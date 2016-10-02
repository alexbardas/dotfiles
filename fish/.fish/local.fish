set -gx PATH /usr/local/sbin /usr/local/bin $PATH
set -gx EDITOR vim

set -gx LS_COLORS (gdircolors -c ~/.dircolors | string replace -r 'setenv LS_COLORS \'(.*)\'' '$1')

set -x FZF_DEFAULT_COMMAND 'ag -g ""'
set -x FZF_DEFAULT_OPTS '--ansi --inline-info'

alias g 'git'

if test (uname) = "Linux"
  alias ls     'ls --color=auto'
  alias dir    'dir --color=auto'
  alias vdir   'vdir --color=auto'
else
  if command -s gls > /dev/null
    alias ls     'gls --color=auto'
  end

  if command -s gdir > /dev/null
    alias dir    'gdir --color=auto'
  end

  if command -s gvdir > /dev/null
    alias vdir   'gvdir --color=auto'
  end
end

