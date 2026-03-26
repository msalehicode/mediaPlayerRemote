import QtQuick
import QtQuick.Controls
import "./Pages"
import "./CustomComponents"

Window {
    width: 380
    height: 840
    visible: true
    title: qsTr("MediaPlayer Android Remote")

Rectangle
{
    anchors.fill: parent
    color:"grey"

    // Button
    // {
    //     text:"back"
    //     visible: false
    //     onClicked:
    //     {
    //         // if(mainStack>0)
    //             mainStack.pop()
    //     }
    //     z:1000
    // }

    Label
    {
        text:"Main Page"
        color:"white"
        font.pixelSize: 30
        anchors.centerIn: parent
    }

    StackView
    {
        id:mainStack
        anchors.fill: parent
        // initialItem: controlPage
    }


    Rectangle
    {
        color:"crimson"
        id:bottomIndicator
        width:parent.width
        height:70
        anchors.bottom: parent.bottom
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
                onButtonClicked:
                {
                    mainStack.push("Pages/ConnectionPage.qml")
                }
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
                onButtonClicked:
                {
                    mainStack.push("Pages/ControlPage.qml")
                }
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
                onButtonClicked:
                {
                    mainStack.push("Pages/SettingsPage.qml")
                }
            }
        }
    }


}





    Component.onCompleted:
    {
        console.log("completed")
    }


}
