# gtlin Command Setup Guide

The `gtlin` command is a custom shell function that streamlines creating git branches from Linear issues. It automatically fetches the Linear issue title and creates a branch using Graphite.

## Prerequisites

Before setting up `gtlin`, make sure you have these tools installed:

1. **Linear CLI** - Install from https://github.com/linearapp/linear or:
   ```bash
   npm install -g @linear/cli
   ```

2. **Graphite CLI** - Install from https://graphite.dev/docs/getting-started or:
   ```bash
   npm install -g @graphite.dev/gt
   ```

## Setup Instructions

### 1. Get Your Linear API Key
1. Go to https://linear.app/settings/account/security
2. Create a new API key
3. Copy the key (it will look like `lin_api_xxxxxxxxxxxxxxxx`)

### 2. Download and Install the gtlin Function

Create the function file in your home directory:

```bash
curl -o ~/gtlin-function.sh https://raw.githubusercontent.com/[YOUR-REPO]/gtlin-function.sh
```

Or manually create `~/gtlin-function.sh` with this content:

```bash
#!/bin/bash

# Function to create a git branch from a Linear issue
# Usage: gtlin "HER-123-fix-user-authentication"
gtlin() {
    local branch_name="$1"
    
    # Validate input
    if [[ -z "$branch_name" ]]; then
        echo "Error: Branch name is required"
        echo "Usage: gtlin 'HER-xy-name-of-branch'"
        return 1
    fi
    
    # Check if LINEAR_API_KEY is set
    if [[ -z "$LINEAR_API_KEY" ]]; then
        echo "Error: LINEAR_API_KEY environment variable is not set"
        echo "Please set your Linear API token: export LINEAR_API_KEY='your-token-here'"
        return 1
    fi
    
    # Extract Linear issue ID from branch name (e.g., HER-123 from HER-123-fix-user-auth)
    local issue_id
    issue_id=$(echo "$branch_name" | grep -o "^HER-[0-9]\+")
    
    if [[ -z "$issue_id" ]]; then
        echo "Error: Branch name must start with HER-xy format (e.g., HER-123-branch-name)"
        return 1
    fi
    
    echo "Extracting issue ID: $issue_id"
    
    # Get issue title using Linear CLI
    local issue_title
    issue_title=$(linear issue title "$issue_id" 2>/dev/null)
    
    # Check if Linear CLI command was successful
    if [[ $? -ne 0 || -z "$issue_title" ]]; then
        echo "Error: Failed to get issue title for $issue_id"
        echo "Make sure the issue exists and you have access to it"
        return 1
    fi
    
    echo "Found Linear issue: $issue_title"
    
    # Run gt create command with the issue title
    echo "Creating branch with gt..."
    gt create "$branch_name" -m "$issue_title"
    
    if [[ $? -ne 0 ]]; then
        echo "Error: gt create command failed"
        return 1
    fi
    
    # Run gt sr command
    echo "Running gt sr..."
    gt sr
    
    if [[ $? -ne 0 ]]; then
        echo "Warning: gt sr command failed"
        return 1
    fi
    
    echo "✅ Successfully created branch '$branch_name' with Linear issue title: '$issue_title'"
}

# Export the function so it's available in the shell
export -f gtlin
```

### 3. Set Up Environment Variables

Add these lines to your shell configuration file:

**For zsh (most common on macOS):**
```bash
echo 'export LINEAR_API_KEY=your_actual_api_key_here' >> ~/.zshrc
echo 'source ~/gtlin-function.sh' >> ~/.zshrc
```

**For bash:**
```bash
echo 'export LINEAR_API_KEY=your_actual_api_key_here' >> ~/.bashrc
echo 'source ~/gtlin-function.sh' >> ~/.bashrc
```

**Replace `your_actual_api_key_here` with your actual Linear API key!**

### 4. Reload Your Shell

Either restart your terminal or run:
```bash
source ~/.zshrc  # for zsh
# or
source ~/.bashrc  # for bash
```

### 5. Test the Setup

Try running:
```bash
gtlin --help
```

You should see the usage message if everything is set up correctly.

## Usage

Once set up, you can create branches from Linear issues like this:

```bash
gtlin HER-123-add-user-authentication
```

This will:
1. Extract the issue ID (HER-123) from the branch name
2. Fetch the issue title from Linear
3. Create a new git branch using Graphite with the Linear issue title as the commit message
4. Push the branch and create a PR

## Troubleshooting

### "LINEAR_API_KEY environment variable is not set"
Make sure you've added the export line to your shell config file and reloaded it.

### "linear: command not found"
Install the Linear CLI: `npm install -g @linear/cli`

### "gt: command not found"
Install Graphite CLI: `npm install -g @graphite.dev/gt`

### "Failed to get issue title"
- Make sure the Linear issue exists
- Verify you have access to the issue
- Check that your API key is valid

## What gtlin Does

1. **Validates** the branch name format (must start with HER-XXX)
2. **Extracts** the Linear issue ID from the branch name
3. **Fetches** the issue title from Linear using the CLI
4. **Creates** a new git branch using Graphite
5. **Pushes** the branch and creates a pull request automatically

Perfect for maintaining consistency between Linear issues and git branches!
