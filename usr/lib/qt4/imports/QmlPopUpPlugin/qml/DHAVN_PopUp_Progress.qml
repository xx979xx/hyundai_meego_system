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
    property int progressMin
    property int progressMax
    property int progressCur
    property bool useRed: false

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal btnPressed( variant btnId )
    focus_visible:true
    states: [
        State {
            name: "PopupTypeA"
            when: ( (id_content.height<45*2)&& title.length== 0)
            PropertyChanges {target: popUpBase; type: RES.const_POPUP_TYPE_A}
        },
        State {
            name: "PopupTypeB"
            when: ( (id_content.height >= 45*2)&&title.length== 0)
            PropertyChanges {target: popUpBase;type: RES.const_POPUP_TYPE_B}
        },
        State {
            name: "PopupTypeD"
            when: ( (id_content.height < 45*2)&&title.length> 0)
            PropertyChanges {target: popUpBase;type: RES.const_POPUP_TYPE_D}
        },
        State {
            name: "PopupTypeE"
            when: ( (id_content.height >= 45*2)&&title.length> 0)
            PropertyChanges {target: popUpBase;type: RES.const_POPUP_TYPE_E}
        }
    ]

    content: Item
    {
        id: popup_content

        property bool focus_visible: popUpBase.focus_visible
        property int focus_id: 0

//        anchors.centerIn: parent
//        anchors.fill:parent
        width : parent.width
        height: parent.height - getMargin()
        anchors.top: parent.top
        anchors.topMargin: getMargin()
        function getMargin()
        {
            switch(popUpBase.type)
            {
            case RES.const_POPUP_TYPE_D:
            case RES.const_POPUP_TYPE_E:
                return CONST.const_POPUPTYPE_D_CONTEXT_TOP_MARGIN//const_POPUPTYPE_D_TOP_MARGIN //
            default:
                return 0
            }
        }
        /** --- Signals --- */
        signal lostFocus( int arrow, int focusID );

        function setDefaultFocus( arrow )
        {
            return popupBtn.setDefaultFocus( arrow )
        }

        Text //content
        {
            id:id_content
            anchors.verticalCenter:parent.verticalCenter
            anchors.verticalCenterOffset: -36
            anchors.left: parent.left
            anchors.leftMargin:popUpBase.langID != 20 ? (buttons.count > 0 ? 77 : 57) : (buttons.count > 0 ? 355 : 57)
            horizontalAlignment: popUpBase.langID != 20 ? (buttons.count > 0 ? Text.AlignLeft : Text.AlignHCenter) : (buttons.count > 0 ? Text.AlignRight : Text.AlignHCenter)
            font.pointSize: 32
            font.family: popUpBase.fontFamily
            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
            width: buttons.count > 0 ? 661 : 820+160
          //  horizontalAlignment: buttons.count > 0 ? Text.AlignLeft : Text.AlignHCenter
            clip: true
            text:  ( message.get(0).msg.substring( 0, 4 ) === "STR_" ) ?
                                               qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, message.get(0).msg):
                                               message.get(0).msg
            wrapMode: Text.WordWrap
        }


        /** Progress bar */
        Item{
            anchors.fill: parent
            anchors.centerIn: parent
            Loader{
                sourceComponent: popUpBase.langID != 20 ? id_PROGRESSBAR_NORMAL : id_PROGRESSBAR_NORMAL
                anchors.bottom:  parent.bottom
                anchors.bottomMargin:  popUpBase.type == RES.const_POPUP_TYPE_A ? 95 : 98
                anchors.left: parent.left
                anchors.leftMargin: popUpBase.langID != 20 ? buttons.count > 0 ? 77 : 57+160 : buttons.count > 0 ? 355 : 56+159

            }
            Component{
                id: id_PROGRESSBAR_NORMAL
                DHAVN_PopUp_Item_ProgressBar
                {
                    id: progress_bar
                    min: progressMin
                    max: progressMax
                    cur: progressCur
                    useRed: popUpBase.useRed
//                    anchors.bottom:  parent.bottom
//                    anchors.bottomMargin:  popUpBase.type == RES.const_POPUP_TYPE_A ? 95 : 98
//                    anchors.left: parent.left
//                    anchors.leftMargin: buttons.count > 0 ? 77 : 57+160
                }
            }
            Component{
                id: id_PROGRESSBAR_REVERSE
                DHAVN_PopUp_Item_ProgressBar_REVERSE
                {
                    id: progress_bar
                    min: progressMin
                    max: progressMax
                    cur: progressCur
                    useRed: popUpBase.useRed
//                    anchors.bottom:  parent.bottom
//                    anchors.bottomMargin:  popUpBase.type == RES.const_POPUP_TYPE_A ? 95 : 98
//                    anchors.left: parent.left
//                    anchors.leftMargin: buttons.count > 0 ? 355 : 56+159
                }
            }
        }
        /** Buttons */
