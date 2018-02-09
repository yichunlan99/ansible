OS=$(uname -s)
REV=$(uname -r)
MACH=$(uname -m)
GetVersionFromFile()
{
        VERSION=$(cat $1 | tr "\n" ' ' | sed 's/.*VERSION.*=\ //')
}
if [ "${OS}" = "Linux" ]; then
        KERNEL=$(uname -r)
        if [ -f /etc/redhat-release ]; then
                DIST='RedHat'
                PSUEDONAME=$(cat /etc/redhat-release | sed 's/.*(//' | sed 's/)//')
                REV=$(cat /etc/redhat-release | sed 's/.*release\ //' | sed 's/\ .*//')
        elif [ -f /etc/debian_version ]; then
                DIST="Debian $(cat /etc/debian_version)"
                REV=""
        fi
fi
        OSSTR="${OS} ${DIST} ${REV}(${PSUEDONAME} ${KERNEL} ${MACH})"
# Get system/hardware info .
OUT='/etc/motd'
figlet jcloud.com > $OUT
echo "This server is restricted to authorized users only. All activities on this system are logged." >> $OUT
SYSMOD=$(lsb_release -sd | sed 's/"//g')
echo "System Model: $SYSMOD " >> $OUT;echo -e "\n"
PROCTYPE=$(cat /proc/cpuinfo | grep -m 1 vendor_id | awk '{ print $3 }')
echo "Processor Type: $PROCTYPE " >> $OUT
PROCNUM=$(cat /proc/cpuinfo | grep processor | wc -l)
echo "Number Of Processors: $PROCNUM" >> $OUT
RAM=$(cat /proc/meminfo | grep MemTotal | awk -F\: '{print $2}' | awk -F\  '{print $1 " " $2}')
echo "Memory Size: $RAM RAM" >> $OUT
BIOSREV=$(dmidecode -s bios-version)
if [ "$BIOSREV" = "/dev/mem: mmap: Bad address" ]
then
echo "Bios Revision: Unknown" >> $OUT
else
echo "Bios Revision: $BIOSREV" >> $OUT
fi
echo "OS: $OSSTR" >> $OUT
echo "" >> $OUT
echo "Network Information" >> $OUT
HOSTNAME=$(/bin/hostname -f)
echo -e "\tHost Name: " $HOSTNAME  >> $OUT
let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days %02d hours %02d minutes %02d seconds" "$days" "$hours" "$mins" "$secs"`
echo -e "\tUptime: " $UPTIME >> $OUT
IP=$(ifconfig eth0 | grep "inet " | awk '{ print $2 }' | cut -d: -f2)
echo -e "\tIP Address: $IP " >> $OUT
echo -e "\tName Servers: " $(grep nameserver /etc/resolv.conf| awk '{ print $2 }') >> $OUT
echo -e "\tDomain Name: " $(dnsdomainname) >> $OUT
echo >> $OUT
echo "Paging Space Information" >> $OUT
SWAP=$(cat /proc/meminfo | grep SwapTotal | awk -F\: '{print $2}' | awk -F\  '{print $1 " " $2}')
echo -e "\tTotal Paging Space: $SWAP swap space" >> $OUT
SWAPUSED=$(free | grep Swap | awk '{ print $3 }')
echo -e "\tPaging Used: $SWAPUSED KB swap space" >> $OUT
