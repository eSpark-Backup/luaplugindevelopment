// Rest api in depth using POSTMAN

const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const mongoDB = 'mongoDB://localhost:27017/cars_api'
mongoose.connect(mongoDB, {userNewUrlParcer: true, useunifiedTopology: true});

const db = mongoose.connection
db.on('error', console.error.bind(console, 'MongoDB connection error:'))

const carSchema = new mongoose.Schema({
    name: String,
    model: number,
    age: number
})

const app = express();

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

const port = 4567;

const cars = [
  { name: "LC300", model: 2023 },
  { name: "Vitz", model: 2003 },
  { name: "Cultus", model: 2020 },
  { name: "Civic", model: 2022 },
];

app.get("/", (req, res) => {
  res.json(cars);
});

app.get("/cars/:id", (req, res) => {
  res.json(cars[parseInt(req.params.id) - 1]);
});

app.post("/cars", (req, res) => {
  console.log(req.body);
  res.json({ message: "ok" });
});

app.put("/cars/:id", (req, res) => {
  console.log(req.params.id);
  console.log(req. body)
  res.json({ message: `updating cars info ${req.params.id}` });
});

app.delete("/cars/:id", (req, res) => {
  console.log(req.params.id);
  res.json({ message: `deleting cars info ${req.params.id}` });
});

app.listen(port, () => {
  console.log(`listening on port ${port}`);
});

// const express = require("express");
// const bodyParser = require('body-parser');

// const app = express();

// // parse application/x-www-form-urlencoded
// app.use(bodyParser.urlencoded({ extended: false }));

// // parse application/json
// app.use(bodyParser.json());

// const port = 4003;

// // Example endpoint: GET request
// app.get("/", (req, res) => {
//   res.send("Hello, Postman!");
// });

// // Example endpoint: POST request
// app.post("/users", (req, res) => {
//   const { name, email } = req.body;
//   // Perform some operations with the received data
//   // For now, just send back a response with the received data
//   res.json({ name, email });
// });

// app.listen(port, () => {
//   console.log(`Server is running on port ${port}`);
// });
