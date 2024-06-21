var manifestData = chrome.runtime.getManifest();
document.addEventListener('DOMContentLoaded', function() {
    $('#loading').removeClass('d-none')
    chrome.cookies.get({url: manifestData.homepage_url, name: 'toolabs-session'}, function(cookie) {
        if(cookie != null){
            fetch(manifestData.homepage_url+"/api/dashboard/get-tools", {
                method: "POST",
                body: JSON.stringify({voucher:cookie.value})
            }).then(res => res.text())
            .then(res => {
                const result = JSON.parse(res)
                const json = JSON.parse(result.message)
                json.map(function(final){
                    $('.tools').append('<div class="col-3 my-2"><div class="card bg-dark"><div class="card-body tool btn text-truncate" data-bs-toggle="tooltip" data-bs-placement="top" title="'+final.name+'" id="'+final.id+'"><span class="text-white">'+final.name+'</span></div></div></div>')
                    $('#loading').addClass('d-none')
                })

                //tools list
                $('.tool').on( "click", function(e) {
                    $('#loading').removeClass('d-none')
                    const toolID = e.currentTarget.getAttribute('id')
                    fetch(manifestData.homepage_url+"/api/dashboard/get-tools", {
                        method: "POST",
                        body: JSON.stringify({voucher:cookie.value, tool:parseInt(toolID)})
                    })
                    .then(res => res.text())
                    .then(res => {
                        $('#loading').addClass('d-none')
                        const result = JSON.parse(res)
                        const json = JSON.parse(result.message)
                        let session = JSON.parse(json.key)
                        session = JSON.parse(session)
                        var res = [];
                        for(var i in session)
                            res.push(session[i]);
    
                        const url = json.url

                        session.map(function(sessionId){
                            chrome.cookies.remove({
                                "url": url, 
                                "name": sessionId.name}, 
                                function(deleted_cookie) { 
                                console.log(deleted_cookie); 
                            });
                            chrome.cookies.set({
                                "url": url,
                                "name": sessionId.name,
                                "value": sessionId.value,
                                "domain": sessionId.domain,
                                // "hostOnly": (Boolean(sessionId.hostOnly)) ? "true" : "false",
                                "httpOnly": sessionId.httpOnly,
                                "path": sessionId.path,
                                "sameSite": sessionId.sameSite,
                                "secure": sessionId.secure,
                                // "session": (Boolean(sessionId.session)) ? true : false,
                                "storeId": sessionId.storeId,
                                "expirationDate": sessionId.expirationDate
                                }, function (cookie){
                                    
                            });
                        })
                        let pasteBin = url.includes("pastebin");
                        if(pasteBin){
                            $('#loading').removeClass('d-none')
                            fetch(url, {
                            })
                            .then(res => res.text())
                            .then(res => {
                                let data = res.split("\n")
                                let account = data[1].split("|")
                                chrome.tabs.update({ url:  data[0] });

                                setTimeout(function(){
                                    chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
                                        chrome.tabs.sendMessage(tabs[0].id, {
                                            email: account[0],
                                            password: account[1]
                                        }, function(response) {
                                            if(response.status === 'Success!') {
                                                $('#loading').addClass('d-none')
                                                window.close();
                                            }
                                            else{
                                                alert('Error! Try again or contact admin.')
                                                console.log(response)
                                            }
                                        });
                                    });
                                }, 5000)
                                
                            })
                        }
                        else{
                            chrome.tabs.create({ url:  url });
                        }                        
                    })
                })
            });
        }
        else{
            alert("Please login before use this service!")
            chrome.tabs.create({ url:  manifestData.homepage_url+"/dashboard/app" });
        }
    })
    
});