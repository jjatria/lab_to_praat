include ../../plugin_tap/procedures/more.proc
include ../../plugin_utils/procedures/try.proc

@plan: 17

runScript: "../scripts/read_mlf.praat", "../t/samples/all_modes.mlf"
mlf = selected("Table")

# Read in simple mode
@test_lab: "simple", "a"
@test_lab: "simple", "b"

# Read in full mode
@test_lab: "full", "sub/a"
@test_lab: "full", "sub/b"
@test_lab: "full", "c"

# Read in direct mode
@test_lab: "default", ""

@diag: "Testing Praat objects"
@test_obj: "Pitch"
@test_obj: "Intensity"

removeObject: mlf

@ok_selection()

@done_testing()

procedure test_obj: .type$
  selectObject: mlf
  .name$ = replace_regex$(.type$, "(.*)", "\L\1", 0)

  runScript: "../scripts/query_mlf.praat", .name$ + "." + .type$, "Glob"
  @is_true: numberOfSelected(.type$), "Found a '.type$' object"
  @is$: selected$(.type$), .name$, "Found correct file"
  Remove
endproc

procedure test_lab: .dir$, .file$
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
