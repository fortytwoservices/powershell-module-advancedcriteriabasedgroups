<#
.SYNOPSIS
    Removes a user from a group based on a criteria or a list of group members.

.DESCRIPTION
    Removes a user from a group if the user is a member of the specified group.
    Used in conjunction with Get-AdvancedCriteriaBasedGroupUsers to filter users based on attributes.

.EXAMPLE

    Get-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" | 
    Where-Object usageLocation -in "NO" |
    Remove-AdvancedCriteriaBasedGroupMember -Debug

    This example removes all users from the group that are members of the group with the specified object id.

#>
function Remove-AdvancedCriteriaBasedGroupMember {
    [CmdletBinding()]
    # Piped user object to remove from group
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $User
    )

    Process {
        # Check if user has an Id
        if(!$User.Id) {
            Write-Eror "User does not have an Id"
            return
        }
        # Check if group is set
        if(!$Script:Group.Id) {
            Write-Error "Group not set, please use Start-AdvancedCriteriaBasedGroup first"
            return
        }
        # Add user to the list of users to remove
        if ($Script:AddedMembers[$Script:Group.Id].ContainsKey($_.Id)) {
            $Script:AddedMembers[$Script:Group.Id].Remove($_.Id)
            Write-Debug "Removing user $($_.id)"
        }
        else {
            Write-Debug "User $($_.id) not in group"
        }
    }
}