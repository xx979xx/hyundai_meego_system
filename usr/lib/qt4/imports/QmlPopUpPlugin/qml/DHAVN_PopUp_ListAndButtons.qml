import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

DHAVN_PopUp_Base
{
    id: popup

    /** --- Input parameters --- */
    property ListModel listmodel: ListModel {}
    property ListModel buttons: ListModel {}
    property bool bIsNoActiv: false
    property int visibleLine
    property int nCurIndex
    property int item_list_height
    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal listItemClicked( variant index )
    states: [
        State {
            name: "PopupA"
            when: listmodel.count <= 3 && title.length== 0 && buttons.count <= 2
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_A;
            }
        },
        State {
            name: "PopupB"
            when: (listmodel.count > 3 || buttons.count > 2)  && title.length==0
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_B;
            }
        },
        State {
            name: "PopupD"
            when: listmodel.count <= 3 && title.length>0 && buttons.count <= 2
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_D;
            }
        },
        State {
            name: "PopupE"
            when: (listmodel.count > 3  || buttons.count > 2) && title.length>0
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_E;
            }
        }
   ]

    Connections
    {
        target:UIListener// id_content_focus.visible ? UIListener : null
        onSignalJogNavigation: { doJogNavigation( arrow, status ); }
        onSignalPopupJogNavigation: { doJogNavigation( arrow, status ); }
    }
    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
//        case UIListenerEnum.KEY_STATUS_CLICKED:
//            switch(arrow)
//            {
//            case UIListenerEnum.JOG_WHEEL_LEFT:
//                console.log("jog_wheel_left")
//                if( itemList.contentY > 0  )
//                    itemList.contentY = itemList.contentY - 10
//                break;
//            case UIListenerEnum.JOG_WHEEL_RIGHT:
//                console.log("jog_wheel_right")
//                if( itemList.contentY <= itemList.contentHeight - itemList.height )
//                    itemList.contentY = itemList.contentY + 10
//                break;

