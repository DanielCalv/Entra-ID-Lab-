# Implementation

# 1. Tenant Configuration

# 2. User Management
## 2.1. Objective 
The objective of this stage was to create a set of fictional users within Microsoft Entra ID that could be later organised into security groups and used to demonstrate identity and access management. This was completed using PowerShell and Microsoft Graph rather than manually creating each user individually.

## 2.2. User structure 
For this project I created 20 users which were split across 7 different departments. Each user was given a unique job title relating to the department they were assigned to. The users were distributed across multiple departments to provide a realistic environment for testing group based access control. 

## 2.3. CSV User data 
For the CSV file I created 4 columns; FirstName, LastName, Department and JobTitle. The CSV files acts as the input dataset for the provisioning script. Other values such as the User Principal Name and Display Name were generated automatically by the PowerShell script. 

## 2.4. PowerShell Implementation
The final PowerShell script was developed incrementally. I initially created the script to create a single user. Once I had a single user created I extended the script to create all 20 users by using a foreach loop.

The CSV data was imported using the Import-CSV cmdlet. The script then processed each user and used Microsoft Graph to create the corresponding account within Microsoft Entra ID.

For each record, the script:
(1) Reads the user's first name, last name, department and job title 
(2) Generates the user's display name 
(3) Generates a User Principal Name using the users name and verified tenant domain 
(4) Checks if the user already exists 
(5) Creates the user in Microsoft Entra ID
(6) Assigns the department and job title attributes 
(7) Enables the account and then assigns a temporary password 

The complete script is here: [View the Create-EntraUsers.ps1 script](../scripts/Create-EntraUsers.ps1)

## 2.5. Evidence 
Figure 1 - User provisioning CSV dataset 
![CSV dataset](../screenshots/01-users-csv.png)

Figure 2 - Verification of 20 users imported from CSV
![Verification of Users](../screenshots/02-Verification-users-CSV.png)

Figure 3 - Example Entra ID user and attributes 
![Verification of Entra ID success](../screenshots/03-Verification-Entra-ID-user.png)

# 3. Group Management
## 3.1. Objective
The objective of this stage was to organise the users just created into groups based on the department they are assigned to. For this project, eight security groups were created, with an additional group for managers.

I also created two additional administrative groups: IT-Admins and Security-Admins. These groups will be used to demonstrate RBAC, as outlined in the next section. As 'James Carter' is IT Manager he has been assigned to IT-Admins group, while 'Emily Wilson' has been assigned to Security-Admins.

## 3.2. Group structure 
The following security groups were created: IT-Users, Finance-Users, HR-Users, Sales-Users, Marketing-Users, Development-Users, Operations-Users and Managers. 

## 3.3. Group creation 
The security groups were created as Microsoft Entra security groups rather than Microsoft 365 groups. Security groups were selected as the main purpose of this lab is to manage identity and access rather than provide collaboration features. 

The complete script for creating groups is here: [View the Create-EntraGroups.ps1 script](../scripts/Create-EntraGroups.ps1)

To demonstrate the different approaches to Entra ID administration, the administrative groups (IT-Admins and Security-Admins) were created manually through the Microsoft Entra admin centre rather than through PowerShell. 

## 3.4. PowerShell implementation for assigning users to groups 
The group membership process was automated using the Microsoft Graph PowerShell SDK. 

For each user in the CSV, the script:
(1) Reads the department the user is part of 
(2) Uses the hashtable (described below) to determine the security group name 
(3) Finds the corresponding group in Microsoft Entra ID
(4) Finds the corresponding user using their User Principal Name 
(5) Gets the existing members of the department group
(6) Checks whether the user is already a member 
(7) Adds the user to the group if not 

The PowerShell script uses a hashtable to map the department valuers in the csv file to the corresponding security group names in Microsoft Entra ID. This approach was used as the department name does not always directly match the group name e.g. for HR group. 

The complete script for assigning the users to groups is here: [View the Assign-UsersToGroups.ps1 script](../scripts/Assign-UsersToGroups.ps1)

