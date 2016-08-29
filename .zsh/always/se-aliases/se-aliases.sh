# Search Engine Aliases
# by W. Caleb McDaniel and Lincoln Mullen, 2012

# The idea for this was suggested by Lincoln Mullen's post on
# configuring Chrome for specific search engines. I source this file 
# in my bashrc, and then use DTerm or the Terminal to quickly search. 
# This method makes Mullen's ideas browser-independent. Mullen also
# suggested some changes to the functions that make these work in any
# Unix environment too. Feel free to fork and use however you see fit.
#
# For more context, see:
# http://chronicle.com/blogs/profhacker/how-to-hack-urls-for-faster-searches-in-your-browser/42304


# To prepare plain-text queries for URLs, use python.
# http://ruslanspivak.com/2010/06/02/urlencode-and-urldecode-from-a-command-line/

alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

# Your academic library probably has a proxy system. For example, to 
# access JSTOR through Brandeis University's libraries, the url
#      http://www.jstor.org/
# becomes http://www.jstor.org.resources.library.brandeis.edu/
# Fill in the variable below with the value of your proxy. Using the 
# example above:
#      myproxy='.resources.library.brandeis.edu'
#  Then in the # search functions which you want to run through the 
#  library proxy, add the following:
#     http://www.jstor.org$myproxy/
# If you don't have a library proxy, leave the string empty:
# 	  myproxy=''
# Even the searches which other users have provided will still work
# without a proxy.

myproxy='.ezproxy.rice.edu'
umbcproxy='https://proxy-bc.researchport.umd.edu/login?url='

# Different OSes have different commands for opening a URL in a browser 
# from a command line. Change the alias below to the proper command for 
# your OS. The default 'open' works on Macs. On Ubuntu the command would 
# be 'gnome-open' instead. You could also use this alias to change the 
# browser that opened the URL. And if you wished to change the flags for 
# the open command, you could do it in one place by changing the alias.

alias searchopen='open'


# If you want to see a list of all the search engines available using
# these functions, this alias allows you to type "searchlist" at the
# command-line. You'll also need to set the SEPATH variable to
# the location of this file on your computer.

SEPATH=$HOME/.zsh/se-aliases/se-aliases.sh
alias searchlist="awk '/^function/ {print \$2}' $SEPATH | sort" 

# Use these at the command line by typing the function's name and the
# query. Queries with more than one word should be enclosed in double
# quotes. Literal quotes can be added to queries with the escape slash.
#
# E.g.
#
# scholar abolitionists
# scholar "American abolitionists"
# scholar "\"American abolitionists\""

seusage() {
cat << EOF

By default, you are running a keyword search. 
Some options may be available, depending on your search engine.

Help:

  -v			Verbose; show this message before searching
  -o			Sort by date (oldest first)
  -n			Sort by date (newest first)
  -i			Sort by interesting (Flickr only)
  -t			Search in "title" field

Note: Use backslash escapes for literal quotes.

Examples:

  scholar abolitionists
  scholar "American abolitionists"
  poth -td "\"Texas Republican\""
EOF
}

seoptions()
{
  oldfirst=;title=;newfirst=;interesting=;OPTIND=1;
  while getopts "vonit" OPTION; do
    case "$OPTION" in
      v)
        seusage
        ;;
      n)
        newfirst=1
        ;;
      o)
        oldfirst=1
        ;;
      t)
        title=1
        ;;
      i)  
        interesting=1
        ;;
    esac;
  done
}

scholar()
{
  seoptions "$@"
  scholarsearch="https://scholar.google.com/scholar?hl=en&q=$(urlencode "${@: -1}")"
  searchopen "$umbcproxy$scholarsearch"
}

books()
{
  seoptions "$@"
  searchopen "https://books.google.com/books?hl=en&q=$(urlencode "${@: -1}")"
}

