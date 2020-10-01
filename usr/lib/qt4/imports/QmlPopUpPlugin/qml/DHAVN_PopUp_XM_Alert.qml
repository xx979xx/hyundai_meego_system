import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

DHAVN_PopUp_Base
{
    id: popup
    /** --- Input parameters --- */
    property ListModel listmodel: ListModel {}
    property ListModel buttons: ListModel {}
    property int nCurIndex
    property int button_location
    property int item_list_height
    property int map_location_x
    property int map_location_y
    property int map_view_x
    property int map_view_y

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal radioBtnClicked( variant index )



    type: RES.const_POPUP_TYPE_ETC_01
    focus_index: 0
    /** --- Child object --- */
    content: Item
    {
        id: popup_content
        anchors.fill:parent

        property int focus_index: 0
        property int focus_id: -1
        property bool focus_visible: popup.focus_visible
        signal lostFocus( int arrow, int focusID )
        function setDefaultFocus( arrow )
        {
            console.log("[SystemPopUp] popup.focus_index = 0")
            popup.focus_index = 0
            if ( listmodel.count > 0 ) return focus_id
            if ( buttons.count > 0 )
            {
                console.log("[SystemPopUp] popup.focus_index = 1")
                popup.focus_index = 1
                return focus_id
            }
            lostFocus( arrow, focus_id )
            return -1
        }
        Connections
        {
            target: popup.focus_index==0 ? UIListener : null
            onSignalJogNavigation: {
                console.log("[SystemPopUp] onSignalJogNavigation")
                doJogNavigation( arrow, status );
            }
            onSignalPopupJogNavigation: {
                console.log("[SystemPopUp] onSignalPopupJogNavigation")
                doJogNavigation( arrow, status ); }
        }
        function doJogNavigation( arrow, status )
        {
            switch(status)
            {
            case UIListenerEnum.KEY_STATUS_PRESSED:
                switch(arrow)
                {
                case UIListenerEnum.JOG_LEFT:
                    console.log("[SystemPopUp] JOG_LEFT")
                   popup.focus_index = 0;
                    break;
                case UIListenerEnum.JOG_RIGHT:
                    console.log("[SystemPopUp] JOG_RIGHT")
                    popup.focus_index = 1;
                    break;
                }
                break;
            }

        }
        DHAVN_PopUp_Item_XM_Alert
        {
            id: itemList
            focus_id: 0
            focus_visible: ( popup.focus_index == 0 )// && popup.focus_visible
            height:475
            width: 789
            location_x: map_location_x
            location_y: map_location_y
            map_x: map_view_x
            map_y: map_view_y

            list: popup.listmodel

            onItemClicked:
            {
                currentIndex = itemId
                popup.radioBtnClicked( itemId )
            }
            onLostFocus:
            {
                console.log("[SystemPopUp] PopUp_Item_XM_Alert onLostFocus")
                if ( arrow == UIListenerEnum.JOG_RIGHT && buttons.count > 0 )
                    popup.focus_index = 1
                else popup.lostFocus( arrow, popup.focus_id )
            }

        }

        DHAVN_PopUp_Item_Buttons
        {
            btnModel: popup.buttons
            focus_id: 1
            focus_visible:  ( popup.focus_index == 1 ) //&& popup.focus_visible
            anchors.left: parent.left
            anchors.leftMargin: 770
            anchors.verticalCenter: parent.verticalCenter
            popupType: popup.type
            __fontFamily:"DH_HDB"
            onBtnClicked: popup.btnClicked( btnId )
            onLostFocus:
            {
                if ( arrow === UIListenerEnum.JOG_LEFT && listmodel.count > 0 )
                    popup.focus_index = 0
                else popup.lostFocus( arrow, popup_content.focus_id )
            }
        }
    }
}
