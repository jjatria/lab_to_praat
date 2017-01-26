###############################################################
###############################################################
##This code will:
##1. Read a lab file in HTS format into a Praat TextGrid
##   with a single tier ("phone")
##2. Load both the audio and labels as objects
##3. open the aligned TextGrid and phonetic tier for editing
###############################################################
###############################################################

include ../procedures/timestamps.proc
include ../../plugin_utils/procedures/check_filename.proc

#Allow Input
form Info
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
tgID = To TextGrid: "phone", ""

#read the .lab file into praat

stringID = Read Strings from raw text file: lab_file$
numberOfStrings = Get number of strings

for stringNumber to numberOfStrings
    selectObject: stringID
    line$ = Get string: stringNumber

    if !index_regex(line$, "^\s*//")
        @mlf_time_to_seconds: extractNumber(line$, "")
        time_start = mlf_time_to_seconds.return

        @mlf_time_to_seconds: extractNumber(line$, " ")
        time_end = mlf_time_to_seconds.return

        label$ = replace_regex$(line$, ".*\s(.*)$", "\1", 1)

        selectObject: tgID
        #Insert boundaries
        nocheck Insert boundary: 1, time_start
        nocheck Insert boundary: 1, time_end
        interval = Get low interval at time: 1, time_end
        Set interval text: 1, interval, label$
    endif
endfor

Replace interval text: 1, 0, 0, "^.*?-([^+]*?)\+.*", "\1", "Regular Expressions"

removeObject: stringID
selectObject: soundID, tgID
