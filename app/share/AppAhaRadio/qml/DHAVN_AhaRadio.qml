import Qt 4.7
import Qt.labs.gestures 2.0 //wsuk.kim 130815 IST_0182093 option menu does not receive the 1st tap event.
//import QmlStatusBarWidget 2.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import AppEngineQMLConstants 1.0
import QmlStatusBar 1.0 //hsryu_0508_QmlStatusBar
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

Rectangle {
    id: ahaController
    // TODO: Need to change the height and Y position
    // after integration  with Framework to show the status bar
    width: PR.const_AHA_ALL_SCREEN_WIDTH
    height: PR.const_AHA_MAIN_SCREEN_HEIGHT

    //QML Properties Declaration
    property variant activeView
    property bool isWaitEnabled: false
    property int currentDeviceIndex:-1
    property bool deviceInUse: false;
    property string initialStateofTrackView: "trackStatePaused"
    property alias popupVisible : popup.visible
    property alias toastPopupVisible : bufferingErrorPopup.visible  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
    //Tan, update from 62 to 71 based on pandora
    //property alias isMenuBtnVisible: statusBar.isMenuBtnVisible;
    property bool isMenuBtnVisible: false;
    property bool showTrackView: false;
    property string currentActiveStation;
    property int currentActiveStationToken : 0;
    property bool isDialUI : false;
    property bool listViewIsTopMost : false;
    //hsryu_0305_trackview_top
    property bool noActiveStation : false;
    //hsryu_0417_sound_setting
    property bool blaunchSoundSetting: false
    //hsryu_0423_block_play_btcall
    property bool isBtBlockPopCenterKey: false
    property alias popUpTextVisible: popUpText.visible  //wsuk.kim 131105 shift error popup move to AhaRadio.qml
//wsuk.kim 131105 shift error popup move to AhaRadio.qml    property alias btBlockPopupVisible: btBlockPopup.visible
    //hsryu_0502_jog_control
    property alias stationGuidePopupVisible : stationGuidePopup.visible
    property alias networkErrorPopupVisible : networkErrorPopup.visible //wsuk.kim no_network
    property alias isReceivingPopupVisible: receivingStationPopup.visible   //wsuk.kim 131105 receivingStation Popup.
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
    property alias isLoadingPopupVisible: popupLoading.visible
    property alias isLoadingFailPopupVisible: popupLoadingFail.visible
    property bool isStartListView: false    //wsuk.kim 130911 to return view(list or track) change after loading fail.
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
    property bool isSelectSameContent: false    //wsuk.kim 131217 ITS_215922 to remain previous play state when selected same content.

    property bool isShowSystemPopup: false  //youngsam.kwon 140205 ITS_0222236

    property int tuneIndex:0

    //hsryu_0329_system_popup
    signal handleCloseTrackPopup();
    signal handleCloseStationPopup();
    signal handleCloseContentsPopup();
    signal handleRestoreTrackPopup();
    signal handleRestoreStationPopup();
    signal handleRestoreContentsPopup();

    //ITS_0226333
    signal handleSelectionEvent();

    //ITS 228391
    signal handleFrontBackIndicatorRefresh();

    //NA - btn press reset
    signal background();

    signal handleShowDefaultDisplay();

    // TODO: Temp code, after integration with App Framework
    // need to remove below
    Image {
        //hsryu_0611_album_reflection
        source: PR_RES.const_APP_AHA_URL_IMG_GENERAL_BACKGROUND
        //fillMode: Image.Tile
        anchors.fill: parent
    }

    //hsryu_0508_QmlStatusBar
    QmlStatusBar {
        id: statusBar
        x: 0;
        y: 0;
        z: 1;   //wsuk.kim 131101 status bar dimming during to display popup.        z: 2;   //wsuk.kim 130815 IST_0182093 option menu does not receive the 1st tap event.
        width: 1280;
        height: 93;
        homeType: "button"
        middleEast: false
    }

//hsryu_0611_album_reflection
   Image
   {
       id: bg_bottom
       source: "/app/share/images/music/bg_basic_bottom.png"
       visible: true //(ahaController.state === "ahaTrackView")
       anchors.bottom: parent.bottom
   }
//hsryu_0611_album_reflection

//wsuk.kim 130815 IST_0182093 option menu does not receive the 1st tap event.
   GestureArea {
       id: gestureArea
       anchors.fill: parent
       Tap {
          onStarted: {
          }
       }
   }
//wsuk.kim 130815 IST_0182093 option menu does not receive the 1st tap event.

    // define various loader. Load only 1st screen
    Loader { id: ahaConnectingViewLoader;}
    Loader { id: ahaTrackViewLoader; }
    Loader { id: ahaStationListViewLoader; } //hsryu added
    Loader { id: ahaContentListViewLoader; }//wsuk.kim list_view
    Loader { id: ahaErrorViewLoader; }
    Loader { id: ahaStationEntryErrorViewLoader}

//hsryu_0607_inititialize_controller
    state: "ahaConnectingView"
    // define various states and its effect
    states: [
        State
        {
            name: "ahaConnectingView"
            PropertyChanges { target: ahaConnectingViewLoader;
                source: "DHAVN_AhaConnectingView.qml"; }
            PropertyChanges {target: ahaController; isMenuBtnVisible:false;}
            PropertyChanges {target: ahaController; showTrackView:true;}
        },

        State
        {
            name: "ahaTrackView"
            PropertyChanges { target: ahaTrackViewLoader;
                source: "DHAVN_AhaTrackView.qml";}
            PropertyChanges {target: ahaController; isMenuBtnVisible:true;}
            PropertyChanges {target: ahaController; showTrackView:true;}
        },

        //hsryu added
        State {
            name: "ahaStationListView"
            PropertyChanges { target: ahaStationListViewLoader;
                source: "DHAVN_AhaStationListView.qml";}
            PropertyChanges {target: ahaController; isMenuBtnVisible:true;}
            PropertyChanges {target: ahaController; showTrackView:false;}
        },

//wsuk.kim list_view
        State {
            name: "ahaContentListView"
            PropertyChanges { target: ahaContentListViewLoader;
                source: "DHAVN_AhaContentListView.qml";}
            PropertyChanges {target: ahaController; isMenuBtnVisible:true;}
            PropertyChanges {target: ahaController; showTrackView:false;}
        },
//wsuk.kim list_view

        State {
            name: "ahaErrorView"
            PropertyChanges { target: ahaErrorViewLoader;
                source: "DHAVN_AhaErrorView.qml"; }
            PropertyChanges {target: ahaController; isMenuBtnVisible:false;}
            PropertyChanges {target: ahaController; showTrackView:false;}
        }
    ]

    /***************************************************************************/
    /**************************** Aha QML connections START ****************/
    /***************************************************************************/

    //AhaStationListView Connections
    Connections
    {
        target: ahaStationListViewLoader.item //hsryu added
        onHandleSelectionEvent:
        {
            UIListener.printQMLDebugString("#####ahaStationListViewLoader onHandleSelectionEvent##### \n");
            UIListener.setSelectionEvent(true);
            UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
            listViewIsTopMost = false;
            ahaController.showTrackView = true;
            ahaTrack.ClearTrackInfo();
            ahaStationList.playStation();

            handleShowDefaultDisplay();
            //ITS_0226333
            handleSelectionEvent();
        }

        onHandleBackRequest:
        {
            UIListener.printQMLDebugString("#####ahaStationListViewLoader onHandleBackRequest##### \n");
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }
            if(isLoadingPopupVisible) return;   //wsuk.kim 131108 ITS_207360 popup unity, change to toast popup.

            if(listViewIsTopMost || noActiveStation)
            {
                sendAppToBackground();
            }
            else
            {
                //UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                noActiveStation = false;
                ahaController.state = "ahaTrackView";
                UIListener.printQMLDebugString("onHandleBackRequest  : move to ahaTrackView \n");
                UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view
                //hsryu_0326_like_dislike
                ahaTrack.DisplayCurrentLikeDislike();
            }
        }

        //hsryu_0524_select_same_content
        onHandlePlayStation:
        {
            handlePlayOnTrackView();
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
//            UIListener.handleNotifyAudioPath();
//            ahaTrack.Play();
//            ahaController.state = "ahaTrackView";
//            UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view
//            ahaTrack.DisplayCurrentLikeDislike();
        }
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//        //hsryu_0423_block_play_btcall
//        onShowBtBlockPopup:
//        {
//            //hsryu_0502_jog_control
//            //isBtBlockPopCenterKey = jogCenter;
//            btBlockPopup.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
//        }

        //hsryu_0613_fail_load_station
        onHandlShowFailLoadStationList:
        {
            UIListener.printQMLDebugString("#####ahaStationListViewLoader onHandlShowFailLoadStationList##### \n");
            ahaStationList.modelClear();
            UIListener.Disconnect();
            UIListener.UpdateAhaForDisconnect();
            qmlProperty.setErrorViewText("STR_AHA_NO_RESPONSE_LOAD_STATION_LIST");
            qmlProperty.setErrorViewText2Line(1);    //wsuk.kim 131223 2 line on Error view.
            ahaController.state = "ahaErrorView";
        }

        onHandleShowErrorPopup: //wsuk.kim 131105 shift error popup move to AhaRadio.qml
        {
            UIListener.printQMLDebugString("#####ahaStationListViewLoader onHandleShowErrorPopup##### \n");
            setShowErrorPopup(reason);
        }
    }

//wsuk.kim list_view
    //ahaContentListView Connections
    Connections
    {
        target:ahaContentListViewLoader.item
        onHandlecontentSelectionEvent:
        {
            UIListener.setSelectionEvent(true);
            ahaTrack.Play();   //wsuk.kim 130822 ITS_0182104 exception loading popup.
            UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
            listViewIsTopMost = false;
            ahaController.showTrackView = true;
            ahaTrack.ClearTrackInfo();
            ahaStationList.playContent();

            handleShowDefaultDisplay();
            //ITS_0226333
            handleSelectionEvent();
        }        
        onHandleBackRequest:
        {
            UIListener.printQMLDebugString("#####ahaContentListViewLoader onHandleBackRequest##### \n");
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }
//wsuk.kim 131108 ITS_207360 popup unity, change to toast popup.
            if(isLoadingPopupVisible) return;
            if(isLoadingFailPopupVisible) return;
//wsuk.kim 131108 ITS_207360 popup unity, change to toast popup.
            noActiveStation = false;
            ahaController.state = "ahaTrackView";
            UIListener.printQMLDebugString("onHandleBackRequest  : move to ahaTrackView \n");
            UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view
            //hsryu_0326_like_dislike
            ahaTrack.DisplayCurrentLikeDislike();
        }

        //hsryu_0524_select_same_content
        onHandlePlayContent:
        {
            UIListener.printQMLDebugString("#####ahaContentListViewLoader onHandlePlayContent##### \n");
            handlePlayOnTrackView();
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
//            UIListener.handleNotifyAudioPath();
//            ahaTrack.Play();
//            ahaController.state = "ahaTrackView";
//            UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view
//            ahaTrack.DisplayCurrentLikeDislike();
        }

