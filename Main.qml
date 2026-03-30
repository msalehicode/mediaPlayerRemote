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


    // Settings
    // {
    //     id:appSettings
    //     category: "MyAppFavoritAddresses"

    //     property string deviceName;
    //     property string deviceAddress;
    // }


    header: Rectangle
    {
        color: Script.convertConnectionStatusToColor(backend.btStatus)
        width:parent.width
        visible: !backend.bluetoothIsOff
        height:30
        Row
        {
            width: parent.width/2
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
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
                color: "black"
                font.bold: true
                text: Script.convertBtStatusToString(backend.btStatus, settings.value["recentDevice/name"])
                anchors.verticalCenter: parent.verticalCenter
            }
            CustomButtonWithIcon
            {
                // setButtonText: "Retry"
                setWidth: 30
                setHeight: 30
                setRadius: 30
                pathFromComponentDire:false
                setIconSource: "icon/wifi.png"
                // setButtonFontsize: 15
                setVisible: (settings.value["recentDevice/name"].length<=0 ? false :
                                (backend.btStatus===35) ? false : true)
                setButtonBackColor: "transparent"
                // setButtonFontColor: "white"
                setButtonBorderColor: "black"
                anchors.verticalCenter: parent.verticalCenter
                onButtonClicked:
                {
                    // if(data.selectedConnectionModeIndex===0)
                        backend.reconnectToRecentDevice();
                    // else
                    // backend.connectToNetworkHost(...)
                }
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
        id:popupTurnOnBluetooth
        visible: backend.bluetoothIsOff
        anchors.fill: parent
        color:"red"
        Text {
            text: qsTr("Turn on bluetooth.")
            anchors.centerIn: parent
            color:"white"
            font.pixelSize: 30
            font.bold: true
        }
    }



    footer: Rectangle
    {
        id:bottomIndicator
        color:"crimson"
        width:parent.width
        visible: !backend.bluetoothIsOff
        height:70
        // anchors.bottom: parent.bottom
        Row
        {
            spacing: 10
            width: implicitWidth
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            CustomButton
            {
                setButtonText: "Connection"
                setWidth: 100
                setButtonFontsize: 15
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setButtonBorderColor: "black"
                // anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onButtonClicked: mainStack.push("Pages/ConnectionPage.qml")
            }
            CustomButton
            {
                setButtonText: "Control"
                setWidth: 100
                setButtonFontsize: 15
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setButtonBorderColor: "transparent"
                // anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onButtonClicked: mainStack.push("Pages/ControlPage.qml")
            }
            CustomButton
            {
                setButtonText: "Settings"
                setWidth: 100
                setButtonFontsize: 15
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setButtonBorderColor: "transparent"
                // anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onButtonClicked: mainStack.push("Pages/SettingsPage.qml")
            }
        }
    }



    Component.onCompleted:
    {
        console.log("completed")
    }


}
