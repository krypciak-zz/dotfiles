#~/bin/sh

#HOMEDIR="/home/krypek"
#CONFIGDIR="${HOMEDIR}/.config"

#THISDIR="${CONFIGDIR}/dotfiles"

dirs=(  "awesome"
	"nvim"
	"zsh"
	"alacritty"
	"qt5ct"
	"strawberry"
	"ttyper"
	"FreeTube"
	"X11"
)

for dir in ${dirs[@]}; do
	ln -i -s $DOTFILES_DIR/$dir /home/$USER1/.config/
done
