#Allow Input
form Info
    integer  Tier 1
    sentence Label_file /home/cshulby/lab_to_praat/1.lab
endform

output_file$ = label_file$ - ".lab" + "_revised.lab"

textgrid = selected("TextGrid")
if !do("Is interval tier...", tier)
    exitScript: "Tier ", tier, " is not an interval tier"
endif

#4. import the strings from the original lab file like we did in read lab.
strings = Read Strings from raw text file: label_file$
label_lines = Get number of strings

tokens = Create Table with column names: "tokens", 0,
  ... "start end pre name post"

writeFile: output_file$, ""

for line to label_lines
    selectObject: strings
    line$ = Get string: line

    if index_regex(line$, "^\s*//")
        appendFileLine: output_file$, line$
    else
        #5. parse to get the labels (the part with the pentaphones
        #   and the features -->ex. "uw^ac-zz+nn=ac/P1:+4/P2:+6/P3:+0" )
        t = Create Strings as tokens: line$
        start  = number(Object_'t'$[1])
        end    = number(Object_'t'$[2])
        label$ = Object_'t'$[3]
        pre$   = replace_regex$(label$, "^(.*?)-.*", "\1", 1)
        name$  = replace_regex$(label$, "^.*?-([^+]+)\+.*", "\1", 1)
        post$  = replace_regex$(label$, "^.*?-[^+]+\+(.*)", "\1", 1)
        removeObject: t

        selectObject: tokens
        Append row
        Set numeric value: Object_'tokens'.nrow, "start", start
        Set numeric value: Object_'tokens'.nrow, "end",   end
        Set string value:  Object_'tokens'.nrow, "pre",   pre$
        Set string value:  Object_'tokens'.nrow, "name",  name$
        Set string value:  Object_'tokens'.nrow, "post",  post$
    endif
endfor

# the number of phones must be static. The user should not add
# or delete a boundary because if the phonetic transcription is
# not correct, this should be corrected before it gets to the lab
# file, otherwise the training process in HTS or HTK will fail
# anyway.

selectObject: textgrid
non_empty = Count intervals where: tier, "is not equal to", ""
if Object_'tokens'.nrow != non_empty
    exitScript: "TextGrid has ", non_empty, " non-empty intervals, but there are ", Object_'tokens'.nrow, " labels"
endif

total_intervals = Get number of intervals: tier
interval = 0
for i to total_intervals
    selectObject: textgrid
    label$ = Get label of interval: 1, i
    if label$ != ""
        interval += 1
        xmin = Get start time of interval: 1, interval
        xmax = Get end time of interval: 1, interval

        @replace: xmin
        xmin$ = replace.string$

        @replace: xmax
        xmax$ = replace.string$

        #6. paste the new time stamps with the old labels
        selectObject: tokens
        appendFileLine: output_file$, xmin$, " ", xmax$, " ",
            ... Object_'tokens'$[interval, "pre"]  +
            ... "-" + label$ + "+" +
            ... Object_'tokens'$[interval, "post"]
    endif
endfor

removeObject: tokens, strings

#3. convert the times back to e-07 format with leading zeros.
procedure replace: .time
    .string$ = string$(.time * 1e7 div 1)
    while length(.string$) < 9
        .string$ = "0" + .string$
    endwhile
endproc
