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

`$(clr.sh string)`

Called without a string as `$(clr)` will result in the reset code clearing all formatting. 

`string` is comprised of the following symbols:

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

To change the color of the background without changing the foreground, use the `.` dot character as the foreground symbol.  
(e.g. `$(clr .g)` will change the background to green without changing the foreground.) 

The function finishes as soon as it recognizes a second valid color symbol. Excess input will be discarded. (This is why formatting symbols should be placed first.)

The @ symbol represents the terminal's default foreground and background colors. (ANSI `\e[39m` and `\e[49m`)

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

## Compatability

This function requires bash v4.0 or higher. (Due to `;;&` fall-through for `case`, and `${var,}`/`${var^^}` lower-case/upper-case expansions.) 

## How does this thing work?

Coming soon, an annotated walkthrough of how this function works. 

Here is the function when expanded and formatted by using bash's `type` builtin:

```
$ type clr
clr is a function
clr ()
{
    ( local i=$1 l=krgybmcw@ b g c s;
    function n ()
    {
        x=${l%"${1,}"*};
        x=${#x};
        ((x<8&&(x+=b+g)||(x=39+g)));
        printf %d $x
    };
    while c=${i::1};
    [ "$c" ] && ((g<11)); do
        i=${i:1};
        b=30;
        case $c in
            +)
                s+=";1"
            ;;
            =)
                s+=";22"
            ;;
            _)
                s+=";4"
            ;;
            -)
                s+=";24"
            ;;
            .)
                ((g+=10))
            ;;
            [${l^^}])
                b=90
            ;;&
            [${l^^}] | [$l])
                s+=";$(n "$c")";
                ((g+=10))
            ;;
        esac;
    done;
    printf %b "\e[${s#;}m" )
}
```
