
# XCUITests

Ideas to integrate XCUITests:

1. Trying to find a way to preserve the running program after tests finish running, then use `leaks` tool to generate `memgraph`

=> Doesn't work because there isn't any way to preverse the running program.

2. At the end of a test, run shell script to generate `memgraph` before the running program quit:

For this idea, we can put a breakpoint before the test end its execution. Then we can custom that breakpoint to execute a shell script command.   
However, when running on CI, we will execute test using script, not from Xcode. So, using breakpoint to execute shell script will not work for CI

=> Only work on local, doesn't work on CI

3. From Xcode13, Apple provide `-enablePerformanceTestsDiagnostics` to generate memgraph after a test finish executing. However, this only works for real device, not for simulator.

Based on [Apple docs](https://developer.apple.com/documentation/xcode-release-notes/xcode-13-release-notes)

> xcodebuild has a new option -enablePerformanceTestsDiagnostics YES that collects diagnostics for Performance XCTests. The option collects a ktrace file for non-XCTMemoryMetrics, and a series of memory graphs for XCTMemoryMetrics. xcodebuild attaches diagnostics to the generated xcresult bundle. Note that memory graph collection isn’t available in simulated devices. (64495534)

=> Only work on local, doens't work on CI
