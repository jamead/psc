/* SD card handling...
 *
 * - Ignore "BOOT.BIN".
 * - Read "NET.CNF" if present
 * - Read and delete "EEPROM.NEW" if present
 * - Write "EEPROM.DAT" if present with zero size
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include <FreeRTOS.h>
#include <lwip/def.h>
#include <lwip/inet.h>
#include <ff.h>

#include "local.h"
#include "pl_regs.h"



static
int MUST_(FRESULT res, unsigned lno, const char* cmd)
{
    if(res==FR_OK)
        return 0;

    fprintf(stderr, "sdcard.c:%u %s error %d\n",
            lno, cmd, res);
    return 1;
}
#define MUST(CMD) MUST_(CMD, __LINE__, #CMD)

static
void sdcard_parse_inet(const char *cmd, const char *arg, ip_addr_t *out)
{
    if(!arg) {
        fprintf(stderr, "Warning: %s without addr\n", cmd);
    } else if(!inet_aton(arg, out)) {
        fprintf(stderr, "Warning: invalid addr: %s %s\n", cmd, arg);
    }
}

static
int parse_hex(char in, unsigned char* out)
{
    switch(in) {
    case '0' ... '9':
        out[0] |= in - '0';
        return 0;
    case 'A' ... 'F':
        out[0] |= in - 'A' + 10;
        return 0;
    case 'a' ... 'f':
        out[0] |= in - 'a' + 10;
        return 0;
    default:
        return 1;
    }
}




static
void sdcard_netconf(net_config *conf, FIL *fd)
{
    char lbuf[64];
    char *line;

    printf("Parse NET.CNF\n");

    while((line = f_gets(lbuf, sizeof(lbuf), fd))) {
        /* lines like:
         *   dhcp no
         *   addr 1.2.2.4
         *   mask 255.255.255.0
         *   gw 1.2.2.1
         */
        while(lwip_isspace(line[0])) line++; // skip leading space
        if(!line[0] || line[0]=='#')
            continue;

        char * const cmd = line;
        char *arg = NULL;

        while(line[0] && !lwip_isspace(line[0])) line++; // find space/nil after cmd
        char * const cmdend = line; // points to space or nil

        while(lwip_isspace(line[0])) line++; // maybe skip space between cmd and arg
        cmdend[0] = '\0'; // chop out cmd

        if(line[0]) { // arg present
            arg = line;
            while(line[0] && !lwip_isspace(line[0])) line++; // find space/nil after arg
            line[0] = '\0'; // chop out arg
        }
        if(strcmp(cmd, "dhcp")==0) {
            if(!arg || strcmp(arg, "yes")==0) {
                printf("DHCP = yes\r\n");
                conf->use_static = 0;
            } else if(strcmp(arg, "no")==0) {
                conf->use_static = 1;
            } else {
                fprintf(stderr, "Warning: unknown: %s %s\n", cmd, arg ? arg : "");
            }

        }  else if(strcmp(cmd, "addr")==0) {
            sdcard_parse_inet(cmd, arg, &conf->addr);
            conf->use_static = 1; // implied...

        } else if(strcmp(cmd, "mask")==0) {
            sdcard_parse_inet(cmd, arg, &conf->mask);

        } else if(strcmp(cmd, "gw")==0) {
            sdcard_parse_inet(cmd, arg, &conf->gw);

        } else if(strcmp(cmd, "hwaddr")==0) {
            uint8_t hwaddr[NETIF_MAX_HWADDR_LEN] = {};
            // expect arg: XX:XX:XX:XX:XX:XX
            printf("cmd=hwaddr  Arg= %s\n", arg);
            if (!arg || strcmp(arg, "eeprom")==0) {
        		printf("Getting HW addr from EEPROM\n");
        		i2c_get_mac_address(conf->hwaddr);
            } else {
                for(unsigned n=0; n<NETIF_MAX_HWADDR_LEN; n++) {
                    const char *part = &arg[n*3];
                    if(parse_hex(part[0], &hwaddr[n])) {
                        fprintf(stderr, "Warning: truncated hwaddr %s\n", arg);
                        break;
                    }
                    hwaddr[n] <<= 4;
                    if(parse_hex(part[1], &hwaddr[n])) {
                        fprintf(stderr, "Warning: truncated hwaddr %s\n", arg);
                        break;
                    }
                    if(n<NETIF_MAX_HWADDR_LEN-1 && part[2]==':') {
                        continue;
                    } else if(n==NETIF_MAX_HWADDR_LEN-1 && !part[2]) {
                        memcpy(conf->hwaddr, hwaddr, sizeof(hwaddr));
                        break;
                    } else {
                        fprintf(stderr, "Warning: invalid hwaddr %s\n", arg);
                        break;
                    }
                }
            }
        } else {
            fprintf(stderr, "Warning: unknown cmd %s\n", cmd);
        }
    }
    if(f_error(fd)) {
        fprintf(stderr, "Error while reading NET.CNF");
    }
}

