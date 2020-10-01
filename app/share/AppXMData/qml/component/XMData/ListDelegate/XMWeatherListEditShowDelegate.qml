import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

XMDataSmallTypeListDelegate{
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width; height:91

    Text {
        id: idText
        x: 13+87; y: 44 - font.pixelSize/2;
        width: 252
        text: cityStateName
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 32
        color: ((index == idListItem.ListView.view.selectedIndex) && !isMousePressed())?colorInfo.focusGrey:colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        //elide:Text.ElideRight
        MXData.XMRectangleForDebug{}
    }

    onClickOrKeySelected: {
        ListView.view.selectedIndex = index;
        ListView.view.currentIndex = index;
        onSelectItem(cityID, itemType);
        forceActiveFocus();
        console.log("[QML] XMWeatherListEditShowDelegate.qml - Pressed:"+index)
        console.log("[XMWeatherListEditShowDelegate.qml.qml][setDataAndShow] itemType = " + itemType);
    }
    onPressAndHold: {
        console.log("[QML] XMWeatherListEditShowDelegate.qml - PressAndHold:"+index)
    }
    onHomeKeyPressed: {
        gotoFirstScreen();
    }
    onBackKeyPressed: {
        gotoBackScreen(false);//CCP
    }

    //property int debugOnOff: idAppMain.debugOnOff;
    Text {
        x:5; y:12; id:idFileName
        text:"XMWeatherListEditShowDelegate.qml";
        color : colorInfo.transparent;
    }
    Rectangle{
        x:10
        y:65
        visible:isDebugMode();
        Column{
            Row{
                Text{text:"["+index+"] CityID:"+cityID +", Lat:"+latitude+",Log:"+longitude+",Fav:"+favorite; color:"white"}
            }
        }
    }
}
