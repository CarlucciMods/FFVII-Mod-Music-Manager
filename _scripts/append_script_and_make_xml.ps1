

# Where to look for music files
$scanDirs = @( "New OGG\Arranged", "New OGG\Metal", "New OGG\Remix" )

# What script to modify
$modifyScript = "generate_updated_names_ogg.ps1"

# Filename extensions to consider as music
$filenameExts = @( '.ogg', '.mp4', '.wav' )

# Wildcards for determining music category
$filenameCategories = @{
    # BA - Battle
    BA = @( '*_bat', '*_bat[0-9]', '*_bat[0-9]_[0-9]' );

    # BB - Boss Battle
    BB = @( '*_chu', '*_chu[0-9]', '*_chu[0-9]_[0-9]' );    # maybe also '*_ob[0-9]' soon? for '_ob2.ogg' ones

    # FA - Victory Fanfare
    FA = @( '*_fan', '*_fan[0-9]', '*_fan[0-9]_[0-9]' );
}

# Output XML for the generated list
$outputXml = "modxml_TOADD.xml"



$xmlEntries = @{ BA = @(); BB = @(); FA = @(); }

# The XML list format for each music item
function New-XmlEntry($artist, $genre, $baseName, $category) {
    $xmlEntries[$category] += @"
<Option Value= "00" Name="$artist ($genre) "`t`tPreviewFile="_images\(((REPLACE_ME))).png"`tPreviewAudio="RAND\M\vgmstream\$baseName.ogg"/>`n
"@
}


$toAdd = @{
    BA = @{
        Remix = @();
        Metal = @();
        Arranged = @();
    };
    BB = @{
        Remix = @();
        Metal = @();
        Arranged = @();
    };
    FA = @{
        Remix = @();
        Metal = @();
        Arranged = @();
    };
}



foreach ($dir in $scanDirs) {
    if (! (Test-Path $dir)) {
        Write-Warning "> The '${dir}' directory doesn't exist"
    }
}

if (!(Test-Path -PathType Leaf $modifyScript)) {
    Write-Error "'$modifyScript' doesn't exist."
    pause
    exit
}


if (!(Test-Path -PathType Leaf "taglibsharp.dll")) {
    # Download taglibsharp from https://github.com/illearth/powershell-taglib for media metadata reading
    Invoke-WebRequest "https://github.com/illearth/powershell-taglib/raw/d8dce348372c39de2c4d6079be1de573e68b100b/taglib-sharp.dll" -OutFile "taglibsharp.dll" 
}

# Load the taglib assembly
[System.Reflection.Assembly]::LoadFile((Join-Path (Get-Location).Path "taglibsharp.dll")) | Out-Null




# Get all audio files
$files = @()
foreach ($folder in $scanDirs) {
    foreach ($ext in $filenameExts) {
        $files += @(Get-ChildItem $folder -Include "*$ext" -Recurse)
    }
}

# read media metadata + call New-XmlEntry for each
foreach ($file in $files) {
    $fullName = $file.FullName
    $meta = [TagLib.File]::Create($fullName).Tag

    # Check if metadata exists (title, artist, genre)
    if ($meta.IsEmpty) {
        Write-Warning "> '$fullName' does not have any tags. Skipping"
        continue;
    }

    $errors = @()
    if (!($meta.Title) -or !($meta.Title.Trim())) {
        $errors += 'Title'
    }
    if (!($meta.JoinedArtists) -or !($meta.JoinedArtists.Trim())) {
        $errors += 'Artist'
    }
    if (!($meta.FirstGenre) -or !($meta.FirstGenre.Trim())) {
        $errors += 'Genre'
    }

    if ($errors) {
        $missingTags = ($errors -Join ',')
        Write-Warning "> '$fullName' does not have [$missingTags] tags. Skipping"
        continue;
    }

    # Check if genre matches directory the audio is in
    if (! ($meta.FirstGenre.Trim() -eq $file.Directory.BaseName.Trim())) {
        $gtag = $meta.FirstGenre.Trim()
        $gdir = $file.Directory.BaseName.Trim()
        Write-Information "> '$fullName' genre tag '$gtag' does not match directory '$gdir'. Using genre tag."
    }

    # Check filename if it matches a category
    $cat = ''
    foreach ($categoryName in $filenameCategories.Keys) {
        $category = $filenameCategories[$categoryName]
        foreach ($wildcard in $category) {
            if ($file.BaseName.Trim() -like $wildcard) {
                $cat = $categoryName
            }
            if ($cat) { break }
        }
        if ($cat) { break }
    }
    if (! $cat) {
        Write-Warning "> '$fullName' category (bat/chu/fan) is unknown. Skipping."
        continue;
    }

    # Check if genre is a known genre
    $genre = ( Get-Culture ).TextInfo.ToTitleCase( $meta.FirstGenre.Trim().ToLower() )
    if (! ($toAdd[$cat][$genre] -is [Array]) ) {
        $gtag = $meta.FirstGenre.Trim()
        Write-Warning "> '$fullName' genre tag '$gtag' is an unknown genre. Skipping."
        continue;
    }

    # Add if not yet there (-Contains : case-insensitive contains)
    if (! ($toAdd[$cat][$genre] -Contains $file.BaseName.Trim())) {
        $toAdd[$cat][$genre] += $file.BaseName.Trim()
    }

    # Add to xml list to-add
    New-XmlEntry $meta.JoinedArtists.Trim() $genre $file.BaseName.Trim() $cat
}


