function convertBtStatusToString(status)
{
    switch(status) {
    case -1: return "Unknown";
    case 10: return "Adaptor Not Found";
    case 11: return "Failed";
    case 20: return "Permission Denied";
    case 21: return "Asking Permission";
    case 22: return "Permission Granted";
    case 30: return "Disconnected";
    case 31: return "Scanning";
    case 32: return "ScanningCanceled";
    case 33: return "ScanningDone";
    case 34: return "Connecting";
    case 35: return "Connected";
    default: return "Unknown Status";
    }
}
