import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

ListView
{
    id: listArea

    /** --- Input parameters --- */
    property ListModel listModel: ListModel {}

    property int itemHeight: 0
    property string separatorPath: ""
    property int focus_button: 0

    property int focus_id: -1
    property int focus_index: 0
    property bool focus_visible: false

    /** --- Signals --- */
    signal lostFocus( int arrow, int focusID );
    signal leftBtnClicked( variant index )
    signal rightBtnClicked( variant index )

    /** --- Internal property --- */
    property bool bDebug: true

    function setDefaultFocus( arrow )
    {
        var ret = focus_id
        if ( count <= 0 )
        {
            lostFocus( arrow, focus_id )
            focus_button = -1
            ret = -1
        }
        return ret
    }

    Connections
    {
        target: focus_visible ? UIListener : null

        onSignalJogNavigation:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                if ( arrow == UIListenerEnum.JOG_CENTER )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_CENTER" );
                    if ( focus_button == 0 ) { listArea.leftBtnClicked( focus_index ); return; }
                    if ( focus_button == 1 ) { listArea.rightBtnClicked( focus_index ); return; }
                }

                if ( arrow == UIListenerEnum.JOG_RIGHT || arrow == UIListenerEnum.JOG_WHEEL_RIGHT )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_RIGHT" );

                    focus_button = 1
                    return
                }

                if (  arrow == UIListenerEnum.JOG_LEFT || arrow == UIListenerEnum.JOG_WHEEL_LEFT )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_LEFT" );

                    focus_button = 0
                    return
                }

                if ( arrow == UIListenerEnum.JOG_UP && focus_index > 0 )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_UP" );

                    focus_index--
                    return
                }

                if ( arrow == UIListenerEnum.JOG_DOWN && focus_index < listModel.count - 1 )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_DOWN" );

                    focus_index++
                    return
                }

                listArea.lostFocus( arrow, focus_id )
            }
        }
    }

    function log( logText )
    {
       if ( bDebug ) console.log( "[SystemPopUp] PopUp_Item_ASList: " + logText )
    }

    /** --- Object property --- */
    clip: true
    focus: true
    model: listModel
    boundsBehavior: Flickable.StopAtBounds

    /** --- Child object --- */
    delegate: Item
    {
        id: listItem
        height: itemHeight
        width: separator.sourceSize.width
        anchors.horizontalCenter: parent.horizontalCenter

        Text
        {
            id: item_text
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            text: (listArea.listModel.get( index ).text).substring(0, 4) == "STR_" ?
                      qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, listArea.listModel.get( index ).text ) :
                      listArea.listModel.get( index ).text
            color: CONST.const_TEXT_COLOR
            font.pixelSize: CONST.const_TEXT_PT
        }

        Image
        {
            id: separator
            visible: index
            source: separatorPath
            anchors.top: parent.top
        }

        DHAVN_PopUp_Item_Button
        {
            id: leftBtnItem

            bFocused: focus_index = index && focus_visible && focus_button == 0

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: rightBtnItem.left
            anchors.rightMargin : 10

            bg_img_n: RES.const_POPUP_04_BUTTON_N
            bg_img_p: RES.const_POPUP_04_BUTTON_P
            caption: (listArea.listModel.get( index ).textLeftBtn).substring(0, 4) == "STR_" ?
                         qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, listArea.listModel.get( index ).textLeftBtn ) :
                         listArea.listModel.get( index ).textLeftBtn

            onBtnClicked:
            {
                listArea.leftBtnClicked( index );
            }
        }

        DHAVN_PopUp_Item_Button
        {
            id: rightBtnItem

            bFocused: focus_index = index && focus_visible && focus_button == 1

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            bg_img_n: RES.const_POPUP_04_BUTTON_N
            bg_img_p: RES.const_POPUP_04_BUTTON_P
            caption: (listArea.listModel.get( index ).textRightBtn).substring(0, 4) == "STR_" ?
                         qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, listArea.listModel.get( index ).textRightBtn ) :
                         listArea.listModel.get( index ).textRightBtn

            onBtnClicked:
            {
                listArea.rightBtnClicked( index );
            }
        }
    }

    DHAVN_PopUp_Item_VerticalScrollBar
    {
        anchors.right: listArea.right
        anchors.rightMargin: CONST.const_V_SCROLLBAR_RIGHT_MARGIN
        anchors.top:listArea.top
        anchors.topMargin: CONST.const_V_SCROLLBAR_TOP_MARGIN
        position: parent.visibleArea.yPosition
        pageSize: (listModel.count == 0) ? 0 : ((listArea.height / itemHeight) / listModel.count)
        visible: listModel.count * itemHeight > listArea.height
        list_count: listModel.count
    }

    onFocus_indexChanged:
    {
        listArea.positionViewAtIndex ( listArea.focus_index, ListView.Contain  )
    }
}
