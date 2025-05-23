FROM buildpack-deps:bookworm-curl

ENV INFLUXDB_VERSION=1.12.0-c1.12.0
RUN curl -fsSLO "https://dl.influxdata.com/enterprise/releases/influxdb-meta_${INFLUXDB_VERSION}-1_amd64.deb.asc" \
         -fssLO "https://dl.influxdata.com/enterprise/releases/influxdb-meta_${INFLUXDB_VERSION}-1_amd64.deb" && \
    # Verify InfluxDB 1.X Enterprise \
    gpg --batch --keyserver hkp://keyserver.ubuntu.com --recv-keys \
        # InfluxData Package Signing Key <support@influxdata.com> \
        9D539D90D3328DC7D6C8D3B9D8FF8E1F7DF8B07E && \
    gpg --batch --verify \
        "influxdb-meta_${INFLUXDB_VERSION}-1_amd64.deb.asc" \
        "influxdb-meta_${INFLUXDB_VERSION}-1_amd64.deb" && \
    # Install InfluxDB 1.X Enterprise \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        "/influxdb-meta_${INFLUXDB_VERSION}-1_amd64.deb" && \
    # Cleanup \
    rm -r "influxdb-meta_${INFLUXDB_VERSION}-1_amd64.deb.asc" \
          "influxdb-meta_${INFLUXDB_VERSION}-1_amd64.deb" \
          /var/lib/apt/lists/*

COPY influxdb-meta.conf /etc/influxdb/influxdb-meta.conf

EXPOSE 8091

VOLUME /var/lib/influxdb

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd-meta"]