# Function to get music items from the ps1 script
$scr = (Get-Content -Raw $modifyScript)
function Get-ScriptItems($category, $genre) {
    $s = $scr | Select-String -Pattern "\n[^\n#]*?$category\s*=\s*@\{[\S\s]*?\n[^\n#]*?genre\s*=\s*[`"']$genre[`"'].*\n[^\n#]*?list\s*=\s*@\((.*)\)[\s;]*?\n"
    $arr = $s.Matches.Groups[1].Value.Trim() -Split "\s*,\s*" | Foreach-Object { $_.Trim() -Replace "[`"'](.*)[`"']",'$1' }
    return $arr
}

# Populate current arrays with old items from script
foreach ($categoryName in $toAdd.Keys) {
    foreach ($genre in @($toAdd[$categoryName].Keys)) {
        # Fetch the script's items
        $oldNames = (Get-ScriptItems $categoryName $genre)

        foreach ($oldName in $oldNames) {
            # Add if not yet there (-Contains : case-insensitive contains)
            if (! ($toAdd[$categoryName][$genre] -Contains $oldName)) {
                $toAdd[$categoryName][$genre] += $oldName
            }
        }
    }
}

# Create the ALL array for each category
foreach ($categoryName in $toAdd.Keys) {
    $all = @()
    foreach ($genre in @($toAdd[$categoryName].Keys)) {
        $all += $toAdd[$categoryName][$genre]
    }
    $toAdd[$categoryName].ALL = $all
}

# Sort the item arrays
foreach ($categoryName in $toAdd.Keys) {
    foreach ($genre in @($toAdd[$categoryName].Keys)) {
        $toAdd[$categoryName][$genre] = $toAdd[$categoryName][$genre] | Sort-Object
    }
}


# Replace the script contents $scr to have the new items
function Set-ScriptItems($category, $genre, $newList) {
    $stringList = "'" + ($newList.Replace("'","``'") -Join "', '") + "'"
    $script:scr = ($scr -Replace "(\n[^\n#]*?$category\s*=\s*@\{[\S\s]*?\n[^\n#]*?genre\s*=\s*[`"']$genre[`"'].*\n[^\n#]*?list\s*=\s*@\()(.*)(\)[\s;]*?\n)","`$1$stringList`$3")
}

foreach ($categoryName in $toAdd.Keys) {
    foreach ($genre in $toAdd[$categoryName].Keys) {
        Set-ScriptItems $categoryName.Trim() $genre.Trim() $toAdd[$categoryName][$genre]
    }
}


# Make a backup of old script, write the new script in place
$lastDate = (Get-Item $modifyScript).LastWriteTime.ToString('yy-MM-dd_HH.mm.ss')
Copy-Item "$modifyScript" "$modifyScript.old_$lastDate.backup" -Force
($scr -Replace "`r?`n$", "") | Set-Content -Encoding ASCII -Path "$modifyScript"


# XML stuff
$xml = @"
<!-- Copy the below lines to your mod.xml -->

"@

foreach ($categoryName in @($xmlEntries.Keys)) {
    $xml += "`n`n<!-- [$categoryName] Category -->`n`n"
    
    # sort the lines first
    $xmlEntries[$categoryName] = $xmlEntries[$categoryName] | Sort-Object
    foreach ($line in $xmlEntries[$categoryName]) {
        $xml += $line
    }
}

# Write
$xml | Set-Content -Encoding ASCII -Path "$outputXml"



Read-Host "Done. Press enter to exit." | Out-Null
