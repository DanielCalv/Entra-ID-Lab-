# Enterprise Identity Lab

## Overview 
This project implements an enterprise identity environment for a made-up company called Digital Solutions.

This project uses Microsoft Entra ID to demonstrate how an organisation can manage employee identities, control acces, apply security policies and automate administration. 

## Objectives 
The main objectives outlined at the start of the project:
(1) Create and manage employee identities 
(2) Organise users using security groups 
(3) Implement RBAC 
(4) Configure authentication and identity security controls 
(5) Implement SSPR
(6) Configure Conditional Access policies 
(7) Manage access to enterprise applications
(8) Automation using PowerShell
(9) Monitor identity activity using audit and sign in logs 
(10) Test the implemented controls using test user accounts 

## Organisation Structure 
The simulated organisation contains six departments:
1. IT operations
2. Cloud Engineering
3. Cyber Security
4. HR
5. Sales
6. Customer Support

The organisation is modelled at 100 employees, with a smaller representative user set is used within the lab. 

## Features implemented 

### Identity Management 
(1) Employee user accounts 
(2) Department and job title attributes 
(3) Temporary passwords 
(4) Forced password change at first sign-in 
(5) Bulk user provisioning using PowerShell
(6) Microsoft Entra ID user management 

### Security Groups 
Department based security groups were created to organise users and support group based access maangement. The security groups created were:
(1) SG-IT-Operations 
(2) SG-Cloud-Engineering 
(3) SG-Cyber-Security 
(4) SG-HR
(5) SG-Sales 
(6) SG-Customer-Support 

Some additional groups were used for administration and security testing. 

### RBAC 
Microsoft Entra directory roles were used to demonstrate administrative separation and least privilege. The roles created were:
(1) User Administrator 
(2) Groups Administrator 
(3) Security Administrator 

### Authentication 
Microsoft Entra authentication methods were configured and tested. The following were tested using a representative employee account to verify successful authentication:
(1) Password authentication
(2) Microsoft authentication
(3) MFA 
(4) SSPR 

### Conditional Access 
Conditional Access policies were implemented to demonstrate how Microsoft Entra ID makes decisions based on defined conditions. This project included policies designed to demonstrate controls such as:
(1) Requiring MFA 
(2) Blocking legacy authentication
(3) Applying policies to specific test users or groups

### PowerShell Automation 
Microsoft Graph PowerShell was used to automate identity administration. Automation was used to demonstrate tasks such as:
(1) Bulk user creation
(2) User attribute configuration 
(3) Group creation
(4) Administrative role assignment 

## Conclusion
This Enterprise Identity Lab desmonstrates how Microsoft Entra ID can be used to design and operate an enterprise environment. The project combines identity provisioning, group based access, administrative roles, authentication, MFA, SSPR, Conditional Access, monitoring and Powershell Auotmation in a single environment. 
