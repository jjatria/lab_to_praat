appendInfoLine: "1..1"

test = Read from file: "test.TextGrid"
test_intervals = Get number of intervals: 1

runScript: "../read_lab.praat", "1.lab", "audio1.wav"
tg = selected("TextGrid")
selectObject: tg
total_intervals = Get number of intervals: 1

pass = 1

if total_intervals == test_intervals
  for i to total_intervals
    selectObject: test
    a$ = Get label of interval: 1, i

    selectObject: tg
    b$ = Get label of interval: 1, i

    if a$ != b$
      pass = 0
    endif
  endfor
else
  pass = 0
endif

if pass
  appendInfoLine: "ok 1"
else
  appendInfoLine: "not ok 1"
endif
