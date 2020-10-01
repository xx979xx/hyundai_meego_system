import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST

DHAVN_PopUp_Base
{
    id: popUpBase

    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}

    property int icon_location: 0
    property int text_location: 0

    /** --- Signals --- */
    signal btnClicked( variant btnId )

    states: [
        State {
            name: "state1"                             // One line of text without button
            when: message.count == 1
            PropertyChanges {
                target: popUpBase;
                type: RES.const_POPUP_TYPE_ETC_01;
                icon_location: 50
                text_location: 173
            }
        },
        State {
            name: "state2"                             // Two lines of text with button
            when: message.count == 2 && buttons.count
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_ETC_02;
                icon_location: 40
                text_location: 143
            }
        },
        State {
            name: "state3"                             // Three lines of text with button
            when: message.count == 3  && buttons.count
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_ETC_03;
                icon_location: 50
                text_location: 170
            }
        }

    ]

    content: Item
    {
        id: popup_content

        property bool focus_visible: false
        property int focus_id: -1

        /** --- Signals --- */
        signal lostFocus( int arrow, int focusID );

        function setDefaultFocus( arrow )
        {
            return popupBtn.setDefaultFocus( arrow )
        }

        /** Loading icon */
        AnimatedImage
        {
            id: animation
            source: RES.const_LOADING_IMG
            anchors{ horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: icon_location }
        }

        /** Text message */
        DHAVN_PopUp_Item_SuperText
        {
            id: supertext
            txtModel: message
            width: popUpBase.widthImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: text_location
            txtOnly: ( buttons.count < 0 )
        }

        /** Buttons */
        DHAVN_PopUp_Item_Buttons
        {
            id: popupBtn
            focus_id: parent.focus_id
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            btnModel: popUpBase.buttons
            onBtnClicked: { popUpBase.btnClicked( btnId ) }
            focus_visible: parent.focus_visible
            onLostFocus: parent.lostFocus( arrow, focusID )
        }

   }
}
