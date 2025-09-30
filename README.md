---

# DB Remote Enabler

A one-run Ubuntu script that auto-detects and configures PostgreSQL, MongoDB, and MySQL/MariaDB with dual-mode operation: **open** for unrestricted remote access or **private** to completely secure all databases to localhost-only access - all with a single command.

---

> **⚠️ Security Warning**
>
> **Open Mode:** Designed for **isolated, controlled development environments** only. It intentionally opens your databases to any connection from any IP address. **Do NOT use open mode on production servers or machines exposed to the public internet.**
>
> **Private Mode:** Secures databases to localhost-only access. Use this mode to lock down databases for production or when remote access is no longer needed.

## Overview

`db-remote-enabler` is a "fire-and-forget" utility script created for developers who need to quickly toggle database network access modes. 

**Open Mode:** Configure databases for remote access from other machines on your network (e.g., a GUI client on your host machine connecting to a database inside a VM).

**Private Mode:** Instantly lock down all databases to localhost-only access for maximum security.

The script automates the tedious process of locating configuration files and modifying network binding settings for multiple database systems with a single command.

## Features

-   **Dual-Mode Operation:** Switch between open (remote access) and private (localhost-only) modes with a single parameter.
-   **All-in-One:** A single script handles multiple database systems simultaneously.
-   **Auto-Detection:** Automatically checks if PostgreSQL, MongoDB, or MySQL/MariaDB are installed before attempting to configure them.
-   **Fully Automated:** No manual input required. Just run the script, and it will handle the rest.
-   **One-Line Security:** Lock down all databases to localhost with a single command - perfect for production environments.
-   **Idempotent-Friendly:** Safe to run multiple times without creating duplicate configurations.

### Supported Databases

-   PostgreSQL
-   MongoDB
-   MySQL
-   MariaDB

## Prerequisites

-   An Ubuntu-based operating system.
-   `sudo` or `root` privileges.
-   One or more of the supported databases installed.

## Usage

### Open Mode (Remote Access)

To enable remote access for all databases (default behavior):

```bash
curl -L https://raw.githubusercontent.com/AmirHosseinMoloudi/db-remote-enabler/main/enable-remote-db.sh | sudo bash
```

### 🔒 Private Mode (Localhost Only) - **NEW!**

To completely secure all databases to localhost-only access with a single command:

```bash
curl -L https://raw.githubusercontent.com/AmirHosseinMoloudi/db-remote-enabler/main/enable-remote-db.sh | sudo bash -s private
```

This will automatically:
- ✓ Restrict PostgreSQL to localhost (127.0.0.1 and ::1)
- ✓ Restrict MongoDB to localhost (127.0.0.1)
- ✓ Restrict MySQL/MariaDB to localhost (127.0.0.1)
- ✓ Remove all wide-open network access rules
- ✓ Restart all services to apply changes instantly

### Manual Installation

Alternatively, you can clone the repository and run the script manually:

```bash
# 1. Clone the repository
git clone https://github.com/AmirHosseinMoloudi/db-remote-enabler.git

# 2. Navigate to the directory
cd db-remote-enabler

# 3. Make the script executable
chmod +x enable-remote-db.sh

# 4. Run the script with sudo
# For remote access:
sudo ./enable-remote-db.sh

# For localhost-only (private mode):
sudo ./enable-remote-db.sh private
```

The script will automatically restart the database services to apply the changes.

## Use Cases

### When to Use Open Mode
- 🔧 **Development Environment:** Need to access databases from GUI tools on your host machine while databases run in a VM
- 🧪 **Testing:** Quick setup for testing applications that need remote database access
- 🌐 **Local Network Access:** Allow other devices on your local network to access databases for development

### When to Use Private Mode
- 🔒 **Secure by Default:** Lock down databases after development/testing is complete
- 🚀 **Production Prep:** Quickly secure all databases before deploying to production
- 🛡️ **Security Hardening:** Revert wide-open access and restrict to localhost only
- 🔄 **Quick Toggle:** Instantly switch from open to secure mode when working in different contexts

## Disclaimer

The author of this script is not responsible for any security breaches, data loss, or other damages that may result from its use. By running this script, you acknowledge that you understand the security implications and assume all associated risks.

## License

This project is licensed under the [MIT License](LICENSE).