function WebSocketTest(){"WebSocket"in window?(socketSupport=!0,initWebSocket()):(socketSupport=!1,updateStatus())}function initWebSocket(){ws=new WebSocket("ws://wifiusb.local:8080",["arduino"]),ws.onopen=function(e){showToast("Socket connection established")},ws.onclose=function(e){showToast("Socket connection closed")},ws.onmessage=function(e){var t=JSON.parse(e.data);setPowerButtonColor(t.on),showToast(t.description)},ws.onerror=function(e){console.log("Error",e),showToast("Unable to connect. Please confirm that this device and WiFi-USB are on the same network, then refresh the page.")}}function showInfo(){var e=document.getElementById("info-overlay");e.classList="info-overlay scrollable"}function hideInfo(){var e=document.getElementById("info-overlay");e.classList="info-overlay scrollable hidden"}function setPowerButtonColor(e){var t=$(".power-toggle");e?(t.removeClass("power-off"),t.addClass("power-on"),t.attr("title","Power is on")):(t.removeClass("power-on"),t.addClass("power-off"),t.attr("title","Power is off"))}function showToast(e){var t=document.getElementById("toast");t.textContent=e,t.className="toast-show",setTimeout(hideToast,4e3)}function hideToast(){var e=document.getElementById("toast");e.className="toast-hide"}function sendRequestTo(e,t){var o=function(e){setPowerButtonColor(e.on),showToast(e.description)},n=window.XMLHttpRequest?new XMLHttpRequest:new ActiveXObject("Microsoft.XMLHTTP");return n.open(t,"http://wifiusb.local"+e),n.onreadystatechange=function(){n.readyState>3&&200==n.status&&o(n.responseText)},n.setRequestHeader("X-Requested-With","XMLHttpRequest"),n.send(),n}function reboot(){socketSupport?ws.send("reboot"):sendRequestTo("/reboot","GET")}function togglePower(){socketSupport?ws.send("toggle"):sendRequestTo("/toggle","POST")}function updateStatus(){socketSupport?ws.send("status"):sendRequestTo("/status","GET")}var socketSupport=!1,ws;document.addEventListener("DOMContentLoaded",function(){var e=document.getElementById("info-overlay");e.classList="info-overlay scrollable hidden",WebSocketTest()}),document.ontouchmove=function(e){for(var t=!0,o=e.target;null!==o;){if(o.classList&&o.classList.contains("disable-scrolling")){t=!1;break}o=o.parentNode}t||e.preventDefault()};