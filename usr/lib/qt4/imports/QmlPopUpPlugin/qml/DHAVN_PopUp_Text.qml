import Qt 4.7
import QtQuick 1.1
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import PopUpConstants 1.0
import AppEngineQMLConstants 1.0


DHAVN_PopUp_Base{
    id: popUpBase

    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}
    property int alignment
    property int _elideMode: Text.ElideNone
    property int _wrapMode: Text.Wrap

    Connections{
        target: UIListener
        onSignalLanguageChanged:{
            popUpBase.langID = lang;
            fontFamily = "DH_HDR"
            LocTrigger.retrigger();
        }
    }

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal stopCloseTimer(variant btnId)
    signal restartCloseTimer(variant btnId)
    signal resetTimerPopupText();
    focus_index: 1

    states: [
        State {
            name: "PopupTypeA"
            //            when: ( buttons.count <= 2 && title.length==0 && id_content.implicitHeight <= 304-(18*2) )
            when: ( buttons.count <= 2 && title.length==0 && id_content.implicitHeight <= 274-(18*2) )
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_A
            }
        },
        State {
            name: "PopupTypeB"
            //            when: ( (buttons.count >= 3 ||  id_content.implicitHeight > 304-(18*2) )&& title.length==0 )
            when: ( (buttons.count >= 3 ||  id_content.implicitHeight > 274-(18*2) )&& title.length==0 )
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_B
            }
        },
        State {
            name: "PopupTypeD"
            when: ((buttons.count <= 2)&& ((title.length>0) && (id_content.implicitHeight <= 274-(18*2))))
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_D
            }
        },
        State {
            name: "PopupTypeE"
            when: ( ((buttons.count >= 3 || (id_content.implicitHeight > 274-(18*2) )))&& title.length>0 )
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_E
            }
        }
    ]
    Connections{
        target: id_content_focus.visible  ? UIListener : null
        onSignalJogNavigation: { doJogNavigation( arrow, status ); }
        onSignalPopupJogNavigation: { doJogNavigation( arrow, status ); }
    }

    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
        case UIListenerEnum.KEY_STATUS_PRESSED:
            switch(arrow)
            {
            case UIListenerEnum.JOG_WHEEL_LEFT:
                console.log("[SystemPopUp] jog_wheel_left")
                console.log("[SystemPopUp] id_content.implicitHeight = ", id_content.implicitHeight)
                if( flic_view.contentY > 0  )
                    flic_view.contentY = (popUpBase.content_size == 26) ? (flic_view.contentY - 22) : (flic_view.contentY - 10)
                break;
            case UIListenerEnum.JOG_WHEEL_RIGHT:
                console.log("[SystemPopUp] jog_wheel_right")
                console.log("[SystemPopUp] id_content.implicitWidth = ", id_content.implicitWidth)
                if( flic_view.contentY < (flic_view.contentHeight - flic_view.height))
                    flic_view.contentY = (popUpBase.content_size == 26) ? (flic_view.contentY + 22) : (flic_view.contentY + 10)
                break;
            case UIListenerEnum.JOG_LEFT:{
                if( popUpBase.langID == 20  )
                    popUpBase.focus_index=1
                break;
            }
            case UIListenerEnum.JOG_RIGHT:{
                if( popUpBase.langID != 20 )
                    popUpBase.focus_index=1
                break;
            }
            }
            break;
//        case UIListenerEnum.KEY_STATUS_PRESSED:
//            switch(arrow)
//            {
//            case UIListenerEnum.JOG_LEFT:{
//                if( UIListener.GetCountryVariantFromQML() === 4 )
//                    popUpBase.focus_index=1
//                break;
//            }
//            case UIListenerEnum.JOG_RIGHT:{
//                if( UIListener.GetCountryVariantFromQML() !== 4 )
//                    popUpBase.focus_index=1
//                break;
//            }
//            }

