
This is the README for the htklabel CPrAN plugin for Praat.
The latest version is available through CPrAN or at
<http://cpran.net/plugins/htklabel>

The htklabel plugin is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

The htklabel plugin is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with htklabel. If not, see <http://www.gnu.org/licenses/>.

Copyright 2017 Christopher Shulby, Jose Joaquin Atria

# plugin_htklabel

A plugin for Praat to read information from a HTK / HTS label file and
Master Label Files.

## Installation:

This plugin requires some of the existing plugins distributed through CPrAN.
If you have the CPrAN client installed on your machine, you can install this
plugin by typing

    cpran install htklabel

> NOTE: this will not work until registration on CPrAN is complete, which
> should be soon.
> if this does not work you may clone this repo to your PRAAT preferences directory.

After that, you should be able to read `.lab` and `.mlf` files using the
commands in the `Open` menu, and save TextGrid objects as labels using the
commands in the `Save` menu.

If **you do no not have the client** you can follow [these instructions][1] 
to set it up and install the plugin as above.

If **you cannot install the client**, you can still use this plugin, as long
as you manually install all of its dependencies (and their dependencies).
The full list of dependencies (pointing to their git repositories) is

* [tap](https://gitlab.com/cpran/plugin_tap)
* [utils](https://gitlab.com/cpran/plugin_utils)
* [varargs](https://gitlab.com/cpran/plugin_varargs)
* [printf](https://gitlab.com/cpran/plugin_printf)
* [selection](https://gitlab.com/cpran/plugin_selection)
* [strutils](https://gitlab.com/cpran/plugin_strutils)

[1]: http://cpran.net/clients/cpran/#installation

## Plugin Use

From the object window the user may open...

1. ".lab" file by selecting Open > Read HTK Label File... ;
2. ".mlf" file by selecting Open > Read HTK Master Label File... ;

When one of these tabs is selected a menu will appear prompting the user to include the path to the .lab or .mlf file desired.

Optionally, the user may also include a corresponding audio file which has been aligned with the labels.
	-it is important to note that if the user chooses to include an audio file, it is also necessay to check the box below "Use sound file", otherwise teh audio will not load.

By default, the box "Discard context" is also left unchecked. This will load the entire phonological context in the label file.
If the user wishes to diplay only the central phoneme, it is necessay to check this box as well.

To Save a file...

The user may click on Save > Save as HTK Label File with comments... (if you want to save the original comments at the top of your lab file),  Save > Save as HTK Label File without comments... (this is what most people will likely use) or Save > Save as HTK Master Label File... (if you are saving an .mlf).

## Selective Revision

The user may wish top open a View & Edit Window to a specific interval to revise specific boundries manually.  In the case it is necessary to call praat from the command line using the following command:

HTS_SOUND_FILE="<PATH TO SOUND FILE>" HTS_TEXTGRID_FILE="<PATH TO LABEL FILE>" START_TIME="<BEGINNING OF INTERVAL>" END_TIME="<END OF INTERVAL>" praat
