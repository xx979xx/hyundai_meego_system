import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import AppEngineQMLConstants 1.0

DHAVN_PopUp_Base
{
    id: popup

    /** --- Input parameters --- */
    property ListModel thumbnailList: ListModel {}
    property int nCurIndex: -1

    /** --- Signals --- */    
    signal selected( int index )

    /** --- Private property --- */
    property string cur_item_text: ( thumbnailList.get(itemList.currentIndex) != null ) ? thumbnailList.get(itemList.currentIndex).name : ""

    type: RES.const_POPUP_TYPE_B
 //PlanA   enableCloseBtn: true

    /** --- Child object --- */
    content: Item
    {
        id: popup_content
        property int focus_id: -1
        property bool focus_visible: false
        signal lostFocus( int arrow, int focusID )
        function setDefaultFocus( arrow )
        {
            if ( thumbnailList.count > 0 ) return focus_id
            lostFocus( arrow, focus_id )
            return -1
        }

        Column
        {
            id: albumPreview
            spacing: CONST.const_THUMBNAIL_IMG_SPACING_Y
            anchors{ bottom: parent.bottom; left: parent.left; top: parent.top }
            anchors.leftMargin: CONST.const_THUMBNAIL_IMG_X -CONST.const_POPUP_BORDER_WIDTH
            anchors.topMargin: CONST.const_THUMBNAIL_IMG_Y - CONST.const_TITLE_HEIGHT

            Image
            {
                id: icon
                source: RES.const_THUMBNAIL_BG_ALBUM_IMG

                Image
                {
                    id: albumImage
                    anchors.centerIn:parent.Center
                    height: CONST.const_THUMBNAIL_ALBUM_IMAGE_HEIGHT
                    width: CONST.const_THUMBNAIL_ALBUM_IMAGE_WIDTH
                    clip: true
                    source: ( thumbnailList.get(itemList.currentIndex) != null ) ? thumbnailList.get(itemList.currentIndex).icon :
                            RES.const_THUMBNAIL_UNDEFINED_IMG
                }
            }

            Item
            {
                id: albumName
                anchors.left: parent.left
                width: albumImage.width
                height: strName.height
                clip: true

                Text
                {
                    id: strName
                    text: ( cur_item_text.substring( 0, 4 ) != "STR_") ? cur_item_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, cur_item_text )

                    color: CONST.const_TEXT_COLOR
                    font.pixelSize: CONST.const_THUMBNAIL_TEXT_PT
                }
            }
        }

        Timer
        {
            id: startAnimationTimer
            interval: 2000
            repeat: false
            running: ( animationTimer.delta > 0 )
            onTriggered:
            {
                if ( animationTimer.delta > 0 )
                    animationTimer.start()
            }
        }

        Timer
        {
            id: animationTimer
            property int delta: 0
            interval: 25
            repeat: true
            running: ( animationTimer.delta > 0 )
            onTriggered:
            {
                strName.x--

                if( strName.x < albumName.x - delta )
                {
                   animationTimer.stop()
                   resetAnimationTimer.start()
                }
            }
        }

        Timer
        {
            id: resetAnimationTimer
            interval: 2000
            repeat: false
            running: ( animationTimer.delta > 0 )
            onTriggered:
            {
                strName.x = albumName.x
                if ( animationTimer.delta > 0 )
                    startAnimationTimer.start()
            }
        }

        DHAVN_PopUp_Item_List
        {
            id: itemList
            focus_visible: popup_content.focus_visible
            focus_id: popup_content.focus_id
            list: thumbnailList
            itemHeight: CONST.const_THUMBNAIL_LIST_ITEM_HEIGHT
            height: itemHeight * 4
            separatorPath: RES.const_POPUP_LIST_LINE_699
            focusWidth: true
            anchors
            {
                top: parent.top
                left: albumPreview.right
                right: parent.right
                leftMargin: CONST.const_THUMBNAIL_IMG_X - CONST.const_POPUP_BORDER_WIDTH
            }
            onCurrentIndexChanged:
            {
                if ( thumbnailList.count <= 0 || itemList.currentIndex < 0) return

                var deltaText = strName.width - albumName.width

                if ( deltaText > 0 )
                {
                    animationTimer.delta = deltaText
                    startAnimationTimer.start()
                }

                if ( deltaText <= 0 )
                {
                    animationTimer.delta = 0
                    startAnimationTimer.running = false
                    strName.x = albumName.x
                }
            }
            onLostFocus: popup_content.lostFocus( arrow, focusID )
            onItemClicked:
            {
                itemList.currentIndex = itemId
                popup.selected( itemId )
            }
            Component.onCompleted: itemList.currentIndex = popup.nCurIndex
        }
    }

    onNCurIndexChanged: itemList.currentIndex = popup.nCurIndex
}
