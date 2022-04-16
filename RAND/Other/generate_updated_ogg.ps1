
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
            list = @('DanielLambie_bat', 'DanielLambie2_bat', 'FinalFantim_bat', 'DanielTidwell_bat', 'Falkkone_bat', 'Ferdk_bat', 'Ferdk2_bat', 'GlitchxCity_bat', 'Huskybythegeek_bat', 'Lau_bat', 'JonnyAtama_bat', 'Pillars_bat', 'ArtificialFear_bat', 'Fishy_bat', 'Fishy2_bat', 'norg_bat', 'AlanBuono_bat', 'RichardBichler_bat', 'SheetMusicBoss_bat', 'ReduxChrisMarsh_bat', 'ToxicxEternity_bat', 'VincentMoretto_bat', 'ZachPayne_bat', 'DLBPOST_bat', 'Tsunamods_bat', 'VicenteBravo_bat', 'Mykah_bat', 'AlexMoukala_bat', 'GirlzMelon_bat', 'DLBPFan_bat', 'DLBPPro_bat', 'FamilyJules7x_bat')
        };
        "2" = @{
            genre = "Remix";
            list = @('ZachPayne_bat', 'Mykah_bat', 'Lau_bat')
        };
        "3" = @{
            genre = "Metal";
            list = @('RichardBichler_bat', 'FamilyJules7x_bat', 'GirlzMelon_bat', 'ToxicxEternity_bat', 'norg_bat', 'Fishy_bat', 'ArtificialFear_bat', 'DanielLambie_bat', 'DanielLambie2_bat', 'DanielTidwell_bat', 'Falkkone_bat', 'Ferdk_bat', 'Ferdk2_bat', 'GlitchxCity_bat', 'Huskybythegeek_bat', 'JonnyAtama_bat', 'Pillars_bat', 'Fishy2_bat')
        };
        "4" = @{
            genre = "Arranged";
            list = @('DLBPPro_bat', 'FinalFantim_bat', 'AlanBuono_bat', 'SheetMusicBoss_bat', 'ReduxChrisMarsh_bat', 'VincentMoretto_bat', 'DLBPOST_bat', 'Tsunamods_bat', 'VicenteBravo_bat', 'AlexMoukala_bat', 'DLBPFan_bat')
        };
    };

    #BB - Boss Battle
    BB = @{
        name = 'BossBB';
        id = 'chu';
        "1" = @{
            genre = "ALL";
            list = @('Standby_chu', 'CarboHydroM_chu', 'AlexMoukala_chu', 'FuegoRedXIII_chu', 'DLPBPro_chu', 'ReduxChrisMarsh_chu', 'FuegoRedXIII2_chu', 'ToxicEternity_chu', 'Tsunamods_chu', 'EHWButler_chu', 'FinalFantim_chu', 'VicenteBravo_chu', 'DLPBOST_chu', 'DLPBFan_chu', 'TheRunawayFive_chu', 'Falkkone_chu', 'RichardBichler_chu', 'ArtificialFear_chu', 'LevoLution_chu', 'DanielTidwell_chu', 'zircon_chu', 'RichardBichlerDupe_chu', 'Ferdk_chu');
        };
        "2" = @{
            genre = "Remix";
            list = @('Standby_chu', 'CarboHydroM_chu', 'LevoLution_chu', 'zircon_chu')
        };
        "3" = @{
            genre = "Metal";
            list = @('DLPBPro_chu', 'ToxicEternity_chu', 'EHWButler_chu', 'Falkkone_chu', 'RichardBichler_chu', 'ArtificialFear_chu', 'DanielTidwell_chu', 'RichardBichlerDupe_chu', 'Ferdk_chu')
        };
        "4" = @{
            genre = "Arranged";
            list = @('AlexMoukala_chu', 'FuegoRedXIII_chu', 'ReduxChrisMarsh_chu', 'FuegoRedXIII2_chu', 'Tsunamods_chu', 'FinalFantim_chu', 'VicenteBravo_chu', 'DLPBOST_chu', 'DLPBFan_chu', 'TheRunawayFive_chu')
        };
    };

    #FA - Victory Fanfare
    FA = @{
        name = 'VictoryFA';
        id = 'fan2';
        "1" = @{
            genre = "ALL";
            list = @('FinalFantim_fan', 'ReduxChrisMarsh_fan', 'AnotherSoundscape_fan', 'FamilyJules7x_fan', 'aluminum_fan', 'DjCutman_fan', 'DjCutman2_fan', 'Mykah_fan', 'HolderEphixa_fan', 'HolderEphixa2_fan', 'DLBPOST_fan', 'DLBPPro_fan', 'FredrikHagglund_fan', 'TheRunawayFive_fan', 'Tsunamods_fan', 'VicenteBravo_fan', 'Pillars_fan', 'DanielLambie_fan', 'GirlzMelon_fan', 'GirlzMelon2_fan', 'DjCutman3_fan', 'DjCutman4_fan', 'Carlucci_fan', 'AnotherSoundscape2_fan', 'aluminum2_fan');
        };
        "2" = @{
            genre = "Remix";
            list = @('AnotherSoundscape_fan', 'aluminum_fan', 'DjCutman_fan', 'DjCutman2_fan', 'Mykah_fan', 'HolderEphixa_fan', 'HolderEphixa2_fan', 'TheRunawayFive_fan', 'DjCutman3_fan', 'DjCutman4_fan', 'AnotherSoundscape2_fan', 'aluminum2_fan')
        };
        "3" = @{
            genre = "Metal";
            list = @('GirlzMelon_fan', 'GirlzMelon2_fan', 'FamilyJules7x_fan', 'FredrikHagglund_fan', 'Pillars_fan', 'DanielLambie_fan', 'Carlucci_fan')
        };
        "4" = @{
            genre = "Arranged";
            list = @('FinalFantim_fan', 'ReduxChrisMarsh_fan', 'DLBPOST_fan', 'DLBPPro_fan', 'Tsunamods_fan', 'VicenteBravo_fan')
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
