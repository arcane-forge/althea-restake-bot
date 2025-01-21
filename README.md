# Althea Restake Bot

This Python script automates the process of collecting and restaking rewards on the Althea blockchain network. It queries for available staking rewards, collects them, and restakes 50% of the rewards every 4 hours. The script supports using a keyring backend (e.g., `file` or `test`) to avoid manual password entry.

## Requirements

- Python 3.6 or later
- Althea CLI (`althead` command)
- Node URL and Chain ID for the Althea network
- Validator and delegator wallet addresses set up in Althea

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/arcane-forge/althea-restake-bot.git
cd althea-restake-bot
```

### 2. Install Dependencies

Ensure you have Python 3.6+ and install the necessary Python packages.

```bash
pip install subprocess
```

### 3. Configure the Script

Open the script `restake_bot.py` and update the following placeholders:

- **`<VALIDATOR_ADDRESS>`**: Replace with the address of your validator.
- **`<DELEGATOR_WALLET>`**: Replace with the name of your delegator wallet (the wallet that will collect rewards and restake).

Example:

```python
validator_address = "altheavaloper1xyz..."
delegator_wallet = "my-delegator-wallet"
```

### 4. Keyring Backend (Optional)

If your keyring is locked, you can set the keyring backend to avoid manual password entry. To set it, modify the script to include the `--keyring-backend` option in the staking delegate command, or set the environment variable.

For example:

```python
delegate_command = f"althea tx staking delegate {validator_address} {amount} --from {delegator_wallet} --node {node_url} --chain-id {chain_id} --fees {fees} --gas {gas} --keyring-backend file -y"
```

Alternatively, you can set the keyring backend globally by adding this to your `.bashrc` or `.zshrc`:

```bash
export ALTHEA_KEYRING_BACKEND="file"
```

### 5. Run the Script

Once the script is configured, you can run it manually to test it:

```bash
python3 restake_bot.py
```

### 6. Automate with Cron

To run the script every 4 hours, you can set up a cron job.

1. Edit the cron job list:

   ```bash
   crontab -e
   ```

2. Add the following line to run the script every 4 hours:

   ```bash
   0 */4 * * * /usr/bin/python3 /path/to/restake_bot.py >> /path/to/logfile.log 2>&1
   ```

   Replace `/path/to/restake_bot.py` with the actual path to your script, and `/path/to/logfile.log` with the desired log file location.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
