// routes/tables.js
const express = require('express');
const router = express.Router();
const db = require('../db');

// POST /api/tables
router.post('/', async (req, res) => {
  const { table_number, capacity, status } = req.body;
  try {
    const result = await db.query(
      'INSERT INTO restaurant_tables(table_number, capacity, status) VALUES($1,$2,$3) RETURNING *',
      [table_number, capacity, status || 'available']
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to add table' });
  }
});

// GET /api/tables
router.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM restaurant_tables ORDER BY table_number');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch tables' });
  }
});

// GET /api/tables/:id
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('SELECT * FROM restaurant_tables WHERE id=$1', [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Table not found' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch table' });
  }
});

// PUT /api/tables/:id
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { table_number, capacity, status } = req.body;
  try {
    const result = await db.query(
      'UPDATE restaurant_tables SET table_number=$1, capacity=$2, status=$3 WHERE id=$4 RETURNING *',
      [table_number, capacity, status, id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Table not found' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to update table' });
  }
});

// DELETE /api/tables/:id
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('DELETE FROM restaurant_tables WHERE id=$1 RETURNING *', [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Table not found' });
    res.json({ message: 'Table deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to delete table' });
  }
});

module.exports = router;