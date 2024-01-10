# MPV Media Player Scripts
A Collection of scripts I've made for the MPV Media Player.

# SponsorBlock Local
Skips all segments specified in the script settings from the embedded SponsorBlock chapters created by yt-dlp.
This was made mostly for the Android version of MPV Media Player since the original SponsorBlock script doesn't work on it.

## How to use
1. Download the script and put the script in your scripts folder.
2. Edit the skip categories in the script file.
3. Play videos as you normally would. The script should skip over the segments that you've specified.

# Audio Speed Helper
Automatically picks the best audio filter for the speed you're playing at.

Speed > 1 = scaletempo2  
Speed < 1 = rubberband

# Fast Forward Keybind
Allows you to temporarily adjust playback speed to a specified value whilst holding a key down. Value can be adjusted with user customizable hotkeys.

## How to use
There are 2 script messages that are available:  

fastforwardaddspeed: Adjusts the fast forward speed by the specified value.  
fastforwardresetspeed: Resets the fast forward speed to 1x.

The fast forward button has to be changed in the script itself.
