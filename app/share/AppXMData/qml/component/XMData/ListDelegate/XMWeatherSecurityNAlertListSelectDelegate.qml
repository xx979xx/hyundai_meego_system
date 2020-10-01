/*
  XMWeatherSecurityNAlertListSelectDelegate
  */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

XMDataAddDeleteCheckBoxListDelegate{
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width; height:92

    property int fav : WSAisDeleteItem;
    signal checkOn(int index);
    signal checkOff(int index);

    onCheckBoxOn:{
        checkOn(index); //This signal will be catched by Delegate Definition.
    }
    onCheckBoxOff:{
        checkOff(index) //This signal will be catched by Delegate Definition.
    }
    onClickOrKeySelected: {
        idListItem.ListView.view.currentIndex = index;
        itemClicked(idText.text);
        forceActiveFocus();
        toggleCheckBox();
    }
    Component.onCompleted: {
        if(WSAisDeleteItem == true){
            setCheckBoxOn();
        }
    }
    onFavChanged: {
        if(fav == true)
            setCheckBoxOn();
        else
            setCheckBoxOff();
    }

    //=============================== Componet Layout
    //priority + WSA Type + Location
    MComp.DDScrollTicker {
        id: idText
        x: 49 + 35
        //y: 44 - font.pixelSize/2;
        y:0;
        height:parent.height
        width: 820;
        text: UIListener.getFullNameForMsgType(WSAmsgType) + " " + "(" + WSAlocationDes+ ")";
        fontSize: 40
        fontFamily: systemInfo.font_NewHDR
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        //MXData.XMRectangleForDebug{}
    }

    //WSA Type + Location
//    Text {
//        id: idStarting
//        x: 75 + 83 + 155 + 17 + 22 + 463 + 4 + 21; y:0//y: 44 - font.pixelSize/2;
//        width: 235
//        height: parent.height;
//        text: WSAMsgType + " " + "(" + WSALocation+ ")"
//        font.family: systemInfo.font_NewHDB
//        font.pixelSize: 32
//        color: colorInfo.brightGrey
//        horizontalAlignment: Text.AlignLeft
//        verticalAlignment: Text.AlignVCenter
//        //MXData.XMRectangleForDebug{}
//    }

    //=============================== Debug Info
//    Rectangle{
//        id:idDebugInfoView
//        z:200
//        visible:isDebugMode()
//        Column{
//            id:idDebugInfo1
//            x: 10
//            y: 70
//            Text{text: "["+index+"]["+selectedIndex+"] entryID:" + entryID +" szListMode : " + ", Fav:" + favorite; color: "white"; }
//            Text{text: "name: "+theaterName+", s:" + startTime +", addr: "+theaterAddr+" [" + theaterPhoneNum+"]"; color: "white"; }
//        }
//        Column{
//            id:idDebugInfo2
//            x:400; y:5
//            Row{
//                spacing:10
//                Column{
//                    Text{text: "dist : " + distance; color: "white"; }
//                    Text{text: "dir  : " + direction; color: "white"; }
//                }
//                Column{
//                    Text{text: "lati : " + latitude; color: "white"; }
//                    Text{text: "long : " + longitude; color: "white"; }
//                }
//            }
//        }
//    }
}
