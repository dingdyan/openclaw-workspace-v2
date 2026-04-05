
import { exec } from 'child_process';

const queries = {
    international: "major international news last 24 hours",
    domestic: "国内重要新闻 最近一天",
    ai: "AI technology news last 24 hours"
};

function runQuery(query) {
    return new Promise((resolve, reject) => {
        exec(`mcporter call tavily.tavily_search query="${query}"`, (error, stdout, stderr) => {
            if (error) {
                console.error(`Error executing query: ${query}`, stderr);
                // Resolve with empty results on error to avoid breaking the whole process
                resolve([]);
                return;
            }
            try {
                const data = JSON.parse(stdout);
                resolve(data.results.slice(0, 4)); // Get top 4 results
            } catch (e) {
                console.error(`Error parsing JSON for query: ${query}`, e);
                resolve([]);
            }
        });
    });
}

async function getNews() {
    console.log("老板，早上好！这是您的今日新闻简报：\n");

    const [internationalResults, domesticResults, aiResults] = await Promise.all([
        runQuery(queries.international),
        runQuery(queries.domestic),
        runQuery(queries.ai)
    ]);

    console.log("### 国际新闻");
    if (internationalResults.length > 0) {
        internationalResults.forEach(item => {
            console.log(`*   **${item.title.trim()}**: [链接](${item.url})`);
        });
    } else {
        console.log("今天国际上风平浪静。");
    }
    console.log("\n");

    console.log("### 国内新闻");
    if (domesticResults.length > 0) {
        domesticResults.forEach(item => {
            console.log(`*   **${item.title.trim()}**: [链接](${item.url})`);
        });
    } else {
        console.log("国内今天没什么大事。");
    }
    console.log("\n");

    console.log("### AI前沿");
    if (aiResults.length > 0) {
        aiResults.forEach(item => {
            console.log(`*   **${item.title.trim()}**: [链接](${item.url})`);
        });
    } else {
        console.log("AI领域今天很安静。");
    }
}

getNews();
