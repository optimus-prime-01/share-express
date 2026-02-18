const router = require('express').Router();
const File = require('../models/file');
const mongoose = require('mongoose');
const memoryStorage = require('../storage/memoryStorage');

router.get('/:uuid', async (req, res) => {
    try {
        let file = null;
        
        // Try MongoDB first if connected
        if (mongoose.connection.readyState === 1) {
            try {
                file = await File.findOne({ uuid: req.params.uuid });
            } catch (err) {
                console.error('Error fetching from MongoDB:', err.message);
            }
        }
        
        // Fallback to memory storage
        if (!file) {
            file = memoryStorage.findFileByUuid(req.params.uuid);
        }
        
        // Link expired
        if(!file) {
            return res.render('download', { error: 'Link has been expired.'});
        } 
        
        const baseUrl = process.env.APP_BASE_URL || 'http://localhost:3000';
        return res.render('download', { 
            uuid: file.uuid, 
            fileName: file.filename, 
            fileSize: file.size, 
            downloadLink: `${baseUrl}/files/download/${file.uuid}` 
        });
    } catch(err) {
        console.error('Error in show route:', err);
        return res.render('download', { error: 'Something went wrong.'});
    }
});


module.exports = router;