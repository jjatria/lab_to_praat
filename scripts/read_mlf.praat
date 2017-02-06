include ../../plugin_utils/procedures/check_filename.proc
include ../../plugin_utils/procedures/utils.proc
# include ../../plugin_utils/procedures/trace.proc
# trace.enable = 1

form Read MLF file...
  sentence Read_from
endform

@checkFilename: read_from$, "Choose MLF file..."
filename$ = checkFilename.name$
lines = Read Strings from raw text file: filename$

if Object_'lines'$[1] != "#!MLF!#"
  @abort: "missing header"
endif

Remove string: 1
total_lines = Get number of strings

mlf = Create Table with column names: selected$("Strings"), 0,
  ... "pattern mode target"

immediate = 0
transcription$ = ""
for i to total_lines
  line$ = Object_'lines'$[i]
  # @trace: "#'i': Parsing """ + line$ + """"

  if !index_regex(line$, "\S")
    @abort: "blank line"
  endif

  if immediate
    # @trace: "#'i':   In immediate transcription"
    if line$ == "."
      # @trace: "#'i':   End of transcription, pushing to table"

      selectObject: mlf
      Set string value: Object_'mlf'.nrow, "target", transcription$
      transcription$ = ""
    else
      # @trace: "#'i':   Appending """ + line$ + """ to text"
      transcription$ = transcription$ + line$ + newline$
    endif
  else
    # @trace: "#'i':   Not in an immediate transcription"
    if index_regex(line$, "\s[=-]\>\s")
      line$ = replace_regex$(line$, "\s+", " ", 0)
      @split: " ", line$

      if split.length < 3
        @abort: "invalid directory reference"
      else
        @dequote: split.return$[1]
        pattern$ = dequote.string$

        mode$    = if split.return$[2] == "->" then "simple" else "full" fi

        @dequote: split.return$[3]
        target$  = dequote.string$

        selectObject: mlfobject
        Append row

        Set string value: Object_'mlfobject'.nrow, "pattern", pattern$
        Set string value: Object_'mlfobject'.nrow, "mode",    mode$
        Set string value: Object_'mlfobject'.nrow, "target",  target$

      endif
    else
      immediate = 1

      selectObject: mlfobject
      Append row

      @dequote: line$
      Set string value: Object_'mlfobject'.nrow, "pattern", dequote.string$
      Set string value: Object_'mlfobject'.nrow, "mode",    "direct"
    endif
  endif
endfor
removeObject: lines
selectObject: mlfobject

procedure abort: .reason$
  nocheck removeObject: lines
  nocheck removeObject: mlfobject
  exitScript: "Input file """'filename$'""" is not a valid MLF file: ",
    ... .reason$
endproc

procedure dequote: .string$
  .string$ = replace_regex$(.string$, "(^""|""$)", "", 2)
endproc
