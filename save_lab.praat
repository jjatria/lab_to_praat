#Allow Input
form Info
    sentence New_lab_file_dir /home/cshulby/lab_to_praat/1_revised.lab
    sentence Lab_file_dir /home/cshulby/lab_to_praat/1.lab
endform

clearinfo

#1. read strings from TextGrid object already open in the gui into the info window
outputFile$ = new_lab_file_dir$

selectObject: 2
writeFile: outputFile$, ""                        ; start from an empty .txt

#2. parse by item in the phone tier to get the start_time$ and end_time$

numberOfIntervals = Get number of intervals: 1    ; (this is tier 1)

for interval to numberOfIntervals
    label$ = Get label of interval: 1, interval
    if label$ != ""                               ; (we just want non-empty intervals)
        xmin = Get start time of interval: 1, interval
        xmax = Get end time of interval: 1, interval

#3. convert the times back to e-07 format with leading zeros.
        xmin$ = string$(xmin)
        @replace: xmin$
        xmin  = number(replace.string$)
        xmin$=string$(xmin)
        #for some reason these replaces don't work inside the procedure... any ideas why?
        xmin$ = replace_regex$ (xmin$, "^", "000000000", 1)
        xmin$ = replace_regex$ (xmin$, "[0-9]*([0-9]{9})$", "\1", 0)
       # appendInfoLine: xmin$

        xmax$ = string$(xmax)
        @replace: xmax$
        xmax  = number(replace.string$)
        xmax$=string$(xmax)
        xmax$ = replace_regex$ (xmax$, "^", "000000000", 1)
        xmax$ = replace_regex$ (xmax$, "[0-9]*([0-9]{9})$", "\1", 0)
      #  appendInfoLine: xmax$


        appendFileLine: outputFile$, "'xmin$'" + " " + "'xmax$'"
    endif
endfor
#4. import the strings from the original lab file like we did in read lab.
    #this can be copied from the read_lab scripts newest version

stringID = Read Strings from raw text file: lab_file_dir$
numberOfStrings = Get number of strings

for stringNumber from 1 to 2
    selectObject: stringID
    line$ = Get string: stringNumber
    appendInfoLine:line$
endfor

for stringNumber from 1 to numberOfStrings
    selectObject: stringID
    line$ = Get string: stringNumber
    stringID_parsed = Create Strings as tokens: line$
    nStrings_parsed = Get number of strings

#5. parse to get the labels (the part with the pentaphones and the features -->ex. "uw^ac-zz+nn=ac/P1:+4/P2:+6/P3:+0" ) #remember the number of phones must be static.  The user should not add or delete a boundary because if the phonetic transcription is not correct, this should be corrected before it gets to the lab file, otherwise the training process in HTS or HTK will fail anyway.

    #Get info from each column
    where = startsWith (line$, "0")
    if where == 1
        phone$ = Get string: 3
        #URGENT: This produces the right format but not the correct time stamps, just the last.  Need a solution for this
        appendInfoLine:xmin$ + " " + xmax$ + " " + phone$
    endif
endfor

#6. paste the new time stamps with the old labels
    #what is the most elegant way to do this? 

#7. write to a new lab file.
#using the name defined in the window


#string replace to format time in seconds
procedure replace: .string$
        .string$ = replace_regex$ (.string$, "(\.[0-9]*[1-9])", "\10000000", 0)
        .string$ = replace_regex$ (.string$, "([0-9]{7})0*$", "\1", 0)
        .string$ = replace_regex$ (.string$, "\.", "", 0)
        #for some reason the "^" isn't working here so I will copy it above.  Ugly but it will work
        #.string$ = replace_regex$ (.string$, "^", "000000000", 0)
        #.string$ = replace_regex$ (.string$, "[0-9]*([0-9]{9})$", "\1", 0)
endproc
