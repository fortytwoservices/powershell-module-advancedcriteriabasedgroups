# Documentation for module AdvancedCriteriaBasedGroups

A module for working with advanced criteria for Entra ID groups.

| Metadata | Information |
| --- | --- |
| Version | 1.1.0 |
| Author | Marius Solbakken Mellum and Thomas Rogne Johansen |
| Company name | Fortytwo |
| PowerShell version | 7.1 |

## Add-AdvancedCriteriaBasedGroupMember

### SYNOPSIS
Adds a user from a group based on a criteria or a list of group members.

### SYNTAX

```
Add-AdvancedCriteriaBasedGroupMember [-User] <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Adds a user from a group if the user is a member of the specified group.
Used in conjunction with Get-AdvancedCriteriaBasedGroupUsers to filter users based on attributes.

### EXAMPLES

#### EXAMPLE 1
```
Get-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" | 
Where-Object usageLocation -in "NO" |
Add-AdvancedCriteriaBasedGroupMember -Debug
```

This example Adds all users from the group that are members of the group with the specified object id.

### PARAMETERS

#### -User
Piped user object to add from group

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-AdvancedCriteriaBasedGroupMembers

### SYNOPSIS
Adds users to a group based on a specified criteria.

### SYNTAX

#### Criteria (Default)
```
Add-AdvancedCriteriaBasedGroupMembers -Criteria <ScriptBlock> [-Passthru] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

#### GroupMembers
```
Add-AdvancedCriteriaBasedGroupMembers -MembersOfGroupObjectId <String> [-Passthru]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
This function adds users to a group based on a specified criteria.
The criteria can be a script block that returns a boolean value for each user.
If the script block returns $true, the user will be added to the group.
The function can also be used to add all members of a specified group to the group.

### EXAMPLES

#### EXAMPLE 1
```
Add-AdvancedCriteriaBasedGroupMembers -Criteria { $_.UserPrincipalName -like "*@contoso.com" }
```

This example adds all users with a UserPrincipalName ending with @contoso.com to the group.

#### EXAMPLE 2
```
Add-AdvancedCriteriaBasedGroupMembers -Criteria { $_.JobTitle -like "Engineer" }
```

This example adds all users with a JobTitle equal to Engineer to the group.

#### EXAMPLE 3
```
Add-AdvancedCriteriaBasedGroupMembers -Criteria { ($_.EmployeeId -ge 1010) -and ($_.EmployeeId -le 1020) }
```

This example adds all users with an EmployeeId between 1010 and 1020 to the group.

#### EXAMPLE 4
```
Add-AdvancedCriteriaBasedGroupMembers -MembersOfGroupObjectId "2f4a2003-3684-4139-bff6-d737813991b5"
```

This example adds all members of the group with the object id 2f4a2003-3684-4139-bff6-d737813991b5 to the group.

### PARAMETERS

#### -Criteria
The criteria to use to determine which users to add to the group

```yaml
Type: ScriptBlock
Parameter Sets: Criteria
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -MembersOfGroupObjectId
The object id of the group where users should be fetched from

