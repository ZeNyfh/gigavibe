discord command play [<string>]:
	prefixes: !
	aliases: p, youtube
	executable in: guild
	trigger:
		if arg 1 is not set:
			make embed:
				set title of embed to "❌ **You need to specify a URL or a Youtube search term.**"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		set {_a} to channel of event-member in event-guild
		if {_a} is not set:
			make embed:
				set description of embed to "❌ `You need to be in a voice channel to use this command.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		else:
			connect event-bot to voice channel of event-member
			search in youtube for arg-1 and store it in {_searchresult::*}
			add {_searchresult::1} to {track::*}
			wait 1 second
			play {track::1} in event-guild
			clear {_searchresult::*}
			make embed:
				set title of embed to "%{track::1}%"
				set title url of embed to track url of {track::1}
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
				set thumbnail of embed to track thumbnail of {track::1}
				add "Duration: `%track duration of {track::1}%`" to {_l::*}
				add "Channel: `%track author of {track::1}%`" to {_l::*}
				set description of embed to join {_l::*} with nl
			send last embed to event-channel
			clear {track::1}
			exit

on bot leave:
	clear queue of event-guild
	clear {track::*}

discord command np:
	aliases: nowplaying
	prefixes: !
	executable in: guild
	trigger:
		set {_current} to the track the bot is playing in the event-guild
		if {_current} is not set:
			make embed:
				set description of embed to "❌ `I am not playing anything.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		else:
			make embed:
				set {_42why::*} to "`🎵 Now playing:`"
				set {_42why::*} to "%{_current}%"
				set title of embed to join {_42why::*} with nl
				set title url of embed to track url of {_current}
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
				set footer icon of embed to avatar of event-member
				set thumbnail of embed to track thumbnail of {track::1}
				add "Duration: `%track duration of {_current}%`" to {_l::*}
				add "Channel: `%track author of {_current}%`" to {_l::*}
				set description of embed to join {_l::*} with nl
			send last embed to event-channel
			clear {_42why::*}
			exit

discord command voteskip:
	aliases: skip
	prefixes: !
	executable in: guild
	trigger:
		set {_a} to channel of event-member in event-guild
		if {_a} is not set:
			make embed:
				set description of embed to "❌ `You need to be in a voice channel to use this command.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		else:
			add 1 to {temp}
			set {members::*} to members in the voice channel of event-member in event-guild
			loop {members::*}:
				if loop-value is a discord bot:
					remove loop-value from {members::*}
					remove 1 from {temp}
				if loop-value is a member:
					add 1 to {temp}
			if {userid::*} contains id of event-member:
				make embed:
					set description of embed to "❌ `You have already voted to skip.`"
					set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit
			set {_temptrack} to the track the bot is playing in the event-guild
			if {_temptrack} is not set:
				make embed:
					set description of embed to "❌ `No track is playing right now.`"
					set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit
			remove 1 from {temp}
			add 1 to {votecount}
			add id of event-member to {userid::*}
			set {halfmembercount} to {temp} / 2
			set {_a} to floor({halfmembercount})
			set {halfmembercount} to {_a}
			make embed:
				set {_B::1} to "✅ `You voted to skip the current track.`"
				set footer of embed to "%{votecount}% of %{halfmembercount}% needed to skip"
				set description of embed to join {_B::*} with nl
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			clear {temp}
			if {votecount} = {halfmembercount}:
				make embed:
					set description of embed to ":fast_forward: `Skipped`"
					set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				skip track of event-guild
				clear {userid::*}
				clear {userid::*}
				clear {temp}
				clear {votecount}
				clear {temp}
				clear {userid::*}
				clear {halfmembercount}
				clear {votecount}
				wait 60 seconds
				if the bot is playing in the event-guild: # this is backwards
					disconnect bot of event-guild
				exit

discord command forceskipall:
	aliases: fsall
	prefixes: !
	executable in: guild
	trigger:
		if voice channel of event-bot in event-guild is not set:
			make embed:
				set description of embed to "❌ `I am not in a voice channel.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		if event-member has permission message manage:
			clear {queue::*}
			stop current queue of event-guild
			make embed:
				set description of embed to ":fast_forward: `Skipped all`"
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
			send last embed to event-channel
			wait 60 seconds
			if the bot is playing in the event-guild: # this is backwards
				disconnect bot of event-guild
			exit
		else:
			make embed:
				set description of embed to "❌ `Insufficient permissions.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit

discord command forceskip:
	aliases: fs
	prefixes: !
	executable in: guild
	trigger:
		if voice channel of event-bot in event-guild is not set:
			make embed:
				set description of embed to "❌ `I am not in a voice channel.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		if event-member has permission message manage:
			skip track of event-guild
			make embed:
				set description of embed to ":fast_forward: `Skipped`"
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
			send last embed to event-channel
			wait 1 second
			play {track::1} in event-guild
			wait 60 seconds
			if the bot is playing in the event-guild: # this is backwards
				disconnect bot of event-guild
			exit
		else:
			make embed:
				set description of embed to "❌ `Insufficient permissions.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit

