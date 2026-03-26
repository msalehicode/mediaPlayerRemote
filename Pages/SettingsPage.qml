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
            text:"Control"
            color:"white"
            font.pixelSize: 30
            anchors.centerIn: parent
        }
    }

    Rectangle
    {
        color:"grey"
        anchors.fill: parent
        Label
        {
            text:"Settings Page"
            color:"white"
            font.pixelSize: 30
            anchors.centerIn: parent
        }
    }
}
