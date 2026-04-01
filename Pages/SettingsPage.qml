import QtQuick
import QtQuick.Controls

Page
{
    anchors.fill: parent
    objectName: "SettingsPage"

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
