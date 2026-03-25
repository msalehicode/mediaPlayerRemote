import QtQuick
import QtQuick.Controls

Page
{
    // anchors.fill: parent

    header: Rectangle
    {
        color:"black"
        width:parent.width
        height:50
        Label
        {
            text:"Control Page"
            color:"white"
            font.pixelSize: 30
            anchors.centerIn: parent
        }
    }

    Rectangle
    {
        color:"#3c3c3c"
        anchors.fill: parent

    }
}
