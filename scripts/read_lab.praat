###############################################################
###############################################################
##This code will:
##1. Read a lab file in HTS format into a Praat TextGrid
##   with a single tier ("phone")
##2. Load both the audio and labels as objects
##3. open the aligned TextGrid and phonetic tier for editing
###############################################################
###############################################################

include ../procedures/read.proc
include ../../plugin_utils/procedures/check_filename.proc

form Read HTK label file...
    sentence Path_to_label
    sentence Path_to_audio_(optional)
    comment  Leave paths empty for GUI selectors
    boolean  Use_sound_file no
    boolean  Discard_context no
endform

@checkFilename: path_to_label$, "Select HTK label file..."
path_to_label$ = checkFilename.name$
strings = Read Strings from raw text file: path_to_label$

if use_sound_file
    @checkFilename: path_to_audio$, "Select sound file..."
    path_to_audio$ = checkFilename.name$
    sound = Read from file: path_to_audio$

    plusObject: strings
endif

@read_lab()
removeObject: strings

if discard_context
    nocheck minusObject: sound
    Replace interval text: 1, 0, 0, "^.*?-([^+]*?)\+.*", "\1", "Regular Expressions"
    nocheck plusObject: sound
endif
