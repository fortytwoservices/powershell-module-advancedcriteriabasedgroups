<#
.SYNOPSIS
    Adds users to a group based on a specified criteria.

.DESCRIPTION
    This function adds users to a group based on a specified criteria. The criteria can be a script block that returns a boolean value for each user. If the script block returns $true, the user will be added to the group.
    The function can also be used to add all members of a specified group to the group.

.EXAMPLE
    Add-AdvancedCriteriaBasedGroupMembers -Criteria { $_.UserPrincipalName -like "*@contoso.com" }

    This example adds all users with a UserPrincipalName ending with @contoso.com to the group.

.EXAMPLE
    Add-AdvancedCriteriaBasedGroupMembers -Criteria { $_.JobTitle -like "Engineer" }

    This example adds all users with a JobTitle equal to Engineer to the group.

.EXAMPLE
    Add-AdvancedCriteriaBasedGroupMembers -Criteria { ($_.EmployeeId -ge 1010) -and ($_.EmployeeId -le 1020) }

    This example adds all users with an EmployeeId between 1010 and 1020 to the group.

.EXAMPLE
    Add-AdvancedCriteriaBasedGroupMembers -MembersOfGroupObjectId "2f4a2003-3684-4139-bff6-d737813991b5"

    This example adds all members of the group with the object id 2f4a2003-3684-4139-bff6-d737813991b5 to the group.
#>

function Add-AdvancedCriteriaBasedGroupMembers {
    [CmdletBinding(DefaultParameterSetName = "Criteria")]

    Param(
        #The criteria to use to determine which users to add to the group
        [Parameter(Mandatory = $true, ParameterSetName = "Criteria")]
        [ScriptBlock] $Criteria,

        # The object id of the group where users should be fetched from
        [Parameter(Mandatory = $true, ParameterSetName = "GroupMembers")]
        [String] $MembersOfGroupObjectId,

        # Switch to return the added users
        [Parameter(Mandatory = $false)]
        [Switch] $Passthru
    )

    Process {
        # Call the Get-AdvancedCriteriaBasedGroupUsersFromCriteria function to filter out the users that should be added from cached users
        if ($PSCmdlet.ParameterSetName -eq "Criteria") {
            $UsersToAdd = Get-AdvancedCriteriaBasedGroupUsersFromCriteria -Criteria $Criteria
        }
        # Get all members of the specified group if -MembersOfGroupObjectId is specified
        elseif ($PSCmdlet.ParameterSetName -eq "GroupMembers") {
            try {
                Write-Verbose "Getting members of group $MembersOfGroupObjectId"
                $UsersToAdd = Get-MgGroupMember -GroupId $MembersOfGroupObjectId | ForEach-Object { $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_ }
            } catch {
                Write-Error "Unable to retrieve members of group $($MembersOfGroupObjectId): $($_)"
                return
            
            }
        }
        else {
            Write-Error "Unable to determine parameter set"
            return
        }
        # Create statistics for user to add to group
        $count = 0
        $addedCount = 0
        $alreadyAddedCount = 0

        # Loop through the users to add and ignore users that are already added
        $UsersToAdd |
        ForEach-Object {
            $count += 1
            if ($Script:AddedMembers[$Script:Group.Id].ContainsKey($_.Id)) {
                $alreadyAddedCount += 1
                Write-Debug "User $($_.id) already added"
            }
            else {
                $addedCount += 1
                Write-Debug "Adding user $($_.id)"
                $Script:AddedMembers[$Script:Group.Id][$_.Id] = $_
            }

            if ($Passthru.IsPresent) {
                $_
            }
        }

        Write-Verbose ("Found a total of $count users{0}" -f ($alreadyAddedCount -gt 0 ? ", of which $alreadyAddedCount were already added" : ""))
    }
}