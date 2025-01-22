# Althea Restake Bot

This Python script automates the process of collecting and restaking rewards on the Althea blockchain network. It queries for available staking rewards, collects them, and restakes 50% of the rewards at regular intervals (as defined by the user). The script supports using a keyring backend (e.g., `file` or `test`) to avoid manual password entry during staking.

## Requirements

- Python 3.6 or later
- Althea CLI (`althea` command)
- Access to the Althea network node (e.g., public RPC endpoint)

## Setup

### 1. Clone the Repository

Start by cloning the repository to your machine:

```bash
git clone https://github.com/arcane-forge/althea-restake-bot.git
cd althea-restake-bot
```

### 2. Install the Bot Using the Installation Script

The easiest way to set up the bot is to use the included installation script. This will configure the bot for you and set up a cron job to run the bot at your chosen interval.

1. **Make the script executable**:

    ```bash
    chmod +x install.sh
    ```

2. **Run the script**:

    ```bash
    ./install.sh
    ```

During installation, the script will:

- Prompt you for the **installation directory** (default: `~/althea-restake-bot`).
- Ask you for your **validator address**, **delegator wallet name**, **delegator address**, and **keyring backend** preference.
- Let you specify how frequently you want the bot to run via a cron job (options include: every 30 minutes, 1 hour, 2 hours, 4 hours, 12 hours, or 24 hours).
- Create a configuration file (`config.txt`) to store your input data.
- Set up a cron job to run the bot at the chosen interval.

### 3. Configure the Bot Manually (If Needed)

If you choose not to use the install script, you can manually configure the bot by editing the `restake_bot.py` file. Open the script and update the following placeholders:

- **`<VALIDATOR_ADDRESS>`**: Replace with the address of your validator.
- **`<DELEGATOR_WALLET>`**: Replace with the name of your delegator wallet (the wallet that will collect rewards and restake).
- **`<DELEGATOR_ADDRESS>`**: Replace with your delegator address.

Example:

```python
validator_address = "altheavaloper1xyz..."
delegator_wallet = "my-delegator-wallet"
delegator_address = "althea1xys0n4r80d4tpdm774mx0k8xmz4c073tmy5khv"
```

If you choose not to use the keyring backend, you can also configure it manually. However, if you opt to use the installation script, the keyring will be automatically configured based on your input.

### 4. Configuration File (`config.txt`)

The installation script will generate a `config.txt` file in the bot’s installation directory with the following structure:

```
VALIDATOR_ADDRESS=<your_validator_address>
DELEGATOR_WALLET=<your_delegator_wallet>
DELEGATOR_ADDRESS=<your_delegator_address>
KEYRING_BACKEND=<your_keyring_backend>
NODE_URL=<your_node_url>
CHAIN_ID=<your_chain_id>
FEES=<your_fees>
GAS=<your_gas>
```

This file is used by the bot to fetch your configuration settings. If you need to change these values later, you can edit the `config.txt` file directly.

### 5. Manually Running the Script

If you wish to run the bot manually (outside of the cron job), you can do so by executing the following command:

```bash
python3 ~/althea-restake-bot/restake_bot.py
```

This will collect rewards, restake 50% of them, and provide updates in the terminal.

### 6. Cron Job

If you set up the bot using the installation script, it will automatically create a cron job to run the bot at your chosen interval.

To check or modify the cron job:

1. Open the crontab file:

    ```bash
    crontab -e
    ```

2. The cron job entry will look something like this:

    ```bash
    */240 * * * * python3 ~/althea-restake-bot/restake_bot.py
    ```

This will run the script every 4 hours. If you wish to change the interval, you can modify the cron job directly.

### 7. Keyring Backend (Optional)

The bot supports using a keyring backend to store your keys and avoid entering your password each time you run the bot.

If you want to configure the keyring backend, you have the following options:

- **os**: Use the operating system's keyring (default).
- **file**: Store keys in a file.
- **test**: Use a temporary test keyring (not recommended for production).

The installation script will ask you to select one of these options during setup.

### 8. License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
