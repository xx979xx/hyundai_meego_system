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
//        color: colorInfo.brightGrey
        color: idListView.isDragStarted ? idListItem.isDragItem ? colorInfo.brightGrey : colorInfo.disableGrey : colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    Image {
        id: idSportsIcon
        x: idText.textPaintedWidth + 104
        y: parent.height/4;
        source: getSportsImageSource(statusTip);
        visible: true
    }

    Image {
        id: idFemaleIcon
        x: idSportsIcon.x + 57; y: parent.height/4;
        source: imageInfo.imgFolderXMDataSports + "icon_woman.png";
        visible: whatsThis == "Women's College Basketball"? true : false;
    }

    function getSportsImageSource(lID)
    {
        switch(lID)
        {
            case 0:
            case 4:
                return imageInfo.imgFolderXMDataSports + "icon_rugby.png"
            case 1:
                return imageInfo.imgFolderXMDataSports + "icon_baseball.png"
            case 2://[ITS 181428]
            case 5:
            case 6:
                return imageInfo.imgFolderXMDataSports + "icon_basketball.png"
            case 3:
                return imageInfo.imgFolderXMDataSports + "icon_hockey.png"
            default:
            break;
        }
    }


//    Item{
//        x:0;
//        y:controlPointY;
//        width:parent.width-70;
//        height: parent.height
//        visible: controlVisible;
//        Text {
//            id: idText
//            x: 101; y: 0;
//            width: 996
//            height: parent.height
//            text: teamNickName;
//            font.family: systemInfo.font_NewHDB
//            font.pixelSize: 40
//            //color: ((index == idListItem.ListView.view.selectedIndex) && !isMousePressed())?colorInfo.focusGrey:colorInfo.brightGrey
//            color: colorInfo.brightGrey//((index == listView.selectedIndex) && !isMousePressed())?colorInfo.focusGrey:colorInfo.brightGrey
//            horizontalAlignment: Text.AlignLeft
//            verticalAlignment: Text.AlignVCenter
//            elide:Text.ElideRight
//                Rectangle{
//                    width:parent.width
//                    height:parent.height
//                    border.color:"white"
//                    border.width: 1
//                    color:"transparent"
//                    visible:debugOnOff==1
//                }
//        }

//        Image {
//            x: 101; y: parent.height
//            source: imageInfo.imgFolderMusic + "tab_list_line.png"
//        }
//    }
}
