include ../../plugin_utils/procedures/check_filename.proc
include ../../plugin_htklabel/procedures/timestamps.proc

form Save as HTK label file...
    sentence Save_as
    integer  Tier 1
    comment  Leave paths empty for GUI selector
endform

textgrid = selected("TextGrid")

@checkWriteFile: save_as$, "Save as HTK label file...", selected$("TextGrid") + ".lab"
output_file$ = checkWriteFile.name$

interval_tier = Is interval tier: tier

runScript: preferencesDirectory$ + "/plugin_tgutils/scripts/" +
  ... "index_specified_labels.praat", tier, ".+", "yes"
tokens = selected("Table")

writeFile: output_file$, ""

for line to Object_'tokens'.nrow
    if interval_tier
        @print: line, "start"
        @print: line, "end"
    else
        @print: line, "time"
    endif

    appendFileLine: output_file$, Object_'tokens'$[line, "label"]
endfor

removeObject: tokens

procedure print: .index, .field$
    .tmp = Object_'tokens'[.index, .field$]
    @seconds_to_mlf_time: .tmp
    appendFile: output_file$, seconds_to_mlf_time.return$, " "
endproc
