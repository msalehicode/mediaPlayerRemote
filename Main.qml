import QtQuick
import QtQuick.Controls
import "./Pages"
import "./CustomComponents"
import "./Pages/scripts.js" as Script

ApplicationWindow
{
    id:rootWindow;

    width: 380
    height: 840
    visible: true
    title: qsTr("MediaPlayer Android Remote")

    onClosing:
    {
        if(mainStack.depth>1)
        {
            if(mainStack.currentItem.objectName==="ControlPage")
            {
                //make sure disconnecting current connection before pop out
                backend.disconnectFromHost();
            }
            mainStack.pop();
            close.accepted = false;
        }

        //close will accepted.
    }

    header: Rectangle
    {
        id:connectionStatusBackground
        visible:true
        width:parent.width
        height:30
        Row
        {
            width: parent.width/2
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Image
            {
                id: connectionModeIcon
                width: 20
                height: 20
                source: settings.value["recentDevice/type"]==="bluetooth"?  "icons/bluetooth.png" : "icons/wifi.png"
                anchors.verticalCenter: parent.verticalCenter
            }
            Label
            {
                id:connectionStatusLabel
                font.pixelSize: 20
                text:""
                color: "black"
                font.bold: true
                width: implicitWidth
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
            }
        }

    }


    Rectangle
    {
        anchors.fill: parent
        color:"black"
        StackView
        {
            id:mainStack
            anchors.fill: parent
            initialItem: "Pages/ConnectionPage.qml"
        }
    }


    Rectangle
    {
        id:popupBluetoothError
        anchors.fill: parent
        visible: false
        color:"red"


        function show(text,checkButton=false,checkBlueStatus=false)
        {
            popupBluetoothAccessText.text = text
            popupBluetoothError.visible=true
            buttonCheckBluetoothOn.setVisible=checkBlueStatus
            buttonCheckBluetoothPermission.setVisible = checkButton
        }

        function hide()
        {
            popupBluetoothError.visible=false
            popupBluetoothAccessText.text = ""//clear text
        }

        Column
        {

            anchors.centerIn: parent
            spacing: 25
            Text {
                id:popupBluetoothAccessText
                color:"white"
                font.pixelSize: 25
                font.bold: true
            }
            CustomButton
            {
                id:buttonCheckBluetoothPermission
                setButtonText: "Check Permission"
                setWidth: 150
                anchors.horizontalCenter: parent.horizontalCenter
                setButtonFontsize: 15
                setHeight: 50
                setButtonBackColor: "cyan"
                setButtonFontColor: "black"
                setButtonBorderColor: "transparent"
                setVisible: false
                onButtonClicked:
                {
                    backend.checkPermission()
                }
            }
            CustomButton
            {
                id:buttonCheckBluetoothOn
                setButtonText: "Check Bluetooth"
                setWidth: 150
                anchors.horizontalCenter: parent.horizontalCenter
                setButtonFontsize: 15
                setHeight: 50
                setButtonBackColor: "cyan"
                setButtonFontColor: "black"
                setButtonBorderColor: "transparent"
                setVisible: false
                onButtonClicked:
                {
                    backend.isBluetoothOn()
                }
            }
        }
    }



    function setConnectionStatus(statusText,statusColor="")
    {
        connectionStatusLabel.text = statusText;

        if(statusColor==="")//deduce color
            statusColor = Script.convertConnectionStatusToColor(backend.btStatus)

        connectionStatusBackground.color = statusColor
        var darkerColor = Script.darkenColor(statusColor,40)
        // console.log("statusColor=", statusColor, " darker color=",darkerColor, "R:",darkerColor[0], "G:",darkerColor[1], "B:",darkerColor[2])
        phoneControl.setStatusBarColor(darkerColor[0], darkerColor[1], darkerColor[2]);
    }

    Connections
    {
        target:backend
        onBtStatusChanged:
        {
            console.log("bt status changed: " + backend.btStatus)
            switch(backend.btStatus)
            {
                case -1: rootWindow.setConnectionStatus("Unknown"); break;
                case 10: rootWindow.setConnectionStatus("Adaptor Not Found");break;
                case 11: rootWindow.setConnectionStatus("Failed");break;

                case 20:
                {
                    rootWindow.setConnectionStatus("Permission Denied");
                    popupBluetoothError.show("Go to settings give permission \nbluetooth (nearby devices) to app",true)
                }break;
                case 21:
                    rootWindow.setConnectionStatus("Asking Permission");
                    popupBluetoothError.show("Give bluetooth permission",true)
                    break;
                case 22:
                    rootWindow.setConnectionStatus("Permission Granted");
                    backend.isBluetoothOn() //lets check bluetooth is on/off
                    break;

                case 23:
                    rootWindow.setConnectionStatus("Bluetooth is Off")
                    popupBluetoothError.show("Turn on your bluetooth",false,true)
                    break;

                case 24: rootWindow.setConnectionStatus("bluetooth is on"); //bluetooth is ON. & permission has granted
                    popupBluetoothError.hide()
                    break;

                case 30:
                    rootWindow.setConnectionStatus("Disconnected")
                    mainStack.popToIndex(0) //go to initItem (ConnectionPage)
                    // because it has already disconnected.. (maybe host/device-bluetooth/bluetooth=permission turned off)
                    break;

                case 31: rootWindow.setConnectionStatus("Scanning");break;
                case 32: rootWindow.setConnectionStatus("Scan Canceled");break;
                case 33: rootWindow.setConnectionStatus("Scan Done");break;


                case 34:
                    rootWindow.setConnectionStatus("Connecting to "
                                                    + (settings.value["recentDevice/name"].length>7 ?  settings.value["recentDevice/name"].substring(0, 7)+".." : settings.value["recentDevice/name"]))
                    break;


                case 35:
                    rootWindow.setConnectionStatus("Connected to "
                                                    + (settings.value["recentDevice/name"].length>7 ?  settings.value["recentDevice/name"].substring(0, 7)+".." : settings.value["recentDevice/name"]))
                    mainStack.push("Pages/ControlPage.qml")
                    break;

                default:
                {
                    rootWindow.setConnectionStatus("Something Bad :"+backend.btStatus)

                }
            }

        }
    }


    Component.onCompleted:
    {
        console.log("completed")
    }


}
