# Born2BeRoot Quick Reference

## Quick Command Reference

### User Management
```bash
# Create user
sudo adduser <username>

# Delete user
sudo deluser <username>
sudo deluser --remove-home <username>  # Also delete home directory

# Check user groups
groups <username>
id <username>

# Add user to group
sudo usermod -aG <group> <username>

# Remove user from group
sudo gpasswd -d <username> <group>

# List all users
cat /etc/passwd | cut -d: -f1

# Create group
sudo groupadd <groupname>

# Delete group
sudo groupdel <groupname>

# Check group members
getent group <groupname>
```

### Password Management
```bash
# Change password
sudo passwd <username>

# Check password policy
sudo chage -l <username>

# Set password expiry
sudo chage -M 30 <username>  # Max days
sudo chage -m 2 <username>   # Min days
sudo chage -W 7 <username>   # Warning days

# Force password change on next login
sudo chage -d 0 <username>
```

### Sudo Configuration
```bash
# Edit sudoers (always use visudo)
sudo visudo

# Check sudo privileges
sudo -l

# View sudo logs
sudo cat /var/log/sudo/sudo.log
sudo cat /var/log/sudo/sudo.log | grep COMMAND
```

### SSH Management
```bash
# Check SSH status
sudo systemctl status ssh

# Restart SSH
sudo systemctl restart ssh

# Check SSH configuration
sudo cat /etc/ssh/sshd_config | grep Port
sudo cat /etc/ssh/sshd_config | grep PermitRootLogin

# Check listening ports
sudo ss -tunlp | grep ssh
sudo netstat -tulpn | grep ssh

# Connect to SSH
ssh <username>@localhost -p 4242
```

### UFW Firewall
```bash
# Check status
sudo ufw status
sudo ufw status numbered
sudo ufw status verbose

# Enable/Disable
sudo ufw enable
sudo ufw disable

# Allow port
sudo ufw allow 4242
sudo ufw allow 80

# Delete rule
sudo ufw delete <rule_number>
sudo ufw delete allow 4242

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Reset firewall
sudo ufw reset
```

### System Information
```bash
# OS information
cat /etc/os-release
uname -a
uname -r  # Kernel version

# Hostname
hostname
hostnamectl

# Change hostname
sudo hostnamectl set-hostname <new_hostname>
# Then edit /etc/hosts

# Check partitions
lsblk
df -h
sudo fdisk -l

# LVM information
sudo lvdisplay
sudo vgdisplay
sudo pvdisplay

# Check AppArmor
sudo aa-status
```

### Monitoring Script
```bash
# Run manually
sudo /usr/local/bin/monitoring.sh

# Edit cron jobs
sudo crontab -e

# List cron jobs
sudo crontab -l

# Cron service
sudo systemctl status cron
sudo systemctl stop cron
sudo systemctl start cron
sudo systemctl restart cron
sudo systemctl enable cron   # Start at boot
sudo systemctl disable cron  # Don't start at boot
```

### Network Information
```bash
# IP address
hostname -I
ip addr
ip a

# MAC address
ip link
ip link show

# Active connections
ss -ta
ss -tunlp
netstat -tulpn

# Check open ports
sudo ss -tunlp
sudo netstat -tulpn
```

### Service Management
```bash
# Check service status
sudo systemctl status <service>

# Start/Stop/Restart service
sudo systemctl start <service>
sudo systemctl stop <service>
sudo systemctl restart <service>

# Enable/Disable service at boot
sudo systemctl enable <service>
sudo systemctl disable <service>

# List all services
systemctl list-units --type=service

# Check if service is enabled
systemctl is-enabled <service>
```

## Defense Questions & Answers

### What is a Virtual Machine?
A virtual machine (VM) is a software-based emulation of a physical computer that runs an operating system and applications as if it were a separate physical machine. It allows multiple OS environments to run simultaneously on a single physical machine.

### Why Choose Debian?
- Stable and reliable
- Large community support
- Extensive documentation
- Beginner-friendly
- APT package manager is straightforward
- Good for learning Linux fundamentals

### Debian vs Rocky Linux
| Debian | Rocky Linux |
|--------|-------------|
| Community-driven | Enterprise-focused (RHEL clone) |
| APT package manager | DNF/YUM package manager |
| .deb packages | .rpm packages |
| Larger software repository | Smaller but stable repository |
| Release when ready | Fixed release schedule |

### What is LVM?
Logical Volume Manager (LVM) is a device mapper framework that provides logical volume management for the Linux kernel. Benefits:
- Dynamic resizing of partitions
- Snapshots for backups
- Better disk space management
- Ability to combine multiple disks

### What is AppArmor?
AppArmor (Application Armor) is a Linux kernel security module that allows the system administrator to restrict programs' capabilities with per-program profiles. It uses path-based access control.

### AppArmor vs SELinux
| AppArmor | SELinux |
|----------|---------|
| Path-based access control | Label-based access control |
| Easier to configure | More complex configuration |
| Default in Debian/Ubuntu | Default in RHEL/CentOS |
| Less granular | More granular control |
| Uses file paths | Uses security contexts |

### What is UFW?
Uncomplicated Firewall (UFW) is a user-friendly frontend for managing iptables firewall rules. It's designed to make firewall configuration easier.

