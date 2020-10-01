import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import PopUpConstants 1.0

DHAVN_PopUp_Base
{
    id: popup

    /** --- Input parameters --- */
    property bool enableCloseBtn: false
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}
    property variant progressMin
    property variant progressMax
    property variant progressCur
    property bool useRed: false

    //property string popupType: ( message.count > 2 ) ? RES.const_POPUP_TYPE_A : RES.const_POPUP_TYPE_B
    states: [
        State {
            name: "PopupTypeA"
            when: ( message.count < 3 )
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_A
            }
        },
        State {
            name: "PopupTypeB"
            when: ( message.count  >= 3 )
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_B
            }
        }
    ]

    /** --- Signals --- */
    signal btnClicked( variant btnId )

    type: popupType
    icon_title: EPopUp.WARNIG_ICON
    content: Item
    {
        id: name
        property bool focus_visible: false
        property int focus_id: -1

        /** --- Signals --- */
        signal lostFocus( int arrow, int focusID );

        function setDefaultFocus( arrow )
        {
            return popupBtn.setDefaultFocus( arrow )
        }

        //anchors.centerIn: parent
        anchors.fill:parent

        /** Text message */
//        Item
//        {
//            width: parent.width
//            //height: ( popupType == RES.const_POPUP_TYPE_ETC_02 ) ? 214 : 200
//            anchors.top:parent.top
//            anchors.horizontalCenter: parent.horizontalCenter

            DHAVN_PopUp_Item_SuperText
            {
                txtModel: message
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 94
                alignment:Text.AlignHCenter
                //fontColor:

                //width: popup.widthImage
                width: parent.width
                height: message.count * 44
                use_icon:true
                txtOnly: ( buttons.count < 0 )
            }
//        }

        /** Progress bar */
        DHAVN_PopUp_Item_ProgressBar
        {
            id: progress_bar
            min: progressMin
            max: progressMax
            cur: progressCur
            useRed: popup.useRed
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: ( popupType == RES.const_POPUP_TYPE_ETC_02 ) ? 200 : 286

        }

        /** Buttons */
        DHAVN_PopUp_Item_Buttons
        {
            id: popupBtn
            focus_id: parent.focus_id
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_BUTTON_LEFT_MARGIN
            anchors.verticalCenter: parent.verticalCenter
            btnModel: popup.buttons
            __fontFamily:"DH_HDB"
            onBtnClicked: { popup.btnClicked( btnId ) }
            onLostFocus: parent.lostFocus( arrow, focusID )
            focus_visible: parent.focus_visible
        }
    }
}
