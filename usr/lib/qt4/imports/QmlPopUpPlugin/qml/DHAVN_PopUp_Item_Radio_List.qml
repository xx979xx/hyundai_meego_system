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
    property bool focus_visible: false
    property int focus_id: -1
    property bool bPressed: false
    property int pressedIndex:-1
    property string _fontFamily
    property int _default_list_index:0

    property int langID: UIListener.GetLanguageFromQML()

    /** --- Signals --- */
    signal itemClicked( variant itemId )
    signal lostFocus( int arrow, int focusID );
    signal itemPressed(variant itemId)

    onVisibleChanged: {
        focus_index=_default_list_index
    }

    function setDefaultFocus( arrow )
    {
        var ret = focus_id
        if ( count <= 0 )
        {
            lostFocus( arrow, focus_id )
            ret = -1
        }
        return ret
    }

    /** --- Private property --- */
    property int focus_index: 0

    /** --- Object property --- */
    clip: true
    model: list

    boundsBehavior: {
               if(list.count >=4) Flickable.DragAndOvershootBounds
               else Flickable.StopAtBounds
      }

    Connections
    {
        target: focus_visible ? UIListener : null
        onSignalJogNavigation:
        {
            switch(status)
            {
            case UIListenerEnum.KEY_STATUS_PRESSED:
                switch(arrow)
                {
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
                        console.log("[SystemPopUp] JOG_WHEEL_RIGHT")
                        if( focus_index < list.count - 1 )
                            focus_index++
                        break;
                    }
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
                        console.log("[SystemPopUp] JOG_WHEEL_LEFT")
                        if( focus_index > 0 )
                            focus_index--
                        break;
                    }
                    case UIListenerEnum.JOG_CENTER:
                    {
                        list_view.currentIndex = focus_index;
                        bPressed = true;
                        pressedIndex=focus_index;
                        console.log("[SystemPopUp] JOG center pressed");
                        break;
                    }
                    case UIListenerEnum.JOG_RIGHT:
                    {
                        list_view.lostFocus( arrow, focus_id )
                        break;
                    }
                }

                break;
//            case UIListenerEnum.KEY_STATUS_PRESSED:
//                switch(arrow)
//                {
//                    case UIListenerEnum.JOG_CENTER:
//                    {
//                        list_view.currentIndex = focus_index;
//                        bPressed = true;
//                        pressedIndex=focus_index;
//                        console.log("JOG center pressed");
//                        break;
//                    }
////                    case UIListenerEnum.JOG_RIGHT:
////                        list_view.lostFocus( arrow, focus_id )
////                        break;
//                }
//                break;
            case UIListenerEnum.KEY_STATUS_RELEASED:
                switch(arrow)
                {
                case UIListenerEnum.JOG_CENTER:
                    list_view.itemClicked( focus_index );
                    break;
                }

//                break;
//            case UIListenerEnum.KEY_STATUS_LONG_PRESSED:
//                switch(arrow)
//                {
//                case UIListenerEnum.JOG_DOWN:
//                    focus_index = list.count - 1
//                    UIListener.ManualBeep()
//                    break;
//                case UIListenerEnum.JOG_UP:
//                    focus_index = 0
//                    UIListener.ManualBeep()
//                    break;
//                }

//                break;
            }

//            if ( status === UIListenerEnum.KEY_STATUS_CLICKED )
//            {
//                if ( ( arrow === UIListenerEnum.JOG_DOWN ||
//                       arrow === UIListenerEnum.JOG_WHEEL_RIGHT ) &&
//                     ( focus_index < list.count - 1 ) )
//                {
//                    focus_index++
//                    return
//                }
//                if ( ( arrow === UIListenerEnum.JOG_UP ||
//                       arrow === UIListenerEnum.JOG_WHEEL_LEFT ) &&
//                     ( focus_index > 0 ) )
//                {
//                    focus_index--
//                    return
//                }

