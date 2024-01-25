@{
    Severity     =@('Warning', 'Error', 'Information')
    ExcludeRules =@('PSAvoidUsingWriteHost')
    Rules        = @{
        PSPlaceOpenBrace  = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }
        PSPlaceCloseBrace = @{
            Enable             = $true
            NoEmptyLineBefore  = $true
            IgnoreOneLineBlock = $true
            NewLineAfter       = $false
        }
    }
}
