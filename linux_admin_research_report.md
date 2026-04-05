# Linux System Administration Research Report

**Date:** 2026-02-27
**Role:** Researcher
**Subject:** Comprehensive Guide to Linux System Administration

## 1. Introduction
This report synthesizes key practices for managing Linux servers, focusing on modern distributions (e.g., Ubuntu, Debian, CentOS/RHEL). It covers essential command-line operations, user and file management, networking, services, and security hardening.

## 2. Basic Commands (The Essentials)
Proficiency in the terminal is the foundation of Linux administration.

*   **Navigation & File Management**:
    *   `ls -lah`: List files with details (permissions, size, hidden files).
    *   `cd`, `pwd`: Change directory, print working directory.
    *   `cp -r`, `mv`, `rm -rf`: Copy (recursive), move/rename, remove (recursive/force).
    *   `mkdir -p`: Create directory trees.
    *   `touch`: Create empty files or update timestamps.
    *   `find /path -name "pattern"`: Search for files.
    *   `grep -r "text" /path`: Search for text within files.

*   **System Information**:
    *   `top` / `htop`: Real-time process monitoring.
    *   `uname -a`: Kernel and system information.
    *   `uptime`: System load and runtime.
    *   `free -h`: Memory usage.
    *   `df -h`: Disk space usage.
    *   `du -sh *`: Directory size summary.

*   **View & Edit**:
    *   `cat`, `less`, `head`, `tail -f`: View file contents (tail follows log updates).
    *   `nano`, `vim`: Text editors.

## 3. User Management
Managing access and privileges securely.

*   **User Operations**:
    *   `useradd -m -s /bin/bash username`: Create a user with home dir and shell.
    *   `passwd username`: Set/change password.
    *   `usermod -aG groupname username`: Add user to a group (e.g., `sudo`, `docker`).
    *   `deluser --remove-home username`: Delete user and home directory.

*   **Groups & Permissions**:
    *   `groupadd`, `groupdel`: Manage groups.
    *   `chown user:group file`: Change file ownership.
    *   `chmod 755 file`: Change file permissions (rwx for owner, rx for others).
    *   `visudo`: Safely edit `/etc/sudoers` to grant sudo privileges.

## 4. File Systems
Understanding storage and structure.

*   **Filesystem Hierarchy Standard (FHS)**:
    *   `/etc`: Configuration files.
    *   `/var`: Variable data (logs, www, spool).
    *   `/home`: User directories.
    *   `/bin`, `/usr/bin`: Executable binaries.
    *   `/tmp`: Temporary files (cleared on reboot).

*   **Disk Management**:
    *   `mount /dev/sdX /mnt`: Mount a partition.
    *   `/etc/fstab`: Configuration for persistent mounts on boot.
    *   `lsblk`: List block devices (disks/partitions).
    *   `mkfs.ext4 /dev/sdX`: Format a partition.

## 5. Network Configuration
Modern Linux uses `iproute2` tools over the deprecated `net-tools` (ifconfig).

*   **Status & Config**:
    *   `ip addr`: Show IP addresses.
    *   `ip route`: Show routing table.
    *   `ip link set dev eth0 up/down`: Enable/disable interface.
    *   `ss -tuln`: List listening ports (TCP/UDP).
    *   `ping`, `curl`, `wget`: Connectivity testing.

*   **DNS & Hostname**:
    *   `/etc/hosts`: Local hostname mapping.
    *   `/etc/resolv.conf`: DNS server configuration (often managed by systemd-resolved).
    *   `hostnamectl`: Set system hostname.

## 6. Service Management (Systemd)
Systemd is the init system for most modern distros.

*   **Control**:
    *   `systemctl start/stop/restart service_name`: Control service state.
    *   `systemctl enable/disable service_name`: Enable/disable start on boot.
    *   `systemctl status service_name`: Check service health.
    *   `systemctl list-units --type=service`: List all active services.

*   **Logs (Journald)**:
    *   `journalctl -u service_name`: View logs for a specific service.
    *   `journalctl -xe`: View error logs / recent system messages.
    *   `journalctl -f`: Follow logs in real-time.

## 7. Security Best Practices
Hardening the server against attacks.

1.  **SSH Hardening (`/etc/ssh/sshd_config`)**:
    *   Disable root login: `PermitRootLogin no`.
    *   Use key-based auth: `PasswordAuthentication no`.
    *   Change default port (optional but reduces noise): `Port 2222`.

2.  **Firewall (UFW / FirewallD / IPTables)**:
    *   **UFW (Uncomplicated Firewall)**:
        *   `ufw allow ssh` (or custom port).
        *   `ufw allow http/https`.
        *   `ufw enable`.
    *   Deny all incoming by default.

3.  **Updates & Patching**:
    *   `apt update && apt upgrade` (Debian/Ubuntu).
    *   `dnf update` (RHEL/CentOS).
    *   Configure automatic security updates (e.g., `unattended-upgrades`).

4.  **Least Privilege**:
    *   Run services as dedicated users, not root.
    *   Use `sudo` for administrative tasks.

5.  **Monitoring & Logs**:
    *   Install `fail2ban` to block IPs with too many failed login attempts.
    *   Regularly check `/var/log/auth.log` and `/var/log/syslog`.

## 8. Conclusion
Effective Linux administration requires a balance of operational knowledge (commands, services) and security hygiene. Regular updates, strict access control, and monitoring are critical for maintaining a stable and secure environment.
