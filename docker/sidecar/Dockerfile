# SPDX-FileCopyrightText: 2026 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: AGPL-3.0-only

# psql + openssl are needed by the bootstrap/setup scripts. The carbonio-sidecar
# base is ubuntu jammy; installing postgresql-client/openssl with apt in the
# final stage runs target-arch maintainer scripts (no QEMU => exec format error
# on arm64).
#
# Instead, cross-download the target-arch .debs on the BUILDPLATFORM (amd64 CI
# builder) from ports.ubuntu.com, extract them with dpkg -x (no maintainer
# scripts execute), and assemble a minimal tree of just the binaries + the libs
# the base does NOT already provide. libssl/libcrypto/libgssapi/libgnutls/
# libtinfo are already in the base, so we ship only: libpq, libldap-2.5,
# liblber-2.5, libsasl2, libreadline. Everything goes under /usr/lib (not /lib):
# ubuntu jammy is usrmerged so /lib is a symlink to /usr/lib, and COPYing into
# /lib/* fails on some buildkit versions ("cannot copy to non-directory").
FROM --platform=$BUILDPLATFORM ubuntu:noble AS pgclient
ARG TARGETARCH
RUN set -eux; \
    case "$TARGETARCH" in \
      arm64) TRIPLET=aarch64-linux-gnu ;; \
      amd64) TRIPLET=x86_64-linux-gnu ;; \
      *) echo "unsupported TARGETARCH=$TARGETARCH" >&2; exit 1 ;; \
    esac; \
    dpkg --add-architecture "${TARGETARCH}"; \
    if [ "$TARGETARCH" != "amd64" ]; then \
      sed -i 's|http://archive.ubuntu.com/ubuntu/|[arch=amd64] http://archive.ubuntu.com/ubuntu/|; s|http://security.ubuntu.com/ubuntu/|[arch=amd64] http://security.ubuntu.com/ubuntu/|' /etc/apt/sources.list; \
      printf 'deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ jammy main universe\ndeb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ jammy-updates main universe\ndeb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ jammy-security main universe\n' > /etc/apt/sources.list.d/arm64.list; \
    fi; \
    apt-get update; \
    mkdir -p /dl /x /out/usr/bin "/out/usr/lib/${TRIPLET}"; \
    apt-get install -y --download-only -o Dir::Cache::archives=/dl \
      postgresql-client-14:${TARGETARCH} libpq5:${TARGETARCH} openssl:${TARGETARCH}; \
    for d in /dl/*.deb; do dpkg -x "$d" /x; done; \
    cp -a /x/usr/lib/postgresql/14/bin/psql        /out/usr/bin/psql; \
    cp -a /x/usr/lib/postgresql/14/bin/pg_isready   /out/usr/bin/pg_isready; \
    cp -a /x/usr/bin/openssl                        /out/usr/bin/openssl; \
    cp -a /x/usr/lib/${TRIPLET}/libpq.so.*          "/out/usr/lib/${TRIPLET}/"; \
    cp -a /x/usr/lib/${TRIPLET}/libldap-2.5.so.*    "/out/usr/lib/${TRIPLET}/"; \
    cp -a /x/usr/lib/${TRIPLET}/liblber-2.5.so.*    "/out/usr/lib/${TRIPLET}/"; \
    cp -a /x/usr/lib/${TRIPLET}/libsasl2.so.*       "/out/usr/lib/${TRIPLET}/"; \
    cp -a /x/lib/${TRIPLET}/libreadline.so.*        "/out/usr/lib/${TRIPLET}/"

FROM registry.dev.zextras.com/dev/carbonio-sidecar:devel

# psql + pg_isready + openssl + their not-already-present shared libs
# (arch-matched, cross-downloaded above). No target-arch RUN => QEMU-free.
COPY --from=pgclient /out /

# Service registration
COPY package/carbonio-ws-collaboration-db.hcl /consul/config/

# Setup files at the path the setup script expects
COPY package/service-protocol.json /etc/carbonio/ws-collaboration-db/service-discover/
COPY package/intentions.json       /etc/carbonio/ws-collaboration-db/service-discover/
COPY package/policies.json         /etc/carbonio/ws-collaboration-db/service-discover/

# Setup script (COPY --chmod avoids a target-arch RUN — QEMU-free)
COPY --chmod=755 package/carbonio-ws-collaboration-db /usr/local/bin/carbonio-ws-collaboration-db

# Bootstrap script (creates DB user, database, saves credentials to consul KV)
COPY --chmod=755 package/carbonio-ws-collaboration-db-bootstrap /usr/local/bin/carbonio-ws-collaboration-db-bootstrap

# Entrypoint script (COPY --chmod avoids a target-arch RUN — QEMU-free)
COPY --chmod=755 docker/sidecar/entrypoint.sh /usr/local/bin/entrypoint.sh

ENV SERVICE_NAME=carbonio-ws-collaboration-db
ENV PGPASSWORD=admin
ENV POSTGRES_USER=admin
ENV POSTGRES_HOST=localhost
ENV POSTGRES_PORT=5432

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