```yaml
Type: String
Parameter Sets: GroupMembers
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Passthru
Switch to return the added users

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Complete-AdvancedCriteriaBasedGroup

### SYNOPSIS

### SYNTAX

```
Complete-AdvancedCriteriaBasedGroup [[-TransitionInUrls] <String[]>] [[-TransitionOutUrls] <String[]>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### DESCRIPTION
Completes the group membership based on criterias or groupmemberships and triggers webhooks for transitions in and out of the group.

### EXAMPLES

#### EXAMPLE 1
```
Complete-AdvancedCriteriaBasedGroup -TransitionInUrls "https://webhook.com/transitionin" -TransitionOutUrls "https://webhook.com/transitionout"
```

This example completes the group membership based on criterias or groupmemberships and triggers webhooks for transitions in and out of the group.

### PARAMETERS

#### -TransitionInUrls
A POST of the user object will be sent to the urls

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TransitionOutUrls
A POST of the user object will be sent to the urls

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Connect-AdvancedCriteriaBasedGroups

### SYNOPSIS
{{ Fill in the Synopsis }}

### SYNTAX

#### AutomationAccountUserAssignedIdentity (Default)
```
Connect-AdvancedCriteriaBasedGroups [-DoNotCacheAllUsers] [-UserProperties <String[]>] [-Environment <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### MgGraphConnection
```
Connect-AdvancedCriteriaBasedGroups [-UseExistingMgGraphConnection] [-DoNotCacheAllUsers]
 [-UserProperties <String[]>] [-Environment <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

### PARAMETERS

#### -DoNotCacheAllUsers


```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Environment


```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Global, China, USGov, USGovDoD

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -UseExistingMgGraphConnection


```yaml
Type: SwitchParameter
Parameter Sets: MgGraphConnection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -UserProperties


```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

#### None
### OUTPUTS

#### System.Object
### NOTES

### RELATED LINKS
## Get-AdvancedCriteriaBasedGroupUsers

### SYNOPSIS
Gets users from specified group object

### SYNTAX

#### AllUsers (Default)
```
Get-AdvancedCriteriaBasedGroupUsers [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### MemberOfGroup
```
Get-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION
Gets users specified in -MembersOfGroupObjectId using Microsoft Graph

### EXAMPLES

#### EXAMPLE 1
```
Get-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9"
```

This example gets all users from the group with the specified object id

### PARAMETERS

#### -MembersOfGroupObjectId


```yaml
Type: String
Parameter Sets: MemberOfGroup
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## New-MicrosoftGraphServicePrincipalApplicationPermission

### SYNOPSIS
Assigns a service principal certain application permissions for Microsoft Graph

### SYNTAX

```
New-MicrosoftGraphServicePrincipalApplicationPermission [[-GraphPermission] <String[]>] [[-ObjectId] <String>]
 [[-Environment] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
New-MicrosoftGraphServicePrincipalApplicationPermission -ObjectId "00000000-0000-0000-0000-000000000000" -GraphPermission "User.Read.All", "User.ReadWrite.All
```

### PARAMETERS

#### -GraphPermission


```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ObjectId
The objectid of the service principal to assign permissions to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Environment


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Global
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Remove-AdvancedCriteriaBasedGroupMember

### SYNOPSIS
Removes a user from a group based on a criteria or a list of group members.

### SYNTAX

```
Remove-AdvancedCriteriaBasedGroupMember [-User] <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION
Removes a user from a group if the user is a member of the specified group.
Used in conjunction with Get-AdvancedCriteriaBasedGroupUsers to filter users based on attributes.

### EXAMPLES

#### EXAMPLE 1
```
Get-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" | 
Where-Object usageLocation -in "NO" |
Remove-AdvancedCriteriaBasedGroupMember -Debug
```

This example removes all users from the group that are members of the group with the specified object id.

### PARAMETERS

#### -User


```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Remove-AdvancedCriteriaBasedGroupMembers

### SYNOPSIS
Removes users from a group based on a criteria or a list of group members.

### SYNTAX

#### Criteria (Default)
```
Remove-AdvancedCriteriaBasedGroupMembers -Criteria <ScriptBlock> [-Passthru]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### GroupMembers
```
Remove-AdvancedCriteriaBasedGroupMembers -MembersOfGroupObjectId <String> [-Passthru]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Removes users from a group if user properties no longer match the criteria or if the user is a member of the specified group.

### EXAMPLES

#### EXAMPLE 1
```
Remove-AdvancedCriteriaBasedGroupMembers -Criteria { $_.UserPrincipalName -like "admin*"} -Verbose -Debug
```

This example removes all users from the group where the UserPrincipalName starts with "admin".

#### EXAMPLE 2
```
Remove-AdvancedCriteriaBasedGroupMembers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" -Verbose -Debug
```

This example removes all users from the group that are members of the group with the specified object id.

### PARAMETERS

#### -Criteria
Specify a criteria to filter users to remove

```yaml
Type: ScriptBlock
Parameter Sets: Criteria
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -MembersOfGroupObjectId
Remove user from script group if member of the specified group in this parameter

```yaml
Type: String
Parameter Sets: GroupMembers
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Passthru
Passes the removed users through the pipeline

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Select-AdvancedCriteriaBasedGroupUsers

### SYNOPSIS
Filters out users based on a specified criteria or group membership

### SYNTAX

#### GroupMembers
```
Select-AdvancedCriteriaBasedGroupUsers -User <Object> -MembersOfGroupObjectId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### Criteria
```
Select-AdvancedCriteriaBasedGroupUsers -User <Object> -Criteria <ScriptBlock>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
This function filters out users based on a specified criteria or group membership.
The criteria can be a script block that returns a boolean value for each user.
If the script block returns $true, the user will be returned.

### EXAMPLES

#### EXAMPLE 1
```
## This example adds that are a member of a group, and also have a UserPrincipalName ending with @contoso.com
Get-AdvancedCriteriaBasedGroupUsers |
Select-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" |
Select-AdvancedCriteriaBasedGroupUsers -Criteria { $_.UserPrincipalName -like "*@contoso.com" } |
Add-AdvancedCriteriaBasedGroupMember
```

Complete-AdvancedCriteriaBasedGroup

#### EXAMPLE 2
```
## This example adds users that are member of all three groups
Get-AdvancedCriteriaBasedGroupUsers |
Select-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "2f4a2003-3684-4139-bff6-d737813991b5" |
Select-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "7572fb59-300d-4fe8-b3c5-047df69d47ef" |
Select-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "d937e7a1-78e4-4719-9293-675a1a22939d" |
Add-AdvancedCriteriaBasedGroupMember
```

Complete-AdvancedCriteriaBasedGroup

### PARAMETERS

#### -User
User input object, usually from pipeline

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -Criteria
The criteria to use to determine which users to add to the group

```yaml
Type: ScriptBlock
Parameter Sets: Criteria
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -MembersOfGroupObjectId
The object id of the group where users should be fetched from

```yaml
Type: String
Parameter Sets: GroupMembers
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Start-AdvancedCriteriaBasedGroup

### SYNOPSIS
Starts working on a group to which criteria-based membership should be applied.

### SYNTAX

```
Start-AdvancedCriteriaBasedGroup [-ObjectId] <String> [-UseGraphBetaEndpoint]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
This function starts working on a group to which criteria-based membership should be applied.
It retrieves the existing members of the group and prepares to add and remove members based on criteria.

### EXAMPLES

#### EXAMPLE 1
```
Start-AdvancedCriteriaBasedGroup -ObjectId "404c71ff-bb33-4434-85e1-2e6c9863d33c" -Verbose
```

### PARAMETERS

#### -ObjectId
The object id of the group to work on

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -UseGraphBetaEndpoint
Optional switch to use the beta endpoint

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
