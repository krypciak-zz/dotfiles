#~/bin/sh

#HOMEDIR="/home/krypek"
#CONFIGDIR="${HOMEDIR}/.config"

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CONFIG_DIRS=(  "awesome"
	"nvim"
	"zsh"
	"alacritty"
	"qt5ct"
	"strawberry"
	"ttyper"
	"FreeTube"
	"X11"
	"chromium/Default/Extensions"
	"chromium/Default/Extension State"
	"gtk-2.0"
	"gtk-3.0"
	"gtk-4.0"
)

for dir in "${CONFIG_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="/home/$USER1/.config/$dir"
	ln -sfT "$FROM" "$DEST"
	chown $USER1:$USER1 "$DEST"
done



