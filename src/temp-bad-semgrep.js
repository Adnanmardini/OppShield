const { exec } = require('child_process');

// Command injection - unsanitized input passed directly to exec
function runUserCommand(userInput) {
  exec(`ls ${userInput}`, (err, stdout) => {
    console.log(stdout);
  });
}

module.exports = { runUserCommand };
