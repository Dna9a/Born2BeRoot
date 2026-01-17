#!/bin/bash

# Born2BeRoot Monitoring Script
# This script displays system information every 10 minutes via wall command
# To be placed in /usr/local/bin/monitoring.sh on the VM

# System architecture and kernel version
arch=$(uname -a)

# Physical CPUs
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# Virtual CPUs
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM usage
ram_total=$(free -m | awk 'NR==2{printf "%s", $2}')
ram_used=$(free -m | awk 'NR==2{printf "%s", $3}')
ram_percent=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')

# Disk usage
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_used=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

# CPU load
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpu_load)
cpu_fin=$(printf "%.1f" $cpu_op)

# Last boot
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM active
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP connections
tcpc=$(ss -ta | grep ESTAB | wc -l)

# User log
ulog=$(users | wc -w)

# Network
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# Sudo commands (total count - note: this processes entire journal)
# For better performance on systems with large journals, add: --since "1 day ago"
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

# Display information using wall
wall "	#Architecture: $arch
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $ram_used/${ram_total}MB ($ram_percent%)
	#Disk Usage: $disk_used/${disk_total} ($disk_percent%)
	#CPU load: $cpu_fin%
	#Last boot: $lb
	#LVM use: $lvmu
	#Connections TCP: $tcpc ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmnd cmd"
