# Born2BeRoot Quick Reference - Rocky Linux

Quick command reference for common tasks in the Born2BeRoot project using Rocky Linux.

## System Information

```bash
# Check Rocky Linux version
cat /etc/os-release
cat /etc/redhat-release

# Check architecture
uname -a
uname -m

# Check hostname
hostname
hostnamectl

# Check if SELinux is enabled
sestatus
getenforce

# Check running services
systemctl list-units --type=service --state=running
```

## User Management

```bash
# Create new user
sudo useradd <username>

# Create user with home directory
sudo useradd -m <username>

# Delete user
sudo userdel <username>

# Delete user and home directory
sudo userdel -r <username>

# Change user password
sudo passwd <username>

# Check password aging information
sudo chage -l <username>

# Set password aging
sudo chage -M 30 -m 2 -W 7 <username>

# Force password change on next login
sudo chage -d 0 <username>

# List all users
cat /etc/passwd | cut -d: -f1

# Check user information
id <username>
```

## Group Management

```bash
# Create group
sudo groupadd <groupname>

# Delete group
sudo groupdel <groupname>

# Add user to group
sudo usermod -aG <groupname> <username>

# Remove user from group
sudo gpasswd -d <username> <groupname>

# List all groups
cat /etc/group

# Check user's groups
groups <username>
id <username>

# List users in a group
getent group <groupname>
```

## Sudo Operations

```bash
# Edit sudoers file (ALWAYS use visudo)
sudo visudo

# Check sudo configuration
sudo cat /etc/sudoers

# View sudo logs
sudo cat /var/log/sudo/sudo.log

# List sudo logs directory
ls -la /var/log/sudo/

# Test sudo access
sudo whoami

# Run command as specific user
sudo -u <username> <command>

# List user's sudo privileges
sudo -l
```

## SSH Management

```bash
# Check SSH status
sudo systemctl status sshd

# Start SSH service
sudo systemctl start sshd

# Stop SSH service
sudo systemctl stop sshd

# Restart SSH service
sudo systemctl restart sshd

# Enable SSH at boot
sudo systemctl enable sshd

# Check SSH configuration
sudo cat /etc/ssh/sshd_config

# Check SSH port
sudo ss -tunlp | grep sshd
sudo netstat -tulpn | grep :4242

# Connect via SSH
ssh <username>@localhost -p 4242
ssh <username>@<ip_address> -p 4242

# Test SSH from host machine
ssh <username>@localhost -p 4242
```

## Firewalld (Firewall)

```bash
# Check firewalld status
sudo systemctl status firewalld
sudo firewall-cmd --state

# Start/stop firewalld
sudo systemctl start firewalld
sudo systemctl stop firewalld

# Enable at boot
sudo systemctl enable firewalld

# List all rules
sudo firewall-cmd --list-all

# List allowed ports
sudo firewall-cmd --list-ports

# Allow a port
sudo firewall-cmd --permanent --add-port=4242/tcp
sudo firewall-cmd --reload

# Remove a port
sudo firewall-cmd --permanent --remove-port=4242/tcp
sudo firewall-cmd --reload

# List services
sudo firewall-cmd --list-services

# Allow a service
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload

# Reload firewall rules
sudo firewall-cmd --reload

# Check default zone
sudo firewall-cmd --get-default-zone

# List active zones
sudo firewall-cmd --get-active-zones
```

## SELinux Management

```bash
# Check SELinux status
sestatus
getenforce

# Set SELinux mode (temporary)
sudo setenforce 0  # Permissive
sudo setenforce 1  # Enforcing

# Check SELinux mode
getenforce

# View SELinux config
cat /etc/selinux/config

# Check SELinux file contexts
ls -Z /path/to/file

# View SELinux denials
sudo ausearch -m AVC,USER_AVC -ts recent
sudo grep "SELinux" /var/log/messages
```

## Package Management (DNF/YUM)

```bash
# Update package list
sudo dnf check-update

# Update all packages
sudo dnf update -y
sudo dnf upgrade -y

# Install package
sudo dnf install <package> -y

# Remove package
sudo dnf remove <package>

# Search for package
dnf search <package>

# List installed packages
dnf list installed

# Get package information
dnf info <package>

# Clean cache
sudo dnf clean all

# Check for updates
dnf check-update

# List available updates
dnf list updates

# Using YUM (alternative, similar syntax)
sudo yum update -y
sudo yum install <package> -y
```

## Hostname Management

