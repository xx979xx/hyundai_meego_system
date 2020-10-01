import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_AppFileManager_PopUp_Constants.js" as CONST
import "DHAVN_AppFileManager_PopUp_Resources.js" as RES
//added by aettie 2013 08 07 [KOR][ITS][182912][minor][KOR][ITS][182908][minor]
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

    property bool jogCenterPressed: false 
    
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
            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
                switch(arrow)
                {
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
		    //modified for CCP wheel direction for ME 20131024
                        if( EngineListener.middleEast )
                        {
                            if ( focus_index > 0 )
                                focus_index--;
                            break;
                        }
                        else
                        {
                            if(focus_index < list.count - 1 )
                                focus_index++;
                            break;
                        }
                    }
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
                        if( EngineListener.middleEast )
                        {
                            if(focus_index < list.count - 1 )
                                focus_index++;
                            break;
                        }
                        else
                        {
                            if ( focus_index > 0 )
                                focus_index--;
                            break;
                        }
                    }

                    case UIListenerEnum.JOG_CENTER:
                    {
                        jogCenterPressed = true;
                        list_view.currentIndex = focus_index;
                        pressedIndex=list_view.currentIndex;
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
                        if(jogCenterPressed)
                        {
                            list_view.itemClicked( focus_index )
                        }
                            jogCenterPressed = false;
                        
                        break;
                    }

                    case UIListenerEnum.JOG_RIGHT:
                    {
                        list_view.lostFocus( arrow, focus_id )
                        break;
                    }
// added by Dmitry 18.08.13 for ITS0184462
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
// added by Dmitry 18.08.13 for ITS0184462
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

    /** --- Private property --- */
    property int focus_index: 0

    /** --- Object property --- */
    clip: true
    model: list

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

        Image
        {
            height: parent.height
            width: focus.sourceSize.width
            anchors.centerIn: parent
            source: RES.const_POPUP_LIST_ITEM_FOCUSED_IMG
            visible: ( focus_index == index ) && focus_visible && !(jogCenterPressed||mouseArea.pressed)
        }
        Image
        {
            height: parent.height
            width: focus.sourceSize.width
            anchors.centerIn: parent
            source: RES.const_POPUP_LIST_ITEM_PRESSSED_IMG
            visible: jogCenterPressed &&(( focus_index == index ) && focus_visible)   || mouseArea.pressed
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
            font.family: CONST.const_TEXT_FONT_FAMILY_NEW
            color: Qt.rgba(212/255, 212/255, 212/255, 1)
            width: parent.width
            clip: true
        }

        Image
        {
            id: separator
                z: 1
            visible: true
            source: separatorPath
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 36
        }
        Image
        {
            id: separator_btm
            z: 1
            visible:  ( (index + 1) == list_view.count )
            source: separatorPath
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 36
        }       

        MouseArea
        {
            id: mouseArea
            anchors.fill: parent
            onClicked:
            {
                list_view.itemClicked( index )
            }
        }
    }

    onFocus_indexChanged:
    {
        list_view.positionViewAtIndex ( list_view.focus_index, ListView.Contain  )
    }
}