//wsuk.kim TUNE
        onHandleSelectionEvent: //wsuk.kim 131104 displayed at OSD control by tune.
        {
            UIListener.printQMLDebugString("#####ahaContentListViewLoader onHandleSelectionEvent##### \n");
            UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
            listViewIsTopMost = false;
            ahaController.showTrackView = true;
            ahaTrack.ClearTrackInfo();
            ahaStationList.playStation();

            handleShowDefaultDisplay();
            //ITS_0226333
            handleSelectionEvent();
        }
//wsuk.kim TUNE

        onHandleShowErrorPopup: //wsuk.kim 131105 shift error popup move to AhaRadio.qml
        {
            setShowErrorPopup(reason);
        }

//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//        //hsryu_0423_block_play_btcall
//        onShowBtBlockPopup:
//        {
//            //hsryu_0502_jog_control
//            //isBtBlockPopCenterKey = jogCenter;
//            btBlockPopup.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
//        }
    }
//wsuk.kim list_view

    //ConnectingView.QML Connections
    Connections{
        target: ahaConnectingViewLoader.item
        onHandleBackRequest:
        {
            UIListener.printQMLDebugString("#####ahaConnectingViewLoader onHandleBackRequest##### \n");
            sendAppToBackground();
        }
//wsuk.kim no_network
        onHandleNoNetwork:
        {
            UIListener.printQMLDebugString("#####ahaConnectingViewLoader onHandleNoNetwork##### \n");
            setErrText(7/*E_NETWORK_FAILED*/);
            ahaController.state = "ahaErrorView"
        }
//wsuk.kim no_network
    }

    //TrackView Connections
    Connections{
        target: ahaTrackViewLoader.item
        onHandleBackRequest:
        {
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            sendAppToBackground();
        }

//wsuk.kim list_view
        onHandleContentListViewEvent:
        {
//            listViewIsTopMost = false;
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            ahaController.state = "ahaContentListView";
        }
//wsuk.kim list_view

        onHandleListViewEvent:{
            listViewIsTopMost = false;
            ahaController.state = "ahaStationListView";
        }

        onHandleRewindEvent:{
            popup.showPopup("Rewind not available\nin Aha",false);
        }

//wsuk.kim TUNE
        onHandleSelectionEvent:
        {
            UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
            listViewIsTopMost = false;
            ahaController.showTrackView = true;
            ahaTrack.ClearTrackInfo();
            ahaStationList.playStation();

            handleShowDefaultDisplay();
            //ITS_0226333
            handleSelectionEvent();
        }
//wsuk.kim TUNE

//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//        //hsryu_0423_block_play_btcall
//        onHandleShowTrackBtBlockPopup:
//        {
//            //hsryu_0502_jog_control
//            //isBtBlockPopCenterKey = jogCenter;
//            btBlockPopup.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
//        }

        //hsryu_0514_check_latitude_longitude_for_aha
        onHandleShowErrorPopup://wsuk.kim 131105 shift error popup move to AhaRadio.qml   onHandleShowNaviBlockPopup:
        {
//wsuk.kim 131105 shift error popup move to AhaRadio.qml
//            if(reason === 1)
//            {
//                popUpText.showPopup(qsTranslate("main", "STR_AHA_NAVI_SDCARD_ERROR"));
//            }
//            else if(reason === 2)
//            {
//                popUpText.showPopup(qsTranslate("main", "STR_AHA_UNABLE_LOCATE_ADDRESS"));
//            }
            setShowErrorPopup(reason);
        }

        onHandleHideErrorPopup: // Ryu 20140220
        {
            if(popUpText.visible === true)
            {
                popUpText.hidePopup();
            }
        }

        //hsryu_0613_fail_load_station
//wsuk.kim 131105 receivingStation Popup.
//        onHandlShowFailLoadStation:
//        {
//            ahaStationList.modelClear();
//            UIListener.Disconnect();
//            UIListener.UpdateAhaForDisconnect();
//            qmlProperty.setErrorViewText("STR_AHA_NO_RESPONSE_LOAD_STATION_LIST");
//            ahaController.state = "ahaErrorView";
//        }
    }

    //ErrorView.QML Connections
    Connections{
        target: ahaErrorViewLoader.item
        onHandleBackRequest:
        {
            UIListener.printQMLDebugString("#####ahaErrorViewLoader onHandleBackRequest##### \n");
//wsuk.kim no_network
            if(UIListener.getNetworkStatus() === 0/*AHA_NOTIFY_RESUME_NORMAL*/)
                exitApplication();
            else
                sendAppToBackground();
//wsuk.kim no_network       exitApplication();
        }
        onHandleConnectionRequest:
        {
            UIListener.printQMLDebugString("#####ahaErrorViewLoader onHandleConnectionRequest##### \n");
            UIListener.ConnectToTheOtherIpod(currentDeviceIndex);
            //ahaController.initializeAha();
        }
    }


    /***************************************************************************/
    /**************************** Aha QML connections END ****************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Aha Qt connections START ****************/
    /***************************************************************************/
    Connections
    {
        target:UIListener
        /* Adopted from Pandora change from 62 to 71
        onRetranslateUi:
        {
            activeView.handleRetranslateUI(languageId);
            statusBar.retranslateUi(languageId);
        }
        */

        onRetranslateUi:    //wsuk.kim 131111 was displaying in before language although language was set to change language.2
        {
            networkErrorModel.set(0,{msg: qsTranslate("main", "STR_AHA_UNABLE_TO_CONNECT_TO_AHA")}) //wsuk.kim 131218 ITS_212933 to change other language, display previous string on popup.
            receivingStationModel.set(0,{msg: qsTranslate("main", "STR_AHA_RECEIVING_STATIONS") + "\n" + qsTranslate("main", "STR_AHA_CONNECTING_VIEW_TEXT2")})   //wsuk.kim 131218 ITS_212933 to change other language, display previous string on popup.
            stationGuideModel.set(0,{msg: qsTranslate("main", "STR_AHA_UNABLE_PLAY_STATION") + "\n" + qsTranslate("main", "STR_AHA_GOING_TO_STATION_LIST")})    //wsuk.kim 131227 2 line on station guide popup.
            popupLoadingMsg.set(0,{msg: qsTranslate("main", "STR_AHA_LOADING")})
            popupLoadingFailMsg.set(0,{msg: qsTranslate("main", "STR_AHA_LOADING_FAIL")})
            btnmodel.set(0,{msg:qsTranslate("main","STR_AHA_ERROR_VIEW_OK")})   // ITS 227414
            handleFrontBackIndicatorRefresh(); //ITS 228391
        }

        onHandleHideErrorPopup: // Ryu 20140220
        {
            if(popUpText.visible === true)
            {
                popUpText.hidePopup();
            }
        }

        //hsryu_0329_system_popup
        onSignalShowSystemPopup:
        {
            UIListener.printQMLDebugString("onSignalShowSystemPopup popup close \n");
            if(stationGuidePopup.visible === true)
            {
                stationGuidePopup.hidePopup();
            }

            if(popup.visible === true)
            {
                popup.hidePopup();
            }

            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }
            //hsryu_0429_Block_popup
            if(popUpText.visible === true)
            {
                popUpText.hidePopup();
            }

            if(ahaController.state === "ahaTrackView")
            {
                handleCloseTrackPopup();
            }
            else if(ahaController.state === "ahaStationListView")
            {
                handleCloseStationPopup();
            }
            else if(ahaController.state === "ahaContentListView")
            {
                handleCloseContentsPopup();
            }
            //youngsam.kwon 140205 ITS_0222236
            isShowSystemPopup = true;
        }

        onSignalHideSystemPopup:
        {
            UIListener.printQMLDebugString("onSignalHideSystemPopup \n");
            if(noActiveStation && ahaController.state === "ahaTrackView")
            {
                stationGuidePopup.showPopup();
            }

            if(ahaController.state === "ahaTrackView")
            {
                handleRestoreTrackPopup();
            }
            else if(ahaController.state === "ahaStationListView")
            {
                handleRestoreStationPopup();
            }
            else if(ahaController.state === "ahaContentListView")
            {
                handleRestoreContentsPopup();
            }
            //youngsam.kwon 140205 ITS_0222236
            isShowSystemPopup = false;
        }
        //hsryu_0329_system_popup

        onConnectionStatusChanged:
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onConnectionStatusChanged##### isConnected:"+isConnected);
            if(1 === isConnected) // 1 means device is connected .
            {
                //NOTE: on connected, Trackupdated signal emits and called TrackView
                deviceInUse = true;
            }
            else
            {
                if(isConnected !== 2)//hsryu_0516_remove_device
                {
                    ahaController.state = "";
                }
                // TODO: Need to Display error Popup in place of Error View and that should be
                // Closed in 3 Sec or on Ok Clicked.
                // As per the specs on OK "the previous of a Aha radio playback mode will be returned"
                if(deviceInUse)
                {
                    // Pop up String : "Aha disconnected. Please check your mobile device"
                    //popup.showPopup("Aha disconnected.\nPlease check your mobile device",true);
                    UIListener.Disconnect();
                }
                else
                {
                    // Pop up String : "Connecting Aha Radio Failed"
                    //popup.showPopup("Connecting Aha Failed",true);
                    UIListener.Disconnect();
                }

                deviceInUse = false ;

//hsryu_0607_inititialize_controller
                if(isConnected === 0)
                {
                    noActiveStation = false;
                    stationGuidePopup.hidePopup();
                }
                else if(isConnected === 2)
                {
                    noActiveStation = false;
                }
            }
        }

        onConnectToIpod:
        {
            ahaController.state = "";
            UIListener.printQMLDebugString("onConnectToIpod\n");
            UIListener.printQMLDebugString("currentDeviceIndex: " + currentDeviceIndex+ "\n");
            UIListener.printQMLDebugString("selectedDevice: " + selectedDevice+ "\n");
//hsryu_0607_inititialize_controller
            popup.hidePopup();
            stationGuidePopup.hidePopup();
            //hsryu_0612_bt_call
            popUpText.hidePopup();
            networkErrorPopup.hidePopup();
            currentDeviceIndex = selectedDevice;
            initializeAha();
            blaunchSoundSetting = false; //hsryu_0417_sound_setting
        }

        onForeground:
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onForeground##### \n");
            UIListener.printQMLDebugString("currentDeviceIndex: " + currentDeviceIndex+ "\n");

            if(UIListener.getNetworkStatus() != 0) //  Network error
            {
                activeView.handleNetworkState(false);  //140103    false: no network      true: network OK
            }

            if(UIListener.IsCallingSameDevice() == true) //  now Calling
            {
                activeView.handleCallState(true);  //140122
            }

            if(activeView.visible !== true)
            {
                activeView.visible = true;
                if(UIListener.getNetworkStatus() === 0/*AHA_NOTIFY_RESUME_NORMAL*/ && ahaController.state === "ahaErrorView") //wsuk.kim no_network
                {
                    ahaTrack.Pause();
//wsuk.kim 131219 ITS_215989 Exception temporal mode, automatic reconnect on error view.
//                    ahaController.state = "ahaConnectingView";
//                    UIListener.setCurrentView(1);   // 0 : none   1: connecting view   2 : Track view
                }
                else
                {
                    if(UIListener.getContinueLastView() === false)
                    {
                        if(activeView.tuneSearching)    //wsuk.kim 131007 tune searching, BG->FG aha, remain cue BTN OK key.
                        {
                            activeView.tuneSearching = false;
                        }
                        activeView.handleRevertTrackInfoTune();     // add by Ryu 20130811
                    }
                }
            }
            //ITS_0223964
            activeView.handleRestoreShowFocus();
        }

        onBackground:
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onBackground##### \n");

            background();

            if(UIListener.getContinueLastView())   //wsuk.kim 131016 ITS_195123 Temporal Mode
            {
                if(ahaController.state === "ahaTrackView") //wsuk.kim 131121 ITS_210149 no BT paired, remain focus on modeArea after pressed call BTN.
                {
                    if(!UIListener.IsCallingSameDevice())
                    {
                        activeView.handleSeekTrackPressedFocus();

                        activeView.handleTuneRevert();  // ISV 98805
                    }
                    //ITS_0223964
                    activeView.handleTempHideFocus();
                }
                return;
            }
            //hsryu_0319_control_opt_sound_setting
            if(activeView === ahaStationListViewLoader.item ||
               activeView === ahaContentListViewLoader.item ||
               activeView === ahaTrackViewLoader.item)
            {
                if(activeView.isOptionsMenuVisible /*&& EngineListener.isFrontLCD()*/)  //wsuk.kim 130809 ITS_0183243 menu hide after launch sound setting
                {
                    UIListener.printQMLDebugString("AhaRadio onBackground : hideOptionsMenu \n");
                    activeView.hideOptionsMenu();
                }
                if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
                {
                    toastPopupVisible = false;
                }
//wsuk.kim 131002 ITS_191933 BG aha, close popup.
                if(popUpText.visible === true)
                {
                    popUpText.hidePopup();
                }

                if(ahaController.state === "ahaTrackView")
                {
                    handleCloseTrackPopup();
                    // ITS 0222226 focus reset
                    activeView.handleTempHideFocus();
                }
                else if(ahaController.state === "ahaStationListView")
                {
                    handleCloseStationPopup();
                }
                else if(ahaController.state === "ahaContentListView")
                {
                    handleCloseContentsPopup();
                }

//wsuk.kim 131002 ITS_191933 BG aha, close popup.

                blaunchSoundSetting = false; //hsryu_0417_sound_setting
            }

            //hsryu_0430_fix_trackview_top
            if(ahaController.state === "ahaStationListView" || ahaController.state === "ahaContentListView")
            {
                //wsuk.kim 131016 ITS_195123 Temporal Mode                if(UIListener.getContinueLastView() === false)      // ListView --> not Camera mode
                //noActiveStation = false;
                ahaController.state = "ahaTrackView";   //wsuk.kim be fixed on TrackView when BG
                UIListener.printQMLDebugString("onBackground  : move to ahaTrackView \n");
                UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view

                if(noActiveStation)
                {
                    //stationGuidePopup.visible = true;
                    stationGuidePopup.showPopup();
                    stationGuideModel.set(0,{msg: qsTranslate("main", "STR_AHA_UNABLE_PLAY_STATION") + "\n" + qsTranslate("main", "STR_AHA_GOING_TO_STATION_LIST")})    //wsuk.kim 131227 2 line on station guide popup.
//wsuk.kim 131107 was displaying in before language although language was set to change language.   stationGuidePopup.showPopup(qsTranslate("main", "STR_AHA_UNABLE_PLAY_MOVE_STATION_LIST"));
                }
            }
            else if(ahaController.state === "ahaTrackView") //wsuk.kim 130916 ITS_190541 TrackView BG, focus movement.
            {
                if(!UIListener.IsCallingSameDevice())    //wsuk.kim 131029 during BT call, focus move to title.
                {
                    activeView.handleSeekTrackPressedFocus();
                }
            }

            //hsryu_0607_inititialize_controller
            if(deviceInUse === false)
            {
                UIListener.printQMLDebugString("Initialize Controller \n");
                //ahaController.state = "";
                //noActiveStation = false;
                //stationGuidePopup.hidePopup();
            }
            //activeView.visible = false;           ITS0221058  black screen displayed
        }

        onActiveViewVisible:    //wsuk.kim 131016 ITS_195123 Temporal Mode
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onActiveViewVisible##### visible+"+isVisible);
            activeView.visible = isVisible;
        }

        onNetworkError:
        {
            UIListener.printQMLDebugString("DHAVN_AhaRadio.qml  onNetworkError \n");

            //wsuk.kim no_network            popup.showPopup("Network Error.",true);
            //wsuk.kim no_network            UIListener.Disconnect();

            // Processing during no network by Ryu
            // case 1. move to ErrorView
            // case 2. move to TrackVew
            // case 3. just processing in TrackView

            if(noActiveStation)
            {
                if(popupLoading.visible)
                    popupLoading.hidePopup();

                if(popupLoadingFail.visible)
                    popupLoadingFail.hidePopup();

                setErrText(7/*E_NETWORK_FAILED*/);
                ahaController.state = "ahaErrorView";
            }
            else if(activeView === ahaStationListViewLoader.item ||
               activeView === ahaContentListViewLoader.item)
            {
                noActiveStation = false;
                ahaController.state = "ahaTrackView";
                UIListener.printQMLDebugString("onNetworkError  : move to ahaTrackView \n");
                activeView.handleNetworkState(false);  //140103    false: no network      true: network OK
                UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view
            }
            else if(activeView === ahaTrackViewLoader.item)
            {
                activeView.handleNetworkState(false);  //140103    false: no network      true: network OK
            }
        }

        onNetworkErrorResume:
        {
            UIListener.printQMLDebugString("DHAVN_AhaRadio.qml onNetworkErrorResume \n");
        // networkErrorPopup.hidePopup();
            activeView.handleNetworkState(true);    //140103   false: no network      true: network OK
        }

        onBufferingError:   //wsuk.kim 130904 ITS_0182092 repeat buffering
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onBufferingError##### \n");
            bufferingErrorPopup.showPopup(qsTranslate("main", "STR_AHA_INVALID_NETWORK"));
        }

        //Tan: implementing non-active station
        onJumpToPresets:
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onJumpToPresets##### \n");
            //hsryu_0305_trackview_top
            noActiveStation = true;
            ahaController.state = "ahaTrackView";
            UIListener.printQMLDebugString("onJumpToPresets  : move to ahaTrackView \n");
            UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view

            //hsryu_0312_change_entry_text
            //stationGuidePopup.visible = true;
            stationGuidePopup.showPopup();
            stationGuideModel.set(0,{msg: qsTranslate("main", "STR_AHA_UNABLE_PLAY_STATION") + "\n" + qsTranslate("main", "STR_AHA_GOING_TO_STATION_LIST")})    //wsuk.kim 131227 2 line on station guide popup.
