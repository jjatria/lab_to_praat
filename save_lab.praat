form Info
    sentence New_lab_file_dir /home/badner/Downloads/1_revised.lab
endform


#1. read strings from TextGrid object already open in the gui into the info window

tG$ = selectObject: selected$("TextGrid") 

numberOfIntervals = Get number of intervals: 1    ; (this is tier 1)

for interval to numberOfIntervals
    label$ = Get label of interval: 1, interval
    if label$ != ""                               ; (we just want non-empty intervals)
        xmin = Get start time of interval: 1, interval
        xmax = Get end time of interval: 1, interval
        appendFileLine: outputFile$, "'label$''tab$''xmin''tab$''xmax'"
    endif
endfor

#2. parse by item in the phone tier to get the start_time$ and end_time$
    #this will not be difficult once the TextGrid info is here

#3. convert the times back to e-07 format with leading zeros.
    #Make some replaces here

#4. import the strings from the original lab file like we did in read lab.
    #this can be copied from the read_lab scripts newest version

#5. parse to get the labels (the part with the pentaphones and the features -->ex. "uw^ac-zz+nn=ac/P1:+4/P2:+6/P3:+0" ) #remember the number of phones must be static.  The user should not add or delete a boundary because if the phonetic transcription is not correct, this should be corrected before it gets to the lab file, otherwise the training process in HTS or HTK will fail anyway.
    #parse for the right space delimited column.

#6. paste the new time stamps with the old labels
    #what is the most elegant way to do this?

#7. write to a new lab file.
    #using the name defined in the window
