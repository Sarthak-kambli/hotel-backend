//index.js - main entry
require("dotenv").config();
const express = require("express");
const cors = require('cors');

//Import routes
const userRoutes = require('./routes/users');
const tableRoutes = require('./routes/tables');
const menuRoutes = require('./routes/menu');
const bookingRoutes = require('./routes/booking');
const orderRoutes = require('./routes/order');
const billRoutes = require('./routes/bill');
const paymentRoutes = require('./routes/payment');

const app = express();
app.use(cors());
app.use(express.json());

//Boot route
app.get("/", (req, res) => {
  res.send("Hotel backend running 🚀");
});

// API route prefixes
app.use('/api/users', userRoutes);
app.use('/api/tables', tableRoutes);
app.use('/api/menu', menuRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/order', orderRoutes);
app.use('/api/bill', billRoutes);
app.use('/api/payment', paymentRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

//Start Server
const PORT = process.env.PORT || 5000;
app.listen(5000, () => console.log('Server running on http://localhost:${PORT}'));