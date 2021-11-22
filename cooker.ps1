 Function Select-FolderDialog
{
    param([string]$Description="Select folder",[string]$RootFolder="Desktop")

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
    $objForm.Rootfolder = $RootFolder
    $objForm.Description = $Description
    $Show = $objForm.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
    If ($Show -eq "OK")
    {
        Return $objForm.SelectedPath
    }
    Else
    {
        Write-Error "Operation cancelled by user."
    }
}

 Function Select-FileDialog
{
    param([string]$Description="Select file",[string]$RootFolder="Desktop")

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $objForm = New-Object System.Windows.Forms.OpenFileDialog
    $objForm.InitialDirectory = $RootFolder
    $objForm.Title = $Description
    $Show = $objForm.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
    If ($Show -eq "OK")
    {
        Return $objForm.FileName
    }
    Else
    {
        Write-Error "Operation cancelled by user."
    }
}

$waterMarkPath = Select-FileDialog("Select your watermark")
echo "Your watermark is: $waterMarkPath"

if (!$waterMarkPath) {
    exit
}

$videoPath = Select-FolderDialog("Select your video folder")
echo "Your video folder is: $videoPath"

if (!$videoPath) {
    exit
}

$subtitlePath = Select-FolderDialog("Select your subtitle foler")
echo "Your subtitle folder is: $subtitlePath"

$subExt = Read-Host -Prompt "Please input your subtitle file extension (e.g. ass or csv.ass)"

if (!$subtitlePath) {
    exit
}

echo ""
echo "==================Cooking================="

Get-ChildItem $videoPath |
Foreach-Object {
    $videoFullName = $_.FullName
    echo "Found video file: $videoFullName"

    $fileName = [io.path]::GetFileNameWithoutExtension($_.FullName)
    $subtitleFile = "$subtitlePath\${fileName}_ass.$subExt"
    echo "Looking for matching ass file: $subtitleFile"

    if (![System.IO.File]::Exists($subtitleFile)) {
        echo "Error: $subtitleFile do not exist"
        echo ""
        return
    }

    echo "Subtitle found ..."
    echo "Start processing ..."

    $waterMarkWinPath = $waterMarkPath -replace "\\", "\\\\\"
    $waterMarkWinPath = $waterMarkWinPath -replace ":", "\\:"

    $subtitleFileWinPath = $subtitleFile -replace "\\", "\\\\\"
    $subtitleFileWinPath = $subtitleFileWinPath -replace ":", "\\:"

    .\ffmpeg.exe -y -i "$videoFullName" -c:v libx264 -vf “movie=${waterMarkWinPath}[wm];[i][wm]overlay=24:10,subtitles=${subtitleFileWinPath}” ${fileName}_ass.mp4

    echo "Finished processing for $videoFullName"
    echo ""
}
