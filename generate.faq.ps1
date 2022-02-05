
function GenFAQ {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateSet("onedrive", "azure", "box", "github-com-students", "github-com-projects","sharepoint")]
    #,ErrorMessage="Value '{0}' is invalid. Try one of: '{1}'"
    $application
  )

  $pre = @'
<!DOCTYPE html>
<html lang="{0}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{1} FAQ - {0}</title>
</head>
<body>
'@


  $post = @'
</body>
</html>      
'@

  $template2 = @'
  <details>
    <summary class="blue">{0}</summary>
    <p>{1}</p>
  </details>
'@

  # Specify language supported
  $lang = "en", "sv"

  # Get data
  $jsonData = "faq.json"
  $json = Get-Content -Raw $jsonData | ConvertFrom-Json

  # Filter data
  $jsonFiltered = $json | Where-Object { $_.service -eq $application }
  
  
  # Backup data
  $bFile = $jsonData + "." + $(get-date -Format yyyy-MM-dd.HHmm)
  Copy-Item $jsonData .\backup\$bFile

  foreach ($language in $lang) {

    # File output
    $outFile = ".\docs\" + $application + "." + $language + ".html"

    # Removing old file
    Remove-Item $outFile -Force -ErrorAction SilentlyContinue -Verbose


    if ($language -eq "en") { 
      $tmpPre = $pre
      $tmpPre -f $language, $application | Out-File $outFile -Append -Encoding utf8NoBOM 
    
    }
    else { 
      $tmpPre = $pre
      $tmpPre -f $language, $application | Out-File $outFile -Append -Encoding utf8NoBOM 
    
    }
    
  
    # Generating content
    $jsonFiltered |  ForEach-Object {

      if ($language -eq "en") {

        $temp = $template2
        $q = $_.en_a
        $a = $_.en_q
        $temp -f $q, $a | Out-File $outFile -Append -Encoding utf8NoBOM

      }
      else {
        $temp = $template2
        $q = $_.sv_q
        $a = $_.sv_a
        $temp -f $q, $a | Out-File $outFile -Append -Encoding utf8NoBOM

      }
    
      # Generating post data
      $post | Out-File $outFile -Append -Encoding utf8NoBOM

    }
    
  }
}










