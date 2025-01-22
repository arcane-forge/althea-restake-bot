# Althea Restake Bot

This Python script automates the process of collecting and restaking rewards on the Althea blockchain network. It queries for available staking rewards, collects them, and restakes 50% of the rewards at a configured interval (default 4 hours). The script supports using a keyring backend (e.g., `file` or `test`) to avoid manual password entry.

## Requirements

- Python 3.6 or later
- Althea CLI (`althea` command)
- Node URL and Chain ID for the Althea network
- Validator and delegator wallet addresses set up in Althea

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/arcane-forge/althea-restake-bot.git
cd althea-restake-bot
```

### 2. Install the Bot

To install the bot and configure the cron job for automatic execution, use the provided installation script:

```bash
chmod +x install.sh
./install.sh
```

The installation script will prompt you for the following:

- **Validator address**: Enter the address of your Althea validator.
- **Delegator wallet name**: Enter the name of your delegator wallet (the wallet that will collect rewards and restake).
- **Delegator address**: Enter the address of your delegator account.
- **Keyring backend**: Choose the keyring backend (os, file, or test) to avoid manual password entry for transactions.
- **Cron job interval**: Select the interval for running the bot automatically (30 minutes, 1 hour, 2 hours, 4 hours, 12 hours, or 24 hours).

Once the script is executed, it will automatically set up the bot in a directory of your choice (default is `~/althea-restake-bot`), configure the cron job for automated execution, and store the configuration in a `config.txt` file.

### 3. Run the Script Manually (Optional)

If you wish to run the bot manually at any time, use the following command:

```bash
python3 ~/althea-restake-bot/restake_bot.py
```

### 4. Automate with Cron

The installation script will automatically set up a cron job based on your preferred interval. This ensures that the bot runs periodically to collect and restake rewards.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
