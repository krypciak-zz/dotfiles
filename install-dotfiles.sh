#~/bin/sh

#HOMEDIR="/home/krypek"
#CONFIGDIR="${HOMEDIR}/.config"

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SYMLINKS_DIRS=( 
	"awesome"
	"nvim"
	"zsh"
	"alacritty"
	"qt5ct"
	"strawberry"
	"ttyper"
	"X11"
	"chromium/Default/Extensions"
	"chromium/Default/Extension State"
	"gtk-2.0"
	"gtk-3.0"
	"gtk-4.0"
	"Notepadqq/Notepadqq.ini"
	"redshift"
    "copyq"
)

HARDLINKS_DIRS=(
	"FreeTube/settings.db"
)

mkdir -p /home/$USER1/.config/chromium/Default
mkdir -p /home/$USER1/.config/FreeTube

for dir in "${SYMLINKS_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="/home/$USER1/.config/$dir"
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

for dir in "${HARDLINKS_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="/home/$USER1/.config/$dir"
	ln -fT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done
