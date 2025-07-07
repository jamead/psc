#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <arpa/inet.h>
#include <unistd.h>

#define MAX_PAIRS 10
#define PACKET_MAX_SIZE 1024

typedef struct {
    uint16_t address;
    float setpoint;
} FastSetpoint;

int send_fast_udp_packet(const char *ip, int port, uint16_t protocol_id, uint16_t command,
                         uint64_t nonce, FastSetpoint *pairs, int pair_count) {
    int sockfd;
    struct sockaddr_in server_addr;
    uint8_t buffer[PACKET_MAX_SIZE];
    int offset = 0;

    if (pair_count > MAX_PAIRS) {
        fprintf(stderr, "Too many address/setpoint pairs.\n");
        return -1;
    }

    // Add protocol ID (2 bytes, big endian)
    buffer[offset++] = (protocol_id >> 8) & 0xFF;
    buffer[offset++] = protocol_id & 0xFF;

    // Add command (2 bytes, big endian)
    buffer[offset++] = (command >> 8) & 0xFF;
    buffer[offset++] = command & 0xFF;

    // Add 8-byte nonce (big endian)
    for (int i = 7; i >= 0; --i) {
        buffer[offset++] = (nonce >> (i * 8)) & 0xFF;
    }

    // Add each address/setpoint pair
    for (int i = 0; i < pair_count; ++i) {
        // Address (2 bytes, big endian)
        buffer[offset++] = (pairs[i].address >> 8) & 0xFF;
        buffer[offset++] = pairs[i].address & 0xFF;

        // Setpoint (4 bytes, IEEE-754 float)
        union {
            float f;
            uint8_t bytes[4];
        } float_conv;
        float_conv.f = pairs[i].setpoint;

        // Add float in big-endian
        buffer[offset++] = float_conv.bytes[3];
        buffer[offset++] = float_conv.bytes[2];
        buffer[offset++] = float_conv.bytes[1];
        buffer[offset++] = float_conv.bytes[0];
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

    uint16_t protocol_id = 0x7631;
    uint16_t command = 0x0010;
    uint64_t nonce = 0x00000000BA5EBA11ULL;

    FastSetpoint pairs[] = {
        { .address = 0x0, .setpoint = 1.23451f },
        { .address = 0x1, .setpoint = 5.67892f },
        { .address = 0x2, .setpoint = 7.234567f },
        { .address = 0x3, .setpoint = 8.678912f },    
    };

    int pair_count = sizeof(pairs) / sizeof(pairs[0]);

    if (send_fast_udp_packet(target_ip, target_port, protocol_id, command, nonce, pairs, pair_count) == 0) {
        printf("UDP packet sent successfully.\n");
    } else {
        printf("Failed to send UDP packet.\n");
    }

    return 0;
}

