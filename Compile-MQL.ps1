# Gets the File To Compile as an external parameter... Defaults to a Test file...
Param($FileToCompile = "C:\Users\spawn\AppData\Roaming\MetaQuotes\Terminal\776D2ACDFA4F66FAF3C8985F75FA9FF6\MQL5\Experts\Advisors\hectper\hectperScalperMultiChart.mq5")

# Cleans the terminal screen and sets the log file name...
Clear-Host
$LogFile = $FileToCompile + ".log"

# Before continuing, check if the Compile File has any spaces in it...
if ($FileToCompile.Contains(" ")) {
    "";""
    Write-Host "ERROR!  Impossible to Compile! Your Filename or Path contains SPACES!" -ForegroundColor Red
    ""
    Write-Host $FileToCompile -ForegroundColor Red
    "";""
    return
}

# Fires up the Metaeditor compiler...
& "C:\Program Files\FBS MetaTrader 5\metaeditor64.exe" /compile:"$FileToCompile" /log:"$LogFile" /inc:"C:\Users\spawn\AppData\Roaming\MetaQuotes\Terminal\776D2ACDFA4F66FAF3C8985F75FA9FF6\MQL5" | Out-Null

# Get some clean real state and tells the user what is being compiled (just the file name, no path)...
"";"";"";""
$JustTheFileName = Split-Path $FileToCompile -Leaf
Write-Host "Compiling........: $JustTheFileName"
""

# Reads the log file. Eliminates the blank lines. Skip the first line because it is useless.
$Log = Get-Content -Path $LogFile | Where-Object {$_ -ne ""} | Select-Object -Skip 1

# Green color for successful Compilation. Otherwise (error/warning), Red!
$WhichColor = "Red"
$Log | ForEach-Object { if ($_.Contains("0 errors, 0 warnings")) { $WhichColor="Green" } }

# Runs through all the log lines...
$Log | ForEach-Object {
     # Ignores the ": information: error generating code" line when ME was successful
     if (-Not $_.Contains("information:")) {
           # Common log line... just print it...
           Write-Host $_ -ForegroundColor $WhichColor
     }
}
