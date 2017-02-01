include ../../plugin_tap/procedures/more.proc
include ../../plugin_utils/procedures/utils.proc

@no_plan()

@mktempfile: "HTKlabel_XXXXX", "lab"
tempfile$ = mktempfile.return$

head$[1] = "/// ice_cream"         + newline$
head$[2] = "/// I_scream"          + newline$

block$[1] = ""
... + "000000000 003600000 ice"    + newline$
... + "003600000 008199999 cream"  + newline$

block$[2] = ""
... + "000000000 002200000 I"      + newline$
... + "002200000 008199999 scream" + newline$

tg[1] = Create TextGrid: 0, 0.82, "token", ""
Rename: "ice cream"

tg[2] = Copy: "I scream"
Insert boundary: 1, 0.22
Set interval text: 1, 1, "I"
Set interval text: 1, 2, "scream"

selectObject: tg[1]
Insert boundary: 1, 0.36
Set interval text: 1, 1, "ice"
Set interval text: 1, 2, "cream"

selectObject: tg[1]
deleteFile: tempfile$
runScript: preferencesDirectory$ + "/plugin_htklabel/scripts/" +
  ... "write_lab.praat", tempfile$

test$ = readFile$(tempfile$)
@is_true: fileReadable(tempfile$), "creates file"
@is$: test$, block$[1], "single alternative"
@is: selected("TextGrid"), tg[1], "single selection doesn't change"

selectObject: tg[1], tg[2]
deleteFile: tempfile$
runScript: preferencesDirectory$ + "/plugin_htklabel/scripts/" +
  ... "write_lab.praat", tempfile$

test$ = readFile$(tempfile$)
@is_true: fileReadable(tempfile$), "creates file"
@is$: test$, head$[1] + block$[1] + head$[2] + block$[2], "multiple alternatives"
@is: numberOfSelected("TextGrid"), 2, "multiple selection doesn't change"

deleteFile: tempfile$
@is_false: fileReadable(tempfile$), "removed temporary file"

removeObject: tg[1], tg[2]

@ok_selection()

@done_testing()