discord command leave:
	prefixes: !
	executable in: guild
	trigger:
		if event-member has permission message manage:
			if voice channel of event-bot in event-guild is set:
				make embed:
					set description of embed to ":mailbox_with_no_mail: `Successfully disconnected.`"
					set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
					#set footer icon of embed to avatar of event-member
					set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				disconnect bot of event-guild
				clear {queue::*}
				clear {track::*}
				stop current queue of event-guild
				exit
			else:
				make embed:
					set title of embed to "I am not in a VC"
					set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit
		make embed:
			set description of embed to "❌ `Insufficient permissions.`"
			set color of embed to color from rgb 32, 34, 37
		send last embed to event-channel
		exit

discord command queue:
	prefixes: !
	aliases: q
	executable in: guild
	trigger:
		set {queue::*} to queue of event-guild
		set {_current} to the track the bot is playing in the event-guild
		if {_current} is not set:
			make embed:
				set description of embed to "❌ `There are no songs in the queue`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		else:
			clear {_B::*}
			make embed:
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
				set {_B::1} to "Songs:"
				set {_B::2} to "1.[**%{_current}%**](%track url of {_current}%)"
				set {_B::3} to "2.[%{queue::1}%](%track url of {queue::1}%)"
				set {_B::4} to "3.[%{queue::2}%](%track url of {queue::2}%)"
				set {_B::5} to "4.[%{queue::3}%](%track url of {queue::3}%)"
				set {_B::6} to "5.[%{queue::4}%](%track url of {queue::4}%)"
				set description of embed to join {_B::*} with nl
				set title of embed to "`📝 Queue`"
			send last embed to event-channel
			wait 1 seconds
			clear {_B::*}
			exit

discord command reload:
	prefixes: !
	trigger:
		if discord id of event-member is "211789389401948160":
			send "Successfully reloaded b.sk" to event-channel
			execute console command "skript reload b"
		exit

discord command help:
	aliases: cmds
	prefixes: !
	executable in: guild
	trigger:
		set {_loop} to true
		set {_linecount} to 0
		while {_loop} is true:
			add 1 to {_linecount}
			add line {_linecount} in file "plugins/helplog.txt" to {_helplist::*}
			if {_linecount} = line count of file "plugins/helplog.txt":
				set {_loop} to false
				make embed:
					set color of embed to color from rgb 32, 34, 37
					set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
					set description of embed to join {_helplist::*} with nl
					set title of embed to "`📖 Help`"
				send last embed to event-channel
				if event-member has permission message manage:
					add new button with id "custom-id1" with style danger with text "Close" to buttons of {_row}
					add new button with id "customid2" with style success with text "DJ" to buttons of {_row}
					add new button with id "customid3" with style primary with text "Admin" to buttons of {_row}

discord command clear queue:
	aliases: queue clear, clearqueue, queueclear
	prefixes: !
	executable in: guild
	trigger:
		set {_test} to id of event-member
		add "zenyfhwashere" to {dj::*}
		loop {dj::*}:
			if {_test} contains loop-value:
				clear {track::*}
				clear {queue::*}
				clear queue of event-guild
				stop queue of event-guild
				set {_tracks::*} to {_queue::*}
				remove "zenyfhwashere" from {dj::*}
				make embed:
					set color of embed to color from rgb 32, 34, 37
					set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
					set description of embed to "✅ `Cleared the queue`"
				send last embed to event-channel
				exit
			else:
				remove "zenyfhwashere" from {dj::*}
				make embed:
					set description of embed to "❌ `Insufficient permissions.`"
					set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit

discord command whitelist <text>:
	prefixes: !
	executable in: guild
	trigger:
		if {blockeddj::*} contains discord id of event-member:
			make embed:
				set description of embed to "❌ `Insufficient permissions.`"
				set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit
		else:
			set {cancer1} to arg-1 parsed as member
			if {blockeddj::*} contains {cancer1}:
				remove {cancer1} from {blockeddj::*}
				make embed:
					set description of embed to "✅ `whitelisted %{cancer1}%.`"
					set color of embed to color from rgb 32, 34, 37
					send last embed to event-channel
			else:
				make embed:
					set description of embed to "❌ `This person is not blacklisted.`"
					set color of embed to color from rgb 32, 34, 37
					send last embed to event-channel
				exit

discord command clear blacklist:
	prefixes: !
	executable in: guild
	trigger:
		if {blockeddj::*} contains discord id of event-member:
			make embed:
				set description of embed to "❌ `Insufficient permissions.`"
				set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit
		if event-member has permission message manage:
			clear {blockeddj::*}
			make embed:
				set description of embed to "✅ `cleared the blacklist`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		else:
			make embed:
				set description of embed to "❌ `Insufficient permissions.`"
				set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit


