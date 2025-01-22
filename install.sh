#!/bin/bash

# Prompt user for the directory to install the bot
read -p "Enter installation directory (default: $HOME/althea-restake-bot): " bot_dir
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

# Prompt user for the node URL
read -p "Enter your node URL (default: https://althea-rpc.polkachu.com:443): " node_url
node_url=${node_url:-"https://althea-rpc.polkachu.com:443"}

# Prompt user for the chain ID
read -p "Enter your chain ID (default: althea_258432-1): " chain_id
chain_id=${chain_id:-"althea_258432-1"}

# Prompt user for the fees
read -p "Enter the fees (default: 35000000000000000aalthea): " fees
fees=${fees:-"35000000000000000aalthea"}

# Prompt user for the gas limit
read -p "Enter the gas limit (default: 350000): " gas
gas=${gas:-"350000"}

# Write configuration file with the user's inputs
echo "Writing configuration file..."
cat <<EOF > "$bot_dir/config.txt"
VALIDATOR_ADDRESS=$validator_address
DELEGATOR_WALLET=$delegator_wallet
DELEGATOR_ADDRESS=$delegator_address
KEYRING_BACKEND=$keyring
NODE_URL=$node_url
CHAIN_ID=$chain_id
FEES=$fees
GAS=$gas
EOF

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

# Set up the cron job
cron_job="*/$interval * * * * python3 $bot_dir/restake_bot.py"
(crontab -l 2>/dev/null; echo "$cron_job") | crontab -

# Display installation success
echo "Installation and cronjob setup successful!"
echo "To run the restake bot manually, you can use the command:"
echo "python3 $bot_dir/restake_bot.py"

echo "Cron job set to run every $interval minutes."
