// routes/menu.js
const express = require('express');
const router = express.Router();
const db = require('../db');

// GET /api/menu - list all menu items
router.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM menu_items ORDER BY category, id');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to load menu' });
  }
});

// GET /api/menu/:id - get a single menu item
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('SELECT * FROM menu_items WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Menu item not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to fetch menu item' });
  }
});

// POST /api/menu - create menu item (admin)
router.post('/', async (req, res) => {
  const { name, description, price, category } = req.body;
  try {
    const result = await db.query(
      'INSERT INTO menu_items(name, description, price, category) VALUES($1,$2,$3,$4) RETURNING *',
      [name, description, price, category]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to add item' });
  }
});

// PUT /api/menu/:id - update a menu item
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { name, description, price, category } = req.body;
  try {
    const result = await db.query(
      'UPDATE menu_items SET name=$1, description=$2, price=$3, category=$4 WHERE id=$5 RETURNING *',
      [name, description, price, category, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Menu item not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to update menu item' });
  }
});

// DELETE /api/menu/:id - delete a menu item
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query('DELETE FROM menu_items WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Menu item not found' });
    }
    res.json({ message: 'Menu item deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: 'Failed to delete menu item' });
  }
});

module.exports = router;