## 3.5. Evidence 

Figure 1 - Verification of group creation
![Group creation](../screenshots/04-Verification-of-group-creation.png)

Figure 2 - Verification of groups on Entra ID
![Verification of Entra ID success](../screenshots/05-Verification-groups.png)

Figure 3 - Verification of manager group creation
![Verification of manager group](../screenshots/06-Verification-manager-group.png)

# 4. Role-Based Access Control

## 4.1. Objective 
The objective of this stage was to implement RBAC in Microsoft Entra ID to provide users with administrative permissions based on their responsibilities. Rather than assigning administrative roles directly to individual users, role assignable security grousp were used instead. 

Two administrative groups were created: IT-Admin and Security-Admin. 

## 4.2. RBAC Structure 
As stated before I created two administrative groups, IT-Admin and Security-Admin. The IT-Admin group has been given two permissions; User Administration and Groups Administration. The Security-Admin group has been given the single permission Security Administrator. 

## 4.3. User Administrator Testing 
The User Administrator role was tested to verify that members of the IT-Admin group could manage user accounts. The test was performed using James Carter, who is a member of the IT-Admin group. 

James was used to modify the properties of Florence Wright's account. her job title was changed from Operations Executive to Operations Manager. Below is evidence of this change

![Change to Florence Wright's account](../screenshots/10-User-Admin-Check.png)

## 4.4. Groups Administrator Testing 
The Groups Administrator role was tested to verify that members of IT-Admin could manage groups. The test was again performed using James Carter. 

James was used to create a temporary group called RBAC-Test. Below is evidence of this creation

![RBAC group creation](../screenshots/11-Group-Admin-Check.png)

## 4.5. Least Privilege Testing 
A standard user was tested to confirm that users without administrative roles could not perform privileged group management operations. Florence Wright was used as the standard user. She is currently a member of the Operations-Users group and has no Microsoft Entra directory roles assigned. 

Florence attempted to manage the existing Operations-users group. As evident from the screenshot below, Florence is unable to make any administrative changes, including deleting the group. This is shown by the delete group button being greyed out. 

![Least Privilege](../screenshots/12-Florence.png)

## 4.6. Password Reset Testing 
The User Administration role was further tested by demonstrating the ability to reset another user's password. James Carter was again used to access Florence Wright's user account and selected the Reset password button. This caused the password reset to be successfully initiated. 

# 5. Authentication

## 5.1. Objective 
The objective of this stage was to provide secure methods for users to verify their identity when accessing resources. Microsoft Entra ID authentication methods were configured to support password based authentication, MFA, and SSPR. 

## 5.2. Authentication Configuration 
Microsoft Entra authentication methods were reviewed and configured using the Authentication methods policy. Microsoft Authenticator was enabled as the primary authentication method for users. The screenshot below shows the authentication methods policy being enabled. 

![Authenticator Method](../screenshots/13-Authenticator-Method.png)

## 5.3. MFA
Multi-factor authentication was configured using Microsoft Authenticator. MFA provides an additional authentication factor beyond a user's password, requiring users to verify their identity using a registered authentication method.

Microsoft Authenticator was selected as the primary MFA method due to its support for push notifications and one-time passcodes. This set up was tested using one of the users created earlier. 

The registered authentication method was tested by signing in to the account and completing the additional verification request through Microsoft Authenticator. The authentication request was successfully approved, demonstrating that the MFA method is working correctly and as expected. The screenshot below shows the successful set up for the user Charlie Harris. 

![MFA success](../screenshots/14-MFA.png)

## 5.4. Password Authentication
Password authentication is used as the primary authentication factor for Microsoft Entra ID users. Users were given a temporary password when their accounts were created. 

Within the code, when creating the users, there was a line: ForceChangePasswordNextSignIn = True. This line means the users are required to change their password during the first sign in. The screenshot below shows the page users are given when they first try to log into their account.

![New password page](../screenshots/15-Password-Authentication.png)

## 5.5. SSPR 


# 6. Conditional Access

# 7. Enterprise Applications

# 8. Monitoring
