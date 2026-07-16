#!/bin/sh
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- telegraf "$@"
fi

if [ "$(id -u)" -ne 0 ]; then
    exec "$@"
else
    # Allow telegraf to send ICMP packets and bind to privliged ports
    setcap cap_net_raw,cap_net_bind_service+ep /usr/bin/telegraf || echo "Failed to set additional capabilities on /usr/bin/telegraf"

    # ensure HOME is set to the telegraf user's home dir
    export HOME=$(getent passwd telegraf | cut -d : -f 6)

    # start from the telegraf user's own groups so memberships baked into
    # /etc/group are kept (as su-exec's initgroups did), then honor groups
    # supplied via 'docker run --group-add ...' but drop 'root' and anything
    # already present
    # see https://github.com/influxdata/influxdata-docker/issues/724
    groups="$(id -Gn telegraf | tr ' ' ',')"
    extra_groups="$(id -Gn || true)"
    for group in $extra_groups; do
        case ",${groups},root," in
            *",${group},"*) ;;
            *) groups="${groups},${group}" ;;
        esac
    done
    exec setpriv --reuid telegraf --regid telegraf --groups "$groups" "$@"
fi
