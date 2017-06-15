# This script is part of the htklabel CPrAN plugin for Praat.
# The latest version is available through CPrAN or at
# <http://cpran.net/plugins/htklabel>
#
# The htklabel plugin is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# The htklabel plugin is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with htklabel. If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2017 Christopher Shulby, Jose Joaquin Atria

include ../procedures/read.proc
include ../../plugin_utils/procedures/check_filename.proc

form Read HTK label file...
    sentence Filename
    comment  Leave paths empty for GUI selectors
endform

@checkFilename: path_to_label$, "Select HTK label file..."
path_to_label$ = checkFilename.name$
strings = Read Strings from raw text file: path_to_label$


##########################################
############# WORKING SPACE ##############
#import the strings from the original lab file.

#writeFile: output_file$, ""                        ; start from an empty .txt

stringID = strings
numberOfStrings = Get number of strings

for stringNumber from 1 to 2
    selectObject: stringID
    line$ = Get string: stringNumber
#    appendFileLine: output_file$, line$
endfor

############# WORKING SPACE ##############
##########################################

if use_sound_file
    @checkFilename: path_to_audio$, "Select sound file..."
    path_to_audio$ = checkFilename.name$
    sound = Read from file: path_to_audio$

    plusObject: strings
endif

@read_lab()
#removeObject: strings

if discard_context
    nocheck minusObject: sound
    Replace interval text: 1, 0, 0, "^.*?-([^+]*?)\+.*", "\1", "Regular Expressions"
    nocheck plusObject: sound
endif
