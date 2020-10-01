import Qt 4.7

// System Import
import "../../QML/DH" as MComp

XMDataChangeRowListDelegate{
    id: idListItem
    x:0
    y:0
    height:92
    MComp.DDScrollTicker{
        id: idText
        x: 101; y: 0;
        width: 996
        height: parent.height
        text: toolTip
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: idListView.isDragStarted ? idListItem.isDragItem ? colorInfo.brightGrey : colorInfo.disableGrey : colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

//    Item{
//        x:0;
//        y:0;
//        width:parent.width-70;
//        height: parent.height
////        visible: controlVisible;
//        Text {
//            id: idText
//            x: 101; y: 0;
//            width: 996
//            height: parent.height
//            text: toolTip
//            font.family: systemInfo.font_NewHDR
//            font.pixelSize: 40
//            color: colorInfo.brightGrey
//            horizontalAlignment: Text.AlignLeft
//            verticalAlignment: Text.AlignVCenter
//            elide:Text.ElideRight
//        }
//    }
}
