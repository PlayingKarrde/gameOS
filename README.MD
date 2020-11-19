# XboxOS

![gameOS Pegasus theme 1](https://i.imgur.com/Cb31gtf.png)
![gameOS Pegasus theme 2](https://i.imgur.com/19DZEJ1.jpg)
![gameOS Pegasus theme 3](https://i.imgur.com/x5ATDSx.png)
![gameOS Pegasus theme 4](https://i.imgur.com/KLz2mUE.png)
![gameOS Pegasus theme 5](https://i.imgur.com/pRa3o3I.png)
![gameOS Pegasus theme 6](https://news.xbox.com/en-us/wp-content/uploads/sites/2/2020/08/Xbox-Visual-Refesh-Style-Guide.jpg?w=1200)


## XboxOS theme for Pegasus Frontend

IMPORTANT: This is a fork of [gameOS](https://github.com/PlayingKarrde/gameOS/releases/latest) by the original and true UI God: Seth Powell. The goal of this theme is to create a modern game launcher that can fit in alongside other tvOS-like apps and is reminiscent of the Xbox UI design language, with added color customization. XboxOS is a theme for [Pegasus Frontend](http://pegasus-frontend.org/).

## Installation

[Download the latest version](https://github.com/alfredolvera/XboxOS/releases/latest) and extract it in your [Pegasus theme directory](http://pegasus-frontend.org/docs/user-guide/installing-themes/) under a folder called XboxOS.

Windows users may need to install the [K-lite Codec Pack](https://www.codecguide.com/download_kl.htm) to get video playback working.

IMPORTANT: You need to have the latest version of Pegasus installed (not the current Stable release) otherwise you will get an error regarding Qt.Modules.

## Metadata

It is recommended to use [Skraper.net](http://www.skraper.net/) to acquire media assets for this theme. These are the minimum requirements for media scraping, although adding more could be useful for other themes or the future:

- video
- screenshot
- fanart
- box 2d
- wheel

Skraper will place these in your roms folder under another folder called media.

If no media files are showing up, make sure that Skraper Assets is checked in the Additional Data Sources section of Pegasus settings. It may also be preferable to convert the created gamelist.xml (assuming EmulationStation was chosen for the game list in Skraper) to a metadata.txt file using the [Pegasus conversion tool](http://pegasus-frontend.org/tools/convert/)

## To-Do

- Rounded corners to tiles
- Change fonts to Segoe UI
- Put Game Title inside the tiles
- Change buttons to rectangles with rounded corners
- Item selected effect to glow

## Version history
v0.3
- User selectable background and accent colors

v0.2
- Added clock to Home

v0.1
- Initial release
