import Qt 4.7
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import AppEngineQMLConstants 1.0
import POPUPEnums 1.0
import "General.js" as APC

Item
{
    id: btPopupCtrl
    width: APC.const_SCREEN_WIDTH
    height: APC.const_SCREEN_HEIGHT

    property int language: EngineListenerMain.languageId
    property int pMode: 0
    property string okString: qsTranslate("main","STR_ERROR_VIEW_OK")
    property bool systemPopupVisible: false

    Rectangle {
        width: APC.const_SCREEN_WIDTH
        height: APC.const_SCREEN_HEIGHT
        color: "black"
        opacity: 0.2
    }

    function closePreviousPopup()
    {
        __LOG("closePreviousPopup");
        if(popup.visible == true)
        {
            popup.hidePopup();
        }
    }

    POPUPWIDGET.PopUpText
    {
        id:popup
        z: 1000
        y: 0
        icon_title: EPopUp.NONE_ICON
        visible: false
        message: errorModel
        buttons: btnmodel
        focus_visible: popup.visible && !systemPopupVisible
        property bool showErrorView;
        property bool entryerror : false
        property int errorType: 0
        property string popUpString: ""

        function showPopup(text, errorView)
        {
            entryerror = false;
            popup.showErrorView = errorView;

            switch(text)
            {
                case PopupIDPjtn.POPUP_AAP_BT_FULL :
                    popUpString= qsTranslate("main","STR_AAP_BT_FULL")
                    break;

                case PopupIDPjtn.POPUP_PJTN_OPERATION_NOT_SUPPORTED :
                    popUpString= qsTranslate("main","STR_OPERATION_NOT_SUPPORTED")
                    break;

                case PopupIDPjtn.POPUP_AAP_CONTROL_NOT_AVAILABLE_REAR :
                    popUpString= qsTranslate("main","STR_AAP_CONTROL_NOT_AVAILABLE_REAR")
                    break;

                default :
                    return;
            }

            if(!visible)
            {
                __LOG("showPopup BTPopup.qml");
                closePreviousPopup();

                btnmodel.clear();

                // TODO (if needed) : check system popup, set popup id

                errorModel.set(0,{msg:popUpString})
                btnmodel.set(0,{msg:qsTranslate("main","STR_MNG_YES"),btn_id:"YES"})
                btnmodel.set(1,{msg:qsTranslate("main","STR_MNG_NO"),btn_id:"NO"})
                visible = true;
            }
        }

        function hidePopup()
        {
            popup.visible = false;
            popup.showErrorView = false;
            popup.focus_visible = false;

            // TODO (if needed) : set popup id

        }

        onBtnClicked:
        {
            if( popup.visible === true)
            {
                switch ( btnId )
                {
                    case "YES":
                    {
                        __LOG("Pressed YES");
                        if(root.state === "BTPopupState" && !systemPopupVisible)
                        {
                            popup.hidePopup();
                            EngineListenerMain.handleQmlBTPopupPressed(true);
                        }
                    }
                    break;

                    case "NO":
                    {
                        __LOG("Pressed NO");
                        if(root.state === "BTPopupState" && !systemPopupVisible)
                        {
                            popup.hidePopup();
                            EngineListenerMain.handleQmlBTPopupPressed(false);
                        }
                    }
                    break;
                }
            }
        }

        // TODO (if needed) :  handling visibleChanged
    }

    ListModel
    {
        id: btnmodel
        ListElement
        {
            btn_id: "YES"
            msg: "YES"
        }
        ListElement
        {
            btn_id: "NO"
            msg: "NO"
        }
    }

    ListModel
    {
        id: errorModel
        ListElement
        {
            msg: ""
        }
    }

    Connections {
        target: EngineListenerMain

        onRetranslateUi:
        {
            language = languageId;

            LocTrigger.retrigger()
        }

        onNotiBTPopup:
        {
            __LOG("BTPopup onNotiBTPopup " + isShow)
            if (isShow == true)
                popup.showPopup(PopupIDPjtn.POPUP_AAP_BT_FULL, false)
            else
                popup.hidePopup()
        }

        onNotiSysPopup:
        {
            __LOG("BTPopup onNotiSysPopup " + isShow)
            systemPopupVisible = isShow
        }

    }
    Component.onCompleted:
    {
        popup.showPopup(PopupIDPjtn.POPUP_AAP_BT_FULL, false)
    }
}
