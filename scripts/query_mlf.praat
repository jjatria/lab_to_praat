include ../../plugin_strutils/procedures/strings_from_string.proc
include ../../plugin_utils/procedures/utils.proc
include ../../plugin_utils/procedures/paths.proc
include ../procedures/read.proc
include ../procedures/mlf.proc

clearinfo
form MLF query...
  sentence Filename
  optionmenu Match: 1
    option Glob
    option Regex
endform

if filename$ == ""
  exitScript: "Query cannot be empty"
endif

mlf = selected("Table")
@is_mlf()
if !is_mlf.return
  exitScript: "Selected Table is not a valid MLF object"
endif

row = 0
found = 0
while row < Object_'mlf'.nrow and !found
  row += 1

  pattern$ = Object_'mlf'$[row, "pattern"]
  mode$    = Object_'mlf'$[row, "mode"]
  target$  = Object_'mlf'$[row, "target"]

  @match_pattern: filename$, pattern$, match$
  if match_pattern.return
    found = row
  endif
endwhile

if found
  if Object_'mlf'$[found, "mode"] == "direct"
    target$ = Object_'mlf'$[found, "target"]
    @stringsFromString: filename$, target$
    lab = selected("Strings")
    @read_lab()
    removeObject: lab
    exit
  else
    # "./foo/bar"
    target$ = Object_'mlf'$[found, "target"]

    # "x.lab"
    @basename: filename$
    basename$ = basename.return$

    @split: "/", filename$
    split.return$[0] = ""

    for i from 0 to split.length-1
      dirname$ = target$
      for j from 0 to i
        dirname$ = dirname$ + "/" + split.return$[j]
      endfor

      fullname$ = dirname$ + "/" + basename$
      if fileReadable(fullname$)
        # File is found, all is well
        if endsWith(basename$, ".lab")
          Read Strings from raw text file: fullname$
          lab = selected("Strings")
          @read_lab()
          removeObject: lab
        else
          Read from file: fullname$
        endif
        i += split.length
      elsif Object_'mlf'$[found, "mode"] != "full"
        i += split.length
      endif
    endfor

    if selected() == mlf
      exitScript: "No match found"
    endif

  endif
else
  exitScript: "No match found"
endif

procedure match_pattern: .name$, .pattern$, .type$
  if .type$ = "Glob"
    .pattern$ = replace_regex$(.pattern$, "[.]", "\\.", 0)
    .pattern$ = replace_regex$(.pattern$, "[*]", ".*",  0)
    .pattern$ = replace_regex$(.pattern$, "[?]", ".",   0)
  endif
  .return = index_regex(.name$, .pattern$)
endproc
