import Qt 4.7
import "../System" as MSystem
import "../Component" as MComp

Column {
    id:idDtcColumn
    width: parent.width
    height:  250

    //anchors.top: parent.top
    //spacing: 10
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    Text {
        id: idDTCfirstValue
        x: 20;
        anchors.top: parent.top
        //width: parent.width
        height: 40
        text:dtcTitle
        color: "white"
        font.pointSize: 25
        //font: "HDR"
    }

    GridView {
        clip: true
        id: idDTCGridList
        height: 200
        y:0
        cacheBuffer: 200
        width: parent.width
        cellWidth: 600
        cellHeight: 50
        //anchors.top: idDTCfirstValue.bottom +50
        model: dtcGridModel
        delegate: DTCListDelegate{}
        focus: true



    }
    //--------------------- ScrollBar #
    MComp.MScroll {
        property int  scrollWidth: 13
        property int  scrollY: 5
        x:1230; z:1
        anchors.top: idDTCGridList.top
        scrollArea: idDTCGridList;
        height: 200; width: scrollWidth
//        anchors.right: idHeadUnitView.right
        visible: true
    } //# End MScroll

}

