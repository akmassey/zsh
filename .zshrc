# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.zsh_custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="akmassey"
# ZSH_THEME="random"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bundler brew brew-cask capistrano jump rbenv osx gem rails golang vundle z)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Source your Keychain.
if [ -x /usr/local/bin/keychain ]; then
  eval "$(keychain ~/.ssh/id_rsa)"
fi

# A function to repeat a shell command a specified number of times.
# http://www.stefanoforenza.com/how-to-repeat-a-shell-command-n-times/
loop () {
    n=$1
    shift
    while [ $(( n -= 1 )) -ge 0 ]
    do
        "$@"
    done
}

# Starting to find auto correct rather annoying...
unsetopt correct_all

source ~/.zsh/aliases

myfortune

export EDITOR=/usr/bin/vim

# used by git-latexdiff
export PDFVIEWER=/Applications/Skim.app/Contents/MacOS/Skim

# ensure HTML Tidy uses your configuration file
export HTML_TIDY=$HOME/.tidyrc

# rbenv configuration
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export RBENV_ROOT=/usr/local/opt/rbenv

# cd to top Finder window 
cdf() {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ]; then
    cd "$target"; pwd
  else
    echo 'No Finder window found' >&2
  fi
}

# Settings for Go Programming
# http://stackoverflow.com/questions/12843063/install-go-with-brew-and-running-the-gotour
#export GOVERSION="1.1.2"
#export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION
#export GOPATH=$(brew --prefix)/Cellar/go/$GOVERSION/bin:$HOME/src/go
export GOPATH=$HOME/src/go

# ensure Homebrew is in your PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/lib:$PATH

# Simple function for looking up documentation in Dash
function dash() {
  open "dash://$1"
}

# make and cd into a directory
function mcd() {
  mkdir -p "$1" && cd "$1";
}

# sizeup - http://brettterpstra.com/2015/01/05/sizeup-tidy-filesize-information-in-terminal/
__sizeup_build_query () {
  local bool="and"
  local query=""
  for t in $@; do
    query="$query -$bool -iname \"*.$t\""
    bool="or"
  done
  echo -n "$query"
}

__sizeup_humanize () {
  local size=$1
  if [ $size -ge 1073741824 ]; then
    printf '%6.2f%s' $(echo "scale=2;$size/1073741824"| bc) G
  elif [ $size -ge 1048576 ]; then
    printf '%6.2f%s' $(echo "scale=2;$size/1048576"| bc) M
  elif [ $size -ge 1024 ]; then
    printf '%6.2f%s' $(echo "scale=2;$size/1024"| bc) K
  else
    printf '%6.2f%s' ${size} b
  fi
}

sizeup () {
  local helpstring="Show file sizes for all files with totals\n-r\treverse sort\n-[0-3]\tlimit depth (default 4 levels, 0=unlimited)\nAdditional arguments limit by file extension\n\nUsage: sizeup [-r[0123]] ext [,ext]"
  local totalb=0
  local size output reverse OPT
  local depth="-maxdepth 4"
  OPTIND=1
  while getopts "hr0123" opt; do
    case $opt in
      r) reverse="-r " ;;
      0) depth="" ;;
      1) depth="-maxdepth 1" ;;
      2) depth="-maxdepth 2" ;;
      3) depth="-maxdepth 3" ;;
      h) echo -e $helpstring; return;;
      \?) echo "Invalid option: -$OPTARG" >&2; return 1;;
    esac
  done
  shift $((OPTIND-1))

  local cmd="find . -type f ${depth}$(__sizeup_build_query $@)"
  local counter=0
  while read -r file; do
    counter=$(( $counter+1 ))
    size=$(stat -f '%z' "$file")
    totalb=$(( $totalb+$size ))
    >&2 echo -ne $'\E[K\e[1;32m'"${counter}:"$'\e[1;31m'" $file "$'\e[0m'"("$'\e[1;31m'$size$'\e[0m'")"$'\r'
    # >&2 echo -n "$(__sizeup_humanize $totalb): $file ($size)"
    # >&2 echo -n $'\r'
    output="${output}${file#*/}*$size*$(__sizeup_humanize $size)\n"
  done < <(eval $cmd)
  >&2 echo -ne $'\r\E[K\e[0m'
  echo -e "$output"| sort -t '*' ${reverse}-nk 2 | cut -d '*' -f 1,3 | column -s '*' -t
  echo $'\e[1;33;40m'"Total: "$'\e[1;32;40m'"$(__sizeup_humanize $totalb)"$'\e[1;33;40m'" in $counter files"$'\e[0m'
}

rule () {
  _hr=$(printf "%*s" $(tput cols)) && echo ${_hr// /${1--}}
}

## Print horizontal ruler with message
rulem ()  {
  if [ $# -eq 0 ]; then
    echo "Usage: rulem MESSAGE [RULE_CHARACTER]"
    return 1
  fi
  # Fill line with ruler character ($2, default "-"), reset cursor, move 2
  # cols right, print message
  _hr=$(printf "%*s" $(tput cols)) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}

alias right="printf '%*s' $(tput cols)"
