import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_MP_PopUp_Constants.js" as CONST
import "DHAVN_MP_PopUp_Resources.js" as RES

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

// modified by Dmitry 15.05.13
    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
                switch(arrow)
                {
		//modified for CCP wheel direction for ME 20131024
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
                        if( EngineListenerMain.middleEast )
                        {
                            if ( focus_index > 0 )
                                focus_index--;
                        }
                        else
                        {
                            if(focus_index < list.count - 1 )
                                focus_index++;
                        }
                        break;
                    }
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
                        if( EngineListenerMain.middleEast )
                        {
                            if(focus_index < list.count - 1 )
                                focus_index++;
                        }
                        else
                        {
                            if ( focus_index > 0 )
                                focus_index--;
                        }
                        break;
                    }
                    case UIListenerEnum.JOG_CENTER:
                    {
                        list_view.currentIndex = focus_index;
                        pressedIndex=list_view.currentIndex;
                        bPressed = true;
                        break;
                    }
                }
                break;
            }
            case UIListenerEnum.KEY_STATUS_RELEASED:
            {
                switch(arrow)
                {
                    case UIListenerEnum.JOG_CENTER:
                    {
                        list_view.itemClicked( focus_index )
                        bPressed = false;
                        break;
                    }

                    case UIListenerEnum.JOG_RIGHT:
                    {
                        list_view.lostFocus( arrow, focus_id )
                        break;
                    }
                    
                    case UIListenerEnum.JOG_DOWN:
                    {
                        if(focus_index < list.count - 1 )
                            focus_index++;
                        break;
                    }
                    
                    case UIListenerEnum.JOG_UP:
                    {
                        if ( focus_index > 0 )
                            focus_index--;
                        break;
                    }
                }
                break;
            }

            case UIListenerEnum.KEY_STATUS_LONG_PRESSED:
            {
                switch(arrow)
                {
                    case UIListenerEnum.JOG_DOWN:
                    {
                        focus_index = list.count - 1
                        UIListener.ManualBeep()
                        break;
                    }
                    case UIListenerEnum.JOG_UP:
                    {
                        focus_index = 0
                        UIListener.ManualBeep()
                        break;
                    }
                }
                break;
            }
        }
    }
// modified by Dmitry 15.05.13

    /** --- Private property --- */
    property int focus_index: 0

    /** --- Object property --- */
    clip: true
    model: list
    //boundsBehavior: Flickable.StopAtBounds

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
        Image
        {
            height: parent.height
            width: focusWidth ? parent.width : focus.sourceSize.width
            anchors.centerIn: parent
            source: RES.const_POPUP_LIST_ITEM_FOCUSED_IMG
            visible: ( focus_index == index ) && focus_visible
        }

        Text
        {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 69
            text: ( name.substring( 0, 4 ) == "STR_" ) ?
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, name):
                            name
            font.pixelSize: CONST.const_TEXT_LIST_PT
            //font.family: CONST.const_TEXT_FONT_FAMILY
            font.family: CONST.const_TEXT_FONT_FAMILY_NEW
            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
            width: parent.width
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
            onClicked:
            {
                list_view.itemClicked( index )
            }
        }
    }

    DHAVN_MP_PopUp_Item_VerticalScrollBar
    {
        anchors.right: list_view.right
        anchors.rightMargin: 4
        anchors.top:list_view.top
        anchors.topMargin: CONST.const_V_SCROLLBAR_TOP_MARGIN
        position: parent.visibleArea.yPosition
        pageSize: (list.count == 0) ? 0 : ((list_view.height / itemHeight) / list.count)
        visible: list.count * itemHeight > list_view.height
        list_count: list.count
    }

    onFocus_indexChanged:
    {
        list_view.positionViewAtIndex ( list_view.focus_index, ListView.Contain  )
    }
}
