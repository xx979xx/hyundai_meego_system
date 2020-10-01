/**
 * MScroll.qml
 *
 */

import QtQuick 1.1

Item 
{
    id: idMScroll

    // PROPERTIES
    property variant scrollArea
    property variant orientation: Qt.Vertical

    property string bgImage: imageInfo.imgFolderGeneral + "scroll_menu_list_bg.png"

    property string topScrollImage:     imageInfo.imgFolderGeneral + "scroll_t.png"
    property string middleScrollImage:  imageInfo.imgFolderGeneral + "scroll_m.png"
    property string bottomScrollImage:  imageInfo.imgFolderGeneral + "scroll_b.png"

    property real heightRatio: 0.0;


    /* INTERNAL functions */
    function position() {
        var ny = 0;
        var nh = 0;

        if(1 == scrollArea.visibleArea.heightRatio || 0 == scrollArea.visibleArea.heightRatio) {
            /* 최근통화목록에서 리스트가 변화될때 visibleArea.heightRatio가 1로 설정되어 스크롤바가 전체 다 차지하는 케이스와
             * 설정자동연결에서 Repeater가 사용될때 heightRatio가 0으로 설정되어 스크롤바가 작게 나오는 현상을 막기 위함
             * (visibleArea는 read only value로 수정불가능함)
             */

            nh = heightRatio * idMScroll.height
        } else {
            nh = scrollArea.visibleArea.heightRatio * idMScroll.height;
        }

        ny = scrollArea.visibleArea.yPosition * idMScroll.height;

        if(nh < 40)
        {
            ny = ny * (idMScroll.height - 40) / (idMScroll.height - nh);
        }

        // limit lower boundary
        if(ny > idMScroll.height - imgTopScroll.height - imgBottomScroll.height)
            ny = idMScroll.height - imgTopScroll.height - imgBottomScroll.height;

        return (ny > 2) ? ny : 2;
    }

    function size() {
        var height = 0;
        var nh, ny;

        if(1 == scrollArea.visibleArea.heightRatio || 0 == scrollArea.visibleArea.heightRatio) {
            /* 최근통화목록에서 리스트가 변화될때 visibleArea.heightRatio가 1로 설정되어 스크롤바가 전체 다 차지하는 케이스와
             * 설정자동연결에서 Repeater가 사용될때 heightRatio가 0으로 설정되어 스크롤바가 작게 나오는 현상을 막기 위함
             * (visibleArea는 read only value로 수정불가능함)
             */

            nh = heightRatio * idMScroll.height
        } else {
            nh = scrollArea.visibleArea.heightRatio * idMScroll.height;
        }

        ny = scrollArea.visibleArea.yPosition * idMScroll.height;

        if(ny > 3) {
            var t;
            if(idMScroll.orientation == Qt.Vertical) {
                t = Math.ceil(idMScroll.height - 3 - ny);
            } else {
                t = Math.ceil(idMScroll.width - 3 - ny);
            }

            if(nh > t) {
                height = t;
            } else {
                height = nh;
            }
        } else {
            height = nh + ny;
        }

        if(ny < 0) {
            if(40 > nh ) {
                height = (40 - nh) + height;
            }
        }else if(ny > idMScroll.height - nh) {
            if(40 > nh ) {
                height = (40 - nh) + height;
            }
            height += 1;
        } else {
            if(40 > height ) {
                height = 40;
            }
        }

        return (height > imgTopScroll.height + imgBottomScroll.height) ? (height > 40 ? height : 40) : imgTopScroll.height + imgBottomScroll.height;
    }

    function update(height_ratio) {
        //heightRatio = height / contentHeight;
        //yPosition = 1.0 - heightRatio;

        imgScroll.y = position() + imgTopScroll.height;
        imgScroll.height = size() - imgTopScroll.height - imgBottomScroll.height;
    }


    /* WIDGETS */
    BorderImage {
        id: imgBg
        width: parent.width
        height: parent.height
        source: bgImage
    }

    Image {
        id: imgTopScroll
        source: topScrollImage

        width: 14
        height: 8

        anchors.bottom: imgScroll.top
    }

    Image {
        id: imgScroll
        source: middleScrollImage
        y: position() + imgTopScroll.height

        width: 14
        height: size() - imgTopScroll.height - imgBottomScroll.height

        /*DEPRECATED
        onVisibleChanged: {
            if(true == imgScroll.visible) {
                imgScroll.y = idMScroll.orientation == Qt.Vertical ? size() : idMScroll.height - 8
                imgScroll.height = idMScroll.orientation == Qt.Vertical ? size() : idMScroll.height - 8
            }
        }
DEPRECATED*/
    }

    Image {
        id: imgBottomScroll
        source: bottomScrollImage

        width: 14
        height: 8

        anchors.top: imgScroll.bottom
    }
}
/* EOF */
