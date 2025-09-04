#!/bin/bash

# --- Database Detection and Configuration Script ---

# Function to configure PostgreSQL for remote access
configure_postgresql() {
    echo "Configuring PostgreSQL..."
    PG_CONF=$(find /etc/postgresql -name "postgresql.conf")
    PG_HBA=$(find /etc/postgresql -name "pg_hba.conf")

    if [ -f "$PG_CONF" ] && [ -f "$PG_HBA" ]; then
        # Allow connections from any IP address
        sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"
        sed -i "s/listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

        # Allow all connections
        echo "host    all             all             0.0.0.0/0               md5" >> "$PG_HBA"

        # Restart PostgreSQL
        systemctl restart postgresql
        echo "PostgreSQL configured for remote access."
    else
        echo "PostgreSQL configuration files not found."
    fi
}

# Function to configure MongoDB for remote access
configure_mongodb() {
    echo "Configuring MongoDB..."
    MONGO_CONF="/etc/mongod.conf"

    if [ -f "$MONGO_CONF" ]; then
        # Allow connections from any IP address
        sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" "$MONGO_CONF"

        # Restart MongoDB
        systemctl restart mongod
        echo "MongoDB configured for remote access."
    else
        echo "MongoDB configuration file not found."
    fi
}

# Function to configure MySQL/MariaDB for remote access
configure_mysql() {
    echo "Configuring MySQL/MariaDB..."
    MYSQL_CONF="/etc/mysql/mysql.conf.d/mysqld.cnf"
    MARIADB_CONF="/etc/mysql/mariadb.conf.d/50-server.cnf"

    CONF_FILE=""
    if [ -f "$MYSQL_CONF" ]; then
        CONF_FILE="$MYSQL_CONF"
    elif [ -f "$MARIADB_CONF" ]; then
        CONF_FILE="$MARIADB_CONF"
    fi

    if [ -n "$CONF_FILE" ]; then
        # Allow connections from any IP address
        sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" "$CONF_FILE"

        # Restart MySQL/MariaDB
        if systemctl is-active --quiet mariadb; then
            systemctl restart mariadb
        else
            systemctl restart mysql
        fi
        echo "MySQL/MariaDB configured for remote access."
    else
        echo "MySQL/MariaDB configuration file not found."
    fi
}

# --- Main Script Execution ---

# Detect and configure PostgreSQL
if dpkg -s postgresql >/dev/null 2>&1; then
    configure_postgresql
fi

# Detect and configure MongoDB
if dpkg -s mongodb-org >/dev/null 2>&1 || dpkg -s mongodb >/dev/null 2>&1; then
    configure_mongodb
fi

# Detect and configure MySQL/MariaDB
if dpkg -s mysql-server >/dev/null 2>&1 || dpkg -s mariadb-server >/dev/null 2>&1; then
    configure_mysql
fi

echo "Database configuration script finished."