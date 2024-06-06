
function Start-AdvancedCriteriaBasedGroup {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true)]
        [string] $ObjectId
    )

    Process {
        $Script:Group = Get-MgGroup -GroupId $ObjectId
        if (-not $Script:Group) {
            return
        }

        # TODO: Check whether we are owner (or have write permission groupmember.readwrite.all or group.readwrite.all) on the group

        Write-Verbose "Working on group $($Script:Group.DisplayName) ($($Script:Group.Id))"

        $Script:ExistingMembers[$Script:Group.Id] = @{}
        Get-MgGroupMember -GroupId $Script:Group.Id -All |
        ForEach-Object {
            $Script:ExistingMembers[$Script:Group.Id][$_.Id] = $_
        }

        Write-Verbose "Group $($Script:Group.DisplayName) ($($Script:Group.Id)) has $($Script:ExistingMembers[$Script:Group.Id].Count) existing members"

        $Script:AddedMembers[$Script:Group.Id] = @{}
    }
}