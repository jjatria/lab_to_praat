include ../../plugin_tap/procedures/more.proc
include ../procedures/mlf.proc

@no_plan()

runScript: "../scripts/read_mlf.praat", "../t/samples/all_modes.mlf"
@is: numberOfSelected("Table"), 1, "Script reads Table from MLF file"
mlf = selected("Table")

@is_mlf()
@is_true: is_mlf.return, "Table is MLF"

@is: Object_'mlf'.nrow, 3, "MLF has correct number of patterns"

test$ = Object_'mlf'$[1, "mode"] + " " +
  ... Object_'mlf'$[2, "mode"] + " " + Object_'mlf'$[3, "mode"]
@is$: test$, "simple full direct", "MLF has correct modes"

test$ = Object_'mlf'$[3, "target"]
@is_true: index(test$, newline$), "Direct mode target is multiline"

removeObject: mlf

@ok_selection()

@done_testing()
