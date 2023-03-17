# clr.sh
clr.sh: ANSI coloring function for bash scripts, absurdly minified

## What's This? 

clr.sh is a file containing a highly-minified bash function that you can source from your script, or paste within your script. 

It will allow you to use all 16 foreground and background colors in all 256 combinations of the standard 4-bit ANSI color palette. It also supports bold text and underlines. 

It is designed to have a very brief syntax that will avoid bulking up your strings of colored text. 

Here is a picture of it in action:

![Example Image](https://raw.githubusercontent.com/rustyflavor/clr.sh/main/images/clr_examples.png)

Here is a table of the supported color combinations and the codes that represent them:

![Color Table](https://raw.githubusercontent.com/rustyflavor/clr.sh/main/images/clr_table.png)

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
