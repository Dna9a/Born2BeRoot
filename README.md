# Born2BeRoot - Complete Guide

*A comprehensive step-by-step guide for the 42 School Born2BeRoot project*

<div align="center">
  
[![42 Project](https://img.shields.io/badge/42-Project-blue)](https://42.fr)
[![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-Latest-green)](https://rockylinux.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Getting Started](#getting-started)
- [Documentation](#documentation)
- [Project Overview](#project-overview)
- [Design Choices](#design-choices)
- [Resources](#resources)

## 🎯 About the Project

Born2BeRoot is a system administration project from the 42 School curriculum that introduces students to virtualization, server configuration, and Linux system administration. The goal is to create a secure Rocky Linux virtual machine with strict configuration requirements.

### What You'll Learn

- Setting up a virtual machine with VirtualBox or UTM
- Installing and configuring Rocky Linux
- Partitioning with LVM and encryption
- Implementing strong security policies with SELinux
- Configuring SSH, sudo, and firewall rules
- Creating system monitoring scripts
- Understanding enterprise Linux system administration

## 🚀 Getting Started

This repository contains all the resources you need to complete the Born2BeRoot project successfully.

### Documentation Files

1. **[COMPLETE_GUIDE.md](COMPLETE_GUIDE.md)** - The main comprehensive guide
   - Step-by-step installation instructions
   - Detailed configuration for all requirements
   - Bonus setup (WordPress and additional services)
   - Defense preparation

2. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick command reference
   - All essential commands in one place
   - Defense questions and answers
   - Troubleshooting guide
   - Quick test checklist

3. **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)** - Interactive checklist
   - Track your progress through the setup
   - Verify each requirement is met
   - Prepare for evaluation

4. **[PARTITION_GUIDE.md](PARTITION_GUIDE.md)** - Partition structure explained
   - Visual diagrams of disk layout
   - LVM and encryption explained
   - Expected `lsblk` output
   - Tips for managing partitions

5. **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Problem solving guide
   - Common issues and solutions
   - Emergency recovery procedures
   - Debugging commands
   - Prevention tips

6. **[monitoring.sh](monitoring.sh)** - The monitoring script
   - Ready-to-use monitoring script
   - Copy to your VM: `/usr/local/bin/monitoring.sh`
   - Displays system information every 10 minutes

### Quick Start

1. **Download required software:**
   - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
   - [Rocky Linux ISO (Minimal)](https://rockylinux.org/download)

2. **Follow the guide:**
   ```bash
   # Read the complete guide
   cat COMPLETE_GUIDE.md
   
   # Use the checklist to track progress
   cat SETUP_CHECKLIST.md
   
   # Reference commands during setup
   cat QUICK_REFERENCE.md
   ```

3. **Set up your VM:**
   - Create VM in VirtualBox (30 GB disk, 2 GB RAM)
   - Install Rocky Linux (no GUI - Minimal Install)
   - Configure LVM with encryption
   - Apply security policies

## 📚 Documentation

### Complete Guide Contents

The complete guide covers everything you need chronologically:

1. **Virtual Machine Setup** - Creating and configuring the VM
2. **Rocky Linux Installation** - Step-by-step OS installation
3. **Partition Configuration** - LVM with encrypted partitions
4. **System Configuration** - Initial system setup
5. **User and Group Management** - Creating users and groups
6. **Sudo Configuration** - Strict sudo rules and logging
7. **SSH Configuration** - Secure SSH on port 4242
8. **Firewalld Setup** - Configuring the firewall
9. **Password Policy** - Strong password requirements
10. **Monitoring Script** - System monitoring automation
11. **Bonus: WordPress** - Web server setup (optional)
12. **Testing and Verification** - Ensuring everything works
13. **Defense Preparation** - Questions and answers

### Quick Reference Contents

Quick access to all commands you'll need:

- User management commands
- Password management
- Sudo configuration
- SSH management
- Firewalld commands
- System information
- Service management
- Defense Q&A
- Troubleshooting

## 📊 Project Overview

### Mandatory Requirements

- ✅ Virtual machine using VirtualBox or UTM
- ✅ Latest stable Rocky Linux (no graphical interface)
- ✅ LVM with at least 2 encrypted partitions
- ✅ SSH service on port 4242 only
- ✅ firewalld configured
- ✅ Strong password policy implemented
- ✅ Sudo configured with strict rules
- ✅ Monitoring script displaying system info every 10 minutes

### Bonus Requirements

- ✅ Complex partition structure (multiple logical volumes)
- ✅ WordPress website with Apache (httpd), MariaDB, and PHP
- ✅ Additional useful service (FTP, Fail2ban, etc.)

## 🔧 Design Choices

### Operating System: Rocky Linux

**Chosen:** Rocky Linux 9 - Latest stable version

**Reasons:**
- **Enterprise-grade:** Binary compatible with RHEL
- **Stability:** Rock-solid reliability for production use
- **Community-driven:** Strong community support post-CentOS
- **SELinux:** Advanced security features built-in
- **Package Management:** DNF/YUM is industry-standard for enterprise

**Rocky Linux vs Debian:**

| Aspect | Rocky Linux | Debian |
|--------|-------------|--------|
| Purpose | Enterprise server, RHEL clone | General-purpose, community-driven |
| Package Manager | DNF/YUM (.rpm) | APT (.deb) |
| Release Cycle | Fixed schedule | When ready |
| Community | Enterprise-focused | Large, diverse |
| Learning Curve | Steeper | Easier |
| SELinux | Default | Optional |

### Security Module: SELinux

**Chosen:** SELinux (Rocky Linux default)

**SELinux vs AppArmor:**

| Aspect | SELinux | AppArmor |
|--------|---------|----------|
| Access Control | Label-based | Path-based |
| Complexity | More complex | Simpler configuration |
| Default OS | RHEL/CentOS/Rocky | Debian/Ubuntu |
| Granularity | More granular | Less granular |
| Learning Curve | Steeper | Easier |

### Firewall: firewalld

**Chosen:** firewalld (Rocky Linux default)

**firewalld vs UFW:**

| Aspect | firewalld | UFW |
|--------|-----------|-----|
| Interface | Feature-rich, complex | Simple, user-friendly |
| Default OS | RHEL/CentOS/Rocky | Debian/Ubuntu |
| Zone Concept | Multiple zones | Single zone |
| Rule Management | Dynamic | Static |
| Ease of Use | Moderate | Very easy |

### Virtualization: VirtualBox

**Chosen:** VirtualBox (or UTM for Mac M1/M2)

**VirtualBox vs UTM:**

| Aspect | VirtualBox | UTM |
|--------|------------|-----|
| Platforms | Windows, Linux, Intel Mac | Apple Silicon Mac |
| Performance | Good on x86 | Optimized for ARM |
| Features | Mature, feature-rich | Modern, growing |
| Free/Open Source | Yes | Yes |
| Learning Curve | Easier | Moderate |

### Partition Structure

**Design:** Encrypted LVM with separate logical volumes

**Partitions:**
- `/boot` (500 MB) - Unencrypted, for bootloader
- `sda2` (encrypted) - Contains LVM physical volume
  - `root` (10 GB) - System files
  - `swap` (2.3 GB) - Swap space
  - `home` (5 GB) - User home directories
  - `var` (3 GB) - Variable data
  - `srv` (3 GB) - Service data
  - `tmp` (3 GB) - Temporary files
  - `var-log` (4 GB) - Log files

**Benefits:**
- Security through encryption
- Flexibility in resizing
- Separation of concerns
- Better performance and organization

## 📖 Resources

### Official Documentation
- [Rocky Linux Documentation](https://docs.rockylinux.org/)
- [VirtualBox Documentation](https://www.virtualbox.org/wiki/Documentation)
- [SELinux Project](https://github.com/SELinuxProject)
- [firewalld Documentation](https://firewalld.org/documentation/)

### Useful Guides
- [SSH Configuration](https://www.ssh.com/academy/ssh/config)
- [firewalld Guide](https://firewalld.org/)
- [Sudo Manual](https://www.sudo.ws/docs/man/sudo.man/)
- [LVM Documentation](https://tldp.org/HOWTO/LVM-HOWTO/)
- [SELinux User Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/)

### 42 School
- [42 School](https://42.fr)
- [Born2BeRoot Project](https://github.com/topics/born2beroot)

## 🎓 Defense Tips

1. **Understand, don't memorize** - Know why each configuration exists
2. **Practice commands** - Be comfortable with all operations
3. **Explain your choices** - Justify why you chose Rocky Linux, LVM structure, etc.
4. **Test everything** - Ensure all requirements work before evaluation
5. **Know the monitoring script** - Understand every line
6. **Be ready to modify** - Practice changing hostname, creating users, etc.

## ✅ Pre-Evaluation Checklist

Before your evaluation, verify:

- [ ] Hostname follows format (login42)
- [ ] firewalld is active with only required ports open
- [ ] SSH works on port 4242 (root login disabled)
- [ ] User is in correct groups (wheel, user42)
- [ ] Password policy is enforced
- [ ] Sudo logs are working
- [ ] Monitoring script broadcasts every 10 minutes
- [ ] Can create/delete users
- [ ] Can modify hostname
- [ ] Understand partition structure
- [ ] Can explain all design choices
- [ ] SELinux is enforcing

## 🤝 Contributing

This is a personal project guide. Feel free to fork and adapt it to your needs!

## 📝 License

This project is open source and available under the MIT License.

## 👤 Author

**yoabied** - 42 School Student

---

*This guide is designed to help you understand and complete the Born2BeRoot project using Rocky Linux. Read thoroughly, understand each step, and good luck with your evaluation!* 🚀

![Born2BeRoot](https://media.licdn.com/dms/image/v2/D5622AQG9dFW02IU-9A/feedshare-shrink_800/B56ZbYPI9nGoAo-/0/1747384573418?e=2147483647&v=beta&t=m3boBsHH2ilW3Tp01yPlAEz0wWAruQxbOWOQ-2MtaVo)
