var powerIsOn = true;

$(document).ready(function(){
   $(".info-overlay").hide();
    setPowerButtonColor(powerIsOn);
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

function sendRequestTo(endpoint, withMethod) {
    let success = function(data) {
        console.log(data);
    }
    
    $.ajax({
        type: withMethod,
        url: "http://wifiusb.local" + endpoint,
        data: null,
        success: success
    });
}

function reboot() {
    console.log("Reboot");
}

function togglePower() {
    console.log("toggle power");
    powerIsOn = !powerIsOn;
    setPowerButtonColor(powerIsOn);
}

function updateStatus() {
    console.log("status update");
    alert("Power is on="+ powerIsOn);
}