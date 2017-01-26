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

runScript: "../scripts/read_lab.praat", "../t/1.lab", "../t/audio1.wav"
@is_true: numberOfSelected("TextGrid"), "Script generates TextGrid with Sound"
@is_true: numberOfSelected("Sound"),    "Script reads Sound"

textgrid = selected("TextGrid")
sound    = selected("Sound")

selectObject: textgrid
textgrid_duration = Get total duration

@is: test_duration, textgrid_duration, "TextGrid from Sound has same duration"

selectObject: test_textgrid, textgrid
pause
@test_intervals()

removeObject: textgrid
removeObject: sound

procedure test_intervals ()
    .ref  = selected("TextGrid", 1)
    .test = selected("TextGrid", 2)

    selectObject: .ref
    .ref_tiers = Get number of tiers
    selectObject: .test
    .test_tiers = Get number of tiers
    @is: .ref_tiers, .test_tiers, "Same number of tiers"

    if ok.value
        for .tier to .test_tiers
            selectObject: .test
            @is_true: do("Is interval tier...", .tier), "Tier '.tier' is interval tier"

            selectObject: .test
            .test_intervals = Get number of intervals: .tier

            @diag: "Testing '.test_intervals' intervals"
            for .i to .test_intervals
                selectObject: .test
                .interval = .i
                .test_label$ = Get label of interval:      .tier, .interval
                .test_start  = Get start time of interval: .tier, .interval
                .test_end    = Get end time of interval:   .tier, .interval
                .mid         = .test_start + (.test_end - .test_start) / 2

                selectObject: .ref
                .interval = Get interval at time: .tier, .mid
                if .interval
                    .ref_label$ = Get label of interval:      .tier, .interval
                    .ref_start  = Get start time of interval: .tier, .interval
                    .ref_end    = Get end time of interval:   .tier, .interval

                    @is$: .test_label$, .ref_label$, "Interval label " + string$(.interval)
                    @is:  .test_start,  .ref_start,  "Interval start " + string$(.interval)
                    @is:  .test_end,    .ref_end,    "Interval end "   + string$(.interval)
                else
                    @diag: "No equivalent interval in reference data!"
                endif
            endfor
        endfor
    endif
endproc

removeObject: test_sound, test_textgrid

@ok_selection()

@done_testing()
