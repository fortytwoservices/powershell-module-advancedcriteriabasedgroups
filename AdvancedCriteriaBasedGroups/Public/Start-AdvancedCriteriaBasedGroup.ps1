<#
.DESCRIPTION

.EXAMPLE
Start-AdvancedCriteriaBasedGroup -ObjectId "404c71ff-bb33-4434-85e1-2e6c9863d33c" -Verbose
#>
function Start-AdvancedCriteriaBasedGroup {
    [CmdletBinding()]

    Param(
        # The object id of the group to work on
        [Parameter(Mandatory = $true)]
        [string] $ObjectId,

        [Parameter(Mandatory = $false)]
        [Switch] $UseGraphBetaEndpoint
    )

    Process {
        $Script:Group = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/$($UseGraphBetaEndpoint.IsPresent ? "beta" : "v1.0")/groups/$ObjectId" -Method Get
        if (-not $Script:Group) {
            return
        }

        # TODO: Check whether we are owner (or have write permission groupmember.readwrite.all or group.readwrite.all) on the group

        Write-Verbose "Working on group $($Script:Group.DisplayName) ($($Script:Group.Id))"

        $Script:ExistingMembers[$Script:Group.Id] = @{}
        Get-MgGroupMember -GroupId $Script:Group.Id -All |
        ForEach-Object {
            $Script:ExistingMembers[$Script:Group.Id][$_.Id] = $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_
        }

        Write-Verbose "Group $($Script:Group.DisplayName) ($($Script:Group.Id)) has $($Script:ExistingMembers[$Script:Group.Id].Count) existing members"

        $Script:AddedMembers[$Script:Group.Id] = @{}
    }
}