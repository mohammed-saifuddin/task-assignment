const puppeteer = require('puppeteer');

(async () => {
    const url = process.env.SCRAPE_URL;
    const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    const page = await browser.newPage();
    await page.goto(url);

    // Extract data
    const data = await page.evaluate(() => {
        return {
            title: document.title,
            heading: document.querySelector('h1') ? document.querySelector('h1').innerText : null
        };
    });

    // Write data to JSON file
    const fs = require('fs');
    fs.writeFileSync('scraped_data.json', JSON.stringify(data, null, 2));

    await browser.close();
})();