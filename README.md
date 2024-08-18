
# 🔎 CILeaksDetector 

![Static Badge](https://img.shields.io/badge/status-active-brightgreen)

This is a simple tool to help you checking for leaks in your program automatically in the most accurate way, then it will send the report directly to your development workflow (Pull request/Slack/...).
And even better, you can easily integrate this tool to your CI workflow.

<img src=resources/result.png width=800/>

# Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Current supported testing frameworks](#current-supported-testing-frameworks)
- [How?](#how)
- [How to support your testing framework](#how-to-support-your-testing-framework)
- [Publication](#publication)

## Installation

You can go to [GitHub Releases](https://github.com/hoangatuan/MemoryLeaksCheck/releases) page to download release executable program.

## Usage

The most simple way to run the leaks checking process is:

```bash
    leaksdetector $subcommand -p $YOUR_APP_NAME
```

### How to use subcommands

Check out [this document](./Docs/Report.md) for how to use specific subcommands

### How to report the result to your development workflow

Check out [this document](./Docs/Report.md) for how to customize the process to send the result to your workflow

## Current supported testing frameworks

- [Maestro](https://maestro.mobile.dev/) ✅
- [XCUITest](https://developer.apple.com/documentation/xctest) ✅ (Only support real device. Read more [here](./Docs/XCUITests.md)) 
- [Appium](http://appium.io/) 🚧 (In progress)

### Why I used Maestro?
   
1. I need a testing tool which doesn't kill the program after the testing finished execution. And Maestro support that. Also Maestro is very easy to integrate & use.  
2. XCUITest can not preserve running program after test execution on Simulator. Read more at [here](./Docs/XCUITests.md). However, Xcode support generate memgraph file for XCUITest when running test on real device => XCUITest is a great match for company uses real device farm for testing.

## How it works

1. Use a testing tool to simulate the UI flow in your app.   

2. Generate `memgraph` using `leaks` tool provided by Apple.  
Find more about `leaks` tool and `memgraph` [here](https://developer.apple.com/videos/play/wwdc2018/416/)   

3. Use `leaksdetector` program to proceed the `memgraph` file. If any leaks founded, it will use Danger to post a message to your PR/slack, ... 

## How to support your testing framework

If you're using another UI testing framework which also support preserve the execution of the program after finish testing, you can create another PR to update the `leaksdetector`.   
It's easy to do that, just need to follow these steps:   

1. Open `Executor.swift`, create a new instance of your testing frameworks. Your new instance needs to conform to `Executor` protocol. 
  
```swift

    struct XCUITestExecutor: Executor {
        
        func simulateUI() throws {
            // Custom logic to start simulating UI
        }
        
        func generateMemgraph(for processName: String) throws {
            // Custom logic to start generating memgraph for a `processName`
        }
        
        func memgraphPaths() -> [String]
            // return the path to the generated memgraphs
        }
    }
    
```

2. Go to `Commands` folder to create a new command for your testing framework. Please refer to `MaestroCommand`.

## Publication

I've published an article about this on Medium. You can take a look at [here](https://medium.com/gitconnected/automating-memory-leak-detection-with-ci-integration-for-ios-380f08a55f0b)
