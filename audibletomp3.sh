#! /bin/bash -e
tmpfilef=$(mktemp /tmp/audibletomp3.XXXXXX)
$(ls / > /tmp/audibletomp3.XXXXXX)
cleanup () {
  rm /tmp/audibletomp3.XXXXXX
}
trap cleanup EXIT
start_audible () {
clear && printf '\e[3J'
echo " █████╗ ██╗   ██╗██████╗ ██╗██████╗ ██╗     ███████╗    ████████╗ ██████╗     ███╗   ███╗██████╗ ██████╗ ";
echo "██╔══██╗██║   ██║██╔══██╗██║██╔══██╗██║     ██╔════╝    ╚══██╔══╝██╔═══██╗    ████╗ ████║██╔══██╗╚════██╗";
echo "███████║██║   ██║██║  ██║██║██████╔╝██║     █████╗         ██║   ██║   ██║    ██╔████╔██║██████╔╝ █████╔╝";
echo "██╔══██║██║   ██║██║  ██║██║██╔══██╗██║     ██╔══╝         ██║   ██║   ██║    ██║╚██╔╝██║██╔═══╝  ╚═══██╗";
echo "██║  ██║╚██████╔╝██████╔╝██║██████╔╝███████╗███████╗       ██║   ╚██████╔╝    ██║ ╚═╝ ██║██║     ██████╔╝";
echo "╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝╚═════╝ ╚══════╝╚══════╝       ╚═╝    ╚═════╝     ╚═╝     ╚═╝╚═╝     ╚═════╝ ";
printf '%.s─' $(seq 1 $(tput cols))
}
get_activebit () {
IPb=$(curl -s https://aax.api.j-kit.me/api/v1/activation/$1)
echo "$IPb"
}
get_checkbit () {
IPb1=$(od --address-radix=none --read-bytes=20 --skip-bytes=0x28d --format=x1 --endian=big --width=20 "$1" | tr -d ' ')
echo "$IPb1"
}
option_1 () {
  echo "Select Option:"
echo "1. Install Dependencies"
echo "2. Convert File"
echo "3. Exit"
echo " "
echo "© Allancoding"
}
list_files_aax () {
  $(find /home /mnt -name *.aax -print > /tmp/audibletomp3.XXXXXX)
  ffnum=1
  ffnumf=$(wc -l /tmp/audibletomp3.XXXXXX | awk '{ print $1 }')
  if [ $ffnumf = 0 ] 
		then
		echo "No file was found!"
		sleep 4
		start_audible
		option_1
		option_1_r 0
		else
			echo "Select A File:"
			for (( i=0; i<$ffnumf; i++))
			do
    		echo $ffnum". - "$(sed -n $ffnum'p' /tmp/audibletomp3.XXXXXX)
			ffnum=$(($ffnum+1))
			done
			echo "All. - Convert All the files above."
			option_3_r $(($ffnumf + 1))
		fi
}
option_3_r () {
read OPTION3
if [ $OPTION3 = "All" ]
then
ffnumy=1
fnumf=$(($1-1))
resbit2=()
resbit2+=('all')
resbit2+=($fnumf)
for (( i=0; i<$fnumf; i++))
do
local resbit0=$(get_checkbit "$(sed -n $ffnumy'p' /tmp/audibletomp3.XXXXXX)")
local resbit=$(get_activebit $resbit0)
resbit2+=($ffnumy)
resbit2+=($resbit)
ffnumy=$(($ffnumy+1))
done
start_audible
option_4
option_4_r "${resbit2[@]}"
else
	if [ $OPTION3 -lt $1 ]
then
	if [ $OPTION3 -gt 0 ]
	then
		local resbit0=$(get_checkbit "$(sed -n $OPTION3'p' /tmp/audibletomp3.XXXXXX)")
local resbit=$(get_activebit $resbit0)
resbit2=()
resbit2+=('one')
resbit2+=($OPTION3)
resbit2+=($resbit)
start_audible
option_4
option_4_r "${resbit2[@]}"
	else
echo "Not a valid option"
option_3_r $1
	fi
else
echo "Not a valid option"
option_3_r $1
fi
fi
}
option_2 () {
  echo "Select Option:"
echo "1. Install On Arch Based"
echo "2. Install On Debian Based"
echo "3. Return"
echo "4. Exit"
}
option_4 () {
  echo "Select Format:"
echo "1. mp3"
echo "2. wav"
echo "3. m4a"
echo "4. Exit"
}
option_5 () {
  echo "Select Method:"
echo "1. Convert to one big file"
echo "2. Convert into Chapters"
echo "3. Convert into Time sections"
echo "4. Exit"
}
option_6 () {
  echo "Cut Every?:"
echo "1. 5m"
echo "2. 10m"
echo "3. 30m"
echo "4. 1h"
echo "5. Custom (in seconds)"
echo "6. Exit"
}
option_1_r () {
if [ $1 = 1 ]
then
echo $2
fi
read OPTION
if [ $OPTION -lt 4 ]
then
	if [ $OPTION -gt 0 ]
	then
		if [ $OPTION = 1 ]
		then
		start_audible
		option_2
		option_2_r
		fi
		if [ $OPTION = 2 ]
		then
		list_files_aax
		fi
		if [ $OPTION = 3 ]
		then
		echo "Exit!"
		exit 1
		fi
	else
echo "Not a valid option"
option_1_r 0
	fi
else
echo "Not a valid option"
option_1_r 0
fi
}
option_2_r () {
read OPTION1
if [ $OPTION1 -lt 5 ]
then
	if [ $OPTION1 -gt 0 ]
	then
		if [ $OPTION1 = 1 ]
		then
		echo "Install ffmpeg and jq"
		yes | sudo pacman -Syu
		yes | sudo pacman -S ffmpeg jq
		sleep 2
		start_audible
		option_1
		option_1_r 1 "--Done installing ffmpeg and jq--"
		fi
		if [ $OPTION1 = 2 ]
		then
		echo "Install ffmpeg and jq"
		sudo apt-get update
		sudo apt-get -y install ffmpeg jq
		sleep 2
		start_audible
		option_1
		option_1_r 1 "--Done installing ffmpeg and jq--"
		fi
		if [ $OPTION1 = 3 ]
		then
		start_audible
		option_1
		option_1_r 0
		fi
		if [ $OPTION1 = 4 ]
		then
		echo "Exit!"
		exit 1
		fi
	else
echo "Not a valid option"
option_2_r
	fi
else
echo "Not a valid option"
option_2_r
fi
}
function option_4_r () {
s1n=("$@")
read OPTION4
if [ $OPTION4 -lt 5 ]
then
	if [ $OPTION4 -gt 0 ]
	then
		if [ $OPTION4 = 1 ]
		then
		start_audible
		option_5
		option_5_r "${s1n[@]}" "mp3"
		fi
		if [ $OPTION4 = 2 ]
		then
		start_audible
		option_5
		option_5_r "${s1n[@]}" "wav"
		fi
		if [ $OPTION4 = 3 ]
		then
		start_audible
		option_5
		option_5_r "${s1n[@]}" "m4a"
		fi
		if [ $OPTION4 = 4 ]
		then
		echo "Exit!"
		exit 1
		fi
	else
echo "Not a valid option"
option_4_r "${s1n[@]}"
	fi
else
echo "Not a valid option"
option_4_r "${s1n[@]}"
fi
}
function option_5_r () {
s1n=("$@")
read OPTION5
if [ $OPTION5 -lt 5 ]
then
	if [ $OPTION5 -gt 0 ]
	then
		if [ $OPTION5 = 1 ]
		then
		start_audible
		run_ffmpeg "${s1n[@]}" "o"
		fi
		if [ $OPTION5 = 2 ]
		then
		start_audible
		run_ffmpeg "${s1n[@]}" "c"
		fi
		if [ $OPTION5 = 3 ]
		then
		start_audible
		option_6
		option_6_r "${s1n[@]}" "t"
		fi
		if [ $OPTION5 = 4 ]
		then
		echo "Exit!"
		exit 1
		fi
	else
echo "Not a valid option"
option_5_r "${s1n[@]}" $2
	fi
else
echo "Not a valid option"
option_5_r "${s1n[@]}" $2
fi
}
function run_ffmpeg (){
if [ $1 = "one" ]
then
fline=$2
factive=$3
ftype=$4
fme=$5
elif [ $1 = "all" ]
then
fnum=$2
f1=3
f2=4
	for (( i=0; i<$fnum; i++))
	do
	ffnum=$(($i + 1))
	ff1="fline$ffnum"
	ff2="factive$ffnum"
	eval $ff1='$'"${f1}"
	eval $ff2='$'"${f2}"
	f1=$(($f1+2))
	f2=$(($f2+2))
	done
f2=$(($f2+1))
eval ftype='$'"${f2}"
f2=$(($f2+1))
eval fme='$'"${f2}"
ffmpeg=""
	for (( i=0; i<$fnum; i++))
	do
	ffnum=$(($i + 1))
	ff1='$'"fline$ffnum"
	ff2='$'"factive$ffnum"
	eval ffline=$ff1
	eval ffactive=$ff2
	ffline="$ffline"
	ffactive="$ffactive"
	fffile="$(sed -n $ffline'p' /tmp/audibletomp3.XXXXXX)"
	fffile="'$fffile'"
	tmpfilef2=$(mktemp /tmp/audibletomp3.FXXXXX)
	thejsonffname="$(ffprobe -v quiet -show_chapters -print_format json -show_format $fffile | jq '.format.tags.title'
)"
echo "$thejsonffname"
	ffmpeg="ffmpeg -activation_bytes $ffactive -i $fffile -c copy /tmp/audibletomp3.FXXXXX.mp4 && ffmpeg -activation_bytes $ffactive -i /tmp/audibletomp3.FXXXXX.mp4 -vn /tmp/audibletomp3.FXXXXX.mp3 && rm /tmp/audibletomp3.FXXXXX.mp4 && mkdir audibletomp3 && mv /tmp/audibletomp3.FXXXXX.mp3 audibletomp3/'$thejsonffname.mp3'"
	done
	echo "$ffmpeg"
fi
}
function option_6_r () {
s1n=("$@")
read OPTION6
if [ $OPTION6 -lt 7 ]
then
	if [ $OPTION6 -gt 0 ]
	then
		if [ $OPTION6 = 1 ]
		then
		start_audible
		run_ffmpeg "${s1n[@]}" 5
		fi
		if [ $OPTION6 = 2 ]
		then
		start_audible
		run_ffmpeg "${s1n[@]}" 10
		fi
		if [ $OPTION6 = 3 ]
		then
		start_audible
		run_ffmpeg "${s1n[@]}" 30
		fi
		if [ $OPTION6 = 4 ]
		then
		start_audible
		run_ffmpeg "${s1n[@]}" 1
		fi
		if [ $OPTION6 = 5 ]
		then
		echo "Custom in seconds (min. - 1/max. 5000)"
		read OPTION7
		if [ $OPTION7 -lt 5000 ]
		then
			if [ $OPTION7 -gt 0 ]
			then
				start_audible
				run_ffmpeg "${s1n[@]}" $OPTION7
			else
			start_audible
			option_6
			option_6_r "${s1n[@]}"
			fi
		else
		start_audible
		option_6
		option_6_r "${s1n[@]}"
		fi
		fi
		if [ $OPTION6 = 6 ]
		then
		echo "Exit!"
		exit 1
		fi
	else
echo "Not a valid option"
option_6_r
	fi
else
echo "Not a valid option"
option_6_r
fi
}
start_audible
option_1
option_1_r 0