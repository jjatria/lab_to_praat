include ../../plugin_utils/procedures/check_filename.proc
include ../../plugin_htklabel/procedures/timestamps.proc
include ../../plugin_printf/procedures/printf.proc

# Disable perl fallback to ensure correct handling of unicode
# This needs to be corrected in plugin_printf
printf.system = 0

form Save as HTK label file...
    sentence Save_as
    comment  Leave paths empty for GUI selector
endform

total_textgrids = numberOfSelected("TextGrid")

for t to total_textgrids
    textgrid[t] = selected("TextGrid", t)
endfor

@checkWriteFile: save_as$, "Save as HTK label file...", selected$("TextGrid") + ".lab"
output_file$ = checkWriteFile.name$

# Generate output tables
for hypothesis to total_textgrids
    new_hypothesis = 1

    textgrid = textgrid[hypothesis]
    selectObject: textgrid
    lowest_tier = Get number of tiers
    total_intervals = Get number of intervals: lowest_tier

    output[hypothesis] = Create Table with column names: selected$("TextGrid"), 0,
        ... "start end"
    output = output[hypothesis]

    selectObject: textgrid
    for i to total_intervals
        tier = lowest_tier

        this = Get start time of interval: tier, i
        if i == total_intervals
            next = Get total duration
        else
            next = Get start time of interval: tier, i+1
        endif

        repeat
            interval = Get high interval at time: tier, this
            label$ = Get label of interval: tier, interval

            if this == 0
                boundary = 1
            else
                boundary = Get interval edge from time: tier, this
            endif

            if boundary and label$ != "" and !index_regex(label$, "\s")
                if tier == lowest_tier
                    selectObject: output
                    Append row

                    @seconds_to_mlf_time: this
                    Set numeric value: Object_'output'.nrow, "start", number(seconds_to_mlf_time.return$)

                    @seconds_to_mlf_time: next
                    Set numeric value: Object_'output'.nrow, "end", number(seconds_to_mlf_time.return$)

                    selectObject: textgrid
                endif

                selectObject: output
                col$ = "L" + string$(lowest_tier - tier + 1)
                if !do("Get column index...", col$)
                    Insert column: Object_'output'.ncol + 1, col$
                endif
                Set string value: Object_'output'.nrow, col$, label$

                selectObject: textgrid
                tier -= 1
            else
                tier = 0
            endif
        until !tier
    endfor
endfor

# Delete empty output tables
selectObject()
hypotheses = 0
max_cols = 0
for t to total_textgrids
     output = output[t]
     if Object_'output'.nrow
        hypotheses += 1
        hypothesis[hypotheses] = output
        plusObject: output
        if Object_'output'.ncol > max_cols
            max_cols = Object_'output'.ncol
            max_id   = output
        endif
     else
        removeObject: output
     endif
endfor

# Make sure all output tables have the same number
# of columns, with the same labels
for h to hypotheses
    hypothesis = hypothesis[h]
    while Object_'hypothesis'.ncol < max_cols
        selectObject: max_id
        label$ = Get column label: Object_'hypothesis'.ncol + 1

        selectObject: hypothesis
        Insert column: Object_'hypothesis'.ncol + 1, label$
    endwhile
endfor

# Calculate maximum required field widths for each field
selectObject()
for h to hypotheses
    plusObject: hypothesis[h]
endfor

fields = Append
first$ = Get column label: 1
last$  = Get column label: Object_'fields'.ncol
Formula (column range): first$, last$, "length(self$)"

# Get maximum width per field (=column)
widths = Create Table without column names: "widths", 1, Object_'fields'.ncol
for c to Object_'fields'.ncol
    selectObject: fields
    label$ = Get column label: c
    max = Get maximum: label$
    selectObject: widths
    Set column label (index): c, label$
    Set numeric value: 1, label$, max
endfor
removeObject: fields

# Write the output tables to the output file
writeFile: output_file$, ""
for h to hypotheses
     hypothesis = hypothesis[h]

     selectObject: hypothesis
      if hypotheses > 1
          appendFileLine: output_file$, "/// ", selected$("Table")
      endif

      for r to Object_'hypothesis'.nrow
          line$ = ""
          for c to Object_'hypothesis'.ncol
              field$ = Get column label: c
              width  = Object_'widths'[1, field$]

              if left$(field$) != "L"
                  format$ = "%0" + string$(width) + "d"
                  value   = Object_'hypothesis'[r, field$]
                  call @:sprintf: format$, value
              else
                  format$ = "%-" + string$(width) + "s"
                  value$  = Object_'hypothesis'$[r, field$]
                  call @:sprintf: format$, "'value$'"
              endif
              line$ = line$ + sprintf.return$ + " "
          endfor
          line$ = replace_regex$(line$, "\s+$", "", 0)
          appendFileLine: output_file$, line$
      endfor

      removeObject: hypothesis
endfor
removeObject: widths

# Restore original selection
selectObject()
for t to total_textgrids
    plusObject: textgrid[t]
endfor
