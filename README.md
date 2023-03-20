# clr.sh
clr.sh: ANSI coloring function for bash scripts, absurdly minified

[What?](#whats-this) | [Usage](#Usage) | [Why?](#why-would-i-use-this) | [How?](#how-does-this-thing-work)

## What's This? 

clr.sh is a file containing a highly-minified bash function that you can source from your script, or paste within your script. 

It will allow you to use all 16 foreground and background colors in all 256 combinations of the standard 4-bit ANSI color palette. It also supports bold text and underlines. 

It is designed to have a very brief syntax that will avoid bulking up your strings of colored text. 

Here is a picture of it in action:

![Example Image](https://raw.githubusercontent.com/rustyflavor/clr.sh/main/images/clr_examples.png)

Here is a table of the supported color combinations and the codes that represent them:

![Color Table](https://raw.githubusercontent.com/rustyflavor/clr.sh/main/images/clr_table.png)

## Usage

Insert the function in your bash script, or source it with `source /path/to/clr.sh`, and call it using its minimalist syntax:

`$(clr string)`

Call it without a string to reset to normal formatting/coloring with the `\e[m` reset signal.

`$(clr)`

Calling it with a string that contains no valid formatting or coloring symbols has the same result as calling it without a string, since invalid symbols are discarded. 

`string` should be comprised of the following symbols:

### Formatting symbols:

| Symbol         | Format           | Raw ANSI |
| -------------- | ---------------- | -------- |
| _ (underscore) | Underline        | `\e[4m`  |
| - (minus)      | Remove underline | `\e[24m` |
| + (plus)       | Bold             | `\e[1m`  |
| = (equal sign) | Remove Bold      | `\e[22m` |

*Note that each remove symbol is the same US keyboard key as the formatting symbol, unshifted.*

Formatting symbols should come before color symbols.

### Color symbols: 

| Symbol | Color   | Symbol | Color |
| ------ | ------- | ------ | ---------------- |
| r      | Red     | R      | Bright Red       |
| g      | Green   | G      | Bright Green     |
| b      | Blue    | B      | Bright Blue      |
| c      | Cyan    | C      | Bright Cyan      |
| m      | Magenta | M      | Bright Magenta   |
| y      | Yellow  | Y      | Bright Yellow    |
| k      | Black   | K      | Bright Black     |
| w      | White   | W      | Bright White     |
| .      | None    | @      | Terminal Default |

If you provide one color symbol, the foreground will be adjusted. 

If you provide two color symbols, the first represents the foreground and the second the background. 

To change the color of the background without changing the foreground, use the `.` dot character as the foreground symbol. For example, `$(clr .g)` will change the background to green without changing the foreground. This lets you efficiently omit a redundant foreground parameter in the resulting escape sequence. 

The function finishes and emits your requested escape sequence as soon as it recognizes a second valid color symbol. Excess input will be discarded. (This is why formatting symbols should be placed first.)

The @ symbol represents the terminal's default foreground and background colors (ANSI `\e[39m` and `\e[49m`). If the first color symbol is `@`, the user's preferred foreground color will be applied. Likewise for the their preferred background color when `@` is the second color symbol. 

## Why would I use this?

If you aren't already tempted by the examples shown, you probably don't need this. 

If you write scripts that use color liberally, they might have blocks of variable definitions that looks like this:

```
BLK='\e[30m'; blk='\e[90m'; BBLK='\e[40m'; bblk='\e[100m'
RED='\e[31m'; red='\e[91m'; BRED='\e[41m'; bred='\e[101m'
GRN='\e[32m'; grn='\e[92m'; BGRN='\e[42m'; bgrn='\e[102m'
YLW='\e[33m'; ylw='\e[93m'; BYLW='\e[43m'; bylw='\e[103m'
BLU='\e[34m'; blu='\e[94m'; BBLU='\e[44m'; bblu='\e[104m'
MGN='\e[35m'; mgn='\e[95m'; BMGN='\e[45m'; bmgn='\e[105m'
CYN='\e[36m'; cyn='\e[96m'; BCYN='\e[46m'; bcyn='\e[106m'
WHT='\e[37m'; wht='\e[97m'; BWHT='\e[47m'; bwht='\e[107m'
DEF='\e[0m';  BLD='\e[1m';  UND='\e[4m'
```

This works fine, but when combining foreground, background, and formatting sequences, both the input and output are longer than they need to be:

| | Input | Output 
---|---|----
Variables | `printf "${BLD}${RED}${BBLU}"Hello!${DEF}"` | `\e[1m\e[31m\e[44mHello!\e[0m`
clr function | `printf "$(clr +rb)Hello!$(clr)"`  | `\e[1;31;44mHello!\e[m` 

The `clr()` function returns exactly one ANSI escape sequence containing all the relevant parameters each time it is called.

You might find yourself forgetting these abbreviations. "Did I use `YEL` or `YLW`? Did I use `CYA` or `CYN`?"

If you can remember what [RGB](https://en.wikipedia.org/wiki/RGB_color_model) is, and what [CMYK](https://en.wikipedia.org/wiki/CMYK_color_model) is, and that "white" starts with `w`, you already know all the color symbols you'll need in the `clr()` function. 

## Compatibility

The snippet should be safe to use in any POSIX shell.  

**Bash v4.0 or higher is required for its coloring and formatting to work** (due to `;;&` fall-through for `case`, and `${var,}`/`${var^^}` lower-case/upper-case expansions). 

It should degrade gracefully without error on incompatible shells. Your `$(clr...)` codes will simply have no effect and your script will run colorlessly. 

This is because it is wrapped with a compatibility test with a safe fallback function for incompatible shells: 

`[ ${BASH_VERSINFO[0]} -ge 4 ] && ... || clr(){ :;}`

## How does this thing work?

I've put together [a wiki page](https://github.com/rustyflavor/clr.sh/wiki/How-does-this-work%3F) explaining how this works in agonizing detail. 

## Known Issues

* This function uses an extreme, imperfect application of [Postel's Law](https://en.wikipedia.org/wiki/Robustness_principle). 
  * It does nothing to validate your input beyond discarding what it can't interpret. If you misguidedly call it with `$(clr black)` it will interpret the `b` as blue, discard `l` and `a`, interpret the `c` as cyan, figure it's done since it found two color symbols, and start spitting out blue text on cyan background. 
  * It will allow you to combine contradictory symbols, and emit a likewise contradictory escape code. `$(clr +=)` (bold, not bold) will result in the equivalently nonsensical ANSI sequence `\e[1;22m`. (From what I've seen, when terminals receive contradictory parameters they interpret it according to which comes last. I don't know if this is part of the specification, maybe the behavior varies elsewhere.) 
  * Likewise, it honors redundant formatting symbols. If you call `$(clr ++++)` you will get back `\e[1;1;1;1m`.  
