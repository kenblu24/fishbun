<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="144px" height="144px"/>

#### fishbun
> A theme for [Oh My Fish][omf-link].

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v3.0.0-007EC7.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

<br/>


## Install

```fish
$ omf install fishbun
```

A familiar theme with goodies.

Inspired by [cmorrell](https://github.com/oh-my-fish/theme-cmorrell.com) and [pure](https://github.com/pure-fish/pure)

## Features

* Simple, easy-to-understand one-line prompt
* Smart path shortening
* Shows current location in terminal title bar in reverse order
* Left-side Python virtual environment indicator
* Right-side error status indicator
* Right-side Git status indicator
* Optionally hide hostname or username
* Shows a warning if you're root


## Screenshot

<p align="center">
<img src="{{SCREENSHOT_URL}}">
</p>


# Options

Reminder: Set a variable with `set -g <variable name> <value>` and erase/unset with `set -e <variable name>`

## Common options

* `default_user` When `$USER` is in `$default_user`, the username@hostname will be hidden.
* `fish_prompt_pwd_full_dirs` is the number of directories to show the full names of in the prompt. Default is `1`.
* `fish_prompt_pwd_dir_length` is the maximum length of shortened directories in the prompt. Set to `0` to disable path shortening. Default is `1`.

## Advanced options

* `fish_prompt_no_custom_virtualenv` If defined, ignore `$VIRTUAL_ENV`. Note that virtualenv activation scripts may still modify the prompt.
* `fish_prompt_pwd_ellipsis` This is passed as the [`string shorten -c`](https://fishshell.com/docs/current/cmds/string.html#shorten-subcommand) argument when shortening path components. Set to `SMART` to let `string shorten` use the default ellipses character. Default is `"SMART"`.
* `fish_prompt_custom_prefix` If this function is defined, it will be called before the prompt is generated.


# License

[MIT][mit] © [kenblu24][author] et [al][contributors]


[mit]:            https://opensource.org/licenses/MIT
[author]:         https://github.com/kenblu24
[contributors]:   https://github.com/kenblu24/fishbun/graphs/contributors
[omf-link]:       https://www.github.com/oh-my-fish/oh-my-fish

[license-badge]:  https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