//            break;
        }
    }

    content: Item {
        id: popup_content

        property bool focus_visible: popUpBase.focus_visible
        property int focus_id: 0

        //anchors.fill:parent
        /** --- Signals --- */
        signal lostFocus( int arrow, int focusID );

//        Image {
//            id: icon
//            width: 100; height: 100
//            source: icon_title === EPopUp.LOADING_ICON ? RES.const_LOADING_IMG_01 : ""
//            anchors.top: parent.top
//            anchors.topMargin: CONST.const_LOADING_TOP_MARGIN
//            anchors.horizontalCenter: parent.horizontalCenter
//            //visible: (icon.on && icon_title === EPopUp.LOADING_ICON)
//            property bool on: parent.visible;
//            //ITS:0217403 dmchoi Setting Animation 방향이 반대로 rotation.
//            //NumberAnimation on rotation {target: icon; running: icon.visible; from: 0; to: 360; loops: Animation.Infinite; duration: 1300 }
//        }

        Image {
            id: icon
            width: 100; height: 100
            source: icon_title === EPopUp.LOADING_ICON ? RES.const_LOADING_IMG_01 : ""
            anchors.top: parent.top
            anchors.topMargin: CONST.const_LOADING_TOP_MARGIN
            anchors.horizontalCenter: parent.horizontalCenter
            visible: icon.on
            property bool on: parent.visible;
            //ITS:0217403 dmchoi Setting Animation 방향이 반대로 rotation.
            //NumberAnimation on rotation { running: icon.on; from: 0; to: 360; loops: Animation.Infinite; duration: 1600 }
            NumberAnimation on rotation { running: icon.on; from: 0; to: 360; loops: Animation.Infinite; duration: 1300 }
        }
        function setDefaultFocus( arrow )
        {
            return popupBtn.setDefaultFocus( arrow )
        }
        //        Item{
        width : parent.width
        height: parent.height - (getMargin())
        anchors.top: parent.top
        anchors.topMargin: getMargin()

//        Rectangle{
//            id: id_rect
//            height: popup_content.height
//            width: popup_content.width
//            color:"red"
//            opacity: 0.5
//            anchors.left: popup_content.left
//            //                anchors.leftMargin: alignment == Text.AlignLeft? CONST.const_TEXT_LEFTALIGN_LEFT_MARGIN:const_TEXT_CENTERALIGN_LEFT_MARGIN
//            anchors.top: popup_content.top
//            visible:true
//        }

        /** Text message */
        function getMargin()
        {
            switch(popUpBase.type)
            {
//            case RES.const_POPUP_TYPE_A:
//                return 50+116//icon_title == EPopUp.LOADING_ICON ? 50+148-16 : 0
//            case RES.const_POPUP_TYPE_B:
//                return 60+148-16//icon_title == EPopUp.LOADING_ICON ? 60+148-16 : 0
            case RES.const_POPUP_TYPE_D:
            case RES.const_POPUP_TYPE_E:
                return CONST.const_POPUPTYPE_D_CONTEXT_TOP_MARGIN
//            case RES.const_POPUP_TYPE_G:
//                return CONST.const_POPUPTYPE_G_TOP_MARGIN
            default:
                return 0
            }
        }

        Image{
            id: id_content_focus
            source: popUpBase.langID != 20 ? RES.const_POPUP_TYPE_B_FOCUS : RES.const_POPUP_TYPE_B_FOCUS_REVERSE
            anchors.left:parent.left
            anchors.leftMargin: popUpBase.langID != 20 ? 18 : 278
            anchors.verticalCenter: parent.verticalCenter
            visible: popUpBase.focus_index == 0 && (popUpBase.type == RES.const_POPUP_TYPE_B||popUpBase.type == RES.const_POPUP_TYPE_E)
        }

        Flickable{
            id: flic_view
            property int  focus_id: 0
            width: buttons.count > 0 ? (popUpBase.content_size == 26 ? 654 : 685) : 980
            height: (popUpBase.type == RES.const_POPUP_TYPE_A || popUpBase.type == RES.const_POPUP_TYPE_E ) ? icon_title == EPopUp.LOADING_ICON ?parent.height-(50+50+100) : parent.height-((64-25)*2) : (popUpBase.content_size == 26) ? 320 : 44*6 - 20//parent.height-(/*(101-25)*/44*2)
            anchors.left : parent.left
            anchors.leftMargin: buttons.count > 0 ?  popUpBase.langID != 20 ? (popUpBase.content_size == 26 ? 76 : 78) : 361 : 78
            anchors.top: parent.top
            anchors.topMargin: id_content.height < flic_view.height ? icon_title == EPopUp.LOADING_ICON ? (parent.height/2) - (id_content.height/2) + 35 : (parent.height/2) - (id_content.height/2) : (popUpBase.content_size == 26 ? 32 : (icon_title == EPopUp.LOADING_ICON ? getTopMargin()+130 : getTopMargin()+25))
            clip: true
            contentHeight: id_content.height
            interactive: id_vert_scroll.visible

            //for debugging
//            Rectangle {
//                anchors.fill: parent
//                color:  "transparent"
//                border.width: 1
//                border.color: "red"
//            }

            function getTopMargin()
            {
                if(popUpBase.type == RES.const_POPUP_TYPE_A || popUpBase.type == RES.const_POPUP_TYPE_D)
                    return 64-30
                else
                    return 39//101-30
            }

            Text{
                id:id_content
                //anchors.verticalCenter:parent.verticalCenter
                anchors.top: parent.top
                anchors.topMargin: icon_title == EPopUp.LOADING_ICON ? 20 : 0
                anchors.left: parent.left
                font.pointSize: popUpBase.content_size
                font.family: popUpBase.fontFamily
                color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
                width: parent.width
                height: ((popUpBase.content_size == 26) && (popUpBase.langID == 20)) ? flic_view.height : null
                verticalAlignment: ((popUpBase.content_size == 26) && (popUpBase.langID == 20)) ? Text.AlignTop : Text.AlignVCenter
                horizontalAlignment : popUpBase.langID != 20 ? (buttons.count != 0 ?  Text.AlignLeft : Text.AlignHCenter) : ( buttons.count != 0 ? /*Text.AlignHCenter*/Text.AlignRight : Text.AlignHCenter )
                text:  message.get(0).msg.substring( 0, 4 ) == "STR_"  ?
                           qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, message.get(0).msg): message.get(0).msg
                wrapMode: _wrapMode
                elide: _elideMode
                style: Text.Sunken
                lineHeight: ((popUpBase.content_size == 26) && (popUpBase.langID == 20)) ? 0.82 : 1

                //for debugging
//                Rectangle {
//                    anchors.fill: parent
//                    color:  "transparent"
//                    border.width: 2
//                    border.color: "blue"
//                }
            }
        }

        DHAVN_PopUp_Item_VerticalScrollBar{
            id: id_vert_scroll
            anchors.left:  parent.left
            anchors.leftMargin: popUpBase.langID != 20 ? 760 : 294
            anchors.top:parent.top
            anchors.topMargin: popUpBase.type == RES.const_POPUP_TYPE_B ? 37 : 37
            position: flic_view.visibleArea.yPosition
            //pageSize: flic_view.contentHeight / flic_view.height
            _height: flic_view.visibleArea.heightRatio
            //_y: flic_view.visibleArea.yPosition
            visible:(flic_view.height < flic_view.contentHeight) && (popUpBase.type == RES.const_POPUP_TYPE_B || popUpBase.type == RES.const_POPUP_TYPE_E )
        }

