$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

. "$here\ParsePrTitle.ps1"
. "$here\IsPackageInteresting.ps1"
. "$here\GetSemVerIncrement.ps1"

Describe 'AnyInterestingPRs Tests' -Tag Unit {

    Context 'Single PR' {
        It 'should return false when no patterns are specified' {
            $res = AnyInterestingPRs -Titles @('Bump Corvus.Extensions.Newtonsoft.Json from 0.9.0 to 0.9.1 in /Solutions/dependency-playground') `
                                                    -MaxSemVerIncrement 'minor' `
                                                    -PackageWildcardExpressions @()
            $res | Should -BeOfType [boolean]
            $res | Should -Be $false
        }

        It 'should return false when matching patterns are specified with a SemVer upgrade more than MaxSemVerIncrement' {
            $res = AnyInterestingPRs -Titles @('Bump Corvus.Extensions.Newtonsoft.Json from 0.9.0 to 1.0.0 in /Solutions/dependency-playground') `
                                                    -MaxSemVerIncrement 'minor' `
                                                    -PackageWildcardExpressions @('Corvus.*')
            $res | Should -BeOfType [boolean]
            $res | Should -Be $false
        }

        It 'should return true when matching patterns are specified with a SemVer upgrade less than MaxSemVerIncrement' {
            $res = AnyInterestingPRs -Titles @('Bump Corvus.Extensions.Newtonsoft.Json from 0.9.0 to 0.9.1 in /Solutions/dependency-playground') `
                                                    -MaxSemVerIncrement 'minor' `
                                                    -PackageWildcardExpressions @('Corvus.*')
            $res | Should -BeOfType [boolean]
            $res | Should -Be $true
        }

        It 'should return true when matching patterns are specified with a SemVer upgrade equal to MaxSemVerIncrement' {
            $res = AnyInterestingPRs -Titles @('Bump Corvus.Extensions.Newtonsoft.Json from 0.9.0 to 0.10.0 in /Solutions/dependency-playground') `
                                                    -MaxSemVerIncrement 'minor' `
                                                    -PackageWildcardExpressions @('Corvus.*')
            $res | Should -BeOfType [boolean]
            $res | Should -Be $true
        }
    }


}