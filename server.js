var fs = require('fs'),
	https = require('https'),
	express = require('express');

var firebase = require('firebase');

firebase.initializeApp({
  serviceAccount: "firebase/haxweb-fr.json",
  databaseURL: "https://haxweb-fr.firebaseio.com/"
});

app = express();

const PORT = 443;

var db = firebase.database();
var ref = db.ref("server/haxweb");

var article = ref.child("articles");


article.set({
	1 : {
		date : "May 27, 1987",
		name : "My First article BLBALBA",
		content : "Content"
	} 
});

https.createServer({
  key: fs.readFileSync('ssl-certs/server.key'),
  cert: fs.readFileSync('ssl-certs/server.crt')
}, app).listen(PORT);


app.get('/demo', function(req, res) {
  res.header('Content-type', 'text/html');
  return res.end('<h1>Hello Garage56 !  update test</h1>');
});

console.log('Running on :' + PORT);
