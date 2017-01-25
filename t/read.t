include ../../plugin_tap/procedures/more.proc

@no_plan()

test_sound = Read from file: "audio1.wav"
test_duration = Get total duration

test_textgrid = Read from file: "test.TextGrid"

# runScript: "../read_lab.praat", "../t/1.lab", ""
# @is_true:  numberOfSelected("TextGrid"), "Script generates TextGrid without Sound"
# @is_false: numberOfSelected("Sound"),    "Script does not read Sound"
#
# textgrid = selected("TextGrid")
# selectObject: textgrid, test_textgrid
# @test_intervals()
#
# removeObject: selected("TextGrid")

runScript: "../read_lab.praat", "t/1.lab", "t/audio1.wav"
@is_true: numberOfSelected("TextGrid"), "Script generates TextGrid with Sound"
@is_true: numberOfSelected("Sound"),    "Script reads Sound"

textgrid = selected("TextGrid")
sound    = selected("Sound")

selectObject: textgrid
textgrid_duration = Get total duration

@is: test_duration, textgrid_duration, "TextGrid from Sound has same duration"

selectObject: textgrid, test_textgrid
@test_intervals()

removeObject: textgrid
removeObject: sound

procedure test_intervals ()
    .a = selected("TextGrid", 1)
    .b = selected("TextGrid", 2)

    selectObject: .a
    .an = Get number of intervals: 1

    selectObject: .b
    .bn = Get number of intervals: 1

    .min = min(.an, .bn)
    for .i to .min
      selectObject: .a
      .a$ = Get label of interval: 1, .i
      .as = Get start time of interval: 1, .i
      .ae = Get end time of interval: 1, .i

      selectObject: .b
      .b$ = Get label of interval: 1, .i
      .bs = Get start time of interval: 1, .i
      .be = Get end time of interval: 1, .i

      @is$: .a$, .b$, "Interval label " + string$(.i)
      @is:  .as, .bs, "Interval start " + string$(.i)
      @is:  .ae, .be, "Interval end "   + string$(.i)
    endfor
endproc

removeObject: test_sound, test_textgrid

@ok_selection()

@done_testing()
