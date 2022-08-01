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
if [[ "no" == $(ask_yes_or_no "If you provide the wrong IP, you lock yourself out!") || \
      "no" == $(ask_yes_or_no "Are you REALLY sure?") ]]
then
    echo "Skipped."
    exit 0
fi
sudo ufw default deny incoming
ufw allow proto tcp from YOURSTATICIP to any port 22
sudo ufw allow from YOURSTATIC to any port 3000:3015 proto tcp
sudo ufw allow to any port 30303:30311 proto tcp
ufw --force enable
ufw reload
ufw status numbered
echo "Done (Script by Lux)"
