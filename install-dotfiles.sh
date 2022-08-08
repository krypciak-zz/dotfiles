#~/bin/sh

#HOMEDIR="/home/krypek"
#CONFIGDIR="${HOMEDIR}/.config"

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CONFIG_DIRS=( 
	"awesome"
	"nvim"
	"zsh"
	"alacritty"
	"qt5ct"
	"strawberry"
	"ttyper"
	"FreeTube/settings.db"
	"X11"
	"chromium/Default/Extensions"
	"chromium/Default/Extension State"
	"gtk-2.0"
	"gtk-3.0"
	"gtk-4.0"
	"Notepadqq/Notepadqq.ini"
)

mkdir -p /home/$USER1/.config/chromium/Default
mkdir -p /home/$USER1/.config/FreeTube

for dir in "${CONFIG_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="/home/$USER1/.config/$dir"
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done



