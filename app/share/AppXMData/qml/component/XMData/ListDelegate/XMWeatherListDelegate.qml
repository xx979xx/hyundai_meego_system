import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

XMDataSmallTypeListDelegate{
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width-35; height:92

    MComp.DDScrollTicker{
        id: idText
        x: 6+26+23; y: 0;
        width: 876
        height: parent.height
        text: cityStateName
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    onClickOrKeySelected: {
        ListView.view.selectedIndex = index;
        ListView.view.currentIndex = index;
        if(playBeepOn)
            UIListener.playAudioBeep();
        onSelectItem(cityID, itemType);
        forceActiveFocus();
        console.log("[QML] XMWeatherListDelegate - Pressed:"+index);
    }
    onPressAndHold: {
        console.log("[QML] XMWeatherListDelegate - PressAndHold:"+index);
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
        text:"XMWeatherListDelegate.qml";
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
