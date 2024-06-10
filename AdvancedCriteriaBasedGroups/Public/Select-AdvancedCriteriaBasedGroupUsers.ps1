<#
.SYNOPSIS
Filters out users based on a specified criteria or group membership

.DESCRIPTION
This function filters out users based on a specified criteria or group membership. The criteria can be a script block that returns a boolean value for each user. If the script block returns $true, the user will be returned.

.EXAMPLE
# This example adds that are a member of a group, and also have a UserPrincipalName ending with @contoso.com
Get-AdvancedCriteriaBasedGroupUsers |
Select-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "20a2a612-fbd5-4fd6-a94a-1edefcdf48a9" |
Select-AdvancedCriteriaBasedGroupUsers -Criteria { $_.UserPrincipalName -like "*@contoso.com" } |
Add-AdvancedCriteriaBasedGroupMember

Complete-AdvancedCriteriaBasedGroup

.EXAMPLE
# This example adds users that are member of all three groups
Get-AdvancedCriteriaBasedGroupUsers |
Select-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "2f4a2003-3684-4139-bff6-d737813991b5" |
Select-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "7572fb59-300d-4fe8-b3c5-047df69d47ef" |
Select-AdvancedCriteriaBasedGroupUsers -MembersOfGroupObjectId "d937e7a1-78e4-4719-9293-675a1a22939d" |
Add-AdvancedCriteriaBasedGroupMember

Complete-AdvancedCriteriaBasedGroup

#>
function Select-AdvancedCriteriaBasedGroupUsers {
     [CmdletBinding()]

     Param(
        # User input object, usually from pipeline
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "Criteria")]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "GroupMembers")]
        $User,

         #The criteria to use to determine which users to add to the group
        [Parameter(Mandatory = $true, ParameterSetName = "Criteria")]
        [ScriptBlock] $Criteria,

        # The object id of the group where users should be fetched from
        [Parameter(Mandatory = $true, ParameterSetName = "GroupMembers")]
        [String] $MembersOfGroupObjectId
     )

     Begin {
        $_GroupMembers = @{}
        if($PSCmdlet.ParameterSetName -eq "GroupMembers") {
            Write-Verbose "Getting members of group $MembersOfGroupObjectId"
            try {
                Get-MgGroupMember -GroupId $MembersOfGroupObjectId | ForEach-Object { $_GroupMembers[$_.Id] = $true }
            } catch {
                Write-Error "Unable to read members of group $MembersOfGroupObjectId, probably due to lack of permissions"
                throw $_
            }
        }
     }

     Process {
        if(!$User.Id) {
            Write-Eror "User does not have an Id"
            return
        } elseif($PSCmdlet.ParameterSetName -eq "GroupMembers") {
            $User | Where-Object {$_GroupMembers.ContainsKey($User.Id)}
        } else {
            $User | Where-Object -FilterScript $Criteria
        }
     }
}