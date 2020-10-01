import Qt 4.7
import QmlModeAreaWidget 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import AppEngineQMLConstants 1.0
import QmlOptionMenu 1.0
import QmlSimpleItems 1.0
import PandoraMenuItems 1.0
import CQMLLogUtil 1.0

Item{
    id: pandoraStationEntryErrorView
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT
    x: 0
    y: 0

    //properties declaration
    property bool isFromErrorView: false
    property bool focusVisible: true
    property alias isOptionsMenuVisible: optMenu.visible
    property bool isInsufficientEEV: false; 

    property string logString :""

    //Declaration of QML Signals
    //signal handleBackRequest
    signal handleBackRequest(bool isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
    signal searchButtonClicked

    Text {
        id: firstLine
        text:qsTranslate("main","STR_PANDORA_STATION_ENTRY_ERROR_VIEW_TEXT1");
        y: 273 //PR.const_PANDORA_ERROR_VIEW_TEXT1_Y_OFFSET
        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: PR.const_PANDORA_CONNECTING_TEXT_FONT_SIZE
        font.family: PR.const_PANDORA_CONNECTING_TEXT_FONT_FAMILY
    }
    Text {
        id: secondLine
        text:qsTranslate("main","STR_PANDORA_STATION_ENTRY_ERROR_VIEW_TEXT2");
        y: firstLine.y + 60 //PR.const_PANDORA_ERROR_VIEW_TEXT2_Y_OFFSET
        font.pointSize: PR.const_PANDORA_CONNECTING_TEXT_FONT_SIZE
        font.family: PR.const_PANDORA_CONNECTING_TEXT_FONT_FAMILY
        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        anchors.horizontalCenter: parent.horizontalCenter
    }

        Item {
            id:searchButton        

            x: 409 //PR.const_PANDORA_ERROR_VIEW_OK_BUTTON_X_OFFSET
            y: PR.const_PANDORA_ERROR_VIEW_OK_BUTTON_Y_OFFSET//477
            width: 462
            height: 85

               Image {
                id: focusImg
                source: focusVisible ?  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED :
                    PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
                anchors.fill: searchButton
            }

            Text {
                id : searchText
                text:qsTranslate("main","STR_PANDORA_STATION_ENTRY_ERROR_VIEW_SEARCH");
                font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDB_32_FONT
                font.family: PR.const_PANDORA_FONT_FAMILY_HDB
                color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

            }

           MouseArea{
                anchors.fill: searchButton
                beepEnabled: false 
                onPressed: {
                    focusImg.source = PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_PRESSED
                }
                onClicked: {
                    UIListener.ManualBeep();                   
                    pandoraStationEntryErrorView.searchButtonClicked();
                }

                onReleased: {
                    if(focusVisible)
                       focusImg.source = PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED
                    else
                       focusImg.source = PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
                }
            }
        }
   // }


    // MODE AREA
    QmlModeAreaWidget
    {
        id: errorModeAreaWidget
        bAutoBeep: false
        modeAreaModel: errorModeAreaModel
        search_visible: false
        anchors.top: parent.top
        anchors.topMargin : 93
        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173

        onModeArea_BackBtn:
        {
            errorModeAreaWidget.hideFocus();
            pandoraStationEntryErrorView.focusVisible = false;
            pandoraStationEntryErrorView.handleBackRequest(isJogDial);
        }

        onLostFocus:
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_DOWN:
                {
                    __LOG ("QmlModeAreaWidget: onLostFocus " , LogSysID.LOW_LOG );
                    errorModeAreaWidget.hideFocus();
                    pandoraStationEntryErrorView.focusVisible = true;
                    break;
                }
            }
        }

        onModeArea_MenuBtn:
        {
            __LOG ("onModeArea_MenuBtn" , LogSysID.LOW_LOG );
            
            handleMenuKey();
        }

        ListModel
        {
            id: errorModeAreaModel
            property string text: QT_TR_NOOP("STR_PANDORA_STATIONLIST")

            property string mb_text: QT_TR_NOOP("STR_PANDORA_MENU");
            property bool mb_visible: true;
        }
    }

    OptionMenu{
        id: optMenu
        menumodel: pandoraMenus.optNoStationMenuModel
        z: 1000
        visible: false;
        autoHiding: true
        autoHideInterval: 10000
        anchors.top : parent.top
        anchors.topMargin:93

        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173

        onIsHidden:
        {
            optMenu.visible = false;
            errorModeAreaWidget.hideFocus();
            pandoraStationEntryErrorView.focusVisible = true;
        }

        onTextItemSelect:
        {
            optMenu.disableMenu();
            var hideMenu = true;
            switch(itemId)
            {
                case MenuItems.Search: // Search
                {
                    pandoraStationEntryErrorView.searchButtonClicked();
                    break;
                }
                case MenuItems.SoundSetting: // Sound Setting
                {
                    //hideMenu = false; //removed by jyjeon 2014.01.09 for ITS 218629
                    UIListener.LaunchSoundSetting();
                    break;
                }
                default:
                {
                    break;
                }
            }

            if(hideMenu === true){
//                optMenu.visible = false;
                optMenu.quickHide();
                errorModeAreaWidget.hideFocus();
            }
        }

        function showMenu()
        {
            optMenu.visible = true
            optMenu.show()
        } // added by Sergey 02.08.2103 for ITS#181512
    }

    onVisibleChanged:
    {
        if(EngineListener.isFrontLCD() && pandoraStationEntryErrorView.visible === false){
            hideOptionsMenu();
        }
	
        //{ add by cheolhwan 2013-12-17. ITS 215841.
        if(pandoraStationEntryErrorView.visible === true)
        {
            if(pandoraStationEntryErrorView.focusVisible === true)
            {
                focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED
            }
            else
            {
                focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
            }
        }
        //} add by cheolhwan 2013-12-17. ITS 215841.
    }
    onFocusVisibleChanged:
    {
        if(focusVisible === true)
        {
            focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED

        }
        else
        {
            focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
        }
    }


    Component.onCompleted: {
        activeView = pandoraStationEntryErrorView
        pandoraStationEntryErrorView.visible = visibleStatus;
    }

    function handleForegroundEvent()
    {
        //pandoraStationEntryErrorView.visible = visibleStatus; // Its duplicate not required
    }


    //=====================Functions and connections===========
    Connections
    {
        target: !popupVisible?UIListener:null
        onMenuKeyPressed:
        {
            handleMenuKey();
        }
    }


    //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
    function setInsufficient(isIns)
    {
        (isInsufficientEEV = isIns);
    }
    //} modified by yongkyun.lee 2014-03-11 


    function handleRetranslateUI(languageId)
    {
        LocTrigger.retrigger()
        errorModeAreaWidget.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
        firstLine.text = qsTranslate("main","STR_PANDORA_STATION_ENTRY_ERROR_VIEW_TEXT1");
        secondLine.text = qsTranslate("main","STR_PANDORA_STATION_ENTRY_ERROR_VIEW_TEXT2");
        searchText.text = qsTranslate("main","STR_PANDORA_STATION_ENTRY_ERROR_VIEW_SEARCH");
    }

    function hideOptionsMenu()
    {
        //{ Modified by cheolhwan 2014-02-13. ITS 223528.
        //optMenu.hideFocus();
        optMenu.hide();
        //} Modified by cheolhwan 2014-02-13. ITS 223528.
    }

    function handleMenuKey(/*isJogMenuKey*/)
    {
        if( pandoraStationEntryErrorView !== null && pandoraStationEntryErrorView.visible)
        {
                __LOG("Toggling the menu" , LogSysID.LOW_LOG );
                if(optMenu.visible) // from true to false
                {
                    optMenu.hide();
                    UIListener.SetOptionMenuVisibilty(false);
                }
                else // from false  to true
                {
//                    optMenu.visible = true;
                    optMenu.showMenu();
                    errorModeAreaWidget.hideFocus();
                    pandoraStationEntryErrorView.focusVisible = false;
                    optMenu.showFocus();
                    optMenu.setDefaultFocus(0);
                    UIListener.SetOptionMenuVisibilty(true)
                }
        }
    }


    function isJogListenState()
    {

        __LOG(" popupVisible : " + popupVisible +" optMenu.visible : " + optMenu.visible + " errorModeAreaWidget.focus_visible : " +
              errorModeAreaWidget.focus_visible , LogSysID.LOW_LOG );
        var ret = true;

        if(errorModeAreaWidget.focus_visible || optMenu.visible || popupVisible)
        {
            ret = false;
        }
        return ret;
    }

    function handleJogKey(arrow , status)
    {
        __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status , LogSysID.LOW_LOG );

        switch(arrow)
        {
            case UIListenerEnum.JOG_UP:
                if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    focusVisible = false;
                    errorModeAreaWidget.showFocus();
                    errorModeAreaWidget.setDefaultFocus(arrow);
                }
                break;
            case UIListenerEnum.JOG_CENTER:
                {
                    if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focusImg.source = PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_PRESSED
                    }
                    else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                    {
                        pandoraStationEntryErrorView.searchButtonClicked();
                    }
               }
                break;
        }
    }

    function manageFocusOnPopUp(status)
    {
        if(status)
        {            
            optMenu.hideFocus();
//            optMenu.visible = false;
            optMenu.quickHide();
            errorModeAreaWidget.hideFocus();
            pandoraStationEntryErrorView.focusVisible = false;
        }
        else
        {            
            pandoraStationEntryErrorView.focusVisible = true;
        }
    }

    //{ added by cheolhwan 2013.11.26 for ITS 210787.
    function getWaitIndicatorStatus()
    {
        return false; //waitIndicator.visible;
    }
    //} added by cheolhwan 2013.11.26 for ITS 210787.

    function __LOG( textLog , level)
    {
       logString = "StationEntryView.qml::" + textLog ;
       logUtil.log(logString , level);
    }

}
