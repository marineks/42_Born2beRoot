#Operating system architecture and its kernel version
echo -n "#Architecture: "; uname -a
echo -n "#CPU physical: "; grep -i "physical id" /proc/cpuinfo | sort -u | wc -l 
echo -n "#vCPU :"; nproc

# Display RAM
used_ram=$(free -m | sed -n 2p | awk '{print $3}')
total_ram=$(free -m | sed -n 2p | awk '{print $2}')
percentage=$(( 100 * ${used_ram} / ${total_ram}))
echo "#Memory Usage: ${used_ram}/${total_ram} MB (${percentage}%)"

#Display disk space
used_dp=$(df -h / | sed -n 2p | awk '{print $3}' | sed 's/.$//')
total_dp=$(df -h / | sed -n 2p | awk '{print $2}')
percentage_dp=$(df -h / | sed -n 2p | awk '{print $5}')
echo "#Disk Usage: ${used_dp}/${total_dp} MB (${percentage_dp})"

#Current use of CPUs, last boot, etc.
echo -n "#CPU load: "; mpstat | awk '$12 ~ /[0-9.]+/ {print 100 - $12 "%"}' 
echo -n "#Last boot: "; who -b | awk '{print $3 " " $4}'

#Display whether LVM is active
if [ $(lsblk | grep lvm | wc -l) -gt '0' ]
then 
        echo "#LVM use: yes"
else
        echo "#LVM use: no"
fi

#Active TCP connections
tcp_nb=$(netstat -an | grep tcp | grep ESTABLISHED | wc -l)
echo "#Connexions TCP : ${tcp_nb} ESTABLISHED"

#Nb of users connected
echo -n "#User log: "; who | wc -l

#IPv4 address
ip_add=$(hostname -I)
mac_add=$(ip addr | sed -n 8p | awk '{print $2}')
echo "#Network: IP ${ip_add}(${mac_add})"

#Sudo cmd
line_count=$(cat ../../../var/log/sudo/sudo.log | wc -l)
sudo_count=$(($line_count / 2))
echo "#Sudo : ${sudo_count} cmd"