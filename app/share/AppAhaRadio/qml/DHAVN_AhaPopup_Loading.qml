import Qt 4.7
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

DHAVN_AhaPopup_Base
{
    id: ahaPopUpBase

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
                target: ahaPopUpBase
                type: PR_RES.const_APP_AHA_POPUP_TYPE_C;
                icon_location: 50
                text_location: 133
            }
        },
        State {
            name: "state2"                             // Two lines of text with button
            when: message.count == 2 && buttons.count
            PropertyChanges {
                target: ahaPopUpBase
                type: PR_RES.const_APP_AHA_POPUP_TYPE_ETC_02;
                icon_location: 40
                text_location: 143
            }
        },
        State {
            name: "state3"                             // Three lines of text with button
            when: message.count == 3  && buttons.count
            PropertyChanges {
                target: ahaPopUpBase
                type: PR_RES.const_APP_AHA_POPUP_TYPE_ETC_03;
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

        /*Signals*/
        signal lostFocus( int arrow, int focusID );

//        function setDefaultFocus( arrow )
//        {
//            return popupBtn.setDefaultFocus( arrow )
//        }

//wsuk.kim 130906 loading animation change from gif to png.
//        /*Loading icon*/
//        AnimatedImage
//        {
//            id: load_animation
//            source: PR_RES.const_APP_AHA_POPUP_LOADING_IMG
//            anchors{ horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: icon_location }
//            //hsryu_0409_decrease_speed
//            NumberAnimation on rotation { running: load_animation.on; from: 0; to: 360; loops: Animation.Infinite; duration: 2000 }
//        }
        Image {
            id: load_animation
            anchors{ horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: icon_location }
            source: PR_RES.const_APP_AHA_POPUP_LOADING_WAIT[counter]
        }
        Timer
        {
            id: waitTimer
            interval: 100
            running: popup_content.visible
            repeat: true

            onTriggered: {
                counter = counter + 1
                if(counter == PR.const_AHA_TIMER_COUNTER_MAX_VAL)
                {
                    counter = PR.const_AHA_TIMER_COUNTER_MIN_VAL
                }
                load_animation.source = PR_RES.const_APP_AHA_POPUP_LOADING_WAIT[counter]
            }
        }
//wsuk.kim 130906 loading animation change from gif to png.

        /*Loading text*/
        DHAVN_AhaPopup_Text
        {
            id: popuptext
            txtModel: message
            opacity: 0.9
            width: ahaPopUpBase.widthImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: text_location
            txtOnly: ( buttons.count < 0 )
        }
    }
}
