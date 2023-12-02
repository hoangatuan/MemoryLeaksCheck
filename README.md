
# 🔎 CILeaksDetector 

This is a simple package that enables you to easily integrate the Memory leaks check to your CI workflow.

# Getting started

![Static Badge](https://img.shields.io/badge/status-active-brightgreen)

## Usage

Just need to follow these simple steps:

1. Copy `Dangerfile.leaksReport` to your project. This contains the logic to get the leaks message and post to your Pull request. You can custom this Dangerfile.  
Learn more about `Danger` [here](https://danger.systems/ruby/)

2. Create a maestro flow to run simulate the flow in your app.  
Learn more about `Maestro` [here](https://maestro.mobile.dev/)

3. In your ci workflow, just call:

```bash
    leaksdetector -processName $YOUR_APP_NAME -e $SUPPORTED_TESTING_FRAMEWORKS -d $PATH_TO_DANGER_FILE
```

## Current testing frameworks

- [Maestro](https://maestro.mobile.dev/) ✅
- [XCUITest](https://developer.apple.com/documentation/xctest) (XCUITest is not supported. Read more [here](./Docs/XCUITests.md)) ❌

## How it works

1. Use Maestro to simulate the UI flow in your app.   

2. Generate `memgraph` using `leaks` tool provided by Apple.  
Find more about `leaks` tool and `memgraph` [here](https://developer.apple.com/videos/play/wwdc2018/416/)   

3. Use `leaksdetector` program to proceed the `memgraph` file. If any leaks founded, it will use Danger to post a message to your PR/slack, ... 

## Why I used Maestro?
   
1. I need a testing tool which doesn't kill the program after the testing finished execution. And Maestro support that. Also Maestro is very easy to integrate & use.  
2. XCUITest can not preserve running program after test execution. Read more at [here](./Docs/XCUITests.md) 

## How to support your testing frameworks

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
        
        func getMemgraphPath() -> String {
            // return the path to the generated memgraph
        }
    }
    
```

2. Open `ExecutorFactory.swift`, define your new UI testing frameworks to the `ExecutorType`, and add logic to generate it in the `createExecutor` func.

3. Add new `@Option` to the executable program if need

## Result

<img src=resources/result.png width=800/>

## Publication

I've published an article about this on Medium. You can take a look at [here](https://medium.com/gitconnected/automating-memory-leak-detection-with-ci-integration-for-ios-380f08a55f0b)
