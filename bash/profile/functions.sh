alias gs='git status -s'
alias gc='git commit'
alias reload='source ~/.profile'

increase_swap(){
    cd / ; sudo swapoff -a
    sudo dd if=/dev/zero of=swapfile bs=1M count=3072 oflag=append conv=notrunc
    sudo mkswap swapfile
    sudo swapon swapfile
    sudo swapon -a
}

ssh () {
    local success=false
    local wait=false

    if [[ -z $1 ]]; then
        return
    fi

    if (nc -vz "$1" 22 &> /dev/null); then
        local success=true
    else
        local wait=true
        echo "Waiting for port to open..."
    fi

    while [[ "$success" == false ]]; do
        if (nc -vz "$1" 22 &> /dev/null); then
            echo "Port open!"
            local success=true
        else
            sleep 10
        fi
    done

    if [[ "$wait" == true ]]; then
        echo "Connecting to $1 ..."
    fi

    if [[ "$success" = true ]]; then
        command ssh $@
    fi
}

git () {
    if [[ $1  == "pull" ]]; then
            command git fetch -p && command git pull

    elif [[ $1 == "checkout" ]]; then
            command git $@;
            if [[ ! "$2" =~ ^_ ]]; then
                    if (command git stash list | grep -q "$2"); then
                            echo -e "\033[32mFound stash for this branch\033[39m"
                    fi
            fi
    else
            command git $@
    fi
}

universal_unzip(){
    if [ $# -eq 0 ]; then
            echo -n "filename> "
            read filename
    else
            filename=$1
    fi

    if [ ! -f "$filename" ]; then
            echo "No such file: $filename"
            exit $?
    fi

    case $filename in
            *.tar)      tar -xvf $filename;;
            *.tar.bz2)  tar -xvjf $filename;;
            *.tbz)      tar -xvjf $filename;;
            *.tbz2)     tar -xvjf $filename;;
            *.tgz)      tar -xvzf $filename;;
            *.tar.gz)   tar -xvzf $filename;;
            *.gz)       gunzip -v $filename;;
            *.bz2)      bunzip2 -v $filename;;
            *.zip)      unzip -v $filename;;
            *.Z)        uncompress -v $filename;;
            *)          echo "No extract option for $filename"
    esac
}

# Normal Colors
Black='\e[0;30m'
Red='\e[0;31m'
Green='\e[0;32m'
Yellow='\e[0;33m'
Blue='\e[0;34m'
Purple='\e[0;35m'
Cyan='\e[0;36m'
White='\e[0;37m'
