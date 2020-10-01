import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

XMDataAddDeleteCheckBoxListDelegate{
    id: idListItem
    x:0; y: 0
    z: index
    width:ListView.view.width; height:92

    property string fav : favorite;
    property bool isAddFavorite:false;
    signal checkOn(int index);
    signal checkOff(int index);

    onCheckBoxOn:{
        ListView.view.currentIndex = index;
        checkOn(index); //This signal will be catched by Delegate Definition.
    }
    onCheckBoxOff:{
        ListView.view.currentIndex = index;
        checkOff(index) //This signal will be catched by Delegate Definition.
    }
    onClickOrKeySelected: {
        if(playBeepOn)
            UIListener.playAudioBeep();
        idListItem.ListView.view.currentIndex = index;
        itemClicked(idText.text);
        forceActiveFocus();
        toggleCheckBox();
    }
    onFavChanged: {
        if(fav == "on" || fav == "add" || fav == "deleteCheck")
            setCheckBoxOn();
        else if(fav == "off")
            setCheckBoxOff();
    }

    Component.onCompleted: {
        if(favorite == "on"){
            setCheckBoxOn();
        }
    }

    MComp.DDScrollTicker{
        id: idText
        x: 29 + 6 + 26 + 23; y: 0;
        width: 846
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

    Rectangle{
        x:10
        y:65
        visible:isDebugMode();
        Column{
            Row{
                Text{text:"["+index+"] cityID:"+cityID +", Lat:"+latitude+",Log:"+longitude+",Fav:"+favorite; color:"white"}
            }
        }
    }
}
