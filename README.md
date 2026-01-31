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
## my approache
##### (i guess since i don't think it is logical to have a part sjuch as this on a readme related To the world of Virtuialization)
## Installation Workflow

A followed a manual configuration approach using Anaconda in `text/shell` **mode**.
![anaconda screenshot]()
### 1. Initial Configuration
Before partitioning, we configure the basic system environment within the Anaconda interface:
*   **Language & Keyboard Layout:** Set the system language and keyboard map.
*   **Time & Date:** Configure the timezone and NTP settings.
*   **User Management:**
    *   Set the **Root** password.
    *   Create the primary **User** account and assign administrative privileges.

### 2. Storage Configuration (Anaconda Shell)
We bypass the automatic partitioner to perform a custom setup using `fdisk`, LUKS encryption, and LVM.

#### Step 2.1: Physical Partitioning
Using `fdisk` to clean the disk and create the physical structure:
*   **Boot Partition:** Unencrypted partition for the kernel/bootloader.
*   **Primary Partition:** The remaining space designated for the encrypted volume.

#### Step 2.2: Encryption (LUKS)
Secure the primary partition using LUKS (Linux Unified Key Setup):
*   Initialize the LUKS container.
*   Open the decrypted mapping to prepare for LVM.

#### Step 2.3: Logical Volume Management (LVM)
Set up the flexible volume structure inside the encrypted container:
*   **Physical Volume (PV):** Initialize the decrypted mapper.
*   **Volume Group (VG):** Create a volume group.
*   **Logical Volumes (LV):** Carve out volumes for:
    *   `/root`
    *   `/home`
    *   `swap`

### 3. Finalization
*   **Mounting:** Mount the LVs to their respective mount points.
*   **Installation:** Proceed with the Anaconda installer to write changes to disk.

---
![meme](https://i.programmerhumor.io/2025/10/c2e76d7d346a5067b76bddd6f61347d9c3d59221e88aaf341dd19583607f7a91.png)
![iuhm](https://media.licdn.com/dms/image/v2/D5622AQG9dFW02IU-9A/feedshare-shrink_800/B56ZbYPI9nGoAo-/0/1747384573418?e=2147483647&v=beta&t=m3boBsHH2ilW3Tp01yPlAEz0wWAruQxbOWOQ-2MtaVo)
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


<!-- Additional sections may be required depending on the project (e.g., usage examples, feature list, technical choices, etc.). -->
# The algorithm


#  A Project description 
<!-- section must also explain the choice of operating system
(Debian or Rocky), with their respective pros and cons. It must indicate the main
design choices made during the setup (partitioning, security policies, user manage-
ment, services installed) as well as a comparison between:
◦Debian vs Rocky Linux
◦AppArmor vs SELinux
◦UFW vs firewalld
◦VirtualBox vs UTM -->


implementing Robust Password and Sudo Policies on Your Linux Machine
Maintaining a secure Linux environment entails setting strong password and sudo policies. These policies not only safeguard your system against unauthorized access, but also ensure its overall stability.

Implementing Strong Password Policies To set strong password policies, you'd typically modify the configuration files associated with PAM (Pluggable Authentication Modules) and login.defs. Here's how:

Open the /etc/security/pwquality.conf file and change the following values:

- - -- - - - - - -- - -  


2️⃣ Start fdisk

```
sudo fdisk /dev/sda
```

You are now inside fdisk (interactive mode).

3️⃣ Check current partition table
Command (m for help): p


Meaning:
Shows existing partitions so you don’t overwrite something by mistake.

4️⃣ Create a new partition
Command (m for help): n


fdisk will ask:

Partition type

Partition type:
  p   primary
  e   extended
Select (default p):


➡️ Press Enter (primary)

Partition number

Partition number (1-4, default X):


➡️ Press Enter

First sector

First sector (default ...):


➡️ Press Enter

Last sector (this is where size matters)

Last sector, +/-sectors or +/-size{K,M,G}:


➡️ Type:

+500M


✅ This creates a 500 MB partition

5️⃣ Set the partition type to Linux filesystem
Command (m for help): t


If it asks for a hex code:

Hex code (type L to list all codes): 83


Meaning:

83 = Linux filesystem

Correct for /boot in BIOS systems

6️⃣ Verify before writing
Command (m for help): p


You should see something like:

/dev/sda1   500M   Linux filesystem

--------------------------------------

After fdisk (very important)
8️⃣ Format the partition
```
sudo mkfs.ext4 /dev/sda1
```

Meaning:
Creates a filesystem so Linux can store files there.

9️⃣ Mount it as /boot
```
sudo mount /dev/sda1 /boot
```
🔟 Make it permanent (/etc/fstab)
```
sudo blkid /dev/sda1
```

Copy the UUID, then edit:
```
sudo nano /etc/fstab
```