# Searches for media type "texts" in archive.org
archiveorg()
{
  seoptions "$@"
  searchopen "https://archive.org/search.php?query=$(urlencode "${@: -1}")%20AND%20mediatype%3Atexts"
}

images()
{
  seoptions "$@"
  searchopen "https://images.google.com/images?q=$(urlencode "${@: -1}")"
}

jstor()
{
  seoptions "$@"
  jstorsearch="https://www.jstor.org/action/doBasicSearch?Query=$(urlencode "${@: -1}")"
  searchopen "$umbcproxy$jstorsearch"
}

clio()
{
  seoptions "$@"
  cliosearch="https://web.ebscohost.com/ehost/results?&bquery=$(urlencode "${@: -1}")&bdata=JmRiPWFobCZ0eXBlPTAmc2l0ZT1laG9zdC1saXZlJnNjb3BlPXNpdGU%3d"
  searchopen "$umbcproxy$cliosearch"
}

anb()
{
  seoptions "$@"
  anbsearch="https://www.anb.org/articles/asearch.html?which_index=both&meta-dc=10&func=simple_search&field-Name=$(urlencode "${@: -1}")&Login=Quick+Search"
  searchopen "$umbcproxy$anbsearch"
}

amazon()
{
  seoptions "$@"
  searchopen "https://www.amazon.com/s/?url=search-alias%3Daps&field-keywords=$(urlencode "${@: -1}")"
}

imdb()
{
  seoptions "$@"
  searchopen "https://www.imdb.com/find?q=$(urlencode "${@: -1}")&s=all"
}

nerdquery()
{
  seoptions "$@"
  searchopen "https://nerdquery.com/?media_only=0&query=$(urlencode "${@: -1}")&search=1&category=-1"
}

spanish()
{
  seoptions "$@"
  searchopen "https://translate.google.com/#en/es/$(urlencode "${@: -1}")"
}

english()
{
  seoptions "$@"
  searchopen "https://translate.google.com/#es/en/$(urlencode "${@: -1}")"
}

wikipedia()
{
  seoptions "$@"
  searchopen "https://en.wikipedia.org/w/index.php?search=$(urlencode "${@: -1}")"
}

# Search Flickr for Creative Commons pictures
# https://yubnub.org/kernel/man?args=fliccr
flickr()
{
  seoptions "$@"
  searchopen "https://flickr.com/search/?q=$(urlencode "${@: -1}")&l=cc&ss=1&ct=6$(if [ -n "$newfirst" ]; then echo "&s=rec";fi)$(if [ -n "$interesting" ]; then echo "&s=int"; fi)"
}

youtube()
{
  seoptions "$@"
  searchopen "https://www.youtube.com/results?search_query=$(urlencode "${@: -1}")"
}

# Note: Handbook of Texas Online uses %20 instead of + for spaces
hotx()
{
  seoptions "$@"
  searchopen "https://www.tshaonline.org/search/node/$(echo "${@: -1}" | sed 's/ /%20/g')"
}

poth()
{
  seoptions "$@"
  searchopen "https://texashistory.unt.edu/search/?q=$(urlencode "${@: -1}")$(if [ -n "$oldfirst" ]; then echo "&sort=date_a";fi)$(if [ -n "$title" ]; then echo "&t=dc_title"; fi)"
}

stackoverflow()
{
  seoptions "$@"
  searchopen "https://stackoverflow.com/search?q=$(urlencode "${@: -1}")"
}

superuser()
{
  seoptions "$@"
  searchopen "https://superuser.com/search?q=$(urlencode "${@: -1}")"
}

hoogle()
{
  seoptions "$@"
  searchopen "http://www.haskell.org/hoogle/?hoogle=$(urlencode "${@: -1}")"
}

# Digital Humanities Questions and Answers
dhqa()
{
    seoptions "$@"
    searchopen "https://digitalhumanities.org/answers/search.php?q=$(urlencode "${@:-1}")"
}

