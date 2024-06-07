<#
.DESCRIPTION
Helper function to simplify the common task of adding members to a group based on the members of other groups, but only if they are not member of some other groups.

.EXAMPLE
# Writes members of groups 22222222-2222-2222-2222-222222222222 and 33333333-3333-3333-3333-333333333333 to group 11111111-1111-11111-1111-111111111111, but only if they are not member of group 44444444-4444-4444-4444-444444444444
Write-AdvancedCriteriaBasedGroupMemberOfButNotMemberOfGroup `
    -DestinationGroup "11111111-1111-1111-1111-111111111111" `
    -MemberOfGroups "22222222-2222-2222-2222-222222222222", "33333333-3333-3333-3333-333333333333" `
    -ButNotMemberOfGroups "44444444-4444-4444-4444-444444444444"
#>

function Write-AdvancedCriteriaBasedGroupMemberOfButNotMemberOfGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    Param(
        [Parameter(Mandatory = $true)]
        $DestinationGroup,

        [Parameter(Mandatory = $true)]
        [String[]] $MemberOfGroups,

        [Parameter(Mandatory = $false)]
        [String[]] $ButNotMemberOfGroups = @()
    )

    Process {
        # Get existing members
        Write-Debug "Getting existing members of group $DestinationGroup"
        $DestinationGroupMembers = (Get-MgGroupMember -GroupId $DestinationGroup -All | Group-Object -AsHashTable -Property id) ?? @{}

        Write-Debug "Getting members of 'member of groups'"
        $MemberOfGroupsMembers = $MemberOfGroups | 
        ForEach-Object { 
            Write-Verbose "Getting members of 'member of group' $($_)"
            Get-MgGroupMember -GroupId $_ -All 
        } | Select-Object -Unique -Property id

        $ButNotMemberOfGroupsMembers = $ButNotMemberOfGroups ? (($ButNotMemberOfGroups | 
                ForEach-Object { 
                    Write-Debug "Getting members of 'but not member of group' $($_)"
                    Get-MgGroupMember -GroupId $_ -All 
                } | Select-Object -Unique -Property id | Group-Object -AsHashTable -Property id) ?? @{}) : @{}

        # Calculate expected members
        $ExpectedMembers = ($MemberOfGroupsMembers | Where-Object { -not $ButNotMemberOfGroupsMembers.ContainsKey($_.id) } | Group-Object -AsHashTable -Property id) ?? @{}

        Write-Verbose "Expected member count for group $DestinationGroup : $($ExpectedMembers.Count)"

        # Make sure expected members are in the destination group
        $ExpectedMembers.GetEnumerator() | 
        Where-Object { !$DestinationGroupMembers.ContainsKey($_.key) } |
        ForEach-Object {
            if ($PSCmdlet.ShouldProcess($DestinationGroup, "Add member $($_.key)")) {
                New-MgGroupMember -GroupId $DestinationGroup -DirectoryObjectId $_.key
            }
            else {
                Write-Verbose "Adding member $($_.key) to group $DestinationGroup"
            }
        }

        # Remove members that are not expected
        $MembersToRemove = $DestinationGroupMembers.GetEnumerator() |
        Where-Object { !$ExpectedMembers.ContainsKey($_.key) }
        if ($MembersToRemove) {
            $MembersToRemove |
            ForEach-Object {
                if ($PSCmdlet.ShouldProcess($DestinationGroup, "Remove member $($_.key)")) {
                    Remove-MgGroupMemberByRef -GroupId $DestinationGroup -DirectoryObjectId $_.key 
                }
                else {
                    Write-Verbose "Removing member $($_.key) from group $DestinationGroup"
                }
            }
        }
    }
}