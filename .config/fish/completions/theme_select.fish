# ng help

for theme in $HOME/bin/themes/*
	set theme_name (basename -s .cfg $theme)
	complete -f -c theme_select.sh  -a "$theme_name" -d "Chose the $theme_name theme"
end
