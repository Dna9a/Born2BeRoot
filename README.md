## *This project has been created as part of the 42 curriculum by yoabied.* 

<!-- 9sem -->
<div style="display: flex; justify-content: space-between; align-items: center;">
  <span style="font-size: 45px;">📄</span>
  <span style="font-size: 40px;">🐪</span>
</div>

<!-- # Description-->
# Description
This project aims to introduce you to the wonderful world of virtualization. 
Thats by creating your first virtual machine in `VirtualBox` (my case) using specific instructions.  Then, at the end of this project, you will be able to set up
your own operating system while implementing strict rules.

## Virtualization

Virtualization is a technology used to create virtual representations of `servers`, `storage`, `networks`, and `other physical machines`. Virtualization software `mimics` the functions of physical hardware, allowing multiple virtual machines to run simultaneously on a single physical machine. Businesses use virtualization to utilize hardware resources more efficiently and achieve better returns on their investment. It also powers cloud computing services, helping organizations `manage infrastructure` more effectively. Additionally, virtualization is a solution for limited hardware resources, as it provides users with an isolated environment. The physical machine is called the host, while the virtual machine running on it is called the guest.

## Hypervisor
It is `software` that sits in between the hardware and the VMs for the sake of managing resources for VMs. **The hypervisor** is divided into two types:

### Type 1
This type is a **native** solution that sits directly on top of the hardware. It is capable of acting as the operating system for the physical server, such as:

### Type 2
It is software that sits on top of your main OS, such as:


<!-- Instructions -->
# Instructions
## Installation Workflow

A followed a manual configuration approach using Anaconda in `text/shell` **mode**.

![oo](https://fv5-5.files.fm/thumb_show.php?i=vn2e42yha6&view&v=1&PHPSESSID=58c01eb2a1ca8ecfa0e8f0ade6f6cd6112a9fb82)

### 2. Storage Configuration (Anaconda Shell)
We bypass the automatic partitioner to perform a custom setup using `fdisk`, LUKS encryption, and LVM.

`Get yourr self your OS iso` --> `` --> `` 

`Language` --> `Timezone` --> `Root & User Creds` 
       |
       V
**(Switch to Shell)** --> `fdisk` (Partitioning) --> `LUKS` (Encryption) --> `LVM` (Logical Volumes)
       |
       V
**(Resume Installer)** --> `Mount Points` --> `Begin Installation`

![meme](https://i.programmerhumor.io/2025/10/c2e76d7d346a5067b76bddd6f61347d9c3d59221e88aaf341dd19583607f7a91.png)


<!-- Resources -->
# Resources 

- **[Amazon + A_pdf_Ofpp - Virtualization](https://aws.amazon.com/what-is/virtualization/)**
- **[Wikipedia - luks ](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup)**
- **[RedHat - luks](https://access.redhat.com/solutions/100463)**
- **[Peers - luks](https://profile-v3.intra.42.fr/users/amedina)** 
- **[RedHat - fdisk](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/storage_administration_guide/s2-disk-storage-parted-resize-part)**
- **[ - ]()**
- **[ - ]()**
- **[ - ]()**
- **[ - ]()**


#  A Project description 
<!-- section must also explain the choice of operating system
(Debian or Rocky), with their respective pros and cons. It must indicate the main
design choices made during the setup (partitioning, security policies, user manage-
ment, services installed) as well as a comparison between:
◦Debian vs Rocky Linux
◦AppArmor vs SELinux
◦UFW vs firewalld
◦VirtualBox vs UTM -->

![iuhm](https://media.licdn.com/dms/image/v2/D5622AQG9dFW02IU-9A/feedshare-shrink_800/B56ZbYPI9nGoAo-/0/1747384573418?e=2147483647&v=beta&t=m3boBsHH2ilW3Tp01yPlAEz0wWAruQxbOWOQ-2MtaVo)


# 🐧 Operating System & Design Choices

## 1. Choice of Operating System
For this project, I chose **Debian** over Rocky Linux.

### Debian vs. Rocky Linux
| Feature | Debian (Selected) | Rocky Linux |
| :--- | :--- | :--- |
| **Philosophy** | Strictly open-source, community-driven project (SPI). | Enterprise-focused, bug-for-bug compatible with RHEL. |
| **Package Manager** | `APT` (Advanced Package Tool) & `.deb` packages. | `DNF` / `YUM` & `.rpm` packages. |
| **Stability** | Known for extreme stability; older but tested packages. | Stable, but follows Red Hat enterprise release cycles. |
| **Community** | Massive global community and documentation. | Smaller community (successor to CentOS). |
| **Use Case** | General purpose servers and desktops. | Corporate environments requiring RHEL compatibility. |

---

## 2. Design Choices & Policies

To ensure a secure and efficient server environment, the following configurations were implemented:

### Partitioning
I utilized **LVM (Logical Volume Management)** within an **Encrypted (LUKS)** partition. This structure allows for dynamic resizing of partitions and ensures data security at rest.
*   `/boot`: Unencrypted (required for bootloader).
*   `LVM`: Encrypted volume containing logical volumes for `/root`, `/home`, `/var`, etc.

### Security Policies
*   **Password Policy:** strict rules for password complexity and expiration (via `pwquality`).
*   **Sudo:** Restricted privileges with TTY usage enforcement and log archiving.
*   **SSH:** Root login disabled, custom port (4242), and key-based authentication preferred.

### User Management
*   **Root Account:** Reserved solely for system administration tasks.
*   **Primary User:** Added to the `sudo` and `user42` groups for elevated privileges.

---

## 3. Technology Comparisons

### AppArmor vs. SELinux
| AppArmor (Debian default) | SELinux (Rocky/RHEL default) |
| :--- | :--- |
| **Model** | Path-based access control. Profiles are attached to specific file paths/executables. | Label-based access control. Files and processes are tagged with security contexts. |
| **Ease of Use** | Generally considered easier to learn and configure. | steeper learning curve; very granular but complex. |
| **Implementation** | Less intrusive; often defaults to "complain" mode. | Highly intrusive; enforces strict policies by default ("enforcing" mode). |

### UFW vs. Firewalld
| UFW (Uncomplicated Firewall) | Firewalld |
| :--- | :--- |
| **Interface** | A simplified command-line wrapper for `iptables`/`nftables`. | A dynamic firewall manager with support for network "zones". |
| **Usage** | Designed for simplicity; easy commands like `ufw allow 4242`. | Designed for complex setups; uses XML for configuration and DBus. |
| **Best For** | Single-host servers and beginners. | Complex network environments with changing zones (e.g., laptops, servers). |

### VirtualBox vs. UTM
| VirtualBox | UTM (QEMU backend) |
| :--- | :--- |
| **Architecture** | Primarily x86 virtualization. | Supports emulation of different architectures (ARM, x86, PPC, etc.). |
| **Performance** | Excellent for x86-on-x86 virtualization. | Native speed on Apple Silicon (M-series) via Hypervisor.framework. |
| **OS Support** | Cross-platform (Windows, Linux, macOS). | Exclusive to macOS/iOS. |






implementing Robust Password and Sudo Policies on Your Linux Machine
Maintaining a secure Linux environment entails setting strong password and sudo policies. These policies not only safeguard your system against unauthorized access, but also ensure its overall stability.

Implementing Strong Password Policies To set strong password policies, you'd typically modify the configuration files associated with PAM (Pluggable Authentication Modules) and login.defs. Here's how:

Open the /etc/security/pwquality.conf file and change the following values:

- - -- - - - - - -- - -  


Start fdisk

```
sudo fdisk /dev/sda
```

