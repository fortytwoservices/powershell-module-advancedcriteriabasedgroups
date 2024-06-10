New-Variable -Name Connected -Value $false -Scope Script -Force
New-Variable -Name Group -Value $null -Scope Script -Force
New-Variable -Name ExistingMembers -Value @{} -Scope Script -Force
New-Variable -Name AddedMembers -Value @{} -Scope Script -Force
New-Variable -Name GraphHostname -Value "graph.microsoft.com" -Scope Script -Force

# Get public and private function definition files.
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the files in order to define all cmdlets
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Export all functions
Export-ModuleMember -Function $Public.Basename