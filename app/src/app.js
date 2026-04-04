const express = require('express');
const client = require('prom-client');

const app = express();
const port = process.env.PORT || 3000;

// Initialize Prometheus metrics
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// Prometheus metrics endpoint
app.get('/metrics', async (req, res) => {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});