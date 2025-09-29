// routes/order.js
const express = require('express');
const router = express.Router();
const db = require('../db');

// POST /api/orders - place an order
router.post('/', async (req, res) => {
  const { user_id, table_id, items = [], total_amount } = req.body;
  try {
    await db.query('BEGIN');

    // Insert into orders
    const orderRes = await db.query(
      'INSERT INTO orders(user_id, table_id, total_amount) VALUES($1,$2,$3) RETURNING id, order_time, status',
      [user_id, table_id, total_amount]
    );

    const orderId = orderRes.rows[0].id;

    // Insert items
    const insertPromises = items.map(i =>
      db.query(
        'INSERT INTO order_items(order_id, menu_item_id, quantity, unit_price) VALUES($1,$2,$3,$4)',
        [orderId, i.menu_item_id, i.qty, i.unit_price || 0]
      )
    );

    await Promise.all(insertPromises);
    await db.query('COMMIT');

    res.status(201).json({
      orderId,
      order_time: orderRes.rows[0].order_time,
      status: orderRes.rows[0].status
    });
  } catch (err) {
    await db.query('ROLLBACK');
    console.error("Order Error:", err.message);
    res.status(400).json({ error: 'Failed to place order', details: err.message });
  }
});

// GET /api/orders - fetch all orders + items
router.get('/', async (req, res) => {
  try {
    const ordersRes = await db.query('SELECT * FROM orders ORDER BY id ASC');

    const orders = await Promise.all(
      ordersRes.rows.map(async (order) => {
        const itemsRes = await db.query(
          'SELECT oi.*, mi.name FROM order_items oi JOIN menu_items mi ON oi.menu_item_id = mi.id WHERE order_id=$1',
          [order.id]
        );
        return { ...order, items: itemsRes.rows };
      })
    );

    res.json(orders);
  } catch (err) {
    console.error("Fetch All Orders Error:", err.message);
    res.status(500).json({ error: 'Failed to fetch orders' });
  }
});


// GET /api/orders/:id - get order + items
router.get('/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const orderRes = await db.query('SELECT * FROM orders WHERE id=$1', [id]);
    if (orderRes.rows.length === 0) {
      return res.status(404).json({ error: 'Order not found' });
    }

    const itemsRes = await db.query(
      'SELECT oi.*, mi.name FROM order_items oi JOIN menu_items mi ON oi.menu_item_id = mi.id WHERE order_id=$1',
      [id]
    );

    res.json({ order: orderRes.rows[0], items: itemsRes.rows });
  } catch (err) {
    console.error("Fetch Order Error:", err.message);
    res.status(500).json({ error: 'Failed to fetch order' });
  }
});

// PUT /api/orders/:id - update an order
router.put('/:id', async (req, res) => {
  const id = req.params.id;
  const { user_id, table_id, items = [], total_amount, status } = req.body;

  try {
    await db.query('BEGIN');

    // Update order
    const orderRes = await db.query(
      'UPDATE orders SET user_id=$1, table_id=$2, total_amount=$3, status=$4 WHERE id=$5 RETURNING *',
      [user_id, table_id, total_amount, status || 'pending', id]
    );

    if (orderRes.rows.length === 0) {
      await db.query('ROLLBACK');
      return res.status(404).json({ error: 'Order not found' });
    }

    // Delete old items
    await db.query('DELETE FROM order_items WHERE order_id=$1', [id]);

    // Insert new items
    const insertPromises = items.map(i =>
      db.query(
        'INSERT INTO order_items(order_id, menu_item_id, quantity, unit_price) VALUES($1,$2,$3,$4)',
        [id, i.menu_item_id, i.qty, i.unit_price || 0]
      )
    );

    await Promise.all(insertPromises);
    await db.query('COMMIT');

    res.json({ order: orderRes.rows[0], items });
  } catch (err) {
    await db.query('ROLLBACK');
    console.error("Update Order Error:", err.message);
    res.status(500).json({ error: 'Failed to update order', details: err.message });
  }
});

// DELETE /api/orders/:id - delete an order
router.delete('/:id', async (req, res) => {
  const id = req.params.id;
  try {
    await db.query('BEGIN');

    await db.query('DELETE FROM order_items WHERE order_id=$1', [id]);
    const result = await db.query('DELETE FROM orders WHERE id=$1 RETURNING *', [id]);

    if (result.rows.length === 0) {
      await db.query('ROLLBACK');
      return res.status(404).json({ error: 'Order not found' });
    }

    await db.query('COMMIT');
    res.json({ message: 'Order deleted successfully' });
  } catch (err) {
    await db.query('ROLLBACK');
    console.error("Delete Order Error:", err.message);
    res.status(500).json({ error: 'Failed to delete order' });
  }
});

module.exports = router;