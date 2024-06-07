
function Remove-AdvancedCriteriaBasedGroupMembers {
    [CmdletBinding(DefaultParameterSetName = "Criteria")]

    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "Criteria")]
        [ScriptBlock] $Criteria,

        [Parameter(Mandatory = $true, ParameterSetName = "GroupMembers")]
        [String] $MembersOfGroupObjectId,

        [Parameter(Mandatory = $false)]
        [Switch] $Passthru
    )

    Process {
        if ($PSCmdlet.ParameterSetName -eq "Criteria") {
            $UsersToRemove = Get-AdvancedCriteriaBasedGroupUsersFromCriteria -Criteria $Criteria
        }
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

        $count = 0
        $removedCount = 0
        $notAddedCount = 0
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