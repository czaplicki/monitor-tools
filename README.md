# monitor-tools


## Monitor Daemon
Checks for display being pluged in/out and laptop lid state,
and output state as json.

### Command
monitor-daemon          -> start the application
monitor-daemon (--)help -> usage/help

### Output
```json
{
  "monitors" = ["eDP-1", "HDMI-1", ...],
  "lid_open" = <bool>,
}
```

## Monitor Query
monitor-query list          -> list all monitors
monitor-query info <device> -> give info about a montior
  
## Monitor Manager
Takes the state for damon and maps them to profiles in a configuration.
Also listens for ipc, for selecting and quering profiles.

monitor-manager current         -> outputs current profile
monitor-manager list            -> outputs availible profiles in current state
monitor-manager list all        -> outputs all profiles from the config
monitor-manager apply <profile> -> sets the current profile
monitor-manager help            -> print help/usage

monitor-manager start -> start the manager, taking state changes from stdin,
                       listens to ipc calls, and outputs configurations to apply

### Config (toml)
```toml
[[profile]]
name = "builtin"
match = [{
  lid = "open",
  monitors = ["laptop"],
}]
output = ["laptop"]

[[profile]]
name = 'both'
match = {[
  lid = 'open',
  prio = 1
  monitors = ["laptop", "external"],
]}
output = ["laptop", "external"]

[[profile]]
name = "external"
match = [
  { monitors = ["external"]},
  { lid = closed,
    prio = 2
    monitors = ["external"]
  },
]}
output = ["external"]

[[profile]]
name = "external"
match = [
  { monitors = ["external"]},
  { lid = closed,
    prio = 2
    monitors = ["external"]
  },
]}
output = ["external-vertical"]

[[output]]
name = "eDP-1"
alias = "laptop"
width = <int>
height = <int>
refresh = <int>
scale = <float>
position = { x = 0, y = 0}


[[output]]
name = "HDMI-1"
alias = "external"
width = <int>
height = <int>
refresh = <int>
scale = <float>
```


### Output format
All monitors are always given
```json
{
  "monitors" = [
    "<monitor-1-name>" = {
      "on" = true|false,
      "width"  = <int>,
      "height" = <int>,
      "refresh" = <int>,
      "scale"   = <float>,
    }
    "<monitor-2-name>" = {
      "on" = true|false,
      "width"  = <int>,
      "height" = <int>,
      "refresh" = <int>,
      "scale"   = <float>,
    }
  ]
}
```

## Applicators
Reads the output monitor-manager through stdin and translates it in to calls.

monitor-applicator wlr -> Uses wlr-randr for its calls, should work for any compositor that
                          has wlr-output-management protocol implementd

monitor-applicator x11 -> Uses xrandr for its calls



