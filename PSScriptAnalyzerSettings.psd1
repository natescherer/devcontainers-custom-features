@{
    ExcludeRules = @(
        "PSAvoidUsingWriteHost",
        "PSUseBOMForUnicodeEncodedFile"
    )
    Rules = @{
        PSAvoidSemicolonsAsLineTerminators = @{
            Enable = $true
        }
        PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true
            NewLineAfter = $true
            IgnoreOneLineBlock = $true
        }
        PSPlaceCloseBrace = @{
            Enable = $true
            NoEmptyLineBefore = $true
            IgnoreOneLineBlock = $true
            NewLineAfter = $false
        }
        PSUseConsistentIndentation = @{
            Enable = $true
        }
        PSUseCorrectCasing = @{
            Enable = $true
        }
    }
}
