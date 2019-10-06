// This file contains some helper scripts for formatting data


// For multiplayer games, show the player count as '1-N'
function formatPlayers(playerCount) {
    if (playerCount === 1)
        return playerCount

    return "1-" + playerCount;
}


// Show dates in Y-M-D format
function formatDate(date) {
    return Qt.formatDate(date, "yyyy-MM-dd");
}


// Show last played time as text. Based on the code of the default Pegasus theme.
// Note to self: I should probably move this into the API.
function formatLastPlayed(lastPlayed) {
    if (isNaN(lastPlayed))
        return "never";

    var now = new Date();

    var elapsedHours = (now.getTime() - lastPlayed.getTime()) / 1000 / 60 / 60;
    if (elapsedHours < 24 && now.getDate() === lastPlayed.getDate())
        return "today";

    var elapsedDays = Math.round(elapsedHours / 24);
    if (elapsedDays <= 1)
        return "yesterday";

    return elapsedDays + " days ago"
}


// Display the play time (provided in seconds) with text.
// Based on the code of the default Pegasus theme.
// Note to self: I should probably move this into the API.
function formatPlayTime(playTime) {
    var minutes = Math.ceil(playTime / 60)
    if (minutes <= 90)
        return Math.round(minutes) + " minutes";

    return parseFloat((minutes / 60).toFixed(1)) + " hours"
}

// Process the platform name to make it friendly for the logo
// Unfortunately necessary for LaunchBox
function processPlatformName(platform) {
  switch (platform) {
    case "panasonic 3do":
      return "3do";
      break;
    case "3do interactive multiplayer":
      return "3do";
      break;
    case "amstrad cpc":
      return "amstradcpc";
      break;
    case "apple ii":
      return "apple2";
      break;
    case "atari 800":
      return "atari800";
      break;
    case "atari 2600":
      return "atari2600";
      break;
    case "atari 5200":
      return "atari5200";
      break;
    case "atari 7800":
      return "atari7800";
      break;
    case "atari jaguar":
      return "atarijaguar";
      break;
    case "atari jaguar cd":
      return "atarijaguarcd";
      break;
    case "atari lynx":
      return "atarilynx";
      break;
    case "atari st":
      return "atarist";
      break;
    case "commodore 64":
      return "c64";
      break;
    case "tandy trs-80":
      return "coco";
      break;
    case "commodore amiga":
      return "amiga";
      break;
    case "sega dreamcast":
      return "dreamcast";
      break;
    case "final burn alpha":
      return "fba";
      break;
    case "sega game gear":
      return "gamegear";
      break;
    case "nintendo game boy":
      return "gb";
      break;
    case "nintendo game boy advance":
      return "gba";
      break;
    case "nintendo game boy color":
      return "gbc";
      break;
    case "nintendo gamecube":
      return "gc";
      break;
    case "sega genesis":
      return "genesis";
      break;
    case "mattel intellivision":
      return "intellivision";
      break;
    case "sega master system":
      return "mastersystem";
      break;
    case "sega mega drive":
      return "megadrive";
      break;
    case "sega genesis":
      return "genesis";
      break;
    case "microsoft msx":
      return "msx";
      break;
    case "nintendo 64":
      return "n64";
      break;
    case "nintendo ds":
      return "nds";
      break;
    case "snk neo geo aes":
      return "neogeo";
      break;
    case "snk neo geo mvs":
      return "neogeo";
      break;
    case "snk neo geo cd":
      return "neogeocd";
      break;
    case "nintendo 64":
      return "segacd";
      break;
    case "nintendo entertainment system":
      return "nes";
      break;
    case "snk neo geo pocket":
      return "ngp";
      break;
    case "snk neo geo pocket color":
      return "ngpc";
      break;
    case "sega cd":
      return "segacd";
      break;
    case "nex turbografx-16":
      return "turbografx16";
      break;
    case "sony psp":
      return "psp";
      break;
    case "sony playstation":
      return "psx";
      break;
    case "sony playstation 2":
      return "ps2";
      break;
    case "sony playstation 3":
      return "ps3";
      break;
    case "sony playstation vita":
      return "vita";
      break;
    case "sega saturn":
      return "saturn";
      break;
    case "sega 32x":
      return "sega32x";
      break;
    case "super nintendo entertainment system":
      return "snes";
      break;
    case "sega cd":
      return "segacd";
      break;
    case "nintendo wii":
      return "wii";
      break;
    case "nintendo wii u":
      return "wii u";
      break;
    case "nintendo 3ds":
      return "3ds";
      break;
    case "microsoft xbox":
      return "xbox";
      break;
    case "microsoft xbox 360":
      return "xbox360";
      break;
    case "nintendo switch":
      return "switch";
      break;
    default:
      return platform;
  }
}
