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

    property int langID: UIListener.GetLanguageFromQML()

    /** --- Signals --- */
    signal itemClicked( variant itemId )
    signal lostFocus( int arrow, int focusID );
    signal itemPressed(variant itemId)
    signal jogSelect(int selected_index)
    signal hideFocus()

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
    //boundsBehavior: Flickable.boundsBehavior/* .StopAtBounds*/

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
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                        if ( focus_index > 0 )
                            focus_index--;
                        break;
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                        if(focus_index < list.count - 1 )
                            focus_index++;
                        break;
                    case UIListenerEnum.JOG_RIGHT:
                        list_view.lostFocus( arrow, focus_id )
                        break;
                    case UIListenerEnum.JOG_CENTER:

                        list_view.currentIndex = focus_index;
                        pressedIndex=list_view.currentIndex;
                        bPressed = true;
                        break;
                    }
                    break;
//            case UIListenerEnum.KEY_STATUS_PRESSED:
//                switch(arrow)
//                {
//                case UIListenerEnum.JOG_DOWN:
//                case UIListenerEnum.JOG_WHEEL_RIGHT:
//                    if(focus_index < list.count - 1 )
//                        focus_index++;
//                    break;
//                case UIListenerEnum.JOG_UP:
//                case UIListenerEnum.JOG_WHEEL_LEFT:
//                    if ( focus_index > 0 )
//                        focus_index--;
//                    break;
//                case UIListenerEnum.JOG_CENTER:

//                    list_view.currentIndex = focus_index;
//                    pressedIndex=list_view.currentIndex;
//                    bPressed = true;
//                    break;
//                }

//                break;
            case UIListenerEnum.KEY_STATUS_RELEASED:
                switch(arrow)
                {
                case UIListenerEnum.JOG_CENTER:
                    bPressed = false;

                   list_view.jogSelect(focus_index)
                   bSelected = !bSelected
                   console.log("[SystemPopUp] Released")
                    break;

                case UIListenerEnum.JOG_RIGHT:
                    list_view.lostFocus( arrow, focus_id )
                    break;
                }
                break;
//            case UIListenerEnum.KEY_STATUS_CLICKED:
//                switch(arrow)
//                {
//                case UIListenerEnum.JOG_DOWN:
//                case UIListenerEnum.JOG_WHEEL_RIGHT:
//                    if(focus_index < list.count - 1 )
//                        focus_index++;
//                    break;
//                case UIListenerEnum.JOG_UP:
//                case UIListenerEnum.JOG_WHEEL_LEFT:
//                    if ( focus_index > 0 )
//                        focus_index--;
//                    break;
//                case UIListenerEnum.JOG_RIGHT:
//                    list_view.lostFocus( arrow, focus_id )
//                    break;
//                }
//                break;
            case UIListenerEnum.KEY_STATUS_LONG_PRESSED:
                break;
            }
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
        property bool bSelected:false
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
            source: list_view.currentIndex == index ? RES.const_POPUP_LIST_ITEM_PRESSSED_IMG : ""
            visible:bPressed
        }

        Image
        {
            id: separator
            visible: index
            source: separatorPath
         //   width:parent.width - CONST.const_V_SCROLLBAR_WIDTH - 36
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
            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
            width: CONST.const_CHECKLIST_TEXT_WIDTH//separator.sourceSize.width
            clip: true
        }

//        Image
//        {
//            id: item_checkbox
//            anchors.verticalCenter: parent.verticalCenter
////            anchors.right: parent.right
////            anchors.rightMargin: 83
//            anchors.left: parent.left
//            anchors.leftMargin: 69 + 610 + 18
//            source: ( bSelected == false)/*( list_view.currentIndex == index && bSelected == true)*/ ?
//                        RES.const_BTN_CHECK_ON_IMG :
//                        RES.const_BTN_CHECK_OFF_IMG
//        }
        DHAVN_PopUp_Item_CheckBox
        {
            id: item_checkbox
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 69 + 610 + 18
            stateCheck: check
            onItemClicked: list_view.itemClicked( index )
        }

        MouseArea
        {
            anchors.fill: parent
            beepEnabled: false
            onClicked:
            {
                console.log("[SystemPopUp] Index =  " + index);
                list_view.itemClicked( index )
                item_checkbox.checkToggle()
            }

            onPressed: {
                UIListener.ManualBeep();
                bPressed = true;
                pressedIndex=index;
                currentIndex=index;
                list_view.hideFocus();
                focus_index = index;
            }
            onReleased: { bPressed = false; bSelected = !bSelected; /*; bClicked = false*/ }
            onCanceled:{ console.log("[SystemPopUp] onCanceled Index =  " + index);bPressed = false/*; bClicked = false*/ }
//            { bPressed = false/*; bClicked = false*/ }
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
