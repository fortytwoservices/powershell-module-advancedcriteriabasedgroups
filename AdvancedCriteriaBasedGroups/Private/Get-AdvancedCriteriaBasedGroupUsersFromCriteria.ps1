
function Get-AdvancedCriteriaBasedGroupUsersFromCriteria {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true)]
        [ScriptBlock] $Criteria
    )

    Process {
        Write-Verbose "Evaluating criteria: $Criteria"
        $Script:AllUsers.Values | 
        Where-Object -FilterScript $Criteria |
        ForEach-Object { $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_ }
    }
}