#!/bin/bash
sudo apt install ufw -y
sudo apt upgrade -y
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "no" == $(ask_yes_or_no "Did you add the correct IP? Continuing will reset your current UFW config. Proceed?") ]]
then
    echo "Skipped."
    exit 0
fi
sudo yes | ufw reset 
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw allow from YOURIPHERE to any port 3000:3015 proto tcp
sudo ufw allow to any port 30303:30311 proto tcp
ufw --force enable
ufw reload
ufw status numbered
echo "Done, bot UI secured (Script by Lux)"
if [[ "no" == $(ask_yes_or_no "Also add port 22 SSH? If you provided a wrong IP, you can lock yourself out of your server. Continue?") || \
      "no" == $(ask_yes_or_no "Are you REALLY sure?") ]]
then
    echo "Skipped."
    exit 0
fi
sudo ufw delete allow ssh
sudo ufw allow proto tcp from YOURIPHERE to any port 22
sudo ufw reload
sudo ufw status numbered
echo "Done, SSH port is now secured (Script by Lux)"
