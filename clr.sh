# Colors:  [r]ed [g]reen [b]lue [c]yan [m]agenta [y]ellow blac[k] [w]hite
#          Capital letter for bright color, @ for terminal's default color.
#          First color symbol is foreground, second is background.
#          $(clr g):Green text, $(clr Gb):Bright Green on blue.
#          To change background without affecting foreground, use a . for
#          foreground color e.g. $(clr .g) leaves fg alone and sets bg green.
# Formats: + Apply Bold,  _ Apply Underline
#          = Remove Bold, - Remove Underline (same key as apply, but unshifted)
#          Place format symbols before color symbols when combining them.

[ ${BASH_VERSINFO[0]} -ge 4 ]&&clr(){ local i=$1 l=krgybmcw@ b g c s
while c=${i::1};[ "$c" ]&&((g<11));do i=${i:1};b=30;case $c in +)s+=";1";;
=)s+=";22";;_)s+=";4";;-)s+=";24";;.)((g+=10));;[${l^^}])b=90;;&
[${l^^}]|[$l])s+=";$(x=${l%"${c,}"*};x=${#x};((x<8&&(x+=b+g)||(x=39+g)));
printf %d $x)";((g+=10));esac;done;printf %b "\e[${s#;}m";}||
clr(){ :;} # docs: https://github.com/rustyflavor/clr.sh
