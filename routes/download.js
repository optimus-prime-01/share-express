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
     
     const filePath = `${__dirname}/../${file.path}`;
     const fs = require('fs');
     if (!fs.existsSync(filePath)) {
       return res.status(404).render('download', { error: 'File not found on server.'});
     }
     res.download(filePath, file.filename);
   } catch (error) {
     console.error('Error downloading file:', error);
     return res.status(500).render('download', { error: 'Something went wrong.'});
   }
});


module.exports = router;