##
## Boxes
##

function box_blue() {
  tput bold
  tput setaf 4
  echo "[ $@ ]"
  tput sgr 0
}

function box_green() {
  #tput bold
  tput setaf 2
  echo "[ `date +"%F %T"` - $@ ]"
  tput sgr0
}

function box_yellow() {
  #tput bold
  tput setaf 3
  echo "[ `date +"%F %T"` - $@ ]"
  tput sgr0
}

function box_red() {
  #tput bold
  tput setaf 1
  echo "[ `date +"%F %T"` - $@ ]"
  tput sgr0
}
