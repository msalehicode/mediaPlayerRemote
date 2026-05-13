import QtQuick
import QtQuick.Controls
import "scripts.js" as Script
import MyCommands //enum from CommandHandler. call enum like:  Command.Something
import "../CustomComponents"

Item {
    id:root
    anchors.fill: parent
    Rectangle
    {
        anchors.fill:parent
        color:"navy"

        Rectangle
        {
            id:baseETC
            color:"transparent"
            width: parent.width
            height:200

            Column
            {
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

        }

        CustomCollapsiblePanel
        {
            id:subtitleCorrectionPanel
            setWidth: 200
            setHeight: 50
            setOpen: true
            setTitle: "subtitle correction"
            setContentHeight: subtitleCorrection.height
            anchors.top:baseETC.bottom
            anchors.right: parent.right
            Rectangle
            {
                id:subtitleCorrection
                width: parent.width
                height: colSubtitleCorrection.implicitHeight
                color:"black"

                Column {
                    id:colSubtitleCorrection
                    Label {
                        text: "remove domains"
                        font.pixelSize: 12
                        color:  q_fontColor
                    }
                    CustomSwitch
                    {
                        id:subRemoveDomains
                        onSwitchClicked: backend.send(Command.SubRemoveDomainsToggle,switchStatus)
                    }

                    Label {
                        text: "ignore HTML tags"
                        font.pixelSize: 12
                        color:  q_fontColor
                    }
                    CustomSwitch
                    {
                        id:subIgnoreHTML
                        onSwitchClicked: backend.send(Command.SubIgnoreHtmlTagToggle,switchStatus)
                    }

                    Label {
                        text: "clean subtitle"
                        font.pixelSize: 12
                        color:  q_fontColor
                    }
                    CustomSwitch
                    {
                        id:subCleanSubtitle
                        onSwitchClicked: backend.send(Command.SubCleanSubtitleToggle,switchStatus)
                    }

                    Label {
                        text: "remove ExtraInfo"
                        font.pixelSize: 12
                        color:  q_fontColor
                    }
                    CustomSwitch
                    {
                        id:subRemoveExtraInfo
                        onSwitchClicked: backend.send(Command.SubRemoveExtraInfoToggle,switchStatus)
                    }

                }


            }
        }

        CustomCollapsiblePanel
        {
            id:snsPanel
            setWidth: 100
            setHeight: 50
            setTitle: "sns"
            setContentHeight: snsBox.height
            anchors.top: baseETC.bottom
            setOpen: true
            Rectangle
            {
                id:snsBox
                width: parent.width
                height: columnSNS.implicitHeight
                color:"black"
                Column
                {
                    id: columnSNS
                    spacing: 3
                    CustomSwitch
                    {
                        id: snsCheckbox
                        onSwitchClicked: backend.send(Command.SNSToggle, switchStatus)
                    }

                    Label
                    {
                        id:snsSpeedLabel
                        text:"speed"
                        color:q_fontColor
                        visible: false
                    }
                    SpinBox {
                        id:snsSpeedSpinBox
                        width: 50
                        height:25
                        from: 0
                        to: 50
                        visible: false
                        onValueChanged: backend.send(Command.SNSspeed, value)
                    }

                    Label
                    {
                        id:snsBeforeLabel
                        text:"before"
                        color:q_fontColor
                        visible: false
                    }
                    SpinBox {
                        id: snsOffsetBeforeSubtitle
                        width: 50
                        height:25
                        from: 0
                        to: 50
                        visible: false
                        //has loop on initial
                        // onValueChanged: backend.send(Command.SNSsecBeforeSpeedup, value)
                    }


                    Label
                    {
                        id:snsAfterLabel
                        text:"after"
                        color:q_fontColor
                        visible: false
                    }

                    SpinBox {
                        id: snsOffsetAfterSubtitle
                        width: 50
                        height:25
                        from: 0
                        to: 50
                        visible: false
                        //has loop on initial
                        // onValueChanged: backend.send(Command.SNSsecAfterSpeedup, value)
                    }

                }
            }
        }





    }

    Connections
    {
        target: backend
        onRemoteDataChanged: function(cmd,payload)
        {
            switch(cmd)
            {
            case Command.MprisControlToggle:
                mprisControl.changeStatus(Script.asBool(payload))
                break;

            case Command.SteadyAudioDeviceToggle:
                steadyOnAudioOutput.changeStatus(Script.asBool(payload))
                break;

            case Command.CustomCursorStatusToggle:
                customCursor.changeStatus(Script.asBool(payload))
                break;


            case Command.SNSToggle:
                var status=Script.asBool(payload);
                snsCheckbox.changeStatus(status)
                snsOffsetAfterSubtitle.visible=status
                snsOffsetBeforeSubtitle.visible=status;
                snsSpeedSpinBox.visible=status;

                //labels
                snsSpeedLabel.visible=status
                snsAfterLabel.visible=status
                snsBeforeLabel.visible=status
                break;
            case Command.SNSspeed:
                snsSpeedSpinBox.value=Script.asInt(payload);
                break;
            case Command.SNSsecBeforeSpeedup:
                snsOffsetBeforeSubtitle.value=Script.asInt(payload)
                break;
            case Command.SNSsecAfterSpeedup:
                snsOffsetAfterSubtitle.value=Script.asInt(payload)
                break;


                //sub correction.
            case Command.SubRemoveDomainsToggle:
                subRemoveDomains.changeStatus(Script.asBool(payload))
                break;
            case Command.SubIgnoreHtmlTagToggle:
                subIgnoreHTML.changeStatus(Script.asBool(payload))
                break;
            case Command.SubCleanSubtitleToggle:
                subCleanSubtitle.changeStatus(Script.asBool(payload))
                break;
            case Command.SubRemoveExtraInfoToggle:
                subRemoveExtraInfo.changeStatus(Script.asBool(payload))
                break;
            }
        }
    }

}
