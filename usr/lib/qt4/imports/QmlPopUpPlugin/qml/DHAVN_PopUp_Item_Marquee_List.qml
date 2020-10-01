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
    property int hAlignment
    property bool bounds
    property bool scroll

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
        if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
        {
            if ( ( arrow == UIListenerEnum.JOG_DOWN ||
                arrow == UIListenerEnum.JOG_WHEEL_RIGHT ) &&
                ( focus_index < list.count - 1 ) )
            {
                focus_index++
                return
            }
            if ( ( arrow == UIListenerEnum.JOG_UP ||
                arrow == UIListenerEnum.JOG_WHEEL_LEFT ) &&
                ( focus_index > 0 ) )
            {
                focus_index--
                return
            }

            if (arrow == UIListenerEnum.JOG_CENTER)
            {
                list_view.itemClicked( focus_index )
            }

            list_view.lostFocus( arrow, focus_id )
        }
        else if ( status == UIListenerEnum.KEY_STATUS_RELEASED ){

        }
        else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
        {
            if ( arrow == UIListenerEnum.JOG_DOWN)
            {
                focus_index = list.count - 1
                UIListener.ManualBeep();
//		controller.callBeepSound();
                return
            }

            if ( arrow == UIListenerEnum.JOG_UP)
            {
                focus_index = 0
                UIListener.ManualBeep();
//		controller.callBeepSound();
                return
            }
        }
    }

    /** --- Private property --- */
    property int focus_index: 0

    /** --- Object property --- */
    clip: true
    model: list
    boundsBehavior: bounds ? Flickable.boundsBehavior:Flickable.StopAtBounds

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

//        Text
//        {
//            anchors.top: parent.top
//            text: ( name.substring( 0, 4 ) === "STR_" ) ?
//                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, name):
//                            name
//            font.pixelSize: CONST.const_TEXT_LIST_PT
//            font.family: CONST.const_TEXT_FONT_FAMILY
//            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
//            width: parent.width
//            horizontalAlignment: Text.AlignHCenter
//            clip: true
//            opacity: 0.5
//        }
        DHAVN_PopUp_Item_Marquee
        {
            anchors.top: parent.top
            text: ( msg.substring( 0, 4 ) === "STR_" ) ?
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, msg):
                            msg
            width:parent.width
            hAlign:hAlignment
            scrolling:scroll
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


}
