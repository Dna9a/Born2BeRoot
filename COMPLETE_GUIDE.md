# Born2BeRoot Complete Guide - Debian Edition

## Table of Contents
1. [Introduction](#introduction)
2. [Virtual Machine Setup](#virtual-machine-setup)
3. [Debian Installation](#debian-installation)
4. [Partition Configuration](#partition-configuration)
5. [System Configuration](#system-configuration)
6. [User and Group Management](#user-and-group-management)
7. [Sudo Configuration](#sudo-configuration)
8. [SSH Configuration](#ssh-configuration)
9. [UFW Firewall Setup](#ufw-firewall-setup)
10. [Password Policy](#password-policy)
11. [Monitoring Script](#monitoring-script)
12. [Bonus: WordPress Setup](#bonus-wordpress-setup)
13. [Testing and Verification](#testing-and-verification)
14. [Defense Preparation](#defense-preparation)

---

## Introduction

Born2BeRoot is a system administration project from the 42 School curriculum. The goal is to create a virtual machine running Debian (or Rocky Linux) with strict security configurations and custom monitoring capabilities.

### Project Requirements Overview
- Virtual machine using VirtualBox or UTM
- Latest stable Debian version (no graphical interface)
- LVM with encrypted partitions
- SSH running on port 4242
- UFW firewall with only port 4242 open
- Strong password policy
- Configured sudo with strict rules
- Monitoring script displaying system information every 10 minutes

---

## Virtual Machine Setup

### Step 1: Download VirtualBox
1. Go to [VirtualBox Downloads](https://www.virtualbox.org/wiki/Downloads)
2. Download the appropriate version for your operating system
3. Install VirtualBox following the installation wizard

### Step 2: Download Debian ISO
1. Visit [Debian Official Downloads](https://www.debian.org/distrib/)
2. Download the latest stable **netinst** ISO (small installation image)
3. Choose the appropriate architecture (usually AMD64 for 64-bit systems)

### Step 3: Create Virtual Machine
1. Open VirtualBox
2. Click **"New"** to create a new virtual machine
3. Configuration:
   - **Name:** Born2BeRoot (or your choice)
   - **Type:** Linux
   - **Version:** Debian (64-bit)
   - **Memory:** 1024 MB (1 GB) - minimum recommended
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
   - Select your downloaded Debian ISO
4. Click **"OK"** to save settings

---

## Debian Installation

### Step 1: Start Installation
1. Start your virtual machine
2. Select **"Install"** (not Graphical Install)

### Step 2: Language and Location
1. **Language:** English
2. **Location:** Your country
3. **Keymap:** Your keyboard layout

### Step 3: Network Configuration
1. **Hostname:** Use your 42 login + "42" (e.g., `yoabied42`)
2. **Domain name:** Leave empty or use default
3. **Root password:** Choose a strong password (follow password policy)
4. **Re-enter root password**
5. **Full name for new user:** Your name
6. **Username:** Your 42 login (e.g., `yoabied`)
7. **Password:** Strong password (follow password policy)

### Step 4: Clock Configuration
- Select your time zone

---

## Partition Configuration

This is one of the most critical parts of the project. You need to create an encrypted LVM structure.

### Step 1: Partition Disks
1. Select **"Manual"** partitioning method

### Step 2: Create Boot Partition
1. Select **"FREE SPACE"**
2. **Create a new partition**
3. **Size:** 500 MB (or 525 MB)
4. **Type:** Primary
5. **Location:** Beginning
6. **Use as:** Ext4 journaling file system
7. **Mount point:** /boot
8. **Done setting up the partition**

### Step 3: Create Encrypted Volume
1. Select remaining **"FREE SPACE"**
2. **Create a new partition**
3. **Size:** Maximum (use all remaining space)
4. **Type:** Logical
5. **Use as:** physical volume for encryption
6. **Done setting up the partition**
7. **Configure encrypted volumes** → Yes (write changes to disk)
8. **Create encrypted volumes**
9. Select the partition you just created (sda5 or similar)
10. **Done setting up the partition**
11. **Finish**
12. **Yes** (write changes)
13. **Encryption passphrase:** Strong passphrase (you'll need to enter this at boot)
14. Re-enter the passphrase

### Step 4: Configure LVM
1. **Configure the Logical Volume Manager** → Yes (write changes)
2. **Create volume group**
3. **Volume group name:** LVMGroup (or your login + "42" like `yoabied42`)
4. Select the encrypted partition (/dev/mapper/sda5_crypt or similar)
5. **Create logical volumes** (create the following):
   
   **Mandatory Partitions:**
   - **root**: 10 GB
     - Logical volume name: root
     - Volume group: LVMGroup
     - Size: 10G
   
   - **swap**: 2.3 GB
     - Logical volume name: swap
     - Size: 2.3G
   
   - **home**: 5 GB
     - Logical volume name: home
     - Size: 5G
   
   - **var**: 3 GB
     - Logical volume name: var
     - Size: 3G
   
   - **srv**: 3 GB
     - Logical volume name: srv
     - Size: 3G
   
   - **tmp**: 3 GB
     - Logical volume name: tmp
     - Size: 3G
   
   - **var-log**: 4 GB (remaining space)
     - Logical volume name: var-log
     - Size: 4G or remaining

6. **Finish** configuring LVM

### Step 5: Format Logical Volumes
For each logical volume you created:

1. Select **"LV home"** under LVM VG LVMGroup
   - **Use as:** Ext4 journaling file system
   - **Mount point:** /home
   - **Done setting up**

2. Select **"LV root"**
   - **Use as:** Ext4 journaling file system
   - **Mount point:** /
   - **Done setting up**

3. Select **"LV srv"**
   - **Use as:** Ext4 journaling file system
   - **Mount point:** /srv
   - **Done setting up**

4. Select **"LV swap"**
   - **Use as:** swap area
   - **Done setting up**

5. Select **"LV tmp"**
   - **Use as:** Ext4 journaling file system
   - **Mount point:** /tmp
   - **Done setting up**

6. Select **"LV var"**
   - **Use as:** Ext4 journaling file system
   - **Mount point:** /var
   - **Done setting up**

7. Select **"LV var-log"**
   - **Use as:** Ext4 journaling file system
   - **Mount point:** /var/log
   - **Done setting up**

8. **Finish partitioning and write changes to disk** → Yes

### Step 6: Continue Installation
1. **Scan extra installation media:** No
2. **Debian archive mirror country:** Your country
3. **Debian archive mirror:** deb.debian.org (or closest mirror)
4. **HTTP proxy:** Leave empty (unless you need one)
5. **Participate in package usage survey:** No
6. **Software selection:** UNCHECK everything (no desktop environment, no print server)
   - Only keep: "SSH server" and "standard system utilities"
7. Wait for installation to complete
8. **Install GRUB boot loader:** Yes
9. **Device for boot loader:** /dev/sda
10. **Installation complete** → Continue (it will reboot)

---

## System Configuration

### Step 1: Login as Root
```bash
# Enter encryption password at boot
# Login as root
```

### Step 2: Install Required Packages
```bash
apt update
apt upgrade -y
apt install sudo vim ufw libpam-pwquality -y
```

### Step 3: Check System Information
```bash
# Verify Debian version
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
# Add your user to sudo and user42 groups
usermod -aG sudo,user42 <your_username>

# Verify user groups
groups <your_username>

# Alternative: check with id
id <your_username>
```

### Step 3: Create New User (for evaluation)
```bash
# Create a new user
adduser <new_username>

# Add to appropriate groups
usermod -aG user42 <new_username>

# Verify
groups <new_username>
```

### Step 4: Manage Users
```bash
# Delete a user
deluser <username>

# Delete user and home directory
deluser --remove-home <username>

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
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
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

### Step 1: Configure SSH
```bash
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
sudo systemctl restart ssh

# Check SSH status
sudo systemctl status ssh

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

## UFW Firewall Setup

### Step 1: Enable UFW
```bash
# Enable UFW
sudo ufw enable

# Allow SSH on port 4242
sudo ufw allow 4242
```

### Step 2: Check Firewall Status
```bash
# Check UFW status
sudo ufw status numbered

# Should show:
# Status: active
# To                         Action      From
# --                         ------      ----
# 4242                       ALLOW       Anywhere
# 4242 (v6)                  ALLOW       Anywhere (v6)
```

### Step 3: Manage Firewall Rules
```bash
# Delete a rule (by number)
sudo ufw delete <rule_number>

# Allow a port
sudo ufw allow <port_number>

# Deny a port
sudo ufw deny <port_number>

# Disable firewall
sudo ufw disable
```

---

## Password Policy

### Step 1: Configure Password Quality Requirements
```bash
# Edit PAM password quality configuration
sudo vim /etc/pam.d/common-password
```

### Step 2: Modify Password Quality Settings
Find the line with `pam_pwquality.so` and modify it:

```bash
password        requisite                       pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username difok=7 enforce_for_root
```

**Explanation:**
- `retry=3`: Allow 3 password entry attempts
- `minlen=10`: Minimum password length of 10 characters
- `ucredit=-1`: At least 1 uppercase letter required
- `dcredit=-1`: At least 1 digit required
- `maxrepeat=3`: No more than 3 consecutive identical characters
- `reject_username`: Password cannot contain username
- `difok=7`: At least 7 characters different from old password
- `enforce_for_root`: Apply rules to root user as well

### Step 3: Configure Password Aging
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

### Step 4: Apply Password Policy to Existing Users
```bash
# For your user
sudo chage -M 30 -m 2 -W 7 <your_username>

# For root
sudo chage -M 30 -m 2 -W 7 root

# Check password aging information
sudo chage -l <your_username>
```

### Step 5: Change Passwords to Comply
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

# Sudo commands
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
# Stop cron service
sudo systemctl stop cron

# Start cron service
sudo systemctl start cron

# Disable cron at boot (for defense)
sudo systemctl disable cron

# Enable cron at boot
sudo systemctl enable cron
```

---

## Bonus: WordPress Setup

### Prerequisites
```bash
# Install required packages
sudo apt install lighttpd mariadb-server php-cgi php-mysql wget -y
```

### Step 1: Configure Lighttpd
```bash
# Enable required modules
sudo lighty-enable-mod fastcgi
sudo lighty-enable-mod fastcgi-php

# Restart lighttpd
sudo systemctl restart lighttpd

# Allow HTTP port in firewall
sudo ufw allow 80
```

### Step 2: Configure MariaDB
```bash
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
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress
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
# You can choose any service except NGINX or Apache2
# Examples: FTP, Redis, Fail2ban, etc.

# Example: Install Fail2ban (intrusion prevention)
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

---

## Testing and Verification

### System Information
```bash
# Check Debian version
cat /etc/os-release

# Check if desktop environment is installed (should return nothing)
ls /usr/bin/*session

# Check AppArmor is running
sudo aa-status
```

### Partition Verification
```bash
# Check partition structure
lsblk

# Should show encrypted LVM structure with:
# - sda1: /boot
# - sda5: encrypted volume
# - Multiple LV partitions under LVMGroup
```

### User and Group Verification
```bash
# Check if user exists and is in correct groups
groups <your_username>
# Should show: sudo user42

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
sudo systemctl status ssh
sudo ss -tunlp | grep 4242

# Check root login is disabled
sudo grep "PermitRootLogin" /etc/ssh/sshd_config
# Should show: PermitRootLogin no
```

### UFW Verification
```bash
# Check UFW status
sudo ufw status numbered

# Should show only port 4242 allowed
```

### Password Policy Verification
```bash
# Check password quality settings
sudo cat /etc/pam.d/common-password | grep pam_pwquality

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
adduser <username>         # Create new user
deluser <username>         # Delete user
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
sudo systemctl status ssh  # Check SSH status
sudo vim /etc/ssh/sshd_config  # Edit SSH config
sudo systemctl restart ssh # Restart SSH service
```

**UFW:**
```bash
sudo ufw status numbered   # Show firewall rules
sudo ufw allow <port>      # Allow port
sudo ufw delete <number>   # Delete rule by number
```

**Monitoring Script:**
```bash
sudo crontab -l            # List cron jobs
sudo crontab -e            # Edit cron jobs
sudo systemctl status cron # Check cron status
```

### Questions to Prepare For

1. **What is a virtual machine?**
   - A virtual machine is a software-based emulation of a physical computer that runs an operating system and applications independently.

2. **Why did you choose Debian?**
   - Debian is stable, secure, has extensive documentation, and is beginner-friendly. It's widely used in servers and has a strong community.

3. **Difference between Debian and Rocky Linux?**
   - Debian: Uses APT package manager, larger repository, community-driven
   - Rocky: RHEL-based, uses DNF/YUM, enterprise-focused, different release cycle

4. **What is AppArmor?**
   - AppArmor is a Linux kernel security module that restricts programs' capabilities using per-program profiles.

5. **Difference between AppArmor and SELinux?**
   - AppArmor: Path-based, easier to configure, Debian default
   - SELinux: Label-based, more complex, Red Hat default, more granular

6. **What is LVM?**
   - Logical Volume Manager allows flexible disk management, enabling resizing, snapshots, and easier partition management.

7. **What is UFW?**
   - Uncomplicated Firewall - a user-friendly frontend for iptables to manage firewall rules.

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
- [ ] Demonstrate UFW rule management
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
- Boot into recovery mode
- Remount root as read-write: `mount -o remount,rw /`
- Fix sudoers: `visudo`

**Issue: SSH connection refused**
- Check if SSH is running: `sudo systemctl status ssh`
- Check port forwarding in VirtualBox settings
- Verify firewall: `sudo ufw status`

**Issue: Forgot encryption password**
- Unfortunately, there's no recovery without the password
- You'll need to restart the installation

**Issue: Monitoring script not working**
- Check script permissions: `ls -l /usr/local/bin/monitoring.sh`
- Make executable: `sudo chmod +x /usr/local/bin/monitoring.sh`
- Check cron is running: `sudo systemctl status cron`

---

## Conclusion

This guide covers all mandatory and bonus requirements for the Born2BeRoot project. Follow each step carefully, understand what you're doing, and be prepared to explain your choices during the defense.

Remember: The goal is not just to complete the project, but to understand system administration fundamentals.

Good luck with your Born2BeRoot project! 🚀
