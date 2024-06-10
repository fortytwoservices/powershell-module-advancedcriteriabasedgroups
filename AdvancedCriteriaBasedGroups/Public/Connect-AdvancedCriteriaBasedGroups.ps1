<#
.SYNOPSIS
    Connects the module to the Microsoft Graph using the specified authentication method.
    Caches all users in Entra ID if -DoNotCacheAllUsers is not specified.

.DESCRIPTION
    Connects the module to the Microsoft Graph using one of the specified methods:
        - User Assigned Managed Identity (Azure Automation Account)
            - Requires environment variable $ENV:AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID to be set to the clientid of the User Assigned Identity.
        - Existing connection (Connect-MgGraph)
    Default behavior is to cache all users in Entra ID. This can be disabled by specifying -DoNotCacheAllUsers.

.EXAMPLE
Use User Assigned Managed Identity as authentication method (default behavior):

Specify the clientid of the User Assigned Identity in the environment variable AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID.

$ENV:AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID = "af029adc-eb93-4130-9896-d939b93ac3da"
Connect-AdvancedCriteriaBasedGroups

.EXAMPLE
Use existing connection to Microsoft Graph:
See this Microsoft Docs article for more information on how to connect to Microsoft Graph: https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.authentication/connect-mggraph?view=graph-powershell-1.0

Connect-AdvancedCriteriaBasedGroups -UseExistingMgGraphConnection
#>


function Connect-AdvancedCriteriaBasedGroups {
    [CmdletBinding(DefaultParameterSetName = "AutomationAccountUserAssignedIdentity")]
    
    param (
        # Connects to Microsoft Graph using existing connection
        [Parameter(Mandatory = $true, ParameterSetName = "MgGraphConnection")]
        [Switch] $UseExistingMgGraphConnection,
        
        # Switch to disable caching of all users in Entra ID
        [Parameter(Mandatory = $false, ParameterSetName = "AutomationAccountUserAssignedIdentity")]
        [Parameter(Mandatory = $false, ParameterSetName = "MgGraphConnection")]
        [Switch] $DoNotCacheAllUsers,
        
        # User properties to include in the cache of all users in Entra ID. Default is $null
        [Parameter(Mandatory = $false, ParameterSetName = "AutomationAccountUserAssignedIdentity")]
        [Parameter(Mandatory = $false, ParameterSetName = "MgGraphConnection")]
        [String[]] $UserProperties = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "AutomationAccountUserAssignedIdentity")]
        [Parameter(Mandatory = $false, ParameterSetName = "MgGraphConnection")]
        [ValidateSet("Global","China","USGov","USGovDoD")]
        [String] $Environment = "Global"

    )

    Process {
        $GraphHostnames = @{
            "Global" = "graph.microsoft.com"
            "China" = "microsoftgraph.chinacloudapi.cn"
            "USGov" = "graph.microsoft.us"
            "USGovDoD" = "dod-graph.microsoft.us"
        }
        $Script:GraphHostname = $GraphHostnames[$Environment]

        # Region Connect to Microsoft Graph
        $Script:Connected = $false

        # Attempts to connect to Microsoft Graph using User Assigned Managed Identity if other auth method has not been specified.
        if ($PSCmdlet.ParameterSetName -eq "AutomationAccountUserAssignedIdentity") {
            Write-Verbose "Using User Assigned Managed Identity as authentication method"

            # Check if the environment variable AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID is set and in the correct format
            if ($ENV:AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID -notlike "*-*-*-*-*") {
                Write-Error "This script is meant to be run in an Azure Automation Account with a User Assigned Identity, and the environment variable AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID set to the clientid of the User Assigned Identity"
                return
            }
            # Connect to Microsoft Graph using the User Assigned Managed Identity
            Connect-MgGraph -Identity -ClientId $ENV:AUTOMATION_SC_USER_ASSIGNED_IDENTITY_ID -NoWelcome -Environment $Environment
            $_context = Get-MgContext

            # Check if the identity has the required permissions
            if ("user.read.all" -notin $_context.Scopes -and "user.readwrite.all" -notin $_context.Scopes) {
                Write-Error "The current context does not have the required permissions to run this script. Please make sure the context has the 'User.Read.All' or 'User.ReadWrite.All' permission."
                return
            }
        }
        # Attempts to use an existing connection to Microsoft Graph
        elseif ($PSCmdlet.ParameterSetName -eq "MgGraphConnection") {
            Write-Verbose "Using existing MgGraph connection"
            #Checks if existing connection runs in AppOnly mode and has the required permissions.
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
        
        # endregion

        # Region Cache all users in Entra ID
        # Builds a cache of all users in Entra ID if -DoNotCacheAllUsers is not specified.
        if (!$DoNotCacheAllUsers.IsPresent) {
            Write-Verbose "Building cache of all users in Entra ID (this may take a while)"
            $Script:AllUsers = @{}
            # Using the beta endpoint to get all UserProperties 
            $uri = "https://$($Script:GraphHostname)/beta/users?`$top=999"

            # Checks if UserProperties has been specified
            if ($UserProperties) {
                $uri += "&`$select=" + ($UserProperties -join ",")
            }

            # Loops through all users in Entra ID and adds them to the cache
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