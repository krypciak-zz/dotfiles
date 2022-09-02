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

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
NC='\033[0m' 

function confirm() {
    echo -en "$LBLUE |||$LGREEN Do you want to override ${GREEN}$1 $LBLUE(Y/n)? >> $NC"
    if [ $YOLO -eq 1 ]; then
        echo y
        rm -rf "$1"
        return
    fi
    read choice
    case "$choice" in 
    y|Y|"" ) rm -rf "$1";;
    n|N ) return;;
    * ) confirm "$1"; return;;
    esac
}

mkdir -p $REAL_HOMEDIR
mkdir -p $HOMEDIR


for dir in "${LINK_HOME_DIRS[@]}"; do
    mkdir -p $HOMEDIR/$dir
    ln -sf $HOMEDIR/$dir $REAL_HOMEDIR/
done


mkdir -p $HOMEDIR/.config/chromium/Default
mkdir -p $HOMEDIR/.config/FreeTube
#mkdir -p $REAL_HOMEDIR/.config/Notepadqq

for dir in "${HOME_DIRS[@]}"; do
    FROM="$DOTFILES_DIR/dotfiles/$dir"
    DEST="$HOMEDIR/$dir"
    if [ -f "$DEST" ]; then
        confirm $DEST
    fi
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

for dir in "${SYMLINKS_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="$HOMEDIR/.config/$dir"
    if [ -f "$DEST" ]; then
        confirm $DEST
    fi
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

# Update nvim plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1

