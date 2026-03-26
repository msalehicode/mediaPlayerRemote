import QtQuick
import QtQuick.Controls
import "../CustomComponents"
import "scripts.js" as Script
Page
{
    anchors.fill: parent

    header: Rectangle
    {
        color:"black"
        width:parent.width
        height:50
        Label
        {
            id:headerTitle
            text:"Connection Page"
            color:"white"
            font.pixelSize: 30
            anchors.centerIn: parent
        }
    }

    SwipeView {
        id: view

        currentIndex: 0
        anchors.fill: parent

        Item
        {
            id:bluetoothItem
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
                        id:connectionStatus
                        font.pixelSize: 20
                        color: "white"
                        font.bold: true
                        text: "Status: " + Script.convertBtStatusToString(backend.btStatus)
                    }

                    Row
                    {
                        width:parent.width
                        height:60
                        spacing:20
                        CustomButton
                        {
                            setButtonText: "Start Scan"
                            setWidth: 70
                            setButtonFontsize: 15
                            setHeight: 50
                            setButtonBackColor: "cyan"
                            setButtonFontColor: "black"
                            setButtonBorderColor: "transparent"
                            onButtonClicked:
                            {
                                backend.run(true)
                            }
                        }
                        CustomButton
                        {
                            setButtonText: "Stop Scan"
                            setWidth: 70
                            setButtonFontsize: 15
                            setHeight: 50
                            setButtonBackColor: "cyan"
                            setButtonFontColor: "black"
                            setButtonBorderColor: "transparent"
                            onButtonClicked:
                            {
                                backend.run(false)
                            }
                        }
                    }


                    Label
                    {
                        text:"found devices:"
                        font.pixelSize: 20
                        color:"white"
                    }
                    Rectangle
                    {
                        color:"grey"
                        width:parent.width
                        height:200


                        ListView
                        {
                            anchors.fill: parent
                            model: backend.devices
                            spacing: 10
                            delegate: Rectangle
                            {
                                color:"black"
                                width:parent.width/1.5
                                anchors.horizontalCenter: parent.horizontalCenter
                                height:30
                                Label
                                {
                                    text:modelData
                                    font.pixelSize: 20
                                    color: "white"
                                    anchors.centerIn: parent
                                }
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        backend.connectToHost(modelData)
                                    }
                                }
                            }
                        }
                    }


                    Label
                    {
                        text:"received commands:"
                        font.pixelSize: 20
                        color:"white"
                    }
                    Rectangle
                    {
                        color:"green"
                        width:parent.width
                        height:200
                        Label
                        {
                            text:backend.receivedMessage
                            font.pixelSize: 20
                            color:"white"
                        }
                    }

                    // custom
                    CustomTextInput
                    {
                        id:textInput
                        setWidth: parent.width
                        setHeight: 70
                        setBgColor: "purple"
                        setTitleText: "Enter command:"
                        CustomButton
                        {
                            setWidth: parent.width/5
                            setHeight: parent.height/2
                            anchors
                            {
                                right:parent.right
                                verticalCenter: parent.verticalCenter
                            }

                            setButtonText: "Send"
                            setButtonBackColor: "black"
                            setButtonFontColor: "red"
                            onButtonClicked:
                            {
                                backend.send(textInput.theText)
                                textInput.theText=""
                            }

                        }
                    }


                }
            }

        }

        Item
        {
            id:wifiItem
            Rectangle
            {
                id:wifiBase
                anchors.fill: parent
                color:"grey"
                Label
                {
                    text:"Coming soon..."
                    font.pixelSize: 35
                    color: "white"
                    anchors.centerIn: parent
                }
            }
        }
        onCurrentIndexChanged:
        {
            switch(currentIndex)
            {
            case 0:
                headerTitle.text = "bluetooth connection"
                break;
            case 1:
                headerTitle.text = "wifi connection"
                break;
            default:
                headerTitle.text = "connection"
            }

        }
    }

    PageIndicator {
        id: indicator

        count: view.count
        currentIndex: view.currentIndex

        anchors.bottom: view.bottom
        anchors.bottomMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
    }

}
