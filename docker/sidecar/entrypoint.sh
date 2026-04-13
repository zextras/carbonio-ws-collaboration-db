#!/bin/sh
set -e

echo '[sidecar] Waiting for consul agent...'
until consul members >/dev/null 2>&1; do sleep 1; done
echo '[sidecar] Consul agent ready.'

echo '[sidecar] Waiting for postgres...'
until pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" >/dev/null 2>&1; do sleep 1; done
until PGPASSWORD="$PGPASSWORD" psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -w -c 'SELECT 1' >/dev/null 2>&1; do sleep 1; done
echo '[sidecar] Postgres ready.'

consul services register /consul/config/*.hcl

echo '[sidecar] Running setup...'
carbonio-ws-collaboration-db setup || true

echo '[sidecar] Running bootstrap...'
carbonio-ws-collaboration-db-bootstrap "$POSTGRES_USER" "$POSTGRES_HOST" || true

echo "[sidecar] Starting envoy for $SERVICE_NAME"
exec consul connect envoy \
  -sidecar-for="$SERVICE_NAME" \
  -admin-bind=localhost:0