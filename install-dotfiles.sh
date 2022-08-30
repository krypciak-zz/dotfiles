#~/bin/sh

REAL_HOMEDIR="/home/$USER1"
HOMEDIR="$REAL_HOMEDIR/home"

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
	#"Notepadqq/Notepadqq.ini"
	"redshift"
    "copyq"
    "keepassxc"
    "fish"
)

HARDLINKS_DIRS=(
	"FreeTube/settings.db"
)

HOME_DIRS=(
    ".bashrc"
    ".bash_profile"
)

LINK_HOME_DIRS=(
    ".config"
    ".local"
    "Documents"
    "Downloads"
    "Pictures"
    "Videos"
    "Programming"
    "VM"
    "Games"
    "Temp"
    "Music"
)

mkdir -p $REAL_HOMEDIR
mkdir -p $HOMEDIR


for dir in "${LINK_HOME_DIRS[@]}"; do
    mkdir -p $HOMEDIR/$dir
    ln -sf $HOMEDIR/$dir $REAL_HOMEDIR/
done


mkdir -p $REAL_HOMEDIR/.config/chromium/Default
mkdir -p $REAL_HOMEDIR/.config/FreeTube
#mkdir -p $REAL_HOMEDIR/.config/Notepadqq

for dir in "${HOME_DIRS[@]}"; do
    FROM="$DOTFILES_DIR/dotfiles/$dir"
    DEST="$REAL_HOMEDIR/$dir"
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

for dir in "${SYMLINKS_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="$REAL_HOMEDIR/.config/$dir"
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

for dir in "${HARDLINKS_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="$REAL_HOMEDIR/.config/$dir"
	ln -fT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done
