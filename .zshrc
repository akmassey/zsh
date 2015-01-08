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
plugins=(git bundler brew brew-cask capistrano rbenv osx gem rails golang vundle z)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Source your Keychain.
if [ -x /usr/local/bin/keychain ]; then
  eval "$(keychain ~/.ssh/id_rsa)"
fi

# Display aliases.  Please see this post for more information:
# http://stackoverflow.com/questions/9299402/echo-all-aliases-in-zsh
_-accept-line () {
    emulate -L zsh
    local -a WORDS
    WORDS=( ${(z)BUFFER} )
    # Unfortunately ${${(z)BUFFER}[1]} works only for at least two words,
    # thus I had to use additional variable WORDS here.
    local -r FIRSTWORD=${WORDS[1]}
    local -r GREEN=$'\e[32m' RESET_COLORS=$'\e[0m'
    [[ "$(whence -w $FIRSTWORD 2>/dev/null)" == "${FIRSTWORD}: alias" ]] &&
        echo -nE $'\n'"${GREEN}Executing $(whence $FIRSTWORD)${RESET_COLORS}"
    zle .accept-line
}
zle -N accept-line _-accept-line


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

# aliases for custom fortune files
alias myfortune="fortune /Users/masseya/Documents/Fortunes/akm-quotes"
alias update-myfortune="strfile /Users/masseya/Documents/Fortunes/akm-quotes /Users/masseya/Documents/Fortunes/akm-quotes.dat"
alias cl="clear"

alias l="ls -l"
alias lh="ls -lh"
alias t="todo.sh -d ~/.todo.cfg"
alias recall="history | grep --color"
alias pg="ps aux | grep --color"
alias vanilla="/usr/bin/vim -u NONE -N" # alias for vim without customization
alias map="xargs -n1"

# create an alias to pretty print homebrew dependencies
alias homebrewdeps=brew list | while read cask; do echo -n $fg[blue] $cask $fg[white]; brew deps $cask | awk '{printf(" %s ", $0)}'; echo ""; done

# clipboard preview
alias cbp='pbpaste|less'

# list only dotfiles
alias l.='ls -lGd .*'
# list only files
alias lsf="ls -l | egrep -v '^d'"
# list only directories
alias lsd="ls -ld */"

# use color with grep
alias grep='grep --color=auto'

# use this instead of Console.app
alias console='tail -40 -f /var/log/system.log'

# TODO: turn these into functions that can be tab-completed.
# aliases for opening in various applications
# alias skim="open -a Skim"
alias skim="/Applications/Skim.app/Contents/MacOS/Skim"
alias firefox="open -a Firefox"
alias safari="open -a Safari"
alias bibdesk="open -a BibDesk"

# show recently modified files
alias lt="ls -lthGr"

# show / hide hidden files in the Mac OS X Finder
alias showhidden='defaults write com.apple.finder AppleShowAllFiles True; killall Finder'
alias hidehidden='defaults write com.apple.finder AppleShowAllFiles False; killall Finder'

# open something in quick look
alias ql="qlmanage -p &>/dev/null"

# ensure downloaded attachments go to the desktop
alias mutt='cd ~/Desktop/ && mutt'

# compile LaTeX documents automatically
alias mklatex='latexmk -bibtex -pdf -pvc'
alias mkxetex='latexmk -xelatex -synctex=1 -pvc'
alias rmtexmk='latexmk -c && rmtex'

# alias enscript, mostly so that I can remember the options
alias enscript='akm-enscript'

myfortune

export EDITOR=/usr/bin/vim

# used by git-latexdiff
export PDFVIEWER=/Applications/Skim.app/Contents/MacOS/Skim

# Oh My Zsh has a function defined for R, but I would rather use that for the
# statistical language package
# unfunction R


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

# open current directory in Finder
alias f='open -a Finder ./'

# identify 10 largest files in current directory
alias ducks='du -cks *|sort -rn|head -11'

# echos path items one line at a time.
alias epath="echo $PATH | tr ':' '\n'"

# Quick way to rebuild the Launch Services database and get rid of duplicates
# in the Open With submenu.
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

# quickly grep for TODO, FIXME, etc...
alias todo='grep -r -n -e TODO -e FIXME -e XXX -e OPTIMIZE -e AKM'

# create an alias for wget to use curl
alias wget="curl -O --retry 999 --retry-max-time 0 -C -"


# Faster Navigation with Marks
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function jump { 
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark { 
    rm -i "$MARKPATH/$1"
}
function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

# and mark completions
function _completemarks {
  reply=($(ls $MARKPATH))
}

compctl -K _completemarks jump
compctl -K _completemarks unmark

alias j='jump'


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
