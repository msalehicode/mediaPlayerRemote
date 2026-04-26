import QtQuick
import MyCommands //enum from CommandHandler. call enum like:  Command.Something
import QtQuick.Controls
import "../CustomComponents"
import "scripts.js" as Script

Item
{
    anchors.fill: parent
    property int iconW: 25;
    property int iconH: 25;

    Rectangle
    {
        id: controlBase
        color:"navy"
        anchors.fill: parent
        Column
        {
            id:topButtons
            width: parent.width
            height: implicitHeight
            spacing: 10
            Rectangle
            {
                color: controlBase.color
                width: parent.width/2
                anchors.horizontalCenter: parent.horizontalCenter
                height: 200
                Label
                {
                    id:currentFileNameLabel
                    text: "current file name"
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    font.pixelSize: 15
                    color:q_fontColor
                    wrapMode: "WrapAnywhere"
                }
            }

            Rectangle
            {
                id:baseCircularControl
                color:"transparent"
                clip: true
                border.color: "yellow"
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

                CustomButtonWithIcon
                {
                    id:backwardButton
                    setIconHeight: iconH
                    setIconWidth: iconW
                    setIconSource: "icons/Forward_icon_Dark.png"
                    setIconFlipHorizontal: true
                    setButtonText: "-15s"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "transparent"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    onButtonClicked: backend.send(Command.SeekBack,"");
                }

                CustomButtonWithIcon
                {
                    id:forwardButton
                    setIconHeight: iconH
                    setIconWidth: iconW
                    setIconSource: "icons/Forward_icon_Dark.png"
                    setButtonText: "+15s"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "transparent"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    onButtonClicked: backend.send(Command.SeekForth,"");
                }



                CustomButtonWithIcon
                {
                    id:speedupButton
                    setIconHeight: iconH
                    setIconWidth: iconW
                    setIconSource: "icons/Rate_Icon_Dark.svg"
                    setButtonText: "+0.5"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "transparent"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onButtonClicked: backend.send(Command.SpeedUp,"");
                }

                CustomButtonWithIcon
                {
                    id:speeddownButton
                    setIconHeight: iconH
                    setIconWidth: iconW
                    setIconSource: "icons/Rate_Icon_Dark.svg"
                    setButtonText: "-0.5"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "transparent"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    onButtonClicked: backend.send(Command.SpeedDown,"");
                }


                Rectangle
                {
                    id:holdToSpeedupButtonBase
                    color:"transparent"
                    border.color: "red"
                    border.width: 3
                    width: parent.width/2
                    height: parent.height/2
                    radius: 200
                    anchors.centerIn: parent

                    CustomButton
                    {
                        id:holdToSpeedupButton
                        setButtonText: "2x"
                        setWidth: 70
                        setHeight: 50
                        setButtonFontsize: 20
                        setBold:true
                        setButtonBackColor: "transparent"
                        setButtonFontColor: q_fontColor
                        setButtonBorderColor: "transparent"
                        onButtonHeld: backend.send(Command.StartSpeeding,"");
                        anchors.centerIn: parent
                        onButtonReleasesd: backend.send(Command.StopSpeeding,"");
                    }

                }
            }



        }

        // ------------------------ LEFT
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
            CustomButtonWithIcon
            {
                id:muteButton
                setButtonText: "Mute"
                setIconHeight: iconH
                setIconWidth: iconW
                setIconSource: "icons/Volume_Icon_Dark.svg"
                setWidth: 70
                setHeight: 90
                setButtonBackColor: "black"
                setButtonFontColor: q_fontColor
                setButtonBorderColor: "transparent"
                anchors.right: parent.right
                onButtonClicked: backend.send(Command.MuteToggle,"");
            }

            Rectangle
            {
                id:brigthnessBase
                width:50
                height:100
                color:"black"
                Row
                {
                    spacing:5
                    Column
                    {
                        spacing: 5
                        CustomButton
                        {
                            id:brightnessupButton
                            setButtonText: "+"
                            setWidth: 60
                            setHeight: 50
                            setButtonBackColor: "black"
                            setButtonFontColor: q_fontColor
                            setRadius: 10
                            setButtonBorderColor: "transparent"
                            onButtonClicked: backend.send(Command.BrightnessUp,"");
                        }
                        CustomButton
                        {
                            id:brightnessdownButton
                            setButtonText: "-"
                            setWidth: 60
                            setHeight: 50
                            setButtonBackColor: "black"
                            setButtonFontColor: q_fontColor
                            setRadius: 10
                            setButtonBorderColor: "transparent"
                            onButtonClicked: backend.send(Command.BrightnessDown,"");
                        }
                    }
                    Rectangle {
                        id: brightnessIndicator
                        width: 20
                        height: 100
                        color: "#888"
                        radius: 8
                        clip:true

                        Rectangle {
                            width: parent.width
                            height: brightnessIndicator.height //* (1.0 - root.brightness)
                            color: "#ff0"
                        }
                    }

                }


            }
        }


        // ------------------------ RIGHT
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

            CustomButtonWithIcon
            {
                id:fullscreenButton
                setIconHeight: iconH
                setIconWidth: iconW
                setIconSource: "icons/FullScreen_Icon_Dark.svg"
                setButtonText: "fullscreen"
                setWidth: 70
                setHeight: 50
                setButtonBackColor: "black"
                setButtonFontColor: q_fontColor
                setButtonBorderColor: "transparent"
                anchors.right: parent.right
                onButtonClicked: backend.send(Command.FullscreenToggle,"");
            }



            Rectangle
            {
                id:volumeBase
                width:50
                height:100
                color:"black"
                Row
                {
                    spacing:5
                    Rectangle {
                        id: volumeIndicator
                        width: 20
                        height: 100
                        color: "#888"
                        radius: 8
                        clip:true

                        Rectangle {
                            width: parent.width
                            height: volumeIndicator.height //* root.volume
                            color: "#0f0"
                        }
                    }
                    Column
                    {
                        spacing: 5
                        CustomButton
                        {
                            id:volumeupButton
                            setButtonText: "+"
                            setWidth: 60
                            setHeight: 50
                            setButtonBackColor: "black"
                            setButtonFontColor: q_fontColor
                            setRadius: 10
                            setButtonBorderColor: "transparent"
                            onButtonClicked: backend.send(Command.VolumeUp,"");
                        }
                        CustomButton
                        {
                            id:volumedownButton
                            setButtonText: "-"
                            setWidth: 60
                            setHeight: 50
                            setButtonBackColor: "black"
                            setButtonFontColor: q_fontColor
                            setRadius: 10
                            setButtonBorderColor: "transparent"
                            onButtonClicked: backend.send(Command.VolumeDown,"");
                        }
                    }


                }

            }




            // Label
            // {
            //     text:"speed of hold to speedup:"
            //     color:q_fontColor
            // }
            // SpinBox {
            //     id: speedOfholdToSpeedup
            //     width: 50
            //     height:25
            //     from: 0
            //     to: 50
            // }


            Label
            {
                text:"mprisControl:"
                color:q_fontColor
            }
            CustomSwitch
            {
                id: mprisControl
                onSwitchClicked: backend.send(Command.MprisControlToggle, switchStatus)
            }

            Label
            {
                text:"steady on audioOutput:"
                color:q_fontColor
            }
            CustomSwitch
            {
                id: steadyOnAudioOutput
                onSwitchClicked: backend.send(Command.SteadyAudioDeviceToggle, switchStatus)
            }

            Label
            {
                text:"custom Cursor:"
                color:q_fontColor
            }
            CustomSwitch
            {
                id: customCursor
                onSwitchClicked: backend.send(Command.CustomCursorStatusToggle, switchStatus)
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
                CustomButtonWithIcon
                {
                    id:shuffleButton
                    setIconHeight: iconH
                    setIconWidth: iconW
                    setIconSource: "icons/Shuffle_Icon_Dark.svg"
                    setButtonText: "shuffle"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    onButtonClicked: backend.send(Command.ShuffleToggle,"");
                }

                Dial
                {
                    id: rotationDial
                    from: 0
                    to: 360
                    value: 0
                    stepSize: 1
                    width: 45
                    height: 45
                    onValueChanged: backend.send(Command.ModifyRotation,value);
                }

                CustomButtonWithIcon
                {
                    id:loopButton
                    setIconHeight: iconH
                    setIconWidth: iconW
                    setIconSource: "icons/Loop_Icon_Dark.svg"
                    setButtonText: "repeat"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    onButtonClicked: backend.send(Command.RepeatToggle,"");
                }
            }




            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                CustomButtonWithIcon
                {
                    id:previousButton
                    setIconHeight: iconH
                    setIconWidth: iconW
                    setIconSource: "icons/Previous_Icon_Dark.svg"
                    setButtonText: "<"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    onButtonClicked: backend.send(Command.PreviousToggle,"");
                }


                CustomButtonWithIcon
                {
                    id:playPauseButton
                    setIconHeight: 50
                    setIconWidth: 50
                    setIconSource: "icons/Play_Icon.svg"
                    setButtonText: "play"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    onButtonClicked: backend.send(Command.PlayToggle,"");
                }

                CustomButtonWithIcon
                {
                    id:nextButton
                    setIconHeight: iconH
                    setIconWidth: iconW
                    setIconSource: "icons/Next_Icon_Dark.svg"
                    setButtonText: ">"
                    setWidth: 70
                    setHeight: 50
                    setButtonBackColor: "black"
                    setButtonFontColor: q_fontColor
                    setButtonBorderColor: "transparent"
                    onButtonClicked: backend.send(Command.NextToggle,"");
                }
            }


            Rectangle
            {
                id:baseMediaSlider
                visible: false
                color: "black"
                width: parent.width
                height:60
                property int mediaDuration:0;
                property int mediaCurrent:0;
                Label
                {
                    id:mediaTotalLengthLabel
                    text:"duration"
                    color: q_fontColor
                    font.pixelSize: 15
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
                CustomSlider {
                    id: mediaSlider
                    backgroundColor: "#41CD52"
                    backgroundOpacity: 0.8
                    width: parent.width/1.5
                    height: 50
                    enabled:true
                    to: 1.0
                    value: baseMediaSlider.mediaCurrent / baseMediaSlider.mediaDuration

                    anchors.centerIn: parent
                    onMoved:  backend.send(Command.ModifyPosition,(value * baseMediaSlider.mediaDuration));
                }
                Label
                {
                    id:mediaCurrentLengthLabel
                    text:"current"
                    color: q_fontColor
                    font.pixelSize: 15
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }


        }
    }


    function getTime(time : int) : string {
        const h = Math.floor(time / 3600000).toString()
        const m = Math.floor(time / 60000).toString()
        const s = Math.floor(time / 1000 - m * 60).toString()
        return `${h.padStart(2,'0')}:${m.padStart(2,'0')}:${s.padStart(2, '0')}`
    }
    Connections
    {
        target: backend
        onRemoteDataChanged: function(cmd,payload)
        {
            switch(cmd)
            {
                case Command.ModifyPosition: //current position changed!
                    payload=Script.asInt(payload)
                    if(payload>=0)
                    {
                        baseMediaSlider.mediaCurrent=payload; //save same no visual current
                        mediaCurrentLengthLabel.text=getTime(payload) //visual current like 1:20:00
                        baseMediaSlider.visible=true
                    }
                    else
                        baseMediaSlider.visible=false
                break;

                case Command.CurrentMediaMeta: //later include other metaData...

                    console.log("metadata received= ",payload)

                    var separatedArray = payload.split("`");

                    var filename = separatedArray[1];
                    var duration = separatedArray[2];

                    //make sure we have a proper file name
                    if(filename.length>0 && filename!=="current file name")
                        currentFileNameLabel.text=filename

                    //make sure duration is fine!
                    if(duration>=0)
                    {
                        baseMediaSlider.mediaDuration=duration; //save same no visual duration
                        mediaTotalLengthLabel.text=getTime(duration) //visual duration like 1:20:00
                        baseMediaSlider.visible=true
                    }
                    else
                        baseMediaSlider.visible=false


                    break;
                case Command.ModifyRotation:
                    rotationDial.value=Script.asInt(payload)
                    break;
                case Command.Play:
                    playPauseButton.setIconSource="icons/Play_Icon.svg";
                    break;
                case Command.Pause:
                    playPauseButton.setIconSource="icons/Stop_Icon.svg";
                    break;
                case Command.PlayToggle:
                    if(playPauseButton.setIconSource==="icons/Stop_Icon.svg")
                        playPauseButton.setIconSource="icons/Play_Icon.svg";
                    else
                        playPauseButton.setIconSource="icons/Stop_Icon.svg";
                    break;
                case Command.MprisControlToggle:
                    mprisControl.changeStatus(Script.asBool(payload))
                    break;

                case Command.SteadyAudioDeviceToggle:
                    steadyOnAudioOutput.changeStatus(Script.asBool(payload))
                    break;

                case Command.CustomCursorStatusToggle:
                    customCursor.changeStatus(Script.asBool(payload))
                    break;

                // case Command.BrightnessDown:
                //     brightnessIndicatorVolume.height=brightnessIndicatorBase.height * (1.0 - 0.10)
                //      break;
                // case Command.ModifyBrightness:
            }
        }
    }


}
