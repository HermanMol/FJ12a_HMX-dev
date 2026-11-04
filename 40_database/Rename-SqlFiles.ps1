<#
.SYNOPSIS
    Recursively rename SQL files by removing a language suffix such as "_eng", "_nld", "_fra", etc.

.DESCRIPTION
    Finds files whose names match:
        _[a-z][a-z][a-z].sql

    Examples:
        customer_eng.sql  -> customer.sql
        order_nld.sql     -> order.sql
        test_fra.sql      -> test.sql

    Supports a dry run mode that only displays the proposed changes.

.PARAMETER Path
    Root folder to scan recursively.

.PARAMETER DryRun
    Show changes without actually renaming files.

.EXAMPLE
    .\Rename-SqlFiles.ps1 -Path "C:\Scripts" -DryRun

.EXAMPLE
    .\Rename-SqlFiles.ps1 -Path "C:\Scripts"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [switch]$DryRun
)

$pattern = '_(?<lang>[a-z]{3})(?=\.sql$)'

Get-ChildItem -Path $Path -Recurse -File |
    Where-Object { $_.Name -match '_[a-z]{3}\.sql$' } |
    ForEach-Object {

        $newName = $_.Name -replace $pattern, ''

        if ($newName -eq $_.Name) {
            return
        }

        $newPath = Join-Path $_.DirectoryName $newName

        if (Test-Path $newPath) {
            Write-Warning "Target already exists: $newPath"
            return
        }

        if ($DryRun) {
            Write-Host "[DRY RUN] $($_.FullName) -> $newName"
        }
        else {
            Rename-Item -LiteralPath $_.FullName -NewName $newName
            Write-Host "[RENAMED] $($_.Name) -> $newName"
        }
    }