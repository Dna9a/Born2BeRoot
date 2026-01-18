# Born2BeRoot Setup Checklist - Rocky Linux Edition

## Pre-Installation
- [ ] Download VirtualBox (or UTM for Mac M1/M2)
- [ ] Download Rocky Linux ISO (Minimal or DVD version)
- [ ] Create Virtual Machine with appropriate settings
  - [ ] Name: Born2BeRoot
  - [ ] Type: Linux
  - [ ] Version: Red Hat (64-bit)
  - [ ] Memory: 2048 MB minimum (Rocky needs more than Debian)
  - [ ] Hard disk: 30 GB (8 GB for mandatory only)
  - [ ] Mount Rocky Linux ISO

## Installation Phase
- [ ] Start installation (choose "Install Rocky Linux")
- [ ] Select language: English
- [ ] Click "Continue"
- [ ] Configure network first
  - [ ] Network & Hostname: Turn ON ethernet
  - [ ] Hostname: your_login42 (e.g., yoabied42)
  - [ ] Click "Apply" and "Done"
- [ ] Set Time & Date
- [ ] Set Root password (strong, follows policy)
- [ ] Create user account during or after installation
  - [ ] Username: your 42 login
  - [ ] User password (strong, follows policy)

## Partition Configuration
- [ ] Click "Installation Destination"
- [ ] Select disk, choose "Custom" storage configuration
- [ ] Click "Done" to enter partitioning tool
- [ ] Create /boot partition (1 GB, Standard Partition, XFS)
- [ ] Create encrypted partition (remaining space)
  - [ ] Click "+" to add mount point "/"
  - [ ] Check "Encrypt my data"
  - [ ] Set encryption passphrase (remember this!)
- [ ] Configure LVM
  - [ ] Create volume group: (auto-created or name it)
  - [ ] Create logical volumes:
    - [ ] root (/): 10 GB (XFS)
    - [ ] swap: 2.3 GB (swap)
    - [ ] home (/home): 5 GB (XFS)
    - [ ] var (/var): 3 GB (XFS)
    - [ ] srv (/srv): 3 GB (XFS)
    - [ ] tmp (/tmp): 3 GB (XFS)
    - [ ] var-log (/var/log): 4 GB (XFS or remaining)
- [ ] Click "Done" and "Accept Changes"

## Complete Installation
- [ ] Software Selection
  - [ ] Choose "Minimal Install" (no GUI)
  - [ ] Or uncheck all desktop environments
  - [ ] Can add "Standard" or leave minimal
- [ ] Click "Begin Installation"
- [ ] Wait for installation to complete
- [ ] Click "Reboot System"
- [ ] Remove installation media when prompted

## Post-Installation - System Configuration
- [ ] Login as root
- [ ] Update system
  ```bash
  dnf check-update
  dnf update -y
  ```
- [ ] Install required packages
  ```bash
  dnf install sudo vim libpwquality -y
  ```
- [ ] Verify installation
  - [ ] Check Rocky version: `cat /etc/os-release` or `cat /etc/redhat-release`
  - [ ] Check partitions: `lsblk`
  - [ ] Check LVM: `lvdisplay`, `vgdisplay`
  - [ ] Check SELinux: `sestatus`

## User and Group Management
- [ ] Create user if not done during installation
  ```bash
  useradd -m <username>
  passwd <username>
  ```
- [ ] Create user42 group
  ```bash
  groupadd user42
  getent group user42
  ```
- [ ] Add your user to groups
  ```bash
  usermod -aG wheel,user42 <username>
  groups <username>
  ```
- [ ] Verify user is in correct groups (wheel = sudo on Rocky)

## Sudo Configuration
- [ ] Create sudo log directory
  ```bash
  mkdir -p /var/log/sudo
  ```
- [ ] Configure sudoers file using `visudo`
  - [ ] Add `passwd_tries=3`
  - [ ] Add custom `badpass_message`
  - [ ] Add `logfile="/var/log/sudo/sudo.log"`
  - [ ] Add `log_input` and `log_output`
  - [ ] Add `iolog_dir="/var/log/sudo"`
  - [ ] Add `requiretty`
  - [ ] Add `secure_path`
- [ ] Test sudo configuration
  - [ ] Switch to user: `su - <username>`
  - [ ] Test: `sudo whoami`
  - [ ] Check logs: `sudo cat /var/log/sudo/sudo.log`

## SSH Configuration
- [ ] Install SSH if not present: `sudo dnf install openssh-server -y`
- [ ] Edit SSH config: `sudo vim /etc/ssh/sshd_config`
  - [ ] Change Port to 4242
  - [ ] Set PermitRootLogin to no
