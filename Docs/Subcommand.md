
# How to use specific subcommand

1. Maestro 

## Maestro

To use Maestro, you need to follow these steps:

1. Install Maestro. Learn more about `Maestro` [here](https://maestro.mobile.dev/) 
2. Create a maestro flow to run simulate the flow in your app.  
3. In your ci workflow, just call:
```bash
    leaksdetector maestro -p $YOUR_APP_NAME -maestro-flow-path $YOUR_MAESTRO_FILE_PATH
```

4. If you want to report the result to your Pull request/Slack/..., please check out the Report section.
