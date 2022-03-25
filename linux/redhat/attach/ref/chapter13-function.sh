NumToWord () {
 case $1 in
  1)
   echo one
  ;;
  2)
   echo two
  ;;
  3)
   echo Three
  ;;
 esac
}

echo "Number $(NumToWord "$1")"
echo "$(NumToWord "$1") dollar(S)"
