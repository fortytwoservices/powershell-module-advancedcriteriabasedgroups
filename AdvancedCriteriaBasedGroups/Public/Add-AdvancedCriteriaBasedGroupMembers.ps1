
function Add-AdvancedCriteriaBasedGroupMembers {
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
            $UsersToAdd = Get-AdvancedCriteriaBasedGroupUsersFromCriteria -Criteria $Criteria
        }
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

        $count = 0
        $addedCount = 0
        $alreadyAddedCount = 0
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