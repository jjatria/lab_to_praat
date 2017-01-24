appendInfoLine: "1..1"

test = Read from file: "test.TextGrid"
runScript: "read_lab.praat", "1.lab", "audio1.wav"
tg = selected("TextGrid")

if objectsAreIdentical(test, tg)
  appendInfoLine: "ok 1"
else
  appendInfoLine: "not ok 1"
endif
