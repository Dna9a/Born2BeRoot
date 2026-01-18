# Born2BeRoot Partition Structure - Rocky Linux Edition

## Disk Layout Overview

This document provides a visual representation of the disk partitioning structure for the Born2BeRoot project using Rocky Linux.

## Physical Disk Structure

```
┌─────────────────────────────────────────────────────────┐
│                     Physical Disk (sda)                  │
│                          30 GB                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │         sda1 - /boot (1 GB)                    │    │
│  │         Standard Partition                      │    │
│  │         Type: XFS (Rocky default)              │    │
│  │         NOT Encrypted                           │    │
│  └────────────────────────────────────────────────┘    │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │         sda2 - LVM Partition                   │    │
│  │         (~29 GB)                               │    │
│  │         Type: Encrypted (LUKS)                 │    │
│  │         Maps to: /dev/mapper/luks-xxxx         │    │
│  │                                                 │    │
│  │  ┌──────────────────────────────────────────┐ │    │
│  │  │      LVM Physical Volume (PV)            │ │    │
│  │  │      Contains Volume Group (rl)          │ │    │
│  │  └──────────────────────────────────────────┘ │    │
│  └────────────────────────────────────────────────┘    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## LVM Structure

```
┌──────────────────────────────────────────────────────────┐
│         Volume Group: rl (~29 GB)                        │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV root - / (10 GB)                             │   │
│  │  Type: XFS (Rocky default)                       │   │
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
│  │  Type: XFS                                        │   │
│  │  Usage: User home directories                     │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV var - /var (3 GB)                            │   │
│  │  Type: XFS                                        │   │
│  │  Usage: Variable data, caches                     │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV srv - /srv (3 GB)                            │   │
│  │  Type: XFS                                        │   │
│  │  Usage: Service data (WordPress for bonus)       │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV tmp - /tmp (3 GB)                            │   │
│  │  Type: XFS                                        │   │
│  │  Usage: Temporary files                           │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LV var-log - /var/log (4 GB)                    │   │
│  │  Type: XFS                                        │   │
│  │  Usage: System logs                               │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

## Expected Output of `lsblk` Command

After completing the installation, running `lsblk` should produce output similar to:

```
NAME                  MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                     8:0    0   30G  0 disk
├─sda1                  8:1    0    1G  0 part  /boot
└─sda2                  8:2    0   29G  0 part
  └─luks-xxxx         253:0    0   29G  0 crypt
    ├─rl-root         253:1    0   10G  0 lvm   /
    ├─rl-swap         253:2    0  2.3G  0 lvm   [SWAP]
    ├─rl-home         253:3    0    5G  0 lvm   /home
    ├─rl-var          253:4    0    3G  0 lvm   /var
    ├─rl-srv          253:5    0    3G  0 lvm   /srv
    ├─rl-tmp          253:6    0    3G  0 lvm   /tmp
    └─rl-var_log      253:7    0    4G  0 lvm   /var/log
sr0                    11:0    1 1024M  0 rom
```

**Note:** Rocky Linux typically uses "rl" as the default volume group name. The encrypted partition shows as "luks-xxxx" where xxxx is a UUID.

## Partition Size Breakdown

| Partition | Size | Type | Mount Point | Purpose |
|-----------|------|------|-------------|---------|
| sda1 | 1 GB | XFS | /boot | Boot files, not encrypted |
| sda2 | ~29 GB | Encrypted | N/A | Container for LVM |
| LV root | 10 GB | XFS | / | Root filesystem, system files |
| LV swap | 2.3 GB | Swap | N/A | Virtual memory |
| LV home | 5 GB | XFS | /home | User home directories |
| LV var | 3 GB | XFS | /var | Variable data, package caches |
| LV srv | 3 GB | XFS | /srv | Service data (e.g., WordPress) |
| LV tmp | 3 GB | XFS | /tmp | Temporary files |
| LV var_log | 4 GB | XFS | /var/log | System and application logs |

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
2. GRUB2 Bootloader (reads from /boot - sda1)
   ↓
3. Prompt for LUKS encryption password
   ↓
4. Unlock encrypted partition (luks-xxxx)
   ↓
5. LVM activates all logical volumes
   ↓
6. Mount all filesystems (XFS)
   ↓
7. System boots with SELinux enabled
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
sudo cryptsetup luksDump /dev/sda2

# Check encryption status
sudo dmsetup status
```

### Check Disk Usage
```bash
# Show disk usage for all partitions
df -h

# Show detailed disk usage (Rocky uses "rl" as VG name)
df -h | grep -E "Filesystem|rl"
```

## Modifying the Structure (After Installation)

### Resize a Logical Volume
```bash
# Extend a logical volume (if space available)
sudo lvextend -L +2G /dev/rl/home
sudo xfs_growfs /home  # For XFS (Rocky default)

# For ext4 (if you used it):
# sudo resize2fs /dev/rl/home

# Note: XFS cannot be shrunk, only grown!
# If you need to reduce size, you must backup, recreate, and restore
```

### Create a New Logical Volume
```bash
# If you have free space in the volume group
sudo lvcreate -L 2G -n new_lv rl
sudo mkfs.xfs /dev/rl/new_lv
```

### Take a Snapshot
```bash
# Create a snapshot of a logical volume
sudo lvcreate -L 1G -s -n home_snapshot /dev/rl/home

# Mount the snapshot
sudo mkdir /mnt/snapshot
sudo mount /dev/rl/home_snapshot /mnt/snapshot
```

## Partition Structure Alternatives

### Minimal Setup (Mandatory Requirements Only)
For the mandatory requirements, you could use a simpler structure:
- `/boot` - 1 GB (XFS)
- `/` (root) - 4 GB (XFS)
- `swap` - 1 GB
- `/home` - Remaining space (XFS)

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
6. **XFS is Default**: Rocky Linux uses XFS by default (can't shrink, only grow)
7. **Use ext4 if Flexibility Needed**: ext4 allows both growing and shrinking

## Common Issues

### Issue: Forgot Encryption Password
**Solution:** Unfortunately, there's no way to recover without the password. You'll need to reinstall.

### Issue: Partition Full
**Solution:** Use LVM to extend the partition:
```bash
# Check free space in volume group
sudo vgs

# Extend the logical volume
sudo lvextend -L +1G /dev/rl/var
sudo xfs_growfs /var  # For XFS
# Or: sudo resize2fs /dev/rl/var  # For ext4
```

### Issue: Can't Boot (GRUB Error)
**Solution:** 
1. Boot from Rocky Linux installer
2. Choose "Troubleshooting" → "Rescue a Rocky Linux system"
3. Enter encryption password
4. Reinstall GRUB2:
   ```bash
   chroot /mnt/sysimage
   grub2-install /dev/sda
   grub2-mkconfig -o /boot/grub2/grub.cfg
   exit
   reboot
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
