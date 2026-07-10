const { exec } = require("child_process");

function runCommand(userInput) {
    exec(userInput);
}

module.exports = runCommand;
