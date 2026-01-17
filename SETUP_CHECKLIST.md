# Born2BeRoot Setup Checklist

## Pre-Installation
- [ ] Download VirtualBox (or UTM for Mac M1/M2)
- [ ] Download Debian ISO (netinst version)
- [ ] Create Virtual Machine with appropriate settings
  - [ ] Name: Born2BeRoot
  - [ ] Type: Linux
  - [ ] Version: Debian (64-bit)
  - [ ] Memory: 1024 MB minimum
  - [ ] Hard disk: 30 GB (8 GB for mandatory only)
  - [ ] Mount Debian ISO

## Installation Phase
- [ ] Start installation (choose "Install", not graphical)
- [ ] Select language: English
- [ ] Select location
- [ ] Select keyboard layout
- [ ] Configure network
  - [ ] Hostname: your_login42 (e.g., yoabied42)
  - [ ] Domain: leave empty
- [ ] Set up users and passwords
  - [ ] Root password (strong, follows policy)
  - [ ] Create user account (your 42 login)
  - [ ] User password (strong, follows policy)

## Partition Configuration
- [ ] Select "Manual" partitioning
- [ ] Create /boot partition (500 MB, Primary, Ext4)
- [ ] Create encrypted partition (remaining space, Logical)
- [ ] Configure encrypted volumes
  - [ ] Set encryption passphrase (remember this!)
- [ ] Configure LVM
  - [ ] Create volume group: LVMGroup (or login42)
  - [ ] Create logical volumes:
    - [ ] root: 10 GB
    - [ ] swap: 2.3 GB
    - [ ] home: 5 GB
    - [ ] var: 3 GB
    - [ ] srv: 3 GB
    - [ ] tmp: 3 GB
    - [ ] var-log: 4 GB (or remaining)
- [ ] Format each logical volume with appropriate filesystem
- [ ] Set correct mount points for each volume

## Complete Installation
- [ ] Configure package manager
  - [ ] Debian mirror country
  - [ ] Mirror: deb.debian.org
  - [ ] HTTP proxy: (leave empty)
- [ ] Software selection
  - [ ] UNCHECK all desktop environments
  - [ ] Keep: SSH server, standard system utilities
- [ ] Install GRUB bootloader on /dev/sda
- [ ] Complete installation and reboot

## Post-Installation - System Configuration
- [ ] Login as root
- [ ] Update system
  ```bash
  apt update
  apt upgrade -y
  ```
- [ ] Install required packages
  ```bash
  apt install sudo vim ufw libpam-pwquality -y
  ```
- [ ] Verify installation
  - [ ] Check Debian version: `cat /etc/os-release`
  - [ ] Check partitions: `lsblk`
  - [ ] Check LVM: `lvdisplay`, `vgdisplay`

## User and Group Management
- [ ] Create user42 group
  ```bash
  groupadd user42
  getent group user42
  ```
- [ ] Add your user to groups
  ```bash
  usermod -aG sudo,user42 <username>
  groups <username>
  ```
- [ ] Verify user is in correct groups

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
- [ ] Edit SSH config: `sudo vim /etc/ssh/sshd_config`
  - [ ] Change Port to 4242
  - [ ] Set PermitRootLogin to no
- [ ] Restart SSH: `sudo systemctl restart ssh`
- [ ] Verify SSH status: `sudo systemctl status ssh`
- [ ] Check port: `sudo ss -tunlp | grep 4242`
- [ ] Configure VirtualBox port forwarding
  - [ ] VM Settings → Network → Port Forwarding
  - [ ] Add rule: Host Port 4242 → Guest Port 4242
- [ ] Test SSH connection from host
  ```bash
  ssh <username>@localhost -p 4242
  ```

## UFW Firewall Setup
- [ ] Enable UFW
  ```bash
  sudo ufw enable
  ```
- [ ] Allow SSH port
  ```bash
  sudo ufw allow 4242
  ```
