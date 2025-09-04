---

# DB Remote Enabler

A one-run Ubuntu script that auto-detects and configures PostgreSQL, MongoDB, and MySQL/MariaDB for unrestricted remote access. It binds databases to `0.0.0.0` to instantly allow connections from any IP address.

---

> **⚠️ Security Warning: For Development Use Only**
>
> This script is designed for **isolated, controlled development environments** only. It intentionally disables critical security features by opening your databases to any connection from any IP address.
>
> **Do NOT run this on a production server or any machine exposed to the public internet.** You will create a major security vulnerability.

## Overview

`db-remote-enabler` is a "fire-and-forget" utility script created for developers who need to quickly configure local or sandboxed databases for remote access from other machines on their network (e.g., a GUI client on their host machine connecting to a database inside a VM).

The script automates the tedious process of locating configuration files and modifying network binding settings for multiple database systems.

## Features

-   **All-in-One:** A single script handles multiple database systems.
-   **Auto-Detection:** Automatically checks if PostgreSQL, MongoDB, or MySQL/MariaDB are installed before attempting to configure them.
-   **Fully Automated:** No manual input required. Just run the script, and it will handle the rest.
-   **Idempotent-Friendly:** The `sed` commands are written to avoid adding duplicate lines on re-runs.

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

You can run the script with a single command. Open your terminal and execute the following:

```bash
curl -L https://raw.githubusercontent.com/AmirHosseinMoloudi/db-remote-enabler/main/enable-remote-db.sh | sudo bash
```

Alternatively, you can clone the repository and run the script manually:

```bash
# 1. Clone the repository
git clone https://github.com/AmirHosseinMoloudi/db-remote-enabler.git

# 2. Navigate to the directory
cd db-remote-enabler

# 3. Make the script executable
chmod +x enable-remote-db.sh

# 4. Run the script with sudo
sudo ./enable-remote-db.sh
```

The script will automatically restart the database services to apply the changes.

## Disclaimer

The author of this script is not responsible for any security breaches, data loss, or other damages that may result from its use. By running this script, you acknowledge that you understand the security implications and assume all associated risks.

## License

This project is licensed under the [MIT License](LICENSE).