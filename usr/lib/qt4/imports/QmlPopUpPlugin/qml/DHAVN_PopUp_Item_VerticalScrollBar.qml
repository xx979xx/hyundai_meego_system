import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST

Item {
    id: scrollBar

    // The properties that define the scrollbar's state.
    // position and pageSize are in the range 0.0 - 1.0.  They are relative to the
    // height of the page, i.e. a pageSize of 0.5 means that you can see 50%
    // of the height of the view.
    // orientation can be either Qt.Vertical or Qt.Horizontal
    property real position
    property real pageSize
    property int  list_count
    property int  line: (pageSize * list_count)
    property real _height
    property int _y:0

    width: bg_img.width
   // height: (line > 3 ? parent.height - (37*2) /*CONST.const_V_SCROLLBAR_4LINE_HEIGHT*/ : CONST.const_V_SCROLLBAR_3LINE_HEIGHT)

    Connections
    {
        target: UIListener
        onSignalLanguageChanged:{
            langID = lang;
        }
    }

    Image
    {
        id: bg_img;
        anchors.left: parent.left
        anchors.top:  parent.top
        source: langID != 20  ? RES.const_LIST_SCROLL_BG_IMG_4Lines : RES.const_LIST_SCROLL_BG_IMG_4Lines_REVERSE
        Item
        {
           height:  scrollBar._height * bg_img.height
           y: bg_img.height * scrollBar.position //flic_view.visibleArea.yPosition
           Image
           {
              y: -parent.y
              source: langID != 20  ? RES.const_LIST_SCROLL_IMG_T : RES.const_LIST_SCROLL_IMG_T_REVERSE
           }
           width: parent.width
           clip: true
        }
    }
}