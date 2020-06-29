// Run by Node.js

console.log('asdf');
const readline = require("readline");
const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout
});

rl.on("line", function(line) {
	console.log("Hello Goorm! Your input is", line);
	rl.close();
}).on("close", function() {
	process.exit();
});