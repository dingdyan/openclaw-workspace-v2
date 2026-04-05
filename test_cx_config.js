const { search } = require('./skills/google-custom-search/search.js');

// Test the CX ID resolution logic
console.log('Testing CX ID configuration:');

// Test 1: No cx parameter, no env var (should use DEFAULT_CX)
console.log('Test 1 - No parameters:');
console.log(`CX_ID from config: ${require('./skills/google-custom-search/search.js').CX_ID}`);

// Test 2: With cx parameter
console.log('\nTest 2 - With cx parameter:');
const testSearch = () => {
    return new Promise((resolve) => {
        // Simulate the search function logic for CX resolution
        const searchEngineId = 'override-cx' || require('./skills/google-custom-search/search.js').CX_ID;
        resolve(searchEngineId);
    });
};
testSearch().then(result => console.log(`CX used: ${result}`));

// Test 3: Check if environment variable would override
console.log('\nTest 3 - Environment variable check:');
console.log(`GOOGLE_CX env var: ${process.env.GOOGLE_CX}`);
console.log(`DEFAULT_CX: ${require('./skills/google-custom-search/search.js').DEFAULT_CX}`);
console.log(`Final CX_ID: ${require('./skills/google-custom-search/search.js').CX_ID}`);