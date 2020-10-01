import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

ListView
{
    id: list_view

    /** --- Input parameters --- */
    property ListModel list: ListModel {}

    property int itemHeight: 0
    property string separatorPath: ""

    property bool focusWidth: false
    property bool bIsActiv: true

    property bool focus_visible: false
    property int focus_id: -1
    property string _fontFamily

    /** --- Signals --- */
    signal itemClicked( variant itemId )
    signal lostFocus( int arrow, int focusID );

    function setDefaultFocus( arrow )
    {
        var ret = focus_id
        if ( count <= 0 || bIsActiv == false)
        {
            lostFocus( arrow, focus_id )
            ret = -1
        }
        return ret
    }

    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
//        case UIListenerEnum.KEY_STATUS_CLICKED:
//        {
//            switch(arrow)
//            {
//                case UIListenerEnum.JOG_DOWN:
//                case UIListenerEnum.JOG_WHEEL_RIGHT:
//                {
//                    if( focus_index < list.count - 1 )
//                        focus_index++
//                    break;
//                }
//                case UIListenerEnum.JOG_UP:
//                case UIListenerEnum.JOG_WHEEL_LEFT:
//                {
//                    if( focus_index > 0 )
//                        focus_index--
//                    break;
//                }
//                case UIListenerEnum.JOG_CENTER:
//                {
//                    list_view.itemClicked( focus_index )
//                    break;
//                }
//                case UIListenerEnum.JOG_RIGHT:
//                {
//                    list_view.lostFocus( arrow, focus_id )
//                    break;
//                }
//            }

//            break;
//        }
        case UIListenerEnum.KEY_STATUS_PRESSED:
        {
            switch(arrow)
            {
                //case UIListenerEnum.JOG_DOWN:
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    if(focus_index < list.count - 1 )
                        focus_index++;
                    break;
                }
                //case UIListenerEnum.JOG_UP:
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    if ( focus_index > 0 )
                        focus_index--;
                    break;
                }
                case UIListenerEnum.JOG_CENTER:
                {
                    list_view.currentIndex = focus_index;
                    pressedIndex=list_view.currentIndex;
                    bPressed = true;
                    break;
                }
                case UIListenerEnum.JOG_RIGHT:
                {
                    list_view.lostFocus( arrow, focus_id )
                    break;
                }
            }
            break;
        }
        case UIListenerEnum.KEY_STATUS_CANCELED:
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_CENTER:
                {
                    bPressed = false;
                }
            }

            break;
        }
        case UIListenerEnum.KEY_STATUS_RELEASED:
        {
            break;
        }
        case UIListenerEnum.KEY_STATUS_LONG_PRESSED:
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_DOWN:
                {
                    focus_index = list.count - 1
                    UIListener.ManualBeep();
//		    controller.callBeepSound();
                    break;
                }
                case UIListenerEnum.JOG_UP:
                {
                    focus_index = 0
                    UIListener.ManualBeep();
//		    controller.callBeepSound();
                    break;
                }
            }
            break;
        }
        }
    }
//        if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
//        {
//            if ( ( arrow == UIListenerEnum.JOG_DOWN ||
//                arrow == UIListenerEnum.JOG_WHEEL_RIGHT ) &&
//                ( focus_index < list.count - 1 ) )
//            {
//                focus_index++
//                return
//            }
//            if ( ( arrow == UIListenerEnum.JOG_UP ||
//                arrow == UIListenerEnum.JOG_WHEEL_LEFT ) &&
//                ( focus_index > 0 ) )
//            {
//                focus_index--
//                return
//            }

//            if (arrow == UIListenerEnum.JOG_CENTER)
//            {
//                list_view.itemClicked( focus_index )
//            }
//             if (arrow == UIListenerEnum.JOG_RIGHT)
//             {
//                list_view.lostFocus( arrow, focus_id )
//             }
//        }
//        else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
//        {
//            if ( arrow == UIListenerEnum.JOG_DOWN)
//            {
//                focus_index = list.count - 1
//                UIListener.ManualBeep()
//                return
//            }

//            if ( arrow == UIListenerEnum.JOG_UP)
//            {
//                focus_index = 0
//                UIListener.ManualBeep()
//                return
//            }
//        }


    /** --- Private property --- */
    property int focus_index: 0

    /** --- Object property --- */
    clip: true
    model: list
    boundsBehavior: Flickable.StopAtBounds

    Connections
    {
        target: focus_visible ? UIListener : null
        onSignalJogNavigation: { doJogNavigation(arrow, status); }
        onSignalPopupJogNavigation: { doJogNavigation(arrow, status); }
    }

    /** --- Child object --- */
    delegate: Item
    {
        id: listItem
        height: itemHeight
        width: parent.width//separator.sourceSize.width
        anchors.horizontalCenter: parent.horizontalCenter

        /** Highlight Img
        Image
        {
            id: highlight_img
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            source: RES.const_LIST_HIGHLIGHT_IMG
            visible: ( list_view.currentIndex == index ) && bIsActiv
        }*/

        /** Focused Img */
//        Image
//        {
//            height: parent.height
//            width: focus.sourceSize.width
//            anchors.top: parent.top
//            anchors.left: parent.left
//            anchors.leftMargin: 35
//            source: RES.const_POPUP_LIST_ITEM_FOCUSED_IMG
//            visible: ( focus_index == index ) && focus_visible
//        }

        Text
        {
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignRight
            anchors.left: parent.left
            anchors.leftMargin: 69
            text: ( name.substring( 0, 4 ) == "STR_" ) ?
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, name):
                            name
            font.pixelSize: CONST.const_TEXT_LIST_PT
            font.family: _fontFamily
            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
            width: 677
            clip: true
        }

        Image
        {
            //{ modified by Aettie.ji for New UX(Music) #46 on 2012.10.18
            id: separator
            //visible: index
            visible: true
            source: separatorPath
            //anchors.top: parent.top
            //anchors.bottom: parent.bottom
           // width:parent.width - CONST.const_V_SCROLLBAR_WIDTH - 36
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 36
            //{ modified by Aettie.ji for New UX(Music) #46 on 2012.10.18
        }

        MouseArea
        {
            anchors.fill: parent
            beepEnabled: false
            onClicked:
            {
                UIListener.ManualBeep();
                list_view.itemClicked( index )
            }
        }
    }

    DHAVN_PopUp_Item_VerticalScrollBar
    {
        anchors.left:  parent.left
        anchors.top:list_view.top
        anchors.topMargin: CONST.const_V_SCROLLBAR_TOP_MARGIN
        position: parent.visibleArea.yPosition
        pageSize: (list.count == 0) ? 0 : ((list_view.height / itemHeight) / list.count)
        _height: list_view.visibleArea.heightRatio
        _y: list_view.visibleArea.yPosition
        visible: list.count * itemHeight > list_view.height
        list_count: list.count
    }

    onFocus_indexChanged:
    {
        list_view.positionViewAtIndex ( list_view.focus_index, ListView.Contain  )
    }
}
