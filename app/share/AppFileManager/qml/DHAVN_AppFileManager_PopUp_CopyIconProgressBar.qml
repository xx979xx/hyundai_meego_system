import Qt 4.7
import "DHAVN_AppFileManager_PopUp_Resources.js" as RES
import "DHAVN_AppFileManager_PopUp_Constants.js" as CONST
import "DHAVN_AppFileManager_PopUp_Constants.js" as EPopUp 

//[KOR][ITS][170734][comment] (aettie.ji)
DHAVN_AppFileManager_PopUp_Base
{
    id: popup

    /** --- Input parameters --- */
    property bool enableCloseBtn: false
    property ListModel message_s: ListModel {}
    property ListModel buttons: ListModel {}
    property variant progressMin_s
    property variant progressMax_s
    property variant progressCur_s
    property string type
    property int iconType

    property int offset_y 

    focus_index: 0

    type: RES.const_POPUP_TYPE_B

    /** --- Signals --- */
    signal btnClicked( variant btnId )

    /** --- Signals --- */
    signal lostFocus( int arrow, int focusID );

    function setDefaultFocus( arrow )
    {
        return popupBtn.setDefaultFocus( arrow )
    }

    Image
    {
        id: content
        source: type

        anchors
        {
          left: parent.left; leftMargin: getLeftMargin()
          top: parent.top; topMargin: getTopMargin()
        }

       DHAVN_AppFileManager_PopUp_Item_CopyIcon
        {
            id: copy_icon
            anchors.top: parent.top
            anchors.topMargin: 69
            anchors.left : parent.left
            anchors.leftMargin : 77 + ((661-636)/2)
            iconType:popup.iconType
        }

        DHAVN_AppFileManager_PopUp_Item_SuperText
        {
        	id: progress_text_s
            txtModel: message_s
            anchors.top: parent.top
            anchors.topMargin: 202
            alignment:Text.AlignLeft 
            anchors.leftMargin: alignment == Text.AlignLeft? CONST.const_TEXT_LEFTALIGN_LEFT_MARGIN:57 
            width: 661
            height: message_s.count * 44
        }

        /** Progress bar */
        DHAVN_AppFileManager_PopUp_Item_ProgressBar
        {
            id: progress_bar_s
            min: progressMin_s
            max: progressMax_s
            cur: progressCur_s
            anchors.top: parent.top
            anchors.topMargin: 224 + 118 - 30
            anchors.left: parent.left   
            anchors.leftMargin: 77
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
