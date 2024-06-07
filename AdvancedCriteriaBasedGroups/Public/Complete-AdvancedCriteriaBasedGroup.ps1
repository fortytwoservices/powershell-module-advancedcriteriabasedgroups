

function Complete-AdvancedCriteriaBasedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    Param(
        # A POST of the user object will be sent to the urls
        [Parameter(Mandatory = $false)]
        [String[]] $TransitionInUrls,

        # A POST of the user object will be sent to the urls
        [Parameter(Mandatory = $false)]
        [String[]] $TransitionOutUrls
    )

    Process {
        #region Process new users
        $Script:AddedMembers[$Script:Group.Id].GetEnumerator() |
        Where-Object { !$Script:ExistingMembers[$Script:Group.Id].ContainsKey($_.Key) } |
        ForEach-Object {
            Write-Verbose "Adding member $($_.Key) to group $($Script:Group.DisplayName) ($($Script:Group.Id))"

            # Trigger transition in webhooks
            if ($TransitionInUrls) {
                $body = ConvertTo-Json -Depth 10 -InputObject @{
                    group     = $Script:Group
                    user      = $_.Value
                    operation = "add"
                }

                Write-Verbose "Invoking transition in urls for user $($_.Key)"
                if ($PSCmdlet.ShouldProcess("Group $($Script:Group.Id)", "Invoke transition in urls")) {
                    $TransitionInUrls | ForEach-Object {
                        Write-Debug "Invoking transition in url for user $($_.Key): $_"
                        Invoke-RestMethod -Uri $_ -Method Post -Body $body -ContentType "application/json" -Verbose:$false
                    }
                }
            }

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

            # Trigger transition out webhooks
            if ($TransitionOutUrls) {
                $body = ConvertTo-Json -Depth 10 -InputObject @{
                    group     = $Script:Group
                    user      = $_.Value
                    operation = "remove"
                }

                Write-Verbose "Invoking transition out urls for user $($_.Key)"
                if ($PSCmdlet.ShouldProcess("Group $($Script:Group.Id)", "Invoke transition out urls")) {
                    $TransitionOutUrls | ForEach-Object {
                        Write-Debug "Invoking transition out url for user $($_.Key): $_"
                    
                        Invoke-RestMethod -Uri $_ -Method Post -Body $body -ContentType "application/json" -Verbose:$false
                    }
                }
            }

            if ($PSCmdlet.ShouldProcess("Group $($Script:Group.Id)", "Remove member $($_.Key)")) {
                Remove-MgGroupMemberDirectoryObjectByRef -GroupId $Script:Group.Id -DirectoryObjectId $_.Key
            }
        }
        #endregion
    }
}