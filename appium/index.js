const wdio = require("webdriverio");

// console.log('Nyaa test: running in environment', JSON.stringify(process.env));
let platformName;
let browserName;
let automationName;
if (process.env.DEVICEFARM_DEVICE_PLATFORM_NAME === "Android") {
    console.log('Nyaa Test: Running on Android.');
    platformName = 'Android';
    browserName = 'Chrome';
    automationName = 'UIAutomator2';
} else if (process.env.DEVICEFARM_DEVICE_PLATFORM_NAME === "iOS") {
    console.log('Nyaa Test: Running on iOS.');
    platformName = 'iOS';
    browserName = 'Safari';
    automationName = 'XCUITest';
} else {
    console.log('Nyaa Test: Running on Desktop.');
    platformName = undefined;
    browserName = 'Chrome';
}

const opts = {
    path: '/wd/hub',
    port: 4723,
    capabilities: {
        platformName,
        browserName,
        automationName
    }
};


async function main() {
    const browser = await wdio.remote(opts);
    await browser.url('https://nyaa.joyride.fm')
    await browser.pause(5000)
    const tutorialButton = await browser.$('#new-game')
    await tutorialButton.click()
    await browser.pause(3000)
    const startTutorial = await browser.$('#start-game')
    await startTutorial.click()
    await browser.pause(10000)
    await browser.deleteSession();
}

main();