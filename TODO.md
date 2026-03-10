# PROJECT
Uses nix flakes for building and dev environmet, updated as needed.
All project have their on directory, and there own build/pkg output in the flake.

We do not want to use flake utils!

## Monitor Deamon

### Instructions
* Create a State struct holding current state
* queary the current state of monitors and lid,
 set it in the state and print state to std as json
* listen for devices added or removed and lid state changes,
  and updates the state accordingly, then prints it out as json to stdout
* make sure cleans up correctly,
  and that it can be terminated with standard linux signals without issues
