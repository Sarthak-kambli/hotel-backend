// db.js — simple Postgres helper using node-postgres (pg)
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,

  ssl: {
    rejectUnauthorized: false, // required for Render PostgreSQL
  },

  /* If running locally without DATABASE_URL, you can configure:
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT*/
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool
};