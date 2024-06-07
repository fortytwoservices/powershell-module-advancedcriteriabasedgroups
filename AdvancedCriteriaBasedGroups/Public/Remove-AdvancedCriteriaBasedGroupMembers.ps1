<#
.SYNOPSIS
    Removes users from a group based on a criteria or a list of group members.

.DESCRIPTION
    Removes users from a group if user properties no longer match the criteria or if the user is a member of the specified group.

.EXAMPLE
    Remove-AdvancedCriteriaBasedGroupMembers -Criteria { $_.UserPrincipalName -like "admin*"} -Verbose -Debug

    This example removes all users from the group where the UserPrincipalName starts with "admin".

.EXAMPLE
    Remove-AdvancedCriteriaBasedGroupMembers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" -Verbose -Debug

    This example removes all users from the group that are members of the group with the specified object id.

#>
function Remove-AdvancedCriteriaBasedGroupMembers {
    [CmdletBinding(DefaultParameterSetName = "Criteria")]

    Param(
        # Specify a criteria to filter users to remove
        [Parameter(Mandatory = $true, ParameterSetName = "Criteria")]
        [ScriptBlock] $Criteria,

        # Remove user from script group if member of the specified group in this parameter
        [Parameter(Mandatory = $true, ParameterSetName = "GroupMembers")]
        [String] $MembersOfGroupObjectId,

        # Passes the removed users through the pipeline
        [Parameter(Mandatory = $false)]
        [Switch] $Passthru
    )

    Process {

        # Select users from AllUsers and filter them based on the criteria
        if ($PSCmdlet.ParameterSetName -eq "Criteria") {
            $UsersToRemove = Get-AdvancedCriteriaBasedGroupUsersFromCriteria -Criteria $Criteria
        }
        # Retrieve members of group specified in -membersOfGroupObjectId and add them for removal
        elseif ($PSCmdlet.ParameterSetName -eq "GroupMembers") {
            try {
                Write-Verbose "Getting members of group $MembersOfGroupObjectId"
                $UsersToRemove = Get-MgGroupMember -GroupId $MembersOfGroupObjectId | ForEach-Object { $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_ }
            } catch {
                Write-Error "Unable to retrieve members of group $($MembersOfGroupObjectId): $($_)"
                return
            
            }
        }
        else {
            Write-Error "Unable to determine parameter set"
            return
        }

        # Create statistics
        $count = 0
        $removedCount = 0
        $notAddedCount = 0

        # List users to remove
        $UsersToRemove |
        ForEach-Object {
            $count += 1
            if ($Script:AddedMembers[$Script:Group.Id].ContainsKey($_.Id)) {
                $Script:AddedMembers[$Script:Group.Id].Remove($_.Id)
                $removedCount += 1
                Write-Debug "Removing user $($_.id)"
            }
            else {
                $notAddedCount += 1
                Write-Debug "User $($_.id) not added"
            }

            if ($Passthru.IsPresent) {
                $_
            }
        }

        Write-Verbose ("Found a total of $count users to remove{0}" -f ($notAddedCount -gt 0 ? ", of which $notAddedCount were not added" : ""))
    }
}