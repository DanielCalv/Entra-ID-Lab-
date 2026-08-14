# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Define the security groups to create
$groups = @(
    "IT-Users"
    "Finance-Users"
    "HR-Users"
    "Sales-Users"
    "Marketing-Users"
    "Development-Users"
    "Operations-Users"
    "Managers"
)

# Process each group
foreach ($groupName in $groups) {

    Write-Host "Processing $groupName..."

    # Check whether the group already exists
    $existingGroup = Get-MgGroup -Filter "displayName eq '$groupName'"

    # Skip the group if it already exists
    if ($existingGroup) {
        Write-Host "$groupName already exists - skipping." -ForegroundColor Yellow
        continue
    }

    # Create the security group
    New-MgGroup `
        -DisplayName $groupName `
        -MailEnabled:$false `
        -MailNickname $groupName `
        -SecurityEnabled:$true `
        -GroupTypes @()

    Write-Host "Group created: $groupName" -ForegroundColor Green
}