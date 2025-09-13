const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Health check endpoint for load balancer
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// Main route - serve the logo
app.get('/', (req, res) => {
    const logoPath = path.join(__dirname, 'logoswayatt.png');
    
    // Check if file exists
    require('fs').access(logoPath, require('fs').constants.F_OK, (err) => {
        if (err) {
            res.status(404).json({
                error: 'Logo file not found',
                message: 'Please ensure logoswayatt.png exists in the root directory'
            });
        } else {
            res.sendFile(logoPath);
        }
    });
});

// API endpoint for testing
app.get('/api/info', (req, res) => {
    res.json({
        app: 'DevOps Sample Application',
        version: '1.0.0',
        environment: process.env.NODE_ENV || 'development',
        timestamp: new Date().toISOString()
    });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        error: 'Something went wrong!',
        message: err.message
    });
});

// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({
        error: 'Not Found',
        message: `Route ${req.originalUrl} not found`
    });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://0.0.0.0:${PORT}`);
    console.log(`Health check available at http://0.0.0.0:${PORT}/health`);
    console.log(`API info available at http://0.0.0.0:${PORT}/api/info`);
});