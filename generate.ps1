function GenFAQ {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateSet("onedrive", "azure", "box")]
    $application
  )

  Add-Type -AssemblyName System.Web
  

  $preEN = @'
  <!DOCTYPE html>
  <html lang="en">
  <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>OneDrive FAQ - English</title>
  </head>
  <body>
'@

$pre = @'
<!DOCTYPE html>
<html lang="sv">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>OneDrive FAQ - Svenska</title>
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

  # Get content from DB
  $jsonData = $application + ".json"

  # Backup data
  $bFile = $jsonData + "." + $(get-date -Format yyyy-MM-dd.HHmm)
 Copy-Item $jsonData .\backup\$bFile

  $json = Get-Content -Raw $jsonData | ConvertFrom-Json


  $lang | ForEach-Object {
    $language = $_
    $outFile = $application + "." + $language + ".html"

    # Removing old file
    Remove-Item $outFile -Force -ErrorAction SilentlyContinue -Verbose

    # Creating new file with pre content
    $pre | Out-File $outFile -Append -Encoding utf8NoBOM

    # Generating content
    $json |  ForEach-Object {


    
      $temp = $template2
      if ( $language = "sv") {
        $q = $_.sv_q
        $a = $_.sv_a
        $temp -f $q, $a | Out-File $outFile -Append -Encoding utf8NoBOM

      }
      else {
        $q = $_.en_q
        $a = $_.en_a
        $temp -f $q, $a | Out-File $outFile -Append -Encoding utf8NoBOM
       
      }

     
    }

    # Generating post data
    $post | Out-File $outFile -Append -Encoding utf8NoBOM

  }

}











