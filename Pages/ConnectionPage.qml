import QtQuick
import QtQuick.Controls

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
            text:"Connection Page"
            color:"white"
            font.pixelSize: 30
            anchors.centerIn: parent
        }
    }
    Rectangle
    {
        color:"black"
        anchors.fill: parent
        Label
        {
            text:"Connection Page"
            color:"white"
            font.pixelSize: 30
            anchors.centerIn: parent
        }
        Column
        {
            anchors.fill: parent
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


        }
    }
}
