# Born2BeRoot Partition Structure

## Disk Layout Overview

This document provides a visual representation of the disk partitioning structure for the Born2BeRoot project.

## Physical Disk Structure

```
┌─────────────────────────────────────────────────────────┐
│                     Physical Disk (sda)                  │
│                          30 GB                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │         sda1 - /boot (500 MB)                  │    │
│  │         Primary Partition                       │    │
│  │         Type: Ext4                              │    │
│  │         NOT Encrypted                           │    │
│  └────────────────────────────────────────────────┘    │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │         sda5 - Extended Partition              │    │
│  │         (~29.5 GB)                             │    │
│  │         Type: Encrypted (LUKS)                 │    │
│  │         Maps to: /dev/mapper/sda5_crypt        │    │
│  │                                                 │    │
│  │  ┌──────────────────────────────────────────┐ │    │
│  │  │      LVM Physical Volume (PV)            │ │    │
│  │  │      Contains LVMGroup                   │ │    │
│  │  └──────────────────────────────────────────┘ │    │
│  └────────────────────────────────────────────────┘    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## LVM Structure

```
┌──────────────────────────────────────────────────────────┐
│         Volume Group: LVMGroup (~29.5 GB)                │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV root - / (10 GB)                             │   │
│  │  Type: Ext4                                       │   │
│  │  Usage: System files, programs                    │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV swap - swap (2.3 GB)                         │   │
│  │  Type: Swap                                       │   │
│  │  Usage: Virtual memory                            │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV home - /home (5 GB)                          │   │
│  │  Type: Ext4                                       │   │
│  │  Usage: User home directories                     │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV var - /var (3 GB)                            │   │
│  │  Type: Ext4                                       │   │
│  │  Usage: Variable data, caches                     │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV srv - /srv (3 GB)                            │   │
│  │  Type: Ext4                                       │   │
│  │  Usage: Service data (WordPress for bonus)       │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV tmp - /tmp (3 GB)                            │   │
│  │  Type: Ext4                                       │   │
│  │  Usage: Temporary files                           │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV var-log - /var/log (4 GB)                    │   │
│  │  Type: Ext4                                       │   │
│  │  Usage: System logs                               │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

## Expected Output of `lsblk` Command

After completing the installation, running `lsblk` should produce output similar to:

```
NAME                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                       8:0    0   30G  0 disk
├─sda1                    8:1    0  500M  0 part  /boot
├─sda2                    8:2    0    1K  0 part
└─sda5                    8:5    0 29.5G  0 part
  └─sda5_crypt          254:0    0 29.5G  0 crypt
    ├─LVMGroup-root     254:1    0   10G  0 lvm   /
    ├─LVMGroup-swap     254:2    0  2.3G  0 lvm   [SWAP]
    ├─LVMGroup-home     254:3    0    5G  0 lvm   /home
    ├─LVMGroup-var      254:4    0    3G  0 lvm   /var
    ├─LVMGroup-srv      254:5    0    3G  0 lvm   /srv
    ├─LVMGroup-tmp      254:6    0    3G  0 lvm   /tmp
    └─LVMGroup-var--log 254:7    0    4G  0 lvm   /var/log
sr0                      11:0    1 1024M  0 rom
```

## Partition Size Breakdown

| Partition | Size | Type | Mount Point | Purpose |
|-----------|------|------|-------------|---------|
| sda1 | 500 MB | Ext4 | /boot | Boot files, not encrypted |
| sda5 | ~29.5 GB | Encrypted | N/A | Container for LVM |
| LV root | 10 GB | Ext4 | / | Root filesystem, system files |
| LV swap | 2.3 GB | Swap | N/A | Virtual memory |
| LV home | 5 GB | Ext4 | /home | User home directories |
| LV var | 3 GB | Ext4 | /var | Variable data, package caches |
| LV srv | 3 GB | Ext4 | /srv | Service data (e.g., WordPress) |
| LV tmp | 3 GB | Ext4 | /tmp | Temporary files |
| LV var-log | 4 GB | Ext4 | /var/log | System and application logs |

**Total:** ~30.3 GB

## Why This Structure?

### Security Benefits
1. **Encryption**: All data except `/boot` is encrypted using LUKS
2. **Separation**: Isolates different types of data for better security and management
3. **Containment**: Issues in one partition (e.g., log files filling up) won't affect others

