
function Add-AdvancedCriteriaBasedGroupMembers {
    [CmdletBinding(DefaultParameterSetName = "Criteria")]

    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "Criteria")]
        [ScriptBlock] $Criteria,

        [Parameter(Mandatory = $false)]
        [Switch] $Passthru
    )

    Process {
        if($PSCmdlet.ParameterSetName -eq "Criteria") {
            $count = 0
            Write-Verbose "Evaluating criteria: $Criteria"
            $Script:AllUsers | 
            Where-Object -FilterScript $Criteria |
            ForEach-Object {
                Write-Debug "Adding user $($_.id)"
                $count += 1
                $Script:AddedMembers[$Script:Group.Id][$_.Id] = $_
                
                if($Passthru.IsPresent) {
                    $_
                }
            }

            Write-Verbose "Criteria matched $count users"
        }
        else {
            Write-Error "Unable to determine parameter set"
        }
    }
}