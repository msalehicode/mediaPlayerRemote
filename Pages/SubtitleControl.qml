import QtQuick
import MyCommands //enum from CommandHandler. call enum like:  Command.Something
import QtQuick.Controls
import "../CustomComponents"
import "scripts.js" as Script
import QtQuick.Dialogs

Item
{
    anchors.fill: parent
    ColorDialog
    {
        id:sharedColorDialog
        property string key;
        onAccepted:
        {
            var commandCode=0;
            if(key==="Subtitle1/textColor")
                commandCode=Command.Subtitle1TextColor;

            else if(key==="Subtitle1/backColor")
                commandCode=Command.Subtitle1BackColor;

            else if(key==="Subtitle2/textColor")
                commandCode=Command.Subtitle2TextColor;

            else if(key==="Subtitle2/backColor")
                commandCode=Command.Subtitle2BackColor;

            backend.send(commandCode,selectedColor)
        }
    }


    Rectangle
    {
        color: "navy";
        anchors.fill: parent;

        Column
        {
            //sub1 left side
            id:sub1Base
            anchors.left:parent.left
            spacing: 5
            Rectangle
            {
                width:60
                height: 80
                color:"transparent"
                Column
                {
                    Label { text:"sub1 status"; color:q_fontColor }
                    CustomSwitch
                    {
                        id: sub1Status
                        onSwitchClicked: backend.send(Command.Subtitle1Status, switchStatus)
                    }
                }
            }
            Column
            {
                id:subtitle1Base
                Rectangle
                {
                    width:60
                    height: 80
                    color:"transparent"
                    Column
                    {
                        Label { text:"sub1 wordByWord status"; color:q_fontColor }
                        CustomSwitch
                        {
                            id: sub1WordByWord
                            onSwitchClicked: backend.send(Command.Subtitle1WordByWord, switchStatus)
                        }
                    }
                }

                Rectangle
                {
                    id:sub1WordByWordChunksBase
                    width:60
                    height: 80
                    color:"transparent"
                    Column
                    {
                        Label { id:sub1WordByWordChunksLabel; text:"sub1 WBW chunks"; color:q_fontColor; }
                        Rectangle
                        {
                            width: 200
                            height: 50
                            color:"transparent"
                            CustomAdvanceSlider
                            {
                                id:sub1WordByWordChunks
                                setWidth: 200
                                setHeight: 10
                                setFilledLeftRadius: 30
                                setRadius: 30
                                setFrom: 1
                                setTo: 10
                                setStepVisible: true
                                onModified: backend.send(Command.Subtitle1WordByWordChunks, value)
                            }
                        }
                    }
                }


                Row
                {
                    Label { id:sub1TextSizeLabel; text:"sub1 textSize"; color:q_fontColor; }
                    CustomButton
                    {
                        setWidth: 30
                        setHeight: 30
                        setButtonText: "+"
                        onButtonClicked: backend.send(Command.Subtitle1TextSize, sub1TextSize.value+1)
                    }
                    CustomButton
                    {
                        setWidth: 30
                        setHeight: 30
                        setButtonText: "-"
                        onButtonClicked: backend.send(Command.Subtitle1TextSize, sub1TextSize.value-1)
                    }
                }

                Rectangle
                {
                    width: 200
                    height: 50
                    color:"transparent"
                    CustomAdvanceSlider
                    {
                        id:sub1TextSize
                        setWidth: 200
                        setHeight: 10
                        setFilledLeftRadius: 30
                        setRadius: 30
                        setFrom: 1
                        setTo: 200
                        setStepVisible: false
                        onModified: backend.send(Command.Subtitle1TextSize, value)
                    }
                }


                Row
                {
                    Label { id:sub1OffsetLabel; text:"sub1 offset"; color:q_fontColor; }
                    CustomButton
                    {
                        setWidth: 30
                        setHeight: 30
                        setButtonText: "+"
                        onButtonClicked: backend.send(Command.Subtitle1Offset, sub1Offset.value+1)
                    }
                    CustomButton
                    {
                        setWidth: 30
                        setHeight: 30
                        setButtonText: "-"
                        onButtonClicked: backend.send(Command.Subtitle1Offset, sub1Offset.value-1)
                    }
                }

                Rectangle
                {
                    width: 200
                    height: 50
                    color:"transparent"
                    CustomAdvanceSlider
                    {
                        id:sub1Offset
                        setWidth: 200
                        setHeight: 10
                        setFilledLeftRadius: 30
                        setRadius: 30
                        setFrom: -50
                        setTo: 50
                        setStepVisible: false
                        onModified: backend.send(Command.Subtitle1Offset, value)
                    }
                }

                Label { id:sub1BackOpacityLabel; text:"sub1 back opacity "; color:q_fontColor; }
                Rectangle
                {
                    width: 200
                    height: 50
                    color:"transparent"
                    CustomAdvanceSlider
                    {
                        id:sub1BackOpacity
                        setWidth: 200
                        setHeight: 10
                        setFilledLeftRadius: 30
                        setRadius: 30
                        setFrom: 1
                        setTo: 10
                        setStepVisible: true
                        onModified: backend.send(Command.Subtitle1Opacity, value/10)
                    }
                }


                Row
                {
                    Label {
                        text: "text color:"
                        font.pixelSize: 12
                        color:  q_fontColor
                    }
                    CustomButton
                    {
                        id:buttonPickTextColor
                        setWidth: 60
                        setHeight: 30
                        setButtonText: "pickcolor"
                        onButtonClicked:
                        {
                            sharedColorDialog.key="Subtitle1/textColor"
                            sharedColorDialog.open()
                        }
                    }
                }

                Row
                {
                    Label {
                        text: "back color:"
                        font.pixelSize: 12
                        color:  q_fontColor
                    }
                    CustomButton
                    {
                        id:buttonPickBackColor
                        setWidth: 60
                        setHeight: 30
                        setButtonText: "pickcolor"
                        onButtonClicked:
                        {
                            sharedColorDialog.key="Subtitle1/backColor"
                            sharedColorDialog.open()
                        }
                    }
                }



                Label { id:sub1PosyLabel; text:"sub1 pos y "; color:q_fontColor; }
                Rectangle
                {
                    width: parent.width
                    height: 200
                    color:"transparent"
                    Row
                    {
                        spacing: 25
                        Item{ width: 50; height:1}
                        CustomAdvanceSlider
                        {
                            id:sub1Posy
                            setWidth: 200 //rotated: so it's hight
                            setHeight: 10 //rotated: so it's width
                            setFilledLeftRadius: 30
                            setRadius: 30
                            setRotation: 90
                            setFrom: 0
                            setTo: 9
                            setStepVisible: true
                            onModified: backend.send(Command.Subtitle1PosY, value/10)
                        }
                    }
                }

            }

        }


        Column
        {
            //sub2 right side
            id:sub2Base
            anchors.right:parent.right
            spacing: 5
            Rectangle
            {
                width:60
                height: 80
                color:"transparent"
                Column
                {
                    Label { text:"sub2 status"; color:q_fontColor }
                    CustomSwitch
                    {
                        id: sub2Status
                        onSwitchClicked: backend.send(Command.Subtitle2Status, switchStatus)
                    }
                }
            }
            Column
            {
                id:subtitle2Base
                Rectangle
                {
                    width:60
                    height: 80
                    color:"transparent"
                    Column
                    {
                        Label { text:"sub2 wordByWord status"; color:q_fontColor }
                        CustomSwitch
                        {
                            id: sub2WordByWord
                            onSwitchClicked: backend.send(Command.Subtitle2WordByWord, switchStatus)
                        }
                    }
                }

                Rectangle
                {
                    id:sub2WordByWordChunksBase
                    width:60
                    height: 80
                    color:"transparent"
                    Column
                    {
                        Label { id:sub2WordByWordChunksLabel; text:"sub2 WBW chunks"; color:q_fontColor; }
                        Rectangle
                        {
                            width: 200
                            height: 50
                            color:"transparent"
                            CustomAdvanceSlider
                            {
                                id:sub2WordByWordChunks
                                setWidth: 200
                                setHeight: 10
                                setFilledLeftRadius: 30
                                setRadius: 30
                                setFrom: 1
                                setTo: 10
                                setStepVisible: true
                                onModified: backend.send(Command.Subtitle2WordByWordChunks, value)
                            }
                        }
                    }
                }


                Row
                {
                    Label { id:sub2TextSizeLabel; text:"sub2 textSize"; color:q_fontColor; }
                    CustomButton
                    {
                        setWidth: 30
                        setHeight: 30
                        setButtonText: "+"
                        onButtonClicked: backend.send(Command.Subtitle2TextSize, sub2TextSize.value+1)
                    }
                    CustomButton
                    {
                        setWidth: 30
                        setHeight: 30
                        setButtonText: "-"
                        onButtonClicked: backend.send(Command.Subtitle2TextSize, sub2TextSize.value-1)
                    }
                }

                Rectangle
                {
                    width: 200
                    height: 50
                    color:"transparent"
                    CustomAdvanceSlider
                    {
                        id:sub2TextSize
                        setWidth: 200
                        setHeight: 10
                        setFilledLeftRadius: 30
                        setRadius: 30
                        setFrom: 1
                        setTo: 200
                        setStepVisible: false
                        onModified: backend.send(Command.Subtitle2TextSize, value)
                    }
                }

                Row
                {
                    Label { id:sub2OffsetLabel; text:"sub2 offset"; color:q_fontColor; }
                    CustomButton
                    {
                        setWidth: 30
                        setHeight: 30
                        setButtonText: "+"
                        onButtonClicked: backend.send(Command.Subtitle2Offset, sub2Offset.value+1)
                    }
                    CustomButton
                    {
                        setWidth: 30
                        setHeight: 30
                        setButtonText: "-"
                        onButtonClicked: backend.send(Command.Subtitle2Offset, sub2Offset.value-1)
                    }
                }

                Rectangle
                {
                    width: 200
                    height: 50
                    color:"transparent"
                    CustomAdvanceSlider
                    {
                        id:sub2Offset
                        setWidth: 200
                        setHeight: 10
                        setFilledLeftRadius: 30
                        setRadius: 30
                        setFrom: -50
                        setTo: 50
                        setStepVisible: false
                        onModified: backend.send(Command.Subtitle2Offset, value)
                    }
                }

                Label { id:sub2BackOpacityLabel; text:"sub2 back opacity "; color:q_fontColor; }
                Rectangle
                {
                    width: 200
                    height: 50
                    color:"transparent"
                    CustomAdvanceSlider
                    {
                        id:sub2BackOpacity
                        setWidth: 200
                        setHeight: 10
                        setFilledLeftRadius: 30
                        setRadius: 30
                        setFrom: 1
                        setTo: 10
                        setStepVisible: true
                        onModified: backend.send(Command.Subtitle2Opacity, value/10)
                    }
                }


                Row
                {
                    Label {
                        text: "text color:"
                        font.pixelSize: 12
                        color:  q_fontColor
                    }
                    CustomButton
                    {
                        id:buttonPickTextColor2
                        setWidth: 60
                        setHeight: 30
                        setButtonText: "pickcolor"
                        onButtonClicked:
                        {
                            sharedColorDialog.key="Subtitle2/textColor"
                            sharedColorDialog.open()
                        }
                    }
                }

                Row
                {
                    Label {
                        text: "back color:"
                        font.pixelSize: 12
                        color:  q_fontColor
                    }
                    CustomButton
                    {
                        id:buttonPickBackColor2
                        setWidth: 60
                        setHeight: 30
                        setButtonText: "pickcolor"
                        onButtonClicked:
                        {
                            sharedColorDialog.key="Subtitle2/backColor"
                            sharedColorDialog.open()
                        }
                    }
                }



                Label { id:sub2PosyLabel; text:"sub2 pos y "; color:q_fontColor; }
                Rectangle
                {
                    width: parent.width
                    height: 200
                    color:"transparent"
                    Row
                    {
                        spacing: 25
                        Item{ width: 50; height:1}
                        CustomAdvanceSlider
                        {
                            id:sub2Posy
                            setWidth: 200 //rotated: so it's hight
                            setHeight: 10 //rotated: so it's width
                            setFilledLeftRadius: 30
                            setRadius: 30
                            // x:setHeight*4
                            setRotation: 90
                            setFrom: 0
                            setTo: 9
                            setStepVisible: true
                            onModified: backend.send(Command.Subtitle2PosY, value/10)
                        }
                    }
                }
            }

        }

/*
        CustomCollapsiblePanel
        {
            setWidth: 200
            setHeight: 50
            setTitle: "subtitle correction"
            setContentHeight: subtitleCorrection.height
            anchors.top: sub1Base.bottom
            // anchors.right: parent.right
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
            setWidth: 100
            setHeight: 50
            setTitle: "sns"
            setContentHeight: snsBox.height
            anchors.top: sub2Base.bottom
            anchors.right: parent.right
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
*/

    }

    Connections
    {
        target: backend
        onRemoteDataChanged: function(cmd,payload)
        {
            switch(cmd)
            {
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


                //sub1
                case Command.Subtitle1Status:
                    var val = Script.asBool(payload)
                    sub1Status.changeStatus(val)
                    subtitle1Base.visible = val
                    break;

                case Command.Subtitle1WordByWord:
                    var val = Script.asBool(payload)
                    sub1WordByWord.changeStatus(val)
                    sub1WordByWordChunksBase.visible = val
                    break;

                case Command.Subtitle1WordByWordChunks:
                    var val = Script.asInt(payload)
                    sub1WordByWordChunksLabel.text = "sub1 wbw chunks (" + val + ")"
                    sub1WordByWordChunks.intialValue=val
                    break;
                case Command.Subtitle1TextSize:
                    var val = Script.asInt(payload)
                    sub1TextSizeLabel.text = "sub1 textSize (" + val + ")"
                    sub1TextSize.intialValue = val;
                    break;
                case Command.Subtitle1Offset:
                    var val = Script.asInt(payload)
                    sub1OffsetLabel.text = "sub1 offset (" + val + ")"
                    sub1Offset.intialValue = val;
                    break;
                case Command.Subtitle1Opacity:
                    var val = Script.asFloat(payload)
                    sub1BackOpacityLabel.text = "sub1 back opacity (" + val + ")"
                    sub1BackOpacity.intialValue = val*10;
                    break;
                case Command.Subtitle1BackColor:
                    buttonPickBackColor.setButtonBackColor=payload
                    break;
                case Command.Subtitle1TextColor:
                    buttonPickTextColor.setButtonBackColor=payload
                    break;

                case Command.Subtitle1PosY:
                    sub1PosyLabel.text = "sub1 posY (" + Math.round(Script.asInt(payload)*100) + "%)"
                    sub1Posy.intialValue= Script.asFloat(payload)*10
                    break;

                //sub2
                case Command.Subtitle2Status:
                    var val = Script.asBool(payload)
                    sub2Status.changeStatus(val)
                    subtitle2Base.visible = val
                    break;

                case Command.Subtitle2WordByWord:
                    var val = Script.asBool(payload)
                    sub2WordByWord.changeStatus(val)
                    sub2WordByWordChunksBase.visible = val
                    break;

                case Command.Subtitle2WordByWordChunks:
                    var val = Script.asInt(payload)
                    sub2WordByWordChunksLabel.text = "sub2 wbw chunks (" + val + ")"
                    sub2WordByWordChunks.intialValue=val
                    break;
                case Command.Subtitle2TextSize:
                    var val = Script.asInt(payload)
                    sub2TextSizeLabel.text = "sub2 textSize (" + val + ")"
                    sub2TextSize.intialValue = val;
                    break;
                case Command.Subtitle2Offset:
                    var val = Script.asInt(payload)
                    sub2OffsetLabel.text = "sub2 offset (" + val + ")"
                    sub2Offset.intialValue = val;
                    break;
                case Command.Subtitle2Opacity:
                    var val = Script.asFloat(payload)
                    sub2BackOpacityLabel.text = "sub2 back opacity (" + val + ")"
                    sub2BackOpacity.intialValue = val*10;
                    break;
                case Command.Subtitle2BackColor:
                    buttonPickBackColor2.setButtonBackColor=payload
                    break;
                case Command.Subtitle2TextColor:
                    buttonPickTextColor2.setButtonBackColor=payload
                    break;

                case Command.Subtitle2PosY:
                    sub2PosyLabel.text = "sub2 posY (" + Math.round(Script.asInt(payload)*100) + "%)"
                    sub2Posy.intialValue= Script.asFloat(payload)*10
                    break;
            }
        }
    }


}
