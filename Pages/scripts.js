
function convertConnectionStatusToColor(code)
{
    switch(code)
    {
        case -1://unkown (start status)
            return "#989898";//like grey
        case 10:
        case 11:
        case 23: //bluetooth is powered off
        case 20: //permission  denied
        case 30:
            return "#ff0000";//red //disconnected, no adapter, failed, no permission, powered off

        case 21: //permission asking
        case 22: //permission granted
        case 24: //bluetooth powered on
        case 31:
        case 32:
        case 33:
            return "#ffff00";//yellow , //Scanning, ScanningCanceled, ScanningDone, bluetooth is on
        case 34:
            return "#ff7300";//orange (connecting)

        case 35:
            return "#00ff00";//green  //connected
        default:
            return "#a400ff"; //purple, really unknown
    }
}



function darkenColor(hex, amount = 20)
{
hex = hex.replace("#", "").trim();
// Must be 6 characters
if (hex.length !== 6) return null;
// Convert to RGB
let r = parseInt(hex.substring(0, 2), 16);
let g = parseInt(hex.substring(2, 4), 16);
let b = parseInt(hex.substring(4, 6), 16);

// Darken each channel
const factor = 1 - (amount / 100);
r = Math.round(r * factor);
g = Math.round(g * factor);
b = Math.round(b * factor);

// Clamp 0–255
r = Math.max(0, Math.min(255, r));
g = Math.max(0, Math.min(255, g));
b = Math.max(0, Math.min(255, b));
return [r,g,b]
}