### LVM Benefits
1. **Flexibility**: Can resize partitions without downtime (in most cases)
2. **Snapshots**: Can take point-in-time snapshots for backups
3. **Easy Management**: Simpler to manage than traditional partitioning

### Practical Benefits
1. **Performance**: Separate partitions can be optimized differently
2. **Backup**: Easier to backup specific areas (e.g., just /home)
3. **Troubleshooting**: Easier to identify and fix disk space issues
4. **Compliance**: Meets many security standards and best practices

## Boot Process Flow

```
1. BIOS/UEFI
   ↓
2. GRUB Bootloader (reads from /boot - sda1)
   ↓
3. Prompt for LUKS encryption password
   ↓
4. Unlock sda5_crypt
   ↓
5. LVM activates all logical volumes
   ↓
6. Mount all filesystems
   ↓
7. System boots
```

## Commands to Verify Structure

### Check Partition Layout
```bash
lsblk
fdisk -l
```

### Check LVM Information
```bash
# Physical volumes
pvdisplay
pvs

# Volume groups
vgdisplay
vgs

# Logical volumes
lvdisplay
lvs
```

### Check Encryption
```bash
# List encrypted devices
lsblk -f | grep crypto

# Check LUKS header
sudo cryptsetup luksDump /dev/sda5
```

### Check Disk Usage
```bash
# Show disk usage for all partitions
df -h

# Show detailed disk usage
df -h | grep -E "Filesystem|LVMGroup"
```

## Modifying the Structure (After Installation)

### Resize a Logical Volume
```bash
# Extend a logical volume (if space available)
sudo lvextend -L +2G /dev/LVMGroup/home
sudo resize2fs /dev/LVMGroup/home

# Reduce a logical volume (be careful!)
sudo umount /home
sudo e2fsck -f /dev/LVMGroup/home
sudo resize2fs /dev/LVMGroup/home 4G
sudo lvreduce -L 4G /dev/LVMGroup/home
sudo mount /home
```

### Create a New Logical Volume
```bash
# If you have free space in the volume group
sudo lvcreate -L 2G -n new_lv LVMGroup
sudo mkfs.ext4 /dev/LVMGroup/new_lv
```

### Take a Snapshot
```bash
# Create a snapshot of a logical volume
sudo lvcreate -L 1G -s -n home_snapshot /dev/LVMGroup/home

# Mount the snapshot
sudo mkdir /mnt/snapshot
sudo mount /dev/LVMGroup/home_snapshot /mnt/snapshot
```

## Partition Structure Alternatives

### Minimal Setup (Mandatory Requirements Only)
For the mandatory requirements, you could use a simpler structure:
- `/boot` - 500 MB
- `/` (root) - 4 GB
- `swap` - 1 GB
- `/home` - Remaining space

**Total:** ~8 GB minimum

### Full Bonus Setup (As Shown Above)
This structure is recommended for the bonus part:
- Provides more logical volumes
- Better separation for services
- Demonstrates understanding of system organization

## Tips for Partitioning

1. **Plan Before Installing**: Know your partition sizes before starting
2. **/boot Must Not Be Encrypted**: The bootloader needs to read it
3. **Leave Some Free Space**: Always good to have ~10% free in the volume group
4. **Swap Size**: Generally 1-2x your RAM (2.3 GB is safe for most cases)
5. **Log Files Can Grow**: /var/log should have adequate space (4 GB recommended)

## Common Issues

### Issue: Forgot Encryption Password
**Solution:** Unfortunately, there's no way to recover without the password. You'll need to reinstall.

### Issue: Partition Full
**Solution:** Use LVM to extend the partition:
```bash
# Check free space in volume group
sudo vgs

# Extend the logical volume
sudo lvextend -L +1G /dev/LVMGroup/var
sudo resize2fs /dev/LVMGroup/var
```

### Issue: Can't Boot (GRUB Error)
**Solution:** 
1. Boot from Debian installer
2. Choose "Rescue mode"
3. Reinstall GRUB:
   ```bash
   grub-install /dev/sda
   update-grub
   ```

---

## Summary

This partition structure provides:
- ✅ Encryption for data security
- ✅ LVM for flexibility
- ✅ Proper separation of concerns
- ✅ Meets all Born2BeRoot requirements
- ✅ Follows Linux best practices

Understanding this structure is crucial for your defense presentation!
