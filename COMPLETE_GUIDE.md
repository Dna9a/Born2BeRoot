# Born2BeRoot Complete Guide - Rocky Linux Edition

## Table of Contents
1. [Introduction](#introduction)
2. [Virtual Machine Setup](#virtual-machine-setup)
3. [Rocky Linux Installation](#rocky-linux-installation)
4. [Partition Configuration](#partition-configuration)
5. [System Configuration](#system-configuration)
6. [User and Group Management](#user-and-group-management)
7. [Sudo Configuration](#sudo-configuration)
8. [SSH Configuration](#ssh-configuration)
9. [Firewalld Setup](#firewalld-setup)
10. [Password Policy](#password-policy)
11. [Monitoring Script](#monitoring-script)
12. [Bonus: WordPress Setup](#bonus-wordpress-setup)
13. [Testing and Verification](#testing-and-verification)
14. [Defense Preparation](#defense-preparation)

---

## Introduction

Born2BeRoot is a system administration project from the 42 School curriculum. The goal is to create a virtual machine running Rocky Linux (or Debian) with strict security configurations and custom monitoring capabilities.

### Project Requirements Overview
- Virtual machine using VirtualBox or UTM
- Latest stable Rocky Linux version (no graphical interface)
- LVM with encrypted partitions
- SSH running on port 4242
- firewalld with only port 4242 open
- Strong password policy
- Configured sudo with strict rules
- Monitoring script displaying system information every 10 minutes

---

## Virtual Machine Setup

### Step 1: Download VirtualBox
1. Go to [VirtualBox Downloads](https://www.virtualbox.org/wiki/Downloads)
2. Download the appropriate version for your operating system
3. Install VirtualBox following the installation wizard

### Step 2: Download Rocky Linux ISO
1. Visit [Rocky Linux Downloads](https://rockylinux.org/download)
2. Download the latest stable **Minimal ISO** (small installation image)
3. Choose the appropriate architecture (usually x86_64 for 64-bit systems)

### Step 3: Create Virtual Machine
1. Open VirtualBox
2. Click **"New"** to create a new virtual machine
3. Configuration:
   - **Name:** Born2BeRoot (or your choice)
   - **Type:** Linux
   - **Version:** Red Hat (64-bit)
   - **Memory:** 2048 MB (2 GB) - minimum recommended for Rocky
   - **Hard disk:** Create a virtual hard disk now
   - **Hard disk file type:** VDI (VirtualBox Disk Image)
   - **Storage:** Dynamically allocated
   - **Size:** 30 GB (minimum for bonus, 8 GB for mandatory)

### Step 4: Configure VM Settings
1. Select your VM and click **"Settings"**
2. **System** → **Motherboard**: Ensure Boot Order has "Hard Disk" first, then "Optical"
3. **Storage** → Click on "Empty" under Controller: IDE
   - Click the disk icon on the right
   - Choose **"Choose a disk file"**
   - Select your downloaded Rocky Linux ISO
4. Click **"OK"** to save settings

---

## Rocky Linux Installation

### Step 1: Start Installation
1. Start your virtual machine
2. Select **"Install Rocky Linux"** (use arrow keys and Enter)

### Step 2: Language and Keyboard
1. **Language:** English (or your preference)
2. Click **"Continue"**

### Step 3: Installation Summary Screen
You'll see multiple configuration options. Configure them in this order:

#### Network & Hostname
1. Click **"Network & Host Name"**
2. Turn on the Ethernet connection (toggle switch to ON)
3. **Hostname:** Use your 42 login + "42" (e.g., `yoabied42`)
4. Click **"Apply"**, then **"Done"**

#### Time & Date
1. Click **"Time & Date"**
2. Select your region and city
3. Click **"Done"**

#### Root Password
1. Click **"Root Password"**
2. Set a strong password (follow password policy)
3. Confirm the password
4. Click **"Done"** (may need to click twice if weak password warning appears)

#### User Creation
1. Click **"User Creation"**
2. **Full name:** Your name
3. **Username:** Your 42 login (e.g., `yoabied`)
4. **Make this user administrator:** CHECK this box
5. Set a strong password
6. Confirm the password
7. Click **"Done"**

---

## Partition Configuration

This is one of the most critical parts of the project. You need to create an encrypted LVM structure.

### Step 1: Installation Destination
1. Click **"Installation Destination"**
2. Select your virtual hard disk
3. **Storage Configuration:** Select **"Custom"**
4. Click **"Done"**

### Step 2: Manual Partitioning Screen
1. You'll see the manual partitioning interface
2. From the dropdown at the bottom, select **"LVM"** as the partitioning scheme
3. Check the **"Encrypt my data"** checkbox
4. Enter and confirm your encryption passphrase (you'll need this at every boot!)
5. Now you'll create individual mount points

### Step 3: Create Boot Partition
1. Click **"+"** to add a new mount point
2. **Mount Point:** /boot
3. **Desired Capacity:** 1 GB (1024 MB)
4. Click **"Add mount point"**
5. On the left side, select the /boot partition you just created
6. On the right side, ensure:
   - **Device Type:** Standard Partition
   - **File System:** xfs
   - **Encrypt:** Should be unchecked (bootloader needs to read this)

### Step 4: Create Root Partition
1. Click **"+"** to add a new mount point
2. **Mount Point:** /
3. **Desired Capacity:** 10 GB (10240 MB)
4. Click **"Add mount point"**
5. The system will automatically place this in an encrypted LVM
6. Verify:
   - **Device Type:** LVM
   - **Volume Group:** rl (Rocky Linux default) or your custom name
   - **File System:** xfs

### Step 5: Create Swap Partition
1. Click **"+"**
2. **Mount Point:** swap
3. **Desired Capacity:** 2.3 GB (2355 MB)
4. Click **"Add mount point"**
5. Verify:
   - **Device Type:** LVM
   - **File System:** swap

### Step 6: Create Home Partition
1. Click **"+"**
2. **Mount Point:** /home
3. **Desired Capacity:** 5 GB (5120 MB)
4. Click **"Add mount point"**
5. Verify: Device Type is LVM, File System is xfs

### Step 7: Create Var Partition
1. Click **"+"**
2. **Mount Point:** /var
3. **Desired Capacity:** 3 GB (3072 MB)
4. Click **"Add mount point"**
5. Verify: Device Type is LVM, File System is xfs

### Step 8: Create Srv Partition
1. Click **"+"**
2. **Mount Point:** /srv
3. **Desired Capacity:** 3 GB (3072 MB)
4. Click **"Add mount point"**
5. Verify: Device Type is LVM, File System is xfs

### Step 9: Create Tmp Partition
1. Click **"+"**
2. **Mount Point:** /tmp
3. **Desired Capacity:** 3 GB (3072 MB)
4. Click **"Add mount point"**
5. Verify: Device Type is LVM, File System is xfs

### Step 10: Create Var-Log Partition
1. Click **"+"**
2. **Mount Point:** /var/log
3. **Desired Capacity:** 4 GB (4096 MB) or leave blank for remaining space
4. Click **"Add mount point"**
5. Verify: Device Type is LVM, File System is xfs

### Step 11: Review and Finalize Partitioning
1. Review all partitions on the left side:
   - /boot (1 GB, Standard Partition, unencrypted)
   - / (10 GB, LVM, encrypted)
   - swap (2.3 GB, LVM, encrypted)
   - /home (5 GB, LVM, encrypted)
   - /var (3 GB, LVM, encrypted)
   - /srv (3 GB, LVM, encrypted)
   - /tmp (3 GB, LVM, encrypted)
   - /var/log (4 GB, LVM, encrypted)
2. Click **"Done"**
3. Review the "Summary of Changes" dialog carefully
4. Click **"Accept Changes"** to apply the partitioning

### Step 12: Software Selection
1. Click **"Software Selection"**
2. **Base Environment:** Select **"Minimal Install"**
3. Do NOT select any add-ons (no GUI)
4. Click **"Done"**

### Step 13: Begin Installation
1. Click **"Begin Installation"**
2. Wait for installation to complete (10-20 minutes)
3. Once complete, click **"Reboot System"**
4. Remove the ISO when prompted

---

## System Configuration

### Step 1: First Boot
```bash
# Enter encryption password at boot prompt
# Login as root or your user
```

### Step 2: Update System
```bash
# Login as root
su -

# Update all packages
dnf update -y

# Install required packages
dnf install -y vim sudo firewalld
```

### Step 3: Check System Information
```bash
# Verify Rocky Linux version
cat /etc/os-release

# Check partitions
lsblk

# Verify LVM
lvdisplay
vgdisplay
```

---

## User and Group Management

### Step 1: Create User Groups
```bash
# Create user42 group
groupadd user42

# Verify group creation
getent group user42
```

### Step 2: Add User to Groups
```bash
# Add your user to wheel (sudo) and user42 groups
usermod -aG wheel,user42 <your_username>

# Verify user groups
groups <your_username>

# Alternative: check with id
id <your_username>
```

### Step 3: Create New User (for evaluation)
```bash
# Create a new user
useradd <new_username>

# Set password
passwd <new_username>

# Add to appropriate groups
usermod -aG user42 <new_username>

# Verify
groups <new_username>
```

### Step 4: Manage Users
```bash
# Delete a user
userdel <username>

# Delete user and home directory
userdel -r <username>

# Change user password
passwd <username>
```

---

## Sudo Configuration

### Step 1: Configure Sudoers
```bash
# Create sudo log directory
mkdir -p /var/log/sudo

# Edit sudoers file
visudo
```

### Step 2: Add Sudo Rules
Add the following configuration to the sudoers file:

```bash
# Default settings for sudo
Defaults        passwd_tries=3
Defaults        badpass_message="Wrong password. Try again!"
Defaults        logfile="/var/log/sudo/sudo.log"
Defaults        log_input
Defaults        log_output
Defaults        iolog_dir="/var/log/sudo"
Defaults        requiretty
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

**Explanation:**
- `passwd_tries=3`: Limit authentication attempts to 3
- `badpass_message`: Custom error message for wrong password
- `logfile`: Log all sudo commands
- `log_input`: Log input for sudo commands (⚠️ Note: logs everything typed, including passwords)
- `log_output`: Log output for sudo commands
- `iolog_dir`: Directory for input/output logs
- `requiretty`: Require a terminal for sudo
- `secure_path`: Secure PATH for sudo commands

### Step 3: Test Sudo Configuration
```bash
# Switch to your user
su - <your_username>

# Test sudo
sudo whoami
# Should output: root

# Check sudo logs
sudo cat /var/log/sudo/sudo.log
```

---

## SSH Configuration

### Step 1: Install and Configure SSH
```bash
# Install OpenSSH server
sudo dnf install -y openssh-server

# Enable SSH service
sudo systemctl enable sshd

# Edit SSH configuration file
sudo vim /etc/ssh/sshd_config
```

### Step 2: Modify SSH Settings
Find and modify these lines:

```bash
# Change SSH port to 4242
Port 4242

# Disable root login
PermitRootLogin no
```

### Step 3: Restart SSH Service
```bash
# Restart SSH
sudo systemctl restart sshd

# Check SSH status
sudo systemctl status sshd

# Verify SSH is listening on port 4242
sudo ss -tunlp | grep 4242
```

### Step 4: Configure VirtualBox Port Forwarding
1. Power off your VM
2. Go to VM Settings → Network → Adapter 1 → Advanced → Port Forwarding
3. Add a new rule:
   - **Name:** SSH
   - **Protocol:** TCP
   - **Host Port:** 4242
   - **Guest Port:** 4242
4. Start your VM

### Step 5: Test SSH Connection
```bash
# From your host machine
ssh <your_username>@localhost -p 4242

# Or if using IP
ssh <your_username>@127.0.0.1 -p 4242
```

---

## Firewalld Setup

### Step 1: Enable Firewalld
```bash
# Start firewalld service
sudo systemctl start firewalld

# Enable firewalld at boot
sudo systemctl enable firewalld

# Check status
sudo systemctl status firewalld
```

### Step 2: Configure Firewall Rules
```bash
# Remove SSH from services (we'll add custom port)
sudo firewall-cmd --permanent --remove-service=ssh

# Add SSH on port 4242
sudo firewall-cmd --permanent --add-port=4242/tcp

# Reload firewall to apply changes
sudo firewall-cmd --reload

# Verify configuration
sudo firewall-cmd --list-all
```

### Step 3: Check Firewall Status
```bash
# Check active zones
sudo firewall-cmd --get-active-zones

# List all rules
sudo firewall-cmd --list-all

# Should show:
# ports: 4242/tcp
```

### Step 4: Manage Firewall Rules
```bash
# Add a port
sudo firewall-cmd --permanent --add-port=<port>/tcp
sudo firewall-cmd --reload

# Remove a port
sudo firewall-cmd --permanent --remove-port=<port>/tcp
sudo firewall-cmd --reload

# Stop firewall
sudo systemctl stop firewalld

# Disable firewall at boot
sudo systemctl disable firewalld
```

---

## Password Policy

### Step 1: Install Password Quality Library
```bash
# Install libpwquality
sudo dnf install -y libpwquality
```

### Step 2: Configure Password Quality Requirements
```bash
# Edit PAM password configuration
sudo vim /etc/pam.d/system-auth
```

### Step 3: Modify Password Quality Settings
Find the line with `pam_pwquality.so` and modify it (or add if it doesn't exist):

```bash
password    requisite     pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 usercheck=1 difok=7 enforce_for_root
```

**Also edit** `/etc/pam.d/password-auth` with the same line.

**Explanation:**
- `retry=3`: Allow 3 password entry attempts
- `minlen=10`: Minimum password length of 10 characters
- `ucredit=-1`: At least 1 uppercase letter required
- `dcredit=-1`: At least 1 digit required
- `maxrepeat=3`: No more than 3 consecutive identical characters
- `usercheck=1`: Password cannot contain username
- `difok=7`: At least 7 characters different from old password
- `enforce_for_root`: Apply rules to root user as well

### Step 4: Configure Password Aging
```bash
# Edit login definitions
sudo vim /etc/login.defs
```

Find and modify these lines:

```bash
PASS_MAX_DAYS   30
PASS_MIN_DAYS   2
PASS_WARN_AGE   7
```

**Explanation:**
- `PASS_MAX_DAYS`: Password expires after 30 days
- `PASS_MIN_DAYS`: Minimum 2 days before password can be changed again
- `PASS_WARN_AGE`: Warning 7 days before password expires

### Step 5: Apply Password Policy to Existing Users
```bash
# For your user
sudo chage -M 30 -m 2 -W 7 <your_username>

# For root
sudo chage -M 30 -m 2 -W 7 root

# Check password aging information
sudo chage -l <your_username>
```

### Step 6: Change Passwords to Comply
```bash
# Change root password (must follow new policy)
sudo passwd root

# Change user password
sudo passwd <your_username>
```

---

## Monitoring Script

### Step 1: Create Monitoring Script
```bash
# Create the script
sudo vim /usr/local/bin/monitoring.sh
```

### Step 2: Add Script Content
```bash
#!/bin/bash

# System architecture and kernel version
arch=$(uname -a)

# Physical CPUs
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# Virtual CPUs
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM usage
ram_total=$(free -m | awk 'NR==2{printf "%s", $2}')
ram_used=$(free -m | awk 'NR==2{printf "%s", $3}')
ram_percent=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')

# Disk usage
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_used=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

# CPU load
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpu_load)
cpu_fin=$(printf "%.1f" $cpu_op)

# Last boot
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM active
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP connections
tcpc=$(ss -ta | grep ESTAB | wc -l)

# User log
ulog=$(users | wc -w)

# Network
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# Sudo commands (total count - note: this processes entire journal)
# For better performance on systems with large journals, add: --since "1 day ago"
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

# Display information
wall "	#Architecture: $arch
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $ram_used/${ram_total}MB ($ram_percent%)
	#Disk Usage: $disk_used/${disk_total} ($disk_percent%)
	#CPU load: $cpu_fin%
	#Last boot: $lb
	#LVM use: $lvmu
	#Connections TCP: $tcpc ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmnd cmd"
```

### Step 3: Make Script Executable
```bash
# Make the script executable
sudo chmod +x /usr/local/bin/monitoring.sh

# Test the script
sudo /usr/local/bin/monitoring.sh
```

### Step 4: Configure Cron Job
```bash
# Edit root's crontab
sudo crontab -e

# Add the following line to run every 10 minutes
*/10 * * * * /usr/local/bin/monitoring.sh
```

### Step 5: Manage Cron
```bash
# Check if crond is running
sudo systemctl status crond

# Start crond service
sudo systemctl start crond

# Enable crond at boot
sudo systemctl enable crond

# Disable crond at boot (for defense)
sudo systemctl disable crond
```

---

## Bonus: WordPress Setup

### Prerequisites
```bash
# Install required packages
sudo dnf install -y httpd mariadb-server php php-mysqlnd php-fpm wget
```

### Step 1: Configure Apache (httpd)
```bash
# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Allow HTTP port in firewall
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload
```

### Step 2: Configure MariaDB
```bash
# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation

# Answer the prompts:
# - Enter current password: Press Enter (no password yet)
# - Switch to unix_socket authentication: N
# - Change root password: Y (set a strong password)
# - Remove anonymous users: Y
# - Disallow root login remotely: Y
# - Remove test database: Y
# - Reload privilege tables: Y
```

### Step 3: Create WordPress Database
```bash
# Login to MariaDB
sudo mysql -u root -p

# Create database and user
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Step 4: Download and Install WordPress
```bash
# Download WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz

# Move WordPress to web root
sudo mv wordpress /var/www/html/

# Set permissions
sudo chown -R apache:apache /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Configure SELinux contexts
sudo chcon -t httpd_sys_rw_content_t /var/www/html/wordpress -R
sudo setsebool -P httpd_can_network_connect_db 1
```

### Step 5: Configure WordPress
```bash
# Copy sample configuration
cd /var/www/html/wordpress
sudo cp wp-config-sample.php wp-config.php

# Edit configuration
sudo vim wp-config.php

# Update these lines with your database information:
# define('DB_NAME', 'wordpress');
# define('DB_USER', 'wpuser');
# define('DB_PASSWORD', 'strong_password');
# define('DB_HOST', 'localhost');
```

### Step 6: Additional Service Setup (for full bonus)
```bash
# You can choose any service except NGINX or Lighttpd
# Examples: FTP, Redis, Fail2ban, etc.

# Example: Install Fail2ban (intrusion prevention)
sudo dnf install -y epel-release
sudo dnf install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

---

## Testing and Verification

### System Information
```bash
# Check Rocky Linux version
cat /etc/os-release

# Check if desktop environment is installed (should return nothing)
dnf grouplist | grep -i desktop

# Check SELinux is running
sudo sestatus
```

### Partition Verification
```bash
# Check partition structure
lsblk

# Should show encrypted LVM structure with:
# - sda1: /boot
# - sda2: encrypted volume
# - Multiple LV partitions under LVMGroup
```

### User and Group Verification
```bash
# Check if user exists and is in correct groups
groups <your_username>
# Should show: wheel user42

# Check all users
cat /etc/passwd | cut -d: -f1

# Check all groups
cat /etc/group | cut -d: -f1
```

### Sudo Verification
```bash
# Check sudo configuration
sudo cat /etc/sudoers

# Check sudo logs exist
ls -la /var/log/sudo/

# Test sudo command and check log
sudo ls
sudo cat /var/log/sudo/sudo.log
```

### SSH Verification
```bash
# Check SSH is running on port 4242
sudo systemctl status sshd
sudo ss -tunlp | grep 4242

# Check root login is disabled
sudo grep "PermitRootLogin" /etc/ssh/sshd_config
# Should show: PermitRootLogin no
```

### Firewalld Verification
```bash
# Check firewalld status
sudo firewall-cmd --list-all

# Should show only port 4242/tcp
```

### Password Policy Verification
```bash
# Check password quality settings
sudo cat /etc/pam.d/system-auth | grep pam_pwquality

# Check password aging settings
sudo cat /etc/login.defs | grep PASS_

# Check user password aging
sudo chage -l <your_username>
```

### Hostname Verification
```bash
# Check current hostname
hostname

# Change hostname
sudo hostnamectl set-hostname new_hostname

# Edit hosts file
sudo vim /etc/hosts
# Change old hostname to new hostname

# Reboot to apply
sudo reboot
```

---

## Defense Preparation

### Key Commands to Remember

**System Information:**
```bash
uname -a                    # System architecture
cat /etc/os-release        # OS version
lsblk                      # List block devices/partitions
```

**User Management:**
```bash
useradd <username>         # Create new user
userdel <username>         # Delete user
groups <username>          # Check user groups
usermod -aG <group> <user> # Add user to group
getent group <groupname>   # Check group members
```

**Password Management:**
```bash
passwd <username>          # Change user password
chage -l <username>        # Check password aging
chage -M <days> <username> # Set max password age
```

**Sudo:**
```bash
visudo                     # Edit sudoers file safely
sudo -l                    # List user's sudo privileges
```

**SSH:**
```bash
sudo systemctl status sshd # Check SSH status
sudo vim /etc/ssh/sshd_config  # Edit SSH config
sudo systemctl restart sshd # Restart SSH service
```

**Firewalld:**
```bash
sudo firewall-cmd --list-all       # Show firewall rules
sudo firewall-cmd --permanent --add-port=<port>/tcp  # Allow port
sudo firewall-cmd --permanent --remove-port=<port>/tcp  # Remove port
sudo firewall-cmd --reload         # Apply changes
```

**Monitoring Script:**
```bash
sudo crontab -l            # List cron jobs
sudo crontab -e            # Edit cron jobs
sudo systemctl status crond # Check cron status
```

### Questions to Prepare For

1. **What is a virtual machine?**
   - A virtual machine is a software-based emulation of a physical computer that runs an operating system and applications independently.

2. **Why did you choose Rocky Linux?**
   - Rocky Linux is enterprise-grade, community-driven, RHEL-compatible, stable, and has strong support for server environments. It's the successor to CentOS and maintains binary compatibility with RHEL.

3. **Difference between Rocky Linux and Debian?**
   - Rocky: Uses DNF/YUM package manager, .rpm packages, RHEL-based, enterprise-focused
   - Debian: Uses APT package manager, .deb packages, community-driven, larger repository

4. **What is SELinux?**
   - Security-Enhanced Linux is a Linux kernel security module that provides label-based mandatory access control (MAC) mechanisms.

5. **Difference between SELinux and AppArmor?**
   - SELinux: Label-based, more complex, Red Hat default, more granular control
   - AppArmor: Path-based, easier to configure, Debian/Ubuntu default, less granular

6. **What is LVM?**
   - Logical Volume Manager allows flexible disk management, enabling resizing, snapshots, and easier partition management.

7. **What is firewalld?**
   - firewalld is a dynamic firewall management tool with support for network/firewall zones. It's the default on RHEL-based systems.

8. **What is SSH?**
   - Secure Shell - a cryptographic network protocol for secure remote login and command execution.

9. **What is sudo?**
   - "Superuser do" - a program that allows users to run commands with root privileges in a controlled manner.

10. **What is the purpose of the monitoring script?**
    - To display real-time system information including CPU, RAM, disk usage, network status, and active connections.

### Defense Checklist

- [ ] Be able to explain every choice you made
- [ ] Know how to create/delete users
- [ ] Know how to add/remove users from groups
- [ ] Be able to modify hostname
- [ ] Understand partition structure (explain LVM)
- [ ] Know how to modify sudo timeout
- [ ] Explain password policy rules
- [ ] Show sudo logs
- [ ] Demonstrate firewalld rule management
- [ ] Explain monitoring script line by line
- [ ] Be able to modify cron schedule
- [ ] Know how to stop/start services

---

## Additional Tips

### Snapshot Your VM
- Create snapshots at important milestones
- Useful for recovery if something breaks
- VirtualBox: Machine → Take Snapshot

### Backup Configuration Files
```bash
# Before editing important files, create backups
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sudo cp /etc/sudoers /etc/sudoers.backup
```

### Common Issues and Solutions

**Issue: Can't sudo after configuration**
- Boot into rescue mode
- Remount root as read-write: `mount -o remount,rw /`
- Fix sudoers: `visudo`

**Issue: SSH connection refused**
- Check if SSH is running: `sudo systemctl status sshd`
- Check port forwarding in VirtualBox settings
- Verify firewall: `sudo firewall-cmd --list-all`

**Issue: Forgot encryption password**
- Unfortunately, there's no recovery without the password
- You'll need to restart the installation

**Issue: Monitoring script not working**
- Check script permissions: `ls -l /usr/local/bin/monitoring.sh`
- Make executable: `sudo chmod +x /usr/local/bin/monitoring.sh`
- Check crond is running: `sudo systemctl status crond`

**Issue: SELinux blocking operations**
- Check SELinux status: `sudo sestatus`
- View denials: `sudo ausearch -m avc -ts recent`
- Set to permissive mode temporarily: `sudo setenforce 0`
- For permanent changes, modify booleans or create policies

---

## Conclusion

This guide covers all mandatory and bonus requirements for the Born2BeRoot project using Rocky Linux. Follow each step carefully, understand what you're doing, and be prepared to explain your choices during the defense.

Remember: The goal is not just to complete the project, but to understand system administration fundamentals in an enterprise Linux environment.

Good luck with your Born2BeRoot project! 🚀