- [ ] Restart SSH: `sudo systemctl restart sshd`
- [ ] Enable SSH at boot: `sudo systemctl enable sshd`
- [ ] Verify SSH status: `sudo systemctl status sshd`
- [ ] Check port: `sudo ss -tunlp | grep 4242`
- [ ] Configure VirtualBox port forwarding
  - [ ] VM Settings → Network → Port Forwarding
  - [ ] Add rule: Host Port 4242 → Guest Port 4242
- [ ] Test SSH connection from host
  ```bash
  ssh <username>@localhost -p 4242
  ```

## Firewalld Setup
- [ ] Check firewalld status
  ```bash
  sudo systemctl status firewalld
  ```
- [ ] Start and enable firewalld
  ```bash
  sudo systemctl start firewalld
  sudo systemctl enable firewalld
  ```
- [ ] Configure SSH port
  ```bash
  sudo firewall-cmd --permanent --remove-service=ssh
  sudo firewall-cmd --permanent --add-port=4242/tcp
  sudo firewall-cmd --reload
  ```
- [ ] Verify status
  ```bash
  sudo firewall-cmd --list-all
  ```
- [ ] Confirm only port 4242 is open

## Password Policy
- [ ] Edit password quality config: `sudo vim /etc/security/pwquality.conf`
  - [ ] Uncomment and set:
    - [ ] retry = 3
    - [ ] minlen = 10
    - [ ] ucredit = -1
    - [ ] dcredit = -1
    - [ ] maxrepeat = 3
    - [ ] usercheck = 1
    - [ ] difok = 7
    - [ ] enforce_for_root
- [ ] Edit login definitions: `sudo vim /etc/login.defs`
  - [ ] PASS_MAX_DAYS 30
  - [ ] PASS_MIN_DAYS 2
  - [ ] PASS_WARN_AGE 7
- [ ] Apply to existing users
  ```bash
  sudo chage -M 30 -m 2 -W 7 <username>
  sudo chage -M 30 -m 2 -W 7 root
  ```
- [ ] Verify: `sudo chage -l <username>`
- [ ] Change passwords to comply with policy
  ```bash
  sudo passwd root
  sudo passwd <username>
  ```

## Monitoring Script
- [ ] Create script: `sudo vim /usr/local/bin/monitoring.sh`
- [ ] Add script content (see COMPLETE_GUIDE.md or monitoring.sh file)
- [ ] Make executable: `sudo chmod +x /usr/local/bin/monitoring.sh`
- [ ] Test script: `sudo /usr/local/bin/monitoring.sh`
- [ ] Configure cron: `sudo crontab -e`
  - [ ] Add: `*/10 * * * * /usr/local/bin/monitoring.sh`
- [ ] Verify cron is running: `sudo systemctl status crond`
- [ ] Wait 10 minutes and verify broadcast appears

## Bonus: WordPress Setup (Optional)
- [ ] Install packages
  ```bash
  sudo dnf install httpd mariadb-server php php-mysqlnd php-fpm wget -y
  ```
- [ ] Configure Apache (httpd)
  - [ ] Start and enable: `sudo systemctl start httpd && sudo systemctl enable httpd`
  - [ ] Allow port 80 in firewall
  ```bash
  sudo firewall-cmd --permanent --add-service=http
  sudo firewall-cmd --reload
  ```
- [ ] Configure PHP-FPM
  ```bash
  sudo systemctl start php-fpm
  sudo systemctl enable php-fpm
  ```
- [ ] Secure MariaDB
  ```bash
  sudo systemctl start mariadb
  sudo systemctl enable mariadb
  sudo mysql_secure_installation
  ```
- [ ] Create WordPress database and user
- [ ] Download and install WordPress to /var/www/html/
- [ ] Configure wp-config.php
- [ ] Set proper permissions and SELinux contexts
- [ ] Access via browser

## Bonus: Additional Service (Optional)
- [ ] Choose and install additional service (not NGINX/Apache2)
  - Examples: FTP server, Fail2ban, Redis, etc.
- [ ] Configure service
- [ ] Document why you chose this service

## Testing and Verification

### System Verification
- [ ] Check Rocky version: `cat /etc/redhat-release`
- [ ] Verify no GUI: `systemctl get-default` (should be multi-user.target)
- [ ] Check SELinux: `sudo sestatus`

### Partition Verification
- [ ] Display partition structure: `lsblk`
- [ ] Verify encrypted LVM setup
- [ ] Check mount points: `df -h`

### User Verification
- [ ] Check user groups: `groups <username>`
- [ ] Verify user42 group exists: `getent group user42`
- [ ] List all users: `cat /etc/passwd | cut -d: -f1`

### Sudo Verification
- [ ] Check sudo config: `sudo cat /etc/sudoers`
- [ ] Verify sudo logs: `ls -la /var/log/sudo/`
- [ ] Test sudo and check log
  ```bash
  sudo ls
  sudo cat /var/log/sudo/sudo.log
  ```

