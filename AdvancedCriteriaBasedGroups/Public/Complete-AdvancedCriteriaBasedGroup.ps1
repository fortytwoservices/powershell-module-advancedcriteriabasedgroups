

function Complete-AdvancedCriteriaBasedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    Param()

    Process {
        #region Process new users
        $Script:AddedMembers[$Script:Group.Id].GetEnumerator() |
        Where-Object { !$Script:ExistingMembers[$Script:Group.Id].ContainsKey($_.Key) } |
        ForEach-Object {
            Write-Verbose "Adding member $($_.Key) to group $($Script:Group.DisplayName) ($($Script:Group.Id))"

            # TODO: Trigger transition in webhooks

            if ($PSCmdlet.ShouldProcess("Group $($Script:Group.Id)", "Add member $($_.Key)")) {
                New-MgGroupMember -GroupId $Script:Group.Id -DirectoryObjectId $_.Key
            }
        }
        #endregion

        #region Process users no longer matching criteria
        $Script:ExistingMembers[$Script:Group.Id].GetEnumerator() |
        Where-Object { !$Script:AddedMembers[$Script:Group.Id].ContainsKey($_.Key) } |
        ForEach-Object {
            Write-Verbose "Removing member $($_.Key) from group $($Script:Group.DisplayName) ($($Script:Group.Id))"

            # TODO: Trigger transition out webhooks

            if ($PSCmdlet.ShouldProcess("Group $($Script:Group.Id)", "Remove member $($_.Key)")) {
                Remove-MgGroupMemberDirectoryObjectByRef -GroupId $Script:Group.Id -DirectoryObjectId $_.Key
            }
        }
        #endregion
    }
}