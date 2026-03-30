function convertBtStatusToString(status,deviceName="")
{
    var res;
    switch(status)
    {
        case -1: res= "Unknown"; break;
        case 10: res= "Adaptor Not Found";break;
        case 11: res= "Failed";break;
        case 12: res= "Bluetooth Powered Off"; break;
        case 13: res= "Bluetooth Powered On"; break;
        case 20: res= "Permission Denied";break;
        case 21: res= "Asking Permission";break;
        case 22: res= "Permission Granted";break;
        case 30: res= "Disconnected";break;
        case 31: res= "Scanning";break;
        case 32: res= "Scan Canceled";break;
        case 33: res= "Scan Done";break;
        case 34: res= "Connecting";break;
        case 35: res= "Connected";break;
        default: res= "ERROR";break;
    }
    if(deviceName!=="" && (status===35||status===34))
        return res+" to "+ (deviceName.length>5 ? deviceName.substring(0, 5)+".." : deviceName)
    else
        return res

}

function convertConnectionStatusToColor(code)
{
    switch(code)
    {
        case -1:
        case 10:
        case 11:
        case 12:
        case 20:
        case 30:
            return "#ff0000";//red //disconnected, unknown, no adapter, failed, no permission, powered off
        case 13:
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
