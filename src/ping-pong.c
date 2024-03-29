#include <stdio.h>
#include <stdlib.h>

#include "discord.h"
#include "log.h"

void print_usage(void) {
    printf("\nThe classic ping pong example\n"
            "1. Type ping in chat for pong\n"
            "2. Type pong in chat for ping\n");
}

void on_ready(struct discord *client, const struct discord_ready *event) {
    // const struct discord_user *bot = discord_get_self(client);

    log_info("bot successfully connected to Discord as %s#%s", 
                            event->user->username, event->user->discriminator);
}

void on_ping(struct discord *client, const struct discord_message *event) {
    if (event->author->bot) return;

    struct discord_create_message param = { .content = "pong" };
    discord_create_message(client, event->channel_id, &param, NULL);
}

void on_pong(struct discord *client, const struct discord_message *event) {
    if (event->author->bot) return;

    struct discord_create_message param = { .content = "ping" };
    discord_create_message(client, event->channel_id, &param, NULL);
}

int main(int argc, char *argv[]) {
    const char *config_file;

    if (argc > 1)
        config_file = argv[1];
    else config_file = "../config.json";

    ccord_global_init();
    struct discord *client = discord_config_init(config_file);

    discord_set_on_ready(client, &on_ready);
    discord_set_on_command(client, "pong", &on_pong);
    discord_set_on_command(client, "ping", &on_ping);

    print_usage();
    fgetc(stdin);

    discord_run(client);

    discord_cleanup(client);
    ccord_global_cleanup();
}
