# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

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
ZSH_CUSTOM=$HOME/zsh_custom

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