- [ ] Verify status
  ```bash
  sudo ufw status numbered
  ```
- [ ] Confirm only port 4242 is open

## Password Policy
- [ ] Edit PAM configuration: `sudo vim /etc/pam.d/common-password`
  - [ ] Configure pam_pwquality.so with all requirements:
    - [ ] retry=3
    - [ ] minlen=10
    - [ ] ucredit=-1
    - [ ] dcredit=-1
    - [ ] maxrepeat=3
    - [ ] reject_username
    - [ ] difok=7
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
- [ ] Verify cron is running: `sudo systemctl status cron`
- [ ] Wait 10 minutes and verify broadcast appears

## Bonus: WordPress Setup (Optional)
- [ ] Install packages
  ```bash
  sudo apt install lighttpd mariadb-server php-cgi php-mysql wget -y
  ```
- [ ] Configure Lighttpd
  - [ ] Enable FastCGI modules
  - [ ] Restart service
  - [ ] Allow port 80 in firewall
- [ ] Secure MariaDB
  ```bash
  sudo mysql_secure_installation
  ```
- [ ] Create WordPress database and user
- [ ] Download and install WordPress
- [ ] Configure wp-config.php
- [ ] Set proper permissions
- [ ] Access via browser

## Bonus: Additional Service (Optional)
- [ ] Choose and install additional service (not NGINX/Apache2)
  - Examples: FTP server, Fail2ban, Redis, etc.
- [ ] Configure service
- [ ] Document why you chose this service

## Testing and Verification

### System Verification
- [ ] Check Debian version: `cat /etc/os-release`
- [ ] Verify no GUI: `ls /usr/bin/*session`
- [ ] Check AppArmor: `sudo aa-status`

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
- [ ] Check SSH status: `sudo systemctl status ssh`
- [ ] Verify port 4242: `sudo ss -tunlp | grep 4242`
- [ ] Confirm root login disabled: `sudo grep PermitRootLogin /etc/ssh/sshd_config`
- [ ] Test SSH connection from host machine

### UFW Verification
- [ ] Check firewall status: `sudo ufw status numbered`
- [ ] Verify only port 4242 (and 80 for bonus) is open

### Password Policy Verification
- [ ] Check PAM config: `sudo cat /etc/pam.d/common-password | grep pam_pwquality`
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
- [ ] Verify cron service: `sudo systemctl status cron`
- [ ] Confirm broadcast appears every 10 minutes

## Defense Preparation

### Practice Commands
- [ ] Create a new user
- [ ] Delete a user
- [ ] Add user to group
- [ ] Remove user from group
- [ ] Change password
- [ ] Check password policy for user
- [ ] Modify hostname
- [ ] Add UFW rule
- [ ] Delete UFW rule
- [ ] View sudo logs
- [ ] Explain monitoring script line by line
- [ ] Modify cron schedule
- [ ] Start/stop cron service

### Study Defense Questions
- [ ] What is a virtual machine?
- [ ] Why did you choose Debian?
- [ ] Difference between Debian and Rocky Linux
- [ ] What is AppArmor?
- [ ] AppArmor vs SELinux
- [ ] What is LVM?
- [ ] What is UFW?
- [ ] UFW vs firewalld
- [ ] What is SSH?
- [ ] What is sudo?
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
- Add user to sudo group: `usermod -aG sudo <username>`

### Issue: SSH Connection Refused
**Solution:**
- Check SSH is running: `sudo systemctl status ssh`
- Verify port forwarding in VirtualBox
- Check firewall: `sudo ufw status`
- Verify SSH config: `sudo cat /etc/ssh/sshd_config`

### Issue: Monitoring Script Not Broadcasting
**Solution:**
- Check script permissions: `ls -l /usr/local/bin/monitoring.sh`
- Make executable: `sudo chmod +x /usr/local/bin/monitoring.sh`
- Verify cron is running: `sudo systemctl status cron`
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
