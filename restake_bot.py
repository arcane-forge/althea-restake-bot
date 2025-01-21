import subprocess
import time

# Your wallet information and node details
validator_address = "<VALIDATOR_ADDRESS>"  # Replace with your validator address
delegator_wallet = "<DELEGATOR_WALLET>"  # Replace with your delegator wallet name
node_url = "https://althea-rpc.polkachu.com:443"
chain_id = "althea_258432-1"
fees = "35000000000000000aalthea"
gas = "350000"

# Function to execute a command and capture its output
def run_command(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    return result.stdout.strip()

# Function to query for available rewards
def query_rewards():
    query_command = f"althea query distribution rewards {delegator_wallet} {validator_address} --from {delegator_wallet} --node {node_url} --chain-id {chain_id}"
    print("Querying for rewards...")
    output = run_command(query_command)
    print(f"Raw Query result: {output}")  # Print the full query result for debugging
    return output

# Function to collect rewards
def collect_rewards():
    withdraw_command = f"althea tx distribution withdraw-rewards {validator_address} --commission --from {delegator_wallet} --node {node_url} --chain-id {chain_id} --fees {fees} --gas {gas} -y"
    print("Collecting rewards...")
    output = run_command(withdraw_command)
    print(f"Rewards collected: {output}")
    return output

# Function to restake tokens
def restake_tokens(amount):
    delegate_command = f"althea tx staking delegate {validator_address} {amount} --from {delegator_wallet} --node {node_url} --chain-id {chain_id} --fees {fees} --gas {gas} --keyring-backend file -y"  # Change keyring-backend if needed
    print(f"Restaking {amount} tokens...")
    output = run_command(delegate_command)
    print(f"Tokens restaked: {output}")

# Function to check the status of the transaction
def check_transaction_status(txhash):
    print(f"Checking transaction status for txhash: {txhash}")
    query_command = f"althea query tx {txhash} --node {node_url}"
    tx_status = run_command(query_command)
    print(f"Transaction status: {tx_status}")
    return tx_status

# Main function to collect and restake
def main():
    # Step 1: Query rewards
    rewards_collected = query_rewards()

    # Check if the query result is empty or contains an error
    if not rewards_collected or "rewards:" not in rewards_collected:
        print("No rewards data found or query failed.")
        print("Exiting...")
        return

    # Step 2: Parse the amount of rewards
    try:
        # Look for the 'amount' field in the YAML-like output and extract the value
        lines = rewards_collected.splitlines()
        for line in lines:
            if "amount:" in line:
                # Extract the reward amount (strip the leading "amount: " and trailing " aalthea")
                earned_tokens_str = line.split(":")[1].strip().strip('"')
                earned_tokens = float(earned_tokens_str)  # Convert to float
                restake_amount = earned_tokens * 0.5  # Restake 50%
                restake_amount_with_denom = f"{restake_amount}aalthea"  # Add the "aalthea" denomination back

                print(f"Restaking {restake_amount_with_denom} tokens out of {earned_tokens_str} aalthea.")

                # Step 3: Collect rewards
                collect_output = collect_rewards()

                # Extract txhash from the reward collection transaction
                txhash = collect_output.split("txhash:")[1].strip().split()[0]
                print(f"Collected rewards, txhash: {txhash}")

                # Step 4: Wait for the reward withdrawal transaction to be confirmed
                print("Waiting for reward withdrawal transaction to be confirmed...")
                time.sleep(10)  # Wait 10 seconds before checking transaction status

                # Check if the transaction was successful
                tx_status = check_transaction_status(txhash)
                if "code" in tx_status and "0" in tx_status:  # Check for a successful transaction
                    print("Transaction confirmed successfully, proceeding with restaking.")
                    # Step 5: Restake 50% of rewards
                    restake_tokens(restake_amount_with_denom)
                else:
                    print("Transaction failed or is still pending. Retrying...")
                    break  # Exit the loop and try again next time
    except Exception as e:
        print(f"Error parsing or restaking: {e}")

if __name__ == "__main__":
    main()