//            }
//            break;
        case UIListenerEnum.KEY_STATUS_PRESSED:
            switch(arrow)
            {
                case UIListenerEnum.JOG_LEFT:{
                    console.log("[SystemPopUp] JOG_LEFT")
                    if( popup.langID == 20 )
                        popup.focus_index=1
                    else
                        popup.focus_index=0

                    break;
                }
                case UIListenerEnum.JOG_RIGHT:{
                    console.log("[SystemPopUp] JOG_RIGHT")
                    if( popup.langID != 20 )
                        popup.focus_index=1
                    else
                        popup.focus_index=0
                    break;
                }
            }

            break;
        }

    }
    /** --- Child object --- */
  //  type: ( listmodel.count > 3 ) ?  RES.const_POPUP_TYPE_B : RES.const_POPUP_TYPE_A
    content: Item
    {
        id: popup_content
        width : parent.width
        height: parent.height - getMargin()
        anchors.top: parent.top
        anchors.topMargin: getMargin()
        property int focus_index: 0
        property int focus_id: -1
        property bool focus_visible: false

        /** --- topMargin for button --- */
//        property int indent: (popup.type == RES.const_POPUP_TYPE_ETC_04) ? 360 : 271

        signal lostFocus( int arrow, int focusID )
        function getMargin()
        {
            switch(popup.type)
            {
            case RES.const_POPUP_TYPE_D:
            case RES.const_POPUP_TYPE_E:
                return CONST.const_POPUPTYPE_D_CONTEXT_TOP_MARGIN
            default:
                return 0
            }
        }
        function setDefaultFocus( arrow )
        {
            focus_index = 0
            if ( listmodel.count > 0 ) return focus_id
            if ( buttons.count > 0 )
            {
                focus_index = 1
                return focus_id
            }
            lostFocus( arrow, focus_id )
            return -1
        }
//        Rectangle
//        {
//            width:itemList.width
//            height:itemList.height
//            color:"red"
//            opacity: 0.5
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.left: popup_content.left
//        }
        Item{
            anchors.fill: parent
            anchors.centerIn: parent
            Loader{
                sourceComponent: popup.langID != 20 ? id_LIST_NORMAL : id_LIST_REVERSE

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: popup.langID != 20 ? 0 : 292
            }
            Component{
                id: id_LIST_NORMAL
                DHAVN_PopUp_Item_List
                {
                    id: itemList

                    focus_id: 0
                    focus_visible: popup.focus_index == 0//( parent.focus_index == 0 ) /*&& parent.focus_visible*/
                    height: listmodel.count>3 ? itemHeight * 4 :  itemHeight * listmodel.count//itemHeight * item_list_height//( listmodel.count > 3 ) ? itemHeight * 4 : itemHeight * 3
                    width: CONST.const_POPUP_TYPE_B_CONTENT_AREA_WIDTH_WITH_BUTTON+CONST.const_V_SCROLLBAR_WIDTH
                    list: popup.listmodel
                    itemHeight: CONST.const_LIST_AND_BUTTONS_ITEM_HEIGHT
                    separatorPath: RES.const_POPUP_LIST_LINE
                    currentIndex: nCurIndex
                    _fontFamily: popup.fontFamily
                    boundsBehavior: Flickable.StopAtBounds

//                    anchors{
//                        left: popup_content.left;
//                        verticalCenter: parent.verticalCenter
//                    }

                    onItemClicked: popup.listItemClicked( itemId )

                    onLostFocus:
                    {
                        if ( arrow == UIListenerEnum.JOG_RIGHT && buttons.count > 0 )
                            popup.focus_index = 1
                        else popup_content.lostFocus( arrow, popup_content.focus_id )
                    }
                    function getTopMargin()
                    {
                        switch(listmodel.count)
                        {
                        case 1:
                            return CONST.const_LIST_1_LINE_TOP_MARGIN;
                        case 2:
                            return CONST.const_LIST_2_LINE_TOP_MARGIN;
                        case 3:
                            return CONST.const_LIST_3_LINE_TOP_MARGIN;
                        case 4:
                        default:
                            return CONST.const_LIST_4_LINE_TOP_MARGIN;
                        }
                    }
                } //DHAVN_PopUp_Item_List
            }//Component
            Component{
                id: id_LIST_REVERSE
                DHAVN_PopUp_Item_List_REVERSE
                {
                    id: itemList

                    focus_id: 0
                    focus_visible: ( parent.focus_index == 0 ) && parent.focus_visible
                    height: listmodel.count>3 ? itemHeight * 4 :  itemHeight * listmodel.count//itemHeight * item_list_height//( listmodel.count > 3 ) ? itemHeight * 4 : itemHeight * 3
                    width: CONST.const_POPUP_TYPE_B_CONTENT_AREA_WIDTH_WITH_BUTTON+CONST.const_V_SCROLLBAR_WIDTH
                    list: popup.listmodel
                    itemHeight: CONST.const_LIST_AND_BUTTONS_ITEM_HEIGHT
                    separatorPath: RES.const_POPUP_LIST_LINE
                    currentIndex: nCurIndex
                    boundsBehavior: Flickable.StopAtBounds
                    _fontFamily: popup.fontFamily

//                    anchors{
//                        left: popup_content.left;
//                        verticalCenter: parent.verticalCenter
//                    }

                    onItemClicked: popup.listItemClicked( itemId )

                    onLostFocus:
                    {
                        if ( arrow == UIListenerEnum.JOG_RIGHT && buttons.count > 0 )
                            popup_content.focus_index = 1
                        else popup_content.lostFocus( arrow, popup_content.focus_id )
                    }
                    function getTopMargin()
                    {
                        switch(listmodel.count)
                        {
                        case 1:
                            return CONST.const_LIST_1_LINE_TOP_MARGIN;
                        case 2:
                            return CONST.const_LIST_2_LINE_TOP_MARGIN;
                        case 3:
                            return CONST.const_LIST_3_LINE_TOP_MARGIN;
                        case 4:
                        default:
                            return CONST.const_LIST_4_LINE_TOP_MARGIN;
                        }
                    }
                } //DHAVN_PopUp_Item_List_REVERSE
            }//Component
        }

        Item{
            anchors.fill: parent
            anchors.centerIn: parent
            Loader{ sourceComponent: popup.langID != 20 ? id_BUTTON_NORMAL : id_BUTTON_REVERSE
                anchors.left: parent.left
                anchors.leftMargin: popup.langID != 20  ? CONST.const_BUTTON_LEFT_MARGIN : CONST.const_BUTTON_LEFT_MARGIN_REVERSE
                anchors.verticalCenter: parent.verticalCenter
            }
            Component{
                id: id_BUTTON_NORMAL
                DHAVN_PopUp_Item_Buttons
                {
                    btnModel: popup.buttons
                    focus_id: 1
                    focus_visible:popup.focus_index == 1// ( parent.focus_index == 1 ) && parent.focus_visible
//                    anchors.left: parent.left
//                    anchors.leftMargin: CONST.const_BUTTON_LEFT_MARGIN
//                    anchors.verticalCenter: parent.verticalCenter
                    popupType: popup.type
                    __fontFamily: "DH_HDB"
                    onBtnClicked: popup.btnClicked( btnId )
                    onLostFocus:
                    {
                        if ( arrow === UIListenerEnum.JOG_LEFT && listmodel.count > 0 )
                            popup_content.focus_index = 0
                        else popup_content.lostFocus( arrow, popup_content.focus_id )
                    }
                }//DHAVN_PopUp_Item_Buttons
            }//Component
            Component{
                id: id_BUTTON_REVERSE
                DHAVN_PopUp_Item_Buttons_Reverse
                {
                    btnModel: popup.buttons
                    focus_id: 1
                    focus_visible: popup.focus_index == 1// ( parent.focus_index == 1 ) && parent.focus_visible
//                    anchors.left: parent.left
//                    anchors.leftMargin: CONST.const_BUTTON_LEFT_MARGIN
//                    anchors.verticalCenter: parent.verticalCenter
                    popupType: popup.type
                    __fontFamily: "DH_HDB"
                    onBtnClicked: popup.btnClicked( btnId )
                    onLostFocus:
                    {
                        if ( arrow === UIListenerEnum.JOG_LEFT && listmodel.count > 0 )
                            popup_content.focus_index = 0
                        else popup_content.lostFocus( arrow, popup_content.focus_id )
                    }
                }//DHAVN_PopUp_Item_Buttons
            }//Component
        }
    }
}
