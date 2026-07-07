$repoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoPath

Write-Host "Watching for changes in $repoPath..."

while ($true) {
    Start-Sleep -Seconds 5

    $status = git status --porcelain
    if (-not $status) {
        continue
    }

    try {
        git add -A | Out-Null
        git commit -m "Auto-commit $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-Null
        git push | Out-Null
        Write-Host "Pushed changes at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }
    catch {
        Write-Host "Push attempt failed: $($_.Exception.Message)"
    }
}
