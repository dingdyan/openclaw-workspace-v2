#!/usr/bin/env node

const fs = require('fs').promises;
const path = require('path');
const { Client } = require('@larksuiteoapi/node-sdk');

/**
 * Feishu Image Uploader
 * Uploads an image to Feishu and returns the image_key
 * 
 * Usage: node index.js <image_file_path>
 */

async function uploadImage(imagePath) {
  try {
    // Validate input
    if (!imagePath) {
      console.error('Error: Please provide an image file path');
      console.error('Usage: node index.js <image_file_path>');
      process.exit(1);
    }

    // Check if file exists
    await fs.access(imagePath);
    
    // Get file info
    const stats = await fs.stat(imagePath);
    if (stats.size === 0) {
      console.error('Error: File is empty');
      process.exit(1);
    }

    // Get file extension to determine MIME type
    const ext = path.extname(imagePath).toLowerCase();
    let fileType;
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        fileType = 'jpeg';
        break;
      case '.png':
        fileType = 'png';
        break;
      case '.gif':
        fileType = 'gif';
        break;
      case '.webp':
        fileType = 'webp';
        break;
      default:
        fileType = 'jpeg'; // default to jpeg
        console.warn(`Warning: Unknown file extension ${ext}, using jpeg as default`);
    }

    // Get Feishu app credentials from environment variables
    const appId = process.env.FEISHU_APP_ID;
    const appSecret = process.env.FEISHU_APP_SECRET;
    
    if (!appId || !appSecret) {
      console.error('Error: FEISHU_APP_ID and FEISHU_APP_SECRET environment variables are required');
      console.error('Please set them before running this script:');
      console.error('  export FEISHU_APP_ID=your_app_id');
      console.error('  export FEISHU_APP_SECRET=your_app_secret');
      process.exit(1);
    }

    // Create Feishu client
    const client = new Client({
      appId: appId,
      appSecret: appSecret,
      appType: 'SelfBuild',
      domain: 'Feishu'
    });

    // Read the image file
    const fileBuffer = await fs.readFile(imagePath);
    
    // Upload the image using Feishu's file API
    // Note: For images, Feishu uses the im.file.create endpoint
    const res = await client.im.file.create({
      data: {
        file_type: fileType,
        file_name: path.basename(imagePath),
        file: fileBuffer,
      },
    });

    // Check if upload was successful
    if (res.success && res.data) {
      const fileKey = res.data.file_key;
      if (fileKey) {
        console.log(fileKey);
        return fileKey;
      } else {
        console.error('Error: No file_key returned in response');
        console.error('Response:', JSON.stringify(res, null, 2));
        process.exit(1);
      }
    } else {
      console.error('Error: Upload failed');
      console.error('Response:', JSON.stringify(res, null, 2));
      process.exit(1);
    }

  } catch (error) {
    console.error('Error uploading image:', error.message);
    if (error.stack) {
      console.error('Stack trace:', error.stack);
    }
    process.exit(1);
  }
}

// Main execution
if (require.main === module) {
  const imagePath = process.argv[2];
  uploadImage(imagePath);
}