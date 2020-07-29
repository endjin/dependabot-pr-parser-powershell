function IsPackageInteresting
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $PackageName,

        [string[]]
        $PackageWildcardExpressions = @()
    )

    $ErrorActionPreference = 'Stop'

    $matchFound = $false
    foreach ($f in $PackageWildcardExpressions) {
        if ($PackageName -ilike $f) {
            $matchFound = $true
            Write-Verbose ("Dependency '{0}' matched with parrern '{1}'" -f $PackageName, $PackageWildcardExpressions)
            break;
        }
    }

    $matchFound
}