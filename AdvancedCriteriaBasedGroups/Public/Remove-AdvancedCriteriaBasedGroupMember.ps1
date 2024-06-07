
function Remove-AdvancedCriteriaBasedGroupMember {
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
            $Script:AddedMembers[$Script:Group.Id].Remove($_.Id)
            Write-Debug "Removing user $($_.id)"
        }
        else {
            Write-Debug "User $($_.id) not in group"
        }
    }
}