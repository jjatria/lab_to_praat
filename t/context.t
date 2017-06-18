include ../../plugin_tap/procedures/more.proc

@no_plan()

textgrid = Read from file: "../t/samples/context.TextGrid"

# Left
selectObject: textgrid
runScript: "../scripts/prune_context.praat", 0, 1, 0, 0

@is_true: numberOfSelected("TextGrid"), "Pruning selects TextGrid"
@isnt: selected(), textgrid, "Pruning creates copy"

@like: selected$("TextGrid"), "_left$", "Assign left suffix"
@is$: do$("Get label of interval...", 1, 1), "",   "Empty left context"
@is$: do$("Get label of interval...", 1, 3), "b-", "Extracted left context"

Remove

# Name
selectObject: textgrid
runScript: "../scripts/prune_context.praat", 0, 0, 1, 0

@like: selected$("TextGrid"), "_name$", "Assign name suffix"
@is$: do$("Get label of interval...", 1, 1), "a", "Extracted name from right"
@is$: do$("Get label of interval...", 1, 2), "b", "Extracted name from both"
@is$: do$("Get label of interval...", 1, 3), "c", "Extracted name from left"

Remove

# Right
selectObject: textgrid
runScript: "../scripts/prune_context.praat", 0, 0, 0, 1

@like: selected$("TextGrid"), "_right$", "Assign right suffix"
@is$: do$("Get label of interval...", 1, 3), "",   "Empty right context"
@is$: do$("Get label of interval...", 1, 1), "+b", "Extracted right context"

Remove

removeObject: textgrid

@ok_selection()

@done_testing()
