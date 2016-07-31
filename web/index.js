var socketSupport = false;
var ws;

document.addEventListener("DOMContentLoaded", function () {
    var overlay = document.getElementById("info-overlay");
    overlay.classList = "info-overlay scrollable hidden";
    WebSocketTest();
});


function WebSocketTest() {
    if ("WebSocket" in window) {
        socketSupport = true;
        initWebSocket();
    } else {
        socketSupport = false;
        updateStatus();
    }
}

function initWebSocket() {
    ws = new WebSocket("ws://wifiusb.local:8080", ['arduino']);
    ws.onopen = function (evt) {
        showToast("Socket connection established");
    }
    ws.onclose = function (evt) {
        showToast("Socket connection closed");
    }
    ws.onmessage = function (evt) {
        var data = JSON.parse(evt.data);
        console.log(evt);
        console.log(data);
        setPowerButtonColor(data.on);
        showToast(data.description);
    }
    ws.onerror = function (evt) {
        console.log("Error", evt);
        showToast("Unable to connect. Please confirm that this device and WiFi-USB are on the same network, then refresh the page.");
    }
}

function showInfo() {
    var overlay = document.getElementById("info-overlay");
    overlay.classList = "info-overlay scrollable";
}

function hideInfo() {
    var overlay = document.getElementById("info-overlay");
    overlay.classList = "info-overlay scrollable hidden";
}

function setPowerButtonColor(powerIsOn) {
    var button = document.getElementById("power-toggle");
    if (powerIsOn) {
        button.classList = "power-toggle power-on";
        button.setAttribute("title", "Power is on");
    } else {
        button.classList = "power-toggle power-off";
        button.setAttribute("title", "Power is off");
    }
}

function showToast(message) {
    var toast = document.getElementById("toast");
    toast.textContent = message;
    toast.className = "toast-show";
    //    toast.style.bottom = "30px";
    //    toast.style.opacity = "0.9";
    setTimeout(hideToast, 4000);
}

function hideToast() {
    var toast = document.getElementById("toast");
    toast.className = "toast-hide";
    //    toast.style.bottom = "-100px";
    //    toast.style.opacity = "0.0";
}

function sendRequestTo(endpoint, withMethod) {
    var success = function (data) {
        setPowerButtonColor(data.on);
        showToast(data.description);
    }

    var xhr = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject('Microsoft.XMLHTTP');
    xhr.open(withMethod, "http://wifiusb.local" + endpoint);
    xhr.onreadystatechange = function () {
        if (xhr.readyState > 3 && xhr.status == 200) success(xhr.responseText);
    };
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.send();
    return xhr;

}

function reboot() {
    if (socketSupport) {
        ws.send("reboot");
    } else {
        sendRequestTo("/reboot", "GET");
    }
}

function togglePower() {
    if (socketSupport) {
        ws.send("toggle");
    } else {
        sendRequestTo("/toggle", "POST");
    }
}

function updateStatus() {
    if (socketSupport) {
        ws.send("status");
    } else {
        sendRequestTo("/status", "GET");
    }
}


/* Misbehaving scroll fix courtesy of: http://blog.christoffer.me/six-things-i-learnt-about-ios-safaris-rubber-band-scrolling/ */
document.ontouchmove = function (event) {

    var isTouchMoveAllowed = true,
        target = event.target;

    while (target !== null) {
        if (target.classList && target.classList.contains('disable-scrolling')) {
            isTouchMoveAllowed = false;
            break;
        }
        target = target.parentNode;
    }

    if (!isTouchMoveAllowed) {
        event.preventDefault();
    }

};

//function removeIOSRubberEffect(element) {
//
//    element.addEventListener("touchstart", function () {
//
//        var top = element.scrollTop,
//            totalScroll = element.scrollHeight,
//            currentScroll = top + element.offsetHeight;
//
//        if (top === 0) {
//            element.scrollTop = 1;
//        } else if (currentScroll === totalScroll) {
//            element.scrollTop = top - 1;
//        }
//
//    });
//
//}
//
//removeIOSRubberEffect(document.querySelector(".scrollable"));