# wsl-alias

Create aliases of Linux commands to access them from Windows command line or PowerShell!

This is a simple Windows batch script and bash command wrapper that allows you to pass commands to your WSL (Windows Subsystem for Linux) from Windows and adds a few sweet features like aliases and automatic mounting. What that means is you can install PHP, NodeJS, etc. in your WSL and use them from Windows!

If you still don't understand what that means, here are a few examples (all commands are executed from the Windows PowerShell):
```
> cd C:\Users\User\Documents\repo
> b git commit -m "commit message"
```

```
> b apt-get install php-cli
> b wsl-alias add php php
> php -v
```

```
> cd Z:\Projects
> b pwd
/mnt/z/Projects
```

## Features

Here's a quick overview of the features:
-   pass commands to WSL without escaping them
-   use Linux programs and scripts as if they were installed in Windows
-   a single file with environment variables and code that will be loaded when executing commands or entering an interactive shell (solves [this](https://github.com/Microsoft/BashOnWindows/issues/219))
-   automatically mount the drives that WSL doesn't - with different filesystems and even network drives (solves [this](https://superuser.com/a/1133984/413987))
-   translates your current Windows path into the WSL path

## Installation

First of all, make sure you're running the Fall Creators update or newer and have installed Ubuntu on Windows 10 (or another distribution) from the [Windows Store](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide). Next, start up wsl (using the command `bash` or `wsl`) on Windows 10 as the default user and run this command:
```
bash <(curl -o- https://raw.githubusercontent.com/leongrdic/wsl-alias/master/install.sh)
```
The install script will clone this repository and put it into the right directory with right permissions, create a new user and configure it.
You will be asked to choose the __default alias__ (command that will actually call the `bash` command). You can just leave it empty, which sets it to `b`.

Finally you will get a message from the installer with a path that you should copy and put into your user environment variable on Windows. ([here](https://stackoverflow.com/a/44272417/1830738)'s a beautiful tutorial)

All you have to do now is open the command line or PowerShell and start typing your first commands:
```
b          # opens an interactive shell
b [cmd]    # executes the command cmd in WSL
```
note: if you chose a different default alias, use it instead of `b`

## Aliases
Aliases allow you to call Linux commands from Windows. They pass all the arguments and the current directory and allow you to benefit of the auto-mount feature.

Use the command `wsl-alias` inside WSL as following:
```
wsl-alias list                       # lists all aliases
wsl-alias add [name] [command]       # adds a new alias
wsl-alias remove [name]              # removes an existing alias
```
Make sure you don't remove the default alias (the one you specified during installation) or you might have to reinstall `wsl-alias`. This is because the command `wsl-alias` only works when you're accessing WSL using one of the existing aliases.

## `env.sh` script
Yyou can use the shell script `~/.wsl/env.sh` to define environment variables, mount drives or run other scripts every time you use any of your aliases. For example you can include the _`nvm` initialization code_ or `ssh-agent` setup there.

This script also directly serves as a replacement for `.bashrc`, of course only for user-added commands and variables. (note they will only be accessible when using one of your aliases)

The `$wsl_interactive` variable provides a way to find out if the user has passed any arguments with the _default alias_
```
$wsl_interactive == "0"     # a command was passed
$wsl_interactive == "1"     # no commands passed
```
This might be useful if, for example, you want to set up `ssh-agent`. You will only invoke it if the shell is interactive, there's no need otherwise.

Setting an environment variable:
```
export variable="value"
```

If you need to execute a command as root, and don't want to get prompted for the password each time you use an alias, use the `wsl_sudo` function:
```
wsl_sudo "whoami"
```

## Auto mounting
When you call any alias, your current directory is taken from Windows and translated into a WSL path (e.g. `/mnt/c/Users`). Windows already does this but not for all drives. That's where `wsl-alias` comes in - we check if the drive isn't already mounted and do it without prompting you for the root password!

As WSL only lives as long as its last session, you might not be able to access a drive if your current working directory is somewhere else but you're referencing the unmounted drive from the alias. That's why we provide you with a way to always mount your drive, whether you're just entering the interactive shell (using the default alias) or passing a command - add the following line to the `env.sh` file:
```
wsl_sudo "sudo mount -t drvfs Z: /mnt/z"
```
Replace the letters with your actual drive letters.

### Avoid mounting drives on each alias run

You can use an approach like [this one](https://emil.fi/bashwin) (props to that guy) to make WSL always run in background so that your drives don't get unmounted when closing the last WSL session.
Or simple upvote [this](https://wpdev.uservoice.com/forums/266908-command-prompt-console-bash-on-ubuntu-on-windo/suggestions/13653522-consider-enabling-cron-jobs-daemons-and-background) to make Microsoft realize we need WSL running in background.

## Escaping commands
### PowerShell
```
b echo "a \""b\"" c"     # prints: a "b" c
b echo "a 'b' c"         # prints: a 'b' c
b echo 'a \"b\" c'       # prints: a "b" c
b echo 'a ''b'' c'       # prints: a 'b' c
```

### cmd
```
b echo "a \"b\" c"       # prints: a "b" c
b echo "a 'b' c"       # prints: a 'b' c
b echo 'a "b" c'       # prints: a "b" c
# not possible to escape single quotes inside single quotes
```

PowerShell is recommended because of better syntax support, but both should do for basic functionality.

## Limitations
Unfortunately you can't pass all symbols through `wsl-alias`. Those include redirectors (`>`, `>>`, `<`, etc.), separators (`;`, `&&`, etc.). But you can always open an interactive shell and execute commands just like you would on Linux!

## Troubleshooting
The most common problems...
1.  are you running Windows 10 version 1709 A.K.A. Fall Creators Update (build 16215 or later)?
1.  have you updated the PATH environment variable in Windows?
1.  did you install `wsl-alias` as the default WSL user?
1.  did you remove the default alias?
1.  is `bash` installed inside WSL? (in case of a custom distro)

### Fall Creators update
It's necessary to have this version because of a few features that weren't supported in the previous (LXSS) builds:
-   executing commands as another user through `sudo`
-   `drvfs` which allows for mounting any drive

## Reinstallation or uninstallation
If you want to reinstall (e.g. a newer version) simply run the installer command again.

To uninstall just remove the `~/.wsl` directory like so:
```
rm -rf ~/.wsl
```

## Security
`wsl-alias` creates a user `wsl` inside your WSL and gives it root privileges. That user has a disabled login, but your default account gets configured with access to it through `sudo`.

Since all WSL users have the same permissions for Windows files (`/mnt/`), this shouldn't be considered a security risk, except if you have some important data protected with the Linux permissions.

If you find any security related bugs, please open an issue or better yet contact me personally. I do not guarantee that this code is 100% secure and it should be used at your own risk.
