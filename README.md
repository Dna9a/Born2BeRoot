## *This project has been created as part of the 42 curriculum by yoabied.* 
<!-- 9sem -->
<div style="display: flex; justify-content: space-between; align-items: center;">
  <span style="font-size: 45px;">📄</span>
  <span style="font-size: 40px;">🐪</span>
</div>

## 📑 Table of Contents

- [Description](#description)
- [Instructions](#instructions)
- [Project Description](#project-description)
- [Operating System & Design Choices](#operating-system--design-choices)
- [Disk Partitioning](#disk-partitioning)
- [Text Mode (CLI)](#text-mode-cli)
- [Configuration Cheatsheet](#configuration-cheatsheet)
- [WordPress & Lighttpd](#wordpress--lighttpd)
- [Game Hosting](#game-hosting)
- [Monitoring Script](#monitoring-script)
- [Resources](#resources)
- [Conclusion](#conclusion)



<!-- # Description-->
# Description
## Virtualization

Virtualization is a technology used to create virtual representations of `servers`, `storage`, `networks`, and `other physical machines`. Virtualization software `mimics` the functions of physical hardware, allowing multiple virtual machines to run simultaneously on a single physical machine. Businesses use virtualization to utilize hardware resources more efficiently and achieve better returns on their investment. It also powers cloud computing services, helping organizations `manage infrastructure` more effectively. Additionally, virtualization is a solution for limited hardware resources, as it provides users with an isolated environment. The physical machine is called the host, while the virtual machine running on it is called the guest.

## Hypervisor
It is `software` that sits in between the hardware and the VMs for the sake of managing resources for VMs. **The hypervisor** is divided into two types

![Hypervisor](https://github.com/Dna9a/Repo-s_assets/blob/main/B2R/what-is-hypervisor.jpg)

### Type 1 (Bare Metal)
This type is a **native** solution that sits directly on top of the hardware. It is capable of acting as the operating system for the physical server, such as:

![Type 1](https://www.ubackup.com/screenshot/en/acb/virtual-machine/type-1-hypervisor-vs-type-2/type-1-hypervisor-examples.png)
### Type 2 (Hosted)
It is software that sits on top of your main OS, such as:

![Type 2](https://www.ubackup.com/screenshot/en/acb/virtual-machine/type-1-hypervisor-vs-type-2/type-2-hypervisor-examples.png)

<!-- Resources -->
# Resources 
- **[Amazon + a_pdf_from_ofppt - Virtualization](https://aws.amazon.com/what-is/virtualization/)**
- **[Wikipedia - luks ](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup)**
- **[RedHat - luks](https://access.redhat.com/solutions/100463)**
- **[Peers - luks](https://profile-v3.intra.42.fr/users/amedina)** 
- **[RedHat - fdisk](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/storage_administration_guide/s2-disk-storage-parted-resize-part)**
- **[AOMEI - Hypervisor](https://www.ubackup.com/enterprise-backup/type-1-hypervisor-vs-type-2.html)**
- **[Rocky - Inst.text](https://forums.rockylinux.org/t/inst-text-not-working/4414)**
- **[Rocky - TextMode](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/installation_guide/sect-installation-text-mode-x86)**
- **[RedHat - TextMode](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/installation_guide/sect-installation-text-mode-x86)**
- **[RedHat - SElinux](https://www.redhat.com/en/topics/linux/what-is-selinux)** 

<!-- Instructions -->
# Instructions

## Installation Workflow
A followed example of me working on the approach of how does Anaconda work in `text/shell` **mode**.

![oo](https://github.com/Dna9a/Repo-s_assets/blob/main/B2R/anaconda%20bad%20text%20mode.png)

### 2. Storage Configuration (Anaconda Shell)
We bypass the automatic partitioner to perform a custom setup using `fdisk`, LUKS encryption, and LVM.

`Get yourself your OS iso` --> `You're supposed to know why you chose this last one` --> `create a machine on virtual box` 

`Language` --> `Timezone` --> `Root & User Creds` 

**(Switch to Shell)** --> `fdisk` (Partitioning) --> `LUKS` (Encryption) --> `LVM` (Logical Volumes)

**(Resume Installer)** --> `Mount Points` --> `Begin Installation`

![meme](https://i.programmerhumor.io/2025/10/c2e76d7d346a5067b76bddd6f61347d9c3d59221e88aaf341dd19583607f7a91.png)



# Project description 
On this project i involved it into setting up a secure and efficient server environment that's using Rocky Linux. The main objectives include:

![iuhm](https://media.licdn.com/dms/image/v2/D5622AQG9dFW02IU-9A/feedshare-shrink_800/B56ZbYPI9nGoAo-/0/1747384573418?e=2147483647&v=beta&t=m3boBsHH2ilW3Tp01yPlAEz0wWAruQxbOWOQ-2MtaVo)


# 🐧 Operating System & Design Choices

## 1. Choice of Operating System
For this project, I chose **Rocky** over Debian Linux because basically why not.
![Rocky](https://www.wbaboxing.com/wp-content/uploads/2023/02/rockyy.jpeg)

### Debian vs. Rocky Linux
| Feature | Debian | Rocky Linux (Selected) |
| :--- | :--- | :--- |
| **Philosophy** | Strictly open-source, community-driven project . | Enterprise-focused, bug-for-bug compatible with RHEL. |
| **Package Manager** | `APT` (Advanced Package Tool) & `.deb` packages. | `DNF` / `YUM` & `.rpm` packages. |
| **Stability** | Known for extreme stability; older but tested packages. | Stable, but follows Red Hat enterprise release cycles. |
| **Community** | Massive global community and documentation. | Smaller community (successor to CentOS). |
| **Use Case** | General purpose servers and desktops. | Corporate environments requiring RHEL compatibility. |

---

## 2. Design Choices & Policies

To ensure a secure and efficient server environment, the following configurations were implemented:

### Security Policies
*   **Password Policy:** strict rules for password complexity and expiration (via `pwquality`).
*   **Sudo:** Restricted privileges with TTY usage enforcement and log archiving.
*   **SSH:** Root login disabled, custom port (4242), and key-based authentication preferred.

### User Management
*   **Root Account:** Reserved solely for system administration tasks.
*   **Primary User:** Added to the `sudo` and `user42` groups for elevated privileges.
 
### Services Installed

![uhm](https://h4ckseed.wordpress.com/wp-content/uploads/2023/09/sin-titulo.png)

## To maintain a minimal and secure footprint, only essential services were installed:
*   **SSH (OpenSSH Server):** For remote access on port 4242.
*   **Firewalld:** For managing network traffic and ports.
*   **Cron:** For scheduling system maintenance tasks.
*   **Git:** Installed to fetch and deploy project repositories.
*   **Lighttpd & WordPress:** Hosted to serve a specific Unity-based video game project.


## 3. Technology Comparisons

### VirtualBox vs. UTM

![tm](https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2025/02/img_9627.png)
|   |VirtualBox | UTM (QEMU backend) |
| :--- | :--- |:--- |
| **Architecture** | Primarily x86 virtualization. | Supports emulation of different architectures (ARM, x86, PPC). |
| **Performance** | Excellent for x86-on-x86 virtualization. | Native speed on Apple Silicon (M-series) via Hypervisor.framework. |
| **OS Support** | Cross-platform (Windows, Linux, macOS). | Exclusive to macOS/iOS. |

---

### AppArmor vs. SELinux

![VS](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*qycA2LkdLNir9BT9.jpg)

| |AppArmor (Debian default) | SELinux (Rocky/RHEL default) |
| :--- | :--- |:--- |
| **Model** | Path-based access control. Profiles are attached to specific file paths. | Label-based access control. Files/processes are tagged with security contexts. |
| **Ease of Use** | Generally considered easier to learn and configure. | Steeper learning curve; very granular but complex. |
| **Mode** | Less intrusive; often defaults to "complain" mode. | Highly intrusive; enforces strict policies by default ("enforcing"). |

### UFW vs. Firewalld

![UFW](https://media2.dev.to/dynamic/image/width=1000,height=420,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fnyitqzs7c4h2a0d055ar.png)

| |UFW (Uncomplicated Firewall) | Firewalld |
| :--- |:--- | :--- |
| **Interface** | A simplified command-line wrapper for `iptables`/`nftables`. | A dynamic firewall manager with support for network "zones". |
| **Usage** | Designed for simplicity (e.g., `ufw allow 4242`). | Uses XML configuration and DBus. Complex zone management. |
| **Target** | Single-host servers and beginners (Debian standard). | Complex network environments (RHEL standard). |

# Disk Partitioning

## 1. LVM & LUKS Configuration
For this project, I utilized **LVM (Logical Volume Management)** within an **Encrypted (LUKS)** partition. This structure allows for dynamic resizing of partitions and ensures data security at rest.
*   `/boot`: Unencrypted (required for bootloader).
*   `LVM`: Encrypted volume containing logical volumes for `/root`, `/home`, `/var`, etc.

## 2. fdisk vs. parted: A Brief Comparison

`fdisk` and `parted` are both powerful and widely used tools for partitioning disks in Linux systems. They have their `advantages` and specific use cases, but they also differ in some key aspects.

## `fdisk`
fdisk is a widely used, text-based utility for managing disk partitions on Linux systems. It supports `creating`, `deleting`, and `modifying partitions` on a `hard disk`. While `fdisk` primarily works with MBR (Master Boot Record) partition tables, it also offers limited support for GPT (GUID Partition Table) partition tables. Some of the reasons to choose `fdisk` include:

- Familiarity: `fdisk` has been around for a long time, and many users are accustomed to using it.
- Simplicity: `fdisk` provides a straightforward interface for managing partitions, making it easier for users to accomplish their tasks.

## `parted`
`parted` is another command-line utility for partitioning hard drives on Linux systems. It is more advanced than fdisk and supports a broader range of partition table formats, including MBR and GPT. Some reasons to choose parted include:

Greater compatibility: `parted` works with a wider variety of partition tables, making it more versatile for managing modern hard drives.
Advanced features: `parted` offers more advanced functionality, such as resizing partitions without data loss.

## Text Mode (CLI)

![uhm](https://linuxconfig.org/images/redhat_7_text_installation.png)
**Text Mode**, often referred to as the Command Line Interface (CLI) or "Headless" mode, is a method of interacting with the computer using only text commands, without a Graphical User Interface (GUI) like GNOME or KDE.

**How it works:**
Instead of clicking icons, the user types commands into a shell (like Bash). The system processes these text inputs and returns text outputs.
*   **Performance:** It consumes significantly fewer resources (RAM/CPU) because the system doesn't need to render heavy graphics.
*   **Stability:** Fewer moving parts (graphical drivers, window managers) means fewer things can crash.
*   **Server Standard:** Almost all professional servers run in text mode to maximize performance for the actual services.

# ⚙️ Configuration Cheatsheet

## User & Group Management (Rocky Linux)
To fulfill the project requirements of managing groups, here are the commands used:

1.  **Check existing groups for a user:**
    ```bash
    groups <username>
    ```

2.  **Add a user to the `wheel` group (Admin/Sudo rights on Rocky):**
    ```bash
    usermod -aG wheel <username>
    ```

3.  **Add a user to the `user42` group (Project requirement):**
    ```bash
    # First, create the group if it doesn't exist
    groupadd user42
    
    # Add the user
    usermod -aG user42 <username>
    ```

## 🔥 Firewalld Configuration
Rocky Linux uses `firewalld` by default.

1.  **Check Status:**
    ```bash
    systemctl status firewalld
    ```
2.  **Add Port 4242 (SSH):**
    ```bash
    firewall-cmd --permanent --add-port=4242/tcp
    firewall-cmd --reload
    ```
3.  **List Open Ports:**
    ```bash
    firewall-cmd --list-ports
    ```

## 🌐 WordPress & Lighttpd
To set up a WordPress site using Lighttpd on Rocky Linux, follow these steps:
1.  **Install Lighttpd and PHP:**
    ```bash
    dnf install lighttpd php php-mysqlnd -y
    ```
2.  **Start and enable Lighttpd:**
    ```bash
    systemctl start lighttpd
    systemctl enable lighttpd
    ```
3.  **Download and set up WordPress:**
    ```bash
    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz
    chown -R lighttpd:lighttpd /var/www/html
    ```
4.  **Configure Lighttpd for WordPress:**
    Create a configuration file for your site:
    ```bash
    nano /etc/lighttpd/conf.d/wordpress.conf        
    ```

# 🎮 Game Hosting

# 🖥️ Monitoring Script

```shell
#!/bin/bash

ARCH=$(uname -a)

CPU_PHYSICAL=$(lscpu | awk '/Socket\(s\)/ {print $2}')
VCPU=$(lscpu | awk '/^CPU\(s\)/ {print $2}')

RAM=$(free -m | awk '/Mem:/ { printf "%d/%dMB (%.2f%%)", $3, $2, $3*100/$2 }')

DISK=$(df -m --total | awk '/total/ {printf "%d/%dMB (%s)", $3, $2, $5}')

CPU_LOAD=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.1f%%", 100 - $8}')

LAST_BOOT=$(who -b | awk '{print $3 " " $4}')

LVM_USE=$(lsblk | grep -q lvm && echo "yes" || echo "no")

TCP_CONN=$(ss -tn state established | wc -l)

USER_LOG=$(who | awk '{print $1}' | sort -u | wc -l)

IP=$(hostname -I | awk '{print $1}')

#MAC=$(ip a | grep "link/ether" | awk '{print $2}')
MAC=$(nmcli device show | grep GENERAL.HWADDR: | head -1 | awk '{printf "%s", $2}')
SUDO_CMDS=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "
#Architecture: $ARCH
#CPU physical : $CPU_PHYSICAL
#vCPU : $VCPU
#Memory Usage: $RAM
#Disk Usage: $DISK
#CPU load: $CPU_LOAD
#Last boot: $LAST_BOOT
#LVM use: $LVM_USE
#Connections TCP : $TCP_CONN ESTABLISHED
#User log: $USER_LOG
#Network: IP $IP $(echo -n "(")$MAC$(echo -n ")")
#Sudo : $SUDO_CMDS cmd
"

echo " .-----------------. .----------------.  .----------------.  .----------------.
| .--------------. || .--------------. || .--------------. || .--------------. |
| | ____  _____  | || |      __      | || |    ______    | || |      __      | |
| ||_   \|_   _| | || |     /  \     | || |  .' ____ '.  | || |     /  \     | |
| |  |   \ | |   | || |    / /\ \    | || |  | (____) |  | || |    / /\ \    | |
| |  | |\ \| |   | || |   / ____ \   | || |  '_.____. |  | || |   / ____ \   | |
| | _| |_\   |_  | || | _/ /    \ \_ | || |  | \____| |  | || | _/ /    \ \_ | |
| ||_____|\____| | || ||____|  |____|| || |   \______,'  | || ||____|  |____|| |
| |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------' "
```

# Conclusion

I've successfully completed the Born2BeRoot project, setting up a secure and optimized server environment using Rocky Linux. This project covered essential skills in virtualization, disk management, and server security.

<!-- I still need to add my lightpd & wordpress configuration files, I will update this section once i do so. -->