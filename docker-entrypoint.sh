#!/bin/bash
set -e

# 等待 PostgreSQL 可用
echo "Checking PostgreSQL connection..."
until pg_isready -h "$POSTGRES_HOST" -U "$POSTGRES_USER"; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

# 等待 MySQL 可用
echo "Checking MySQL connection..."
until mysqladmin ping -h "$MYSQL_HOST" -u root -p"$MYSQL_ROOT_PASSWORD" --silent; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

# 创建数据库（如果不存在）并执行迁移
echo "Running database setup..."
bundle exec rails db:create
bundle exec rails db:migrate

# 只在第一次运行时执行 seed
if [ ! -f /tmp/db-seeded ]; then
  echo "Seeding databases..."
  bundle exec rails db:seed
  touch /tmp/db-seeded
fi

exec "$@"
