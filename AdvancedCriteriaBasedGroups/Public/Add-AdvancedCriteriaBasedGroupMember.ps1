<#
.SYNOPSIS
    Adds a user from a group based on a criteria or a list of group members.

.DESCRIPTION
    Adds a user from a group if the user is a member of the specified group.
    Used in conjunction with Get-AdvancedCriteriaBasedGroupUsers to filter users based on attributes.

.EXAMPLE

    Get-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" | 
    Where-Object usageLocation -in "NO" |
    Add-AdvancedCriteriaBasedGroupMember -Debug

    This example Adds all users from the group that are members of the group with the specified object id.

#>
function Add-AdvancedCriteriaBasedGroupMember {
    [CmdletBinding()]

    Param(
            # Piped user object to add from group
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
        #Check if user is already added, else add user to the list of users to add
        if ($Script:AddedMembers[$Script:Group.Id].ContainsKey($_.Id)) {
            Write-Debug "User $($_.id) already added"
        }
        else {
            Write-Debug "Adding user $($_.id)"
            $Script:AddedMembers[$Script:Group.Id][$_.Id] = $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_
        }
    }
}