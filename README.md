# HPCC Systems DAS (Dashboard as Services or Services as Dashboard)

A simple Polymer 3 (mostly lit-html and lit-element) based framework for creating services driven dashboards

The examples in this project use http://play.hpccsystems.com:8010

## Get Started

Prerequisites:

- Latest NPM package manager installed
- Latest Polymer CLI

```
git clone https://github.com/hpcc-systems/Solutions-DAS.git
```

```
cd Solutions-DAS
cd client
npm update
cd ../server
npm update
```

Run the application server (A very simple proxy service that calls ROXIE services) from the server directory

```
node server.js
```

Run the client server from the client directory

```
polyserve --proxy-target http://localhost:3000/api --proxy-path api
```

Access the application from your browser (Firefox tested only)

http://localhost:8081

