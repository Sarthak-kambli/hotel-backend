// routes/users.js
const express = require('express');
const router = express.Router();
const db = require('../db');

// Create a payment for a bill
router.post('/', async (req, res) => {
  try {
    const { bill_id, amount, method } = req.body;

    // Check bill exists
    const billCheck = await db.query('SELECT * FROM bills WHERE id = $1', [bill_id]);
    if (billCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Bill not found' });
    }

    // Insert payment
    const result = await db.query(
      `INSERT INTO payments (bill_id, amount, method, status) 
       VALUES ($1, $2, $3, 'success') RETURNING *`,
      [bill_id, amount, method]
    );

    // Update bill status → paid
    await db.query('UPDATE bills SET status = $1 WHERE id = $2', ['paid', bill_id]);

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to process payment', details: err.message });
  }
});

// Get all payments
router.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM payments ORDER BY paid_at DESC');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch payments' });
  }
});

// Get payment by ID
router.get('/:id', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM payments WHERE payment_id = $1', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Payment not found' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch payment' });
  }
});

// Update payment status (e.g., failed/refunded)
router.put('/:id', async (req, res) => {
  try {
    const { status } = req.body;
    const result = await db.query(
      'UPDATE payments SET status = $1 WHERE payment_id = $2 RETURNING *',
      [status, req.params.id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Payment not found' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to update payment' });
  }
});

// Delete payment
router.delete('/:id', async (req, res) => {
  try {
    const result = await db.query('DELETE FROM payments WHERE payment_id = $1 RETURNING *', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Payment not found' });
    res.json({ message: 'Payment deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete payment' });
  }
});

module.exports = router;
