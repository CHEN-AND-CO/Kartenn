const { connect } = require('mongodb')
const { argv } = require('process')


let db = connect("localhost");

db = db.getSiblingDB('admin');

let kartUser = argv[2];
let kartPassword = argv[3];

if (kartUser === undefined) {
    kartUser = "Kartenn";
}

db.createUser(
    {
        user: "admin",
        pwd: passwordPrompt(),
        roles: ["root"]
    }
);

if (kartPassword === undefined) {
    db.createUser(
        {
            user: kartUser,
            pwd: passwordPrompt(),
            roles: [{ role: "readWrite", db: "kartenn_api" }],
            mechanisms: ["SCRAM-SHA-256"]
        }
    );
} else {
    db.createUser(
        {
            user: kartUser,
            pwd: kartPassword,
            roles: [{ role: "readWrite", db: "kartenn_api" }],
            mechanisms: ["SCRAM-SHA-256"]
        }
    );
}