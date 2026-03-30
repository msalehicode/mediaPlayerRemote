import QtQuick
import QtQuick.Controls
import "../CustomComponents"
import "scripts.js" as Script
Page
{
    anchors.fill: parent

    // readonly property var connectionModes: ["Bluetooth", "Network"]

    Rectangle
    {
        id:bluetoothBase
        color:"black"
        anchors.fill: parent

        Column
        {
            anchors.fill: parent
            spacing: 20
            Label
            {
                text:"Recent Connection:"
                font.pixelSize: 20
                color:"white"
            }
            Rectangle
            {
                id:recentDeviceConnectionBox
                color:"grey"
                width:parent.width/1.25
                anchors.horizontalCenter: parent.horizontalCenter
                visible: recentDeviceName.text!==""
                height:50
                radius:20
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
                    id:recentDeviceName
                    text: settings.value["recentDevice/name"]
                    font.pixelSize: 20
                    color: "white"
                    anchors.centerIn: parent
                }
                CustomButton
                {
                    setButtonText: "connect"
                    setWidth: 70
                    setButtonFontsize: 15
                    setHeight: 50
                    setButtonBackColor: "cyan"
                    setButtonFontColor: "black"
                    setButtonBorderColor: "transparent"
                    anchors.right: parent.right
                    onButtonClicked:
                    {
                        backend.reconnectToRecentDevice()
                    }
                }
            }


            CustomCollapsiblePanel
            {
                id:directConnectionPanel
                setWidth: parent.width/1.10
                anchors.horizontalCenter: parent.horizontalCenter
                setHeight:60
                setTitle: "Direct Connection:"
                setBgColorButton: "white"
                setTextColor:"black"
                setBgContent: "grey"
                setTextFontSize: 20
                setOpen: false
                setContentHeight: 170
                onCollapsed: directConnectionPanel.setHeight = setOpen ? setContentHeight+60 : 60

                Rectangle
                {
                    width:parent.width
                    height:300
                    color:"transparent"
                    Column
                    {
                        width: parent.width
                        height:parent.height
                        spacing:15
                        anchors
                        {
                            top:parent.top
                            topMargin:15
                        }


                        CustomTextInput
                        {
                            id:directConnectName
                            setWidth: parent.width/1.5
                            setHeight: 50
                            anchors.horizontalCenter: parent.horizontalCenter
                            setTitleText: "Enter custom name:"
                        }
                        Text
                        {
                            text:"Enter bluetooth address:"
                            color: "white"
                            height: 7
                            width: parent.width/1.25
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 20
                            font.bold: true
                            // anchors.verticalCenter: parent.verticalCenter
                        }
                        CustomTextInputForMacAddress
                        {
                            id:directConnectAddress
                            setWidth: parent.width/1.10
                            anchors.horizontalCenter: parent.horizontalCenter
                            setHeight: 50
                            CustomButton
                            {
                                setWidth: parent.width/5
                                setHeight: parent.height
                                anchors
                                {
                                    right:parent.right
                                    verticalCenter: parent.verticalCenter
                                }

                                setButtonText: "Connect"
                                setButtonBackColor: "black"
                                setButtonFontColor: "red"
                                onButtonClicked:
                                {
                                    var addr=directConnectAddress.enteredAddress.toUpperCase()
                                    console.log("direct address entered name:", directConnectName.theText, " address:" , addr)
                                    backend.connectToBluetoothByAddress(directConnectName.theText, addr)
                                    // directConnectAddress.enteredAddress=""
                                    // directConnectName.clear()
                                }

                            }
                        }


                    }

                }
            }


            CustomCollapsiblePanel
            {
                id:scanBluetoothPanel
                setWidth: parent.width/1.10
                setHeight: 60
                setTitle: "Scan Bluetooth"
                setBgColorButton: "white"
                setTextColor: "black"
                setBgContent: "grey"
                setTextFontSize: 20
                setOpen: true
                setContentHeight: 300
                anchors.horizontalCenter: parent.horizontalCenter
                onCollapsed: scanBluetoothPanel.setHeight = setOpen ? setContentHeight+60 : 60
                Rectangle
                {
                    width:parent.width
                    height:300
                    color:"transparent"
                    Column
                    {
                        width: parent.width
                        height:parent.height
                        spacing:30
                        anchors
                        {
                            top:parent.top
                            topMargin:15
                        }


                        Row
                        {
                            id:buttonsStarScanStopScan
                            width:parent.width/2
                            height:60
                            spacing:20

                            anchors.horizontalCenter: parent.horizontalCenter
                            CustomButton
                            {
                                setButtonText: "Start Scan"
                                setWidth: parent.width/2
                                setButtonFontsize: 15
                                setHeight: 50
                                setButtonBackColor: "cyan"
                                setButtonFontColor: "black"
                                setButtonBorderColor: "transparent"
                                onButtonClicked:
                                {
                                    backend.scan(true)
                                }
                            }
                            CustomButton
                            {
                                setButtonText: "Stop Scan"
                                setWidth: parent.width/2
                                setButtonFontsize: 15
                                setHeight: 50
                                setButtonBackColor: "cyan"
                                setButtonFontColor: "black"
                                setButtonBorderColor: "transparent"
                                onButtonClicked:
                                {
                                    backend.scan(false)
                                }
                            }
                        }

                        Label
                        {
                            id:labelFoundDevices
                            text:"found devices: (" + listViewFoundDevices.count + ")"
                            font.pixelSize: 20
                            color:"white"
                        }

                        Rectangle
                        {
                            id:baseFoundDevicesList
                            color:"white"
                            width:parent.width
                            height:200
                            clip:true

                            ListView
                            {
                                id:listViewFoundDevices
                                anchors.fill: parent
                                model: backend.devices
                                spacing: 10
                                delegate: Rectangle
                                {
                                    color:"black"
                                    width:parent.width/1.25
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    height:50
                                    Label
                                    {
                                        text:modelData
                                        font.pixelSize: 20
                                        color: "white"
                                        anchors.centerIn: parent
                                    }
                                    CustomButton
                                    {
                                        setButtonText: "connect"
                                        setWidth: 70
                                        setButtonFontsize: 15
                                        setHeight: 50
                                        setButtonBackColor: "cyan"
                                        setButtonFontColor: "black"
                                        setButtonBorderColor: "transparent"
                                        anchors.right: parent.right
                                        onButtonClicked:
                                        {
                                            backend.connectToBluetoothHost(modelData)
                                        }
                                    }
                                }

                            }
                        }

                    }
                }
            }

            // Label
            // {
            //     text:"received log:"
            //     font.pixelSize: 20
            //     color:"white"
            // }
            // Rectangle
            // {
            //     color:"green"
            //     width:parent.width
            //     height:200
            //     clip:true
            //     Label
            //     {
            //         text:backend.receivedMessage
            //         font.pixelSize: 20
            //         color:"white"
            //     }
            // }

            // custom
            // CustomTextInput
            // {
            //     id:textInput
            //     setWidth: parent.width
            //     setHeight: 70
            //     setBgColor: "purple"
            //     setTitleText: "custom command:"
            //     CustomButton
            //     {
            //         setWidth: parent.width/5
            //         setHeight: parent.height/2
            //         anchors
            //         {
            //             right:parent.right
            //             verticalCenter: parent.verticalCenter
            //         }

            //         setButtonText: "Send"
            //         setButtonBackColor: "black"
            //         setButtonFontColor: "red"
            //         onButtonClicked:
            //         {
            //             backend.send(textInput.theText)
            //             textInput.theText=""
            //         }

            //     }
            // }


        }
    }

}
