const express = require('express');
const hbs = require('express-handlebars').create();


const PORT = process.argv[2] | 3000
const app = express();

app.engine('handlebars', hbs.engine);
app.set('view engine', 'handlebars');

app.use('/static', express.static('static'));

app.get('/', (req, res) => {
    res.send('Hello from The Team. Get the pun(?)')
})

app.listen(PORT, () => {
    console.log(`server started on port ${PORT} ...`);
})