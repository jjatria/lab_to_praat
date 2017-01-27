include ../../plugin_utils/procedures/check_filename.proc
include ../../plugin_htklabel/procedures/timestamps.proc

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
writeFile: output_file$, ""

for hypothesis to total_textgrids
    new_hypothesis = 1
    selectObject: textgrid[hypothesis]
    lowest_tier = Get number of tiers

    total_intervals = Get number of intervals: lowest_tier
    for i to total_intervals
        new_line = 0
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
                if new_line
                    appendFile: output_file$, " "
                endif

                new_line = 1
                if tier == lowest_tier

                    if total_textgrids > 1 and new_hypothesis
                        new_hypothesis = 0
                        appendFileLine: output_file$, "/// ", selected$("TextGrid")
                    endif

                    @seconds_to_mlf_time: this
                    appendFile: output_file$, seconds_to_mlf_time.return$, " "
                    @seconds_to_mlf_time: next
                    appendFile: output_file$, seconds_to_mlf_time.return$, " "
                endif

                appendFile: output_file$, label$
                tier -= 1
            else
                tier = 0
            endif
        until !tier

        if new_line
            appendFileLine: output_file$, ""
        endif
    endfor
endfor

selectObject()
for t to total_textgrids
    plusObject: textgrid[t]
endfor