//        Image{
//            id:id_line_light
//            source: RES.const_POPUP_BUTTON_LINE
//            anchors.top: parent.top
//            anchors.topMargin: 18
//            anchors.left: parent.left
//            anchors.leftMargin: 793
//            z:1
//            visible:true
//        }

        /** Buttons */
        Item{
            id:id_buttons
            anchors.fill: parent
            anchors.centerIn: parent
            Loader{
                id: id_button_loader
                sourceComponent: popUpBase.langID != 20 ? id_BUTTON_NORMAL : id_BUTTON_REVERSE
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
                    __fontFamily: "DH_HDB"
                    onBtnClicked: {
                        console.log("[SystemPopUp] id_content.implicitHeight = ", id_content.implicitHeight)
                        console.log("[SystemPopUp] id_content.implicitWidth = ", id_content.implicitWidth)
                        popUpBase.btnClicked( btnId );
                    }
                    focus_visible: popUpBase.focus_index==1
                    onLostFocus:
                    {
                        if ( arrow === UIListenerEnum.JOG_LEFT && (popUpBase.type==RES.const_POPUP_TYPE_B|| popUpBase.type==RES.const_POPUP_TYPE_E) && id_vert_scroll.visible ==true)
                        {
                            if (id_vert_scroll.visible == true) {
                                console.log("[SystemPopUp] PopUp_Item_Buttons lostfocus")
                                popUpBase.focus_index = 0
                            }
                        }
                        else popUpBase.lostFocus( arrow, popUpBase.focus_id )
                    }
                    onStopPopupTimer_: {
                        console.log("[SystemPopUp] PopUp_Text onStopPopUpTimer_")
                        stopCloseTimer(btnId)
                    }
                    onRestartPopupTimer_: {
                        console.log("[SystemPopUp] PopUp_Text onRestartPopupTimer_")
                        restartCloseTimer(btnId)
                    }
                    onResetTimerPopupButton:{ // restart timer 2013.09.23

                        console.log("[SystemPopUp] PopUp_Text onResetPopupTimer")
                        resetTimerPopupText()
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
                    focus_visible: popUpBase.focus_index==1
                    onLostFocus:
                    {

                        if ( arrow === UIListenerEnum.JOG_RIGHT && (popUpBase.type==RES.const_POPUP_TYPE_B|| popUpBase.type==RES.const_POPUP_TYPE_E) )
                        {
                            if (id_vert_scroll.visible == true) {
                                console.log("[SystemPopUp] PopUp_Item_Buttons_Reverse lostfocus")
                                popUpBase.focus_index = 0
                            }
                        }
                        else popUpBase.lostFocus( arrow, popUpBase.focus_id )
                    }

                    onResetTimerPopupButton:{ // restart timer 2013.09.23

                        console.log("[SystemPopUp] PopUp_Text onResetPopupTimer")
                        resetTimerPopupText()
                    }
                }
            }
        }
    }
}
