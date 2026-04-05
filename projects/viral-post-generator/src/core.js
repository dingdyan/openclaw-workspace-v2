import OpenAI from 'openai';
import dotenv from 'dotenv';
dotenv.config();

const openai = new OpenAI({
    apiKey: process.env.API_KEY || 'sk-test', 
    baseURL: process.env.API_BASE_URL || 'https://api.openai.com/v1',
});

export async function generateViralPost(sourceText, targetTopic, targetPlatform = '小红书') {
    console.log(`🔄 正在提取爆款骨架，准备重构为【${targetPlatform}】风格...`);
    
    let platformInstructions = '';
    
    switch(targetPlatform) {
        case '小红书':
            platformInstructions = '必须符合小红书风格：首图标题极具吸引力，大量使用Emoji🌟，段落极短，重点词汇加粗，语气亲切（如：宝子们、绝绝子、干货建议收藏）。';
            break;
        case '抖音/视频号':
            platformInstructions = '必须符合抖音短视频脚本风格：包含【画面】和【口播】分列。第一秒必须是痛点反转钩子，中段节奏紧凑无废话，结尾带强互动（如：点赞收藏、左下角链接）。';
            break;
        case '微信公众号':
            platformInstructions = '必须符合微信公众号长文风格：有深度的标题，开头有引言和痛点带入，主体分为3-4个清晰的小标题（干货拉满），结尾有走心的金句总结和关注引导。不需要Emoji。';
            break;
        case '知乎/头条':
            platformInstructions = '必须符合知乎高赞回答风格：开头用真实故事或犀利观点破题，中间逻辑严密、分点论述（甚至可以带“利益相关”），文风专业克制，结尾升华主题。';
            break;
        case '微博/推特':
            platformInstructions = '必须符合微博推文风格：字数精简，情绪拉满。第一句直接放炸弹观点，中间短平快输出，必须带相关 #话题标签#，适合快速转发。';
            break;
        default:
            platformInstructions = '小红书图文风格，多用Emoji，语气亲切，分段清晰。';
    }

    const systemPrompt = `你是一个全网通吃、深谙各大内容平台流量密码的“百万粉操盘手”。
    
【你的任务】
1. 深度拆解用户提供的[参考爆款文案]，提取其核心骨架结构（情绪痛点、反转逻辑、干货排布、促单转化）。
2. 将用户提供的[新主题]，套入这个爆款骨架中。
3. 严格遵循以下目标平台要求，写出 3 篇内容完全原创、风格各异的爆款内容：\n\n🎯 ${platformInstructions}\n\n注意：必须返回 3 篇完整的内容，用明显的分割线或编号隔开。`;

    const userPrompt = `【参考爆款文案】：\n${sourceText}\n\n【我要推的新主题】：\n${targetTopic}\n\n【目标平台】：\n${targetPlatform}\n\n请输出3篇定制爆文。`;

    try {
        const response = await openai.chat.completions.create({
            model: process.env.MODEL_NAME || "qwen-plus",
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: userPrompt }
            ],
            temperature: 0.8,
        });

        return response.choices[0].message.content;
    } catch (error) {
        console.error("生成失败:", error);
        return "生成失败，请检查 API 密钥或网络连接。错误信息: " + error.message;
    }
}
