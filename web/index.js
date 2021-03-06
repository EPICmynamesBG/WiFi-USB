//TODO: Remove JQuery, just use CSS3 animatinos?
$(document).ready(function(){
   $(".info-overlay").hide();
    updateStatus();
});

function showInfo() {
    $(".info-overlay").fadeIn();
}

function hideInfo() {
    $(".info-overlay").fadeOut();
}

function setPowerButtonColor(powerIsOn) {
    var button = $(".power-toggle");
    if (powerIsOn) {
        button.removeClass("power-off");
        button.addClass("power-on");
        button.attr("title", "Power is on");
    } else {
        button.removeClass("power-on");
        button.addClass("power-off");
        button.attr("title", "Power is off");
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
    var success = function(data) {
        setPowerButtonColor(data.on);
        showToast(data.description);
    }
    
    $.ajax({
        type: withMethod,
        url: "http://wifiusb.local" + endpoint,
        data: null,
        success: success
    });
}

function reboot() {
    sendRequestTo("/reboot", "GET");
}

function togglePower() {
    sendRequestTo("/toggle", "POST");
}

function updateStatus() {
    sendRequestTo("/status", "GET");
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

function removeIOSRubberEffect(element) {

    element.addEventListener("touchstart", function () {

        var top = element.scrollTop,
            totalScroll = element.scrollHeight,
            currentScroll = top + element.offsetHeight;

        if (top === 0) {
            element.scrollTop = 1;
        } else if (currentScroll === totalScroll) {
            element.scrollTop = top - 1;
        }

    });

}

removeIOSRubberEffect(document.querySelector(".scrollable"));