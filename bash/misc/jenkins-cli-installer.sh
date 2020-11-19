#!/bin/bash

set -e
set -o pipefail

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

url="${1}"
example="java -jar jenkins-cli.jar -s ${url}/ help"

fetch_jar(){
	{
		wget "${url}/jnlpJars/jenkins-cli.jar"
	} && {
		echo -e "${green}Downloaded jenkins-cli.jar${reset}"
	} || {
		echo -e "${red}Failed to reach Jenkins\nCheck for malformed URL"
	}
}

append_profile(){
	echo "Adding CLI to bash profile..."

	# Linux
	if [[ -n $(find ~ -name ".profile" 2>&1) ]]; then
		if [[ -s cli ]]; then
			echo "${green}CLI file populated${reset}"
			cat cli >> ~/.profile
			source ~/.profile

			echo -e "${green}CLI Appended to profile${reset}"

		else
			echo "${red}CLI file not populated${reset}"
			exit 1
		fi
 
 	# Mac
	elif [[ -n $(find ~ -name ".bash_profile" 2>&1) ]]; then
		if [[ -s cli ]]; then
			echo "${green}CLI file populated${reset}"
			cat cli >> ~/.bash_profile
			source ~/.bash_profile

			echo -e "${green}CLI Appended to profile${reset}"

	  else
			echo "${red}CLI file not populated${reset}"
			exit 1
		fi

	else
		echo -e "${red}Bash profile not found${reset}"
	fi
}


main(){
	fetch_jar
	if [[ -z $(find . -name "jenkins-cli.jar") ]]; then
		echo -e "${red}Jenkins CLI jar not installed, try again${reset}"

	else
		count=0
		echo -e "${green}Jenkins CLI jar found, testing...${reset}"

		while [[ $count -lt 3 ]]; do
			java -jar jenkins-cli.jar -s "${url}/" help &> /dev/null

			if [[ $? -eq 0 ]]; then
				echo -e "${green}CLI Test OK${reset}"
				append_profile && exit 0
			
			elif [[ $count -eq 3 ]]; then
				echo -e "${red}Retry limit reached, there appears to be an unknown issue...${reset}"
				break
 
			else 
				echo -e "${red}CLI Test unsuccessful, attempting again${reset}"
				count+=1
			fi
		done
	fi
}

main
