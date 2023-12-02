
# XCUITests

After the tests finish execution, the essential thing that we need is the simulator needs to stay alive.
The problem with `XCUITests` is that after testing finish execution, it quit the simulator.

# Things I've tried:

1. Trying to find a way to preserve the running program after tests finish running

- I can't find any way to preserve the running program.

2. At the end of a test, run shell script to generate `memgraph` before the running program quit

For this idea, I put a breakpoint before the test finish execution. Then we can custom that breakpoint to execute a shell script command.   
However, when running on CI, we will execute test using script, not from Xcode. So, using breakpoint to execute shell script will not work for CI

=> Only work on Xcode

3. From Xcode13, Apple provide `-enablePerformanceTestsDiagnostics` to generate memgraph after a test finish executing.

```bash
    xcodebuild test -project MemoryLeaksCheck.xcodeproj \
        -scheme LeaksCheckerUITests \
        -destination platform=iOS,name="Tuan iPhone" \
        -enablePerformanceTestsDiagnostics YES
```

> Note: In the scheme configuration, open `Options` under `Test`, unselect "Delete if test succeeds" for Attachments.

<img src=../resources/xcuitests.png width=800/>

However, **this only works for real device, not for simulator.**

Based on [Apple docs](https://developer.apple.com/documentation/xcode-release-notes/xcode-13-release-notes)

> xcodebuild has a new option -enablePerformanceTestsDiagnostics YES that collects diagnostics for Performance XCTests. The option collects a ktrace file for non-XCTMemoryMetrics, and a series of memory graphs for XCTMemoryMetrics. xcodebuild attaches diagnostics to the generated xcresult bundle. **Note that memory graph collection isn’t available in simulated devices. (64495534)**

=> Only work on local with real device, doesn't work on CI

# Conclusion

XCUITests is not appropriate for this approach. (for now)
