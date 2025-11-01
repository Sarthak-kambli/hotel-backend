// routes/booking.js
const express = require('express');
const router = express.Router();
const db = require('../db');
const authMiddleware = require('../middleware/authMiddleware');

// Helper: Restrict certain routes to specific roles
const requireRole = (role) => (req, res, next) => {
  if (req.user.role !== role) {
    return res.status(403).json({ message: 'Access denied: insufficient permissions' });
  }
  next();
};

/* 
  POST /api/bookings
  -> Logged-in users can make a booking request
  -> Default status = 'pending'
*/
router.post('/', authMiddleware, async (req, res) => {
  const { name, phone, date, time, guests } = req.body;

  try {
    if (!name || !phone || !date || !time || !guests) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const result = await db.query(
      `INSERT INTO bookings (name, phone, date, time, guests, status, user_id)
       VALUES ($1, $2, $3, $4, $5, 'pending', $6)
       RETURNING *`,
      [name, phone, date, time, guests, req.user.id]
    );

    res.status(201).json({
      message: 'Booking request sent successfully. You will be notified once confirmed.',
      booking: result.rows[0]
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to create booking' });
  }
});

/* 
  GET /api/bookings
  -> Admin only: view all bookings
*/
router.get('/', authMiddleware, requireRole('admin'), async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM bookings ORDER BY date, time');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch bookings' });
  }
});

/* 
  PUT /api/bookings/:id/status
  -> Admin only: approve or reject a booking
  -> Expected body: { status: 'confirmed' | 'rejected' }
*/
router.put('/:id/status', authMiddleware, requireRole('admin'), async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  if (!['confirmed', 'rejected'].includes(status)) {
    return res.status(400).json({ error: 'Invalid status value' });
  }

  try {
    const result = await db.query(
      `UPDATE bookings SET status = $1 WHERE id = $2 RETURNING *`,
      [status, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    res.json({
      message: `Booking ${status} successfully`,
      booking: result.rows[0]
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to update booking status' });
  }
});

/* 
  GET /api/bookings/my
  -> Logged-in user can view only their bookings
*/
router.get('/my', authMiddleware, async (req, res) => {
  try {
    const result = await db.query(
      'SELECT * FROM bookings WHERE user_id = $1 ORDER BY date, time',
      [req.user.id]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch your bookings' });
  }
});

// DELETE /api/bookings/:id - Admin only
router.delete('/:id', authMiddleware, requireRole('admin'), async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('DELETE FROM bookings WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    res.json({ message: 'Booking deleted successfully', deleted: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to delete booking' });
  }
});

module.exports = router;
