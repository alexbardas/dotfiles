export PATH="/usr/local/sbin:$PATH"

# Load our dotfiles like ~/.bash_prompt, etc…
for file in ~/.{bash_prompt,exports,aliases,bash_preexec,bash_z,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

# bash completion.
if  which brew &> /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

if command -v gdircolors >/dev/null 2>&1; then
    eval "$(gdircolors -b ~/.dircolors)"
else
    eval "$(dircolors -b ~/.dircolors)"
fi;

##
## better `cd`'ing
##

shopt -s cmdhist        # Save all lines of a multiple-line command in the same history entry
shopt -s nocaseglob     # Case-insensitive globbing (used in pathname expansion)
shopt -s cdspell        # Autocorrect typos in path names when using `cd`
shopt -s no_empty_cmd_completion # Do not attempt to search the PATH for possible completions when completion is attempted on an empty line