```bash
# Display hostname
hostname
hostnamectl

# Change hostname (temporary)
sudo hostname <new_hostname>

# Change hostname (permanent)
sudo hostnamectl set-hostname <new_hostname>

# Edit hosts file
sudo vim /etc/hosts
# Change: 127.0.0.1 localhost <new_hostname>

# Verify hostname change
hostname
hostnamectl
```

## Partition and LVM

```bash
# List block devices
lsblk

# Show disk usage
df -h

# Show detailed partition info
sudo fdisk -l

# LVM: Physical volumes
sudo pvdisplay
sudo pvs

# LVM: Volume groups
sudo vgdisplay
sudo vgs

# LVM: Logical volumes
sudo lvdisplay
sudo lvs

# Check encryption
lsblk -f | grep crypto
sudo cryptsetup status /dev/mapper/sda5_crypt

# Extend logical volume
sudo lvextend -L +2G /dev/<vg>/<lv>
sudo xfs_growfs /mount/point  # For XFS
sudo resize2fs /dev/<vg>/<lv>  # For ext4
```

## Monitoring and System Info

```bash
# CPU information
lscpu
cat /proc/cpuinfo

# Memory information
free -h
free -m
cat /proc/meminfo

# Disk usage
df -h
du -sh /path/to/directory

# Current processes
ps aux
top
htop

# Network connections
ss -tunlp
netstat -tulpn

# Check established connections
ss -ta | grep ESTAB

# System load
uptime
w

# Last boot time
who -b

# Check services
systemctl list-units --type=service

# View system logs
sudo journalctl -xe
sudo journalctl -u <service>
```

## Cron Jobs

```bash
# Edit root crontab
sudo crontab -e

# List root crontab
sudo crontab -l

# Edit user crontab
crontab -e

# List user crontab
crontab -l

# Check cron service
sudo systemctl status crond

# View cron logs
sudo grep CRON /var/log/cron
sudo journalctl -u crond

# Cron syntax:
# */10 * * * * /path/to/script.sh  # Every 10 minutes
# 0 * * * * /path/to/script.sh     # Every hour
# 0 0 * * * /path/to/script.sh     # Every day at midnight
```

## Monitoring Script

```bash
# Create script
sudo vim /usr/local/bin/monitoring.sh

# Make executable
sudo chmod +x /usr/local/bin/monitoring.sh

# Test script
sudo /usr/local/bin/monitoring.sh

# Add to cron (every 10 minutes)
sudo crontab -e
# Add: */10 * * * * /usr/local/bin/monitoring.sh

# Check if running
ps aux | grep monitoring
```

## Service Management

```bash
# Check service status
sudo systemctl status <service>

# Start service
sudo systemctl start <service>

# Stop service
sudo systemctl stop <service>

# Restart service
sudo systemctl restart <service>

# Reload service configuration
sudo systemctl reload <service>

# Enable service at boot
sudo systemctl enable <service>

# Disable service at boot
sudo systemctl disable <service>

# Check if service is enabled
sudo systemctl is-enabled <service>

# List failed services
sudo systemctl --failed

# View service logs
sudo journalctl -u <service>
sudo journalctl -u <service> -f  # Follow logs
```

## Network

```bash
# Show IP addresses
ip a
ip addr show
hostname -I

# Show MAC addresses
ip link show

# Show routing table
ip route
route -n

# Test connectivity
ping -c 4 8.8.8.8
ping -c 4 google.com

# DNS lookup
nslookup google.com
dig google.com

# Check open ports
sudo ss -tunlp
sudo netstat -tulpn

# Check listening ports
sudo ss -tlnp
```

## Logs

```bash
# System logs (Rocky Linux uses journalctl)
sudo journalctl -xe
sudo journalctl -f  # Follow logs
sudo journalctl -u <service>
sudo journalctl --since "1 hour ago"
sudo journalctl --since "2023-01-01"
sudo journalctl -p err  # Only errors

# Traditional log files
sudo cat /var/log/messages      # System messages
sudo cat /var/log/secure        # Security/auth logs
sudo cat /var/log/cron          # Cron logs
sudo tail -f /var/log/messages  # Follow system logs

# Sudo logs
sudo cat /var/log/sudo/sudo.log
sudo cat /var/log/secure | grep sudo

# Clear journal logs (keep last 7 days)
sudo journalctl --vacuum-time=7d
```

## Password Policy Verification

```bash
# Check PAM password quality settings
sudo cat /etc/security/pwquality.conf

# Check login definitions
sudo cat /etc/login.defs | grep PASS_

# Check user password aging
sudo chage -l <username>

# Check all users password aging
for user in $(cat /etc/passwd | cut -d: -f1); do
    echo "User: $user"
    sudo chage -l $user
    echo "---"
done
```

