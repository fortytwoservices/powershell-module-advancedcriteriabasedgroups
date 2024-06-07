<#
.SYNOPSIS
    Connects the module to the Microsoft Graph using the specified authentication method.

.EXAMPLE
$ENV:AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID = "af029adc-eb93-4130-9896-d939b93ac3da"
Connect-AdvancedCriteriaBasedGroups

.EXAMPLE
Connect-AdvancedCriteriaBasedGroups -UseExistingMgGraphConnection
#>

function Connect-AdvancedCriteriaBasedGroups {
    [CmdletBinding(DefaultParameterSetName = "AutomationAccountUserAssignedIdentity")]
    
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "MgGraphConnection")]
        [Switch] $UseExistingMgGraphConnection,
        
        [Parameter(Mandatory = $false, ParameterSetName = "AutomationAccountUserAssignedIdentity")]
        [Parameter(Mandatory = $false, ParameterSetName = "MgGraphConnection")]
        [Switch] $DoNotCacheAllUsers,
        
        [Parameter(Mandatory = $false, ParameterSetName = "AutomationAccountUserAssignedIdentity")]
        [Parameter(Mandatory = $false, ParameterSetName = "MgGraphConnection")]
        [String[]] $UserProperties = $null

    )

    Process {
        $Script:Connected = $false
        if ($PSCmdlet.ParameterSetName -eq "AutomationAccountUserAssignedIdentity") {
            Write-Verbose "Using User Assigned Managed Identity as authentication method"

            if ($ENV:AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID -notlike "*-*-*-*-*") {
                Write-Error "This script is meant to be run in an Azure Automation Account with a User Assigned Identity, and the environment variable AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID set to the clientid of the User Assigned Identity"
                return
            }
            
            Connect-MgGraph -Identity -ClientId $ENV:AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID -NoWelcome
            $_context = Get-MgContext

            if ("user.read.all" -notin $_context.Scopes -and "user.readwrite.all" -notin $_context.Scopes) {
                Write-Error "The current context does not have the required permissions to run this script. Please make sure the context has the 'User.Read.All' or 'User.ReadWrite.All' permission."
                return
            }
        }
        elseif ($PSCmdlet.ParameterSetName -eq "MgGraphConnection") {
            Write-Verbose "Using existing MgGraph connection"
            $_context = Get-MgContext
            if ($_context.AuthType -eq "AppOnly") {
                if ("user.read.all" -notin $_context.Scopes -and "user.readwrite.all" -notin $_context.Scopes) {
                    Write-Error "The current context does not have the required permissions to run this script. Please make sure the context has the 'User.Read.All' or 'User.ReadWrite.All' permission."
                    return
                }
            }
            else {
                Write-Warning "Using existing connection, but the authentication method is not AppOnly. This may cause issues."
            }
        }
        else {
            Write-Error "Unable to determine authentication method."
            return
        }
        
        $Script:Connected = $true
        
        if (!$DoNotCacheAllUsers.IsPresent) {
            Write-Verbose "Building cache of all users in Entra ID (this may take a while)"
            $Script:AllUsers = @{}
            $uri = "https://graph.microsoft.com/beta/users?`$top=999"

            if ($UserProperties) {
                $uri += "&`$select=" + ($UserProperties -join ",")
            }

            while ($uri) {
                $response = Invoke-MgGraphRequest -Method Get -Uri $uri
                if ($response.value) {
                    $response.value | ForEach-Object {
                        $Script:AllUsers[$_.id] = $_
                    }
                }
                $uri = $response.'@odata.nextLink'
            }

            Write-Verbose "Built cache of $($Script:AllUsers.Count) users"
        }
    }
    
}