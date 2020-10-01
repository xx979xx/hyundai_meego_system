import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idSoftPhoneBookPatternLoader
    x:0; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    //clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property int phonebookPatternValue: variant.PhoneBookPattern

    function setPhoneBookPatternValue(value)
    {
        phonebookPatternValue = value;
    }

    function setCheckedStateTrue(index)
    {
        switch(index)
        {
        case 0:
            phoneBookPatternData.setProperty(0, "isCheckedState", true )
            break;
        case 1:
            phoneBookPatternData.setProperty(1, "isCheckedState", true )
            break;

        }
    }
    function setCheckedStatefalse(index)
    {
        switch(index)
        {
        case 0:
            phoneBookPatternData.setProperty(0, "isCheckedState", false )
            break;
        case 1:
            phoneBookPatternData.setProperty(1, "isCheckedState", false )
            break;

        }
    }

    function getCheckedState(index)
    {
        var retValue;
        retValue = false;
        UIListener.printLogMessage("[Qml] getCheckedState :" + index)
        switch(index)
        {
            case 0:
            {
                if(UIListener.voicePhoneBookPattern == 0)
                //if(phonebookPatternValue == 0)
                {
                   retValue = true
                }
                else
                {
                    retValue = false
                }
            }
            break;

            case 1:
            {
                if(UIListener.voicePhoneBookPattern == 0)
                //if(phonebookPatternValue == 0)
                {
                   retValue = false
                }
                else
                {
                    retValue = true
                }
            }
            break;
        }
        UIListener.printLogMessage("[Qml] getCheckedState : UIListener.voicephoneBookPattern: " + UIListener.voicePhoneBookPattern)
        UIListener.printLogMessage("[Qml] getCheckedState : retValue: " + retValue)
        return retValue;


    }

    Component.onCompleted:{
        //UIListener.autoTest_athenaSendObject();
    }


    ListModel{
        id:phoneBookPatternData

        Component.onCompleted:
        {
            phoneBookPatternData.append({ name: "4 Pattern (Full/Reverse/First/Last)", "gridId":0, "isCheckedState": getCheckedState(1) })
            phoneBookPatternData.append({ name: "2 Pattern (Full/First)", "gridId":1, "isCheckedState": getCheckedState(0) })

        }

    }
    ListView{
        id:idPhoneBookPatternView
        //opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: phoneBookPatternData
        delegate: Engineer_Soft_PhoneBookDelegate{
            onWheelLeftKeyPressed:idPhoneBookPatternView.decrementCurrentIndex()
            onWheelRightKeyPressed:idPhoneBookPatternView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
        highlightMoveSpeed: 99999
        boundsBehavior: Flickable.StopAtBounds

    }

}


