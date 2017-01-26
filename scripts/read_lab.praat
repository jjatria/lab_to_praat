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
    sentence Lab_file
    sentence Sound
    comment  Leave paths empty for GUI selectors
endform

@checkFilename: lab_file$, "Select HTK label file..."
lab_file$ = checkFilename.name$

@checkFilename: sound$, "Select sound file..."
sound$ = checkFilename.name$

#Open wav file
soundID = Read from file: sound$
stringID = Read Strings from raw text file: lab_file$

selectObject: soundID, stringID
@read_lab()
removeObject: stringID

minusObject: soundID
Replace interval text: 1, 0, 0, "^.*?-([^+]*?)\+.*", "\1", "Regular Expressions"
plusObject: soundID

