set fish_greeting

#
# ENVIRONMENT VARIABLES
#

set -xp PATH ~/.local/bin       # scripts installed by pip (python)
set -xp PATH ~/.cargo/bin       # binaries installed by cargo (rust)

set -xg EDITOR nvim		     # prefer neovim as text editor
set -xg BROWSER firefox              # prefer firefox as default browser
set -xg TERMINAL tilix               # preder tilix as default terminal
set -xg PYTHONDONTWRITEBYTECODE 1    # do not produce .pyc/.pyo files
set -xg CLICOLOR 1                   # turn on colors for some BSD tools
set -xg GPG_TTY (tty)                # setup tty for gpg2's pinetry

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
