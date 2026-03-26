import QtQuick
import QtQuick.Controls
import "../CustomComponents"
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
                    Row
                    {
                        width:parent.width
                        height:60
                        spacing:20
                        Button
                        {
                            text:"start scan"
                            onClicked: backend.run(true)
                        }
                        Button
                        {
                            text:"stop scan"
                            onClicked: backend.run(false)
                        }
                    }

                    Rectangle
                    {
                        color:"grey"
                        width:parent.width
                        height:200
                        Label
                        {
                            text:"found devices:"
                            font.pixelSize: 20
                            color:"white"
                        }

                        ListView
                        {
                            anchors.fill: parent
                            // model: backend.devices
                            spacing: 10
                            delegate: Rectangle
                            {
                                color:"blue"
                                width:parent.width
                                height:30
                                Label
                                {
                                    text:modelData
                                    font.pixelSize: 20
                                }
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        console.log("clicked on ", modelData)
                                    }
                                }
                            }
                        }
                    }

                    Rectangle
                    {
                        color:"green"
                        width:parent.width
                        height:200
                        Label
                        {
                            text:"message"//+backend.receivedMessage
                            font.pixelSize: 20
                            color:"white"
                        }
                    }

                    // custom
                    CustomTextInput
                    {
                        setWidth: parent.width
                        setHeight: 70
                        setBgColor: "purple"
                        setTitleText: "Enter Message:"
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
