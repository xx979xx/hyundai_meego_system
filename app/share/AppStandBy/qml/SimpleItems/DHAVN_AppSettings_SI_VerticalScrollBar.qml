import QtQuick 1.1
import "DHAVN_AppSettings_SI_VerticalScrollBar.js" as RES

Item {
    id: scrollBar

    // type of scroll bar
    property int nTypeScroll: RES.const_LIST_SCROLL_MENU_LIST_TYPE
    property int listViewHeight

    width: scroll_bg.width
    height: scroll_bg.height
    // The properties that define the scrollbar's state.
    // position and pageSize are in the range 0.0 - 1.0.  They are relative to the
    // height of the page, i.e. a pageSize of 0.5 means that you can see 50%
    // of the height of the view.
    // orientation can be either Qt.Vertical or Qt.Horizontal
    property real position
    property real pageSize

    Image{
        id: scroll_bg
        source: RES.const_LIST_SCROLL_IMG_MENU_BG

        // Size the bar to the required size, depending upon the orientation.
        Item {
            y: scrollBar.position * scroll_bg.height
            height: scrollBar.pageSize * scroll_bg.height

            Image{
                id: top_img
                anchors.top: parent.top
                source: RES.const_LIST_SCROLL_IMG_T
            }
            Image{
                id: middle_img
                anchors.top: top_img.bottom
                anchors.bottom: bottom_img.top
                source: RES.const_LIST_SCROLL_IMG_M
            }
            Image{
                id: bottom_img
                anchors.bottom: parent.bottom
                source: RES.const_LIST_SCROLL_IMG_B
            }
        }
    }
}
