// Build a basic Node.js REST api 

// console.log("Hello world")
const express = require("express")
const app = express()
const port = 4001

const cars =[
    {name:"LC300", model:2023},
    {name:"Vitz", model:2003},
    {name:"Cultus", model:2020},
    {name:"Civic", model:2022},
]

app.get("/", (req,res)=>{
    // console.log(req)
    // res.send("Welcome")
    res.json(cars)
    // res.json(cars[parseInt(req.params.id)-1])
})

app.get("/cars/:id", (req,res)=>{
    res.send(`What do you want to know about cars ${req.params.id}`)
})

app.listen(port,()=>{
    console.log(`listening on port ${port}`)
})