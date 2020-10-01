import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import AppEngineQMLConstants 1.0

DHAVN_PopUp_Base
{
    id: popup

    /** --- Input parameters --- */
    property string popupType: RES.const_POPUP_TYPE_C
    property int buttonSpace: CONST.const_POPUP_RADIO_BTN_SPACING
    property int currentRadioBtn: 0

    property ListModel radio: ListModel {}
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}

    type: popupType

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal radioBtnClicked( variant index )

    /** --- Private property --- */
    /** --- Child object --- */
    content: Column
    {
        id: popup_content
        property int focus_id: -1
        property int focus_index: 0
        property bool focus_visible: false

        /** --- Signals --- */
        signal lostFocus( int arrow, int focusID );

        /** Focus interface functions */
        function setDefaultFocus( arrow )
        {
            focus_index = 0
            radio_list.focus_index = 0

            if ( radio.count > 0 ) return focus_id
            if ( buttons.count > 0 )
            {
                focus_index = 1;
                return focus_id
            }
            lostFocus( arrow, focus_id )
            return -1
        }

        width: parent.width
        anchors.centerIn: parent

        /** Text message */
        DHAVN_PopUp_Item_SuperText { txtModel: message }

        Row
        {
            id: radio_list
            property int focus_index: 0
            property int focus_id: 0
            property bool focus_visible: ( popup_content.focus_index == 0 ) && popup_content.focus_visible
            signal lostFocus( int arrow, int focusID )

            spacing: CONST.const_POPUP_RADIO_ITEM_SPACING
            anchors.horizontalCenter: parent.horizontalCenter

            Connections
            {
                target: radio_list.focus_visible ? UIListener : null
                onSignalJogNavigation:
                {
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                    {
                        if ( ( arrow == UIListenerEnum.JOG_UP ||
                               arrow == UIListenerEnum.JOG_WHEEL_LEFT ) &&
                             ( radio_list.focus_index > 0 ) )
                        {
                            radio_list.focus_index--
                            return
                        }
                        if ( ( arrow == UIListenerEnum.JOG_DOWN ||
                               arrow == UIListenerEnum.JOG_WHEEL_RIGHT ) &&
                             ( radio_list.focus_index < radio.count - 1 ) )
                        {
                            radio_list.focus_index++
                            return
                        }
                        radio_list.lostFocus( arrow, radio_list.focus_id )
                    }
                }
            }

            onLostFocus:
            {
                if ( arrow == UIListenerEnum.JOG_DOWN && buttons.count > 0 )
                    popup_content.focus_index = 1
                else popup_content.lostFocus( arrow, popup_content.focus_id )
            }

            Repeater
            {
                model: radio
                delegate: Component
                {
                    DHAVN_PopUp_Item_RadioBtn
                    {
                        id: radio_button

                        btnId: index
                        radio_txt: txt
                        radio_icon: icon || ""
                        radio_txt_color: txt_color
                        radio_txt_pixelsize: txt_pixelsize ? txt_pixelsize : CONST.const_RADIO_CONTENT_TEXT_SIZE
                        radio_content_spacing: content_spacing
                        text_under_bg: name
                        bFocused: ( radio_list.focus_index == index ) && radio_list.focus_visible
                        bSelected: ( radio_list.currentRadioBtn == index )
                        onBtnClicked: popup.radioBtnClicked( index )
                    }
                }
            }
        }

        /** Button spacing */
        Item { width: 1; height: buttonSpace }

        /** Buttons */
        DHAVN_PopUp_Item_Buttons
        {
            id: popupBtns
            focus_id: 1
            focus_visible: ( popup_content.focus_index == 1 ) && popup_content.focus_visible
            btnModel: popup.buttons
            onBtnClicked: popup.btnClicked( btnId )
            __fontFamily:"DH_HDB"
            onLostFocus:
            {
                if ( arrow == UIListenerEnum.JOG_UP && radio.count > 0 )
                    popup_content.focus_index = 0
                else popup_content.lostFocus( arrow, popup_content.focus_id )
            }
        }
    }
}
