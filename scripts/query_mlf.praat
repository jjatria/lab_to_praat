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

include ../../plugin_strutils/procedures/strings_from_string.proc
include ../../plugin_utils/procedures/utils.proc
include ../../plugin_utils/procedures/paths.proc
include ../procedures/read.proc
include ../procedures/mlf.proc

#! ~~~ params
#! in:
#!   Filename: (sentence) The path to search for
#!   Match: (optionmenu) The type of match to make
#! selection:
#!   in:
#!     table: 1
#!   out:
#!     The read object or objects
#! ~~~
#!
#! Run a filename query on a Table representation of a HTK/HTS MLF file.
#!
#! Executed with a MLF Table selected, this script will attempt to find a
#! match for the specified filename. The match against the MLF patterns is
#! normally a file glob (where `?` matches any single character and `*` matches
#! any character, any number of times), and this is done if the value of the
#! `Match` parameter is `"Glob"`. If the value is `"Regex"`, the patterns
#! will be treated as regular expressions. Be advised that this is non-standard
#! behaviour.
#!
#! MLF search is done in the following way:
#!
#! When annotations are given directly, they are recorded in the MLF file in
#! the same way that they would be in a regular label file. On the other hand,
#! when a pattern is mapped to a subdirectory, this can be done in one of two
#! "modes": _simple_, and _full_.
#!
#! When in simple mode, the specified filename _must_ be found directly under
#! the given subdirectory, and a missing file will result in an error. In full
#! mode, a query for the file `foo/bar/baz` will look for the file `baz` first
#! directly under the specified directory, and then, if unsiccessful, under
#! `bar` and under `foo/bar`, in that order.
#!
#! If a filename is not found through these methods, or if it doesn't match any
#! of the given patterns, an error will be raised. The search will stop after
#! the first file is found.
#!
#! If a file is found, it will be read. If the filename ends in `.lab`, it will
#! be processed as an HTK/HTS label file and result in a set of TextGrid
#! objects. If the file is some other file, it will be passed as is to the
#! standard `Read from file...` Praat command.
#!
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
      @no_match: filename$
    endif

  endif
else
  @no_match: filename$
endif

#! ~~~ params
#! in:
#!   .name$: The filename provided
#! internal: true
#! ~~~
#!
#! Report a non-matching filename and cleanup, before exiting the script.
#!
procedure no_match: .name$
  nocheck removeObject: mlf
  exitScript: "No match found for ", .name$
endproc

#! ~~~ params
#! in:
#!   .name$: The string to match
#!   .pattern$: The pattern to match against
#!   .type$: The type of match to perform
#! out:
#!   .return: True if there was a match
#! internal: true
#! ~~~
#!
#! Attempt to match a string (=filename) to a pattern taken from an HTK/HTS
#! MLF file. The pattern can be considered either as a file glob, if `.type$`
#! is `"Glob"`, or as a regular expression otherwise.
#!
procedure match_pattern: .name$, .pattern$, .type$
  if .type$ = "Glob"
    .pattern$ = replace_regex$(.pattern$, "[.]", "\\.", 0)
    .pattern$ = replace_regex$(.pattern$, "[*]", ".*",  0)
    .pattern$ = replace_regex$(.pattern$, "[?]", ".",   0)
  endif
  .return = index_regex(.name$, .pattern$)
endproc
