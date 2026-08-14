# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All", "User.Read.All"

# Import users from CSV
$users = Import-Csv "C:\Users\daniel\OneDrive - Pendle Connections Ltd\Lboro\Pendle\Entra ID\users.csv"

# Temporarily use only the first user for testing
# $users = $users | Select-Object -First 1

# Mapping from department to group name 
$departmentGroups = @{
    "IT" = "IT-Users"
    "Finance" = "Finance-Users"
    "Human Resources" = "HR-Users"
    "Sales" = "Sales-Users"
    "Marketing" = "Marketing-Users"
    "Development" = "Development-Users"
    "Operations" = "Operations-Users"
}

# Process each user in the CSV
foreach ($user in $users) {
	# Get the users department from the CSV
    	$department = $user.Department

    	# Find the corresponding Entra group name
    	$departmentGroupName = $departmentGroups[$department]

    	# Find the group in Microsoft Entra ID
    	$departmentGroup = Get-MgGroup -Filter "displayName eq '$departmentGroupName'"

	$userPrincipalName = "$($user.FirstName).$($user.LastName)@digisolutionscustomers.onmicrosoft.com".ToLower()
	$entraUser = Get-MgUser -UserId $userPrincipalName
	
	# Get the current members of the department group
    	$groupMembers = Get-MgGroupMember -GroupId $departmentGroup.Id -All
	
	if ($entraUser.Id -in $groupMembers.Id) { 
		Write-Host "User already in group, skipping.." -ForegroundColor Yellow
	}
	else { 
		
		#Write-Host $entraUser.DisplayName
		#Write-Host $entraUser.Id

		Write-Host "User: $($entraUser.DisplayName)"
		Write-Host "Group: $($departmentGroup.DisplayName)"
		Write-Host "Adding user to group..."

		# Adding the Entra user to their corresponding department security group
		New-MgGroupMember -GroupId $departmentGroup.Id -DirectoryObjectId $entraUser.Id
	}

	
	if ($user.JobTitle -like "*Manager*") {
		# add user to managers 

		# find the Managers group
    		$managerGroup = Get-MgGroup -Filter "displayName eq 'Managers'"

		# Get the current members of the Managers group
    		$managerGroupMembers = Get-MgGroupMember -GroupId $managerGroup.Id -All

		if ($entraUser.Id -in $managerGroupMembers.Id) { 
			Write-Host "User already in manager group, skipping.." -ForegroundColor Yellow
		}
		else {

    			# Add the user to the Managers group
    			New-MgGroupMember -GroupId $managerGroup.Id -DirectoryObjectId $entraUser.Id
			Write-Host "Adding user to group.." -ForegroundColor Yellow
		}
	}

}

