import Qt 4.7
import QtQuick 1.1
import "DHAVN_AppFileManager_PopUp_Resources.js" as RES
import "DHAVN_AppFileManager_PopUp_Constants.js" as CONST
import PopUpConstants 1.0

DHAVN_AppFileManager_PopUp_Base
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
    LayoutMirroring.enabled: EngineListener.middleEast
    LayoutMirroring.childrenInherit: EngineListener.middleEast

    /** --- Signals --- */
    signal lostFocus( int arrow, int focusID );
    signal btnClicked( variant btnId )

    function setDefaultFocus( arrow )
    {
        return popupBtn.setDefaultFocus( arrow )
    }

    property int offset_y

    focus_index: 0

    //property string popupType: ( message.count > 2 ) ? RES.const_POPUP_TYPE_A : RES.const_POPUP_TYPE_B
    // modified by ravikanth for ITS 0187211
    states: [
        State {
            name: "PopupTypeA"
            when: ( ( message.count < 3 ) && ( buttons.count > 0 ) )
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
        },
        State {
            name: "PopupTypeF"
            when: ( ( message.count < 3 ) && ( buttons.count < 1 ) )
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_F
            }
        }
    ]

    Image
    {
       id: content
       source: type

       anchors
       {
          left: parent.left; leftMargin: getLeftMargin()
          top: parent.top; topMargin: getTopMargin()
       }

        DHAVN_AppFileManager_PopUp_Item_SuperText
        {
            id: progress_text
            txtModel: message
            anchors.top: parent.top
            anchors.topMargin: ( popup.type == RES.const_POPUP_TYPE_F ) ? 68 : 88
            alignment:Text.AlignLeft //Text.AlignHCenter // modified by lssanh 2013.03.03 ISV61726
            anchors.leftMargin: ( popup.type == RES.const_POPUP_TYPE_F ) ? 67 : ( alignment == Text.AlignLeft ? CONST.const_TEXT_LEFTALIGN_LEFT_MARGIN : 57 ) // added by lssanh 2013.03.03 ISV61726
            width: 661
            height: message.count * 44
            use_icon:true
            txtOnly: ( buttons.count < 1 )
        }

        /** Progress bar */
        DHAVN_AppFileManager_PopUp_Item_ProgressBar
        {
            id: progress_bar
            min: progressMin
            max: progressMax
            cur: progressCur
            useRed: popup.useRed
            anchors.top: parent.top
            anchors.topMargin: ( popup.type == RES.const_POPUP_TYPE_F ) ? 186 : 206//( popup.type == RES.const_POPUP_TYPE_A ) ? 200 : 286
            anchors.left: parent.left   
            anchors.leftMargin: ( popup.type == RES.const_POPUP_TYPE_F ) ? 67 : 77
            width:661
        }

        /** Buttons */
        DHAVN_AppFileManager_PopUp_Item_Buttons
        {
           id: popupBtn
           focus_id: popup.focus_id
           anchors.right: parent.right
           anchors.rightMargin: CONST.const_POPUP_BUTTON_RIGHT_MARGIN
           anchors.verticalCenter: parent.verticalCenter
           popupType: popup.type
           btnModel: popup.buttons
           onBtnClicked: { popup.btnClicked( btnId ) }
           onLostFocus: popup.lostFocus( arrow, focusID )
           focus_visible: popup.focus_visible
       }
    }
}
