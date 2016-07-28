# Powerline
# No archlinux pacman -S powerline powerline-fonts 
# habilitar p xfce-terminal com suporte a 256 cores 
# https://bbs.archlinux.org/viewtopic.php?id=175581
if [ -f `which powerline-daemon` ]; then
	powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1
	. /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh
		      
	   fi
alias ls="ls --color"	
