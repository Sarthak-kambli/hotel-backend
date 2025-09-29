// routes/users.js

const express = require('express');
const router = express.Router();
const db = require('../db');

// Generate a new bill for an order
router.post('/', async (req, res) => {
  try {
    const { order_id } = req.body;

    // Check order exists
    const orderCheck = await db.query('SELECT * FROM orders WHERE id = $1', [order_id]);
    if (orderCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Order not found' });
    }

    // Get order items and calculate total
    const items = await db.query(`
      SELECT quantity, unit_price
      FROM order_items
      WHERE order_id = $1
    `, [order_id]);

    if (items.rows.length === 0) {
      return res.status(400).json({ error: 'No items found for this order' });
    }

    const total = items.rows.reduce((sum, item) => sum + (item.quantity * item.unit_price), 0);

    // Insert bill
    const result = await db.query(
      'INSERT INTO bills (order_id, total_amount) VALUES ($1, $2) RETURNING *',
      [order_id, total]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to generate bill', details: err.message });
  }
});

// Get all bills
router.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM bills ORDER BY generated_at DESC');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch bills' });
  }
});

// Get bill by ID
router.get('/:id', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM bills WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Bill not found' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch bill' });
  }
});

// Update bill (e.g., mark as paid manually)
router.put('/:id', async (req, res) => {
  try {
    const { status } = req.body;
    const result = await db.query(
      'UPDATE bills SET status = $1 WHERE id = $2 RETURNING *',
      [status, req.params.id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Bill not found' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to update bill' });
  }
});

// Delete bill
router.delete('/:id', async (req, res) => {
  try {
    const result = await db.query('DELETE FROM bills WHERE id = $1 RETURNING *', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Bill not found' });
    res.json({ message: 'Bill deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete bill' });
  }
});

module.exports = router;
