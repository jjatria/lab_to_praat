# This script is part of the htklabel CPrAN plugin for Praat.
# The latest version is available through CPrAN or at
# <http://cpran.net/plugins/htklabel>
#
# The htklabel plugin is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# The htklabel plugin is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with htklabel. If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2017 Christopher Shulby, Jose Joaquin Atria

include ../../plugin_utils/procedures/check_filename.proc
include ../../plugin_utils/procedures/utils.proc
include ../../plugin_utils/procedures/paths.proc
# include ../../plugin_utils/procedures/trace.proc
# trace.enable = 1

#! ~~~ params
#! in:
#!   Read from: (sentence) The path of the file to read
#! selection:
#!   out:
#!     table: 1
#! ~~~
#!
#! Read an HTK/HTS Master Label File.
#!
#! Master Label Files map a series of filename patterns to either annotations
#! that are contained in the file itself, or to subdirectories where the
#! specified file shold be found.
#!
#! A representation of this mapping is stored as a Table object, on which
#! filename queries can be made using the `MLF query...` script in this
#! plugin.
#!
form Read MLF file...
  sentence Read_from
endform

@checkFilename: read_from$, "Choose MLF file..."
filename$ = checkFilename.name$
lines = Read Strings from raw text file: filename$

@dirname: filename$
path$ = dirname.return$

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

        mode$ = if split.return$[2] == "->" then "simple" else "full" fi

        @dequote: split.return$[3]
        target$  = dequote.string$

        selectObject: mlf
        Append row

        @normalise_path: target$
        target$ = normalise_path.return$
        @is_relative: target$
        if is_relative.return
          target$ = path$ + "/" + target$
        endif

        Set string value: Object_'mlf'.nrow, "pattern", pattern$
        Set string value: Object_'mlf'.nrow, "mode",    mode$
        Set string value: Object_'mlf'.nrow, "target",  target$

      endif
    else
      immediate = 1

      selectObject: mlf
      Append row

      @dequote: line$
      Set string value: Object_'mlf'.nrow, "pattern", dequote.string$
      Set string value: Object_'mlf'.nrow, "mode",    "direct"
    endif
  endif
endfor
removeObject: lines
selectObject: mlf

procedure abort: .reason$
  nocheck removeObject: lines
  nocheck removeObject: mlf
  exitScript: "Input file """, filename$, """ is not a valid MLF file: ",
    ... .reason$
endproc

procedure dequote: .string$
  if left$(.string$) == """" and right$(.string$) == """"
    .string$ = replace_regex$(.string$, "(^""|""$)", "", 2)
  endif
endproc
