#!/bin/bash
#By Simon Bailey @newtriks
# 1) Navigates to the foremost finder window
# 2) Creates a new project defined in the passed in args from Alfred
# 3) Navigates into the new project directory
# 4) Downloads Stray's (awesome) Projects Sprouts (Robotlegs) script generators
# 5) Unpacks, moves the scripts into new project script directory then cleansup
# 6) Opens the new project in a finder window
# 7) Closes the terminal window
# 8) Displays the Project Sprout output to a Growl Notification window

scriptname="$1"
args="$2"
echo $scriptname $args
osascript <<EOD
	tell application "Finder"
    	try
    		activate
			set frontWin to folder of front window as string
			set frontWinPath to (get POSIX path of frontWin)
			tell application "Terminal"
				do script with command "cd \"" & frontWinPath & "\""
				do script with command "sprout -n $scriptname $args | pbcopy" in window 1
				do script with command "cd $args" in window 1
				do script with command "curl -L https://github.com/Stray/project-sprouts-robot-legs-bundle/tarball/master | tar zx" in window 1
				do script with command "mv Stray-project-sprouts-robot-legs-bundle-a1aaa5d/generators script" in window 1
				do script with command "rm -Rf Stray-project-sprouts-robot-legs-bundle-a1aaa5d" in window 1
				do script with command "open ." in window 1	
				do script with command "exit" in window 1			
			end tell
			set pb to (do shell script "pbpaste | fold -s")
			tell application "GrowlHelperApp"
				set the allNotificationsList to {"Project Sprouts Notification"}
				set the enabledNotificationsList to {"Project Sprouts Notification"}
				register as application "Project Sprouts AppleScript" ¬
				   all notifications allNotificationsList ¬
				   default notifications enabledNotificationsList ¬
				   icon of application "Alfred"
				notify with name "Project Sprouts Notification" ¬
				   title "Project Sprouts" ¬
				   description pb ¬
				   application name "Project Sprouts AppleScript"				
			end tell
		on error error_message
		beep
		display dialog error_message buttons ¬
			{"OK"} default button 1
 		end try
	end tell
EOD

