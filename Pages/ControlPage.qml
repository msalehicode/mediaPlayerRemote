import QtQuick
import QtQuick.Controls
import "scripts.js" as Script
import MyCommands //enum from CommandHandler. call enum like:  Command.Something
import QtQuick.Layouts
Page
{
    id:root
    objectName: "ControlPage"
    property color q_fontColor: "yellow"
    SwipeView {
        id: view

        currentIndex: 0
        anchors.fill: parent

        Item {
            GeneralControl{

            }
        }
        Item {
            SubtitleControl
            {

            }
        }
    }

    PageIndicator {
        id: indicator

        count: view.count
        currentIndex: view.currentIndex

        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        delegate: Rectangle
        {
            width:50
            height: 50
            color:index===indicator.currentIndex ? "red" : "blue"
            MouseArea
            {
                anchors.fill: parent
                onClicked: view.currentIndex =index

            }
        }
    }

}
