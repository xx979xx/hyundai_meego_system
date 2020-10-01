import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import AppEngineQMLConstants 1.0

DHAVN_PopUp_Base
{
    id: popup

    /** --- Input parameters --- */
    property string popupType: RES.const_POPUP_TYPE_C

    property variant sliderMin
    property variant sliderMax
    property variant sliderCur: sliderMin
    property variant sliderStep

    property int buttonSpace: CONST.const_SLIDER_BTN_SPACING
    property ListModel message: ListModel
    {
        ListElement { msg: ""; txt_spacing: 45; txt_pixelsize: 83 }
    }
    property ListModel buttons: ListModel {}

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal sliderMoved( variant cur_value )

    /** --- Child object --- */
    type: popupType
    content: Column
    {
        id: popup_content
        property int focus_index: 0
        property int focus_id: -1
        property bool focus_visible: false
        signal lostFocus( int arrow, int focusID )
        function setDefaultFocus( arrow )
        {
            focus_index = 0
            return focus_id
        }
        anchors.centerIn: parent

        /** Text message */
        DHAVN_PopUp_Item_SuperText { txtModel: message }

        /** Progress bar */
        DHAVN_PopUp_Item_Slider
        {
            min_value: popup.sliderMin
            max_value: popup.sliderMax
            cur_value: popup.sliderCur
            step_value: popup.sliderStep
            focus_visible: ( parent.focus_index == 0 ) && parent.focus_visible
            focus_id: 0
            onSliderMoved: popup.sliderMoved( cur_value )
            onLostFocus:
            {
                if ( arrow == UIListenerEnum.JOG_DOWN && buttons.count > 0 )
                    popup_content.focus_index = 1
                else popup_content.lostFocus( arrow, popup_content.focus_id )
            }
        }

        /** Button spacing */
        Item { width: 1; height: buttonSpace }

        /** Buttons */
        DHAVN_PopUp_Item_Buttons
        {
            focus_id: 1
            focus_visible: ( parent.focus_index == 1 ) && parent.focus_visible
            btnModel: popup.buttons
            onBtnClicked: popup.btnClicked( btnId );
            onLostFocus:
            {
                if ( arrow == UIListenerEnum.JOG_UP )
                    popup_content.focus_index = 0
                else popup_content.lostFocus( arrow, popup_content.focus_id )
            }
        }
    }

    onSliderCurChanged: popup.message.setProperty( 0, "msg", sliderCur)

    Component.onCompleted:
    {
        if ( popup.message.get(0).msg == "")
        {
            popup.message.setProperty( 0, "msg", sliderCur )
        }
    }
}
