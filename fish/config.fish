set fish_greeting (set_color red; curl -m 2 -sS http://quotes.rest/qod.json | jq '.contents.quotes[0].quote,.contents.quotes[0].author'; set_color normal)
set -gx TERM screen-256color-bce

source ~/.fish/cmd_time.fish
source ~/.fish/local.fish
source ~/.fish/prompt.fish
