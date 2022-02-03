# Install-Module -Name ImportExcel

# import-module importexcel

$x = Get-Content -Raw .\faq.json | ConvertFrom-Json
$x | Export-Excel -Path .\faq.xlsx -WorksheetName "FAQ" -FreezeTopRow