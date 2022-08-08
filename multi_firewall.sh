#!/bin/bash
sudo apt install ufw -y
sudo apt upgrade -y
clear
echo "Enter your static IP address - eg. 123.456.7.89"
read ip
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "no" == $(ask_yes_or_no "Did you add the correct IP? Continuing will reset your current UFW config. Proceed?") ]]
then
    echo "Skipped. Re-run the script."
    exit 0
fi
sudo yes | ufw reset
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw allow from $ip to any port 3000:3015 proto tcp
sudo ufw allow to any port 30303:30311 proto tcp
ufw --force enable
ufw reload
ufw status numbered
echo "Done, bot web UI is now secured."
if [[ "yes" == $(ask_yes_or_no "Add a backup IP address? For example your home IP? (https://www.myip.com/)") ]]
then
    echo "Enter a backup IP address - eg. 96.69.1.337"
    read ip2
    sudo ufw allow from $ip2 to any port 3000:3015 proto tcp
    sudo ufw reload
    sudo ufw status numbered
    echo "Done, Backup IP rule is added (Script by Lux)"
fi
if [[ "no" == $(ask_yes_or_no "Secure SSH/port 22? If you provided a wrong static IP and no backup IP, you can lock yourself out of your server. Continue?") || \
      "no" == $(ask_yes_or_no "Are you REALLY sure?") ]]
then
    echo "Skipped. End of script. Only bot web UI secured. (Script by Lux)"
    exit 0
fi
sudo ufw delete allow ssh
sudo ufw allow proto tcp from $ip to any port 22
sudo ufw allow proto tcp from $ip2 to any port 22
sudo ufw reload
sudo ufw status numbered
echo "Done, SSH port is now secured. (Script by Lux)"