//                if (arrow === UIListenerEnum.JOG_CENTER)
//                {
//                    list_view.itemClicked( focus_index )
//                }

//                list_view.lostFocus( arrow, focus_id )
//            }

//            else if (status === UIListenerEnum.KEY_STATUS_LONG_PRESSED)
//            {
//                if ( arrow === UIListenerEnum.JOG_DOWN)
//                {
//                    focus_index = list.count - 1
//                    UIListener.ManualBeep()
//                    return
//                }

//                if ( arrow == UIListenerEnum.JOG_UP)
//                {
//                    focus_index = 0
//                    UIListener.ManualBeep()
//                    return
//                }
//            }
        }

        onSignalLanguageChanged:{
            langID = lang;
        }
    }

    /** --- Child object --- */
    delegate: Item
    {
        id: listItem
        height: itemHeight
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter

        /** Focused Img */
        Image
        {
            id: focus
            height: parent.height
            width: focus.sourceSize.width
            anchors.left: parent.left
            anchors.leftMargin: 26
            source: RES.const_POPUP_LIST_ITEM_FOCUSED_IMG
            visible: ( focus_index == index ) && focus_visible
        }

        /** Pressed Img */
        Image
        {
            id: pressed
            height: parent.height
            width: focus.sourceSize.width
            anchors.left: parent.left
            anchors.leftMargin: 26
            source: list_view.pressedIndex == index ? RES.const_POPUP_LIST_ITEM_PRESSSED_IMG : ""
            visible:bPressed
        }

        Image
        {
            id: separator
            visible: index
            source: separatorPath
            //width:parent.width - CONST.const_V_SCROLLBAR_WIDTH - 36
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 36
        }

        Text
        {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 69
            text: ( name.substring( 0, 4 ) === "STR_" ) ?
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, name):
                            name
            font.pixelSize: CONST.const_TEXT_PT
            font.family: _fontFamily
//            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
            color: (focus.visible || (bPressed && list_view.pressedIndex == index)) ? Qt.rgba(250/255, 250/255, 250/255, 1) : Qt.rgba(212/255, 212/255, 212/255, 1) //Text bright grey : common grey
            width: CONST.const_CHECKLIST_TEXT_WIDTH
            clip: true
        }

        Image
        {
            id: item_radio
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 69 + 610 + 16
            source: ( list_view.currentIndex == index ) ?
                        RES.const_BTN_RADIO_ON_IMG :
                        RES.const_BTN_RADIO_OFF_IMG
        }

        MouseArea
        {
            anchors.fill: parent
            beepEnabled: false
            onClicked:
            {
                console.log("[SystemPopUp] Index =  " + index);
                list_view.itemClicked( index )
            }

            onPressed: {
                bPressed = true;
                pressedIndex=index;}
            onReleased: { UIListener.ManualBeep();bPressed = false/*; bClicked = false*/ }
            onCanceled:{ console.log("[SystemPopUp] onCanceled Index =  " + index);bPressed = false/*; bClicked = false*/ }
        }
    }

    DHAVN_PopUp_Item_VerticalScrollBar
    {
        anchors.left:  parent.left
        anchors.leftMargin: langID != 20 ? 760 : 294
        anchors.top:list_view.top
        anchors.topMargin: CONST.const_V_SCROLLBAR_TOP_MARGIN
        position: parent.visibleArea.yPosition
        pageSize: (list.count == 0) ? 0:((list_view.height / itemHeight) / list.count)
        _height: list_view.visibleArea.heightRatio
        _y: list_view.visibleArea.yPosition
        visible: list.count * itemHeight > list_view.height
        list_count: list.count
    }
    onFocus_visibleChanged: {
        list_view.positionViewAtIndex(focus_index,ListView.Visible )
    }

    onFocus_indexChanged:
    {
        list_view.positionViewAtIndex ( list_view.focus_index, ListView.Contain  )
    }
}
