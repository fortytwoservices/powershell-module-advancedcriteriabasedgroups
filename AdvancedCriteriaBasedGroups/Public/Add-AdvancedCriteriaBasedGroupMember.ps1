
function Add-AdvancedCriteriaBasedGroupMember {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $User
    )

    Process {
        if(!$User.Id) {
            Write-Eror "User does not have an Id"
            return
        }

        if(!$Script:Group.Id) {
            Write-Error "Group not set, please use Start-AdvancedCriteriaBasedGroup first"
            return
        }

        if ($Script:AddedMembers[$Script:Group.Id].ContainsKey($_.Id)) {
            Write-Debug "User $($_.id) already added"
        }
        else {
            Write-Debug "Adding user $($_.id)"
            $Script:AddedMembers[$Script:Group.Id][$_.Id] = $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_
        }
    }
}