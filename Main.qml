import QtQuick
import QtQuick.Controls
import "./Pages"
import "./CustomComponents"
import "./Pages/scripts.js" as Script
import MyCommands //enum from CommandHandler. call enum like:  Command.Something

ApplicationWindow
{
    id:rootWindow;

    width: 380
    height: 840
    visible: true
    title: qsTr("MediaPlayer Android Remote")

    onClosing:
    {
        if(passwordBase.visible)//Dialog Password is shown. first hide it on next actions pop stack
        {
            passwordBase.cancelPassword();
            close.accepted = false;
        }
        else if(mainStack.depth>1)
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

    Rectangle
    {
        id: passwordBase
        anchors.fill: parent
        visible: false
        color:"black"
        Rectangle
        {
            color:"transparent"
            width: parent.width
            height: 222
            anchors.verticalCenter: parent.verticalCenter
            Column
            {
                width: parent.width/1.50
                height: parent.height
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter
                Label
                {
                    text:"Password Required"
                    font.pixelSize: 20
                    color:"white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                CustomTextInput
                {
                    id:enteredPassword
                    setTitleText: "Enter password"
                    setWidth: parent.width
                    setHeight: 60
                    setBgColor: "white"
                    setFontColor: "black"
                    onTheTextAccepted:passwordBase.sendPass()

                }
                Row
                {
                    spacing: 20
                    width: parent.width/1.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    CustomButton
                    {
                        setButtonText: "Cancel"
                        setWidth: 70
                        setHeight: 45
                        setButtonsBorderWidth:0
                        setBold:true
                        setButtonFontColor: "white"
                        setButtonBackColor: "red"
                        onButtonClicked:passwordBase.cancelPassword()
                    }
                    CustomButton
                    {
                        setButtonText: "Ok"
                        setWidth: 70
                        setHeight: 45
                        setButtonsBorderWidth:0
                        setBold:true
                        setButtonFontColor: "white"
                        setButtonBackColor: "green"
                        onButtonClicked:passwordBase.sendPass();
                    }

                }


            }



        }


        function cancelPassword()
        {
            passwordBase.visible=false;
            enteredPassword.clear()
            backend.disconnectFromHost();
        }
        function sendPass()
        {
            backend.send(Command.EnterPassword,enteredPassword.theText)
        }
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

                    //reset and hide passwordBase
                    passwordBase.cancelPassword();
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


        onShowPasswordDialog: //if server ask password, will emit this.
        {
            passwordBase.visible=true
        }

        onHidePasswordDialog: //password accepted.
        {
            passwordBase.visible=false
            enteredPassword.clear()
        }
        onWrongPassword:
        {
            enteredPassword.invalidInput("wrong password.");
        }
    }


    Component.onCompleted:
    {
        console.log("completed")
    }


}
