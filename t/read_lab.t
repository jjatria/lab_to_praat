include ../../plugin_tap/procedures/more.proc

@no_plan()

runScript: "../scripts/read_lab.praat", "../t/samples/lab/simple.lab"
@is: numberOfSelected("TextGrid"), 1, "Simple label reas as single TextGrid"

@is: do("Get total duration"),            1.5, "Duration matches"
@is: do("Get number of tiers"),           1,   "Tiers match"
@is: do("Get number of intervals...", 1), 3,   "Intervals match"

labels$ = " "
for i to do("Get number of intervals...", 1)
  labels$ = labels$ + do$("Get label of interval...", 1, i) + " "
endfor
@is$: labels$, " a b c ", "Labels match"

Remove

runScript: "../scripts/read_lab.praat", "../t/samples/lab/levels.lab"
@is: numberOfSelected("TextGrid"), 1, "Multiple levels reas as single TextGrid"

@is: do("Get total duration"),            0.82, "Duration matches"
@is: do("Get number of tiers"),           2,   "Levels read as different tiers"

Remove

runScript: "../scripts/read_lab.praat", "../t/samples/lab/alternatives.lab"
n = numberOfSelected("TextGrid")
@is: n, 3, "Alternatives reas as different TextGrid objects"

for i to n
  tg[i] = selected("TextGrid", i)
endfor
for i to n
  selectObject: tg[i]
  @is: do("Get total duration"),            0.82, "Duration matches"
  @is: do("Get number of tiers"),           1,    "Tiers match"
  @is: do("Get number of intervals...", 1), 2,    "Intervals match"
endfor
for i to n
  removeObject: tg[i]
endfor

@ok_selection()

@done_testing()
