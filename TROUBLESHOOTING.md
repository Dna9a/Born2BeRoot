# Born2BeRoot Troubleshooting Guide - Rocky Linux Edition

This guide covers common issues you might encounter during the Born2BeRoot project using Rocky Linux and their solutions.

## Table of Contents
- [Installation Issues](#installation-issues)
- [Partition and Encryption Issues](#partition-and-encryption-issues)
- [User and Permission Issues](#user-and-permission-issues)
- [Sudo Issues](#sudo-issues)
- [SSH Issues](#ssh-issues)
- [Firewalld Issues](#firewalld-issues)
- [Password Policy Issues](#password-policy-issues)
- [Monitoring Script Issues](#monitoring-script-issues)
- [Network Issues](#network-issues)
- [Bonus Issues](#bonus-issues)
- [General System Issues](#general-system-issues)

---

## Installation Issues

### Issue: "No installable kernel found"
**Symptoms:** Installation fails with kernel error

**Solutions:**
1. Re-download the Rocky Linux ISO (file may be corrupted)
2. Verify the ISO checksum from Rocky Linux website
3. Use the Minimal or Boot ISO version
4. Check VM settings - ensure enough RAM (2 GB minimum for Rocky)

### Issue: Can't find network mirrors
**Symptoms:** Package manager can't connect during installation

**Solutions:**
1. Ensure network adapter is enabled in Installation Summary
2. Turn ON the ethernet switch in Network & Hostname
3. After installation, check network:
   ```bash
   ip a
   sudo nmcli device status
   sudo nmcli connection up <connection-name>
   ```

### Issue: Installation freezes during package installation
**Symptoms:** Installation hangs at "Installing packages"

**Solutions:**
1. Wait patiently (can take 10-30 minutes)
2. Increase VM RAM allocation if possible
3. Restart installation with fewer packages selected

---

## Partition and Encryption Issues

### Issue: Forgot encryption password
**Symptoms:** Can't boot into system, stuck at encryption prompt

**Solution:**
- **No recovery possible without the password**
- You must reinstall from scratch
- Always write down your encryption password!

**Prevention:**
- Write down the encryption password immediately
- Use a password you won't forget
- Consider using a password manager during installation

### Issue: Can't create encrypted partition
**Symptoms:** Option for encryption is grayed out or not working

**Solutions:**
1. In Installation Destination, choose "Custom" storage configuration
2. When adding mount points, check the "Encrypt my data" checkbox
3. Rocky installer will prompt for encryption passphrase
4. Ensure you're creating LVM volumes, not standard partitions (except /boot)

### Issue: LVM partitions not showing up
**Symptoms:** After creating LVM, partitions aren't visible

**Solutions:**
```bash
# Scan for volume groups
sudo vgscan

# Activate volume groups
sudo vgchange -ay

# Check logical volumes
sudo lvs
sudo lvscan
```

### Issue: "No space left" but `df` shows free space
**Symptoms:** Disk full errors but space appears available

**Solutions:**
```bash
# Check inode usage (might be full)
df -i

# Check actual partition usage
df -h

# Check which partition is full
sudo du -h --max-depth=1 /

# Find large files
sudo find / -type f -size +100M 2>/dev/null
```

---

## User and Permission Issues

### Issue: User not in sudo group
**Symptoms:** "user is not in the sudoers file" error

**Solutions:**
```bash
# Switch to root
su -

# Add user to wheel group (Rocky's sudo group)
usermod -aG wheel <username>

# Verify
groups <username>

# User needs to logout and login again for changes to take effect
exit
su - <username>
```

### Issue: Can't login as user after creation
**Symptoms:** Authentication failure with correct password

**Solutions:**
```bash
# As root, check if user exists
cat /etc/passwd | grep <username>

# Check if home directory exists
ls -la /home/<username>

# Reset password
passwd <username>

# Ensure shell is set correctly
usermod -s /bin/bash <username>
```

### Issue: Permission denied when accessing files
**Symptoms:** Can't read/write files as user

**Solutions:**
```bash
# Check file permissions
ls -l <file>

# Check file ownership
ls -l <file>

# Fix ownership
sudo chown <username>:<group> <file>

# Fix permissions
sudo chmod 644 <file>  # For regular files
sudo chmod 755 <file>  # For executables
```

---

## Sudo Issues

### Issue: Sudo not working after visudo edit
**Symptoms:** Can't use sudo, or syntax error in sudoers

**Solutions:**
```bash
# Boot into recovery mode
# At GRUB menu, select Advanced Options → Recovery Mode

# Mount filesystem as read-write
mount -o remount,rw /

# Fix sudoers file
visudo

# Or restore backup
cp /etc/sudoers.backup /etc/sudoers

# Reboot
reboot
```

### Issue: Sudo logs not being created
**Symptoms:** /var/log/sudo/ is empty

**Solutions:**
```bash
# Check if directory exists
ls -la /var/log/sudo/

# Create if missing
sudo mkdir -p /var/log/sudo

# Set correct permissions
sudo chmod 755 /var/log/sudo

# Verify sudoers configuration
sudo cat /etc/sudoers | grep logfile

# Test sudo and check
sudo ls
sudo cat /var/log/sudo/sudo.log
```

### Issue: "Sorry, user X may not run sudo on hostname"
**Symptoms:** User can't use sudo despite being in wheel group

**Solutions:**
```bash
# Check user groups (as root)
su -
groups <username>

# Add to wheel group if missing
usermod -aG wheel <username>

# Force group file refresh
newgrp wheel

# User must logout and login again
exit
su - <username>
```

---

## SSH Issues

### Issue: SSH connection refused
**Symptoms:** Can't connect via SSH from host machine

**Solutions:**
```bash
# Check if SSH is running
sudo systemctl status sshd

# If not running, start it
sudo systemctl start sshd

# Enable at boot
sudo systemctl enable sshd

# Check if listening on correct port
sudo ss -tunlp | grep 4242

# Check firewall
sudo firewall-cmd --list-all

# Allow SSH port if blocked
sudo firewall-cmd --permanent --add-port=4242/tcp
sudo firewall-cmd --reload
```

### Issue: "Port 4242 already in use"
**Symptoms:** Can't start SSH or bind to port

**Solutions:**
```bash
# Check what's using the port
sudo lsof -i :4242
sudo ss -tulpn | grep 4242

# Kill the process using the port
sudo kill <PID>

# Restart SSH
sudo systemctl restart sshd
```

### Issue: VirtualBox port forwarding not working
**Symptoms:** Can SSH within VM but not from host

**Solutions:**
1. Power off the VM completely
2. Go to VM Settings → Network → Adapter 1
3. Click "Advanced" → "Port Forwarding"
4. Add rule:
   - Name: SSH
   - Protocol: TCP
   - Host IP: 127.0.0.1
   - Host Port: 4242
   - Guest IP: (leave empty)
   - Guest Port: 4242
5. Click OK and start VM
6. Test: `ssh username@localhost -p 4242`

### Issue: "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED"
**Symptoms:** SSH gives security warning

**Solution:**
```bash
# Remove old host key
ssh-keygen -R "[localhost]:4242"

# Or remove entire known_hosts
rm ~/.ssh/known_hosts

# Try connecting again
ssh username@localhost -p 4242
```

---

## Firewalld Issues

### Issue: Firewalld rules not persisting after reboot
**Symptoms:** Firewall rules disappear after restart

**Solutions:**
```bash
# Always use --permanent flag
sudo firewall-cmd --permanent --add-port=4242/tcp
sudo firewall-cmd --reload

# Make sure firewalld is enabled at boot
sudo systemctl enable firewalld

# Check status
sudo systemctl status firewalld
```

### Issue: Locked out after enabling firewalld
**Symptoms:** Can't SSH after enabling firewall

**Solutions:**
1. Access VM directly (not via SSH)
2. Allow SSH port:
   ```bash
   sudo firewall-cmd --permanent --add-port=4242/tcp
   sudo firewall-cmd --reload
   ```
3. Or disable firewalld temporarily:
   ```bash
   sudo systemctl stop firewalld
   sudo firewall-cmd --permanent --add-port=4242/tcp
   sudo systemctl start firewalld
   ```

### Issue: Can't delete firewalld rule
**Symptoms:** Delete command doesn't work

**Solutions:**
```bash
# List all rules
sudo firewall-cmd --list-all

# Remove specific port
sudo firewall-cmd --permanent --remove-port=4242/tcp
sudo firewall-cmd --reload

# Remove specific service
sudo firewall-cmd --permanent --remove-service=ssh
sudo firewall-cmd --reload

# Reset to default (careful!)
sudo firewall-cmd --complete-reload
```

### Issue: Firewalld not starting
**Symptoms:** Service fails to start

**Solutions:**
```bash
# Check for errors
sudo systemctl status firewalld
sudo journalctl -u firewalld -n 50

# Reinstall if corrupted
sudo dnf reinstall firewalld -y

# Reset configuration
sudo rm -rf /etc/firewalld/zones/*
sudo firewall-cmd --reload
```

---

## Password Policy Issues

### Issue: Password doesn't meet policy but error is unclear
**Symptoms:** Can't change password, vague error message

**Checklist:**
- [ ] At least 10 characters long
- [ ] Contains at least 1 uppercase letter
- [ ] Contains at least 1 digit
- [ ] Does not contain username
- [ ] Has at least 7 characters different from old password
- [ ] No more than 3 consecutive identical characters

**Test:**
```bash
# Good password examples:
Password123
MySecure42Pass
Strong1Pass

# Bad password examples (and why):
password123    # No uppercase
Password       # No digit
Pass123        # Too short
username123    # Contains username
aaaa1234       # More than 3 consecutive same characters
```

### Issue: Password policy not applying to root
**Symptoms:** Root can set weak passwords

**Solution:**
```bash
# Edit password quality configuration
sudo vim /etc/security/pwquality.conf

# Ensure enforce_for_root is present (uncommented):
enforce_for_root
```

### Issue: Existing users not following password policy
**Symptoms:** Old passwords don't meet new requirements

**Solution:**
```bash
# Force password change on next login
sudo chage -d 0 <username>

# Or change password manually
sudo passwd <username>
# (New password must meet policy)
```

### Issue: Password quality module not working
**Symptoms:** Weak passwords are accepted

**Solutions:**
```bash
# Check if libpwquality is installed
rpm -q libpwquality

# Install if missing
sudo dnf install libpwquality -y

# Verify configuration
sudo cat /etc/security/pwquality.conf | grep -v "^#" | grep -v "^$"

# Test password quality
pwscore
# Type a password and press Ctrl+D to see its score
```

---

## Monitoring Script Issues

### Issue: Monitoring script not broadcasting
**Symptoms:** No wall messages appearing

**Solutions:**
```bash
# Check if script exists
ls -l /usr/local/bin/monitoring.sh

# Make executable
sudo chmod +x /usr/local/bin/monitoring.sh

# Test manually
sudo /usr/local/bin/monitoring.sh

# Check cron is running
sudo systemctl status crond

# Check cron jobs
sudo crontab -l

# If cron job missing, add it:
sudo crontab -e
# Add: */10 * * * * /usr/local/bin/monitoring.sh
```

### Issue: Script broadcasts but shows errors
**Symptoms:** Wall messages appear but with error output

**Solutions:**
```bash
# Run script manually to see errors
sudo /usr/local/bin/monitoring.sh

# Common fixes:
# If vmstat not found:
sudo dnf install procps-ng -y

# If wall not found:
sudo dnf install util-linux -y

# Check script syntax
bash -n /usr/local/bin/monitoring.sh
```

### Issue: Cron job runs but script doesn't
**Symptoms:** Cron logs show job running but no broadcast

**Solutions:**
```bash
# Check cron logs
sudo grep CRON /var/log/cron
sudo journalctl -u crond

# Ensure script path is absolute
sudo crontab -e
# Use: */10 * * * * /usr/local/bin/monitoring.sh
# Not: */10 * * * * monitoring.sh

# Check script permissions
ls -l /usr/local/bin/monitoring.sh
# Should show: -rwxr-xr-x
```

### Issue: Script shows incorrect information
**Symptoms:** Values in broadcast are wrong or empty

**Solutions:**
```bash
# Test each command individually
uname -a
grep "physical id" /proc/cpuinfo | wc -l
free -m
df -m | grep "/dev/"
ss -ta | grep ESTAB

# Check if required commands are installed
which vmstat
which ss
which free

# Install missing tools
sudo dnf install procps-ng net-tools -y
```

---

## Network Issues

### Issue: No network connectivity in VM
**Symptoms:** Can't ping outside network, can't update packages

**Solutions:**
1. Check VM network adapter type (should be NAT or Bridged)
2. In VirtualBox: Settings → Network → Adapter 1 → Attached to: NAT
3. Inside VM:
   ```bash
   # Check network interfaces
   ip a
   nmcli device status
   
   # Restart networking
   sudo systemctl restart NetworkManager
   
   # Check if interface is up
   sudo nmcli connection up <connection-name>
   
   # Test connectivity
   ping -c 4 8.8.8.8
   ping -c 4 google.com
   ```

### Issue: "Temporary failure in name resolution"
**Symptoms:** Can ping IP addresses but not domain names

**Solutions:**
```bash
# Check DNS configuration
cat /etc/resolv.conf

# If empty or wrong, configure with NetworkManager:
sudo nmcli connection modify <connection-name> ipv4.dns "8.8.8.8 8.8.4.4"
sudo nmcli connection down <connection-name>
sudo nmcli connection up <connection-name>

# Or edit resolv.conf directly (temporary):
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf

# Restart NetworkManager
sudo systemctl restart NetworkManager
```

---

## Bonus Issues

### Issue: WordPress shows "Error establishing database connection"
**Symptoms:** WordPress site doesn't load

**Solutions:**
```bash
# Check MariaDB is running
sudo systemctl status mariadb

# Start if stopped
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Verify database exists
sudo mysql -u root -p
SHOW DATABASES;
# Should see 'wordpress' database
EXIT;

# Check wp-config.php settings
sudo cat /var/www/html/wordpress/wp-config.php | grep DB_
# Ensure DB_NAME, DB_USER, DB_PASSWORD match your MariaDB setup

# Check SELinux context
sudo ls -Z /var/www/html/wordpress/
sudo restorecon -Rv /var/www/html/
```

### Issue: Lighttpd not starting
**Symptoms:** Web server won't start

**Solutions:**
```bash
# Check for errors (Rocky uses httpd/Apache)
sudo systemctl status httpd
sudo journalctl -u httpd -n 50

# Common issue: Port 80 already in use
sudo ss -tulpn | grep :80

# Kill process using port 80 (find PID first)
sudo lsof -ti:80
sudo kill <PID>

# Check SELinux is not blocking
sudo ausearch -m AVC -ts recent
sudo setsebool -P httpd_can_network_connect 1

# Restart httpd
sudo systemctl restart httpd
sudo systemctl enable httpd
```

---

## General System Issues

### Issue: System won't boot after configuration
**Symptoms:** Stuck at boot, kernel panic, or boot loop

**Solutions:**
1. **Boot into rescue mode:**
   - At GRUB menu, press 'e' for edit
   - Add `rd.break` to kernel line
   - Press Ctrl+X to boot
   
2. **Mount filesystem:**
   ```bash
   mount -o remount,rw /sysroot
   chroot /sysroot
   ```

3. **Check recent changes:**
   ```bash
   # Check last modified files
   find /etc -type f -mmin -60
   
   # Review system logs
   journalctl -xb
   ```

4. **Restore from snapshot (if you created one)**

### Issue: Ran out of disk space
**Symptoms:** "No space left on device" errors

**Solutions:**
```bash
# Find what's using space
df -h
sudo du -h --max-depth=1 / | sort -h

# Clean package cache
sudo dnf clean all

# Clean old logs
sudo journalctl --vacuum-time=7d

# Find and remove large files
sudo find / -type f -size +100M 2>/dev/null

# Clear temporary files
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
```

### Issue: Command not found
**Symptoms:** System can't find standard commands

**Solutions:**
```bash
# Check PATH
echo $PATH

# Should include: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# If PATH is wrong, fix it:
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Make permanent by adding to ~/.bashrc
echo 'export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> ~/.bashrc
```

---

## Emergency Recovery

### If System is Completely Broken

1. **Boot from Rocky Linux installer ISO**
2. **Select "Troubleshooting" → "Rescue a Rocky Linux system"**
3. **Enter encryption password**
4. **Select shell option**
5. **Mount all partitions:**
   ```bash
   chroot /mnt/sysimage
   mount -a
   ```
6. **Fix the issue (restore configs, reinstall GRUB, etc.)**
7. **Exit and reboot:**
   ```bash
   exit
   reboot
   ```

### Creating Backups (Prevention)

```bash
# Backup important configurations
sudo mkdir -p /root/backups
sudo cp /etc/sudoers /root/backups/
sudo cp /etc/ssh/sshd_config /root/backups/
sudo cp /etc/pam.d/common-password /root/backups/
sudo cp /etc/login.defs /root/backups/

# Create a VM snapshot in VirtualBox before major changes
```

---

## Getting Help

### Useful Debugging Commands

```bash
# System logs
sudo journalctl -xe
sudo journalctl -u <service-name>

# Service status
sudo systemctl status <service>

# Check for failed services
sudo systemctl --failed

# Network diagnostics
ip a
ss -tunlp
ping -c 4 8.8.8.8

# Disk diagnostics
df -h
lsblk
sudo lvs
sudo vgs

# Process information
ps aux
top
htop
```

### Log Files to Check

- `/var/log/messages` - General system logs
- `/var/log/secure` - Authentication logs
- `/var/log/sudo/sudo.log` - Sudo command logs
- `/var/log/cron` - Cron logs
- `/var/log/firewalld` - Firewall logs
- `/var/log/audit/audit.log` - SELinux audit logs
- `journalctl -xe` - Systemd logs
- `journalctl -u <service>` - Specific service logs

---

## Prevention Tips

1. **Always create VM snapshots before major changes**
2. **Test changes before evaluating**
3. **Keep notes of all commands you run**
4. **Backup configuration files before editing**
5. **Use `visudo` instead of editing /etc/sudoers directly**
6. **Test in a separate test user account first**
7. **Read error messages carefully - they usually tell you what's wrong**
8. **Don't rush - understand what each command does**

---

Remember: Most issues can be fixed! Stay calm, read error messages, and work through problems systematically. If all else fails, you can always reinstall and start fresh with your new knowledge.

Good luck! 🍀