### UFW vs firewalld
| UFW | firewalld |
|-----|-----------|
| Simpler interface | More features |
| Debian/Ubuntu default | RHEL/CentOS default |
| Single zone concept | Multiple zones |
| Static rules | Dynamic rules |

### What is SSH?
Secure Shell (SSH) is a cryptographic network protocol for operating network services securely over an unsecured network. Used for:
- Remote command execution
- Secure file transfer (SCP, SFTP)
- Port forwarding/tunneling

### What is Sudo?
Sudo (superuser do) allows authorized users to run commands with root privileges without logging in as root. Benefits:
- Better security (no need to share root password)
- Audit trail (logs who did what)
- Granular control (specific commands per user)
- Temporary elevation of privileges

### What is Cron?
Cron is a time-based job scheduler in Unix-like systems. It allows users to schedule commands or scripts to run automatically at specified times/dates/intervals.

### Password Policy Explanation
- **minlen=10**: Minimum 10 characters
- **ucredit=-1**: At least 1 uppercase letter
- **dcredit=-1**: At least 1 digit
- **maxrepeat=3**: Max 3 consecutive identical characters
- **reject_username**: Password can't contain username
- **difok=7**: At least 7 different characters from old password
- **PASS_MAX_DAYS 30**: Password expires in 30 days
- **PASS_MIN_DAYS 2**: Can't change password before 2 days
- **PASS_WARN_AGE 7**: Warning 7 days before expiry

## Common Defense Tasks

### Create a New User
```bash
sudo adduser evaluator
sudo usermod -aG user42 evaluator
groups evaluator
```

### Change Hostname
```bash
sudo hostnamectl set-hostname new_hostname
sudo vim /etc/hosts  # Change old hostname to new
sudo reboot
```

### Add/Remove Firewall Rule
```bash
sudo ufw allow 8080
sudo ufw status numbered
sudo ufw delete <number>
```

### Show Partition Structure
```bash
lsblk
```

### Explain Monitoring Script
Go through each section:
1. System architecture (uname -a)
2. Physical/Virtual CPUs (from /proc/cpuinfo)
3. RAM usage (free command)
4. Disk usage (df command)
5. CPU load (vmstat)
6. Last boot time (who -b)
7. LVM status (lsblk)
8. TCP connections (ss command)
9. Logged in users (users)
10. Network info (hostname, ip)
11. Sudo commands (journalctl)

### Modify Cron Schedule
```bash
sudo crontab -e

# Every 10 minutes
*/10 * * * * /usr/local/bin/monitoring.sh

# Every 5 minutes
*/5 * * * * /usr/local/bin/monitoring.sh

# Every minute
* * * * * /usr/local/bin/monitoring.sh
```

### Stop Cron Without Uninstalling
```bash
sudo systemctl stop cron
# Or
sudo systemctl disable cron
```

## File Locations

- **Sudo config**: `/etc/sudoers`
- **Sudo logs**: `/var/log/sudo/`
- **SSH config**: `/etc/ssh/sshd_config`
- **Password policy**: `/etc/pam.d/common-password`
- **Password aging**: `/etc/login.defs`
- **Monitoring script**: `/usr/local/bin/monitoring.sh`
- **Cron jobs**: `sudo crontab -l`
- **User list**: `/etc/passwd`
- **Group list**: `/etc/group`
- **AppArmor profiles**: `/etc/apparmor.d/`

## Important Notes

1. **Always use visudo** to edit sudoers file - it checks for syntax errors
2. **Restart services** after config changes (SSH, UFW, etc.)
3. **Test changes** before evaluation (create test user, try SSH, etc.)
4. **Know your hostname** format (should be login42)
5. **Understand every line** of your monitoring script
6. **Can explain** why you chose each partition size
7. **Password must follow policy** when creating new users
8. **Root cannot SSH** into the system (PermitRootLogin no)
9. **Only port 4242** should be open (UFW)
10. **Script runs every 10 minutes** via cron

## Troubleshooting

### Can't login after reboot
- Check if you're entering encryption password correctly
- Verify user password is correct

### SSH connection refused
- Check if SSH service is running: `sudo systemctl status ssh`
- Verify port 4242 is open: `sudo ufw status`
- Check VirtualBox port forwarding settings

### Sudo not working
- Check if user is in sudo group: `groups username`
- Verify sudoers file syntax: `sudo visudo -c`

### Monitoring script not broadcasting
- Check if script is executable: `ls -l /usr/local/bin/monitoring.sh`
- Verify cron service is running: `sudo systemctl status cron`
- Check cron syntax: `sudo crontab -l`

### Can't change password (doesn't meet policy)
- Ensure password has: 10+ chars, 1 uppercase, 1 digit
- Check it doesn't contain username
- Verify it's different enough from old password

## Quick Test Checklist

Before evaluation:
- [ ] Hostname is correct format (login42)
- [ ] UFW is active with only port 4242
- [ ] SSH works on port 4242
- [ ] User is in sudo and user42 groups
- [ ] Password policy is active
- [ ] Sudo logs are working
- [ ] Monitoring script runs and displays correctly
- [ ] Can create/delete users
- [ ] Can modify hostname
- [ ] Understand partition structure
- [ ] All services are running correctly

Good luck with your defense! 🚀
