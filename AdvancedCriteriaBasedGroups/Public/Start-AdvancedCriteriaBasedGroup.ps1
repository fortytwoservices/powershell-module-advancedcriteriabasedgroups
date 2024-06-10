<#
.SYNOPSIS
    Starts working on a group to which criteria-based membership should be applied.

.DESCRIPTION
    This function starts working on a group to which criteria-based membership should be applied. It retrieves the existing members of the group and prepares to add and remove members based on criteria.

.EXAMPLE
    Start-AdvancedCriteriaBasedGroup -ObjectId "404c71ff-bb33-4434-85e1-2e6c9863d33c" -Verbose

#>
function Start-AdvancedCriteriaBasedGroup {
    [CmdletBinding()]

    Param(
        # The object id of the group to work on
        [Parameter(Mandatory = $true)]
        [string] $ObjectId,
        # Optional switch to use the beta endpoint
        [Parameter(Mandatory = $false)]
        [Switch] $UseGraphBetaEndpoint
    )

    Process {
        $Script:Group = Invoke-MgGraphRequest -Uri "https://$($Script:GraphHostname)/$($UseGraphBetaEndpoint.IsPresent ? "beta" : "v1.0")/groups/$ObjectId" -Method Get
        if (-not $Script:Group) {
            return
        }

        # TODO: Check whether we are owner (or have write permission groupmember.readwrite.all or group.readwrite.all) on the group

        Write-Verbose "Working on group $($Script:Group.DisplayName) ($($Script:Group.Id))"

        # Creates a hashmap of all exising users in the specified group and gets all user properties from $Script:AllUsers
        $Script:ExistingMembers[$Script:Group.Id] = @{}
        Get-MgGroupMember -GroupId $Script:Group.Id -All |
        ForEach-Object {
            $Script:ExistingMembers[$Script:Group.Id][$_.Id] = $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_
        }

        Write-Verbose "Group $($Script:Group.DisplayName) ($($Script:Group.Id)) has $($Script:ExistingMembers[$Script:Group.Id].Count) existing members"

        # Initializes the hashmap of members to add
        $Script:AddedMembers[$Script:Group.Id] = @{}
    }
}