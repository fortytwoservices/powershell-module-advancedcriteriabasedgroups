
function Add-AdvancedCriteriaBasedGroupMembers {
    [CmdletBinding(DefaultParameterSetName = "Criteria")]

    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "Criteria")]
        [ScriptBlock] $Criteria,

        [Parameter(Mandatory = $false)]
        [Switch] $Passthru
    )

    Process {
        if ($PSCmdlet.ParameterSetName -eq "Criteria") {
            $count = 0
            $addedCount = 0
            $alreadyAddedCount = 0
            Write-Verbose "Evaluating criteria: $Criteria"
            $Script:AllUsers.Values | 
            Where-Object -FilterScript $Criteria |
            ForEach-Object {
                $count += 1
                if ($Script:AddedMembers[$Script:Group.Id].ContainsKey($_.Id)) {
                    $alreadyAddedCount += 1
                    Write-Debug "User $($_.id) already added"
                }
                else {
                    $addedCount += 1
                    Write-Debug "Adding user $($_.id)"
                    $Script:AddedMembers[$Script:Group.Id][$_.Id] = $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_
                }

                if ($Passthru.IsPresent) {
                    $_
                }
            }

            
            Write-Verbose ("Criteria matched a total of $count users{0}" -f ($alreadyAddedCount -gt 0 ? ", of which $alreadyAddedCount were already added" : ""))
        }
        else {
            Write-Error "Unable to determine parameter set"
        }
    }
}