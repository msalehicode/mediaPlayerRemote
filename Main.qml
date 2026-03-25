import QtQuick
import QtQuick.Controls
import "./Pages"

Window {
    width: 380
    height: 840
    visible: true
    title: qsTr("Bluetooth Remote")

Rectangle
{
    anchors.fill: parent
    color:"grey"

    // Button
    // {
    //     text:"back"
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

    Row
    {
        width:parent.width
        height:60
        anchors.bottom: parent.bottom
        spacing: 10
        Button
        {
            text:"connection"
            onClicked:
            {
                mainStack.push("Pages/ConnectionPage.qml")
            }
        }
        Button
        {
            text:"control"
            onClicked:
            {
                mainStack.push("Pages/ControlPage.qml")
            }
        }
        Button
        {
            text:"settings"
            onClicked:
            {
                mainStack.push("Pages/SettingsPage.qml")
            }
        }
    }

}





    Component.onCompleted:
    {
        console.log("completed")
        // mainStack.push("Pages/ConnectionPage.qml")

    }


}