//        DHAVN_PopUp_Item_Buttons
//        {
//            id: popupBtn
//            focus_id: 1
//            anchors.left: parent.left
//            anchors.leftMargin: CONST.const_BUTTON_LEFT_MARGIN
//            anchors.verticalCenter: parent.verticalCenter
//            btnModel: popUpBase.buttons
//            popupType: popUpBase.type
//            onBtnClicked: { popUpBase.btnClicked( btnId ) }
//            onFocusHide:  {popUpBase.focus_visible=false }
//            focus_visible: true// popUpBase.focus_visible
//            onLostFocus: parent.lostFocus( arrow, focusID )
//            __fontFamily: popUpBase.getFont() == "NewHDR" ? "NewHDB" : popUpBase.getFont()
//        }
        Item{
            anchors.fill: parent
            anchors.centerIn: parent
            Loader{ sourceComponent: popUpBase.langID != 20 ? id_BUTTON_NORMAL : id_BUTTON_REVERSE
                anchors.left: parent.left
                anchors.leftMargin: popUpBase.langID != 20  ? CONST.const_BUTTON_LEFT_MARGIN : CONST.const_BUTTON_LEFT_MARGIN_REVERSE
                anchors.verticalCenter: parent.verticalCenter
            }
            Component{
                id: id_BUTTON_NORMAL
                DHAVN_PopUp_Item_Buttons
                {
                    id: popupBtn
                    focus_id: 1
                    popupType:popUpBase.type
                    btnModel: popUpBase.buttons
                    __fontFamily:"DH_HDB"
                    onBtnClicked: {
                        popUpBase.btnClicked( btnId );
                    }
                    focus_visible: true//popUpBase.focus_index==1
                    onLostFocus:
                    {
                        if ( arrow === UIListenerEnum.JOG_LEFT && (popUpBase.type==RES.const_POPUP_TYPE_B|| popUpBase.type==RES.const_POPUP_TYPE_E) )
                        {
                            console.log("[SystemPopUp] PopUp_Item_Buttons lostfocus")
                            popUpBase.focus_index = 0
                        }
                        else popUpBase.lostFocus( arrow, popUpBase.focus_id )
                    }
                }
            }
            Component{
                id: id_BUTTON_REVERSE
                DHAVN_PopUp_Item_Buttons_Reverse
                {
                    id: popupBtn
                    focus_id: 1
                    popupType:popUpBase.type
                    anchors.verticalCenter: parent.verticalCenter
                    btnModel: popUpBase.buttons
                    __fontFamily:"DH_HDB"
                    onBtnClicked: {
                        popUpBase.btnClicked( btnId );
                    }
                    focus_visible: true//popUpBase.focus_index==1
                    onLostFocus:
                    {
                        if ( arrow === UIListenerEnum.JOG_RIGHT && (popUpBase.type==RES.const_POPUP_TYPE_B|| popUpBase.type==RES.const_POPUP_TYPE_E) )
                        {
                            console.log("[SystemPopUp] PopUp_Item_Buttons_Reverse lostfocus")
                            popUpBase.focus_index = 0
                        }
                        else popUpBase.lostFocus( arrow, popUpBase.focus_id )
                    }
                }
            }
        }
    }
}
