/**
 * /QML/DH_arabic/MRoundScroll.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


Item
{
    id: idMRoundScroll

    x: 0
    y: 0
    z: 1
    width: scrollWidth
    height: scrollHeight

    // PROPERTIES
    property string scrollBgImage: ImagePath.imgFolderGeneral + "scroll_menu_bg.png"
    property string scrollBarImage: ImagePath.imgFolderGeneral + "scroll_menu.png"
    property int scrollWidth: 46
    property int scrollHeight: 491

    property int moveBarPosition: 0
    property int listCount
    property int listCountOfScreen: 5
    property int moveBarHeight: (40 > ((scrollHeight / listCount) * listCountOfScreen)) ? 40 : ((scrollHeight / listCount) * listCountOfScreen)
    property int bottomPosition: scrollHeight - moveBarHeight - 9

    property int limitBottomPosition: 306 - 44
    property int limitTottomPosition: -306 + 109

    /* INTERNAL functions */
    function scrollToTop() {
        if(0 != moveBarPosition) {
            // 값이 다를때만 Update
            moveBarPosition = 0;
        }
    }

    function scrollToBottom() {
        if(moveBarPosition != bottomPosition) {
            // 값이 다를때만 Update
            moveBarPosition = bottomPosition;
        }
    }

    function scrollTo(position) {
        if(position != moveBarPosition) {
            // 값이 다를때만 Update
            if(bottomPosition <= position) {
                moveBarPosition = bottomPosition;
            } else {
                moveBarPosition = position;
            }
        }
    }


    /* WIDGETS */
    Image {
        source: scrollBgImage
    }

    Item {
        x: 0
        y: (moveBarPosition > limitBottomPosition)? limitBottomPosition : (moveBarPosition < limitTottomPosition)? limitTottomPosition : moveBarPosition
        width: scrollWidth
        height: moveBarHeight
        clip: true

        Image {
            smooth: true
            x: 0
            y: -parent.y
            width: scrollWidth
            height: scrollHeight
            source: scrollBarImage
        }
    }
}
/* EOF */
