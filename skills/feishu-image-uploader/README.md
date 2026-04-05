# Feishu Image Uploader

A simple tool to upload images to Feishu and get the `image_key` for use in Feishu messages.

## Quick Start

1. **Set up your Feishu app credentials**:
   ```bash
   export FEISHU_APP_ID=your_app_id
   export FEISHU_APP_SECRET=your_app_secret
   ```

2. **Install dependencies**:
   ```bash
   cd ~/.openclaw/workspace/skills/feishu-image-uploader
   npm install
   ```

3. **Upload an image**:
   ```bash
   node index.js /path/to/your/image.jpg
   ```

4. **Use the returned image_key** in your Feishu messages.

## How It Works

This tool uses the official Feishu SDK to upload images via the `/im/file/create` API endpoint. The response contains the `file_key` which can be used to reference the uploaded image in Feishu messages.

## Supported Image Formats

- JPEG/JPG
- PNG
- GIF
- WEBP

## Troubleshooting

- **"FEISHU_APP_ID and FEISHU_APP_SECRET environment variables are required"**: Make sure you've set the environment variables.
- **"File is empty"**: Ensure the image file exists and is not empty.
- **"Upload failed"**: Check your Feishu app permissions and network connectivity.

## Example Usage

```bash
# Upload logo.png
$ node index.js ./logo.png
ajLc8dQzYxJhG5fT9mKp2qRwE7sVnZbX

# The output (ajLc8dQzYxJhG5fT9mKp2qRwE7sVnZbX) is your image_key
```

You can then use this `image_key` in Feishu message content like:
```json
{
  "msg_type": "image",
  "content": {
    "image_key": "ajLc8dQzYxJhG5fT9mKp2qRwE7sVnZbX"
  }
}
```

## Permissions Required

Your Feishu app needs the following permissions:
- `im:file:upload`
- `im:message:send_as_bot` (if you plan to send messages with the uploaded images)

## Getting Your App Credentials

1. Go to [Feishu Open Platform](https://open.feishu.cn/app/)
2. Create a new "自建应用" (Self-built App)
3. Copy the App ID and App Secret from the app details page