//wsuk.kim 131107 was displaying in before language although language was set to change language.   stationGuidePopup.showPopup(qsTranslate("main", "STR_AHA_UNABLE_PLAY_MOVE_STATION_LIST"));

            //listViewIsTopMost = true;

            //hsryu added
            //ahaController.state = "ahaStationListView";
        }

        onHandleError:
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onHandleError##### code:"+inAhaError+"\n");
             switch(inAhaError)
            {
                case 1:  //E_INVALID_STATE
                {
//                  0suk @@@@ E_NETWORK_FAILED   popup.showPopup("Unknown Error",true);
                    UIListener.Disconnect();
                    break;
                }

                case 2: //E_INIT_FAILED
                {
                    popup.showPopup("Initialization failed",true);
                    break;
                }
                case 3: //E_DEVICE_NOT_FOUND
                {
                    popup.showPopup("No Phone is Connected",true);
                    break;
                }
                case 4: //E_BT_CONNECTION_FAILED:
                case 5: //E_USB_CONNECTION_FAILED:
                {
                    popup.showPopup("Aha disconnected.\nPlease check your mobile device",true);
                    break;
                }
                case 6: //E_CHECK_AHA_APP_ON_DEVICE
                {
                    popup.showPopup("Please check Aha on your device",true);
                    break;
                }
                case 8: //E_INVALID_TOKEN
                {
                    popup.showPopup("Given token for station is not valid",false);
                    break;
                }
                case 9: //E_INVALID_STRING
                {
                    popup.showPopup("Empty OR doesn't follow the input criteria",false);
                    break;
                }
                case 10: //E_INVALID_STATION_REQ_RANGE
                {
                    popup.showPopup("Requested Station list range is not valid",false);
                    break;
                }
                case 11: //E_INVALID_VERSION
                {
                    popup.showPopup("The API VERSION is incompatible",true);
                    UIListener.Disconnect();
                    break;
                }
                case 12: //E_NO_STATIONS
                {
                    ahaController.state = "ahaStationEntryErrorView"
                    break;
                }
                case 13: //E_NO_ACTIVE_STATIONS
                {
                    popup.showPopup("No station is active",false);
                    ahaController.state = "ahaStationListView"; //hsryu
                    activeView.isFromErrorView = true;
                    break;
                }
                case 14: //E_SKIP_LIMIT_REACHED
                {
                    popup.showPopup("No skips remaining.\n You may skip 6 times per hour on each station.",false);
                    activeView.handleSkipFailedEvent();
                    break;
                }
                case 15: //E_STATION_LIMIT_REACHED
                {
                    popup.showPopup("The maximun station limit has been reached.",false);
                    break;
                }
                case 16: //E_TRACK_RATING_FAILED
                {
                    popup.showPopup("Track Rating has failed.",false);
                    break;
                }
                case 17: //E_STATION_DELETE_FAILED
                {
                    popup.showPopup("Deletion of the station has failed.",false);
                    break;
                }
                case 18: //E_SEARCH_EXTENDED_FAILED
                {
                    popup.showPopup("Extended search has failed.",false);
                    break;
                }
                case 19: //E_SEARCH_SELECT_FAILED
                {
                    popup.showPopup("Select from search result has failed.",false);
                    break;
                }
                case 20: //E_BOOKMARK_FAILED
                {
                    popup.showPopup("Bookmark has failed.",false);
                    break;
                }
                case 21: //E_TRACK_EXPLAIN_FAILED
                {
                    popup.showPopup("Track Explain Request has failed.",false);
                    break;
                }
                case 22: //E_MEMORY
                {
                    popup.showPopup("Required Memory not allocated.",true);
                    break;
                }
                case 23: //E_INVALID_ARGUMENT
                {
                    popup.showPopup("Argument Passed are invalid.",false);
                    break;
                }
                case 24: //E_REQUEST_TIMEOUT
                {
                    popup.showPopup("Timeout error.",true);
                    UIListener.Disconnect();
                    break;
                }
                case 25: //E_UNKNOWN_ERROR
                {
                    //popup.showPopup("Some unknown error occured.", true);
                    break;
                }
//wsuk.kim rm_pop
                case 7: //E_NETWORK_FAILED
                case 100://E_AHA_PLEASE_LOGIN
                case 101://E_AHA_PROT_NOT_SUPPORTED
                case 102://E_AHA_SESSION_REJECTED
                case 103://E_AHA_SESSION_CLOSED
                {
                    ahaStationList.modelClear(); //hsryu_0322_model_clear
                    //popup.visible = false;
                    popup.hidePopup();
                    popupLoading.hidePopup();   // ITS 254053
                    stationGuidePopup.hidePopup();
                    setErrText(inAhaError);
                    ahaController.state = "ahaErrorView"
                    break;
                }
//wsuk.kim rm_pop
                case 104://E_AHA_APP_NOT_OPENED
                {
                    ahaStationList.modelClear(); //hsryu_0322_model_clear
                    //popup.visible = false;
                    popup.hidePopup();
                    ahaController.state = "ahaErrorView"
                    break;
                }
                default:
                {
                   // popup.showPopup("Unknown error.",true);
                    break;
                }
            }
        }

        onHandlePlayPauseEvent:
        {
            activeView.handlePlayPauseEvent();
        }

        // Hard key used for skipping the channel
        onHandleSkipEvent:
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onHandleSkipEvent##### \n");

            if(UIListener.IsRunningInBG() === true)
            {
                if(UIListener.IsCallingSameDevice())
                {
                    UIListener.printQMLDebugString(" [onHandleSkipBackEvent] ..UIListener.OSDInfoCannotPlayBTCall");
                    UIListener.OSDInfoCannotPlayBTCall();
                    return;
                }
                else if(UIListener.getNetworkStatus() !== 0 && UIListener.getNetworkStatus() !== 3)
                {
                    UIListener.printQMLDebugString(" [onHandleSkipBackEvent] ..no network ");
                    UIListener.OSDInfoNoNetwork();
                    return;
                }
            }

            if(UIListener.getNetworkStatus() != 0) //  Network error
            {
                return;
            }

            //youngsam.kwon 140205 ITS_0222236
            if(isShowSystemPopup === true)
            {
                UIListener.printQMLDebugString("AhaRadio onHandleSkipEvent isShowSystemPopup true \n");
                return;
            }

            if(isJogKey === true)
            {
                isDialUI = true;
            }

            // if popup is visible for ex: no rewind available
            // popup will be closed and the skip operation will be executed
            // if for ex: no skips remaining popup
            // popup will be closed and the skip operation will be executed and again the
            // no skips remaining oppup displayed
            if(popupVisible)
            {
                popup.hidePopup();
            }

            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            //if(activeView.visible === false/*BG*/ && popUpTextVisible === true)    //wsuk.kim 131212 ITS_214661 background && shown popup, working for HK.
            //{
            //    popUpTextVisible = false;
            //}

            //active views wait indicator is false means no operation is
            //in progress in active view so we can go for skip operation
            //in any of the Track, List, search or explain view this operation is possible
            //not in error view, device selection view, connecting view,
            //startion entry error view
            if((ahaController.state === "ahaTrackView"
                || ahaController.state === "ahaContentListView"
                || ahaController.state === "ahaStationListView")
                && !stationGuidePopupVisible && !popUpTextVisible && !isReceivingPopupVisible &&
                    !isLoadingPopupVisible && !isLoadingFailPopupVisible && !networkErrorPopupVisible) //hsryu_0502_jog_control
            {
                if(activeView.isOptionsMenuVisible)  //wsuk.kim 130905 menu visible on, press HK SEEK/TRACK, to change menu hide. // moved ITS  229127,229135
                {
                    activeView.hideOptionsMenu();
                }

                //hsryu_0423_block_play_btcall
                if(UIListener.IsCallingSameDevice())
                {
                    UIListener.OSDInfoCannotPlayBTCall();
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.                    btBlockPopup.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
                    return;
                }

                activeView.handleSeekTrackPressedFocus();    //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
                //ITS_0226058
                if(ahaController.state === "ahaContentListView" && UIListener.IsRunningInBG() == false)
                {
                    if(InTrackInfo.allowSkipBack)
                    {
                        UIListener.handleNotifyAudioPath();
                        ahaTrack.SkipBack();
                    }
                    else
                    {
                        UIListener.OSDInfoCannotSkipBack();
                        //hsryu_0429_ITS_0163371
                        if(!UIListener.IsRunningInBG())
                        {
                            activeView.handlePopupNoSkipBack();
                        }
                    }
                }
                else
                {
                    if(InTrackInfo.allowSkip)
                    {
                        UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                        ahaTrack.Skip();
                    }
                    else
                    {
                        UIListener.OSDInfoCannotSkip();
                        //hsryu_0429_ITS_0163371
                        if(!UIListener.IsRunningInBG())
                        {
                            activeView.handlePopupNoSkip();
                        }
                    }
                }
            }
        }

        // Hard key used for skipping back to the previous track in the channel
        onHandleSkipBackEvent:
        {
            UIListener.printQMLDebugString("#####[ UIListener ] onHandleSkipBackEvent##### \n");

            if(UIListener.IsRunningInBG() === true)
            {
                if(UIListener.IsCallingSameDevice())
                {
                    UIListener.printQMLDebugString(" [onHandleSkipBackEvent] ..UIListener.OSDInfoCannotPlayBTCall");
                    UIListener.OSDInfoCannotPlayBTCall();
                    return;
                }
                else if(UIListener.getNetworkStatus() !== 0 && UIListener.getNetworkStatus() !== 3)
                {
                    UIListener.printQMLDebugString(" [onHandleSkipBackEvent] ..no network ");
                    UIListener.OSDInfoNoNetwork();
                    return;
                }
            }

            if(UIListener.getNetworkStatus() != 0) // Network error
            {
                return;
            }

            //youngsam.kwon 140205 ITS_0222236
            if(isShowSystemPopup === true)
            {
                UIListener.printQMLDebugString("AhaRadio onHandleSkipBackEvent isShowSystemPopup true \n");
                return;
            }

            if(isJogKey === true)
            {
                isDialUI = true;
            }

            // if popup is visible for ex: no rewind available
            // popup will be closed and the skip operation will be executed
            // if for ex: no skips remaining popup
            // popup will be closed and the skip operation will be executed and again the
            // no skips remaining oppup displayed
            if(popupVisible)
            {
                popup.hidePopup();
            }

            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            //if(activeView.visible === false/*BG*/ && popUpTextVisible === true)    //wsuk.kim 131212 ITS_214661 background && shown popup, working for HK.
            //{
            //    popUpTextVisible = false;
            //}

            //active views wait indicator is false means no operation is
            //in progress in active view so we can go for skip operation
            //in any of the Track, List, search or explain view this operation is possible
            //not in error view, device selection view, connecting view,
            //startion entry error view
            if((ahaController.state === "ahaTrackView"
                || ahaController.state === "ahaContentListView"
                || ahaController.state === "ahaStationListView")
                && !stationGuidePopupVisible && !popUpTextVisible && !isReceivingPopupVisible &&
                    !isLoadingPopupVisible && !isLoadingFailPopupVisible && !networkErrorPopupVisible) //hsryu_0502_jog_control
            {
                if(activeView.isOptionsMenuVisible)  //wsuk.kim 130905 menu visible on, press HK SEEK/TRACK, to change menu hide. // moved ITS  229127,229135
                {
                    activeView.hideOptionsMenu();
                }

                //hsryu_0423_block_play_btcall
                if(UIListener.IsCallingSameDevice())
                {
                    UIListener.OSDInfoCannotPlayBTCall();
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.                    btBlockPopup.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
                    return;
                }

                activeView.handleSeekTrackPressedFocus();    //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
                //ITS_0226058
                if(ahaController.state === "ahaContentListView" && UIListener.IsRunningInBG() == false)
                {
                    if(InTrackInfo.allowSkip)
                    {
                        UIListener.handleNotifyAudioPath();
                        ahaTrack.Skip();
                    }
                    else
                    {
                        UIListener.OSDInfoCannotSkip();
                        //hsryu_0429_ITS_0163371
                        if(!UIListener.IsRunningInBG())
                        {
                            activeView.handlePopupNoSkip();
                        }
                    }
                }
                else
                {
                    if(InTrackInfo.allowSkipBack)   //wsuk.kim SEEK_TRACK
                    {
                        UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE
                        ahaTrack.SkipBack();
                    }
                    else
                    {
                        UIListener.OSDInfoCannotSkipBack();
                        //hsryu_0429_ITS_0163371
                        if(!UIListener.IsRunningInBG())
                        {
                            activeView.handlePopupNoSkipBack();
                        }
                    }
                }
            }
        }

