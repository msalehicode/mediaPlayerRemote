import QtQuick

Item {
    width:setWidth
    height:setHeight
    property int setWidth: 200
    property int setHeight: 50
    property string enteredAddress:""
    property int inputFieldCount: 6
    property int maxCharacterInField: 2
    property string setJoinCharacter:":" //how join all fields e.g set (:) => AB:CD:EF:..
    property string defualtCharValueInCaseWasInvalid: " " //e.g if item coult not apped to final, will place  this character.char=* maxCharacterInField=2 ==> enteredAddress= AB::CD:**:EF:GB..
    Rectangle
    {
        color:"transparent"
        anchors.fill: parent

        Row
        {
            id:inputRow
            anchors.fill: parent
            spacing: 5
            Repeater
            {
                id:repeater
                model:inputFieldCount
                anchors.horizontalCenter: parent.horizontalCenter
                delegate: CustomTextInputWithMask
                {
                    setWidth:40//parent.width/7
                    setHeight:45//parent.height/1.25
                    setBgColor:"white"
                    setFontColor:"black"
                    setMaxCharacter:maxCharacterInField
                    onTheTextIsFilledFully:
                    {
                        var item;
                        var currentIndex=model.index;
                        var i;
                        var finalAddress=""
                        if(currentIndex===inputFieldCount-1)//put entered values together
                        {
                            for (i = 0; i < repeater.count; i++)
                            {
                                item = repeater.itemAt(i);
                                if (item)
                                {
                                    if(i===0)
                                        finalAddress+=item.theText;
                                    else
                                        finalAddress+=setJoinCharacter+item.theText;
                                }
                                else
                                {
                                    console.log("invalid item repeater to read.")
                                    finalAddress+=setJoinCharacter+ (defualtValueInCaseWasInvalid * setMaxCharacter) //put how many max with empty character for this invalid round
                                }
                            }
                            enteredAddress=finalAddress
                        }
                        else //set focus for next input
                        {
                            for (i = currentIndex; i < repeater.count; i++)
                            {
                                item = repeater.itemAt(i);
                                if (item)
                                {
                                    if(item.theText.length<setMaxCharacter)
                                    {
                                        item.setFocus=true
                                        break;
                                    }
                                }
                            }
                        }



                    }
                }
            }
        }


    }
}
