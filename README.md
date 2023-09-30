
# 🔎 CILeaksDetector 

This is a simple package that enables you to easily integrate the Memory leaks check to your CI workflow.

## Usage

Just need to follow these simple steps:

1. Copy `Dangerfile.leaksReport` to your project. This contains the logic to get the leaks message and post to your Pull request. You can custom this Dangerfile.  
Learn more about `Danger` [here](https://danger.systems/ruby/)

2. Create a maestro flow to run simulate the flow in your app.  
Learn more about `Maestro` [here](https://maestro.mobile.dev/)

3. In your ci workflow, just call:

```bash
    leaksdetector $YOUR_APP_NAME $PATH_TO_MAESTRO_FILE
```

## How it works

1. Use Maestro to simulate the UI flow in your app.   

Why I used Maestro?   
I need to testing tool which doesn't kill the program after the testing finished execution. And Maestro support that. Also Maestro is very to integrated & used.  
If you're using another UI testing framework which also support preserve the execution of the program after finish testing, you can create another PR to update the `leaksdetector`. It's easy to do that (but not for now, I'm doing that feature 🙂)

2. Generate `memgraph` using `leaks` tool provided by Apple.  
Find more about `leaks` tool and `memgraph` [here](https://developer.apple.com/videos/play/wwdc2018/416/)   

3. Use `leaksdetector` program to proceed the `memgraph` file. If any leaks founded, it will use Danger to post a message to your PR/slack, ... 

## Demo


