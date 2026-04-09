#!/usr/bin/env zsh

function stata(){
	autoload colors; colors

	flag="$1"
	for dir in *; do
		if [ -d "${dir}/.git" ]; then
			branch="$(git -C ${dir} rev-parse --abbrev-ref HEAD)"
			unstaged=( $(git -C ${dir} status -s) )
			branch_color=${fg[green]}

			if [ "${flag}" = "-a" ] || ([ "${branch}" != "main" ] && [ "${branch}" != "master" ]) || [ -n "${unstaged}" ] ; then
				if [ "${branch}" != "main" ] && [ "${branch}" != "master" ] ; then
					branch_color="${fg[red]}"
				fi
				echo -e "${dir} -- ${branch_color}${branch}${reset_color}"
				if [ "${#unstaged[@]}" -gt 0 ] ; then
					echo "\t${#unstaged[@]} unstaged changes"
				fi
			fi
		fi
	done
}
