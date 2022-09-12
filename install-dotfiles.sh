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
	"ttyper"
	"X11"
	"gtk-2.0"
	"gtk-3.0"
	"gtk-4.0"
	"redshift"
    "copyq"
    "keepassxc"
    "fish"
    "xsessions"
    "cmus/autosave"
    "cmus/red_theme.theme"
    "cmus/notify.sh"
    "topgrade.toml"
    "neofetch"
    "chromium/Default/Extensions"
	"chromium/Default/Extension State"
    "chromium/Default/Sync Extension Settings"
    "chromium/Default/Managed Extension Settings"
    "chromium/Default/Local Extension Settings"
    "BetterDiscord/plugins"
)

REAL_HOME_DIRS=(
    ".bashrc"
)

COPY_DIRS=(
    "chromium/Default/Preferences"
    "chromium/Default/Cookies"
    "chromium/Local State"
    "tutanota-desktop/conf.json"
    "discord/settings.json"
    "FreeTube/settings.db"
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
    echo -en "$LBLUE |||$GREEN Do you want to override ${LGREEN}$1 $2 $3 $LBLUE(Y/n)? >> $NC"
    if [ ! -z $YOLO ] && [ $YOLO -eq 1 ]; then
        echo "y"
        rm -rf $1 $2 $3
        return
    fi
    read choice
    case "$choice" in 
    y|Y|"" ) rm -rf $1 $2 $3;;
    n|N ) return;;
    * ) confirm $1 $2 $3; return;;
    esac
}

mkdir -p $REAL_HOMEDIR
mkdir -p $HOMEDIR

for dir in "${LINK_HOME_DIRS[@]}"; do
    DEST="$REAL_HOMEDIR/$dir"
    if [ -h "$DEST" ]; then unlink "$DEST"; fi
    if [ -e "$DEST" ]; then confirm $DEST; fi
    mkdir -p $HOMEDIR/$dir
    ln -sfT $HOMEDIR/$dir $DEST
done


for dir in "${REAL_HOME_DIRS[@]}"; do
    FROM="$DOTFILES_DIR/dotfiles/$dir"
    DEST="$REAL_HOMEDIR/$dir"
    if [ -h "$DEST" ]; then unlink "$DEST"; fi
    if [ -e "$DEST" ]; then confirm $DEST; fi
    mkdir -p "$(dirname $DEST)"
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

for dir in "${SYMLINKS_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="$HOMEDIR/.config/$dir"
    if [ -h "$DEST" ]; then unlink "$DEST"; fi
    if [ -e "$DEST" ]; then confirm $DEST; fi
    mkdir -p "$(dirname $DEST)"
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

for dir in "${COPY_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="$HOMEDIR/.config/$dir"
    if [ -h "$DEST" ]; then unlink "$DEST"; fi
    if [ -e "$DEST" ]; then confirm $DEST; fi
    mkdir -p "$(dirname $DEST)"
	cp -rf "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

# Update nvim plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1

chmod +x $REAL_HOMEDIR/.config/awesome/run.sh