//wsuk.kim SEEK_TRACK
        onHandleSeekTrackReleased:
        {
            btnSTPressTimer.stop();
            if(ahaController.state === "ahaTrackView")
            {
                activeView.handleStopTimeshiftAnimation();
            }
        }
//wsuk.kim SEEK_TRACK

        // Hard key used for timeshift backward by 15
        onHandleRewind15Event:
        {
            UIListener.printQMLDebugString("AhaRadio onHandleRewind15Event  \n");
            if(UIListener.getNetworkStatus() != 0) //  Network error
            {
                return;
            }

            if(isJogKey === true)
            {
                isDialUI = true;
            }

            //youngsam.kwon 140205 ITS_0222236
            if(isShowSystemPopup === true)
            {
                UIListener.printQMLDebugString("AhaRadio onHandleRewind15Event isShowSystemPopup true \n");
                return;
            }
            // if popup is visible for ex: no rewind available
            // popup will be closed and the skip operation will be executed
            // if for ex: no skips remaining popup
            // popup will be closed and the skip operation will be executed and again the
            // no skips remaining oppup displayed
            if(popupVisible)
            {
                popup.hidePopup();
            }

            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            if(activeView.visible === false/*BG*/ && popUpTextVisible === true)    //wsuk.kim 131212 ITS_214661 background && shown popup, working for HK.
            {
                //ITS_0228601
                popUpText.hidePopup();
            }
            //active views wait indicator is false means no operation is
            //in progress in active view so we can go for skip operation
            //in any of the Track, List, search or explain view this operation is possible
            //not in error view, device selection view, connecting view,
            //startion entry error view
            if((ahaController.state === "ahaTrackView"
                || ahaController.state === "ahaContentListView" //wsuk.kim SEEK_TRACK
                || ahaController.state === "ahaStationListView")
                && !stationGuidePopupVisible && !popUpTextVisible && !isReceivingPopupVisible &&
                    !isLoadingPopupVisible && !isLoadingFailPopupVisible && !networkErrorPopupVisible) //hsryu_0502_jog_control
            {
                //hsryu_0423_block_play_btcall
                if(UIListener.IsCallingSameDevice())
                {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//					activeView.handleNoREWFW();
                    UIListener.OSDInfoCannotPlayBTCall();
//                  btBlockPopup.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
                    return;
                }

                if(activeView.isOptionsMenuVisible)  //wsuk.kim 130905 menu visible on, press HK SEEK/TRACK, to change menu hide.
                {
                    activeView.hideOptionsMenu();
                }

                activeView.handleSeekTrackPressedFocus();    //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
                if(InTrackInfo.allowTimeShift)
                {
                    UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE

                    if(ahaController.state === "ahaTrackView" && UIListener.IsRunningInBG() == false)
                    {
                        activeView.handleStartTimeshiftAnimation(PR.const_AHA_SEEK_OR_JOGLEFT_ALLOW_KEY);
                    }
                    else
                    {
                        //ITS_0226666
                        UIListener.OSDTrackTimeShift(PR.const_AHA_SEEK_OR_JOGLEFT_ALLOW_KEY);
                        btnSTPressTimer.lastPressed = PR.const_AHA_SEEK_OR_JOGLEFT_ALLOW_KEY;
                        btnSTPressTimer.start();
                    }
                }
                else
                {
                    UIListener.OSDInfoCannotREW15();
                    //hsryu_0429_ITS_0163371
                    if(!UIListener.IsRunningInBG())
                    {
                        activeView.handlePopupNoREW15();
                    }
                }
            }
        }

        onHandleForward30Event:
        {
            if(UIListener.getNetworkStatus() != 0) //  Network error
            {
                return;
            }

            if(isJogKey === true)
            {
                isDialUI = true;
            }

            //youngsam.kwon 140205 ITS_0222236
            if(isShowSystemPopup === true)
            {
                UIListener.printQMLDebugString("AhaRadio onHandleForward30Event isShowSystemPopup true \n");
                return;
            }
            // if popup is visible for ex: no rewind available
            // popup will be closed and the skip operation will be executed
            // if for ex: no skips remaining popup
            // popup will be closed and the skip operation will be executed and again the
            // no skips remaining oppup displayed
            if(popupVisible)
            {
                popup.hidePopup();
            }

            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            if(activeView.visible === false/*BG*/ && popUpTextVisible === true)    //wsuk.kim 131212 ITS_214661 background && shown popup, working for HK.
            {
            	//ITS_0228601
                popUpText.hidePopup();
            }
            //active views wait indicator is false means no operation is
            //in progress in active view so we can go for skip operation
            //in any of the Track, List, search or explain view this operation is possible
            //not in error view, device selection view, connecting view,
            //startion entry error view
            if((ahaController.state === "ahaTrackView"
                || ahaController.state === "ahaContentListView" //wsuk.kim SEEK_TRACK
                || ahaController.state === "ahaStationListView")
                && !stationGuidePopupVisible && !popUpTextVisible && !isReceivingPopupVisible &&
                    !isLoadingPopupVisible && !isLoadingFailPopupVisible && !networkErrorPopupVisible) //hsryu_0502_jog_control
            {
                //hsryu_0423_block_play_btcall
                if(UIListener.IsCallingSameDevice())
                {
//wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
//					activeView.handleNoREWFW();
					UIListener.OSDInfoCannotPlayBTCall();
//                  btBlockPopup.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
                    return;
                }

                if(activeView.isOptionsMenuVisible)  //wsuk.kim 130905 menu visible on, press HK SEEK/TRACK, to change menu hide.
                {
                    activeView.hideOptionsMenu();
                }
                activeView.handleSeekTrackPressedFocus();    //wsuk.kim 130905 current focus change when to press only SEEK/TRACK.
                if(InTrackInfo.allowTimeShift)
                {
                    UIListener.handleNotifyAudioPath();  //wsuk.kim UNMUTE

                    if(ahaController.state === "ahaTrackView" && UIListener.IsRunningInBG() == false)
                    {
                        activeView.handleStartTimeshiftAnimation(PR.const_AHA_TRACK_OR_JOGRIGHT_ALLOW_KEY);
                    }
                    else
                    {
                        //ITS_0226666
                        UIListener.OSDTrackTimeShift(PR.const_AHA_TRACK_OR_JOGRIGHT_ALLOW_KEY);
                        btnSTPressTimer.lastPressed = PR.const_AHA_TRACK_OR_JOGRIGHT_ALLOW_KEY;
                        btnSTPressTimer.start();
                    }
                }
                else
                {
                    UIListener.OSDInfoCannotFW30();
                    //hsryu_0429_ITS_0163371
                    if(!UIListener.IsRunningInBG())
                    {
                        activeView.handlePopupNoFW30();
                    }
                }
            }
        }

