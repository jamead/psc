#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <unistd.h>

#define MAX_PAIRS 10
#define PACKET_MAX_SIZE 1024

typedef struct {
    uint8_t address;
    uint16_t setpoint;
} FastSetpoint;

int send_fast_udp_packet(const char *ip, int port, uint8_t protocol_id, uint8_t command,
                         uint16_t nonce, FastSetpoint *pairs, int pair_count) {
    int sockfd;
    struct sockaddr_in server_addr;
    uint8_t buffer[PACKET_MAX_SIZE];
    int offset = 0;

    if (pair_count > MAX_PAIRS) {
        fprintf(stderr, "Too many address/setpoint pairs.\n");
        return -1;
    }

    // Build packet
    buffer[offset++] = protocol_id;
    buffer[offset++] = command;
    buffer[offset++] = (nonce >> 8) & 0xFF;
    buffer[offset++] = nonce & 0xFF;

    for (int i = 0; i < pair_count; ++i) {
        buffer[offset++] = pairs[i].address;
        buffer[offset++] = (pairs[i].setpoint >> 8) & 0xFF;  // MSB
        buffer[offset++] = pairs[i].setpoint & 0xFF;         // LSB
    }

    // Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        return -1;
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    inet_pton(AF_INET, ip, &server_addr.sin_addr);

    // Send UDP packet
    int sent = sendto(sockfd, buffer, offset, 0,
                      (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (sent != offset) {
        perror("sendto failed");
        close(sockfd);
        return -1;
    }

    close(sockfd);
    return 0;
}

int main() {
    const char *target_ip = "10.0.142.100";
    int target_port = 12345;

    uint8_t protocol_id = 0x01;
    uint8_t command = 0x10;
    uint16_t nonce = 0xABCD;

    FastSetpoint pairs[] = {
        { .address = 0x01, .setpoint = 0x1234 },
        { .address = 0x02, .setpoint = 0x5678 }
    };

    int pair_count = sizeof(pairs) / sizeof(pairs[0]);

    if (send_fast_udp_packet(target_ip, target_port, protocol_id, command, nonce, pairs, pair_count) == 0) {
        printf("UDP packet sent successfully.\n");
    } else {
        printf("Failed to send UDP packet.\n");
    }

    return 0;
}
