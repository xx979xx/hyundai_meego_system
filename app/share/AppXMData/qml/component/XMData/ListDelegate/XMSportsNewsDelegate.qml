import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../List" as XMList


XMDataSmallTypeListNormalDelegate{
    id: idListItem
    y: 0
    width:ListView.view.width; height: 92

    Image {
        id: idBgImage
        x: 0; y:0
        source: (idListItem.activeFocus && focusOn) ? imageInfo.imgFolderGeneral + "list_f.png" : ""
    }


    Image{
        x: 0; y:idListItem.height;
        source: imageInfo.imgFolderGeneral + "list_line.png"
    }

    MComp.DDScrollTicker{
        id: idNewsItem
        x: 87; y: 33 - fontSize/2;
        width: 940
        height: 64
        text: HeadlineBodyRole
        fontFamily : systemInfo.font_NewHDR
        fontSize: 34
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    onClickReleased: {
        ListView.view.currentIndex = index;
    }
}
