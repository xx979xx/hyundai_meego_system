import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Import.js" as IMP

DHAVN_PopUp_Base
{
    id: popupBase
    /** --- Input parameters --- */
    property ListModel listmodel: ListModel {}
    property ListModel buttons: ListModel {}  
    property int nCurIndex
    property int button_location
    property int item_list_height

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal radioBtnClicked( variant index )
    signal jogSelect(int selected_index)

    onNCurIndexChanged: itemList.currentIndex = nCurIndex

    states: [
        State {
            name: "PopupA"
            when: ( listmodel.count <= 3 && buttons.count <= 2 ) && ( title.length== 0)
            PropertyChanges {
                target: popupBase
                type: RES.const_POPUP_TYPE_A;
            }
        },
        State {
            name: "PopupB"
            when: (listmodel.count > 3 || buttons.count > 2) && ( title.length == 0)
            PropertyChanges {
                target: popupBase
                type: RES.const_POPUP_TYPE_B;
            }
        },
        State {
            name: "PopupD"
            when: (listmodel.count <= 3 && buttons.count <= 2) && title.length>0
            PropertyChanges {
                target: popupBase
                type: RES.const_POPUP_TYPE_D;
            }
        },
        State {
            name: "PopupE"
            when: (listmodel.count > 3 || buttons.count > 2 ) &&  title.length>0
            PropertyChanges {
                target: popupBase
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
                    if( langID == 20 )
                        popupBase.focus_index=1
                    else
                        popupBase.focus_index=0

                    break;
                }
                case UIListenerEnum.JOG_RIGHT:{
                    if( langID != 20 )
                        popupBase.focus_index=1
                    else
                        popupBase.focus_index=0
                    break;
                }
            }

            break;
        }

    }

    /** --- Child object --- */
    content: Item
    {
        id: popup_content
        width : parent.width
        height: parent.height - getMargin()
        anchors.top: parent.top
        anchors.topMargin: getMargin()
        property int focus_index: popupBase.focus_index
        property int focus_id: -1
        property bool focus_visible: true
        signal lostFocus( int arrow, int focusID )
        function getMargin()
        {
            switch(popupBase.type)
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
            popupBase.focus_index=1
            return
            //return popupBtn.setDefaultFocus( arrow )
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

//        Image{
//            id: id_content_focus
//            source: UIListener.GetCountryVariantFromQML() !== 4 ? RES.const_POPUP_TYPE_B_FOCUS : RES.const_POPUP_TYPE_B_FOCUS_REVERSE
//            anchors.left:parent.left
//            anchors.leftMargin: UIListener.GetCountryVariantFromQML() !== 4 ? 18 : 278
//            anchors.verticalCenter: parent.verticalCenter
//            visible: popupBase.focus_index == 0 && (popupBase.type == RES.const_POPUP_TYPE_B||popupBase.type == RES.const_POPUP_TYPE_E)

//        }
        Item{
            anchors.fill: parent
            anchors.centerIn: parent
            Loader{
                sourceComponent: langID != 20 ? id_CHECKBOXLIST_NORMAL : id_CHECKBOXLIST_REVERSE

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: langID != 20 ? 0 : 292
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
            Component{
                id: id_CHECKBOXLIST_NORMAL
                DHAVN_PopUp_Item_CheckBox_List
                {
                    id: itemList
                    focus_id: 0
                    focus_visible: popupBase.focus_index == 0
                    height: listmodel.count>3 ? itemHeight * 4 :  itemHeight * listmodel.count
                    width: CONST.const_POPUP_TYPE_B_CONTENT_AREA_WIDTH_WITH_BUTTON+CONST.const_V_SCROLLBAR_WIDTH
                    list: popupBase.listmodel
                    itemHeight: CONST.const_RADIO_LIST_ITEM_HEIGHT
                    separatorPath: RES.const_POPUP_LIST_LINE
                    _fontFamily: popupBase.getFont()
                    onJogSelect:popupBase.jogSelect(selected_index)
                    onItemClicked:
                    {
                        currentIndex = itemId
                        popupBase.radioBtnClicked( itemId )
                    }
                    onLostFocus:
                    {
                        if ( arrow == UIListenerEnum.JOG_RIGHT && buttons.count > 0 )
                            popupBase.focus_index = 1
                        else popup_content.lostFocus( arrow, popup_content.focus_id )
                    }

                    onCurrentIndexChanged:
                    {
                       console.log("[SystemPopUp] onCurrentIndexChanged currentIndex = ", + currentIndex);
                    }
                    onHideFocus: popupBase.hideFocus()
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
                } //DHAVN_PopUp_Item_CheckBox_List
            } //component
            Component{
                id: id_CHECKBOXLIST_REVERSE
                DHAVN_PopUp_Item_CheckBox_List_REVERSE
                {
                    id: itemList
                    focus_id: 0
                    focus_visible: popupBase.focus_index == 0
                    height: listmodel.count>3 ? itemHeight * 4 :  itemHeight * listmodel.count
                    width: CONST.const_POPUP_TYPE_B_CONTENT_AREA_WIDTH_WITH_BUTTON+CONST.const_V_SCROLLBAR_WIDTH
                    list: popupBase.listmodel
                    itemHeight: CONST.const_RADIO_LIST_ITEM_HEIGHT
                    separatorPath: RES.const_POPUP_LIST_LINE
                    _fontFamily: popupBase.getFont()
//                    anchors{
//                        top: popup_content.top; topMargin: getTopMargin();
//                        left: popup_content.left; /*leftMargin: CONST.const_LIST_LEFT_MARGIN*/
//                        /*right: popup_content.left+CONST.const_BUTTON_LEFT_MARGIN*/ }
                    onJogSelect:popupBase.jogSelect(selected_index)
                    onItemClicked:
                    {
                        currentIndex = itemId
                        popupBase.radioBtnClicked( itemId )
                    }
                    onLostFocus:
                    {
                        if ( arrow == UIListenerEnum.JOG_RIGHT && buttons.count > 0 )
                            popupBase.focus_index = 1
                        else popup_content.lostFocus( arrow, popup_content.focus_id )
                    }

                    onCurrentIndexChanged:
                    {
                       console.log("[SystemPopUp] onCurrentIndexChanged currentIndex = ", + currentIndex);
                    }
                    onHideFocus: popupBase.hideFocus()
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
                } //DHAVN_PopUp_Item_CheckBox_List
            }
        }





        Item{
            anchors.fill: parent
            anchors.centerIn: parent
            Loader{ sourceComponent: langID != 20 ? id_BUTTON_NORMAL : id_BUTTON_REVERSE
                anchors.left: parent.left
                anchors.leftMargin: langID != 20  ? CONST.const_BUTTON_LEFT_MARGIN : CONST.const_BUTTON_LEFT_MARGIN_REVERSE
                anchors.verticalCenter: parent.verticalCenter
            }
            Component{
                id: id_BUTTON_NORMAL
                DHAVN_PopUp_Item_Buttons
                {
                    id: popupBtn
                    focus_id: 1
                    popupType:popupBase.type
                    btnModel: popupBase.buttons
                    __fontFamily:"DH_HDB"
                    onBtnClicked: {
                        popupBase.btnClicked( btnId );
                    }
                    focus_visible: popupBase.focus_index==1
                    onLostFocus:
                    {
                        if ( arrow === UIListenerEnum.JOG_LEFT && (popupBase.type==RES.const_POPUP_TYPE_B|| popupBase.type==RES.const_POPUP_TYPE_E) )
                        {
                            console.log("[SystemPopUp] DHAVN_PopUp_Item_Buttons lostfocus")
                            popupBase.focus_index = 0
                        }
                        else popupBase.lostFocus( arrow, popupBase.focus_id )
                    }
                }
            }
            Component{
                id: id_BUTTON_REVERSE
                DHAVN_PopUp_Item_Buttons_Reverse
                {
                    id: popupBtn
                    focus_id: 1
                    popupType:popupBase.type
                    anchors.verticalCenter: parent.verticalCenter
                    btnModel: popupBase.buttons
                    __fontFamily:"DH_HDB"
                    onBtnClicked: {
                        popupBase.btnClicked( btnId );
                    }
                    focus_visible: popupBase.focus_index==1
                    onLostFocus:
                    {
                        if ( arrow === UIListenerEnum.JOG_RIGHT && (popupBase.type==RES.const_POPUP_TYPE_B|| popupBase.type==RES.const_POPUP_TYPE_E) )
                        {
                            console.log("[SystemPopUp] DHAVN_PopUp_Item_Buttons_Reverse lostfocus")
                            popupBase.focus_index = 0
                        }
                        else popupBase.lostFocus( arrow, popupBase.focus_id )
                    }
                }
            }
        }
    }
onTypeChanged: {
    console.log("[SystemPopUp] Type changed " + popupBase.type)
}
}
