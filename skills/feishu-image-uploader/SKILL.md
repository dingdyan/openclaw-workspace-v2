# feishu-image-uploader

一个用于将本地图片上传到飞书并获取 `image_key` 的技能。

## 功能描述

该技能允许用户将本地图片文件上传到飞书平台，并返回生成的 `image_key`。这个 `image_key` 可以在后续的飞书消息发送中使用，例如在富文本消息或卡片中引用图片。

## 使用方法

### 1. 环境准备

首先需要设置飞书应用的认证信息：

```bash
export FEISHU_APP_ID=your_app_id
export FEISHU_APP_SECRET=your_app_secret
```

其中 `your_app_id` 和 `your_app_secret` 是你在飞书开放平台创建的应用的 App ID 和 App Secret.

### 2. 安装依赖

```bash
cd ~/.openclaw/workspace/skills/feishu-image-uploader
npm install
```

### 3. 上传图片

```bash
node index.js /path/to/your/image.jpg
```

该命令会输出生成的 `image_key`，例如：
```
ajLc8dQzYxJhG5fT9mKp2qRwE7sVnZbX
```

## 技能实现

该技能基于飞书官方 SDK (`@larksuiteoapi/node-sdk`) 实现，使用 `client.im.file.create()` API 进行文件上传。

支持的图片格式：JPEG, PNG, GIF, WEBP

## 注意事项

1. 确保飞书应用已获得必要的权限（如 `im:file:upload`）
2. 图片文件不能为空
3. 文件大小受限于飞书平台的限制（通常为 20MB）
4. 上传成功后返回的 `image_key` 可用于在飞书消息中引用图片

## 示例

```bash
# 上传一张图片
node index.js ./logo.png
# 输出: ajLc8dQzYxJhG5fT9mKp2qRwE7sVnZbX

# 在飞书消息中使用 image_key
# {
#   "msg_type": "image",
#   "content": {
#     "image_key": "ajLc8dQzYxJhG5fT9mKp2qRwE7sVnZbX"
#   }
# }
```