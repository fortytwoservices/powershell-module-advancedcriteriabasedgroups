<#
.DESCRIPTION
    Function that filters users from the AllUsers cache based on a criteria and usually saves the result in a variable.

.EXAMPLE
    $Users = Get-AdvancedCriteriaBasedGroupUsersFromCriteria -Criteria { $_.UserPrincipalName -like "*@contoso.com" }
    
    This example gets all users with a UserPrincipalName ending with @contoso.com and saves them in the $Users variable.
#>
function Get-AdvancedCriteriaBasedGroupUsersFromCriteria {
    [CmdletBinding()]

    Param(
        # Criteria to filter users
        [Parameter(Mandatory = $true)]
        [ScriptBlock] $Criteria
    )

    Process {
        Write-Verbose "Evaluating criteria: $Criteria"
        # Cycle through AllUsers cache and filter them based on the criteria
        $Script:AllUsers.Values | 
        Where-Object -FilterScript $Criteria |
        ForEach-Object { $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_ }
    }
}