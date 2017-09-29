# easyWSLbash

IMPORTANT: only works with Windows 10 version 1709 (build 16215 or later) and Ubuntu installed from the Windows Store.

This is a simple Windows batch script and bash command wrapper. It allows you to pass commands to your Ubuntu (Windows Subsystem for Linux) from PowerShell and adds a few sweet features. What that means is you can install PHP, NodeJS, etc. in your WSL and use them from Windows!

If you still don't understand what that means, here are a few examples (all commands are executed from the Windows PowerShell):
```
> cd C:\Users\User\Documents\repo
> b git commit -m "commit message"
```

```
> b apt-get install php-cli
> b php 
```

```
> cd Z:\Projects
> b pwd
/mnt/z/Projects
```

## Features

Here's a quick overview of the features:
-   pass commands to bash without escaping them
-   use Ubuntu programs and scripts as if they were installed in Windows
-   create a file with environment variables and code that will be loaded when executing commands or entering an interactive shell (solves [this](https://github.com/Microsoft/BashOnWindows/issues/219))
-  automatically mount the drives that WSL doesn't - with different filesystems and even network drives (solves [this](https://superuser.com/a/1133984/413987))
-   translates your current Windows path into the WSL path

## Installation

This part couldn't be easier. Okay maybe it could be it's still relatively easy...

First of all, make sure you have installed Ubuntu on Windows 10 from the [Windows Store](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide). Next, open your bash on Windows 10 and run this command:
```
curl -o- https://raw.githubusercontent.com/leongrdic/easyWSLbash/master/install.sh | bash
```
The install script will clone this repository and put it into the right directory with right permissions, create a new user and configure it.

Finally you will get a message from the installer with a path that you should copy and put into your user environment variable on Windows. ([here](https://stackoverflow.com/a/44272417/1830738)'s a beautiful tutorial for doing that)

All you have to do now is open the PowerShell and start typing your first commands:
```
b          # opens an interactive shell
b [cmd]    # executes the command cmd in WSL
```

## FAQ
### It doesn't work
1.  are you running Windows 10 version 1709 (build 16215 or later)?
1.  have you updated the PATH environment variable in Windows?
1.  do you have the latest updates installed (on both Windows and Ubuntu)?

### I get errors regarding quotes (`"` or `'`)
Are you using PowerShell? This script doesn't work with `cmd`.
Escaping works like this:
```
b echo "his name is \""john\""."     # prints: his name is "John".
b echo "his name is 'John'."         # prints: his name is 'John'.
b echo 'his name is ''John''.'       # prints: his name is 'John'.
```
Please note that there is no way to escape double quotes (`"`) within single quotes (`'`) due to a batch scripting limitation. At least I think so... I spent hours trying to solve this, so if you know how to, feel free to open a PR. Thank you.

### How do I define global environment variables?
```
b nano ~/.wsl/env.sh
```
This shell script (`~/.wsl/env.sh`) gets sourced in every command you pass through `easyWSLbash` and even in the interactive shell! So it's a great place to put all your environment variables and do stuff like mounting drives that aren't automatically mounted.

How to set an environment variable:
```
export variable="value"
```

If you need to execute a command as root, and don't want to get prompted for the password each time, use this:
```
wsl_sudo "mount ....."
```

### My drives don't get automatically mounted or get unmounted
When you call `easyWSLbash` while being in a directory on a drive that's not automatically mounted in WSL, `easyWSLbash` actually tries to mount that drive before navigating to it inside the bash environment. This works for flash drives and network drives.

If you always want to mount a drive, check the first question to add it to the `env.sh` file.

When the last WSL window is closed, Windows automatically stops all bash services and shuts down WSL completely which results in those drives being unmounted. One solution is to use the interactive shell to work on those drives (simply execute `b` while being in it using PowerShell).

You could also use an approach like [this one](https://emil.fi/bashwin), props to that guy btw. Or just upvote [this](https://wpdev.uservoice.com/forums/266908-command-prompt-console-bash-on-ubuntu-on-windo/suggestions/13653522-consider-enabling-cron-jobs-daemons-and-background) to make Microsoft realize we need bash running in background.

Note: there is an expeption when detecting if a drive is already mounted. If you're in the root of a drive (e.g. `Z:\`) it won't automatically get mounted because its directory (`/mnt/z`) already exists. To get around this add the auto mount to `env.sh`.

### What are the limitations of passing commands to bash?
Unfortunately you can't pass all symbols to bash through `easyWSLbash`. Those include redirectors (`>`, `>>`, `<`, etc.), separators (`;`, `&&`, etc.). But you can always open an interactive shell and execute commands just like you would on Ubuntu!

### Reinstallation or uninstallation
If you want to reinstall (e.g. a newer version) simply run the installer script again.

To uninstall just remove the `~/.wsl` directory like so:
```
rm -rf ~/.wsl
```

### Any security implications?
`easyWSLbash` creates a user `wsl` inside your WSL and gives it root privileges. That user has a disabled login, but your default account gets configured with access to it via `sudo`.

This shouldn't be considered a security risk since WSL is only supposed to be used for development purposes.

If you find any security related bugs, please open an issue or better yet contact me personally. I do not guarantee that this code is 100% secure and it should be used at your own risk.



