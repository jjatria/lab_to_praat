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
    sentence Lab_file_dir /home/user_name/1.lab
    sentence Sound_dir  /home/user_name/audio1.wav
endform

clearinfo

#Open wav file
soundID = Read from file: sound_dir$
tgID = To TextGrid: "phone", ""

#read the .lab file into praat

stringID = Read Strings from raw text file: lab_file_dir$
numberOfStrings = Get number of strings

for stringNumber from 3 to numberOfStrings
    selectObject: stringID
    line$ = Get string: stringNumber
    stringID_parsed = Create Strings as tokens: line$
    nStrings_parsed = Get number of strings

    #Get info from each column
    time_start$ = Get string: 1
    time_end$ = Get string: 2
    phone$ = Get string: 3

    @replace: time_start$
    time_start  = replace.number

    @replace: time_end$
    time_end  = replace.number

    time_mid = ((time_end-time_start)/2)+time_start

    left = index(phone$, "-")
    left += 1
    right = index(phone$, "+")
    right = right - left
    phone$ = mid$  (phone$, left, right)

    removeObject: stringID_parsed

    #4. write information in TextGrid format.
    tmin = 0 ;
    tmax = 1;

    selectObject: tgID
 #Insert boundaries
    nocheck Insert boundary: 1, time_start
    nocheck Insert boundary: 1, time_end
    interval = Get interval at time: 1, time_mid
    Set interval text: 1, interval, phone$
endfor

removeObject: stringID 
selectObject: soundID
plusObject: tgID
View & Edit

#string replace to format time in seconds
procedure replace: .string$
    .number = number(.string$) / 1e7
endproc
