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

A
<!-- Instructions -->
# Instructions
## my approache 
language --> time --> root --> user --> patitiionnning using fdisk--> luks encription
<!-- here is a picture -->
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