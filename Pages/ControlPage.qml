import QtQuick
import QtQuick.Controls
import "scripts.js" as Script
import MyCommands //enum from CommandHandler. call enum like:  Command.Something
import QtQuick.Layouts
import "../CustomComponents"
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
        Item
        {
            AdvanceControl
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
        spacing: 20
        delegate: Rectangle
        {
            width:(root.width/view.count)-indicator.spacing*view.count
            radius:50
            height: 50
            color:index===indicator.currentIndex ? "white" : "grey"
            Image
            {
                width: 30
                height: 30
                source: switch(index)
                        {
                        case 0: return "../icons/universal-access.svg"
                        case 1: return "../icons/closed-captioning.svg"
                        case 2: return "../icons/cubes.svg"
                        }

                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: view.currentIndex =index
            }
        }
    }
    Component.onCompleted:
    {
        console.log("view.count*root.width/3",(view.count*(root.width/3)))
        console.log("view.count",view.count)
        console.log("root width",root.width , " /3=",root.width/3)
    }

}
