#!/bin/bash

# Prompt user for the directory to install the bot
echo "Where would you like to save the Althea Restake Bot?"
echo "Press enter to use the default location: ~/althea-restake-bot"
read -p "Enter installation directory: " bot_dir
bot_dir=${bot_dir:-$HOME/althea-restake-bot}

# Create the directory if it doesn't exist
mkdir -p "$bot_dir"

# Prompt for the keyring-backend option
echo "Which keyring-backend would you like to use?"
echo "1) os (default)  2) file  3) test"
read -p "Enter the number of your choice (default: os): " keyring_choice
keyring_choice=${keyring_choice:-1}

case $keyring_choice in
  1) keyring="os" ;;
  2) keyring="file" ;;
  3) keyring="test" ;;
  *) keyring="os" ;;
esac

# Prompt user for the validator address
read -p "Enter your validator address (e.g., altheavaloper...): " validator_address

# Prompt user for the delegator wallet name
read -p "Enter your delegator wallet name (e.g., qwoyn-validator): " delegator_wallet

# Prompt user for the delegator address
read -p "Enter your delegator address (e.g., althea1xys0n...): " delegator_address

# Prompt user for the interval to run the script
echo "What interval would you like to set for the cron job?"
echo "1) 30 minutes  2) 1 hour  3) 2 hours  4) 4 hours  5) 12 hours  6) 24 hours"
read -p "Enter the number of your choice (default: 4 hours): " cron_interval
cron_interval=${cron_interval:-4}

# Convert the interval to minutes
case $cron_interval in
  1) interval="30" ;;
  2) interval="60" ;;
  3) interval="120" ;;
  4) interval="240" ;;
  5) interval="720" ;;
  6) interval="1440" ;;
  *) interval="240" ;;
esac

# Create the bot directory and set up the script
echo "Setting up the Althea Restake Bot in $bot_dir..."
cp restake_bot.py "$bot_dir/restake_bot.py"

# Write configuration file with the user's inputs
echo "Writing configuration file..."
cat <<EOF > "$bot_dir/config.txt"
validator_address=$validator_address
delegator_wallet=$delegator_wallet
delegator_address=$delegator_address
keyring_backend=$keyring
EOF

# Set up the cron job
cron_job="*/$interval * * * * python3 $bot_dir/restake_bot.py"
(crontab -l 2>/dev/null; echo "$cron_job") | crontab -

# Display installation success
echo "Installation and cronjob setup successful!"
echo "To run the restake bot manually, you can use the command:"
echo "python3 $bot_dir/restake_bot.py"

echo "Cron job set to run every $interval minutes."
