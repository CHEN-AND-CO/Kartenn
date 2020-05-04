db = db.getSiblingDB('admin');

if (kartUser === undefined) {
    var kartUser = "Kartenn";
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