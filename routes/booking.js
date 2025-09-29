// routes/booking.js
const express = require('express');
const router = express.Router();
const db = require('../db');

// POST /api/bookings - create a booking
router.post('/', async (req, res) => {
  const { name, phone, date, time, guests, table_id } = req.body;
  try {
    const result = await db.query(
      'INSERT INTO bookings(name, phone, date, time, guests, table_id) VALUES($1,$2,$3,$4,$5,$6) RETURNING *',
      [name, phone, date, time, guests, table_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to book' });
  }
});

// GET /api/bookings - list bookings (admin)
router.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM bookings ORDER BY date, time');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to fetch bookings' });
  }
});

// GET /api/bookings/:id - get single booking
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('SELECT * FROM bookings WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to fetch booking' });
  }
});

// PUT /api/bookings/:id - update a booking
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { name, phone, date, time, guests, table_id } = req.body;
  try {
    const result = await db.query(
      `UPDATE bookings 
       SET name = $1, phone = $2, date = $3, time = $4, guests = $5, table_id = $6 
       WHERE id = $7 RETURNING *`,
      [name, phone, date, time, guests, table_id, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to update booking' });
  }
});

// DELETE /api/bookings/:id - delete a booking
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('DELETE FROM bookings WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    res.json({ message: 'Booking deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to delete booking' });
  }
});

module.exports = router;