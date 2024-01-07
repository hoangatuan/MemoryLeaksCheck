
# Supported report process

1. Danger ✅
2. Slack (In progress)

## Danger

1. Create a new Dangerfile to handle the process checking for leaks.
You can copy `Dangerfile.leaksReport` in the example project.

2. You can customize the Dangerfile to do your own things.

### Why do I need to create a separated Dangerfile?

Because the process checking for leaks will trigger Danger to run. 
If you combine the leaks checking Dangerfile and your project Dangerfile to 1 Dangerfile only, the leaks process will execute your Danger logic as well.
