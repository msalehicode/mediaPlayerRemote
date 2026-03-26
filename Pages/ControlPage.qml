import QtQuick
import QtQuick.Controls
import "../CustomComponents"
import "scripts.js" as Script
Page
{
    // anchors.fill: parent
    id:root
    property string connectionMode: "bluetooth" //or wifi

    header: Rectangle
    {
        color:"black"
        width:parent.width
        height:50
        Label
        {
            text:"Control Page"
            color:"white"
            font.pixelSize: 20
            anchors.centerIn: parent
        }
        Label
        {
            id:connectionStatus
            text: "Status: " + Script.convertBtStatusToString(backend.btStatus)
            color:"white"
            font.pixelSize: 15
        }
    }


    function changeVolume(value)
    {
        console.log("chaning volume.. val=",value)
    }

    function changeBrightness(value)
    {
        console.log("chaning bgithness val=",value)
    }

    Rectangle
    {
        id: baseComponents
        color:"grey"
        anchors.fill: parent
        Column
        {
            id:topButtons
            width: parent.width
            height: implicitHeight
            spacing: 10
            Rectangle
            {
                color: baseComponents.color
                width: parent.width/2
                anchors.horizontalCenter: parent.horizontalCenter
                height: 200
                Label
                {
                    text: "file name jiofrejgiojreiogjthjiothjiortjhio giorioj ame.mp4"//backend.currentFileName
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    font.pixelSize: 15
                    color:"white"
                    wrapMode: "WrapAnywhere"
                }
            }

            Rectangle
            {
                color:"transparent"
                clip: true
                border.color: "red"
                border.width: 3
                width: 200
                height: 200
                radius: 200
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle
                {
                    anchors.fill: parent
                    gradient: Gradient
                    {
                            GradientStop { position: 0.0; color: "#ff0000" }   // top
                            GradientStop { position: 1.0; color: "#0000ff" }   // bottom
                    }
                    opacity: 0.5
                    radius: parent.radius
                }

                CustomButton
                {
                    setButtonText: "↶15 "
                    setWidth: 70
                    setButtonFontsize: 15
                    setHeight: 50
                    setButtonBackColor: "transparent"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    // anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    onButtonClicked:
                    {
                        console.log("seek back 15s")
                    }
                }

                CustomButton
                {
                    setButtonText: "15↷"
                    setWidth: 70
                    setHeight: 50
                    setButtonFontsize: 15
                    setButtonBackColor: "transparent"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    onButtonClicked:
                    {
                        console.log("seek forth 15s")
                    }
                }



                CustomButton
                {
                    setButtonText: "s+"
                    setWidth: 70
                    setButtonFontsize: 20
                    setHeight: 50
                    setButtonBackColor: "transparent"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    // anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    onButtonClicked:
                    {
                        console.log("seek back 15s")
                    }
                }

                CustomButton
                {
                    setButtonText: "s-"
                    setWidth: 70
                    setHeight: 50
                    setButtonFontsize: 20
                    setButtonBackColor: "transparent"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    onButtonClicked:
                    {
                        console.log("seek forth 15s")
                    }
                }


                Rectangle
                {
                    color:"transparent"
                    border.color: "red"
                    border.width: 3
                    width: parent.width/2
                    height: parent.height/2
                    radius: 200
                    anchors.centerIn: parent

                    CustomButton
                    {
                        setButtonText: "2x"
                        setWidth: 70
                        setHeight: 50
                        setButtonFontsize: 20
                        setBold:true
                        setButtonBackColor: "transparent"
                        setButtonFontColor: "white"
                        setButtonBorderColor: "transparent"
                        onButtonHeld: console.log("speeding up 2x")
                        anchors.centerIn: parent
                        onButtonReleasesd: console.log("stop speedin up")
                    }

                    // CustomButton
                    // {
                    //     setButtonText: "Rotate"
                    //     setWidth: 70
                    //     setHeight: 50
                    //     setButtonBackColor: "black"
                    //     setButtonFontColor: "white"
                    //     setButtonBorderColor: "transparent"
                    //     anchors.centerIn: parent
                    //     onButtonClicked:
                    //     {
                    //         console.log("poweroff/on")
                    //     }
                    // }
                }
            }



        }

        Column
        {
            id:leftColumn
            width: 60
            height: implicitHeight
            spacing: 30
            anchors
            {
                left: parent.left
                leftMargin: 10
            }
            CustomButton
            {
                setButtonText: "Power off"
                setWidth: 70
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setButtonBorderColor: "transparent"
                onButtonClicked:
                {
                    console.log("poweroff/on")
                }
            }

            CustomButton
            {
                setButtonText: "SNS"
                setWidth: 70
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setButtonBorderColor: "transparent"
                onButtonClicked:
                {
                    console.log("poweroff/on")
                }
            }
            Rectangle {
                id: changeBrightnessBase
                width: 60
                height: 100
                color: "black"
                property real volume: 0
                property real maxDy: 300
                property real minDy: -300

                Rectangle
                {
                    id:indicatorBrightness
                    color: "yellow"
                    width: parent.width
                    height: changeBrightnessBase.volume*100
                    anchors.bottom: parent.bottom
                    opacity: 0.7
                }

                Label
                {
                    text:"+"
                    anchors.horizontalCenter: parent.horizontalCenter
                    color:"white"
                    font.pixelSize: 30
                }
                Label
                {
                    text:"bright"
                    anchors.centerIn: parent
                    color:"white"
                    font.pixelSize: 15
                }
                Label
                {
                    text:"-"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color:"white"
                    font.pixelSize: 30
                }

                Rectangle {
                    id: brightnessControlArea
                    anchors.fill: parent
                    width: parent.width / 8
                    color: "transparent"

                    property real cumulativeDy: 0
                    property real startY: 0

                    MouseArea {
                        anchors.fill: parent
                        drag.target: null

                        onPressed: (mouse) => {
                            brightnessControlArea.cumulativeDy = 0
                            brightnessControlArea.startY = mouse.y
                        }

                        onPositionChanged: (mouse) => {
                            let delta = mouse.y - brightnessControlArea.startY
                            brightnessControlArea.cumulativeDy += delta
                            brightnessControlArea.startY = mouse.y

                            // clamp
                            brightnessControlArea.cumulativeDy = Math.max(
                                changeBrightnessBase.minDy,
                                Math.min(changeBrightnessBase.maxDy, brightnessControlArea.cumulativeDy)
                            )

                            // reversed normalized value 0..1
                            let value =
                                1 - ((brightnessControlArea.cumulativeDy - changeBrightnessBase.minDy) /
                                    (changeBrightnessBase.maxDy - changeBrightnessBase.minDy))

                            changeBrightnessBase.volume = value
                            changeBrightness(value)
                        }
                    }
                }

            }



            CustomButton
            {
                setButtonText: "settings"
                setWidth: 60
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setRadius: 10
                setButtonBorderColor: "transparent"
                onButtonClicked:
                {
                    console.log("open settings")
                }
            }
        }
        Column
        {
            id:rightColumn
            width: 60
            height: implicitHeight
            anchors
            {
                right: parent.right
                rightMargin: 10
            }
            spacing: 30
            CustomButton
            {
                setButtonText: "Mute"
                setWidth: 70
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setButtonBorderColor: "transparent"
                anchors.right: parent.right
                onButtonClicked:
                {
                    console.log("poweroff/on")
                }
            }
            CustomButton
            {
                setButtonText: "fullscreen"
                setWidth: 70
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setButtonBorderColor: "transparent"
                anchors.right: parent.right
                onButtonClicked:
                {
                    console.log("fullscreen/normal")
                }
            }


            Rectangle {
                id: changeVolumeBase
                width: 60
                height: 100
                color: "black"
                property real volume: 0
                property real maxDy: 300
                property real minDy: -300

                Rectangle
                {
                    id:indicatorVolume
                    color: "green"
                    width: parent.width
                    height: changeVolumeBase.volume*100
                    anchors.bottom: parent.bottom
                    opacity: 0.7
                }

                Label
                {
                    text:"+"
                    anchors.horizontalCenter: parent.horizontalCenter
                    color:"white"
                    font.pixelSize: 30
                }
                Label
                {
                    text:"vol"
                    anchors.centerIn: parent
                    color:"white"
                    font.pixelSize: 15
                }
                Label
                {
                    text:"-"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color:"white"
                    font.pixelSize: 30
                }

                Rectangle {
                    id: volumeControlArea
                    anchors.fill: parent
                    width: parent.width / 8
                    color: "transparent"

                    property real cumulativeDy: 0
                    property real startY: 0

                    MouseArea {
                        anchors.fill: parent
                        drag.target: null

                        onPressed: (mouse) => {
                            volumeControlArea.cumulativeDy = 0
                            volumeControlArea.startY = mouse.y
                        }

                        onPositionChanged: (mouse) => {
                            let delta = mouse.y - volumeControlArea.startY
                            volumeControlArea.cumulativeDy += delta
                            volumeControlArea.startY = mouse.y

                            // clamp
                            volumeControlArea.cumulativeDy = Math.max(
                                changeVolumeBase.minDy,
                                Math.min(changeVolumeBase.maxDy, volumeControlArea.cumulativeDy)
                            )

                            // reversed normalized value 0..1
                            let value =
                                1 - ((volumeControlArea.cumulativeDy - changeVolumeBase.minDy) /
                                    (changeVolumeBase.maxDy - changeVolumeBase.minDy))

                            changeVolumeBase.volume = value
                            changeVolume(value)
                        }
                    }
                }

            }


            CustomButton
            {
                setButtonText: "playlist"
                setWidth: 60
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: "white"
                setButtonBorderColor: "transparent"
                onButtonClicked:
                {
                    console.log("open playlist dialog")
                }
            }

        }

        Column
        {
            id:centerButtons
            width: parent.width
            height:implicitHeight
            anchors
            {
                bottom:parent.bottom
                bottomMargin:implicitHeight/2
            }

            spacing: 30

            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                CustomButton
                {
                    setButtonText: "shuffle"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    onButtonClicked:
                    {
                        console.log("shuffle")
                    }
                }

                Dial {
                    id: rotationDial
                    from: 0
                    to: 360
                    value: 0 //settings.value["Media/rotationAngle"] // 0 = normal, 90 = rotated right, 180 = upside down, 270 = rotated left
                    stepSize: 1
                    width: 45
                    height: 45
                    onValueChanged:
                    {
                        // settings.setSetting("Media/rotationAngle",value)
                        // videoOutput.rotation=value
                    }

                }

                CustomButton
                {
                    setButtonText: "repeat"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    onButtonClicked:
                    {
                        console.log("repeat")
                    }
                }
            }




            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                CustomButton
                {
                    setButtonText: "<"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    onButtonClicked:
                    {
                        console.log("previous track")
                    }
                }


                CustomButton
                {
                    setButtonText: "▶"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    onButtonClicked:
                    {
                        console.log("play/pause")
                    }
                }

                CustomButton
                {
                    setButtonText: ">"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: "white"
                    setButtonBorderColor: "transparent"
                    onButtonClicked:
                    {
                        console.log("next track")
                    }
                }
            }

            // Slider
            // {
            //     width: parent.width
            //     height:60
            // }


            Rectangle
            {
                id:baseMediaSlider
                color: "black"
                width: parent.width
                height:60
                Row
                {
                    anchors.fill: parent
                    Label
                    {
                        text:"1:20:33"
                        color:"white"
                        font.pixelSize: 15
                        anchors
                        {
                            left:parent.left
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    CustomSlider {
                        id: mediaSlider
                        backgroundColor: "#41CD52"
                        backgroundOpacity: 0.8// : 0.2
                        width: parent.width/1.5
                        height: 50
                        enabled: root.mediaPlayer.seekable
                        to: 1.0
                        // value: root.mediaPlayer.position / root.mediaPlayer.duration

                        anchors.centerIn: parent
                        // onMoved: root.mediaPlayer.setPosition(value * root.mediaPlayer.duration)
                    }
                    Label
                    {
                        text:"20:33"
                        color:"white"
                        font.pixelSize: 15
                        anchors
                        {
                            right:parent.right
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }


        }

    }
}
