import Qt 4.7

import "../../system/DH" as MSystem

Item {
    id: idMScroll

    property variant scrollArea
    property variant orientation: Qt.Vertical
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string bgImage: imgFolderGeneral + "scroll.png"
    property string selectedScrollImage: imgFolderGeneral+"scroll_option_bg.png" // (Scroll image selected for List scroll - HYANG) #

    function position() {
        var ny = 0;
        if (idMScroll.orientation == Qt.Vertical)
            ny = scrollArea.visibleArea.yPosition * idMScroll.height;
        else
            ny = scrollArea.visibleArea.xPosition * idMScroll.width;
        if (ny > 2) return ny; else return 2;

        console.log(" [MScroll] idMScroll.height : "+idMScroll.height+", idMScroll.width : "+idMScroll.width)
    } // End function()

    function size() {
        var nh, ny;

        if (idMScroll.orientation == Qt.Vertical)
            nh = scrollArea.visibleArea.heightRatio * idMScroll.height;
        else
            nh = scrollArea.visibleArea.widthRatio * idMScroll.width;

        if (idMScroll.orientation == Qt.Vertical)
            ny = scrollArea.visibleArea.yPosition * idMScroll.height;
        else
            ny = scrollArea.visibleArea.xPosition * idMScroll.width;

        if (ny > 3) {
            var t;
            if (idMScroll.orientation == Qt.Vertical)
                t = Math.ceil(idMScroll.height - 3 - ny);
            else
                t = Math.ceil(idMScroll.width - 3 - ny);
            if (nh > t) return t; else return nh;
        } else return nh + ny;
//        console.log("nh : " + nh + ", ny : " + nh)
    } // End function()

    BorderImage{
        id: imgBg
        //x: parent.x; y: parent.y;
        //width: parent.width; height: parent.height;
        source: selectedScrollImage
    } // End BorderImage

    BorderImage {
        id:imgScroll
        source: bgImage
        border { left: 1; right: 1; top: 1; bottom: 1 }
        //x: idMScroll.orientation == Qt.Vertical ? 2 : position()
        width: idMScroll.orientation == Qt.Vertical ? idMScroll.width - 8 : size()
        y: idMScroll.orientation == Qt.Vertical ? position() : 2
        height: idMScroll.orientation == Qt.Vertical ? size() : idMScroll.height - 8
    } // End BorderImage

    states: State {
        name: "visible"
        when: imgScroll.height == idRect.height
        PropertyChanges { target: idMScroll; opacity: 0.0 }
    }
} // End Item
