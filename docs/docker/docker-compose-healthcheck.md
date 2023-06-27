Собрал несколько настроек для docker-compose, чтобы проверять работоспособность различных баз данных

## MySQL / MariaDB
```yaml
healthcheck:
  test: out=$$(mysqladmin ping -h 127.0.0.1 -P 3306 -u root --password=$$(cat $${MARIADB_ROOT_PASSWORD_FILE}) 2>&1); echo $$out | grep 'mysqld is alive' || { echo $$out; exit 1; }
  interval: 1m
  timeout: 10s
  retries: 5
```
## Redis
```yaml
healthcheck:
  test: [ 'CMD', 'redis-cli', 'ping' ]
  interval: 5m
  timeout: 10s
  retries: 5
```
## PostgreSQL

pg_isready не очень полезно, потому что часто служба может работать, но БД недоступна.
```yaml
healthcheck:
  test: [ "CMD", "psql", "-U", "postgres", "-c", "SELECT 1;" ]
  interval: 1m
  timeout: 10s
  retries: 5
```
## Curl

Ensure you use --fail or your health check will always succeed.
```yaml
healthcheck: 
  test: [ "CMD", "curl", "--fail", "http://localhost" ]
  interval: "60s"
  timeout: "5s"
  retries: 3
```