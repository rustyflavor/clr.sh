# Colors:  [r]ed [g]reen [b]lue [c]yan [m]agenta [y]ellow blac[k] [w]hite
#          Capital letter for bright color, @ for terminal's default color.
#          First color symbol is foreground, second is background.
#          $(clr g):Green text, $(clr Gb):Bright Green on blue.
#          To change background without affecting foreground, use a . for
#          foreground color e.g. $(clr .g) leaves fg alone and sets bg green.
# Formats: + Apply Bold,  _ Apply Underline
#          = Remove Bold, - Remove Underline (same key as apply, but unshifted)
#          Place format symbols before color symbols when combining them.

if (( BASH_VERSINFO >= 4 )); then
clr() {
    local input=$1 list=krgybmcw@ bright ground char seq index
    while char=${input::1}; (( ${#char} && ground<11 )); do
        input=${input:1}
        bright=30
        case $char in
            +) seq+=';1' ;; =) seq+=';22' ;;
            _) seq+=';4' ;; -) seq+=';24' ;;
            .) (( ground += 10 )) ;;
            [${list^^}]) bright=90 ;&
            [$list])
                index=${list%"${char,}"*}
                index=${#index}
                seq+=";$(( index<8 ? index+bright+ground : 39+ground ))"
                (( ground += 10 ))
            ;;
        esac
    done
    printf %b "\e[${seq#;}m"
}
else clr(){ :; }
fi # docs: https://github.com/rustyflavor/clr.sh