wikipedia()
{
  seoptions "$@"
  searchopen "https://en.wikipedia.org/wiki/Special:Search?search=$(urlencode "${@: -1}")"
}

# Bookfinder for book price comparison
bookfinder()
{
  seoptions "$@"
  searchopen "https://www.bookfinder.com/search/?keywords=$(urlencode "${@: -1}")&st=xl&ac=qr&src=opensearch"
}

oed()
{
  seoptions "$@"
  oedsearch="https://www.oed.com/search?searchType=dictionary&q=$(urlencode "${@: -1}")&_searchBtn=Search"
  searchopen "$umbcproxy$oedsearch"
}

onelook()
{
  seoptions "$@"
  searchopen "https://www.onelook.com/?w=$(urlencode "${@: -1}")&ls=a"
}

# Library of Congress catalog
lcongress()
{
  seoptions "$@"
  searchopen "https://catalog.loc.gov/vwebv/search?searchArg=$(urlencode "${@: -1}")&searchCode=GKEY%5E*&searchType=0&recCount=100&sk=en_US"
}

# Amazon Video on Demand
vod()
{
  seoptions "$@"
  searchopen "https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Damazontv&field-keywords=$(urlencode "${@: -1}")&x=0&y=0"
}

profhacker()
{
  seoptions "$@"
  profhackersearch="https://chronicle.com/search/?contextId=5&searchQueryString=$(urlencode "${@: -1}")&facetName%5B0%5D=content&facetName%5B1%5D=blog&facetValue%5B0%5D=blogPost&facetValue%5B1%5D=27&facetCaption%5B0%5D=Blog+Post&facetCaption%5B1%5D=ProfHacker&omni_mfs=true"
  searchopen "$umbcproxy$profhackersearch"
}


google()
{
  seoptions "$@"
  searchopen "https://www.google.com/search?q=$(urlencode "${@: -1}")"
}

#Christian Classics Ethereal Library
ccel()
{
  seoptions "$@"
  searchopen "https://www.ccel.org/search?qu=$(urlencode "${@: -1}")"
}

cnet()
{
  seoptions "$@"
  searchopen "https://cnet.com/1770-5_1-0-{startPage?}.html?query=$(urlencode "${@: -1}")&tag=opensearch"
}

# ESV Bible
esv()
{
  seoptions "$@"
  searchopen "https://www.esvbible.org/search/$(urlencode "${@: -1}")/"
}

# WordPress codex
wordpress()
{
  seoptions "$@"
  searchopen "https://wordpress.org/search/do-search.php?search=$(urlencode "${@: -1}")"
}

# Replace 'umbc' in the URL with your own library, or with 'www'
worldcat()
{
  seoptions "$@"
  worldcatsearch="https://umbc.worldcat.org/search?q=$(urlencode "${@: -1}")"
  searchopen "$umbcproxy$worldcatsearch"
}

docsouth()
{
  seoptions "$@"
  searchopen "https://www.googlesyndicatedsearch.com/u/docsouth?q=$(urlencode "${@: -1}")&sa=Search"
}

# The following search engines are probably useful only to the author.
# You can delete to the end of the file without breaking anything.

# Search my own bookmarks on Pinboard
pins()
{
  seoptions "$@"
  searchopen "https://pinboard.in/search/?query=$(urlencode "${@: -1}")&mine=Search+Mine"
}

# This is the engine for the Rice University library's OneSearch tool.
# It may not work universally.
ebsco()
{
  seoptions "$@"
  searchopen "https://ehis.ebscohost.com/eds/results?bquery=$(urlencode "${@: -1}")&bdata=JnR5cGU9MCZzaXRlPWVkcy1saXZlJnNjb3BlPXNpdGU%3d"
}

# UMBC online directory
umbcdir()
{
  seoptions "$@"
  searchopen "https://www.umbc.edu/search/directory/?search=$(urlencode "${@: -1}")"
}

