#!/usr/bin/env bash

set -e

# Adding the nodesource repos to yum to install nodejs
tee /etc/yum.repos.d/nodesource-nodejs.repo > /dev/null <<EOF
[nodesource-nodejs]
baseurl=https://rpm.nodesource.com/pub_23.x/nodistro/nodejs/x86_64
gpgkey=https://rpm.nodesource.com/gpgkey/ns-operations-public.key
EOF
yum install -y nodejs

# writing sample app code to app.js
tee app.js > /dev/null <<"EOF"
const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello, World!\n');
});

# using port 80 as it's the port opened in the security group
const port = process.env.PORT || 80;
server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
EOF

# The use of ampersand (&) at the end of the command allows the script to run in the background, so it doesn't block the rest of the script from executing. The nohup command is used to run the process in a way that it will continue running even if the terminal session is closed.
nohup node app.js &