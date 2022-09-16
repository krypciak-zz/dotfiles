#~/bin/sh

USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SYMLINKS_DIRS=( 
	"at_login.sh"
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
# If path starts with %, will not override
# If path starts with #, dest path will be in .local/share
COPY_DIRS=(
    "chromium/Default/Preferences"
	"%chromium/Default/Cookies"
    "chromium/Local State"
    "chromium-flags.conf"
	"tutanota-desktop/conf.json"
	"discord/settings.json"
	"FreeTube/settings.db"
    "#multimc/multimc.cfg"
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

mkdir -p $USER_HOME
mkdir -p $FAKE_USER_HOME

for dir in "${LINK_HOME_DIRS[@]}"; do
	DEST="$USER_HOME/$dir"
	if [ -h "$DEST" ]; then unlink "$DEST"; fi
	if [ -e "$DEST" ]; then confirm $DEST; fi
	mkdir -p $FAKE_USER_HOME/$dir
	ln -sfT $FAKE_USER_HOME/$dir $DEST
done


for dir in "${REAL_HOME_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="$USER_HOME/$dir"
	if [ -h "$DEST" ]; then unlink "$DEST"; fi
	if [ -e "$DEST" ]; then confirm $DEST; fi
	mkdir -p "$(dirname $DEST | head --lines 1)"
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

for dir in "${SYMLINKS_DIRS[@]}"; do
	FROM="$DOTFILES_DIR/dotfiles/$dir"
	DEST="$FAKE_USER_HOME/.config/$dir"
	if [ -h "$DEST" ]; then unlink "$DEST"; fi
	if [ -e "$DEST" ]; then confirm $DEST; fi
	mkdir -p "$(dirname $DEST | head --lines 1)"
	ln -sfT "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done

for dir in "${COPY_DIRS[@]}"; do
    if [[ $dir = %* ]]; then
		dir="${dir:1}"
		FROM="$DOTFILES_DIR/dotfiles/$dir"
		DEST="$FAKE_USER_HOME/.config/$dir"
		if [ ! -e "$DEST" ]; then
			cp -rf "$FROM" "$DEST"
		fi
	else
		FROM="$DOTFILES_DIR/dotfiles/$dir"
		DEST="$FAKE_USER_HOME/.config/$dir"
        if [[ $dir = \#* ]]; then
            dir="${dir:1}"
		    FROM="$DOTFILES_DIR/dotfiles/$dir"
            DEST="$FAKE_USER_HOME/.local/share/$dir"
        fi
		if [ -h "$DEST" ]; then unlink "$DEST"; fi
		if [ -e "$DEST" ]; then confirm $DEST; fi
		mkdir -p "$(dirname $DEST | head --lines 1)"
		cp -rf "$FROM" "$DEST"
		chown -R $USER1:$USER1 "$DEST"
	fi
done



ESCAPED_USER_HOME=$(printf '%s\n' "$USER_HOME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" $USER_HOME/.local/share/multimc/multimc.cfg
ESCAPED_HOSTNAME=$(printf '%s\n' "$(hostname)" | sed -e 's/[\/&]/\\&/g')
sed -i "s/HOSTNAME/$ESCAPED_HOSTNAME/g" $USER_HOME/.local/share/multimc/multimc.cfg

chmod +x $USER_HOME/.config/awesome/run/run.sh
chmod +x $USER_HOME/.config/at_login.sh


# Update nvim plugins
#nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1
