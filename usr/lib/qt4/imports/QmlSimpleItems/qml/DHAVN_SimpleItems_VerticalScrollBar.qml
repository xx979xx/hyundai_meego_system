import Qt 4.7
import "DHAVN_SimpleItems_VerticalScrollBar.js" as RES

Item
{
    id: scrollBar

    // type of scroll bar
    property int nTypeScroll: RES.const_LIST_SCROLL_MENU_LIST_TYPE

    width: scroll_bg.width
    // The properties that define the scrollbar's state.
    // position and pageSize are in the range 0.0 - 1.0.  They are relative to the
    // height of the page, i.e. a pageSize of 0.5 means that you can see 50%
    // of the height of the view.
    // orientation can be either Qt.Vertical or Qt.Horizontal
    property real position
    property real pageSize

    property real positionResize:(scrollBar.height*pageSize < RES.const_LIST_SCROLL_MIN_HEIGHT)?
                                     (scrollBar.height+scrollBar.height*pageSize-RES.const_LIST_SCROLL_MIN_HEIGHT)*position
                                   : scrollBar.height*position
    property real pageSizeResize:(scrollBar.height*pageSize < RES.const_LIST_SCROLL_MIN_HEIGHT)?
                                     RES.const_LIST_SCROLL_MIN_HEIGHT : scrollBar.height*pageSize

    Image
    {
        id: scroll_bg
        anchors.top: parent.top
        anchors.left:parent.left
        anchors.bottom:parent.bottom

        source:
        {
            var ret

            switch(scrollBar.bTypeScroll)
            {
            case RES.const_LIST_SCROLL_MENU_LIST_TYPE: ret =  RES.const_LIST_SCROLL_IMG_MENU_BG
                break

            case RES.const_LIST_SCROLL_EDIT_LIST_TYPE: ret =  RES.const_LIST_SCROLL_IMG_EDIT_MENU_BG
                break

            default:  ret =  RES.const_LIST_SCROLL_IMG_MENU_BG
            }

            return ret;
        }

        // Size the bar to the required size, depending upon the orientation.
        Item
        {
            // modified by Dmitry Bykov 04.04.2013 for ISV78612
            id: bar
            y: Math.min( scrollBar.height - top_img.height - bottom_img.height,
                                positionResize < 0 ? 0 : positionResize)
            height: Math.max( top_img.height+bottom_img.height,
                             positionResize < 0 ? pageSizeResize+positionResize :
                             positionResize + pageSizeResize > scrollBar.height ? scrollBar.height - positionResize :
                             pageSizeResize)

            Image
            {
                id: top_img
                anchors.top: parent.top
                source: RES.const_LIST_SCROLL_IMG_T
            }
            Image
            {
                id: bottom_img
                anchors.bottom: parent.bottom
                source: RES.const_LIST_SCROLL_IMG_B
            }
            Image
            {
                anchors.top: top_img.bottom
                anchors.bottom: bottom_img.top
                anchors.bottomMargin: -1 // added by Dmitry Bykov 04.04.2013 for ISV78612
                fillMode: Image.Tile
                source: RES.const_LIST_SCROLL_IMG_M
            }
        }
    }
}

