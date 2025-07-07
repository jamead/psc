#include <gtk/gtk.h>
#include <stdint.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>

#define MAX_PAIRS 10
#define PACKET_MAX_SIZE 1024

typedef struct {
    uint16_t address;
    float setpoint;
} FastSetpoint;

typedef struct {
    GtkWidget *ip_entry;
    GtkWidget *addr_entry[4];
    GtkWidget *setpt_entry[4];
} AppWidgets;

int send_fast_udp_packet(const char *ip, int port, uint16_t protocol_id, uint16_t command,
                         uint64_t nonce, FastSetpoint *pairs, int pair_count) {
    int sockfd;
    struct sockaddr_in server_addr;
    uint8_t buffer[PACKET_MAX_SIZE];
    int offset = 0;

    if (pair_count > MAX_PAIRS) return -1;

    buffer[offset++] = (protocol_id >> 8) & 0xFF;
    buffer[offset++] = protocol_id & 0xFF;

    buffer[offset++] = (command >> 8) & 0xFF;
    buffer[offset++] = command & 0xFF;

    for (int i = 7; i >= 0; --i) {
        buffer[offset++] = (nonce >> (i * 8)) & 0xFF;
    }

    for (int i = 0; i < pair_count; ++i) {
        buffer[offset++] = (pairs[i].address >> 8) & 0xFF;
        buffer[offset++] = pairs[i].address & 0xFF;

        union { float f; uint8_t b[4]; } conv;
        conv.f = pairs[i].setpoint;

        buffer[offset++] = conv.b[3];
        buffer[offset++] = conv.b[2];
        buffer[offset++] = conv.b[1];
        buffer[offset++] = conv.b[0];
    }

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return -1;

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    inet_pton(AF_INET, ip, &server_addr.sin_addr);

    int sent = sendto(sockfd, buffer, offset, 0,
                      (struct sockaddr *)&server_addr, sizeof(server_addr));
    close(sockfd);
    return sent == offset ? 0 : -1;
}

void on_send_clicked(GtkButton *button, gpointer user_data) {
    AppWidgets *widgets = (AppWidgets *)user_data;

    const char *ip = gtk_entry_get_text(GTK_ENTRY(widgets->ip_entry));
    int port = 12345;
    uint16_t protocol_id = 0x7631;
    uint16_t command = 0x0010;
    uint64_t nonce = 0x00000000BA5EBA11ULL;

    FastSetpoint pairs[4];

    for (int i = 0; i < 4; ++i) {
        const char *addr_text = gtk_entry_get_text(GTK_ENTRY(widgets->addr_entry[i]));
        const char *setpt_text = gtk_entry_get_text(GTK_ENTRY(widgets->setpt_entry[i]));

        pairs[i].address = (uint16_t)strtoul(addr_text, NULL, 0);
        pairs[i].setpoint = strtof(setpt_text, NULL);
    }

    if (send_fast_udp_packet(ip, port, protocol_id, command, nonce, pairs, 4) == 0)
        g_print("UDP packet sent successfully.\n");
    else
        g_print("Failed to send UDP packet.\n");
}

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    AppWidgets *widgets = g_malloc(sizeof(AppWidgets));

    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "FOFB UDP Setpoint Sender");
    gtk_window_set_default_size(GTK_WINDOW(window), 400, 300);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    GtkWidget *grid = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(grid), 5);
    gtk_grid_set_column_spacing(GTK_GRID(grid), 10);
    gtk_container_add(GTK_CONTAINER(window), grid);

    gtk_grid_attach(GTK_GRID(grid), gtk_label_new("Target IP:"), 0, 0, 1, 1);
    widgets->ip_entry = gtk_entry_new();
    gtk_entry_set_text(GTK_ENTRY(widgets->ip_entry), "10.0.142.100");
    gtk_grid_attach(GTK_GRID(grid), widgets->ip_entry, 1, 0, 2, 1);

    for (int i = 0; i < 4; ++i) {
        char label_text[16];
        sprintf(label_text, "Address %d:", i);
        gtk_grid_attach(GTK_GRID(grid), gtk_label_new(label_text), 0, i + 1, 1, 1);
        widgets->addr_entry[i] = gtk_entry_new();
        gtk_entry_set_text(GTK_ENTRY(widgets->addr_entry[i]), "0");
        gtk_grid_attach(GTK_GRID(grid), widgets->addr_entry[i], 1, i + 1, 1, 1);

        gtk_grid_attach(GTK_GRID(grid), gtk_label_new("Setpoint:"), 2, i + 1, 1, 1);
        widgets->setpt_entry[i] = gtk_entry_new();
        gtk_entry_set_text(GTK_ENTRY(widgets->setpt_entry[i]), "0.0");
        gtk_grid_attach(GTK_GRID(grid), widgets->setpt_entry[i], 3, i + 1, 1, 1);
    }

    GtkWidget *send_button = gtk_button_new_with_label("Send Packet");
    g_signal_connect(send_button, "clicked", G_CALLBACK(on_send_clicked), widgets);
    gtk_grid_attach(GTK_GRID(grid), send_button, 0, 6, 4, 1);

    gtk_widget_show_all(window);
    gtk_main();

    g_free(widgets);
    return 0;
}