## Bonus: WordPress/Apache

```bash
# Apache (httpd) service
sudo systemctl status httpd
sudo systemctl start httpd
sudo systemctl restart httpd

# Check Apache configuration
sudo httpd -t
sudo apachectl configtest

# Apache configuration files
sudo vim /etc/httpd/conf/httpd.conf
sudo vim /etc/httpd/conf.d/

# MariaDB/MySQL service
sudo systemctl status mariadb
sudo systemctl start mariadb

# Access MariaDB
sudo mysql -u root -p
sudo mysql

# Check MariaDB databases
sudo mysql -e "SHOW DATABASES;"

# Check PHP version
php -v

# PHP configuration
sudo vim /etc/php.ini
```

## Troubleshooting

```bash
# Check system status
systemctl status

# Check failed services
sudo systemctl --failed

# Check system logs
sudo journalctl -xe
sudo journalctl -p err

# Check disk space
df -h
sudo du -sh /* | sort -h

# Check memory usage
free -h
top

# Check processes
ps aux
top
htop

# Kill a process
sudo kill <PID>
sudo killall <process_name>

# Check network issues
ip a
ip route
ping 8.8.8.8

# Test port connectivity
telnet <ip> <port>
nc -zv <ip> <port>

# Reboot system
sudo reboot

# Shutdown system
sudo shutdown -h now
sudo poweroff
```

## Useful Keyboard Shortcuts in Terminal

- `Ctrl + C` - Stop current command
- `Ctrl + Z` - Suspend current command
- `Ctrl + D` - Logout/exit
- `Ctrl + L` - Clear screen
- `Ctrl + A` - Go to start of line
- `Ctrl + E` - Go to end of line
- `Ctrl + U` - Delete from cursor to start
- `Ctrl + K` - Delete from cursor to end
- `Ctrl + R` - Search command history
- `Tab` - Autocomplete
- `!!` - Repeat last command
- `sudo !!` - Repeat last command with sudo

## Common File Paths

```bash
# Configuration files
/etc/ssh/sshd_config              # SSH configuration
/etc/sudoers                      # Sudo configuration
/etc/security/pwquality.conf      # Password quality config
/etc/login.defs                   # Login defaults
/etc/pam.d/                       # PAM configuration
/etc/selinux/config               # SELinux config
/etc/hosts                        # Hostname mappings
/etc/hostname                     # System hostname
/etc/redhat-release               # Rocky version
/etc/httpd/conf/httpd.conf        # Apache config

# Log files
/var/log/messages                 # System messages
/var/log/secure                   # Auth logs
/var/log/cron                     # Cron logs
/var/log/sudo/sudo.log            # Sudo logs
/var/log/firewalld                # Firewall logs
/var/log/httpd/                   # Apache logs

# User data
/home/<username>/                 # User home directory
/root/                            # Root home directory
/etc/passwd                       # User accounts
/etc/group                        # Groups
/etc/shadow                       # Password hashes (need root)
```

---

## Defense Questions - Quick Answers

**Q: What is Rocky Linux?**
A: Enterprise Linux distribution, CentOS replacement, 100% compatible with RHEL.

**Q: Difference between Rocky and Debian?**
A: Rocky uses DNF/YUM, RPM packages, SELinux, firewalld; Debian uses APT, DEB packages, AppArmor, UFW.

**Q: What is SELinux?**
A: Security-Enhanced Linux - mandatory access control security system.

**Q: Difference between AppArmor and SELinux?**
A: Both are MAC systems; SELinux (Red Hat) is more complex/powerful, uses contexts; AppArmor (Debian) is simpler, uses file paths.

**Q: What is firewalld?**
A: Dynamic firewall manager, default on RHEL/Rocky, uses zones and services.

**Q: Difference between UFW and firewalld?**
A: UFW (Debian) is simpler, frontend for iptables; firewalld (Rocky) is more advanced with zones and dynamic rules.

**Q: What is DNF?**
A: Dandified YUM - next-generation package manager for RPM-based distributions, replaces YUM.

**Q: What is LVM?**
A: Logical Volume Manager - flexible disk management, allows resizing, snapshots, multiple disks as one.

**Q: What is sudo?**
A: "Superuser do" - allows users to run commands with root privileges securely.

**Q: What is SSH?**
A: Secure Shell - encrypted network protocol for secure remote login and command execution.

**Q: Why port 4242?**
A: Custom port for added security (security through obscurity), avoids default port 22 scanning.

---

**Good luck with your evaluation! 🚀**
