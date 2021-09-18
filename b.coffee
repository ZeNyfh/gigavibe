discord command soundcloud [<string>]: # this does not work for some reason
	prefixes: $
	aliases: sc
	trigger:
		if arg 1 is not set:
			make embed:
				set title of embed to "❌ **You need to specify a URL or a SoundCloud search term.**"
				set color of embed to color from rgb 32, 34, 37
			reply with last embed
			exit
		connect event-bot to voice channel of event-member
		wait 1 second
		set {_a} to channel of event-bot in event-guild
		if {_a} is not set:
			make embed:
				set description of embed to "❌ `You need to be in a voice channel to use this command.`"
				set color of embed to color from rgb 32, 34, 37
			reply with last embed
			exit
		else:
			connect event-bot to voice channel of event-member
			search in soundcloud for arg-1 and store it in {track::*}
			wait 1 second
			play {track::1} in event-guild
			make embed:
				set title of embed to "%{track::1}%"
				set title url of embed to track url of {track::1}
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
				set footer icon of embed to avatar of event-member
				set thumbnail of embed to track thumbnail of {track::1}
				add "Duration: `%track duration of {track::1}%`" to {_l::*}
				add "Channel: `%track author of {track::1}%`" to {_l::*}
				set description of embed to join {_l::*} with nl
			reply with last embed
			exit

discord command play [<string>]:
	prefixes: $
	aliases: p
	trigger:
		if arg 1 is not set:
			make embed:
				set title of embed to "❌ **You need to specify a URL or a Youtube search term.**"
				set color of embed to color from rgb 32, 34, 37
			reply with last embed
			exit
		connect event-bot to voice channel of event-member
		wait 1 second
		set {_a} to channel of event-bot in event-guild
		if {_a} is not set:
			make embed:
				set description of embed to "❌ `You need to be in a voice channel to use this command.`"
				set color of embed to color from rgb 32, 34, 37
			reply with last embed
			exit
		else:
			connect event-bot to voice channel of event-member
			search in youtube for arg-1 and store it in {track::*}
			wait 1 second
			play {track::1} in event-guild
			make embed:
				set title of embed to "%{track::1}%"
				set title url of embed to track url of {track::1}
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
				set footer icon of embed to avatar of event-member
				set thumbnail of embed to track thumbnail of {track::1}
				add "Duration: `%track duration of {track::1}%`" to {_l::*}
				add "Channel: `%track author of {track::1}%`" to {_l::*}
				set description of embed to join {_l::*} with nl
			reply with last embed
			exit

discord command np:
	aliases: nowplaying
	prefixes: $
	executable in: guild
	trigger:
		if {track::1} is not set:
			reply with "I am not currently playing anything!"
			clear {track::*}
			exit
		else:
			make embed:
				add "`🎵 Now playing:`" to {_42why::*}
				add "%{_track}%" to {_42why::*}
				set title of embed to join {_42why::*} with nl
				set title url of embed to track url of {track::1}
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
				set footer icon of embed to avatar of event-member
				set thumbnail of embed to track thumbnail of {track::1}
				add "Duration: `%track duration of {track::1}%`" to {_l::*}
				add "Channel: `%track author of {track::1}%`" to {_l::*}
				set description of embed to join {_l::*} with nl
			reply with last embed
			clear {track::1}
			exit

discord command forceskip:
	aliases: fs
	prefixes: $
	executable in: guild
	trigger:
		if voice channel of event-bot in event-guild is not set:
			make embed:
				set description of embed to "❌ `I am not in a voice channel.`"
				set color of embed to color from rgb 32, 34, 37
			reply with last embed
			exit
		if event-member has permission message manage:
			skip track of event-guild
			make embed:
				set description of embed to ":fast_forward: `Skipped`"
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
			reply with last embed
			wait 1 second
			play {track::1} in event-guild
			exit
		else:
			make embed:
				set description of embed to "❌ `Insufficient permissions.`"
				set color of embed to color from rgb 32, 34, 37
			reply with last embed
			exit

discord command leave:
	prefixes: $
	executable in: guild
	trigger:
		if event-member has permission message manage:
			if voice channel of event-bot in event-guild is set:
				make embed:
					set description of embed to ":mailbox_with_no_mail: `Successfully disconnected.`"
					set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
					#set footer icon of embed to avatar of event-member
					set color of embed to color from rgb 32, 34, 37
				reply with last embed
				disconnect bot of event-guild
				clear {track::*}
				clear {queue::*}
				clear queue of event-guild
				set {_tracks::*} to {_queue::*}
				exit
			else:
				make embed:
					set title of embed to "I am not in a VC"
					set color of embed to color from rgb 32, 34, 37
				reply with last embed
				exit
		make embed:
			set description of embed to "❌ `Insufficient permissions.`"
			set color of embed to color from rgb 32, 34, 37
		reply with last embed
		exit

