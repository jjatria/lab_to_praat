include ../../plugin_tap/procedures/more.proc
include ../../plugin_utils/procedures/try.proc

@no_plan()

runScript: "../scripts/read_mlf.praat", "../t/samples/all_modes.mlf"
mlf = selected("Table")

# Read in simple mode
@test: "simple", "a"
@test: "simple", "b"

# Read in full mode
@test: "full", "sub/a"
@test: "full", "sub/b"
@test: "full", "c"

# Read in direct mode
@test: "default", ""

removeObject: mlf

@ok_selection()

@done_testing()

procedure test: .dir$, .file$
  @diag: "Testing '.file$' in '.dir$'"
  selectObject: mlf
  runScript: "../scripts/query_mlf.praat", .dir$ + "/" + .file$ + ".lab", "Glob"
  @is_true: numberOfSelected("TextGrid"), "Found a label, converted to TextGrid"
  label$ = Get label of interval: 1, 2
  @is$: label$, .dir$ + right$(.file$), "Found correct file"

  if selected() != mlf
    removeObject: selected()
  endif
endproc
