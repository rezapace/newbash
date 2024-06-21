let manifestData = chrome.runtime.getManifest();

chrome.tabs.onActivated.addListener( function(tab) {
    chrome.tabs.get(tab.tabId, current_tab_info => {
        console.log(manifestData.homepage_url)
        if(current_tab_info.url === manifestData.homepage_url){
            chrome.tabs.executeScript(null, {file: './files/tool.js'}, () => console.log('injected'))
        }
    })
});

chrome.runtime.onInstalled.addListener(() => {
    chrome.tabs.create({ url:  manifestData.homepage_url+"/dashboard/app?extensions=installed" });
});