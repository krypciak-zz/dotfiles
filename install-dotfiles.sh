#~/bin/sh

HOMEDIR="/home/krypek"
CONFIGDIR="${HOMEDIR}/.config"

THISDIR="${CONFIGDIR}/dotfiles"

echo installing

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
	ln -i -s $THISDIR/$dir $CONFIGDIR/
done
