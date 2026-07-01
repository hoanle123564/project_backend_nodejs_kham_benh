const mysql = require('mysql2')
require('dotenv').config();

const DB_TIMEZONE = process.env.DB_TIMEZONE || '+07:00';

const connection = mysql.createPool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASS || null,
    database: process.env.DB_NAME,
    timezone: DB_TIMEZONE,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

connection.on('connection', (dbConnection) => {
    dbConnection.query('SET time_zone = ?', [DB_TIMEZONE], (error) => {
        if (error) {
            console.error('Failed to set MySQL session time_zone:', error.message);
        }
    });
});

module.exports = connection
