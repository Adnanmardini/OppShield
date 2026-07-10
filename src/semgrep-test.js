const express = require("express");
const app = express();

app.get("/", (req, res) => {
    const input = req.query.code;
    eval(input);
    res.send("Done");
});
q
quit
