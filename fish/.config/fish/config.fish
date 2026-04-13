set fish_greeting

#
# ENVIRONMENT VARIABLES
#

set -xg VISUAL nvim
set -xg EDITOR nvim		     # prefer neovim as text editor
set -xg PYTHONDONTWRITEBYTECODE 1    # do not produce .pyc/.pyo files
set -xg CLICOLOR 1                   # turn on colors for some BSD tools
set -xg LESS "FRX"

fish_config theme choose nord

#
# SETUP PROMPT WITH BLACKJACK AND HOOKERS
#

if type -q starship
  starship init fish | source
end


#
# SOURCE EXTRA CONFIGURATIONS
#

for name in config.{$hostname,local}.fish
  if test -e $__fish_config_dir/$name
    source $__fish_config_dir/$name
  end
end
