import Qt 4.7
import "."
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

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal switchPressed( variant index, bool value )

    type: RES.const_POPUP_TYPE_C

    content: Item
    {
        id: popup_content
        property int focus_index: 0
        property int focus_id: -1
        property bool focus_visible: false
        signal lostFocus( int arrow, int focusID )

        function setDefaultFocus( arrow )
        {
            focus_index = 0
            if ( listmodel.count > 0 ) return focus_id
            if ( buttons.count > 0 )
            {
                focus_index = 1
                return focus_id
            }
            lostFocus( arrow, focus_id )
            return -1
        }

        DHAVN_PopUp_Item_ASList
        {
            id: itemList

            focus_id: 0
            focus_visible: ( parent.focus_index == 0 ) && parent.focus_visible
            height: ( itemHeight * 3 ) + 2
            listModel: popup.listmodel
            itemHeight: CONST.const_LIST_AND_BUTTONS_ITEM_HEIGHT_1
            separatorPath: RES.const_POPUP_LIST_LINE_989
            currentIndex: nCurIndex

            anchors{ top: popup_content.top; left: popup_content.left; right: popup_content.right }

            onSwitchPressed: popup.switchPressed( index, value )
            onLostFocus:
            {
                if ( arrow == UIListenerEnum.JOG_DOWN && buttons.count > 0 )
                    popup_content.focus_index = 1
                else popup_content.lostFocus( arrow, popup_content.focus_id )
            }
        }

        DHAVN_PopUp_Item_Buttons
        {
            id: popupBtn
            focus_id: 1
            btnModel: popup.buttons
            focus_visible: ( parent.focus_index == 1 ) && parent.focus_visible

            anchors{ top: itemList.bottom; topMargin: 8; horizontalCenter: popup_content.horizontalCenter }

            onBtnClicked: popup.btnClicked( btnId )
            onLostFocus:
            {
                if ( arrow == UIListenerEnum.JOG_UP && listmodel.count > 0 )
                    popup_content.focus_index = 0
                else popup_content.lostFocus( arrow, popup_content.focus_id )
            }
        }
    }
}
