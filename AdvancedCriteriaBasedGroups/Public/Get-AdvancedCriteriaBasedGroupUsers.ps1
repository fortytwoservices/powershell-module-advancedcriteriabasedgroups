<#
.SYNOPSIS
    Gets users from specified group object

.DESCRIPTION
    Gets users specified in -MembersOfGroupObjectId using Microsoft Graph

.EXAMPLE
    Get-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9"
    
    This example gets all users from the group with the specified object id
#>
function Get-AdvancedCriteriaBasedGroupUsers {
    [CmdletBinding(DefaultParameterSetName = "AllUsers")]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "MemberOfGroup")]
        [String] $MembersOfGroupObjectId
    )

    Process {
        # Check if users are cached
        if($Script:AllUsers.Values) {
            # Returns all users in specified group 
            if($PSCmdlet.ParameterSetName -eq "MemberOfGroup") {
                Get-MgGroupMember -GroupId $MembersOfGroupObjectId | ForEach-Object { $Script:AllUsers.ContainsKey($_.Id) ? $Script:AllUsers[$_.Id] : $_ }
            } else {
                $Script:AllUsers.Values
            }
        } else {
            Write-Error "No users found in cache"
        }
    }
}