const https = require('https');
const querystring = require('querystring');

// Configuration
// API Key provided in instructions
const DEFAULT_API_KEY = 'AIzaSyDF3aqZ3cNW_3eSF2LY-nZiA1l1FSEVfCM'; 

// Environment variables override defaults
const API_KEY = process.env.GOOGLE_API_KEY || DEFAULT_API_KEY;
const DEFAULT_CX = 'b1635b48f16c04a18';
const CX_ID = process.env.GOOGLE_CX || DEFAULT_CX; 

/**
 * Performs a Google Custom Search.
 * @param {string} query - The search query.
 * @param {string} cx - The Programmable Search Engine ID.
 * @param {number} num - Number of results (1-10).
 * @returns {Promise<Object>} - Structured search results.
 */
function search(query, cx, num = 10) {
    return new Promise((resolve, reject) => {
        // Use provided CX, or env var, or fail gracefully
        const searchEngineId = cx || CX_ID;

        if (!searchEngineId) {
            // Per instructions: "design to default to entire web search".
            // Since API requires a specific CX for this, we return a helpful error
            // guiding the user to provide one.
            const error = new Error("MISSING_CX");
            error.details = {
                message: "To perform a 'Whole Web Search', a Programmable Search Engine ID (CX) is required.",
                instruction: "1. Go to https://programmablesearchengine.google.com/\n2. Create a new search engine.\n3. Enable 'Search the entire web' in setup.\n4. Copy the CX ID and pass it via --cx or GOOGLE_CX env var."
            };
            return reject(error);
        }

        const params = {
            key: API_KEY,
            cx: searchEngineId,
            q: query,
            num: num
        };

        const url = `https://www.googleapis.com/customsearch/v1?${querystring.stringify(params)}`;

        const req = https.get(url, (res) => {
            let data = '';

            res.on('data', chunk => data += chunk);

            res.on('end', () => {
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    try {
                        const parsed = JSON.parse(data);
                        resolve(formatResults(parsed));
                    } catch (e) {
                        reject(new Error(`Failed to parse response: ${e.message}`));
                    }
                } else {
                    // Try to parse error details
                    try {
                        const errData = JSON.parse(data);
                        const msg = errData.error && errData.error.message ? errData.error.message : 'Unknown API Error';
                        reject(new Error(`API Error (${res.statusCode}): ${msg}`));
                    } catch (e) {
                        reject(new Error(`HTTP Error ${res.statusCode}: ${data.substring(0, 100)}`));
                    }
                }
            });
        });

        req.on('error', (e) => reject(new Error(`Network Error: ${e.message}`)));
    });
}

/**
 * Formats the raw API response into a clean structure.
 */
function formatResults(data) {
    if (!data.items || data.items.length === 0) {
        return {
            meta: {
                totalResults: data.searchInformation ? data.searchInformation.totalResults : 0,
                searchTime: data.searchInformation ? data.searchInformation.searchTime : 0
            },
            results: []
        };
    }

    const results = data.items.map(item => ({
        title: item.title,
        link: item.link,
        snippet: item.snippet,
        displayLink: item.displayLink
    }));

    return {
        meta: {
            totalResults: data.searchInformation ? data.searchInformation.totalResults : 0,
            searchTime: data.searchInformation ? data.searchInformation.searchTime : 0
        },
        results: results
    };
}

// CLI Interface
if (require.main === module) {
    const args = process.argv.slice(2);
    let queryArgs = [];
    let cx = '';
    let num = 10;

    for (let i = 0; i < args.length; i++) {
        if (args[i] === '--cx') {
            cx = args[i + 1];
            i++; // skip next
        } else if (args[i] === '--num') {
            num = parseInt(args[i + 1], 10);
            i++; // skip next
        } else {
            queryArgs.push(args[i]);
        }
    }

    const query = queryArgs.join(' ');

    if (!query) {
        console.error("Usage: node search.js <query string> [--cx <id>] [--num <1-10>]");
        process.exit(1);
    }

    search(query, cx, num)
        .then(results => {
            console.log(JSON.stringify(results, null, 2));
        })
        .catch(err => {
            console.error("Error:");
            if (err.details) {
                console.error(err.details.message);
                console.error(err.details.instruction);
            } else {
                console.error(err.message);
            }
            process.exit(1);
        });
}

module.exports = { search };
