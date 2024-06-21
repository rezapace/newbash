chrome.runtime.onMessage.addListener(function(request, sender, sendResponse){
    try {
        function simulateClick(obj) {
            // var evt = document.createEvent("MouseEvents");
            const event = new MouseEvent("click", {
                view: window,
                bubbles: true,
                cancelable: true 
            });
            const cancelled = !obj.dispatchEvent(event);
            if (cancelled) {
                // A handler called preventDefault.
                alert("Try again! Please dont click anything before our bot completed the job.");
            } 
            else{
                console.log("clicked")
            }
        }

        const iflixGroup = ["iflix", "wetv"];
        if(iflixGroup.some(el => window.location.href.includes(el))){
            //modal login not found, manual
            simulateClick(document.querySelector(".header__icon.header__icon--user img"));
            alert("Username: "+request.email+" Password: "+request.password)
        }
        
        $("#email, .email, input[name='email'], input[type=email], #username, .username, input[name='username'], input[type=text].login__input_gvsAX, input[type=emailLogin], input[type=text].MuiFilledInput-input").val(request.email)

        $(".password, #password, input[name='password'], input[type=password], .user_password, #user_password, input[name='user_password']").val(request.password)


        const turnitinGroup = ["turnitin"];
        if(turnitinGroup.some(el => window.location.href.includes(el))){
            //auto login
            if(document.querySelector("input[type=submit][name='submit']") !== null){
                simulateClick(document.querySelector("input[type=submit][name='submit']"));
            }
        }

        const hboGroup = ["hbogoasia"];
        if(hboGroup.some(el => window.location.href.includes(el))){
            //typing required
            if(document.querySelector("input[type=email]") !== null){
                document.querySelector("input[type=email]").value = "";
                document.querySelector("input[type=password]").value = "";

                const labelUsername = document.createElement("label");
                const username = document.createTextNode(request.email)
                labelUsername.appendChild(username);

                const labelPass = document.createElement("label");
                const pass = document.createTextNode(request.password)
                labelPass.appendChild(pass);

                document.querySelector(".customer-body .customer-input").appendChild(labelUsername)
                document.querySelector(".customer-body .customer-input.forgotpassword").appendChild(labelPass);
            }
        }

        const quillbotGroup = ["quillbot"];
        if(quillbotGroup.some(el => window.location.href.includes(el))){
            //auto login
            if(document.querySelector("#loginContainer div:nth-child(6) button  .MuiTouchRipple-root") !== null)
                simulateClick(document.querySelector("#loginContainer div:nth-child(6) button  .MuiTouchRipple-root"));
        }

        const courseheroGroup = ["coursehero"];
        if(courseheroGroup.some(el => window.location.href.includes(el))){
            //using captcha
        }

        sendResponse({status: "Success!"});
    } catch (error) {
        sendResponse({status: "Exception occured!", error: error});
    }
});