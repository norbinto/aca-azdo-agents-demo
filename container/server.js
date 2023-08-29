const ronin = require('ronin-server')
const mocks = require('ronin-mocks')

const server = ronin.server({
    port: 8000
    })

server.use('/', mocks.server(server.Router(), false, true))
server.start()