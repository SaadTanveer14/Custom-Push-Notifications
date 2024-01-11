const express = require('express');
const bodyParser = require('body-parser');
const http = require('http');
const WebSocket = require('ws');
const { error } = require('console');


const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.use(bodyParser.json());

wss.on('connection', (ws) => {
  console.log('WebSocket connection established');
  // Send a welcome message to the new client
  ws.send(JSON.stringify({ message: 'Welcome to the WebSocket server!' }));

  ws.on('close', (code, reason) => {
    console.log(`WebSocket connection closed with code ${code} and reason: ${reason}`);
  });
});

wss.on('error', console.error)

// Handle your POST request and broadcast the received data to all connected clients
app.post('/sendData', (req, res) => {
  const postData = req.body;
  console.log("Data recieved from post request")
  console.log(wss.clients.size)
  // Broadcast the received data to all connected clients
  wss.clients.forEach((client) => {
    console.log('Client if found and sending the message');
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(postData));
    }
  });
  res.json({ success: true, message: 'Data received and broadcasted to clients' });
});

app.get('/getData', (req, res) => {
  res.json({ success: true, message: 'Data received and broadcasted to clients' });
});


server.listen(3000, 'localhost', () => {
  console.log('Server is running on port 3000');
});