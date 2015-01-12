#!/bin/bash

if [ -a avaiable.list ]; then
	rm avaiable.list
fi


## print header lines
echo ""
echo " mac                 essid         frq   chn qual   lvl  enc"

while IFS= read -r line; do

    ## test line contenst and parse as required
    [[ "$line" =~ Address ]] && mac=${line##*ss: }
    [[ "$line" =~ \(Channel ]] && { chn=${line##*nel }; chn=${chn:0:$((${#chn}-1))}; }
    [[ "$line" =~ Frequen ]] && { frq=${line##*ncy:}; frq=${frq%% *}; }
    [[ "$line" =~ Quality ]] && { 
        qual=${line##*ity=}
        qual=${qual%% *}
        lvl=${line##*evel=}
        lvl=${lvl%% *}
    }
	[[ "$line" =~ IEEE ]] && iee=${line##*11.i/: }
    [[ "$line" =~ Authentica ]] && auth=${line##*(1) : }
	[[ "$line" =~ Encrypt ]] && enc=${line##*key:}
    [[ "$line" =~ ESSID ]] && {
        essid=${line##*ID:}
        echo "$mac-$essid-$frq-$chn-$qual-$lvl-$enc-$ieee-$auth"  # output after ESSID
   
	#crate listfile with mac addresses of cripted wifi 
	if [[ "$enc" == "on" ]]; then
		echo $mac >> avaiable.list;
	fi
	enc=0
	mac=0
	essid=0
	frq=0
	chn=0
	qual=0
	lvl=0
	enc=0
	ieee=0
	auth=0
	}

done
