function AnyInterestingPRs
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]]
        $Titles,

        [Parameter(Mandatory=$true)]
        [ValidateSet('patch','minor','major')]
        [string]
        $MaxSemVerIncrement,

        [Parameter()]
        [string[]]
        $PackageWildcardExpressions = @()
    )

    $ErrorActionPreference = 'Stop'

    Enum semver_upgrade_type {
        patch = 0
        minor = 1
        major = 2
    }
    $maxUpdateTypeAsEnum = [semver_upgrade_type]$MaxSemVerIncrement

    $result = $false
    foreach ($prTitle in $Titles) {
        # parse the PR title
        $packageName,$fromVersion,$toVersion,$folder = ParsePrTitle -Title $prTitle

        # apply package filter
        $matchFound = IsPackageInteresting -PackageName $packageName -PackageWildcardExpressions $PackageWildcardExpressions

        # derive upgrade type
        [semver_upgrade_type]$upgradeType = GetSemVerIncrement -FromVersion $fromVersion -ToVersion $toVersion

        if ($matchFound -and ($upgradeType -le $maxUpdateTypeAsEnum)) {
            $result = $true
        }
    }

    return $result
}