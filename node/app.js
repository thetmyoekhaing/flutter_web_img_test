const express = require("express");
const multer = require("multer");
const path = require("path");

const app = express();
const port = 3000;

const storage = multer.diskStorage({
    destination: "./uploads/",
    filename: function (req, file, callback) {
        callback(
            null,
            file.fieldname +
                "-" +
                Date.now() +
                path.extname(file.originalname) +
                ".jpg",
        );
    },
});

const upload = multer({ storage });

app.use(express.static("flutter_app_build_folder"));

app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
    res.setHeader(
        "Access-Control-Allow-Headers",
        "Content-Type, Authorization",
    );
    next();
});

app.post("/upload", upload.single("image"), (req, res) => {
    console.log("Image uploaded:", req.file);
    res.status(200).send("Image uploaded successfully");
});

app.listen(port, () => {
    console.log(`Server is listening on port ${port}`);
});
