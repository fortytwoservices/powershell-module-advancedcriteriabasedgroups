
function Get-AdvancedCriteriaBasedGroupUsers {
    [CmdletBinding(DefaultParameterSetName = "AllUsers")]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "MemberOfGroup")]
        [String] $MembersOfGroupObjectId
    )

    Process {
        if($Script:AllUsers.Values) {
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