# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Import users from CSV
$users = Import-Csv "C:\Users\daniel\OneDrive - Pendle Connections Ltd\Lboro\Pendle\Entra ID\users.csv"

# Entra tenant domain
$domain = "digisolutionsuk.onmicrosoft.com"

# Temporary password
$password = "TempPassword123!"

# Process each user in the CSV
foreach ($user in $users) {

    # Generating user details 
    $displayName = "$($user.FirstName) $($user.LastName)" # Combines the first name and last name
    $userPrincipalName = "$($user.FirstName).$($user.LastName)@$domain".ToLower() # Uses first name, last name and domain 
    $mailNickname = "$($user.FirstName).$($user.LastName)".ToLower() # Creates lowercase mail alias from firstname and lastname 

    Write-Host "Processing $displayName..." # Displays message to terminal

    # Checks whether the user already exists
    $existingUser = Get-MgUser -UserId $userPrincipalName -ErrorAction SilentlyContinue

    # If user already exists then display in yellow to user that it is skipping 
    if ($existingUser) {
        Write-Host "$displayName already exists - skipping." -ForegroundColor Yellow
        continue
    }

    # Create the user
    try {
    New-MgUser `
        -DisplayName $displayName `
        -UserPrincipalName $userPrincipalName `
        -AccountEnabled `
        -MailNickname $mailNickname `
        -PasswordProfile @{
            Password = $password
            ForceChangePasswordNextSignIn = $true
        } `
        -Department $user.Department `
        -JobTitle $user.JobTitle `
        -ErrorAction Stop

    Write-Host "User created successfully: $displayName" -ForegroundColor Green
}
catch {
    Write-Host "Failed to create $displayName" -ForegroundColor Red
}
}