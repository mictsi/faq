# Install-Module -Name ImportExcel

# import-module importexcel

$x = Get-Content -Raw .\onedrive.json | ConvertFrom-Json
$x | Export-Excel -Path .\onedrive.xlsx -WorksheetName "FAQ" -FreezeTopRow