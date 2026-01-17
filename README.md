# Born2BeRoot - Complete Guide

*A comprehensive step-by-step guide for the 42 School Born2BeRoot project*

<div align="center">
  
[![42 Project](https://img.shields.io/badge/42-Project-blue)](https://42.fr)
[![Debian](https://img.shields.io/badge/Debian-Latest-red)](https://www.debian.org/)
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

Born2BeRoot is a system administration project from the 42 School curriculum that introduces students to virtualization, server configuration, and Linux system administration. The goal is to create a secure Debian virtual machine with strict configuration requirements.

### What You'll Learn

- Setting up a virtual machine with VirtualBox or UTM
- Installing and configuring Debian Linux
- Partitioning with LVM and encryption
- Implementing strong security policies
- Configuring SSH, sudo, and firewall rules
- Creating system monitoring scripts
- Understanding system administration fundamentals

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

4. **[monitoring.sh](monitoring.sh)** - The monitoring script
   - Ready-to-use monitoring script
   - Copy to your VM: `/usr/local/bin/monitoring.sh`
   - Displays system information every 10 minutes

### Quick Start

1. **Download required software:**
   - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
   - [Debian ISO (netinst)](https://www.debian.org/distrib/)

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
   - Create VM in VirtualBox (30 GB disk, 1 GB RAM)
   - Install Debian (no GUI)
   - Configure LVM with encryption
   - Apply security policies

## 📚 Documentation

### Complete Guide Contents

The complete guide covers everything you need chronologically:

1. **Virtual Machine Setup** - Creating and configuring the VM
2. **Debian Installation** - Step-by-step OS installation
3. **Partition Configuration** - LVM with encrypted partitions
4. **System Configuration** - Initial system setup
5. **User and Group Management** - Creating users and groups
6. **Sudo Configuration** - Strict sudo rules and logging
7. **SSH Configuration** - Secure SSH on port 4242
8. **UFW Firewall Setup** - Configuring the firewall
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
- UFW firewall commands
- System information
- Service management
- Defense Q&A
- Troubleshooting

## 📊 Project Overview

### Mandatory Requirements

- ✅ Virtual machine using VirtualBox or UTM
- ✅ Latest stable Debian (no graphical interface)
- ✅ LVM with at least 2 encrypted partitions
- ✅ SSH service on port 4242 only
- ✅ UFW firewall configured
- ✅ Strong password policy implemented
- ✅ Sudo configured with strict rules
- ✅ Monitoring script displaying system info every 10 minutes

### Bonus Requirements

- ✅ Complex partition structure (multiple logical volumes)
- ✅ WordPress website with Lighttpd, MariaDB, and PHP
- ✅ Additional useful service (FTP, Fail2ban, etc.)

## 🔧 Design Choices

### Operating System: Debian

**Chosen:** Debian 12 (Bookworm) - Latest stable version

**Reasons:**
- **Stability:** Known for rock-solid stability
- **Security:** Strong security track record
- **Documentation:** Extensive documentation and community support
- **Beginner-friendly:** Easier learning curve for newcomers
- **Package Management:** APT is straightforward and well-documented

**Debian vs Rocky Linux:**

| Aspect | Debian | Rocky Linux |
|--------|--------|-------------|
| Purpose | General-purpose, community-driven | Enterprise server, RHEL clone |
| Package Manager | APT (.deb) | DNF/YUM (.rpm) |
| Release Cycle | When ready | Fixed schedule |
| Community | Large, diverse | Smaller, enterprise-focused |
| Learning Curve | Easier | Steeper |

### Security Module: AppArmor

**Chosen:** AppArmor (Debian default)

**AppArmor vs SELinux:**

| Aspect | AppArmor | SELinux |
|--------|----------|---------|
| Access Control | Path-based | Label-based |
| Complexity | Simpler configuration | More complex |
| Default OS | Debian/Ubuntu | RHEL/CentOS |
| Granularity | Less granular | More granular |
| Learning Curve | Easier | Steeper |

### Firewall: UFW

**Chosen:** UFW (Uncomplicated Firewall)

**UFW vs firewalld:**

| Aspect | UFW | firewalld |
|--------|-----|-----------|
| Interface | Simple, user-friendly | Feature-rich, complex |
| Default OS | Debian/Ubuntu | RHEL/CentOS |
| Zone Concept | Single zone | Multiple zones |
| Rule Management | Static | Dynamic |
| Ease of Use | Very easy | Moderate |

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
- `sda5` (encrypted) - Contains LVM physical volume
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
- [Debian Official Documentation](https://www.debian.org/doc/)
- [VirtualBox Documentation](https://www.virtualbox.org/wiki/Documentation)
- [Linux man pages](https://man7.org/linux/man-pages/)

### Useful Guides
- [SSH Configuration](https://www.ssh.com/academy/ssh/config)
- [UFW Guide](https://help.ubuntu.com/community/UFW)
- [Sudo Manual](https://www.sudo.ws/docs/man/sudo.man/)
- [LVM Documentation](https://tldp.org/HOWTO/LVM-HOWTO/)

### 42 School
- [42 School](https://42.fr)
- [Born2BeRoot Subject](https://github.com/pasqualerossi/Born2BeRoot-Guide)

## 🎓 Defense Tips

1. **Understand, don't memorize** - Know why each configuration exists
2. **Practice commands** - Be comfortable with all operations
3. **Explain your choices** - Justify why you chose Debian, LVM structure, etc.
4. **Test everything** - Ensure all requirements work before evaluation
5. **Know the monitoring script** - Understand every line
6. **Be ready to modify** - Practice changing hostname, creating users, etc.

## ✅ Pre-Evaluation Checklist

Before your evaluation, verify:

- [ ] Hostname follows format (login42)
- [ ] UFW is active with only required ports open
- [ ] SSH works on port 4242 (root login disabled)
- [ ] User is in correct groups (sudo, user42)
- [ ] Password policy is enforced
- [ ] Sudo logs are working
- [ ] Monitoring script broadcasts every 10 minutes
- [ ] Can create/delete users
- [ ] Can modify hostname
- [ ] Understand partition structure
- [ ] Can explain all design choices

## 🤝 Contributing

This is a personal project guide. Feel free to fork and adapt it to your needs!

## 📝 License

This project is open source and available under the MIT License.

## 👤 Author

**yoabied** - 42 School Student

---

*This guide is designed to help you understand and complete the Born2BeRoot project. Read thoroughly, understand each step, and good luck with your evaluation!* 🚀

![Born2BeRoot](https://media.licdn.com/dms/image/v2/D5622AQG9dFW02IU-9A/feedshare-shrink_800/B56ZbYPI9nGoAo-/0/1747384573418?e=2147483647&v=beta&t=m3boBsHH2ilW3Tp01yPlAEz0wWAruQxbOWOQ-2MtaVo)
