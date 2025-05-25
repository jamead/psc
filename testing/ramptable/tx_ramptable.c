#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <errno.h>

#define IP_ADDRESS "10.0.142.115"
#define PORT 3000 

char packet[400000];

void create_packet(char *msg, const char *filename) {
    uint32_t *msg_data = (uint32_t *)(msg + 8);
    uint32_t *msg_len = (uint32_t *)(msg + 4);
    uint32_t i = 0;

    memset(msg, 0, 400000);

    msg[0] = 'P';
    msg[1] = 'S';
    msg[2] = 0;
    msg[3] = 1;

    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    int value;
    while (fscanf(file, "%d", &value) == 1 && i < 100000) {
        msg_data[i++] = htonl(value);
    }

    fclose(file);

    msg_len[0] = htonl(i);  // Store the number of lines read
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <data file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    ssize_t bytes_sent = 0;
    size_t packet_size = sizeof(packet);

    create_packet(packet, argv[1]);

    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("Socket creation failed");
        return EXIT_FAILURE;
    }

    struct sockaddr_in server_addr = {0};
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    if (inet_pton(AF_INET, IP_ADDRESS, &server_addr.sin_addr) <= 0) {
        perror("Invalid address/Address not supported");
        close(sock);
        return EXIT_FAILURE;
    }

    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Connection failed");
        close(sock);
        return EXIT_FAILURE;
    }

    while (bytes_sent < packet_size) {
        ssize_t result = send(sock, packet + bytes_sent, packet_size - bytes_sent, 0);
        if (result < 0) {
            perror("Error sending packet");
            break;
        }
        bytes_sent += result;
    }

    printf("Packet sent to %s:%d\n", IP_ADDRESS, PORT);

    close(sock);
    return 0;
}

