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

form Prune HTK label context...
  integer Tier 0 (= all)
  boolean Left_context no
  boolean Name yes
  boolean Right_context no
endform

if !(left + name + right)
  exitScript: "Must select at least one label component"
endif

suffix$ = ""
if left_context
  suffix$ = suffix$ + "_left"
endif
if name
  suffix$ = suffix$ + "_name"
endif
if right_context
  suffix$ = suffix$ + "_right"
endif

total_textgrids = numberOfSelected("TextGrid")
for i to total_textgrids
  tg[i] = selected("TextGrid", i)
endfor

for i to total_textgrids
  selectObject: tg[i]
  new[i] = Copy: selected$("TextGrid") + suffix$

  t  = if tier then tier else 1 fi
  nt = if tier then tier else do("Get number of tiers") fi

  for t to nt
    item$ = if do("Is interval tier...", t) then "interval" else "point" fi

    if !left_context
      do("Replace " + item$ + " text...",
        ... t, 0, 0, "^.*?-", "", "Regular Expressions")
    endif

    if !right_context
      do("Replace " + item$ + " text...",
        ... t, 0, 0, "\+.*$", "", "Regular Expressions")
    endif

    if !name
      for j to do("Get number of " + item$ + "s...", t)
        label$ = do$("Get label of " + item$ + "...", t, j)
        if index(label$, "-")
          if index(label$, "+")
            new$ = replace_regex$(label$, "(.*?\-).*?(\+.*)", "\1\2", 1)
          else
            new$ = replace_regex$(label$, "(.*?\-).*", "\1", 1)
          endif
        elsif index(label$, "+")
          new$ = replace_regex$(label$, ".*?(\+.*)", "\1", 1)
        else
          new$ = ""
        endif

        do("Set " + item$ + " text...", t, j, new$)
      endfor
    endif

  endfor
endfor

selectObject()
for i to total_textgrids
  plusObject: new[i]
endfor
