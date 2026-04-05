import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';
import { generateViralPost } from './src/core.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

app.post('/api/generate', async (req, res) => {
    const { sourceText, targetTopic, targetPlatform } = req.body;
    
    if (!sourceText || !targetTopic) {
        return res.status(400).json({ error: '必须提供参考文案和目标主题' });
    }

    try {
        const resultText = await generateViralPost(sourceText, targetTopic, targetPlatform || '小红书');
        res.json({ success: true, posts: [resultText] });
    } catch (error) {
        console.error("生成出错:", error);
        res.status(500).json({ error: '服务器内部错误，生成失败' });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 多平台洗稿引擎启动成功！访问地址: http://localhost:${PORT}`);
});