discord command queue:
	prefixes: $
	aliases: q
	trigger:
		if {track::1} is not set:
			reply with "there are no songs in the queue" # temporary, i couldnt be asked to make an embed
			exit
		else:
			set {queue::*} to queue of event-guild
			make embed:
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
				set {_B::1} to "Songs:"
				add "•**%{track::1}%**" to {_B::*}
				add "•%{queue::2}%" to {_B::*}
				add "•%{queue::3}%" to {_B::*}
				add "•%{queue::4}%" to {_B::*}
				add "•%{queue::5}%" to {_B::*}
				set description of embed to join {_B::*} with nl
				set title of embed to "`📝 Queue`"
			reply with last embed
			wait 1 seconds
			clear {queue::*}
			clear {_B::*}
			clear {_queue::*}
			clear queue of event-guild
			clear {track::*}
			set {track::*} to 0
			exit

discord command reload:
	prefixes: $
	trigger:
		reply with "Successfully reloaded b.sk"
		execute console command "skript reload b"
		exit

discord command help:
	prefixes: $
	executable in: guild
	trigger:
		set {_loop} to true
		set {_linecount} to 0
		while {_loop} is true:
			add 1 to {_linecount}
			if line {_linecount} in file "plugins/skript/scripts/b.sk" contains "discord command":
				add line {_linecount} in file "plugins/skript/scripts/b.sk" to {_helplist::*}
				if {_linecount} = line count of file "plugins/skript/scripts/b.sk":
					set {_loop} to false
					exit 1 loop
					set {_helplist2::*} to {_helplist::*}
					loop {_helplist2::*}:
						regex split {_helplist2::*} using "\W* command \W*"
						if loop-value contains "discord command":
							remove "discord command" from {_helplist2::*}
						if loop-value is not set:
							remove "discord command" from {_helplist2::*}
						if {_helplist2::*} does not contain "discord command":
							exit 1 loop
							make embed:
								set color of embed to color from rgb 32, 34, 37
								set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
								set description of embed to join {_helplist2::*} with nl
								set title of embed to "`📖 Help`"
							reply with last embed
							exit # this does not work currently
						
discord command fixtts:
	prefixes: $
	executable in: guild
	trigger:
		clear {check}
		reply with "ok, fixed that"
		exit

on load:
	clear {check}
	exit

discord command tts <text>:
	prefixes: $
	executable in: guild
	trigger:
		if {check} is set:
			reply with "The bot is already talking, try again soon."
			exit
		else:
			set {_vc} to voice channel of event-member
			set {check} to true
			set {_limiter} to arg 1
			if length of {_limiter} > 500:
				reply with "The character limit is 500"
				exit
			if arg-1 contains """":
				clear {check}
				reply with "illegal character: **""**, not sending message"
				exit
			if arg-1 contains "<":
				clear {check}
				reply with "illegal character: **<**, not sending message"
				exit
			if {_vc} is not set:
				reply with "get in a voice channel before using tts."
				clear {check}
				exit
			else:
				set line 1 in file "plugins/PyTTS.py" to "text = ""%event-member% says, %arg-1%""" # replace VBS with python for linux compatibility
				run batch cmd "C:\Users\david\Desktop\code_stuff\discordbot\plugins\a.bat"
				wait 1 second
				load locale track from "plugins/TTS.mp3" and store it in {_fuckyou}
				set {_vc} to voice channel of event-member
				if {_vc} is not set:
					reply with "get in a voice channel before using tts."
					clear {check}
					exit
				else:
					connect event-bot to voice channel of event-member
					play {_fuckyou} in event-guild
					wait 1 second
					delete file "plugins/TTS.mp3"
					clear {_fuckyou}
					clear {_test}
					clear {check}
					reply with "%event-member%: %arg-1%"
					exit

discord command queuedebug:
	prefixes: $
	trigger:
		set {_tracks::*} to {_queue::*}
		exit

on track end seen by "Gigavibe":
	skip track of event-guild
	wait 1 second
	if {track::1} is set:
		play {track::1} in event-guild
	wait 60 seconds
	if the bot is playing in the event-guild: # this is backwards
		disconnect bot of event-guild
		clear {track::*}
		clear {queue::*}
		clear queue of event-guild
		exit

discord command ping: 
	prefixes: $
	executable in: guild
	trigger:
		set {_unixtime} to unix timestamp of now
		send message "." to event-channel and store it in {_temp}
		set {_unixtime2} to unix timestamp of now
		delete discord entity {_temp}
		subtract {_unixtime} from {_unixtime2}
		reply with "ping: %{_unixtime2}*1000%ms"
		exit

command /startb:
	trigger:
		set {token} to "ODc5NTI3Mzg5NzExOTkwNzg1.YSRBtg.D8MXrkTB61EZxENa_TUFHzM8-9o"
		login to "ODc5NTI3Mzg5NzExOTkwNzg1.YSRBtg.D8MXrkTB61EZxENa_TUFHzM8-9o" with name "Gigavibe"
		execute console command "save-all"
		exit