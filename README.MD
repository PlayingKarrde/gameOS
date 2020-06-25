# gameOS v1.0

![gameOS Pegasus theme](https://i.imgur.com/J4Jh4rq.jpg)

## gameOS theme for Pegasus Frontend

The goal of this theme is to create a modern game launcher that can fit in alongside other tvOS-like apps (sometimes called 10 foot user interfaces). gameOS is a theme for [Pegasus Frontend](http://pegasus-frontend.org/).

## Installation

[Download the latest version](https://github.com/PlayingKarrde/gameOS/releases/latest) and extract it in your [Pegasus theme directory](http://pegasus-frontend.org/docs/user-guide/installing-themes/) under a folder called gameOS.

Windows users may need to install the [K-lite Codec Pack](https://www.codecguide.com/download_kl.htm) to get video playback working.

## Metadata

It is recommended to use [Skraper.net](http://www.skraper.net/) to acquire media assets for this theme. These are the minimum requirements for media scraping, although adding more could be useful for other themes or the future:

- video
- screenshot
- fanart
- box 2d
- wheel

Skraper will place these in your roms folder under another folder called media.

If no media files are showing up, make sure that Skraper Assets is checked in the Additional Data Sources section of Pegasus settings. It may also be preferable to convert the created gamelist.xml (assuming EmulationStation was chosen for the game list in Skraper) to a metadata.txt file using the [Pegasus conversion tool](http://pegasus-frontend.org/tools/convert/)

## Version history
v1.07
- Added home settings (by @waldnercharles)
- Added advanced settings to adjust item ratios (by @waldnercharles)
- Fixed issue with font named incorrectly
- Renamed settings sections

v1.06
- Adding GNU license
- Adding option for viewing box art in the grid view instead of dynamic content
- Adding mouse/touch support to settings
- Fixed settings button hover functionality

v1.05
- Added option to toggle mouse hover (off by default)
- Added option for blurring background in game view (off by default)
- Added option for turning off game logo in game view, or text only (shown by default)

v1.0
- Complete overhaul of the theme, rewritten from the ground up
- Focus on features and performance
- Added new home screen
- Added settings
- Added search and filtering
- Added dynamic collections for better game discoverability
- Many more additional changes and additions

v0.6.7.2
- Added autoscroll text for description

v0.6.7.1
- Fixed crash on Android
- Added WiiWare logo
- Hiding text title when selected (only happens when no logo is found)
- Fixed back button exiting game details when viewing video preview

v0.6.7
- Major performance improvements (thanks to @SinisterSpatula for finding the fix)
- Added controller help
- Brought back extra meta data for details
- Fixed grid videos continuing to play while in details
- Added flyer support (needed for arcade)
- Added Windows 10 logo for Windows games

v0.6.6
- Added support for PS2, PS3, Switch, 3DS, Wii and Wii U logos
- Added support for Launchbox logo selection
- Shortening GBA in platform menu if using full name
- Fixed Genesis logo being black

v0.6.5
- Greatly improved video thumbnail performance
- Re-added video thumbnails by default
- Cleaned up buttons for video preview on game details screen
- Added better support for landscape boxart
- Fix for misaligned platform selection text
- Fix for platform selection not defaulting to selected view

v0.6
- Added new default game details screen
- Added new default grid view without game details with to toggle
- Added column number options (for future update)
- Added theme support (for future update)
- Brought back collection title
- Video previews in thumbnail currently turned off to improve performance
- Various bug fixes (thanks to bedgoe, waldnercharles)

v0.5
- Updated to latest version of Pegasus
- Now remembers last game played

v0.4
- Updated platform menu for cleaner experience
- Removed blur when using platform menu to increase performance
- Button consistency across the board
- Fixed details page not elegantly displaying with no media
- Bug fixes

v0.3
- Favorites filter toggle (X button to add to favorites, Y button to view)
- Video preview feature for details
- Bug fixes

v0.2
- Details page
- Streamlined interface
- Various bug fixes
- Various QOL improvements

v0.1
- Initial release
