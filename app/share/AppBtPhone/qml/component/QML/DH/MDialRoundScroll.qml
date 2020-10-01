/**
 * /QML/DH/MRoundScroll.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


Item
{
    id: idMScroll

    // PROPERTIES
    property variant scrollArea
    property variant orientation: Qt.Vertical

    property string bgImage: ImagePath.imgFolderGeneral + "scroll_menu_bg.png"
    property string middleScrollImage:  ImagePath.imgFolderGeneral + "scroll_menu.png"

    property real heightRatio: 0.0;


    /* INTERNAL functions */
    function position() {
        var ny = 0;
        var nh = 0;
        var scrollHeight = 479;

        if(1 == scrollArea.visibleArea.heightRatio || 0 == scrollArea.visibleArea.heightRatio) {
            /* 최근통화목록에서 리스트가 변화될때 visibleArea.heightRatio가 1로 설정되어 스크롤바가 전체 다 차지하는 케이스와
             * 설정자동연결에서 Repeater가 사용될때 heightRatio가 0으로 설정되어 스크롤바가 작게 나오는 현상을 막기 위함
             * (visibleArea는 read only value로 수정불가능함)
             */

            nh = heightRatio * scrollHeight;
        } else {
            nh = scrollArea.visibleArea.heightRatio * scrollHeight;
        }

        ny = scrollArea.visibleArea.yPosition * scrollHeight;

        // If size is limited, recalculate proper position
        if(nh < 40){
            ny = ny * (scrollHeight - 40) / (scrollHeight - nh);
        }

        return (ny > 2) ? ny : 2;
    }

    function size() {
        var height = 0;
        var nh, ny;
        var scrollHeight = 479;

        if(1 == scrollArea.visibleArea.heightRatio || 0 == scrollArea.visibleArea.heightRatio) {
            /* 최근통화목록에서 리스트가 변화될때 visibleArea.heightRatio가 1로 설정되어 스크롤바가 전체 다 차지하는 케이스와
             * 설정자동연결에서 Repeater가 사용될때 heightRatio가 0으로 설정되어 스크롤바가 작게 나오는 현상을 막기 위함
             * (visibleArea는 read only value로 수정불가능함)
             */

            nh = heightRatio * scrollHeight;
        } else {
            nh = scrollArea.visibleArea.heightRatio * scrollHeight;
        }

        ny = scrollArea.visibleArea.yPosition * scrollHeight;

        if(ny > 3) {
            var t;
            if(idMScroll.orientation == Qt.Vertical) {
                t = Math.ceil(scrollHeight - 3 - ny);
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
            return (40 > height) ? (40 - nh) + height : height + 3;
        } else {
            return (40 > height) ? 40 : height + 3;
        }
    }

    function update(height_ratio) {
        imgScroll.y = position();
        imgScroll.height = size();
    }


    /* WIDGETS */
    BorderImage {
        id: imgBg
        width: parent.width
        height: parent.height
        source: bgImage
    }

    Item {
        id: scrollItem
        x: 0
        y: position()
        width: parent.width
        height: size()
        clip: true

        Image {
            source: middleScrollImage
            x: 0
            y: -position()
            width: parent.width
            height: imgBg.height
            smooth: true
        }
    }
}
/* EOF */