//wsuk.kim TUNE
        onHandleTuneUpEvent:
        {
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            if(activeView.visible === false/*BG*/ && popUpTextVisible === true)    //wsuk.kim 131212 ITS_214661 background && shown popup, working for HK.
            {
                //ITS_0228601
                popUpText.hidePopup();
            }

            //ITS_227494
            if(UIListener.IsRunningInBG() === true)
            {
                handleTuneUpDown(arrow);
                return;
            }

            if(UIListener.getNetworkStatus() != 0) //  Network error
            {
                return;
            }

            if((ahaController.state === "ahaTrackView"
                || ahaController.state === "ahaStationListView"
                || ahaController.state === "ahaContentListView")	// [ITS][0227330] - heemin.kang@lge.com
                && !popUpTextVisible)   //wsuk.kim 131105 shift error popup move to AhaRadio.qml
            {
                if(activeView.isOptionsMenuVisible)  //wsuk.kim 130927 menu visible on, tune knob searching, to change menu hide.
                {
                    activeView.hideOptionsMenu();
                    return;
                }
                activeView.handleFocusTuneUp(arrow);
            }
//wsuk.kim OSD_TUNE

            if(ahaController.state === "ahaTrackView")
            {
                UIListener.OSDStationNameTuneUpDown(ahaStationList.getTrackViewTuneIndex(), true);
            }
            else if(ahaController.state === "ahaStationListView")
            {
                UIListener.OSDStationNameTuneUpDown(ahaStationList.getStationListFocusIndex(), false);
            }
            else if(ahaController.state === "ahaContentListView" && !popUpTextVisible)
            {
                UIListener.OSDStationNameTuneUpDown(ahaStationList.getStationIdTuneUp(), true);	// [ITS][0227330] - heemin.kang@lge.com
            }
//wsuk.kim OSD_TUNE
        }

        onHandleTuneDownEvent:
        {
            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            if(activeView.visible === false/*BG*/ && popUpTextVisible === true)    //wsuk.kim 131212 ITS_214661 background && shown popup, working for HK.
            {
                //ITS_0228601
                popUpText.hidePopup();
            }

            //ITS_227494
            if(UIListener.IsRunningInBG() === true)
            {
                handleTuneUpDown(arrow);
                return;
            }

            if(UIListener.getNetworkStatus() != 0) //  Network error
            {
                return;
            }

            if((ahaController.state === "ahaTrackView"
                || ahaController.state === "ahaStationListView"
                || ahaController.state === "ahaContentListView")	// [ITS][0227330] - heemin.kang@lge.com
                && !popUpTextVisible)   //wsuk.kim 131105 shift error popup move to AhaRadio.qml
            {
                if(activeView.isOptionsMenuVisible)  //wsuk.kim 130927 menu visible on, tune knob searching, to change menu hide.
                {
                    activeView.hideOptionsMenu();
                    return;
                }
                //ahaStationList.getStationNameTune(nTuneIndex);
                activeView.handleFocusTuneDown(arrow);
            }
//wsuk.kim OSD_TUNE

            if(ahaController.state === "ahaTrackView")
            {
                UIListener.OSDStationNameTuneUpDown(ahaStationList.getTrackViewTuneIndex(), true);
            }
            else if(ahaController.state === "ahaStationListView")
            {
                UIListener.OSDStationNameTuneUpDown(ahaStationList.getStationListFocusIndex(), false);
            }
            else if(ahaController.state === "ahaContentListView" && !popUpTextVisible)
            {
                UIListener.OSDStationNameTuneUpDown(ahaStationList.getStationIdTuneDown(), true);	// [ITS][0227330] - heemin.kang@lge.com
            }
//wsuk.kim OSD_TUNE
        }

        onHandleTuneCenterEvent:
        {
            UIListener.printQMLDebugString("AhaRadio onHandleTuneCenterEvent in... \n");
            //youngsam.kwon 140205 ITS_0222236
            if(isShowSystemPopup === true)
            {
                UIListener.printQMLDebugString("AhaRadio onHandleTuneCenterEvent isShowSystemPopup true \n");
                return;
            }

            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
            }

            if(activeView.visible === false/*BG*/ && popUpTextVisible === true)    //wsuk.kim 131212 ITS_214661 background && shown popup, working for HK.
            {
            	//ITS_0228601
                popUpText.hidePopup();
            }

            //ITS_0227494
            if(UIListener.IsRunningInBG() === true)
            {
                UIListener.printQMLDebugString(" tune center on background..");

                if(UIListener.IsCallingSameDevice())
                {
                    UIListener.printQMLDebugString(" tune center on background..UIListener.OSDInfoCannotPlayBTCall");
                    UIListener.OSDInfoCannotPlayBTCall();
                    return;
                }
                else if(UIListener.getNetworkStatus() !== 0 && UIListener.getNetworkStatus() !== 3)
                {
                    UIListener.printQMLDebugString(" tune center on background..no network ");
                    UIListener.OSDInfoNoNetwork();
                    return;
                }

                //ITS_0227494_second add tune press when same station is selected.
                if(ahaStationList.getTrackViewTuneIndex() === -1)
                {
                    ahaStationList.setTrackViewTuneIndex(ahaStationList.getStationIndexUsedfromStationIdTune());
                    UIListener.OSDTrackInfo();
                }
                else if(ahaStationList.getStationIndexUsedfromStationIdTune() === ahaStationList.getTrackViewTuneIndex())   // by Ryu 20130817
                {
                    UIListener.OSDTrackInfo();
                }
                else
                {
                    // modified ITS 230430
                    if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
                    {
                        ahaStationList.selectPresetIndex(ahaStationList.getTrackViewTuneIndex());
                        ahaTrack.ClearCurrentLikeDislike();
                        ahaTrack.ClearTrackInfo();
                        ahaStationList.selectPresetID(0);
                    }
                    else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
                    {
                        ahaStationList.selectLBSIndex(ahaStationList.getTrackViewTuneIndex());
                        ahaTrack.ClearCurrentLikeDislike();
                        ahaTrack.ClearTrackInfo();
                        ahaStationList.selectLBSID(0);
                    }

                    UIListener.OSDStationNameTuneUpDown(ahaStationList.getTrackViewTuneIndex(), true); // ITS 229982
                    UIListener.setSelectionEvent(true);
                    UIListener.handleNotifyAudioPath();

                    listViewIsTopMost = false;
                    ahaController.showTrackView = true;

                    ahaStationList.playStation();

                    //ITS_0226333
                    handleSelectionEvent();
                }
                return;
            }

            if((ahaController.state === "ahaTrackView"
                || ahaController.state === "ahaStationListView")
                && !stationGuidePopupVisible && !popUpTextVisible)    //hsryu_0502_jog_control
            {
                activeView.handleFocusTuneCenter();
            }
            else if(ahaController.state === "ahaContentListView" && !popUpTextVisible)
            {
                if(!activeView.visible)
                {
                    activeView.handleStationTuneCenter();
                }
                else
                {
                    activeView.handleFocusTuneCenter();
                }
            }
        }

        onHandelTuneCenterPressedEvent: //wsuk.kim 130806 ITS_0182685 depress when pressed with CCP/Tune Knob
        {
            //youngsam.kwon 140205 ITS_0222236
            if(isShowSystemPopup === true)
            {
                UIListener.printQMLDebugString("AhaRadio onHandelTuneCenterPressedEvent isShowSystemPopup true \n");
                return;
            }

            if((ahaController.state === "ahaStationListView"
                || ahaController.state === "ahaContentListView")
                && !stationGuidePopupVisible && !popUpTextVisible)
            {
                activeView.handleTuneCenterPressed();
            }
        }

