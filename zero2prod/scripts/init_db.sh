#!/bin/bash
#set -x # prints out every line when you run the script!
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
    echo >&2 "Error: psql  is not installed."
    exit 1
fi

if ! [ -x "$(command -v sqlx)" ]; then
    echo >&2 "Error: sqlx is not installed."
    echo >&2 "Use: "
    echo >&2 "      cargo install --version="~0.7" sqlx-cli --no-default-features --features rustls,postgres"
    echo >&2 "to install it."
    exit 1
fi

# Check if a custom user has been set, otherwise default to 'postgres'
DB_USER="${PPOSTGRES_USER:=postgres}"

# Check if a custom password has been set, otherwise default to 'password'
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"

# Check if a custom database name has been set, otherwise default to 'newsletter'
DB_NAME="${POSTGRES_DB:=newsletter}"

# Check if a custom port name has been set, otherwise default to '5432'
DB_PORT="${POSTGRES_PORT:=5432}"

# Check if a custom host name has been set, otherwise default to 'localhost'
DB_HOST="${POSTGRES_HOST:=localhost}"

CONTAINER_NAME="zero2prod"

# Launch postgres using docker
if [ ! "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo "Creating Docker container (name=${CONTAINER_NAME})."
    docker run \
        --name ${CONTAINER_NAME} \
        -e POSTGRES_USER=${DB_USER} \
        -e POSTGRES_PASSWORD=${DB_PASSWORD} \
        -e POSTGRES_DB=${DB_PASSWORD} \
        -p "${DB_PORT}":5432 \
        -d postgres -N 1000 # ^ Increase max number of connections for testing purposes
else
    echo "Docker container already found (name=${CONTAINER_NAME})."
fi

# Keep pinging Postgres until it's readt to accept commands
export "PGPASSWORD=${DB_PASSWORD}" # for windows you need to export "my_stuff_wrapped_in_quotes"
until psql -h "${DB_HOST}" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q' ; do
    echo "Postgres is still unavailable - sleeping"
    sleep 1
done

echo "Postgres is up and running on port ${DB_PORT}!"

DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
export DATABASE_URL
sqlx database create
sqlx migrate run
echo "Postgres has been migrated, ready to go!"