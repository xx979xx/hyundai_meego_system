import Qt 4.7
import "DHAVN_OptionMenu.js" as CONST

Item {
    id: scrollBar

    width: background_img.sourceSize.width
    // The properties that define the scrollbar's state.
    // position and pageSize are in the range 0.0 - 1.0.  They are relative to the
    // height of the page, i.e. a pageSize of 0.5 means that you can see 50%
    // of the height of the view.
    // orientation can be either Qt.Vertical or Qt.Horizontal

    property real position
    property real pageSize

    Image
    {
       id: background_img
       anchors.top: parent.top
       anchors.left: parent.left
       anchors.bottomMargin: 14
       source: CONST.const_OPTIONMENU_LIST_SCROLL_BACKGROUND


       // Size the bar to the required size, depending upon the orientation.
       Item {
           y: (scrollBar.position > 0) ?
                  (scrollBar.position * scrollBar.height < background_img.height ?
                       scrollBar.position * scrollBar.height : background_img.height)
                : 0
           height: calcHeight()

           Image
           {
               id: top_img
               anchors.top: parent.top
               source: CONST.const_OPTIONMENU_LIST_SCROLL_IMG_T
           }
           Image
           {
               id: bottom_img
               anchors.bottom: parent.bottom
               source: CONST.const_OPTIONMENU_LIST_SCROLL_IMG_B
           }
           Image
           {
               anchors.top: top_img.bottom
               anchors.bottom: bottom_img.top
               anchors.bottomMargin: -1 // added by Sergey 22.09.2013 for ITS#189137
               fillMode: Image.Tile
               source: CONST.const_OPTIONMENU_LIST_SCROLL_IMG_M
           }

           function calcHeight()
           {
              var h = (scrollBar.position > 0) ? (y + scrollBar.pageSize * scrollBar.height < background_img.height) ? scrollBar.pageSize * scrollBar.height :
                                                         scrollBar.pageSize * scrollBar.height + (background_img.height - (y + scrollBar.pageSize * scrollBar.height)) :
                                                         scrollBar.pageSize * scrollBar.height + scrollBar.position * scrollBar.height
              return h;
           }
       }
    }
}
