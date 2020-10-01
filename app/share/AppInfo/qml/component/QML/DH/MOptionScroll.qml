import Qt 4.7

import "../../system/DH" as MSystem

Item {
    id: idMOptionScroll

    property variant scrollArea
    property variant orientation: Qt.Vertical
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property bool listScrollFlag: false //# Flag for List scroll - HYANG #

    function position()
    {
        var ny = 0;
        if (idMOptionScroll.orientation == Qt.Vertical)
            ny = scrollArea.visibleArea.yPosition * idMOptionScroll.height;
        else
            ny = scrollArea.visibleArea.xPosition * idMOptionScroll.width;
        if (ny > 2) return ny; else return 2;

        console.log("idMOptionScroll.height : "+idMOptionScroll.height+", idMOptionScroll.width : "+idMOptionScroll.width)
    }

    function size()
    {
        var nh, ny;

        if (idMOptionScroll.orientation == Qt.Vertical)
            nh = scrollArea.visibleArea.heightRatio * idMOptionScroll.height;
        else
            nh = scrollArea.visibleArea.widthRatio * idMOptionScroll.width;

        if (idMOptionScroll.orientation == Qt.Vertical)
            ny = scrollArea.visibleArea.yPosition * idMOptionScroll.height;
        else
            ny = scrollArea.visibleArea.xPosition * idMOptionScroll.width;

        if (ny > 3) {
            var t;
            if (idMOptionScroll.orientation == Qt.Vertical)
                t = Math.ceil(idMOptionScroll.height - 3 - ny);
            else
                t = Math.ceil(idMOptionScroll.width - 3 - ny);
            if (nh > t) return t; else return nh;
        } else return nh + ny;
//        console.log("nh : " + nh + ", ny : " + nh)
    }

    BorderImage{
        id: imgBg
        //x: parent.x; y: parent.y;
        //width: parent.width; height: parent.height;
        source: listScrollFlag? imgFolderGeneral+"scroll_menu_list_bg.png" : imgFolderGeneral + "scroll_option_bg.png"
    }

    BorderImage {
        id:imgScroll

        source: imgFolderGeneral + "scroll_t.png"
        border { left: 1; right: 1; top: 1; bottom: 1 }
        //x: idMOptionScroll.orientation == Qt.Vertical ? 2 : position()
        width: idMOptionScroll.orientation == Qt.Vertical ? idMOptionScroll.width - 8 : size()
        y: idMOptionScroll.orientation == Qt.Vertical ? position() : 2
        height: idMOptionScroll.orientation == Qt.Vertical ? size() : idMOptionScroll.height - 8
    }

    states: State {
        name: "visible"
        when: imgScroll.height == idRect.height
        PropertyChanges { target: idMOptionScroll; opacity: 0.0 }
    }
}
