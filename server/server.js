const express = require('../../../Users/chalaax/AppData/Local/Microsoft/TypeScript/2.9/node_modules/@types/express');
const app = express();
app.use(express.json());

var request = require('../../../Users/chalaax/AppData/Local/Microsoft/TypeScript/2.9/node_modules/@types/request');
var jp = require('../../../Users/chalaax/AppData/Local/Microsoft/TypeScript/2.9/node_modules/@types/jsonpath');


app.post('/api/*', (req, res) => { 

	var request = require("../../../Users/chalaax/AppData/Local/Microsoft/TypeScript/2.9/node_modules/@types/request");
	
	console.log('Request body ' + JSON.stringify(req.body));
	console.log('Request URL - ' + req.body.url);
	console.log('Request Content - ' + req.body.content);

	
	request.post({
		"headers": { "content-type": "application/json" },
		"url": req.body.url,
		"body": JSON.stringify(req.body.content),
		"auth": {
			"user": "",
			"pass": "",
			"sendImmediately": true
		  }
	}, (error, response, body) => {
		if(error) {
			return console.dir(error);
		}
		console.dir('Response Body - ' + JSON.stringify(body));
		
		res.setHeader('Content-Type', 'application/json');
	    res.send(body);
	});
	
	

});


app.listen(3000, () => console.log('Server listening on port 3000!'))