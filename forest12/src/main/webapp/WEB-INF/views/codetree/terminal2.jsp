<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/codetree/terminal2.css">
<link href='https://fonts.googleapis.com/css?family=Source+Code+Pro:200' rel='stylesheet' type='text/css'>

<script>
var email = '${authUser.email}';
var nickname = '${authUser.nickname}';

$(document).ready(function() {
	"use strict";
	// UTILITY
	function getRandomInt(min, max) {
			return Math.floor(Math.random() * (max - min)) + min;
	}
	// END UTILITY
	// COMMANDS
	function clear() {
			terminal.text("");
	}
	function help() {
			terminal.append("There is no help... MUAHAHAHAHA. >:D\n");
	}
	function echo(args) {
			var str = args.join(" ");
			terminal.append(str + "\n");
	}
	function fortune() {
			var xhr = new XMLHttpRequest();
			xhr.open('GET', 'https://cdn.rawgit.com/bmc/fortunes/master/fortunes', false);
			xhr.send(null);
			if (xhr.status === 200) {
					var fortunes = xhr.responseText.split("%");
					var fortune = fortunes[getRandomInt(0, fortunes.length)].trim();
					terminal.append(fortune + "\n");
			}
	}
	// END COMMANDS
	var title = $(".title");
	var terminal = $(".terminal");
	var prompt = "->";
	var path = "~";
	var commandHistory = [];
	var historyIndex = 0;
	var command = "";
	var commands = [{
					"name": "clear",
					"function": clear
			}, {
					"name": "help",
					"function": help
			}, {
					"name": "fortune",
					"function": fortune
			}, {
					"name": "echo",
					"function": echo
			}];
function processCommand() {
	var isValid = false;
	// Create args list by splitting the command
	// by space characters and then shift off the
	// actual command.
	var args = command.split(" ");
	var cmd = args[0];
	args.shift();
	// Iterate through the available commands to find a match.
	// Then call that command and pass in any arguments.
	for (var i = 0; i < commands.length; i++) {
			if (cmd === commands[i].name) {
					commands[i].function(args);
					isValid = true;
					break;
			}
	}
	// No match was found...
	if (!isValid) {
			terminal.append(nickname + ": command not found: " + command + "\n");
	}
	// Add to command history and clean up.
	commandHistory.push(command);
	historyIndex = commandHistory.length;
	command = "";
}
function displayPrompt() {
	terminal.append("<span class=\"prompt\">" + prompt + "</span> ");
	terminal.append("<span class=\"path\">" + path + "</span> ");
}
//Delete n number of characters from the end of our output
function erase(n) {
	command = command.slice(0, -n);
	terminal.html(terminal.html().slice(0, -n));
}
function clearCommand() {
	if (command.length > 0) {
			erase(command.length);
	}
}
function appendCommand(str) {
	terminal.append(str);
	command += str;
}
/*
//	Keypress doesn't catch special keys,
//	so we catch the backspace here and
//	prevent it from navigating to the previous
//	page. We also handle arrow keys for command history.
*/
$(document).keydown(function(e) {
	if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA") {
		e = e || window.event;
		var keyCode = typeof e.which === "number" ? e.which : e.keyCode;
		// BACKSPACE
		if (keyCode === 8 && e.target.tagName !== "INPUT" && e.target.tagName !== "TEXTAREA") {
				e.preventDefault();
				if (command !== "") {
						erase(1);
				}
		}
		// UP or DOWN
		if (keyCode === 38 || keyCode === 40) {
				// Move up or down the history
				if (keyCode === 38) {
						// UP
						historyIndex--;
						if (historyIndex < 0) {
								historyIndex++;
						}
				} else if (keyCode === 40) {
						// DOWN
						historyIndex++;
						if (historyIndex > commandHistory.length - 1) {
								historyIndex--;
						}
				}
				// Get command
				var cmd = commandHistory[historyIndex];
				if (cmd !== undefined) {
						clearCommand();
						appendCommand(cmd);
				}
		}
		$('.window').scrollTop($('.window').prop('scrollHeight'));
	}
});
$(document).keypress(function(e) {
	if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA") {		
		// Make sure we get the right event
		e = e || window.event;
		var keyCode = typeof e.which === "number" ? e.which : e.keyCode;
		// Which key was pressed?
		switch (keyCode) {
				// ENTER
				case 13:
						{
								terminal.append("\n");
								processCommand();
								displayPrompt();
								if($('.theme option:selected').parent().attr('label') == "white") {
									   $(".window .terminal .prompt").css('color', "#004000");
									   $(".window .terminal .path").css('color', "#1f0d98");
								   }
								   else {
									   $(".prompt").css('color', "#bde371");
									   $(".path").css('color', "#5ed7ff");
								   }
								break;
						}
				default:
						{
								appendCommand(String.fromCharCode(keyCode));
						}
		}
		$('.terminal').scrollTop($('.terminal').prop('scrollHeight'));
	}
});
//Set the window title
title.text(email +": ~ ("+nickname+")");
//Get the date for our fake last-login
var date = new Date().toString(); date = date.substr(0, date.indexOf("GMT") - 1);
//Display last-login and promt
terminal.append("Last login: " + date + " on ttys000\n"); displayPrompt();
});
</script>

<div class="window" id="window">
		<div class="handle">
				<div class="buttons">
						<button class="close">
						</button>
						<button class="minimize">
						</button>
						<button class="maximize">
						</button>
				</div>
				<span class="title"></span>
		</div>
		<div class="terminal"></div>
</div>

