clr_demo () {
  local example examples
  examples=(
'echo "$(clr _)Underline$(clr)"'
'echo "$(clr +)Bold$(clr)"'
'echo "$(clr +_)Bold Underline$(clr)"'
'echo "$(clr +_g)Bold Underline Green$(clr)"'
'echo "$(clr +_G)Bold Underline Bright Green$(clr)"'
'echo "$(clr Gb)Bright Green on Dark Blue$(clr)"'
'echo "$(clr gB)Dark Green on Bright Blue$(clr)"'
'echo "$(clr G)Bright Green with $(clr +)two words$(clr =) in bold$(clr)"'
'echo "$(clr cb)Cyan on Blue with $(clr G)a span$(clr c) of bright green text$(clr)"'
'echo "$(clr cb)Cyan on Blue with $(clr .B)a span$(clr .b) of bright blue background$(clr)"'
  )
printf "\nExamples: \n\n"
for example in "${examples[@]}"; do
   printf "$ %s\n" "$example"
   eval "$example"
   echo
done
}
clr_tables() {
  local format desc bg fg code colors=( r R y Y g G b B c C m M k K w W . @)
  for format in '' + _ _+; do
    case $format in
      '') desc="Normal Text";;
      +)  desc="Bold";;
      _)  desc="Underline";;
      _+) desc="Bold Underline";;
    esac
    printf "\n%s:\n" "$desc"
    for bg in "${colors[@]}"; do
      [[ "$bg" = "." ]] && continue
      for fg in "${colors[@]}"; do
        code="${format}${fg}${bg}"
        printf "%b %4s %b" "$(clr $code)" "$code" "$(clr)"
      done
      echo
    done
    [[ "$format" != "_+" ]] && { echo; read -p "More? [Y/n]: " reply; }
    [[ -z "$reply" || "${reply,,}" == "y" ]] || return
  done
echo
}
