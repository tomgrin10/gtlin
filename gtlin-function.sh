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
