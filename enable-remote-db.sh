#!/bin/bash

# --- Database Detection and Configuration Script ---

# Default mode is 'open' for backward compatibility
MODE="${1:-open}"

# Function to configure PostgreSQL
configure_postgresql() {
    echo "Configuring PostgreSQL..."
    PG_CONF=$(find /etc/postgresql -name "postgresql.conf" 2>/dev/null | head -n 1)
    PG_HBA=$(find /etc/postgresql -name "pg_hba.conf" 2>/dev/null | head -n 1)

    if [ -f "$PG_CONF" ] && [ -f "$PG_HBA" ]; then
        if [ "$MODE" = "private" ]; then
            # Restrict to localhost only
            sed -i "s/listen_addresses = '\*'/listen_addresses = 'localhost'/" "$PG_CONF"
            sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/" "$PG_CONF"
            
            # Remove wide-open access rules and ensure localhost access
            sed -i '/0\.0\.0\.0\/0/d' "$PG_HBA"
            if ! grep -q "host.*all.*all.*127.0.0.1/32.*md5" "$PG_HBA"; then
                echo "host    all             all             127.0.0.1/32            md5" >> "$PG_HBA"
            fi
            if ! grep -q "host.*all.*all.*::1/128.*md5" "$PG_HBA"; then
                echo "host    all             all             ::1/128                 md5" >> "$PG_HBA"
            fi
            
            systemctl restart postgresql
            echo "✓ PostgreSQL secured to localhost-only access."
        else
            # Allow connections from any IP address
            sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"
            sed -i "s/listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

            # Allow all connections
            if ! grep -q "host.*all.*all.*0.0.0.0/0.*md5" "$PG_HBA"; then
                echo "host    all             all             0.0.0.0/0               md5" >> "$PG_HBA"
            fi

            systemctl restart postgresql
            echo "✓ PostgreSQL configured for remote access."
        fi
    else
        echo "✗ PostgreSQL configuration files not found."
    fi
}

# Function to configure MongoDB
configure_mongodb() {
    echo "Configuring MongoDB..."
    MONGO_CONF="/etc/mongod.conf"

    if [ -f "$MONGO_CONF" ]; then
        if [ "$MODE" = "private" ]; then
            # Restrict to localhost only
            sed -i "s/bindIp: 0.0.0.0/bindIp: 127.0.0.1/" "$MONGO_CONF"
            sed -i "s/bindIp:.*/bindIp: 127.0.0.1/" "$MONGO_CONF"
            
            systemctl restart mongod
            echo "✓ MongoDB secured to localhost-only access."
        else
            # Allow connections from any IP address
            sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" "$MONGO_CONF"

            systemctl restart mongod
            echo "✓ MongoDB configured for remote access."
        fi
    else
        echo "✗ MongoDB configuration file not found."
    fi
}

# Function to configure MySQL/MariaDB
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
        if [ "$MODE" = "private" ]; then
            # Restrict to localhost only
            sed -i "s/bind-address\s*=\s*0.0.0.0/bind-address = 127.0.0.1/" "$CONF_FILE"
            sed -i "s/bind-address\s*=.*/bind-address = 127.0.0.1/" "$CONF_FILE"
            
            if systemctl is-active --quiet mariadb; then
                systemctl restart mariadb
            else
                systemctl restart mysql
            fi
            echo "✓ MySQL/MariaDB secured to localhost-only access."
        else
            # Allow connections from any IP address
            sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" "$CONF_FILE"

            if systemctl is-active --quiet mariadb; then
                systemctl restart mariadb
            else
                systemctl restart mysql
            fi
            echo "✓ MySQL/MariaDB configured for remote access."
        fi
    else
        echo "✗ MySQL/MariaDB configuration file not found."
    fi
}

# --- Main Script Execution ---

echo "========================================="
if [ "$MODE" = "private" ]; then
    echo "   DATABASE SECURITY MODE: PRIVATE"
    echo "   Securing all databases to localhost"
else
    echo "   DATABASE SECURITY MODE: OPEN"
    echo "   Opening databases for remote access"
fi
echo "========================================="
echo ""

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

echo ""
echo "========================================="
echo "   Configuration complete!"
echo "========================================="