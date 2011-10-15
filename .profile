. ./.login
#if $CS && [ -f `which amixer` ] && aplay -L | grep -i card; then
#	amixer -c0 sset Front 0dB > /dev/null		# Set the volume to max
#fi

#stty erase 

#if ! xhost > /dev/null 2>&1; then
#	$SHELL && exit
#fi

PATH=$PATH:/home/raedwulf/bin/RTaW-Sim-1.1.1/bin;export PATH; # ADDED BY INSTALLER - DO NOT EDIT OR DELETE THIS COMMENT - RealTime-At-Work RTaW-Sim 1.1.1.0 7FB03BAE-BB7D-5C27-ADCF-1A00F64EF810
