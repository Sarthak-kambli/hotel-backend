const express = require('express');
const router = express.Router();
const pool = require('../db'); // PostgreSQL pool
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const authMiddleware = require('../middleware/authMiddleware');

// Helper: Role-based access control
const requireRole = (role) => (req, res, next) => {
    if (req.user.role !== role) {
        return res.status(403).json({ message: 'Access denied: insufficient permissions' });
    }
    next();
};

// Register new user
router.post('/register', async (req, res) => {
    const { name, email, password, role } = req.body;
    try {
        if (!name || !email || !password) {
            return res.status(400).json({ message: 'Name, email, and password are required' });
        }

        // Check if email already exists
        const existingUser = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
        if (existingUser.rows.length > 0) {
            return res.status(400).json({ message: 'Email already registered' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const result = await pool.query(
            'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING id, name, email, role',
            [name, email, hashedPassword, role || 'user']
        );

        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

// Login user
router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        const userResult = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
        const user = userResult.rows[0];
        if (!user) return res.status(400).json({ message: 'Invalid email or password' });

        const validPassword = await bcrypt.compare(password, user.password);
        if (!validPassword) return res.status(400).json({ message: 'Invalid email or password' });

        const token = jwt.sign(
            { id: user.id, role: user.role },
            process.env.JWT_SECRET,
            { expiresIn: '1h' }
        );

        res.json({
            token,
            user: { id: user.id, name: user.name, email: user.email, role: user.role }
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

// Get all users (admin only)
router.get('/', authMiddleware, requireRole('admin'), async (req, res) => {
    try {
        const users = await pool.query('SELECT id, name, email, role FROM users');
        res.json(users.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

// Get single user (protected)
router.get('/:id', authMiddleware, async (req, res) => {
    const { id } = req.params;

    // Allow user to access only their own profile, or admin access
    if (req.user.role !== 'admin' && req.user.id !== parseInt(id)) {
        return res.status(403).json({ message: 'Access denied' });
    }

    try {
        const user = await pool.query('SELECT id, name, email, role FROM users WHERE id = $1', [id]);
        if (user.rows.length === 0) return res.status(404).json({ message: 'User not found' });
        res.json(user.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

// Update user (protected)
router.put('/:id', authMiddleware, async (req, res) => {
    const { id } = req.params;
    const { name, email, password, role } = req.body;

    // Allow self-update or admin update
    if (req.user.role !== 'admin' && req.user.id !== parseInt(id)) {
        return res.status(403).json({ message: 'Access denied' });
    }

    try {
        const existingUser = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
        if (existingUser.rows.length === 0) return res.status(404).json({ message: 'User not found' });

        const hashedPassword = password ? await bcrypt.hash(password, 10) : null;

        const updatedUser = await pool.query(
            `UPDATE users SET 
                name = COALESCE($1, name), 
                email = COALESCE($2, email), 
                password = COALESCE($3, password), 
                role = COALESCE($4, role)
            WHERE id = $5
            RETURNING id, name, email, role`,
            [name, email, hashedPassword, req.user.role === 'admin' ? role : existingUser.rows[0].role, id]
        );

        res.json(updatedUser.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

// Delete user (admin only)
router.delete('/:id', authMiddleware, requireRole('admin'), async (req, res) => {
    const { id } = req.params;
    try {
        const user = await pool.query('SELECT id FROM users WHERE id = $1', [id]);
        if (user.rows.length === 0) return res.status(404).json({ message: 'User not found' });

        await pool.query('DELETE FROM users WHERE id = $1', [id]);
        res.json({ message: 'User deleted successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

module.exports = router;
