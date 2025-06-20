#!/opt/homebrew/bin/bash # Ensure this path is correct for your Bash 4.0+ installation

# Source the configuration file.
# This file contains the declaration of 'vms_to_start' associative array.
# Ensure vm_config.sh is in the same directory or provide the correct path.
CONFIG_FILE="vm_config.sh"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file '$CONFIG_FILE' not found!"
    echo "Please create '$CONFIG_FILE' by copying and customizing 'vm_config.sh.example'."
    exit 1
fi

# Check if the associative array is populated after sourcing
if [ ${#vms_to_start[@]} -eq 0 ]; then
    echo "Error: No VMs defined in '$CONFIG_FILE'."
    echo "Please ensure the 'vms_to_start' array is correctly populated in '$CONFIG_FILE'."
    exit 1
fi

echo "Initiating start commands for all Azure Virtual Machines concurrently..."
echo "This script will send all start requests in parallel and then wait for them to be processed."
echo ""

# Array to hold background process IDs
pids=()

# Loop through the associative array and launch each VM start command in the background
for vm_name in "${!vms_to_start[@]}"; do
    resource_group="${vms_to_start[$vm_name]}"
    echo "Sending start command for VM: '$vm_name' in Resource Group: '$resource_group'..."

    # Run the az vm start command in the background
    az vm start --name "$vm_name" --resource-group "$resource_group" &

    # Store the PID of the last background command
    pids+=($!)
done

echo ""
echo "All start commands have been dispatched. Waiting for all background processes to complete..."

# Wait for all background processes to finish
# We'll check the exit status of each individual command later if needed,
# but 'wait' ensures all are finished sending their requests.
for pid in "${pids[@]}"; do
    wait "$pid"
    # Note: Checking $? here would only reflect the exit status of 'wait', not the 'az vm start' command itself.
    # To check individual command success/failure, you'd need more complex logging redirection.
done

echo ""
echo "All VM start requests have been processed by Azure CLI."
echo "Note: This indicates the commands were sent, not necessarily that the VMs are fully running yet."
echo "You can check the VM status in the Azure Portal or using 'az vm show --name <vm-name> --resource-group <rg-name> --query 'powerState''."

echo "Script execution complete."