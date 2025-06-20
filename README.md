# Azure VM Startup Script

This repository contains a simple Azure CLI script designed to start a predefined set of Azure Virtual Machines (VMs). It's particularly useful for development or test environments where you might want to power on specific VMs on demand, without manually navigating through the Azure portal.

-----

## Features

  * **Batch VM Startup:** Easily start multiple Azure VMs with a single script execution.
  * **External Configuration:** VM details are stored in a separate configuration file (`vm_config.sh`), which can be excluded from version control (e.g., using `.gitignore`) for security and portability.
  * **Configuration Template:** An example configuration file (`vm_config.sh.example`) is provided to help users quickly set up their VM declarations.
  * **Error Handling:** Basic checks are included to ensure the configuration file exists and provides feedback on the success or failure of each VM startup command.

-----

## Prerequisites

Before running this script, ensure you have the following:

  * **Azure CLI:** Installed on your local machine. If you don't have it, you can find installation instructions [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
  * **Bash 4.0+:** This script utilizes Bash features (like associative arrays) that require Bash version 4.0 or newer. You can check your Bash version with `bash --version`.
      * On macOS, the default system Bash might be older. You can install a newer version using Homebrew: `brew install bash`.
  * **Azure Account:** An active Azure subscription with permissions to start the target VMs.
  * **Logged into Azure:** You must be logged into your Azure account via the Azure CLI. Open your terminal and run:
    ```bash
    az login
    ```
    Follow the prompts to complete the authentication process.

-----

## Setup and Usage

Follow these steps to set up and run the script:

### 1\. Clone the Repository (Optional)

If you're tracking this script with Git, clone your repository:

```bash
git clone <your-repo-url>
cd <your-repo-directory>
```

Otherwise, simply create the files manually in a directory of your choice.

### 2\. Prepare the Configuration File

You'll use the provided example to create your personal configuration file.

  * **Copy the Example:** First, copy the `vm_config.sh.example` file to `vm_config.sh` in the same directory:

    ```bash
    cp vm_config.sh.example vm_config.sh
    ```

  * **Customize `vm_config.sh`:** Now, open `vm_config.sh` and edit the `vms_to_start` array. This file will hold the names of your VMs and their corresponding resource groups.

    **`vm_config.sh` (Example Content)**

    ```bash
    #!/bin/bash

    # Define an associative array where keys are VM names and values are their Resource Group names.
    # IMPORTANT: Replace these with your actual VM names and Resource Group names.
    # This file SHOULD BE ADDED TO YOUR .gitignore to prevent committing sensitive information.

    declare -A vms_to_start
    vms_to_start=(
        ["YourVMName1"]="YourResourceGroup1"
        ["YourVMName2"]="YourResourceGroup2"
        ["AnotherVM"]="YourResourceGroup1" # Example: Multiple VMs in the same RG
    )
    ```

    **Customize the `vms_to_start` array** with your actual Azure VM names and the names of the resource groups they reside in.

### 3\. Make the Script Executable

Before running, you need to grant execute permissions to `start_vms.sh`. Open your terminal, navigate to the directory where you saved the script, and run:

```bash
chmod +x start_vms.sh
```

### 4\. Run the Script

Execute the script from your terminal:

```bash
./start_vms.sh
```

The script will then attempt to start each VM defined in your `vm_config.sh` file and provide status updates.

-----

## Troubleshooting

### `declare: -A: invalid option` Error or Script Not Using Updated Bash

If you've updated your Bash version (e.g., to Bash 4.0+ using Homebrew on macOS) but are still encountering errors like `declare: -A: invalid option`, it means your script is likely still being executed by an older version of Bash.

This often happens because your system's default `bash` or your shell's `PATH` might be pointing to an older installation, even if a newer version is present.

**Solution:** Explicitly tell your script to use the newer Bash by updating its "shebang" line.

1.  **Identify the path to your new Bash:**
    Open your terminal and run:

    ```bash
    which -a bash
    ```

    Look for the path that corresponds to your newly installed Bash (e.g., `/opt/homebrew/bin/bash` on macOS with Homebrew).

2.  **Update the Shebang in Your Scripts:**
    Edit both `start_vms.sh` and `vm_config.sh`. Change the very first line (`#!/bin/bash`) in both files to point directly to the path of your new Bash executable.

    For example, if your new Bash is at `/opt/homebrew/bin/bash`, change the first line in both files to:

    ```bash
    #!/opt/homebrew/bin/bash
    ```

    Save both files after making this change.

3.  **Rerun the Script:**
    Try running the script again:

    ```bash
    ./start_vms.sh
    ```

    This should now execute the script using your updated Bash version, resolving the `declare -A` error.
