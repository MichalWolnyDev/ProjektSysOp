#!/bin/bash
#Projekt zaliczeniowy - Skrypt pobierajacy tapety z internetu, z serwisu Unsplash - Michał Wolny K35.2

#funkcja sprawdzajaca czy podana paczka jest zainstalowana
TEMPNAME=""
isPackageInstalled() {

	dpkg --status $1 &> /dev/null
	if [ $? -eq 0 ]; then
	echo "$1: jest juz zainstalowane"
	else
	apt-get install -y $1
	fi
}

nameGenerator() {

	name=''
	name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
	
	echo "$name"
}
setWallpaper() {
	URI="file:///home/${1}/${2}.jpg"
	echo "essa ${URI}"
	temp="/home/${1}/${2}.jpg"
	
	if [ -f "$temp" ]; then
	
	echo "$temp istnieje"
	gsettings set org.gnome.desktop.background picture-uri "${URI}"
	
	echo "tapeta ustawiona"
	fi
	
}

downloadWallpaper() {
	
	
	filename=$(nameGenerator)
	
	mkdir -p /home/$4
			
		
	wget -O /home/$4/$filename.jpg https://source.unsplash.com/$1x$2/?$3
	
	chmod 777 /home/$4/$filename.jpg
	#gsettings set org.gnome.desktop.background picture-uri file:///home/$4/$filename.jpg
	
	echo "$filename"
	#setWallpaper $4 dupa
	#sleep 5
	#mv /home/$4/wallpaper.jpg /home/$4/$filename.jpg
}


if [ "$(id -u)" != "0" ] ; then
	echo "Musisz uruchomic ten skrypt jako root" 1>&2
	exit 1
fi
echo "Wspaniale, uruchomiles skrypt jako root :)"

#sprawdzenie rozdzielczosci
width=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
height=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

#aktualna data
now="$(date +'%m-%d-%Y')"


isPackageInstalled wget
isPackageInstalled grep

#menu jakie chce tapety

echo "Dzisiaj jest $now"
menu='Co Ciebie najbardziej interesuje?'
options=("Natura" "Motoryzacja" "Miasta" "Kobiety" "Wyjscie")

echo $menu
select opt in "${options[@]}"
do
	case $opt in
		"Natura")
			echo "wybrales opcje 1"
			TEMPNAME=$(downloadWallpaper $width $height nature $now)
			echo "dupa $TEMPNAME"
			sleep 5
			setWallpaper $now $TEMPNAME
			
			;;
		"Motoryzacja")
			echo "wybrales opcje 2"
			downloadWallpaper $width $height cars $now
			;;
		"Miasta")
			echo "wybrales opcje 3"
			downloadWallpaper $width $height city $now
			;;
		"Kobiety")
			echo "wybrales opcje 4"
			downloadWallpaper $width $height woman $now
			;;
		"Wyjscie")
			break
			;;
		*) echo "Niepoprawny wybor";;
	esac
done
