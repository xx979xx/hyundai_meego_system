import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import PopUpConstants 1.0

DHAVN_PopUp_Base
{
    id: popUpBase

    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}

    /** --- Signals --- */
    signal btnClicked( variant btnId )

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

    content: Item
    {
        id: popup_content

        property bool focus_visible: popUpBase.focus_visible
        property int focus_id: 0

        anchors.centerIn: parent

        /** --- Signals --- */
        signal lostFocus( int arrow, int focusID );

        function setDefaultFocus( arrow )
        {
            return popupBtn.setDefaultFocus( arrow )
        }
//        Rectangle{
//            color:"red"
//            opacity:0.5
//            width:aaa.width
//            height:aaa.height
//            anchors.left: aaa.left
//            anchors.top: aaa.top
//            visible:true
//        }

Item{
    height: supertext.height
    width : 661
    anchors.left: parent.left
    anchors.leftMargin: 77
    anchors.verticalCenter: parent.verticalCenter
    //anchors.verticalCenter: parent.verticalCenter
//    anchors.bottom: parent.bottom
        /** Text message */
//    Rectangle{
//        color:"yellow"
//        opacity:0.5
//        width:supertext.width
//        height:supertext.height
//        anchors.left: supertext.left
//        anchors.top: supertext.top
//        visible:true
//    }
        DHAVN_PopUp_Item_PropertyTable
        {
            id: supertext
            propertyModel: message

//            anchors.centerIn: parent.Center
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.fill: parent
//            anchors.verticalCenterOffset: CONST.const_TEXT_SPACING_32

            anchors.left: parent.left
            fontFamily:popUpBase.fontFamily
//            anchors.leftMargin: 77

            txtOnly: ( buttons.count < 0 )

        }
}

        /** Buttons */
        DHAVN_PopUp_Item_Buttons
        {
            id: popupBtn
            focus_id: 1
            __fontFamily:"DH_HDB"
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_BUTTON_LEFT_MARGIN
            anchors.verticalCenter: parent.verticalCenter
            btnModel: popUpBase.buttons
            popupType:popUpBase.type
            onBtnClicked: { popUpBase.btnClicked( btnId ) }
            focus_visible: popUpBase.focus_visible
            onLostFocus: parent.lostFocus( arrow, focusID )
        }
    }
}
