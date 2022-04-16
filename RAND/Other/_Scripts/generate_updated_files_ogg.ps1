
$file = "mod.xml"
$outDir = "Output"
$dupeDir = "Output\_dupes"


$defs = @{
#BA - Battle
    BA = @{
        name = 'BattleBA';
        id = 'bat';
        "1" = @{
            genre = "ALL";
            list = @('bat9', 'bat2', 'bat3', 'bat31', 'bat5', 'bat6', 'bat17', 'bat8', 'bat1', 'bat12', 'bat11', 'bat10', 'bat18', 'bat14', 'bat15', 'bat16', 'bat7', 'bat13', 'bat19', 'bat20', 'bat23', 'bat22', 'bat21', 'bat24', 'bat25', 'bat29', 'bat27', 'bat28', 'bat26', 'bat30', 'bat31', 'bat4')
        };
        "2" = @{
            genre = "Remix";
            list = @('bat23', 'bat27', 'bat10')
        };
        "3" = @{
            genre = "Metal";
            list = @('bat32', 'bat2', 'bat18', 'bat21', 'bat16', 'bat14', 'bat13', 'bat1', 'bat29', 'bat4', 'bat5', 'bat6', 'bat7', 'bat8', 'bat9', 'bat11', 'bat12', 'bat15')
        };
        "4" = @{
            genre = "Arranged";
            list = @('bat28', 'bat22', 'bat17', 'bat19', 'bat20', 'bat3', 'bat24', 'bat25', 'bat26', 'bat31', 'bat30')
        };
    };

    #BB - Boss Battle
    BB = @{
        name = 'BossBB';
        id = 'chu';
        "1" = @{
            genre = "ALL";
            list = @('chu17', 'chu2', 'chu3', 'chu4', 'chu5', 'chu6', 'chu7', 'chu8', 'chu9', 'chu10', 'chu11', 'chu12', 'chu13', 'chu14', 'chu15', 'chu16', 'chu1', 'chu18', 'chu19', 'chu21', 'chu22', 'chu24');
        };
        "2" = @{
            genre = "Remix";
            list = @('chu19', 'chu1', 'chu22')
        };
        "3" = @{
            genre = "Metal";
            list = @('chu17', 'chu18', 'chu5', 'chu16', 'chu8', 'chu2', 'chu10', 'chu21', 'chu24')
        };
        "4" = @{
            genre = "Arranged";
            list = @('chu3', 'chu6', 'chu4', 'chu7', 'chu9', 'chu11', 'chu14', 'chu11', 'chu13', 'chu15')
        };
    };

    #FA - Victory Fanfare
    FA = @{
        name = 'VictoryFA';
        id = 'fan2';
        "1" = @{
            genre = "ALL";
            list = @('fan5', 'fan19', 'fan2', 'fan3', 'fan14', 'fan6', 'fan17', 'fan8', 'fan9', 'fan10', 'fan11', 'fan13', 'fan4', 'fan15', 'fan16', 'fan7', 'fan18', 'fan1', 'fan20', 'fan26', 'fan24', 'fan23', 'fan22', 'fan25', 'fan21');
        };
        "2" = @{
            genre = "Remix";
            list = @('fan10', 'fan15', 'fan4', 'fan9', 'fan6', 'fan7', 'fan8', 'fan11', 'fan14', 'fan22', 'fan23', 'fan25', 'fan26')
        };
        "3" = @{
            genre = "Metal";
            list = @('fan20', 'fan29', 'fan5', 'fan18', 'fan21', 'fan24')
        };
        "4" = @{
            genre = "Arranged";
            list = @('fan1', 'fan3', 'fan13', 'fan16', 'fan17')
        };
    };
}


## ---------------------------------------------- ##


function New-Entry($type, $id, $genre, $array) {
    $arraystr = ($array |% {"'$_'"}) -join ', ';
    return @"

# $type $genre #
[$id]
shuffle = [ $arraystr ]

"@
}

function New-Config($configDict) {
    $out = $configDict.Keys |% {
        $coll = $defs[$_];
        $genreNum = $configDict[$_];
        If ($coll -And $coll[$genreNum]) {
            New-Entry $coll.name $coll.id $coll[$genreNum].genre $coll[$genreNum].list
        }
    }

    return ($out -join '')
}


## ---------------------------- ##


Write-Host "Reading '$file'..."

try {
    $xml = [xml](Get-Content $file);
    $test = $xml.ModInfo;
} catch {
    Write-Error "'$file' doesn't exist or is an invalid XML file.";
    pause
    exit
}

$hashes = @()

$xml.ModInfo.ModFolder |% {
    $options = [ordered]@{};
    $hash = @()
    $_.ActiveWhen.And.Option | Select-String -Pattern "(\w+)\s*=\s*(\d+)" |% {
        $k = [string]$_.matches.groups[1];
        $v = [string]$_.matches.groups[2];
        if ($v -ne '0') {
            $options[$k] = $v;
        }
        $hash += "$k$v";
    };

    if (! $hashes.Contains($hash -join '+')) {
        $hashes += ($hash -join '+');
        $dir = "$outDir\$($_.Folder)\vgmstream";
    } else {
        # dupe
        Write-Warning "'$($_.Folder)' is a dupe. Moving it to $dupeDir"
        $dir = "$dupeDir\$($_.Folder)\vgmstream";
    }

    # Create destination folder structure if not existing
    if (! (Test-Path $dir)) { New-Item -path $dir -type directory | Out-Null }

    Write-Host "Writing to $dir\config.toml..."
    New-Config $options | Out-File -Encoding ASCII "$dir\config.toml"
}

Read-Host "Done. Press enter to exit." | Out-Null