### SSH Verification
- [ ] Check SSH status: `sudo systemctl status sshd`
- [ ] Verify port 4242: `sudo ss -tunlp | grep 4242`
- [ ] Confirm root login disabled: `sudo grep PermitRootLogin /etc/ssh/sshd_config`
- [ ] Test SSH connection from host machine

### Firewalld Verification
- [ ] Check firewall status: `sudo firewall-cmd --list-all`
- [ ] Verify only port 4242 (and 80 for bonus) is open

### Password Policy Verification
- [ ] Check password quality config: `sudo cat /etc/security/pwquality.conf`
- [ ] Check login defs: `sudo cat /etc/login.defs | grep PASS_`
- [ ] Check password aging: `sudo chage -l <username>`
- [ ] Test creating user with weak password (should fail)

### Hostname Verification
- [ ] Check hostname: `hostname`
- [ ] Practice changing hostname
  ```bash
  sudo hostnamectl set-hostname new_name
  sudo vim /etc/hosts
  sudo reboot
  ```

### Monitoring Script Verification
- [ ] Script runs manually: `sudo /usr/local/bin/monitoring.sh`
- [ ] Check cron jobs: `sudo crontab -l`
- [ ] Verify cron service: `sudo systemctl status crond`
- [ ] Confirm broadcast appears every 10 minutes

## Defense Preparation

### Practice Commands
- [ ] Create a new user (useradd)
- [ ] Delete a user (userdel)
- [ ] Add user to group (usermod -aG)
- [ ] Remove user from group (gpasswd -d)
- [ ] Change password
- [ ] Check password policy for user
- [ ] Modify hostname (hostnamectl)
- [ ] Add firewall rule (firewall-cmd --add-port)
- [ ] Delete firewall rule (firewall-cmd --remove-port)
- [ ] View sudo logs
- [ ] Explain monitoring script line by line
- [ ] Modify cron schedule
- [ ] Start/stop cron service (crond)

### Study Defense Questions
- [ ] What is a virtual machine?
- [ ] Why did you choose Rocky Linux?
- [ ] Difference between Rocky Linux and Debian
- [ ] What is SELinux?
- [ ] SELinux vs AppArmor
- [ ] What is LVM?
- [ ] What is firewalld?
- [ ] firewalld vs UFW
- [ ] What is SSH?
- [ ] What is sudo?
- [ ] What is DNF/YUM?
- [ ] Difference between DNF and APT
- [ ] Explain password policy rules
- [ ] Explain monitoring script functionality

### Final Checks
- [ ] Create a VM snapshot (for backup)
- [ ] Verify all services start on boot
- [ ] Test all functionality one more time
- [ ] Review all configuration files
- [ ] Ensure you understand every change you made
- [ ] Prepare to explain design choices
- [ ] Review QUICK_REFERENCE.md for commands

## Common Issues and Solutions

### Issue: Can't sudo
**Solution:**
- Boot into recovery mode
- Mount root as read-write: `mount -o remount,rw /`
- Edit sudoers: `visudo`
- Add user to wheel group: `usermod -aG wheel <username>`

### Issue: SSH Connection Refused
**Solution:**
- Check SSH is running: `sudo systemctl status sshd`
- Verify port forwarding in VirtualBox
- Check firewall: `sudo firewall-cmd --list-all`
- Verify SSH config: `sudo cat /etc/ssh/sshd_config`

### Issue: Monitoring Script Not Broadcasting
**Solution:**
- Check script permissions: `ls -l /usr/local/bin/monitoring.sh`
- Make executable: `sudo chmod +x /usr/local/bin/monitoring.sh`
- Verify cron is running: `sudo systemctl status crond`
- Check cron syntax: `sudo crontab -l`

### Issue: Password Doesn't Meet Policy
**Solution:**
- Ensure 10+ characters
- Include at least 1 uppercase letter
- Include at least 1 digit
- Don't use username in password
- Make it different from old password

### Issue: Forgot Encryption Password
**Solution:**
- Unfortunately, no recovery possible
- Must restart installation from scratch
- ALWAYS remember your encryption passphrase!

## Notes
- Take snapshots at important milestones
- Document all passwords securely
- Backup configuration files before editing
- Use `visudo` for sudoers, never edit directly
- Always restart services after config changes
- Test everything before evaluation
- Understand don't just copy commands

---

## Status Tracking

**Started:** _______________

**Installation completed:** _______________

**Configuration completed:** _______________

**Testing completed:** _______________

**Ready for evaluation:** _______________

**Evaluation date:** _______________

---

Good luck with your Born2BeRoot project! 🚀