// sync between file and eeprom.
// eewrite flag indicates direction of write:
//   0:  FILE <--  EEPROM
//   1:  FILE  --> EEPROM
static
void sdcard_sync_eeprom(FIL *fd, int eewrite)
{
    uint8_t *ee = malloc(EE_SIZE);
    uint8_t *file = malloc(EE_SIZE);
    //if(!ee || !file || ee_read(0, ee, EE_SIZE))
    //    goto done;

    UINT n = 0;
    if(MUST(f_read(fd, file, EE_SIZE, &n))) {
        goto done;
    }

    // compare file contents with eeprom contents
    unsigned match = n==EE_SIZE;
    for(unsigned i=0; i<EE_SIZE && match; i++) {
        match = ee[i]==file[i];
    }

    if(match) { // nothing to do...
        printf("EEPROM.DAT up to date\n");

    } else if(eewrite) {
        if(n!=EE_SIZE) {
            fprintf(stderr, "Error EEPROM.NEW size must be %u bytes\n", EE_SIZE);

        //} else if(ee_write(0, file, n)) {
        //    fprintf(stderr, "Error Unable to write EEPROM\n");

        } else {
            printf("Wrote EEPROM\n");
        }

    } else {
        UINT w = 0;
        if(MUST(f_lseek(fd, 0)
            || MUST(f_truncate(fd)
            || MUST(f_write(fd, ee, EE_SIZE, &w))
            || w!=EE_SIZE
            || MUST(f_sync(fd)))))
        {
            fprintf(stderr, "Error updating EEPROM.DAT\n");
        } else {
            printf("EEPROM.DAT updated\n");
        }
    }

done:
    free(ee);
    free(file);
}

static
void sdcard_process(net_config *conf)
{
    FIL fd;
    FRESULT ret;

    if(FR_OK!=(ret=f_open(&fd, "NET.CNF", FA_OPEN_EXISTING | FA_READ))) {
        fprintf(stderr, "Error %d opening NET.CNF\n", ret);
    } else {
        sdcard_netconf(conf, &fd);

        (void)MUST(f_close(&fd));
    }

    if(FR_OK!=(ret=f_open(&fd, "EEPROM.NEW", FA_OPEN_EXISTING | FA_READ))) {
        if(ret!=FR_NO_FILE)
            fprintf(stderr, "Error %d opening EEPROM.NEW\n", ret);
    } else {
        sdcard_sync_eeprom(&fd, 1);

        (void)MUST(f_close(&fd));

        // erase after update...
        (void)MUST(f_unlink("EEPROM.NEW"));
    }

    if(FR_OK!=(ret=f_open(&fd, "EEPROM.DAT", FA_OPEN_ALWAYS | FA_READ | FA_WRITE))) {
        fprintf(stderr, "Error %d opening EEPROM.DAT\n", ret);
    } else {
        sdcard_sync_eeprom(&fd, 0);

        (void)MUST(f_close(&fd));
    }
}

static
int sdcard_trypart(net_config *conf, const char *root)
{
    int ret = 1;
    static FATFS fs;

    if(MUST(f_mount(&fs, root, 1)))
        return 1;

    if(MUST(f_chdir(root)))
        goto unmount;

    printf("Mounted SDCARD at %s\n", root);

    ret = 0;
    sdcard_process(conf);

unmount:
    if(ret)
        (void)MUST(f_unmount(root)); // leave mounted on success
    return ret;
}

void sdcard_handle(net_config *conf)
{
    if(sdcard_trypart(conf, "0:/") && sdcard_trypart(conf, "1:/"))
        fprintf(stderr, "ERROR reading any sdcard\n");
}