//wsuk.kim TUNE
        onHandleRewindEvent:
        {
            isDialUI = true;

            // if popup is visible for ex: no rewind available
            // popup will be closed and the skip operation will be executed
            // if for ex: no skips remaining popup
            // popup will be closed and the skip operation will be executed and again the
            // no skips remaining oppup displayed
            if(popupVisible)
            {
                popup.hidePopup();
            }

            //active views wait indicator is false means no operation is
            //in progress in active view so we can go for skip operation
            //in any of the Track, List, search or explain view this operation is possible
            //not in error view, device selection view, connecting view,
            //startion entry error view
            if(ahaController.state === "ahaTrackView"
                || ahaController.state === "ahaStationListView")
            {
                popup.showPopup("Rewind not available\nin Aha",false);
            }
        }

        onBackKeyPressed:
        {
            // It is CCP Back Key so the UI must Switch to DialUI.
            isDialUI = true;

            if(toastPopupVisible)  //wsuk.kim 130923 ITS_191005 toast popup close used by SK, HK.
            {
                toastPopupVisible = false;
                return;
            }
            if(popUpTextVisible)
            {
				//ITS_0228601
                popUpText.hidePopup();
                return;
            }

            //ITS_0228601
            if(stationGuidePopupVisible)
            {
                stationGuidePopup.hidePopup();
                move2StationList(); //ITS_0228601_second
                return;
            }
            // if popup is visible that should be hidden on back key. else the back key event
            // should be executed for activeScreen
            if(popupVisible)
            {
                popup.hidePopup();
            }
            else
            {
                if(/*activeView.*/isLoadingPopupVisible) return;
                if(networkErrorPopupVisible)    return;
                //if(stationGuidePopupVisible)    return;
                if(isReceivingPopupVisible)     return;
                if(isLoadingFailPopupVisible)   return;

                if(activeView === ahaStationListViewLoader.item ||
                   activeView === ahaContentListViewLoader.item || //wsuk.kim content_back
                   activeView === ahaTrackViewLoader.item)
                {
                    if(activeView.isOptionsMenuVisible /*&& EngineListener.isFrontLCD()*/)  //wsuk.kim 130809 ITS_0183243 menu hide after launch sound setting
                    {
                        UIListener.printQMLDebugString("AhaRadio onBackKeyPressed : hideOptionsMenu \n");
                        activeView.hideOptionsMenu();
                        return;
                    }
                }
                activeView.handleBackRequest();
            }
        }

        onJogsendKeyTovc:
        {
            __handleJogDialPressed (inJogKey);
        }

        onJogHardkeyPressed:
        {
            __handleJogDialReleased (inJogKey);
        }

        onHandleShowPopup: //modify by ys ITS-0221518
        {
            setShowErrorPopup(reason);
        }

        //ITS_0229027, 0229026
        onHandleCallStart:  //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.
        {
            if(activeView == ahaTrackViewLoader.item )
            {
                activeView.handleCallState(bCallingState);
            }
        }
    }

    Connections{
        target: ahaTrack
        onTrackUpdated:
        {
            UIListener.printQMLDebugString("[AhaRadio.qml] ahaTrack:onTrackUpdated..");
            //Means TrackUpdated Signal came as a respose of Connect request
            //Stop the timer and switch the view to TrackView
            if(ahaTrackViewLoader.item === null && showTrackView)
            {
                if(ahaController.state === "ahaConnectingView")
                {
                    //ahaTrack.Play();                               // by Ryu : play after Trackview is displayed
                    activeView.handleStopConnectEvent();    //wsuk.kim connecting view&timer close        activeView.visible = false;
                }

                UIListener.setSelectionEvent(true);
                UIListener.stopTimers();     // added by Ryu : stop timers at Trackview : ITS0224000
                noActiveStation = false;
                ahaController.state = "ahaTrackView";
                UIListener.printQMLDebugString("onTrackUpdated  : move to ahaTrackView \n");
                UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view
                //hsryu_0314_default_albumart
                albumArtWaitIndicator.visible = true;
            }

            //ITS_227494
            ahaStationList.setTrackViewTuneIndex(ahaStationList.getStationIndexUsedfromStationIdTune());
        }
//hsryu_0612_initialize_flag_status_bt_call
        onPlayStarted:
        {
            UIListener.printQMLDebugString("[AhaRadio.qml] ahaTrack:onPlayStarted..net:"+ UIListener.getNetworkStatus() );
            //ITS_0230787
            if(UIListener.IsCallingSameDevice() || (UIListener.getNetworkStatus() != 0 && UIListener.getNetworkStatus() != 3))    //wsuk.kim 130820 launch aha connect USB cable during BT calling.
                initialStateofTrackView = "trackStateBtnDisable";    //wsuk.kim 130827 ITS_0183823 dimming cue BTN & display OSD instead of inform popup during BT calling.    "trackStatePaused";
            else
                initialStateofTrackView = "trackStatePlaying";
        }

        onPauseDone:
        {
            initialStateofTrackView = "trackStatePaused";
        }

        onReceivingStationShowPopup:    //wsuk.kim 131105 receivingStation Popup.
        {
            receivingStationPopup.visible = true;
            receivingStationModel.set(0,{msg: qsTranslate("main", "STR_AHA_RECEIVING_STATIONS") + "\n" + qsTranslate("main", "STR_AHA_CONNECTING_VIEW_TEXT2")}) //wsuk.kim 131227 ITS_217408 2 line on updating station popup.
        }


    }

    Connections{
        target: ahaStationList

        onReceivingStationHidePopup:    //wsuk.kim 131105 receivingStation Popup.
        {
            receivingStationPopup.visible = false;
        }
    }
