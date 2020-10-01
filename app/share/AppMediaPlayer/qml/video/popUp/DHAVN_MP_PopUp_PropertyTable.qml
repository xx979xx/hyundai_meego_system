import Qt 4.7
import "DHAVN_MP_PopUp_Resources.js" as RES
import "DHAVN_MP_PopUp_Constants.js" as CONST
//import PopUpConstants 1.0  remove by edo.lee 2013.01.26
import "DHAVN_MP_PopUp_Constants.js" as EPopUp //added by edo.lee 2013.01.26

DHAVN_MP_PopUp_Base
{
    id: popUpBase

    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}
    property int offset_y:0 //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
    /** --- Signals --- */
    signal btnClicked( variant btnId )
    property bool focus_visible: popUpBase.focus_visible
    property int focus_id: 0

    /** --- Signals --- */
    signal lostFocus( int arrow, int focusID );

    function setDefaultFocus( arrow )
    {
        return popupBtn.setDefaultFocus( arrow )
    }

    states: [
        State {
            name: "PopupWithoutTitle"
            when: ( title == "" )
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_B
            }
            PropertyChanges {
                target: supertext
                anchors.verticalCenterOffset: -40
            }
        },
        State {
            name: "PopupWithTitle"
            when: ( title != "" )
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_E
            }
            PropertyChanges {
                target: supertext
                anchors.verticalCenterOffset: 0
            }
        }
    ]

    Image
    {
        id: content
        source: type

        anchors
        {
          left: parent.left; leftMargin: getTopMargin()
          top: parent.top; topMargin: getLeftMargin()
        }

        Item
        {
            height: supertext.height
            width : 661
            anchors.left: parent.left
            anchors.leftMargin: 77
            anchors.verticalCenter: parent.verticalCenter

            DHAVN_MP_PopUp_Item_PropertyTable
            {
                id: supertext
                propertyModel: message
                anchors.left: parent.left
                txtOnly: ( buttons.count < 0 )
            }
         }

         DHAVN_MP_PopUp_Item_Buttons
         {
             id: popupBtn
             focus_id: 1
             anchors.left: parent.right
             anchors.rightMargin: CONST.const_POPUP_BUTTON_RIGHT_MARGIN
             anchors.verticalCenter: parent.verticalCenter
             btnModel: popUpBase.buttons
             popupType:popUpBase.type
             onBtnClicked: { popUpBase.btnClicked( btnId ) }
             focus_visible: popUpBase.focus_visible
             onLostFocus: parent.lostFocus( arrow, focusID )
         }
    }
}
