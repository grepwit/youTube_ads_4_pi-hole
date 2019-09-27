#!/bin/sh
# Update the pihole list with youtube ads 
# this shell script is made by Kiro 
#Thank you for using it and enjoy 

# The script will create a file with all the youtube ads found in hostsearch and from the logs of the Pi-hole
# it will append the list into a file called blacklist.txt'/etc/pihole/blacklist.txt'

piholeIPV4=$(hostname -I |awk '{print $1}')
piholeIPV6=$(hostname -I |awk '{print $2}')


blackListFile='/etc/pihole/black.list'
blacklist='/etc/pihole/blacklist.txt'

# Get the list from the GitHub 
sudo curl 'https://raw.githubusercontent.com/kboghdady/youTube_ads_4_pi-hole/master/black.list'\
>>$blacklist

sudo curl 'https://raw.githubusercontent.com/kboghdady/youTube_ads_4_pi-hole/master/black.list'\
>>$blackListFile

wait 

# check to see if gawk is installed. if not it will install it
if [ -n "$(command -v apt-get)" ]; then
    dpkg -l | grep -qw gawk || sudo apt-get install gawk -y
elif [ -n "$(command -v yum)" ]; then
    rpm -qa | grep -qw gawk || sudo yum install gawk -y
else
    echo "Unable to automatically install gawk."
fi

wait 
# remove the duplicate records in place
gawk '!a[$0]++' $blackListFile > tmp && mv tmp $blackListFile
wait 
gawk '!a[$0]++' $blacklist > tmp && mv tmp $blacklist