//hsryu_0612_initialize_flag_status_bt_call
    /***************************************************************************/
    /**************************** Aha Qt connections END ****************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/

    //ITS_227494
    function handleTuneUpDown(arrow)
    {
        UIListener.printQMLDebugString(" [handleTuneUpDown] arrow:"+arrow);
        if(UIListener.IsCallingSameDevice())
        {
            UIListener.printQMLDebugString(" [handleTuneUpDown] ..UIListener.OSDInfoCannotPlayBTCall");
            UIListener.OSDInfoCannotPlayBTCall();
            return;
        }
        else if(UIListener.getNetworkStatus() !== 0 && UIListener.getNetworkStatus() !== 3)
        {
            UIListener.printQMLDebugString(" [handleTuneUpDown] ..no network ");
            UIListener.OSDInfoNoNetwork();
            return;
        }

        if(!isReceivingPopupVisible && !networkErrorPopupVisible && !stationGuidePopupVisible)
        {
            tuneIndex = ahaStationList.getTrackViewTuneIndex();

            if(arrow === PR.const_AHA_JOG_EVENT_WHEEL_RIGHT)
            {
                if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
                {
                    if(tuneIndex == ahaStationList.getPresetCount() - 1)
                        tuneIndex = 0;
                    else
                        tuneIndex += 1;
                }
                else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
                {
                    if(tuneIndex == ahaStationList.getLBSCount() - 1)
                        tuneIndex = 0;
                    else
                        tuneIndex += 1;
                }
            }
            else if(arrow === PR.const_AHA_JOG_EVENT_WHEEL_LEFT)
            {
                if(tuneIndex > 0)
                    tuneIndex -= 1;
                else
                {
                    if(ahaStationList.getStationIdTune() === 1 /*STATION_PRESET*/)
                        tuneIndex = ahaStationList.getPresetCount() - 1;
                    else if(ahaStationList.getStationIdTune() === 2 /*STATION_LBS*/)
                        tuneIndex = ahaStationList.getLBSCount() - 1;
                }
            }

            tuneResetTimer.restart();
            ahaStationList.setTrackViewTuneIndex(tuneIndex);
        }
        UIListener.OSDStationNameTuneUpDown(ahaStationList.getTrackViewTuneIndex(), true);
    }

    function __LOG( textLog )
    {
       //console.log( " DHAVN_AhaRadio.qml: " + textLog );
        UIListener.printQMLDebugString(textLog);
    }

    function initializeAha()
    {
        UIListener.printQMLDebugString("initializeAha()\n");
        ahaController.state = "ahaConnectingView"
        UIListener.setCurrentView(1);   // 0 : none   1: connecting view   2 : Track view
    }

    function exitApplication()
    {
        UIListener.printQMLDebugString("#####[ ahaController ] exitApplication##### \n");
        //hsryu_0502_jog_control
        //ahaController.state = "";
        UIListener.ExitApplication();
    }

    function sendAppToBackground()
    {
        UIListener.printQMLDebugString("#####[ ahaController ] sendAppToBackground##### \n");
        UIListener.HandleBackKey();
    }


    function __handleJogDialPressed (jogDialEvent)
    {
        if (jogDialEvent > -1)
        {
            // TODO: Hide the bottom tool bar
            activeView.setHighlightedItem(jogDialEvent);
        }
    }

    function __handleJogDialReleased (jogDialEvent)
    {

    }

    function setErrText(inAhaErr)
    {
        switch(inAhaErr)
        {
        case 7:
            qmlProperty.setErrorViewText("STR_AHA_PLEASE_CHECK_YOUR_NETWORK_CONNECTION");
            break;
        case 100:
            qmlProperty.setErrorViewText("STR_AHA_PLEASE_LOGIN_TEXT");
            break;
        case 101:
            qmlProperty.setErrorViewText("STR_AHA_PROT_NOT_SUPPORTED_TEXT");
            break;
        case 102:
            qmlProperty.setErrorViewText("STR_AHA_SESSION_REJECTED_TEXT");
            break;
        case 103:
            qmlProperty.setErrorViewText("STR_AHA_SESSION_CLOSED_TEXT");
            break;
        }
    }

    function setShowErrorPopup(reason)  //wsuk.kim 131105 shift error popup move to AhaRadio.qml
    {
        switch(reason)
        {
        case 1:
            popUpText.showPopup(qsTranslate("main", "STR_AHA_NAVI_SDCARD_ERROR"));
            break;
        case 2:
            popUpText.showPopup(qsTranslate("main", "STR_AHA_UNABLE_LOCATE_ADDRESS"));
            break;
        case PR.const_AHA_NO_SUPPORT_SKIP_BACK :
            popUpText.showPopup(qsTranslate("main", "STR_NO_SUPPORT_SKIP_BACK"));
            break;
        case PR.const_AHA_NO_SUPPORT_SKIP :
            popUpText.showPopup(qsTranslate("main", "STR_NO_SUPPORT_SKIP"));
            break;
        case PR.const_AHA_NO_SUPPORT_REW15:
            popUpText.showPopup(qsTranslate("main", "STR_AHA_NO_SUPPORT_REW15"));
            break;
        case PR.const_AHA_NO_SUPPORT_FW30:
            popUpText.showPopup(qsTranslate("main", "STR_AHA_NO_SUPPORT_FW30"));
            break;
        case PR.const_AHA_SKIP_NOT_AVAILABLE:
            popUpText.showPopup(qsTranslate("main", "STR_AHA_SKIP_NOT_AVAILABLE"));
            break;
        case PR.const_AHA_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL: //modify by ys ITS-0221518
            popUpText.showPopup(qsTranslate("main", "STR_AHA_FEATURE_NOT_AVAILABLE_DURING_CALL"));
            break;
        default:
            break;
        }
    }

    function handlShowFailLoadStation() //wsuk.kim 131105 receivingStation Popup.
    {
        ahaStationList.modelClear();
        UIListener.Disconnect();
        UIListener.UpdateAhaForDisconnect();
        qmlProperty.setErrorViewText("STR_AHA_NO_RESPONSE_LOAD_STATION_LIST");
        qmlProperty.setErrorViewText2Line(1);    //wsuk.kim 131223 2 line on Error view.
        ahaController.state = "ahaErrorView";
    }

    function handlePlayOnTrackView()    //wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
    {
//wsuk.kim 131212 ITS_215027 selected same contents, keep mute icon.         UIListener.handleNotifyAudioPath();
        isSelectSameContent = true; //wsuk.kim 131217 ITS_215922 to remain previous play state when selected same content.        ahaTrack.Play();
        noActiveStation = false;
        ahaController.state = "ahaTrackView";
        UIListener.printQMLDebugString("function handlePlayOnTrackView()  : move to ahaTrackView \n");
        UIListener.setCurrentView(2);   // 0 : none   1: connecting view   2 : Track view
        ahaTrack.DisplayCurrentLikeDislike();
    }

    //ITS_0228601_second
    function move2StationList()
    {
        //ITS_0228601
        if(noActiveStation)
        {
            ahaController.state = "ahaStationListView";
        }
    }
    /***************************************************************************/
    /**************************** Private functions END **********************/
    /***************************************************************************/

    POPUPWIDGET.PopUpText
    {
        id:popup
        z: 1
        y: 0
        icon_title: EPopUp.WARNING_ICON
        visible: false
        message: errorModel
        buttons: btnmodel
        focus_visible: isDialUI && popup.visible
        property bool showErrorView;

        function showPopup(text, errorView)
        {
            popup.showErrorView = errorView;
            if(!visible)
            {
                if(activeView == ahaTrackViewLoader.item ||
                   activeView == ahaStationListViewLoader.item ||
                   activeView == ahaContentListViewLoader.item   )
                {
                    activeView.handleTempHideFocus();
                }

                errorModel.set(0,{msg:text})
                btnmodel.set(0,{msg:qsTranslate("main","STR_AHA_ERROR_VIEW_OK")}) // added by Ryu 20140208. ITS 222286.
                visible = true;
                functionalTimer.start();
                popup.setDefaultFocus(0);
            }
        }

        function hidePopup()
        {
        	//ITS_0228601
            if(visible == true)
            {
                if(activeView == ahaTrackViewLoader.item ||
                   activeView == ahaStationListViewLoader.item ||
                   activeView == ahaContentListViewLoader.item   )
                {
                    activeView.handleRestoreShowFocus();
                }

                visible = false;
                functionalTimer.stop();
            }
        }

        onBtnClicked:
        {
            switch ( btnId )
            {
                case "OK":
                {
                    functionalTimer.stop();
                    if(popup.showErrorView && popup.visible)//130205 wsuk.kim err_pop
                    {
                        ahaController.state = "ahaErrorView"
                    }
                    //ITS_0228601
                    popup.hidePopup();
                }
                break;
            }
        }
    }

    ListModel
    {
        id: btnmodel
        ListElement
        {
            btn_id: "OK"
            msg: "OK"
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

     Timer{
         id: functionalTimer
         running: false
         repeat: false
         interval: 3000
         onTriggered:{
             //popup.visible = false;
             popup.hidePopup();
             if(popup.showErrorView && ahaController.state !== "ahaErrorView")
             {
                 ahaController.state = "ahaErrorView"
             }
         }
     }

//wsuk.kim SEEK_TRACK
     Item
     {
         Timer
         {
            id: btnSTPressTimer
            interval: 900
            repeat: true
            running: false
            property int lastPressed: -1

            onTriggered:
            {
                if(btnSTPressTimer.lastPressed == PR.const_AHA_SEEK_OR_JOGLEFT_ALLOW_KEY)
                {
                    ahaTrack.Rewind15();
                }
                else if(btnSTPressTimer.lastPressed == PR.const_AHA_TRACK_OR_JOGRIGHT_ALLOW_KEY)
                {
                    ahaTrack.Forward30();
                }
            }
         }
     }
//wsuk.kim SEEK_TRACK

//wsuk.kim no_network
    ListModel
    {
        id: networkErrorModel
        ListElement{
            msg: QT_TR_NOOP("STR_AHA_UNABLE_TO_CONNECT_TO_AHA")
        }
    }

    POPUPWIDGET.PopUpText/*PopUpToast*/
    {   
        id: networkErrorPopup
        y: 0    //wsuk.kim 131101 status bar dimming during to display popup.   y: PR.const_AHA_ALL_SCREENS_TOP_OFFSET
        z: 1
        visible: false
//wsuk.kim 130719 popup type change from toast to text
        icon_title: EPopUp.LOADING_ICON
        message: networkErrorModel
        focus_id: 0
//wsuk.kim 130719 popup type change from toast to text
//        height: 800     //TEMP
//        opacity: 0.9
//        bHideByTimer: true
//        listmodel: networkErrorModel

        function showPopup()
        {
            if(!visible)
            {
                if(activeView == ahaTrackViewLoader.item ||
                   activeView == ahaStationListViewLoader.item ||
                   activeView == ahaContentListViewLoader.item   )
                {
                    activeView.handleTempHideFocus();
                }

                visible = true;
                UIListener.NoNetworkPopupState(true);   //wsuk.kim 131204 ITS_212572 state network error, display error info on OSD.
                noNetworkTimer.start();
            }
        }        

        function hidePopup()
        {
        	//ITS_0228601
            if(visible == true)
            {
                if(activeView == ahaTrackViewLoader.item ||
                   activeView == ahaStationListViewLoader.item ||
                   activeView == ahaContentListViewLoader.item   )
                {
                    activeView.handleRestoreShowFocus();
                }

                visible = false;
                UIListener.NoNetworkPopupState(false);   //wsuk.kim 131204 ITS_212572 state network error, display error info on OSD.
                noNetworkTimer.stop();
            }
        }
    }

    Timer{
        id: noNetworkTimer
        running: false
        repeat: false
        interval: 30000
        onTriggered:{
            networkErrorPopup.hidePopup();
            ahaTrack.Pause();
            stationGuidePopup.hidePopup();
            setErrText(7/*E_NETWORK_FAILED*/);
            ahaController.state = "ahaErrorView"
        }
    }
 //wsuk.kim no_network

//wsuk.kim 130904 ITS_0182092 repeat buffering
    POPUPWIDGET.PopUpToast
    {
        id: bufferingErrorPopup
        z: 1000
        visible: false
        bHideByTimer: false
        listmodel: errorModel

        function showPopup(text)
        {
            if(/*activeView.isShiftPopupVisible || activeView.isShiftErrVisible || activeView.isShiftErrPopupVisible ||*/   //wsuk.kim 131105 shift error popup move to AhaRadio.qml
                /*activeView.*/isLoadingPopupVisible || activeView.isOptionsMenuVisible || /*activeView.isReceivingPopupVisible*/isReceivingPopupVisible ||
                  /*btBlockPopupVisible*/popUpTextVisible || isLoadingFailPopupVisible)  //wsuk.kim 131002 ITS_192102 overlap repeat buffering popup and other popup.
            {
                return;
            }

            if(!visible)
            {
                errorModel.set(0,{msg:text})
                visible = true;
                bufferingErrorPopupTimer.start();
            }
        }

        function hidePopup()
        {
            visible = false;
            bufferingErrorPopupTimer.stop();
        }
    }

    Timer{
        id: bufferingErrorPopupTimer
        running: false
        repeat: false
        interval: 3000
        onTriggered:{
            bufferingErrorPopup.hidePopup();
        }
    }
//wsuk.kim 130904 ITS_0182092 repeat buffering

	//ITS_227494
    Timer{
        id: tuneResetTimer
        running: false
        repeat: false
        interval: 5000

        onTriggered:{
            ahaStationList.setTrackViewTuneIndex(ahaStationList.getStationIndexUsedfromStationIdTune());
        }
    }

     //hsryu_0305_trackview_top
    ListModel   //wsuk.kim 131107 was displaying in before language although language was set to change language.
    {
        id: stationGuideModel
        ListElement
        {
            msg: "" //wsuk.kim 131227 2 line on station guide popup.  QT_TR_NOOP("STR_AHA_UNABLE_PLAY_MOVE_STATION_LIST")
        }
    }

     POPUPWIDGET.PopUpText
     {
         id: stationGuidePopup
         z: 1
         y: 0
         icon_title: EPopUp.WARNING_ICON
         visible: false
         message: stationGuideModel //wsuk.kim 131107 was displaying in before language although language was set to change language.    errorModel
         buttons: btnmodel
         focus_visible: isDialUI && stationGuidePopup.visible

         function showPopup(text)
         {
             if(!visible)
             {
                 if(activeView == ahaTrackViewLoader.item ||
                    activeView == ahaStationListViewLoader.item ||
                    activeView == ahaContentListViewLoader.item   )
                 {
                     activeView.handleTempHideFocus();
                 }

                 errorModel.set(0,{msg:text})
                 visible = true;
                 stationGuidePopup.setDefaultFocus(0);
             }
         }

         function hidePopup()
         {
         	//ITS_0228601
             if(visible == true)
             {
                 if(activeView == ahaTrackViewLoader.item ||
                    activeView == ahaStationListViewLoader.item ||
                    activeView == ahaContentListViewLoader.item   )
                 {
                     activeView.handleRestoreShowFocus();
                 }

                 visible = false;
             }
         }

         onBtnClicked:
         {
             switch ( btnId )
             {
                 case "OK":
                 {
                     //hsryu_0613_fail_load_station
                     if(ahaController.state === "ahaErrorView")
                         return;
//                     if(noActiveStation)
//                     {
//                         //hsryu_0430_fix_trackview_top
//                         //stationGuideTimer.stop();
//                         ahaController.state = "ahaStationListView";
//                     }
                     //ITS_0228601
                     stationGuidePopup.hidePopup();
                     move2StationList();
                 }
                 break;
             }
         }
     }

     Timer{
         id: stationGuideTimer
         running: false
         repeat: false
         interval: 5000
         onTriggered:{
         	//ITS_0228601
             stationGuidePopup.hidePopup();
             if(noActiveStation)
             {
                 ahaController.state = "ahaStationListView";
             }
         }
     }
     //hsryu_0305_trackview_top
     //hsryu_0423_block_play_btcall
     ListModel
     {
         id: trmsgModel
         ListElement
         {
             msg: ""
         }
     }

     POPUPWIDGET.PopUpText
     {
         id: popUpText/*btBlockPopup*/
         z: 1
         y: 0//90 //hsryu_0429_Block_popup
         icon_title: EPopUp.WARNING_ICON
         visible: false
         message: trmsgModel
         buttons: btnmodel
         focus_visible: isDialUI && popUpText.visible

         function showPopup(text)
         {
             if(!visible)
             {
                 if(activeView == ahaTrackViewLoader.item ||
                    activeView == ahaStationListViewLoader.item ||
                    activeView == ahaContentListViewLoader.item   )
                 {
                     activeView.handleTempHideFocus();
                 }

                 trmsgModel.set(0,{msg:text})
                 visible = true;
//wsuk.kim 130909 remove btBlockpopup 5sec hide timer.                 btBlockTimer.start();
                 popUpText.setDefaultFocus(0);
             }
         }

         function hidePopup()
         {
             if(visible == true)
             {
                 if(activeView == ahaTrackViewLoader.item ||
                    activeView == ahaStationListViewLoader.item ||
                    activeView == ahaContentListViewLoader.item   )
                 {
                     activeView.handleRestoreShowFocus();
                 }

                 visible = false;
             }
//wsuk.kim 130909 remove btBlockpopup 5sec hide timer.             btBlockTimer.stop();
         }

         onBtnClicked:
         {
             //UIListener.printQMLDebugString("++++hsryu btBlockPopup onBtnClicked ++++ "+ btnId +" \n");
             switch ( btnId )
             {
                 case "OK":
                 {
                     if(popUpText.visible == true)
                     {
                         if( activeView == ahaTrackViewLoader.item )
                         {
                             if(UIListener.IsCallingSameDevice() == false) //  now Calling
                             {
                                 activeView.handleCallState(false);  //140122
                                 break;
                             }
                         }
                         popUpText.hidePopup();
                     }
                 }
                 break;
             }
         }
     }

    ListModel
    {
        id: receivingStationModel
        ListElement{
//wsuk.kim 131227 ITS_217408 2 line on updating station popup.   msg: QT_TR_NOOP("STR_AHA_RECEIVING_STATIONS")
            msg: ""
        }
    }

    POPUPWIDGET.PopUpText
    {
        id: receivingStationPopup
        y: 0
        z: 1
        visible: false
        icon_title: EPopUp.LOADING_ICON
        message: receivingStationModel
        focus_id: 0

        //hsryu_0613_fail_load_station
        Timer{
            id: receivingStationTimer
            running: receivingStationPopup.visible
            repeat: false
            interval: 30000
            onTriggered:{
                if(receivingStationPopup.visible === true)
                {
                    receivingStationPopup.visible = false;
                    handlShowFailLoadStation();
                }
            }
        }
    }
//wsuk.kim 131105 receivingStation Popup.

//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
    ListModel
    {
        id: popupLoadingMsg
        ListElement{
            msg: QT_TR_NOOP("STR_AHA_LOADING")
        }
    }

    POPUPWIDGET.PopUpText  //wsuk.kim 131211 ITS_214638 change from toast to text popup.
    {
        id: popupLoading
        z: 1
        visible: false
        icon_title: EPopUp.LOADING_ICON
        message: popupLoadingMsg

        Timer{
            id: popupLoadingTimer
            running: popupLoading.visible
            repeat: false
            interval: 15000
            onTriggered:{
                popupLoading.visible = false;
                popupLoadingFail.visible = true;
            }
        }

        function showPopup(text)
        {
            if(!visible)
            {
                if(activeView == ahaTrackViewLoader.item ||
                   activeView == ahaStationListViewLoader.item ||
                   activeView == ahaContentListViewLoader.item   )
                {
                    activeView.handleTempHideFocus();
                }

                errorModel.set(0,{msg:text})
                visible = true;
                popupLoading.setDefaultFocus(0);
            }
        }

        function hidePopup()
        {
               //ITS_0254053
            if(visible == true)
            {
                if(activeView == ahaTrackViewLoader.item ||
                   activeView == ahaStationListViewLoader.item ||
                   activeView == ahaContentListViewLoader.item   )
                {
                    activeView.handleRestoreShowFocus();
                }

                visible = false;
            }
        }
    }

    ListModel
    {
        id: popupLoadingFailMsg
        ListElement{
            msg: QT_TR_NOOP("STR_AHA_LOADING_FAIL")
        }
    }

    POPUPWIDGET.PopUpText  //wsuk.kim 131211 ITS_214638 change from toast to text popup.
    {
       id: popupLoadingFail
       z: 1
       visible: false;
       icon_title: EPopUp.LOADING_ICON
       message: popupLoadingFailMsg

       Timer{
           id: popupLoadingFailTimer
           running: popupLoadingFail.visible
           repeat: false
           interval: 3000
           onTriggered:{
               popupLoadingFail.visible = false;
               //if(isStartListView === true) //wsuk.kim 130911 to return view(list or track) change after loading fail. // removed for ITS 227477
               //{
               isStartListView = false;
               handlePlayOnTrackView();
               //}
           }
       }
    }
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml
}
