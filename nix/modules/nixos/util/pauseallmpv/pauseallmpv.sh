#!/bin/sh

# https://github.com/LukeSmithxyz/voidrice/blob/b45fc5680674bba65e87123a3d95985766c86915/.local/bin/pauseallmpv

# You might notice all mpv commands are aliased to have this input-ipc-server
# thing. That's just for this particular command, which allows us to pause
# every single one of them with one command! This is bound to super + shift + p
# (with other things) by default and is used in some other places.

find /tmp/mpvSockets -type s -exec sh -c '
	echo "{ \"command\": [\"set_property\", \"pause\", true] }" \
		| socat - "UNIX-CONNECT:$1" >/dev/null 2>&1
' sh {} \;
