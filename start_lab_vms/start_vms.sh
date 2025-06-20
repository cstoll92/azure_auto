#!/opt/homebrew/bin/bash

# Source the configuration file.
# This file contains the declaration of 'vms_to_start' associative array.
# Ensure vm_config.sh is in the same directory or provide the correct path.
CONFIG_FILE="vm_config.sh"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file '$CONFIG_FILE' not found!"
    echo "Please create '$CONFIG_FILE' with your VM declarations."
    exit 1
fi

# Check if the associative array is populated after sourcing
if [ ${#vms_to_start[@]} -eq 0 ]; then
    echo "Error: No VMs defined in '$CONFIG_FILE'."
    echo "Please ensure the 'vms_to_start' array is correctly populated in '$CONFIG_FILE'."
    exit 1
fi

echo "Starting Azure Virtual Machines..."

# Loop through the associative array and start each VM
for vm_name in "${!vms_to_start[@]}"; do
    resource_group="${vms_to_start[$vm_name]}"
    echo "Attempting to start VM: '$vm_name' in Resource Group: '$resource_group'..."

    az vm start --name "$vm_name" --resource-group "$resource_group"

    if [ $? -eq 0 ]; then
        echo "Successfully sent start command for VM: '$vm_name'."
    else
        echo "Failed to send start command for VM: '$vm_name'. Please check the VM name, resource group, and your Azure permissions."
    fi
    echo "" # Add a blank line for readability
done

echo "Script execution complete."