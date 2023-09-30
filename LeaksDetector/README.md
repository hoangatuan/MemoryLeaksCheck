# LeaksDetector

A executable program to checks for leaks in a running program

## How it works?

1. It run `maestro` to capture memory graph. Find out about Maestro here: https://maestro.mobile.dev/
2. It use `leaks` tool by Apple to generate a `memgraph` file, which contains all the leaks info if any.
3. Check for leaks
4. If there are any leaks, use `Danger` to post a message & mark a PR as failed.

## How to execute?

Just need to run the script:

```bash
    $ leaksdetector $PROGRAM_NAME $MAESTRO_PATH_FILE
```

## How to run local

1. Open `LeaksDetector.swift`, change `processName`, `executorType`, `maestroFlowPath`, `dangerPath` to a hardcoded value
2. Run:

```bash
   $ swift run
```

## How to release new executable file?

```bash
    $ swift build -c release
    $ cd .build/release
    $ cp -f leaksdetector $LeaksDetectorPath
```

## Todo

1. Investigate how to integrate with XCUITest
2. Integrate with DocC

## Why Maestro?

- TBA

### References:

- https://www.fivestars.blog/articles/ultimate-guide-swift-executables/
- https://www.fivestars.blog/articles/a-look-into-argument-parser/
- https://www.swiftbysundell.com/articles/building-a-command-line-tool-using-the-swift-package-manager/
- https://www.avanderlee.com/swift/command-line-tool-package-manager/
- Enum arguments: https://swiftinit.org/docs/swift-argument-parser/argumentparser/customizingcompletions
- Split to multiple Danger instance: https://www.jessesquires.com/blog/2020/12/15/running-multiple-dangers/
- Passing params to Danger: https://github.com/danger/swift/issues/213
