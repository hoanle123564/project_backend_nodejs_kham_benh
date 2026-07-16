const express = require('express')
const http = require('http')
// const bodyParser = require('body-parser')
const ViewEngine = require('../src/config/viewEngine')
const initWebRoute = require('../src/route/web')
const { initChatSocket } = require('../src/socket/chatSocket')
const { startAppointmentReminderScheduler } = require('../src/service/appointmentReminderService')
const cors = require('cors')
require('dotenv').config()

let app = express()

const parseOriginList = (value = '') =>
    value
        .split(',')
        .map(origin => origin.trim())
        .filter(Boolean)

const configuredOrigins = new Set([
    'http://localhost:3000',
    'http://192.168.101.4:3000',
    ...parseOriginList(process.env.URL_REACT),
    ...parseOriginList(process.env.CORS_ORIGINS),
])

const privateNetworkOriginPattern =
    /^https?:\/\/(localhost|127\.0\.0\.1|10\.\d{1,3}\.\d{1,3}\.\d{1,3}|192\.168\.\d{1,3}\.\d{1,3}|172\.(1[6-9]|2\d|3[0-1])\.\d{1,3}\.\d{1,3})(:\d+)?$/

const isAllowedCorsOrigin = (origin) => {
    if (!origin || configuredOrigins.has(origin)) {
        return true
    }

    return process.env.NODE_ENV !== 'production' && privateNetworkOriginPattern.test(origin)
}

app.use(cors({
    origin: (origin, callback) => {
        if (isAllowedCorsOrigin(origin)) {
            callback(null, true)
            return
        }

        callback(new Error(`CORS blocked origin: ${origin}`))
    },
    credentials: true,
}));


app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ limit: "10mb", extended: true }));


// app.use(bodyParser.json({ limit: "10mb" }));
// app.use(bodyParser.urlencoded({ limit: "10mb", extended: true }));

ViewEngine(app)
app.use('/', initWebRoute);

//connectDB();

let port = process.env.PORT
const server = http.createServer(app)
initChatSocket(server, {
    origin: (origin, callback) => {
        if (isAllowedCorsOrigin(origin)) {
            callback(null, true)
            return
        }

        callback(new Error(`CORS blocked origin: ${origin}`))
    },
})

server.listen(port, () => {
    console.log('Backend nodejs is running on port: ' + port);
    startAppointmentReminderScheduler()
})
