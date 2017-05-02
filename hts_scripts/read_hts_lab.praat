###############################################################
###############################################################
##This code will:
##1. Read a lab file in HTS format into a Praat TextGrid
##   with a single tier ("phone")
##2. Load both the audio and labels as objects
##3. open the aligned TextGrid and phonetic tier for editing
###############################################################
###############################################################

#Allow Input
form Info
    sentence Lab_file_dir /home/badner/Desktop/lab_to_praat/1.lab
    sentence Sound_dir  /home/badner/Desktop/lab_to_praat/audio1.wav
endform

clearinfo

#Open wav file
soundID = Read from file: sound_dir$
tgID = To TextGrid: "phone", ""

#read the .lab file into praat

stringID = Read Strings from raw text file: lab_file_dir$
numberOfStrings = Get number of strings

for stringNumber to numberOfStrings
    selectObject: stringID
    line$ = Get string: stringNumber

    if !index_regex(line$, "^\s*//")
        @replace: extractNumber(line$, "")
        time_start = replace.number

        @replace: extractNumber(line$, " ")
        time_end   = replace.number

        label$     = replace_regex$(line$, ".*\s(.*)$", "\1", 1)

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

#string replace to format time in seconds
procedure replace: .number
    .number /= 1e7
endproc