discord command blacklist [<text>]:
	prefixes: !
	executable in: guild
	trigger:
		if arg-1 is not set:
			make embed:
				set description of embed to join {blockeddj::*} with nl
				set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
			exit
		else:
			set {_a} to arg-1 parsed as member
			set {blockeddj::*} to id of discord entity {_a}
			make embed:
				set description of embed to "✅ `blacklisted %{_a}%`"
				set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
			exit

discord command skiptrack [<number>]:
	prefixes: !
	executable in: guild
	trigger:
		send "%arg-1%" to event-channel
		send "%{track::arg-1}%" to event-channel
		clear {track::arg-1}
		send "%{track::arg-1}%" to event-channel
		if arg-1 is not set:
			make embed:
				set description of embed to "❌ `No argument given.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		else: 
			if {blockeddj::*} contains discord id of event-member:
				make embed:
					set description of embed to "❌ `Insufficient permissions.`"
					set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit

on track start seen by "Gigavibe":
	set {_tempid} to {track::1}
	if {_tempid} is {trackid}:
		skip track of event-guild
	else:
		exit

discord command dj [<text>]:
	prefixes: !
	executable in: guild
	trigger:
		if {blockeddj::*} contains discord id of event-member:
			make embed:
				set description of embed to "❌ `Insufficient permissions.`"
				set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit
		if arg-1 is "list":
			make embed:
				set color of embed to color from rgb 32, 34, 37
				set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
				set description of embed to join {dj::*} with nl
				set title of embed to "`DJs`"
			send last embed to event-channel
			exit
		set {_parse} to discord name of arg-1 parsed as role
		if event-member does not have permission message manage:
			make embed:
				set description of embed to "❌ `Insufficient permissions.`"
				set color of embed to color from rgb 32, 34, 37
			send last embed to event-channel
			exit
		else:
			if {_parse} is not set:
				make embed:
					set description of embed to "❌ `The argument given was not a role.`"
					set color of embed to color from rgb 32, 34, 37
				send last embed to event-channel
				exit
			if {dj::*} is not set:
				add arg-1 to {dj::*}
				make embed:
					set color of embed to color from rgb 32, 34, 37
					set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
					set description of embed to "✅ `added {%{_parse}%} to DJs`"
				send last embed to event-channel
				exit
			if {dj::*} is set:
				if {dj::*} does not contain arg-1:
					add arg-1 to {dj::*}
					make embed:
						set color of embed to color from rgb 32, 34, 37
						set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
						set description of embed to "✅ `added {%{_parse}%} to DJs`"
					send last embed to event-channel
					exit
				else:
					remove arg-1 from {dj::*}
					make embed:
						set color of embed to color from rgb 32, 34, 37
						set footer of embed to "Executed by %discord name of event-member%##%discord tag of event-member%"
						set description of embed to "✅ `removed {%{_parse}%} from DJs`"
					send last embed to event-channel
					exit

on load:
	clear {check}
	exit

discord command tts <text>:
	prefixes: !
	executable in: guild
	trigger:
		if {check} is set:
			send "The bot is already talking, try again soon." to event-channel
			exit
		else:
			set {_vc} to voice channel of event-member
			set {check} to true
			set {_limiter} to arg 1
			if length of {_limiter} > 500:
				send "The character limit is 500" to event-channel
				exit
			if arg-1 contains "'''":
				clear {check}
				send "illegal character: **'''**, not sending message" to event-channel
				exit
			if {_vc} is not set:
				send "get in a voice channel before using tts." to event-channel
				clear {check}
				exit
			else:
				set line 1 in file "plugins/PyTTS.pyw" to "text = '''%arg-1%'''"
				run batch cmd "C:\Users\david\Desktop\code_stuff\discordbot\plugins\a.bat"
				wait 1 second
				load locale track from "plugins/TTS.mp3" and store it in {_fuckyou}
				set {_vc} to voice channel of event-member
				if {_vc} is not set:
					send "get in a voice channel before using tts." to event-channel
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
					exit

on track end seen by "Gigavibe":
	wait 60 seconds
	if the bot is playing in the event-guild: # this is backwards
		disconnect bot of event-guild
		clear {track::*}
		clear {queue::*}
		clear queue of event-guild
		exit

on track end seen by "Gigavibe":
	clear {userid::*}
	clear {track::1}
	wait 1 second
	if {track::1} is set:
		play {track::1} in event-guild
		exit

discord command ping:
	prefixes: !
	executable in: guild
	trigger:
		set {_unixtime} to unix timestamp of now
		send message "." to event-channel and store it in {_temp}
		set {_unixtime2} to unix timestamp of now
		delete discord entity {_temp}
		subtract {_unixtime} from {_unixtime2}
		send "ping: %{_unixtime2}*1000%ms" to event-channel
		exit

on load:
	clear {token}

command /startb:
	trigger:
		if {token} is set:
			send message "I am already running" to the console
			exit
		else:
			login to {tokenvibe} with name "Gigavibe"
			execute console command "save-all"
			exit
