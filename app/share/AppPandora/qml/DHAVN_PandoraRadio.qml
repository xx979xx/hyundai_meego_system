import Qt 4.7
//import QmlStatusBarWidget 2.0//removed by esjang 2012.12.20 for Update Status bar 

import Qt.labs.gestures 2.0

import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import QmlStatusBar 1.0 // added by esjang 2013.05.13 for Update Status bar
//{ modified by yongkyun.lee 2014-02-18 for : 
import POPUPEnums 1.0
//} modified by yongkyun.lee 2014-02-18 
import CQMLLogUtil 1.0

Rectangle {
    id: pndrController
    //y: -93
    //y: 0 // recovery by jonghwan.cho@lge.com 2013.02.04.
    // TODO: Need to change the height and Y position
    // after integration  with Framework to show the status bar
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: PR.const_PANDORA_MAIN_SCREEN_HEIGHT

    //QML Properties Declaration
    property variant activeView
    property bool isWaitEnabled: false
    property int currentDeviceIndex:-1
    property bool deviceInUse: false;
    property string initialStateofTrackView: "trackStatePaused"
    property alias popupVisible : popup.visible
    property alias noStationPopupVisible : noStationPopup.visible  // add by cheolhwan 2013.12.02. for ITS 210787.
    property bool isMenuBtnVisible: false;//statusBar.isMenuBtnVisible;//removed by esjang 2012.12.20 for Update Status bar 
    property bool showTrackView: false;
    property string currentActiveStation;
    property int currentActiveStationToken : 0;
    property bool isDialUI : false

    property bool isjogAccepted: true

    property bool isNoStationExists : false
    property bool isNoActiveStation : false
    property bool isDRSPopup : false // added by esjang 2013.08.14 for ITS #183734
    property bool isDRSPopupShow : false //{ modified by yongkyun.lee 2014-06-10 for : ITS 239774
    property bool visibleStatus: true
    property int  viewNumber: 0

    property bool isInsufficient: false; //added by esjang 2013.11.08 for audit issue
    property int  pos_x: 0
    property int  pos_y: 0
    
//{ modified by yongkyun.lee 2014-02-18 for : 
    property variant pandoraPopupID : PopupIDPnd.POPUP_PANDORA_UNDEFINED //modified by jyjeon 2014-03-14 for ITS 229391
//} modified by yongkyun.lee 2014-02-18 
    property int language: UIListener.languageId
    property bool afterLocalPopup: false// modified by yongkyun.lee 2014-05-27 for : ITS 238336
    property string logString :""

    Image
    {
        id:bgImage
        source: PR_RES.const_APP_PANDORA_URL_IMG_GENERAL_BACKGROUND_1
        fillMode: Image.Tile
        anchors.fill: parent
    }
    Image
    {
       id: bg_bottom
       anchors.left: parent.left
       anchors.bottom: parent.bottom
       visible: (pndrController.state === "pndrTrackView")
       source: PR_RES.const_BG_BASIC_BOTTOM_IMG
    }
//    Image {
//        id: bgKeypad
//        x: 0
//        y: 0
//        visible: (pndrController.state === "pndrSearchView")
//        source: PR_RES.const_APP_PANDORA_KEYPAD_BG
//        width: 1280
//        height: 400
//    }

    //hack the takky code . // option menu does not receive the 1st tap event.
    GestureArea {
        id: gestureArea
        anchors.fill: parent
        Tap {
        
           onStarted: {
                pos_x = gesture.position.x;
                pos_y = gesture.position.y;
           }
           
           onFinished: {
               if(pndrController.state === "pndrTrackView")
                   activeView.closeToastPopup();
           }

        }
        // added by esjang 2013.10.17 for rewind/ seek by touch(swipe) on track view 
        Pan {
            onFinished:
            {

                if(pos_x == Math.abs(gesture.offset.x) && pos_y == Math.abs(gesture.offset.y)
                    || (165 > pos_y || pos_y > 465) )
                {
                    console.log("Do not allow panning event as start and end position are the same");
                    return;
                }
                
		// modified by cheolhwan 2013.12.03. add condition "!popupVisible" for ITS 212464
                if(pndrController.state === "pndrTrackView"
                    /*&& !UIListener.IsCalling()*/ && !popupVisible) //{ modified by cheolhwan 2014-03-21. ITS 230286. 
                {
                    //{ added by cheolhwan 2014-03-21. ITS 230286. 
                    if(UIListener.IsCalling()){
                        popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
                        return;
                    }
                    //} added by cheolhwan 2014-03-21. ITS 230286. 
                    if (gesture.offset.x < -100 && Math.abs(gesture.offset.y) < 300)
                    {
                        pndrTrack.Skip();
                    }
                    else if (gesture.offset.x > 100 && Math.abs(gesture.offset.y) < 300)
                    {
                        activeView.handleRewindEvent();
                    }
                }
            }
        }
    }

    //{ added by esjang 2013.05.13 for Update Status bar
    QmlStatusBar {
        id: statusBar
        x: 0;
        y: 0;
        //z: 2;  //deleted by cheolhwan 2013.12.26. ITS 217300. dimming a status bar during display the receiving popup. //added by esjang 2013.06.07 //BCH_CHECK.  option menu does not receive the 1st tap event.
        width: 1280;
        height: 93;
        homeType: "button"
        middleEast: false
    }
    //} added by esjang 2013.05.13 for Update Status bar
    // define various loader. Load only 1st screen
    Loader { id: pndrConnectedDeviceViewLoader;}
    Loader { id: pndrConnectingViewLoader;}
    Loader { id: pndrTrackViewLoader; }
    Loader { id: pndrListViewLoader; }
    Loader { id: pndrSearchViewLoader; }
    Loader { id: pndrExplainViewLoader; }
    Loader { id: pndrDrivingRestrictionViewLoader; }
    Loader { id: pndrSearchDRViewLoader; }
    Loader { id: pndrErrorViewLoader; }
    Loader { id: pndrStationEntryErrorViewLoader}
    Loader { id: pndrLoadingViewLoader; }// added by esjang 2013.03.13 for Loading VIew


    // define various states and its effect
    states: [

        /* //removed by jyjeon 2014-04-04 for Loading VIew
        State
        {
			// This view will be activited only if more than
		    // one device is found connected, else it will show Connecting Device
		    // waiting screen
            name: "pndrConnectedDeviceListView"
            PropertyChanges { target: pndrConnectedDeviceViewLoader;
                source: "DHAVN_PandoraDeviceListView.qml";}
            PropertyChanges {target: pndrController; isMenuBtnVisible:false;}
            PropertyChanges {target: pndrController; showTrackView:false;}
            PropertyChanges {target: pndrController; viewNumber:0;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698

        },
        */ //removed by jyjeon 2014-04-04 for Loading VIew

        State
        {
            name: "pndrConnectingView"
            PropertyChanges { target: pndrConnectingViewLoader;
                source: "DHAVN_PandoraConnectingView.qml"; }
            PropertyChanges {target: pndrController; isMenuBtnVisible:false;}
            PropertyChanges {target: pndrController; showTrackView:true;}
            PropertyChanges {target: pndrController; viewNumber:1;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        },

        State
        {
            name: "pndrTrackView"
            PropertyChanges { target: pndrTrackViewLoader;
                source: "DHAVN_PandoraTrackView.qml";}
            PropertyChanges {target: pndrController; isMenuBtnVisible:true;}
            PropertyChanges {target: pndrController; showTrackView:true;}
            PropertyChanges {target: pndrController; isNoStationExists:false;}
            PropertyChanges {target: pndrController; isNoActiveStation:false;}
            PropertyChanges {target: pndrController; viewNumber:2;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        },

//{ added by esjang 2013.03.13 for Loading VIew
        State
        {
            name: "pndrLoadingView"
            PropertyChanges { target: pndrLoadingViewLoader;
                source: "DHAVN_PandoraLoadingView.qml";}
            PropertyChanges {target: pndrController; isMenuBtnVisible:true;}
            PropertyChanges {target: pndrController; showTrackView:true;}
            PropertyChanges {target: pndrController; viewNumber:0;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        },

//} added by esjang 2013.03.13 for Loading VIew
        State {
            name: "pndrListView"
            PropertyChanges { target: pndrListViewLoader;
                source: "DHAVN_PandoraListView.qml";}
            PropertyChanges {target: pndrController; isMenuBtnVisible:true;}
            PropertyChanges {target: pndrController; showTrackView:false;}
            PropertyChanges {target: pndrController; isNoStationExists:false;}
            PropertyChanges {target: pndrController; isNoActiveStation:pndrController.isNoActiveStation;}
            PropertyChanges {target: pndrController; viewNumber:3;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        },

        State {
            name: "pndrSearchView"
            //modified by jyjeon 2014-04-22 for ITS 227698
            //PropertyChanges { target: pndrSearchViewLoader;
            //    source: "DHAVN_PandoraSearchView.qml"; }
            PropertyChanges { target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader:null;
                sourceComponent: pndrSearchViewLoader.item; }
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: true;}
            //modified by jyjeon 2014-04-22 for ITS 227698
            PropertyChanges {target: pndrController; isMenuBtnVisible:false;}
            PropertyChanges {target: pndrController; showTrackView:false;}
            PropertyChanges {target: pndrController; isNoStationExists:pndrController.isNoStationExists;}
            PropertyChanges {target: pndrController; isNoActiveStation:pndrController.isNoActiveStation;}
            PropertyChanges {target: pndrController; viewNumber:4;}

        },
        State {
            name: "pndrSearchDRView"
            //modified by jyjeon 2014-04-22 for ITS 227698
            //PropertyChanges { target: pndrSearchViewLoader;
            //    source: "DHAVN_PandoraSearchView.qml"; }
            PropertyChanges { target:pndrSearchDRViewLoader;
                source: "DHAVN_PandoraSearchDR.qml"; }
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;}
            //modified by jyjeon 2014-04-22 for ITS 227698
            PropertyChanges {target: pndrController; isMenuBtnVisible:false;}
            PropertyChanges {target: pndrController; showTrackView:false;}
            PropertyChanges {target: pndrController; isNoStationExists:pndrController.isNoStationExists;}
            PropertyChanges {target: pndrController; isNoActiveStation:pndrController.isNoActiveStation;}
            PropertyChanges {target: pndrController; viewNumber:11;}

        },

        State {
            name: "pndrExplainView"
            PropertyChanges { target: pndrExplainViewLoader;
                source: "DHAVN_PandoraExplainView.qml";}
            PropertyChanges {target: pndrController; isMenuBtnVisible:false;}
            PropertyChanges {target: pndrController; showTrackView:false;}
            PropertyChanges {target: pndrController; isNoStationExists:false;}
            PropertyChanges {target: pndrController; isNoActiveStation:false;}
            PropertyChanges {target: pndrController; viewNumber:6;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        },

        State {
            name: "pndrDrivingRestrictionView"
            PropertyChanges { target: pndrDrivingRestrictionViewLoader;
                source: "DHAVN_PandoraDrivingRestriction.qml";}
            PropertyChanges {target: pndrController; isMenuBtnVisible:false;}
            PropertyChanges {target: pndrController; showTrackView:false;}
            PropertyChanges {target: pndrController; isNoStationExists:false;}
            PropertyChanges {target: pndrController; isNoActiveStation:false;}
            PropertyChanges {target: pndrController; viewNumber:10;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        },
        State {
            name: "pndrErrorView"
            PropertyChanges { target: pndrErrorViewLoader;
                source: "DHAVN_PandoraErrorView.qml"; }
            PropertyChanges {target: pndrController; isMenuBtnVisible:false;}
            PropertyChanges {target: pndrController; showTrackView:false;}
            PropertyChanges {target: pndrController; viewNumber:8;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        },

        State {
            name: "pndrStationEntryErrorView"
            PropertyChanges { target: pndrStationEntryErrorViewLoader;
                source: "DHAVN_PandoraStationEntryErrorView.qml"; }
            PropertyChanges {target: pndrController; isMenuBtnVisible:false;}
            PropertyChanges {target: pndrController; showTrackView:false;}
            PropertyChanges {target: pndrController; isNoStationExists:true;}
            PropertyChanges {target: pndrController; isNoActiveStation:true;}
            PropertyChanges {target: pndrController; viewNumber:5;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        }
        //{ added by esjang 2013.05.31 for ISV #82820
        ,
        State {
            name: "pndrDisconnectView"
            PropertyChanges { target: pndrTrackViewLoader;
                source: "DHAVN_PandoraTrackView.qml";}
            PropertyChanges {target: pndrController; isMenuBtnVisible:true;}
            PropertyChanges {target: pndrController; showTrackView:true;}
            PropertyChanges {target: pndrController; viewNumber:9;}
            PropertyChanges {target: (pndrSearchViewLoader.status == Loader.Ready )?pndrSearchViewLoader.item:null; visible: false;} //added by jyjeon 2014-04-22 for ITS 227698
        }
	//} added by esjang 2013.05.31 for ISV #82820
    ]

    //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
    onIsInsufficientChanged:
    {
        __LOG("isInsufficient= " + isInsufficient , LogSysID.HIGH_LOG);
        if(activeView != null)
            activeView.setInsufficient(isInsufficient);
    }
    //} modified by yongkyun.lee 2014-03-11 

    onStateChanged:{
        __LOG(" State changed to = " + pndrController.state , LogSysID.LOW_LOG);

        //{ modified by yongkyun.lee 2014-12-12 for : ITS 254472
        if( pndrTrackViewLoader.item.isToastPopup())
        {
            __LOG("[leeyk1]isToastPopup ", LogSysID.LOW_LOG );        
            pndrTrackViewLoader.item.forceCloseToastPopup();
        }
        
        if( pndrListViewLoader.item.isToastPopup())
        {
            pndrListViewLoader.item.closeToastPopup();
        }
        //} modified by yongkyun.lee 2014-12-12 

    }
    onViewNumberChanged:{
       // __LOG(" View changed from = "  +  UIListener.currView +" to = " + viewNumber , LogSysID.LOW_LOG );
        //{ added by cheolhwan 2014-02-27. ITS 225019. Connecting view is displayed indefinitely when pandora entered during no network.
        //if(UIListener.currView == 1 && viewNumber != 0)
        //    activeView.setChangeErrorText(0)
        //} added by cheolhwan 2014-02-27. ITS 225019. Connecting view is displayed indefinitely when pandora entered during no network.
        UIListener.currView = pndrController.viewNumber;
    }

    /***************************************************************************/
    /**************************** Pandora QML connections START ****************/
    /***************************************************************************/

    //pndrConnectedDeviceView.qml Connections
    Connections{
        target: pndrConnectedDeviceViewLoader.item
        onConnectToDevice:
        {
            //selected device name is in Variable 'selectedDevice'
             __LOG("Selected device :"+ selectedDevice , LogSysID.LOW_LOG);
            currentDeviceIndex = selectedDevice;
            pndrController.state = "pndrConnectingView";
        }
        onHandleBackRequest:
        {
            __LOG ("QmlRadioWidget: onHandleBackRequest" , LogSysID.LOW_LOG);
	        //sendAppToBackground();
            sendAppToBackground(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
        }
    }

    //PandoraListView Connections
    Connections
    {
        target:pndrListViewLoader.item
        onHandlestationSelectionEvent:
        {
            __LOG("onHandlestationSelectionEvent" , LogSysID.LOW_LOG);
            UIListener.TuneSelectTimer(false);
            pndrController.state = "pndrTrackView"
            pndrController.activeView.showTrackWait();
            pndrNotifier.ClearCluster();// added by esjang 2013.04.26 for Clear TP Message 
            //Clear track info on station changed
            pndrTrack.ClearTrackInfo();            
            pndrStationList.SelectStation(stationIndex);
            //pndrStationList.CancelStationArtRequest();
            pndrStationList.ClearCurrentRequest();
            //pndrStationList.ClearCache();
            currentActiveStationToken = -1;
            UIListener.IfMute_SentAudioPass();
        }
        onHandleSearchViewEvent:
        {
            //When Back is pressed from search View, List request is resent, Not cached.
            //Hence CAncel Station Art Fetching when Search View is launched
            // added by esjang 2013.08.14 for ITS #183734
            if(!UIListener.getScrollingTicker()) // if it is driving mode
            {
                pndrController.state = "pndrSearchDRView";
                pndrStationList.CancelStationArtRequest();
                if( pndrTrack.GetCurrentStationToken() > 0){
                    activeView.isFromErrorView = false;
                }

                activeView.handleForegroundEvent();
                isDRSPopup = true;


                //popup.showPopup(PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION, false); // modified by esjang 2013.07.31 for ITS #182051
            }
            else    //if it is parking mode
            {
                pndrController.state = "pndrSearchView";
                __LOG("CancelStationArtRequest on Search View launch" , LogSysID.LOW_LOG);
                pndrStationList.CancelStationArtRequest();

                __LOG("onHandleSearchViewEvent pndrSearchViewLoader.status = " + pndrSearchViewLoader.status, LogSysID.LOW_LOG);
                if(pndrSearchViewLoader.status != Loader.Ready )
                  pndrSearchViewLoader.source = "DHAVN_PandoraSearchView.qml"
                if( pndrTrack.GetCurrentStationToken() > 0){                    
                    activeView.isFromErrorView = false;
                }

                activeView.handleForegroundEvent();
            }

        }
        onHandleBackRequest:
        {
            if(activeView.isFromErrorView || ( isNoStationExists || isNoActiveStation ) )
            {
                activeView.isFromErrorView = true;
		        //sendAppToBackground();
                sendAppToBackground(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
            }
            else
            {
                __LOG("for isInsufficient: " + isInsufficient , LogSysID.LOW_LOG);
                pndrController.state = "pndrTrackView";
                pndrStationList.CancelStationArtRequest();
                activeView.handleForegroundEvent();

                //activeView.handleNetworkError(isInsufficient); //added by esjang 2013.11.08 for audit issue
            }
        }
    }


    //PandoraSearchView Connections
    Connections{
        target:pndrSearchDRViewLoader.item
        onHandleBackRequest:{
            if(!activeView.isFromErrorView)
            {
                //added by 2013.11.08 esjang for audit issue
                __LOG("for audit issue isInsufficient: " + isInsufficient , LogSysID.LOW_LOG)
                pndrController.state = "pndrListView";
                activeView.handleLoadingPopup(isInsufficient); //added by esjang 2013.11.08 for audit issue
                activeView.handleForegroundEvent();
            }
            else
            {
                pndrController.state = "pndrStationEntryErrorView";
            }
        }

         //{ modified by yongkyun.lee 2014-12-30 for : ITS 255280
          onSearchCallPopup:
          {
              popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE, false);
          }
         //} modified by yongkyun.lee 2014-12-30
    }


    //PandoraSearchView Connections
    Connections{
        target:pndrSearchViewLoader.item
        onHandleBackRequest:{
            if(!activeView.isFromErrorView)
            {
		//added by 2013.11.08 esjang for audit issue
		__LOG("for audit issue isInsufficient: " + isInsufficient , LogSysID.LOW_LOG)
                pndrController.state = "pndrListView";
                activeView.handleLoadingPopup(isInsufficient); //added by esjang 2013.11.08 for audit issue
                activeView.handleForegroundEvent();
            }
            else
            {
                pndrController.state = "pndrStationEntryErrorView";
            }
        }

        onHandleStationSelectionEvent:{
            __LOG("selectionName : "+index, LogSysID.LOW_LOG );
            UIListener.TuneSelectTimer(false);
            pndrController.showTrackView = true;
            //Dont clear information on creating new station , It may fail to create
            //pndrTrack.ClearTrackInfo();
            pndrSearch.SearchSelect(index);
            UIListener.IfMute_SentAudioPass();
        }
        
         //{ modified by yongkyun.lee 2014-12-30 for : ITS 255280
          onSearchCallPopup:
          {
              popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE, false);
          }
         //} modified by yongkyun.lee 2014-12-30 
    }   

    //ConnectingView.QML Connections
    Connections{
        target: pndrConnectingViewLoader.item
        onHandleBackRequest:
        {
            __LOG ("QmlRadioWidget: onHandleBackRequest", LogSysID.LOW_LOG);
	        //sendAppToBackground();
            sendAppToBackground(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey


        }
        onDeviceNotFound:
        {
            __LOG("show error view for device not found : from Coonecting scren ", LogSysID.HIGH_LOG);
             popup.showPopup(PopupIDPnd.POPUP_NO_PHONE_CONNECTED,true);  // modified by esjang 2013.03.23 for ISV # 73220
        }
    }

    //TrackView Connections
    Connections{
        target: pndrTrackViewLoader.item
        onHandleBackRequest:
        {
            //sendAppToBackground();
	        sendAppToBackground(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
        }

        onHandleListViewEvent:{
            __LOG ("onHandleListViewEvent", LogSysID.LOW_LOG);
            pndrController.state = "pndrListView";
            activeView.handleForegroundEvent();
        }

        onHandleExplainViewEvent:{
            __LOG ("onHandleExplainViewEvent" , LogSysID.LOW_LOG);
	    // added by esjang 2013.08.14 for ITS #183734
            if(!UIListener.getScrollingTicker()) // if it is driving mode
            {
                isDRSPopup = true;
                pndrController.state = "pndrDrivingRestrictionView";
                //popup.showPopup(PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION , false); // modified by esjang 2013.07.31 for ITS #182051
            }
            else
            {
                pndrController.state = "pndrExplainView";
            }

        }

        onHandleRewindEvent:{
             __LOG("From track onHandleRewindEvent : " + popup.errorType , LogSysID.LOW_LOG);
            if( PopupIDPnd.POPUP_PANDORA_REWIND_NOT_AVAILABLE != pndrController.pandoraPopupID)// modified by yongkyun.lee 2014-11-03 for : //leeyk1 OSD TEST
            {
                popup.showPopup(PopupIDPnd.POPUP_PANDORA_REWIND_NOT_AVAILABLE , false); // modified by esjang 2013.07.31 for ITS #182051
            }

        }
    }

    //ExpalinView.QML Connections
    Connections{
        target: pndrExplainViewLoader.item
        onHandleBackRequest:
        {
            __LOG ("QmlRadioWidget: onHandleBackRequest" , LogSysID.LOW_LOG);
            //pndrController.state = "pndrTrackView";
            //activeView.handleForegroundEvent();
            //{ added by esjang 2013.11.08 for audit issue
            __LOG("for explainview loader radio.qml isInsufficient: " + isInsufficient , LogSysID.LOW_LOG);
            pndrController.state = "pndrTrackView";
            activeView.handleForegroundEvent();
            //activeView.handleNetworkError(isInsufficient); //added by esjang 2013.11.08 for audit issue
            //} added by esjang 2013.11.08 for audit issue


        }
    }

    //ExpalinView.QML Connections
    Connections{
        target: pndrDrivingRestrictionViewLoader.item
        onHandleBackRequest:
        {
            __LOG ("QmlRadioWidget: onHandleBackRequest" , LogSysID.LOW_LOG);
            //pndrController.state = "pndrTrackView";
            //activeView.handleForegroundEvent();
            //{ added by esjang 2013.11.08 for audit issue
            __LOG("for explainview loader radio.qml isInsufficient: " + isInsufficient , LogSysID.LOW_LOG);
            pndrController.state = "pndrTrackView";
            activeView.handleForegroundEvent();
            //activeView.handleNetworkError(isInsufficient); //added by esjang 2013.11.08 for audit issue
            //} added by esjang 2013.11.08 for audit issue


        }
    }

    //ErrorView.QML Connections
    Connections{
        target: pndrErrorViewLoader.item
        onHandleBackRequest:
        {
            //exitApplication();
	    exitApplication(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
        }
        onHandleConnectionRequest:
        {
            pndrController.initializePandora();
        }
    }

    //DHAVN_PandoraStationEntryErrorView.QML Connections
    Connections{
        target: pndrStationEntryErrorViewLoader.item
        onHandleBackRequest:
        {
            //sendAppToBackground();
            //sendAppToBackground(isJogDial);
            var string = qsTranslate("main","STR_PANDORA_STATION_ENTRY_ERROR_VIEW_TEXT1")
            + "\n" + qsTranslate("main","STR_PANDORA_STATION_ENTRY_ERROR_VIEW_TEXT2");
            //popup.showNoStationPopup(string, false);
            noStationPopup.showNoStationPopup(string, false);  // add by cheolhwan 2013.12.02. for ITS 210787.
        }
        onSearchButtonClicked:
        {
            __LOG ("QmlRadioWidget: Error View onSearchButtonClicked" , LogSysID.LOW_LOG);
            //{ added by cheolhwan 2013.12.02. for ITS 210787. add a DRS Popup.
            var errorState = false; //added by wonseok.heo for ITS 258177

            if(!UIListener.getScrollingTicker()) // if it is driving mode
            {
                isDRSPopup = true;
                popup.showPopup(PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION , false);                
            }
            else
            {
                //{ add by cheolhwan 2013.12.02. for ITS 210787.
                if(noStationPopupVisible === true)
                {
                    noStationPopup.hidePopup();
                }
                if(pndrController.state === "pndrStationEntryErrorView" ){ 
                    errorState = true;
                }//added by wonseok.heo for ITS 258177

                //} add by cheolhwan 2013.12.02. for ITS 210787.
                pndrController.state = "pndrSearchView";
                //added by jyjeon 2014-04-22 for ITS 227698
                if(pndrSearchViewLoader.status != Loader.Ready )
                    pndrSearchViewLoader.source = "DHAVN_PandoraSearchView.qml"
                //added by jyjeon 2014-04-22 for ITS 227698
                //added by wonseok.heo for ITS 258177
                if(errorState == true){
                    activeView.isFromErrorView = true; 
                }else{
                    activeView.isFromErrorView = false;
                    isNoStationExists = false;
                    isNoActiveStation = false;
                }//added by wonseok.heo for ITS 258177

                activeView.handleForegroundEvent();
            }
        }
    }

    Component.onCompleted: {
        __LOG("Component Completed" , LogSysID.LOW_LOG);

    }

    /***************************************************************************/
    /**************************** Pandora QML connections END ****************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Pandora Qt connections START ****************/
    /***************************************************************************/
    Connections
    {
        target:UIListener

        onRetranslateUi:
        {
            language = languageId;
            if(activeView != null){
                LocTrigger.retrigger()
                activeView.handleRetranslateUI(languageId);
            }
            //statusBar.retranslateUi(languageId);
        }
        //removed by esjang 2012.12.20 for Update Status bar

        //{ added by esjang 2013.03.12 for Popup Hotfix
        onSignalShowSystemPopup:
        {
            __LOG("onSignalShowSystemPopup" , LogSysID.LOW_LOG);
            //close local popup
            //myToastPopup.visible = false;//added by esjang 2013.04.08 for Popup Hotfix
            popup.hidePopup();
            noStationPopup.hidePopup();// add by cheolhwan 2013.12.02. for ITS 210787.

//            if( ( pndrController.state === "pndrExplainView" || pndrController.state === "pndrDrivingRestrictionView")
//                && (isDRSPopup === true) )
//            {
//                __LOG("close popup and go to track view", LogSysID.LOW_LOG);
//                isDRSPopupShow= true;// modified by yongkyun.lee 2014-06-10 for : ITS 239774
//            }
//            else if( ( pndrController.state === "pndrSearchView")
//                && (isDRSPopup === true) )
//            {
//                __LOG("close popup and go to list view", LogSysID.LOW_LOG);
//                isDRSPopupShow= true;// modified by yongkyun.lee 2014-06-10 for : ITS 239774
//            }
            //{ added by cheolhwan 2014-01-09. ITS 218638.

            if(  ( pndrController.state === "pndrTrackView")//{ modified by yongkyun.lee 2014-05-28 for : ITS 238338
                    //added by jyjeon 2014.02.03 for ITS 223607
                    || ( pndrController.state === "pndrExplainView")
                    || ( pndrController.state === "pndrDrivingRestrictionView")
                    || ( pndrController.state === "pndrErrorView") // modified by yongkyun.lee 2014-12-11 for : ITS 254376 
                    || ( pndrController.state === "pndrListView")
                    || ( pndrController.state === "pndrSearchDRView")
                    || ( pndrController.state === "pndrSearchView")  )
                    //added by jyjeon 2014.02.03 for ITS 223607
            {
                activeView.manageFocusOnPopUp(true);
            }
            //}  added by cheolhwan 2014-01-09. ITS 218638.
            //console.log("0805 system popup set true");
            UIListener.SetSystemPopupVisibility(true);
        }
        onSignalHideSystemPopup:
        {
            __LOG("onSignalHideSystemPopup : popupVisible ==" + popupVisible, LogSysID.LOW_LOG);
            if(  ( pndrController.state === "pndrTrackView")
                || ( pndrController.state === "pndrExplainView")
                || ( pndrController.state === "pndrDrivingRestrictionView")
                || ( pndrController.state === "pndrSearchDRView")
                || ( pndrController.state === "pndrListView")
                || ( pndrController.state === "pndrErrorView") // modified by yongkyun.lee 2014-12-11 for : ITS 254376  
                || ( pndrController.state === "pndrSearchView")  )
            {
                __LOG("onSignalHideSystemPopup : 1", LogSysID.LOW_LOG);
                if(!popupVisible) {
                    __LOG("onSignalHideSystemPopup :2", LogSysID.LOW_LOG);

                    activeView.manageFocusOnPopUp(false);
                }
            }
            UIListener.SetSystemPopupVisibility(false);
            
             if(isDRSPopupShow === true )
             {
                 //{ modified by yongkyun.lee 2014-10-17 for : ITS 250214
                // if(UIListener.getScrollingTicker())
                //     isDRSPopupShow = false;
                // else
                 //} modified by yongkyun.lee 2014-10-17 
                //     popup.showPopup(PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION, false)
             }
            else if(afterLocalPopup)
                 popup.showPopup(pndrController.pandoraPopupID, popup.showErrorView)
        }

        onConnectionStatusChanged:
        {
             __LOG("onConnectionStatusChanged status = " + isConnected, LogSysID.LOW_LOG);
            if(1 === isConnected) // 1 means device is connected .
            {
                //NOTE: on connected, Trackupdated signal emits and called TrackView
                __LOG("connected", LogSysID.LOW_LOG);
                
                deviceInUse = true;
            }
            else
            {
                //esjang test  for popup handling
                
                if(popupVisible)
                {
                    popup.hidePopup();
                }

                //{ add by cheolhwan 2013.12.02. for ITS 210787.
                if(noStationPopupVisible)
                {
                    noStationPopup.hidePopup();
                }
                //} add by cheolhwan 2013.12.02. for ITS 210787.

                //{ added by esjang 2013.11.08 for audit issue
                if(isInsufficient == true)
                {
                    __LOG("onconnectionstatuschanged else updated radio.qml, isInsufficient : false " , LogSysID.LOW_LOG);
                    //isInsufficient = false;
                }
                //} added by esjang 2013.11.08 for audit issue

                deviceInUse = false ;
              //  UIListener.Disconnect();

                if( activeView != null &&  activeView.visible === false )
                {
                    pndrController.state = "" ;
                    activeView = null ;
                }
            }
        }

        onDeviceChanged:
        {
            __LOG("Device Changed , Hence reset to Null , along with all states", LogSysID.LOW_LOG);

            pndrController.state = ""
	    //{ add by cheolhwan 2014-01-09. ITS 218575 218728. (by Radha)
            initialStateofTrackView = "trackStatePaused"
            deviceInUse = false
            isMenuBtnVisible = false
            showTrackView = false
            currentActiveStation = ""
            currentActiveStationToken = 0
            isjogAccepted = true  // Modified by checolhwan 2014-01-13. ITS 219018. (false->true)
            isNoStationExists = false
            isNoActiveStation = false
            isDRSPopup = false
            visibleStatus = false
            viewNumber = 0
            isInsufficient = false
	    //} add by cheolhwan 2014-01-09. ITS 218575 218728. (by Radha)
	        //added by wonseok.heo for ITS 258177
            activeView.isFromErrorView = false; 
            isNoStationExists = false;
            isNoActiveStation = false;
            //added by wonseok.heo for ITS 258177

            if(activeView != null)
            {
                activeView.visible = false;
                activeView = null;
            }
            //esjang test  for popup handling
            if(popupVisible)
            {
                popup.hidePopup();
            }
            //esjang test  for popup handling

            //{ add by cheolhwan 2013.12.02. for ITS 210787.
            if(noStationPopupVisible)
            {
                noStationPopup.hidePopup();
		//{ add by cheolhwan 2014-01-09. ITS 218575 218728. (by Radha)
                noStationPopup.visible = false
		//} add by cheolhwan 2014-01-09. ITS 218575 218728. (by Radha)
            }
            //} add by cheolhwan 2013.12.02. for ITS 210787.
        }

        onPlayInBG:
        {
            pndrController.state = ""
            if(activeView != null)
            {
                activeView.visible = false;
                activeView = null;
            }
            visibleStatus = false ;
            pndrController.state = "pndrConnectingView";
            activeView.visible = false;
            UIListener.Connect();
        }

        onForeground:
        {

             __LOG("Foreground event state =  " + pndrController.state + ", isInsufficient:" + isInsufficient, LogSysID.LOW_LOG);

            visibleStatus = true;
            if((pndrController.state !== "")/*&& (pndrController.state !== "pndrErrorView"*/)/*&&(pndrController.state !=="pndrDisconnectView")*///) // added by esjang 2013.05.31 for ISV #82820
            {
                //{ added by cheolhwan 2013.11.19. for ITS 0208837.
//                if((pndrController.state === "pndrExplainView" || pndrController.state === "pndrSearchView") && isDRSPopup === true)
//                {

//                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION , false);
//                }

                //} added by cheolhwan 2013.11.19. for ITS 0208837.

                if(pndrController.state === "pndrExplainView"  && isDRSPopup === true)
                {

                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION , false);
                }

                if( pndrController.state === "pndrSearchView" && isDRSPopup === true)
                {

                }

                //{ modified by yongkyun.lee 2014-11-27 for : NOCR
                if(pndrController.state === "pndrTrackView")
                {
                    activeView.checkTune();
                }
                //} modified by yongkyun.lee 2014-11-27 
                if(activeView.visible !== true)
                {
                    activeView.visible = true;
                    //activeView.handleForegroundEvent();
                }
            }
            else
            {
                 __LOG("Foreground event State is null , Hence Initialize Pandora", LogSysID.LOW_LOG);
                initializePandora();
            }
            //{ added by cheolhwan 2014-03-21. modified the error about No Network.
            if(isInsufficient && pndrController.state === "pndrTrackView")
            {
                activeView.setInsufficient(isInsufficient);
            }
            //} added by cheolhwan 2014-03-21. modified the error about No Network.
            //{ modified by yongkyun.lee 2014-09-30 for : ITS 249293
            if(pndrController.state === "pndrListView")
            {
                activeView.checkCurrentstation();
            }
            //} modified by yongkyun.lee 2014-09-30 
        }

        onBackground:
        {            
            __LOG("onBackground state : " + pndrController.state, LogSysID.LOW_LOG);
            visibleStatus = false ;
            if(pndrController.state !== "" && activeView !== null){
                if(!isDRSPopup){
                    popup.hidePopup();
                }
		//{ add by cheolhwan 2013.12.02. for ITS 210787.
		if(noStationPopupVisible)
                    noStationPopup.hidePopup();
		//} add by cheolhwan 2013.12.02. for ITS 210787. 
                activeView.visible = false; 
                UIListener.SetSystemPopupVisibility(false);
            }
        }

        onNetworkError:
        {
            __LOG("error name: Network error - ", LogSysID.LOW_LOG);
            if(pndrController.state != "pndrErrorView"){
                pndrController.state = "pndrErrorView"
                activeView.setTextChange(7); //E_NETWORK_FAILED // add by cheolhwan 2013.12.04 for ITS 211672.
                UIListener.SessionTerminate(); //added by jyjeon 2014-03-20 for ITS 230131
            }            
        }

        onHandleError:
        {
            __LOG("HandleError Error =  " + inPndrError, LogSysID.HIGH_LOG);
             switch(inPndrError)
            {
                case 1:  //E_INVALID_STATE
                {
                    __LOG("HandleError # 1 E_INVALID_STATE", LogSysID.LOW_LOG);

                    //modefied by jyjeon 2014-04-04 for NAQC
                    //added by jyjeon 2014-03-27 for ITS 231421
                    if(pndrController.state == "pndrConnectingView" || pndrController.state == "pndrListView")
                    {
                        pndrController.state = "pndrErrorView";
                        activeView.setTextChange(inPndrError);
                        UIListener.Disconnect();
                    }
                    else
                    //added by jyjeon 2014-03-27 for ITS 231421
                    if(pndrController.state != "pndrErrorView")
                    {
                        activeView.handleForegroundEvent(); // added by esjang 2013.11.12 for ITS # 2016152
                    }
                    //modefied by jyjeon 2014-04-04 for NAQC
                    break;
                }

                case 2: //E_INIT_FAILED
                {
                    if(pndrController.state != "pndrErrorView")
                        popup.showPopup(PopupIDPnd.POPUP_INITALIZATION_FAILED,true); // modified by esjang 2013.03.23 for ISV # 73220
                    break;
                }
                case 3: //E_DEVICE_NOT_FOUND
                {
                    if(pndrController.state != "pndrErrorView"){
                        pndrController.state = "pndrErrorView";
                        activeView.setTextChange(inPndrError); // add by cheolhwan 2013.12.04 for ITS 211672.
                        //popup.showPopup(PopupIDPnd.POPUP_NO_PHONE_CONNECTED,true); // modified by esjang 2013.03.23 for ISV # 73220 //removed by jyjeon 2014-05-09 for ITS 236340
                    }
                    UIListener.Disconnect(); //added by jyjeon 2014-03-27
                    break;
                }
                case 4: //E_BT_CONNECTION_FAILED:
                case 5: //E_USB_CONNECTION_FAILED:
                {
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_DISCONNECTED,true);
                    break;
                }
                case 6: //E_CHECK_PNDR_APP_ON_DEVICE
                {
                    if(pndrController.state != "pndrErrorView")
                    {
                        pndrController.state = "pndrErrorView";
                        activeView.setTextChange(inPndrError); // add by cheolhwan 2013.12.04 for ITS 211672.
                        UIListener.SessionTerminate(); // added by cheolhwan 2014-03-04. ITS 227715 for KH.
                    }
                    break;
                }
                case 8: //E_INVALID_TOKEN
                {
                    popup.showPopup(PopupIDPnd.POPUP_TOKEN_STATION_NOT_VALID,false); // modified by esjang 2013.03.23 for ISV # 73220
                    break;
                }
                case 9: //E_INVALID_STRING
                {
                    popup.showPopup(PopupIDPnd.POPUP_EMPTY_INPUT_CRITERIA,false); // modified by esjang 2013.03.23 for ISV # 73220
                    break;
                }
                case 10: //E_INVALID_STATION_REQ_RANGE
                {
                    popup.showPopup(PopupIDPnd.POPUP_REQUESTED_STATION_RANGE_NOT_VALID,false); // modified by esjang 2013.03.23 for ISV # 73220
                    break;
                }
                case 11: //E_INVALID_VERSION
                {
                    // modified by esjang 2013.03.20 for ITS # 159179 'No Skip Available'
                    //UIListener.Disconnect();

                    //popup.showPopup("This version of Pandora is incompatible with the system and needs to be updated on your mobile device.",true); // modified by esjang 2013.03.23 for ISV # 73220
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_INCOMPATIABLE_VERSION , true);
                    //UIListener.Disconnect();

                    break;
                }
                case 12: //E_NO_STATIONS
                {
                    currentActiveStationToken = 0;
                    currentActiveStation = "";
                    pndrController.state = "pndrStationEntryErrorView"
                    activeView.isFromErrorView = true
                    break;
                }
                case 13: //E_NO_ACTIVE_STATIONS
                {
                    // modified by esjang 2013.03.20 for ITS # 159179 'No Skip Available'
                    currentActiveStationToken = 0;
                    currentActiveStation = "";
                    pndrController.state = "pndrListView";
//                    activeView.handleForegroundEvent();
                    activeView.isFromErrorView = true;
                    isNoActiveStation = true;
                    activeView.handleForegroundEvent();
                    break;
                }
                case 14: //E_SKIP_LIMIT_REACHED
                {
                    if( pndrController.state == "pndrTrackView")
                        activeView.handleSkipFailedEvent();                    
                    if( activeView.visible && !UIListener.IsRunningInBG())// modified by yongkyun.lee 2014-11-03 for : //leeyk1 OSD TEST
                    {
                        popup.showPopup(PopupIDPnd.POPUP_PANDORA_MAX_SKIP_LIMIT , false);// modified by esjang 2013.07.17
                    }

                    __LOG("E_SKIP_LIMIT_REACHED : title == " + InTrackInfo.title, LogSysID.LOW_LOG);
                    UIListener.UpdateTrackTitle(InTrackInfo.title);  //added by jyjeon 2014-03-18 for ITS 227377
                    break;
                }
                case 15: //E_STATION_LIMIT_REACHED
                {

                    if( pndrController.state === "pndrSearchView" ){
                        __LOG("hideWaitNote and show search screen " , LogSysID.LOW_LOG);
                        pndrController.showTrackView = false;
                        pndrController.activeView.hideWaitNote();
                    }
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_STATION_LIST_IS_FULL , false);
                    break;
                }
                case 16: //E_TRACK_RATING_FAILED
                {
                    // modified by esjang 2013.03.20 for ITS # 159179 'No Skip Available'
                    
                    //{ added by esjang 2013.05.07 for certification # 8.3 
                    activeView.handleRateFailedEvent();
                    //} added by esjang 2013.05.07 for certification # 8.3 
                    popup.showPopup(PopupIDPnd.POPUP_TRACK_RATING_FAILED,false);
                    break;
                }
                case 17: //E_STATION_DELETE_FAILED
                {
                    popup.showPopup(PopupIDPnd.POPUP_DELETION_STATION_FAILED,false);
                    break;
                }
                case 18: //E_SEARCH_EXTENDED_FAILED
                {
                    popup.showPopup(PopupIDPnd.POPUP_EXTENDED_SEARCH_FAILED,false);
                    break;
                }
                case 19: //E_SEARCH_SELECT_FAILED, 'Unable to Create Station'
                {
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_SEARCH_SELECT_FAILED , false); // added by esjang 2013.08.05 for ITS # 182670
                    break;
                }
                case 20: //E_BOOKMARK_FAILED
                {
                    popup.showPopup(PopupIDPnd.POPUP_BOOKMARK_FAILED ,false);
                    //{ added by esjang 2013.05.17 for certification test # 4.11, 4.12
                    
                    if(pndrController.state !== "pndrTrackView")
                    {  
                        pndrController.state = "pndrTrackView";
                        activeView.handleForegroundEvent();
                    }
                    //} added by esjang 2013.05.17 for certification test # 4.11, 4.12
                    break;
                }
                case 21: //E_TRACK_EXPLAIN_FAILED
                {
                    popup.showPopup(PopupIDPnd.POPUP_TRACK_EXPLAIN_REQUEST_FAILDE,false);

                    if(pndrController.state !== "pndrTrackView")
                    {
                        pndrController.state = "pndrTrackView";
                        activeView.handleForegroundEvent();
                    }
                    break;
                }
                case 22: //E_MEMORY
                {
                    popup.showPopup(PopupIDPnd.POPUP_REQUIRED_MEMORY_NOT_ALLOCATED,true);
                    break;
                }
                case 23: //E_INVALID_ARGUMENT
                {
                    popup.showPopup(PopupIDPnd.POPUP_ARGUMENT_PRESSED_INVALID,false);
                    break;
                }
                case 24: //E_REQUEST_TIMEOUT
                {
                    // modified by esjang 2013.03.20 for ITS # 159179 'No Skip Available'
                    if(pndrController.state != "pndrErrorView")
                        popup.showPopup(PopupIDPnd.POPUP_TIMEOUT_ERROR,true);
                    //UIListener.Disconnect();
                    break;
                }
                case 25: //E_UNKNOWN_ERROR
                {
                    //{ Modified by esjang 2013.03.22 for ISV #71262

                    __LOG("unknown error disconnect add error state", LogSysID.LOW_LOG);

                    pndrController.state = "pndrErrorView";
                    activeView.setTextChange(inPndrError); // add by cheolhwan 2013.12.04 for ITS 211672.
                    //UIListener.Disconnect();
                    UIListener.SessionTerminate();
                    //} Modified by esjang 2013.03.22 for ISV #71262

                    break;
                }
				//For below all ,we need localized string , For time being I have hardcoded
                case 26://E_SESSION_ALREADY_STARTED
                {
                    popup.showPopup(PopupIDPnd.POPUP_SESSION_ALREADY_EXIT,false);
                }
                break;
                case 27://E_NO_ACTIVE_SESSION
                {
                    //popup.showPopup("No active station",false);
                }
                break;
                case 28://E_APP_URL_NOT_SUPPORTED
                {
                    popup.showPopup(PopupIDPnd.POPUP_URL_NOT_SUPPORTED,false);
                }
                break;
                case 29://E_STATION_DOES_NOT_EXIST
                {
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_STATION_DOES_NOT_EXIST, false);                    
                    //currentActiveStationToken = 0;
                    //currentActiveStation = "";
                    if(pndrController.state !== "pndrListView")
                    {
                        pndrController.state = "pndrListView";
                        activeView.handleForegroundEvent();
                    }

                }
                break;
                case 30: //E_INSUFFICIENT_CONNECTIVITY
                {
                    __LOG("E_INSUFFICIENT_CONNECTIVITY, handle view change : state["+state+"]", LogSysID.LOW_LOG);
                    if(pndrController.state === "pndrListView" 
                        || pndrController.state === "pndrSearchView"
                        || pndrController.state === "pndrSearchDRView"
                        || pndrController.state === "pndrDrivingRestrictionView"
                        || pndrController.state === "pndrExplainView")
                    {
                        __LOG("if not in track view, then changes to track view", LogSysID.LOW_LOG);
                        pndrController.state = "pndrTrackView";
                        activeView.handleForegroundEvent();
                    }
                    //__LOG("esjang 131110 for when insufficent network popup on radio qml", LogSysID.LOW_LOG); 
                    //{ added by cheolhwan 2014-02-27. ITS 225019. Connecting view is displayed indefinitely when pandora entered during no network.
                    else if(pndrController.state === "pndrConnectingView")
                    {
                        //activeView.setChangeErrorText(1);
                        pndrController.state = "pndrErrorView";
                        activeView.setTextChange(inPndrError);
                        UIListener.SessionTerminate();
                    }
                    //} added by cheolhwan 2014-02-27. ITS 225019. Connecting view is displayed indefinitely when pandora entered during no network.
                    closePreviousPopup();
                    if(pndrController.state == "pndrTrackView"){
                        activeView.setTextChange(30);
                    }
                    isInsufficient = true;
                }		
                break;
                case 31://E_LICENSING_RESTRICTIONS
                {
                    __LOG("E_LICENSING_RESTRICTIONS, handle view change", LogSysID.LOW_LOG);
                    if(pndrController.state === "pndrListView" 
                        || pndrController.state === "pndrSearchView"
                        || pndrController.state === "pndrSearchDRView"
                        || pndrController.state === "pndrDrivingRestrictionView"
                        || pndrController.state === "pndrExplainView")
                    {
                        __LOG("if not in track view, then chnages to track view", LogSysID.LOW_LOG);
                        pndrController.state = "pndrTrackView";
                        activeView.handleForegroundEvent();
                    }
                    //{ added by cheolhwan 2014-02-27. ITS 225114. Connecting view is displayed indefinitely when pandora on HU was received LICENSING_RESTRICTIONS during connecting.
                    else if(pndrController.state === "pndrConnectingView")
                    {
                        pndrController.state = "pndrErrorView";
                        activeView.setTextChange(inPndrError);
                        UIListener.SessionTerminate();
                    }
                    //} added by cheolhwan 2014-02-27. ITS 225114. Connecting view is displayed indefinitely when pandora on HU was received LICENSING_RESTRICTIONS during connecting.
                    
                    closePreviousPopup();
                    if(pndrController.state == "pndrTrackView"){
                        activeView.setTextChange(31);
                    }
                    isInsufficient = true;                  
                    
                }
                break;
                case 32://E_INVALID_LOGIN
                {
                    //{ modified by yongkyun.lee 2014-08-27 for :  NOCR LOGIN
                    pndrController.state = "pndrErrorView";
                    activeView.setTextChange(inPndrError);
                    UIListener.SessionTerminate();
                    
                    closePreviousPopup();
                    isInsufficient = true;                      
                    //} modified by yongkyun.lee 2014-08-27 
                }
                break;
                case 33: //E_NOTICE_ERROR_MAINTENANCE
                {
                    __LOG("certi 0505", LogSysID.LOW_LOG);
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_MAINTENANCE, true);
                }
                default:
                {
                   //{ Modified by esjang 2013.03.22 for ISV #71262
                    if(pndrController.state != "pndrErrorView"){
                        pndrController.state = "pndrErrorView";
                        activeView.setTextChange(inPndrError); // add by cheolhwan 2013.12.04 for ITS 211672.
                        //UIListener.Disconnect();
                        UIListener.SessionTerminate();
                    }
                   //} Modified by esjang 2013.03.22 for ISV #71262
                    break;
                }
            }
        }

        // Hard key used for skipping the channel
        onHandleSkipEvent:
        {
            __LOG("popup is invisible , so do skip track", LogSysID.LOW_LOG);
            //active views wait indicator is false means no operation is
            //in progress in active view so we can go for skip operation
            //in any of the Track, List, search or explain view this operation is possible
            //not in error view, device selection view, connecting view,
            //startion entry error view
            //modified by jyjeon 2014-03-13 for ISV 98611
            if((/*pndrController.state === "pndrTrackView"
                || */pndrController.state === "pndrListView"
                || pndrController.state === "pndrExplainView"
                || pndrController.state === "pndrSearchDRView"
                || pndrController.state === "pndrDrivingRestrictionView"
                || pndrController.state === "pndrSearchView")
                && activeView.getWaitIndicatorStatus() === false)
            {
                pndrTrack.Skip();
                //__LOG("esjang 0426 skip and clear time for cluster radio qml", LogSysID.LOW_LOG);
                //if(InTrackInfo.allowSkip) // removed by jyjeon for allowSkip is Track attribute (if AD, allowSkip == false)
                pndrNotifier.ClearCluster(); // added by esjang 2013.04.26 for Clear TP Message
                UIListener.IfMute_SentAudioPass();
            }
            else if(pndrController.state === "pndrTrackView")
            {
                activeView.handleSkipEvent()
            }
            //modified by jyjeon 2014-03-13 for ISV 98611
        }

        onHandleRewindEvent:
        {
            //isDialUI = true;

            // if popup is visible for ex: no rewind available
            // popup will be closed and the rewind operation will be executed and again the
            // no rewind available popup displayed
            // if for ex: no skips remaining popup
            __LOG(" From Base onHandleRewindEvent : " + popup.errorType, LogSysID.LOW_LOG);
            if( PopupIDPnd.POPUP_PANDORA_REWIND_NOT_AVAILABLE != pndrController.pandoraPopupID )// modified by yongkyun.lee 2014-11-03 for : //leeyk1 OSD TEST
            {
                if(popupVisible )
                {
                    popup.hidePopup();
                    popup.visible = false;
                }

                //active views wait indicator is false means no operation is
                //in progress in active view so we can go for rewind operation
                //in any of the Track, List, search or explain view this operation is possible
                //not in error view, device selection view, connecting view,
                //startion entry error view
                if((pndrController.state === "pndrTrackView"
                        || pndrController.state === "pndrListView"
                        || pndrController.state === "pndrExplainView"
                        || pndrController.state === "pndrSearchDRView"
                        || pndrController.state === "pndrDrivingRestrictionView"
                        || pndrController.state === "pndrSearchView")
                        && activeView.getWaitIndicatorStatus() === false
                        && activeView.visible === true)
                {
                    popup.showPopup(PopupIDPnd.POPUP_PANDORA_REWIND_NOT_AVAILABLE, false);
                    popup.errorType = -1;
                }
            }
        }
	
        onBackKeyPressed:
        {
            __LOG("onBackKeyPressed state : " + pndrController.state, LogSysID.LOW_LOG);
            // It is CCP Back Key so the UI must Switch to DialUI.
            isDialUI = true;

            // if popup is visible that should be hidden on back key. else the back key event
            // should be executed for activeScreen
            if(popupVisible)
            {
                popup.hidePopup();
                popup.visible = false;
                // added by esjang 2013.08.14 for ITS #183734
                if( ( pndrController.state === "pndrExplainView") 
                    && (isDRSPopup === true) )
                {
                    __LOG("close popup and go to track view", LogSysID.LOW_LOG);
                    pndrController.state = "pndrTrackView";
                    activeView.handleForegroundEvent(); 
                    isDRSPopup = false;
                }
                else if( ( pndrController.state === "pndrSearchView") 
                    && (isDRSPopup === true) )
                {
                    __LOG("close popup and go to list view", LogSysID.LOW_LOG);
                    pndrController.state = "pndrListView";
                    activeView.handleForegroundEvent(); 
                    isDRSPopup = false;
                }                
            }
            else if(noStationPopupVisible)
            {
                noStationPopup.hidePopup();
            }
            else
            {
                if(activeView === pndrTrackViewLoader.item)
                {
                    __LOG("onBackKeyPressed: Track", LogSysID.LOW_LOG);

                    if(activeView.isOptionsMenuVisible)
                    {
                        activeView.hideOptionsMenu();
                        return;
                    }
                    else if( activeView.closeToastPopup())
                    {
                        return;
                    }
                }
                else if(activeView === pndrListViewLoader.item )
                {
                    __LOG("onBackKeyPressed: List", LogSysID.LOW_LOG);
                    if(activeView.isOptionsMenuVisible)
                    {
                        activeView.hideSubMenu();
                        return;
                    }
                }
                else if(activeView === pndrStationEntryErrorViewLoader.item )
                {

                    if(activeView.isOptionsMenuVisible)
                    {
                        activeView.hideOptionsMenu();
                        return;
                    }
                }

                activeView.handleBackRequest(true); //modified by esjang 2013.06.21 for Touch BackKey
            }
        }

        //{ modified by yongkyun.lee 2014-04-15 for : ITS 234555
        onPlayCommandFromVR:
        {
             if ( activeView.getWaitIndicatorStatus() == false  )
             {
                 if(inPayLoad === 1)
                 {
                         pndrTrack.Play();
                 }
                 else
                 {
                         pndrTrack.Pause();
                 }
             }
        }

        onRatingCommandFromVR:
        {
            
         //if(pndrTrack.IsNullTrackInof() )
         //   return;
         if (  activeView.getWaitIndicatorStatus() == false && InTrackInfo.allowRating === true)
         {                
                if( inPayLoad === 1 )
                {
                    pndrTrack.ThumbUp();
                }
                else
                {
                    pndrTrack.ThumbDown();
                }
            }
        }
        //} modified by yongkyun.lee 2014-04-15 

        onShuffleCommandFromVR:
        {
//            Only in these many views "shuffle" is possible .
//            That to if no request is going on .
//            Multiple request is not supported in pandora state handler.
            if( (pndrController.state === "pndrTrackView"
                || pndrController.state === "pndrListView"
                || pndrController.state === "pndrExplainView"
                || pndrController.state === "pndrSearchDRView"
                || pndrController.state === "pndrDrivingRestrictionView"
                || pndrController.state === "pndrSearchView")
                && activeView.getWaitIndicatorStatus() === false)
            {               
                pndrStationList.PlayShuffle();
                gotoTrackView();//{ modified by yongkyun.lee 2014-12-30 for : ITS 255279
            }
        }

        //{ added by esjang 2013.01.28 for No CR, Updated UX
        onAvModeChanged:
        {
            __LOG("onAVModeChanged deviceInUse = " + deviceInUse + " state = " + pndrController.state
                  + " visible = " + activeView.visible, LogSysID.LOW_LOG);
            if(deviceInUse && pndrController.state !== "")
            {                
                if(activeView.visible !== true)
                {                    
                    if(isNoStationExists || isNoActiveStation)
                    {
                        __LOG("onAVModeChanged: Previous screen was either No Station or staion does not exist ", LogSysID.LOW_LOG);

//                        __LOG(" isNoStationExists : " + isNoStationExists, LogSysID.LOW_LOG);
//                        __LOG(" isNoActiveStation : " + isNoActiveStation, LogSysID.LOW_LOG);
                    }
                    else if( (pndrController.state === "pndrListView"
                        || pndrController.state === "pndrExplainView"
                        || pndrController.state === "pndrSearchDRView"
                        || pndrController.state === "pndrDrivingRestrictionView"
                        || pndrController.state === "pndrSearchView")
                        && activeView.getWaitIndicatorStatus() === false)
                    {
                       // __LOG("onAVModeChanged: Track view will be activated", LogSysID.LOW_LOG);
                        pndrController.state = "pndrTrackView";
                        activeView.handleForegroundEvent();
                        activeView.visible = false; // for safe side
                        if(isDRSPopup)
                            popup.hidePopup();
                    }
                    else
                    {

                    }
                }
            }
        }
//} added by esjang 2013.01.28 for No CR, Updated UX
        onSignalJogNavigation:
        {
           // __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status, LogSysID.LOW_LOG);
            __LOG("popup.visible : " + popup.visible+ " noStationPopup.visible:"+noStationPopup.visible + " isInsufficient : " + isInsufficient, LogSysID.LOW_LOG);
            //if(!popup.visible && (!myToastPopup.visible)) // modified by esjang 2013.11.08 for audit issue network popup 
            //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
            if(!popup.visible && !noStationPopup.visible ) // modified by esjang 2013.11.08 for audit issue network popup // modified by cheolhwan 2013.12.02. for ITS 210787.
            //if(!popup.visible && !noStationPopup.visible && (!isInsufficient)) // modified by esjang 2013.11.08 for audit issue network popup // modified by cheolhwan 2013.12.02. for ITS 210787.
            //} modified by yongkyun.lee 2014-03-11 
            {
                if( pndrController.state != "" && activeView != null && activeView.isJogListenState())
                {
                    //__LOG("activeView.handlejogkey -> arrow : " + arrow + " , status : "+ status + ", isjogAccepted : " +isjogAccepted, LogSysID.LOW_LOG);

                    if(isjogAccepted)
                    {
                        //send to active view to handle
                        activeView.handleJogKey(arrow , status);
                    }
                }

                isjogAccepted = true;
            }
            else
            {
                //__LOG(" Jog key handled on Pop up ", LogSysID.LOW_LOG);
                //{ added by cheolhwan 2014-02-50. ITS 227754. To prevent settting to "false" isJogAccepted by Jog Center ReleasedKey on Popup and Jog RightLongKey released.
                if(status === UIListenerEnum.KEY_STATUS_RELEASED/*1002*/)
                    isjogAccepted = true;
                else
                //} added by cheolhwan 2014-02-50. ITS 227754.
                    isjogAccepted = false;
            }

            return true;
        }
        // added by esjang 2013.08.14 for ITS #183734 
        onTickerChanged:
        {
            __LOG("esjang 0813 ticker changed ", LogSysID.LOW_LOG);
            __LOG("esjang 0813  current state : " + pndrController.state, LogSysID.LOW_LOG);
            //__LOG("esjang 0813 activeView.visible: " + activeView.visible , LogSysID.LOW_LOG);            
            __LOG("esjang 0813 getWaitIndicator : " + activeView.getWaitIndicatorStatus() , LogSysID.LOW_LOG);

            //{ add by cheolhwan 2013.12.02. add "pndrStationEntryErrorView" condition for ITS 210787.
            if((pndrController.state === "pndrTrackView" 
                || pndrController.state === "pndrSearchView"
                || pndrController.state === "pndrSearchDRView"
                || pndrController.state === "pndrListView"
                || pndrController.state === "pndrExplainView"
                || pndrController.state === "pndrDrivingRestrictionView"
                || pndrController.state === "pndrStationEntryErrorView")
                && activeView.getWaitIndicatorStatus() === false )
            {
                    //__LOG("esjang 0813 ticker changed 2", LogSysID.LOW_LOG);
                    __LOG("esjang 0813  inScrollingTicker : " + inScrollingTicker, LogSysID.LOW_LOG);
                    __LOG("esjang 0813  isDRSPopup : " + isDRSPopup, LogSysID.LOW_LOG);

                    if( (inScrollingTicker === false) && (isDRSPopup === false) 
                        && ( pndrController.state !== "pndrListView" && pndrController.state !== "pndrTrackView" ) )
                    {
                        //__LOG("ticker changed show drs popup", LogSysID.LOW_LOG);

                        //showing drs popup

                        if(pndrController.state === "pndrExplainView"){

                            pndrController.state = "pndrDrivingRestrictionView";
                            UIListener.CloseSystemPopup();
                            popup.hidePopup();
                            popup.visible = false;
                        }else
                            if(pndrController.state === "pndrSearchView"){

                                pndrController.state = "pndrSearchDRView";
                                UIListener.CloseSystemPopup();
                                popup.hidePopup();
                                popup.visible = false;
                                activeView.handleForegroundEvent();

                            }else if(pndrController.state != "pndrDrivingRestrictionView"){
                                if(pndrController.state === "pndrSearchView") UIListener.SendTouchCleanUpForApps(); //added by jyjeon 2014-02-27 for  ITS 226165
                                popup.showPopup(PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION, false); // modified by esjang 2013.07.31 for ITS #182051

                        }

                        isDRSPopup = true;
                    }
                    else if( (inScrollingTicker === true) && (isDRSPopup === true) )
                    {
                        //__LOG("esjang 0813 ticker changed close drs popup", LogSysID.LOW_LOG);

                        if(pndrController.state === "pndrDrivingRestrictionView"){

                            pndrController.state = "pndrExplainView";
                            UIListener.CloseSystemPopup();
                            popup.hidePopup();
                            popup.visible = false;


                        }else if(pndrController.state === "pndrSearchDRView"){

                                pndrController.state = "pndrSearchView";
                                pndrSearchViewLoader.source = "DHAVN_PandoraSearchView.qml"
                            UIListener.CloseSystemPopup();
                            popup.hidePopup();
                            popup.visible = false;
                            activeView.handleForegroundEvent();

                            }else if(pndrController.state != "pndrExplainView"){
                                //close popup
                                if(popupVisible && PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION === pndrController.pandoraPopupID) //modified by cheolhwan 2014-05-14. ITS 237346.
                                {
                                    popup.hidePopup();
                                    popup.visible = false;
                                }
                            }


                        isDRSPopup = false; //added by cheolhwan 2013.11.20. for ITS 208837.			
                    }
            } else if((pndrController.state === "pndrSearchView"|| pndrController.state === "pndrSearchDRView" || pndrController.state === "pndrExplainView" || pndrController.state === "pndrDrivingRestrictionView")
                && activeView.getWaitIndicatorStatus() === true )  //{ added by cheolhwan 2013.11.18. for ITS 209342. // modified by cheolhwan 2014-03-03. ITS 227915. added condition for "pndrExplainView"
            {
                //__LOG(" ticker changed 2", LogSysID.LOW_LOG);
                //__LOG(" inScrollingTicker : " + inScrollingTicker, LogSysID.LOW_LOG);
                //__LOG(" isDRSPopup : " + isDRSPopup, LogSysID.LOW_LOG);

                if( (inScrollingTicker === false) && (isDRSPopup === false))
                {
                    //showing drs popup

                    if(pndrController.state === "pndrExplainView"){
                        pndrController.state = "pndrDrivingRestrictionView";
                    }else{
                        if(pndrController.state === "pndrSearchView") {

                            UIListener.SendTouchCleanUpForApps(); //added by jyjeon 2014-02-27 for  ITS 226165
                            pndrController.state = "pndrSearchDRView";
                            activeView.handleForegroundEvent();

                        }

                    }

                    //popup.showPopup(PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION , false);

                    isDRSPopup = true;
                }
                else if( (inScrollingTicker === true) && (isDRSPopup === true) )
                {

                    if(pndrController.state === "pndrDrivingRestrictionView"){
                        pndrController.state = "pndrExplainView";
                    }else if(pndrController.state === "pndrSearchDRView"){
                        pndrController.state = "pndrSearchView";
                        pndrSearchViewLoader.source = "DHAVN_PandoraSearchView.qml"
                    activeView.handleForegroundEvent();

                    } else{
                        //close popup
                        if(popupVisible && PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION === pndrController.pandoraPopupID) //modified by cheolhwan 2014-05-14. ITS 237346.
                        {
                            popup.hidePopup();
                            popup.visible = false;
                        }
                    }
                    isDRSPopup = false; //added by jyjeon 2014-03-14 for ITS 229391
                }
            }
        }

        //{ modified by yongkyun.lee 2014-04-06 for : ITS 233689
        onShowPopupID:
        {
            if( popupVisible && pndrController.pandoraPopupID == PopupIDPnd.POPUP_PANDORA_CALLING_STATE )
                return;

            if( (pndrController.state === "pndrSearchView" || 
                 pndrController.state === "pndrSearchDRView" ||
                 pndrController.state === "pndrTrackView" || 
                 pndrController.state === "pndrListView") &&
                 activeView.getWaitIndicatorStatus() === false)
            {
                if(popupVisible)
                {
                    popup.hidePopup();
                }
                activeView.manageFocusOnPopUp(true);
                popup.showPopup( popupID , false);
            }
        }
        //} modified by yongkyun.lee 2014-04-06 

        //{ added by cheolhwan 2013.11.18. for ITS 209342.
        onCallingPopup:
        {
            __LOG("CallingPopup", LogSysID.LOW_LOG);
            //{ modified by yongkyun.lee 2014-03-14 for :  ITS 229248
            if( popupVisible && pndrController.pandoraPopupID == PopupIDPnd.POPUP_PANDORA_CALLING_STATE )
                return;
            if((pndrController.state === "pndrTrackView" || pndrController.state === "pndrListView" || pndrController.state === "pndrExplainView" || pndrController.state === "pndrDrivingRestrictionView")  //add wonseok.heo for ITS 255745
            //if((pndrController.state === "pndrTrackView")
            //} modified by yongkyun.lee 2014-03-14 
                    && activeView.getWaitIndicatorStatus() === false)
            {
                if(popupVisible)
                {
                    popup.hidePopup();
                }
                activeView.manageFocusOnPopUp(true); // added by jyjeon 2014-02-13 for ITS 224934
                popup.showPopup(PopupIDPnd.POPUP_PANDORA_CALLING_STATE , false);
            }
        }
        //} added by cheolhwan 2013.11.18. for ITS 209342.
        //{ modified by yongkyun.lee 2014-09-04 for : ITS 247991
        onPopupClose:
        {
            closePreviousPopup();
        }
        //} modified by yongkyun.lee 2014-09-04 
    }

    Connections{
        target: pndrTrack
        onTrackUpdated:
        {
            __LOG(" TrackUpdated State = " + pndrController.state + " TrackToken(m_nTrackToken) = " + inTrackToken +
                   " Call in Progress = " + UIListener.IsCalling() + " Show trackView = " +showTrackView, LogSysID.LOW_LOG);
            //{ added by esjang 2013.11.08 for audit issue
            if(isInsufficient == true)
            {
                __LOG("ontrack updated radio.qml, isInsufficient : true " , LogSysID.LOW_LOG);
                return;
                //isInsufficient = false;
            }
            //} added by esjang 2013.11.08 for audit issue
//            if(myToastPopup.visible)
//            {
//                myToastPopup.visible = false;
//            }

            // { added by wonseok.heo for ITS 258177
             if(activeView.isFromErrorView == true){
                 activeView.isFromErrorView = false;
                 isNoStationExists = false;
                 isNoActiveStation = false;
             }
              // }  added by wonseok.heo for ITS 258177
            //{ added by cheolhwan 2014-03-06. When BT Pandora enter, if inTrackToken is 0, connetting view is displayed indefinitely or paused on trackview.
            if(pndrController.state === "pndrConnectingView"
                    && pndrTrack.GetCurrentStationToken() === 0)
            {
                __LOG("onTrackUpdated: Current StationToken is 0", LogSysID.LOW_LOG);
                currentActiveStationToken = 0;
                currentActiveStation = "";
                 pndrController.state = "pndrStationEntryErrorView"; //added by wonseok.heo for ITS 258177
//                pndrController.state = "pndrListView";
                activeView.isFromErrorView = true;
                isNoActiveStation = true;
                pndrStationList.CancelStationArtRequest(); // To execute m_PendingStationArtList.clear()
                activeView.handleForegroundEvent();
            }
            //} added by cheolhwan 2014-03-06. When BT Pandora enter, if inTrackToken is 0, connetting view is displayed indefinitely or paused on trackview.
             
            //Means TrackUpdated Signal came as a respose of Connect request
            //Stop the timer and switch the view to TrackView , playing on FG
            if(pndrTrackViewLoader.item === null && showTrackView)
            {
               // __LOG("View Switching to pndrTrackView track token = " + inTrackToken, LogSysID.LOW_LOG);
                //activeView.handleStopConnectEvent();

                if(inTrackToken > 0)
                {
                    if(pndrController.state === "pndrConnectingView")
                    {
                        if(initialStateofTrackView === "trackStatePaused")
                        {
                            if(!UIListener.IsCalling()){
                                __LOG("Auto Play Requested", LogSysID.LOW_LOG);
                                pndrTrack.Play();
                            }
                        }
                        else
                        {
                            if(UIListener.IsCalling() || UIListener.IsAVModeChanged())
                            {
                                pndrTrack.Pause();
                            }
                        }

                        pndrController.state = "pndrTrackView";
                    }
                    else if(pndrController.state === "pndrSearchView")
                    {
                        pndrController.state = "pndrTrackView";
                    }
                }
                if(activeView != null && pndrController.state == "pndrTrackView"
                        && inTrackToken > 0)
                {
                    activeView.handleForegroundEvent();
                }
            }
            // modified by esjang 2013.08.21 for BT phone call
            if(UIListener.IsCalling())
            {
                // Only for 1st it will come , After that it should not come while call in progress.
                UIListener.SetPlayState(1);
                if(pndrTrack.TrackStatus() == 1){
                    pndrTrack.Pause();
                }
            }
             if( ( pndrController.state == "pndrListView" ||
                  pndrController.state == "pndrSearchView" ||
                  pndrController.state == "pndrSearchDRView" ||
                  pndrController.state == "pndrDrivingRestrictionView" ||
                  pndrController.state == "pndrExplainView" )
                     && inTrackToken > 0 )
             {
                pndrTrack.RequestTrackInfo();
             }
        }
        onPlayStarted:
        {
            UIListener.SetShareDataProvider(true); //added by jyjeon 2014-03-06 for VR
            initialStateofTrackView = "trackStatePlaying";
        }

        onPauseDone:
        {
            UIListener.SetShareDataProvider(false); //added by jyjeon 2014-03-06 for VR
            initialStateofTrackView = "trackStatePaused";
        }
    }

    Connections
    {
        target:pndrStationList
        onActiveStationToken:{
            currentActiveStationToken = inActiveStationToken;
            isNoStationExists = false;
            isNoActiveStation = false;
            //{ modified by yongkyun.lee 2014-10-15 for : ITS 250271
            if(pndrController.state === "pndrListView") 
                activeView.checkCurrentstation()
            //} modified by yongkyun.lee 2014-10-15 
        }

        //{ modified by yongkyun.lee 2014-09-01 for : Pandora 4.25 TEST
        onToastLoadingPopup:
        {
            __LOG("onToastLoadingPopup :" + pndrController.state , LogSysID.LOW_LOG);
            if(pndrController.state === "pndrTrackView") 
                activeView.toastLoadingPopup();
            //myToastPopup.show(QT_TR_NOOP("STR_PANDORA_LOADING") , false)
        }
        //{ modified by yongkyun.lee 2014-09-01
    }
    /***************************************************************************/
    /**************************** Pandora Qt connections END ****************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/

    function __LOG( textLog , level)
    {
       logString = "PanodraRadio.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    //{ modified by yongkyun.lee 2014-04-30 for :  ITS 236250
    function sendTouchCleanUpForApps( )
    {
          UIListener.sendTouchCleanUpForApps() //added by suilyou ITS 0191448
    }
    //} modified by yongkyun.lee 2014-04-30 
    
    function initializePandora()
    {
        __LOG("initializePandora:", LogSysID.LOW_LOG);
        isInsufficient = false;

       // var deviceInfo = UIListener.GetDeviceStatus();

       // __LOG("deviceInfo:" + deviceInfo.length, LogSysID.LOW_LOG);

/*        if(deviceInfo.length > 1)
        {
            pndrController.state = "pndrConnectedDeviceListView";
            //{ modified for CR 14370 by Vijayakumar K
            //UIListener.SetPandoraStateActive();
            //} modified for CR 14370 by Vijayakumar K
        }
        else*/
//        if(deviceInfo.length >= 1)
//        {
            currentDeviceIndex = 0;
            pndrController.state = "pndrConnectingView";
            UIListener.Connect();
//        }
//        else
//        {
//            __LOG("No phone:", LogSysID.LOW_LOG);

//            popup.showPopup("No Phone is Connected.",false); // modified by esjang 2013.03.23 for ISV # 73220
//        }
    }

    //{ modified by yongkyun.lee 2014-12-30 for : ITS 255279
    function gotoTrackView()
    {
        if(pndrController.state != "pndrTrackView" )
        {
            pndrController.state = "pndrTrackView"                            
            activeView.handleForegroundEvent();        
        }
    }
    //} modified by yongkyun.lee 2014-12-30 

    //function exitApplication()
    function exitApplication( isJogDial)
    {
        //pndrController.state = "";
        //UIListener.ExitApplication();
	    UIListener.ExitApplication(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
    }

    //function sendAppToBackground()
    function sendAppToBackground( isJogDial)  
    {
        //UIListener.HandleBackKey();
	UIListener.HandleBackKey(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
    }
    //{ added by esjang 2013.11.07 close previous popup for audit issue
    function closePreviousPopup()
    {
        __LOG("closePreviousPopup Radio.qml", LogSysID.LOW_LOG);
        if(popup.visible == true)
        {
            __LOG("close previous popup " , LogSysID.LOW_LOG);
            popup.hidePopup();
        }

        //{ add by cheolhwan 2013.12.02. for ITS 210787.
        if(noStationPopupVisible)
        {
            __LOG("close previous noStationPopup ", LogSysID.LOW_LOG );
            noStationPopup.hidePopup();
        }
        //} add by cheolhwan 2013.12.02. for ITS 210787.

        //{ add by cheolhwan 2013-12-18. ITS 216037.
        if(pndrController.state === "pndrTrackView" || pndrController.state === "pndrListView")// modified by yongkyun.lee 2014-08-22 for : ITS 246133
        //} modified by yongkyun.lee 2014-08-22 
        {
            __LOG("[BCH_LOG] close previous ToastPopup " , LogSysID.LOW_LOG);
            activeView.closeToastPopup();
        }
        //} add by cheolhwan 2013-12-18. ITS 216037.
    }
    //} added by esjang 2013.11.07 close previous popup for audit issue

    /***************************************************************************/
    /**************************** Private functions END **********************/
    /***************************************************************************/


    POPUPWIDGET.PopUpText
    {
        id:popup
        z: 1000
        y: 0
        icon_title: EPopUp.WARNING_ICON
        visible: false
        message: errorModel
        buttons: /*entryerror ? noStation :*/btnmodel  // modified by cheolhwan 2013.12.02. for ITS 210787.
        focus_visible: /*isDialUI &&*/ popup.visible
        property bool showErrorView;
        property bool entryerror : false
        property int errorType: 0 // It can be used for each error type , belongs to 0 to n
        property string popUpString: ""

        function showPopup(text, errorView)
        {
            entryerror = false;
            popup.showErrorView = errorView;
            //{ modified by yongkyun.lee 2014-02-18 for : 
            switch(text)
            {
                case PopupIDPnd.POPUP_PANDORA_CALLING_STATE : 
                    popUpString= qsTranslate("main","STR_PANDORA_CALLING_STATE")
                    break;
                case PopupIDPnd.POPUP_PANDORA_CANNOT_BE_MANIPULATED : 
                    popUpString= qsTranslate("main","STR_PANDORA_CANNOT_BE_MANIPULATED")
                    break;
                case PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION : 
                    popUpString= qsTranslate("main","STR_PANDORA_DRIVING_RESTRICTION")
                    break;
                case PopupIDPnd.POPUP_PANDORA_INCOMPATIABLE_VERSION : 
                    popUpString= qsTranslate("main","STR_PANDORA_INCOMPATIABLE_VERSION")
                    break;
                case PopupIDPnd.POPUP_PANDORA_LOG_IN : 
                    popUpString= qsTranslate("main","STR_PANDORA_PLEASE_LOGIN") // modified by wonseok.heo for Error Messages 20141002 qsTranslate("main","STR_PANDORA_LOG_IN")
                    break;
                case PopupIDPnd.POPUP_PANDORA_MAINTENANCE : 
                    popUpString= qsTranslate("main","STR_PANDORA_MAINTENANCE")
                    break;
                case PopupIDPnd.POPUP_PANDORA_MAX_SKIP_LIMIT : 
                    popUpString= qsTranslate("main","STR_PANDORA_MAX_SKIP_LIMIT")
                    break;
                case PopupIDPnd.POPUP_PANDORA_REWIND_NOT_AVAILABLE : 
                    popUpString= qsTranslate("main","STR_PANDORA_REWIND_NOT_AVAILABLE")
                    break;
                case PopupIDPnd.POPUP_PANDORA_SEARCH_SELECT_FAILED : 
                    popUpString= qsTranslate("main","STR_PANDORA_SEARCH_SELECT_FAILED")
                    break;
                case PopupIDPnd.POPUP_PANDORA_STATION_DOES_NOT_EXIST : 
                    popUpString=  qsTranslate("main", "STR_PANDORA_STATION_REMOVED_NOT_EXIST") // modified by wonseok.heo for Error Messages 20141002 qsTranslate("main","STR_PANDORA_STATION_DOES_NOT_EXIST")
                    break;
                case PopupIDPnd.POPUP_PANDORA_STATION_LIST_IS_FULL : 
                    popUpString= qsTranslate("main","STR_PANDORA_STATION_LIST_IS_FULL")
                    break;
                case PopupIDPnd.POPUP_RECEIVING_STATIONS : 
                    popUpString= qsTranslate("main","STR_RECEIVING_STATIONS")                   
                    break;
                case PopupIDPnd.POPUP_ARGUMENT_PRESSED_INVALID :                    
                    popUpString=    "Argument Passed are invalid."                   
                    break;
                case PopupIDPnd.POPUP_BOOKMARK_FAILED : 
                    popUpString= qsTranslate("main","STR_PANDORA_UNABLE_BOOKMARK") // modified by wonseok.heo for Error Messages 20141002 modified by wonseok.heo NOCR 20140320
                    //popUpString=    "Bookmark has failed."
                    break;
                case PopupIDPnd.POPUP_DELETION_STATION_FAILED : 
                    popUpString=    "Deletion of the station has failed."                   
                    break;
                case PopupIDPnd.POPUP_EMPTY_INPUT_CRITERIA : 
                    popUpString=    "Empty OR doesn't follow the input criteria."                   
                    break;
                case PopupIDPnd.POPUP_EXTENDED_SEARCH_FAILED : 
                    popUpString=    "Extended search has failed."                   
                    break;
                case PopupIDPnd.POPUP_TOKEN_STATION_NOT_VALID : 
                    popUpString=    qsTranslate("main", "STR_PANDORA_STATION_REMOVED_NOT_EXIST") // modified by wonseok.heo for Error Messages 20141002 "Given token for station is not valid."
                    break;
                case PopupIDPnd.POPUP_INITALIZATION_FAILED : 
                    popUpString= qsTranslate("main","STR_PANDORA_NETWORK_ERROR") //modified by wonseok.heo NOCR 20140320
                    //popUpString=    "Initialization failed."
                    break;
                case PopupIDPnd.POPUP_NO_PHONE_CONNECTED : 
                    popUpString=    qsTranslate("main","STR_PANDORA_ERROR_POPUP1") //modified by wonseok.heo ITS 228603 2014.03.14
                    break;
                case PopupIDPnd.POPUP_PANDORA_DISCONNECTED : 
                    popUpString=    "Pandora disconnected.\nPlease check your mobile device"                   
                    break;
                case PopupIDPnd.POPUP_REQUESTED_STATION_RANGE_NOT_VALID : 
                    popUpString=   qsTranslate("main", "STR_PANDORA_STATION_REMOVED_NOT_EXIST") // modified by wonseok.heo for Error Messages 20141002 "Requested Station list range is not valid."
                    break;
                case PopupIDPnd.POPUP_REQUIRED_MEMORY_NOT_ALLOCATED : 
                    popUpString=    "Required Memory not allocated."                   
                    break;
                case PopupIDPnd.POPUP_SESSION_ALREADY_EXIT : 
                    popUpString=    qsTranslate("main","STR_PANDORA_ENDING_SERVICE") // modified by wonseok.heo for Error Messages 20141002 "Session already exit"
                    break;
                case PopupIDPnd.POPUP_TIMEOUT_ERROR : 
                    popUpString= qsTranslate("main","STR_PANDORA_NETWORK_ERROR") //modified by wonseok.heo NOCR 20140320
                    //popUpString=    "Timeout error."
                    break;
                case PopupIDPnd.POPUP_TRACK_EXPLAIN_REQUEST_FAILDE : 
                    popUpString= qsTranslate("main","STR_PANDORA_TRACK_INFORMATION_UNAVAILABLE") // modified by wonseok.heo for Error Messages 20141002 modified by wonseok.heo NOCR 20140320
                    //popUpString=    "Track Explain Request has failed."
                    break;
                case PopupIDPnd.POPUP_TRACK_RATING_FAILED : 
                    popUpString= qsTranslate("main","STR_PANDORA_UNABLE_TO_SAVE_THUMB_RATING") // modified by wonseok.heo for Error Messages 20141002 modified by wonseok.heo NOCR 20140320
                    //popUpString=    "Track Rating has failed."
                    break;
                case PopupIDPnd.POPUP_URL_NOT_SUPPORTED : 
                    popUpString= qsTranslate("main","STR_PANDORA_NETWORK_ERROR") //modified by wonseok.heo NOCR 20140320
                    //popUpString=    "URL not supported"
                    break;       
                default :
                    return;
            }
            //} modified by yongkyun.lee 2014-02-18 
            
            if(!visible)
            {
                __LOG("showPopup on radio qml", LogSysID.LOW_LOG);
                //{ modified by yongkyun.lee 2014-05-27 for : ITS 238336
                pndrController.pandoraPopupID = text             
                if(UIListener.IsSystemPopupVisible()) //added by esjang 2013.08.07 for ITS #182095
                {
                    UIListener.CloseSystemPopup();
                    afterLocalPopup = true;
                    return;                   
                }
                else
                {
                    afterLocalPopup = false;
                }
                //} modified by yongkyun.lee 2014-05-27 
                closePreviousPopup(); //added by esjang 2013.11.07 close popup for audit issue

                btnmodel.clear();//{ modified by yongkyun.lee 2014-02-20 for : ITS 225866

                //if(UIListener.IsSystemPopupVisible())//{ removed by yongkyun.lee 2014-05-27 for : ITS 238336
                //{
                //    UIListener.CloseSystemPopup();
                //}
                //pndrController.pandoraPopupID = text   //{ removed by yongkyun.lee 2014-05-27          
                errorModel.set(0,{msg:popUpString})
                //{ modified by yongkyun.lee 2014-02-20 for : ITS 225866
                //btnmodel.set(0,{msg:qsTranslate("main","STR_PANDORA_ERROR_VIEW_OK")}) // added by cheolhwan 2014-01-27. ITS 222286.
                btnmodel.append( { "msg": QT_TR_NOOP("STR_PANDORA_ERROR_VIEW_OK"), "btn_id": "OK" } );
                //} modified by yongkyun.lee 2014-02-20 
                visible = true;
                //functionalTimer.start(); // deleted by esjang 2013.05.21 for ux issues 
            }
            //{ added by cheolhwan 2014-05-14. ITS 237346.
            else
            {
                UIListener.printQMLLog("showPopup : else");
                //{ modified by yongkyun.lee 2014-05-27 for : ITS 238336
                pndrController.pandoraPopupID = text             
                if(UIListener.IsSystemPopupVisible())
                {
                    UIListener.CloseSystemPopup();
                    afterLocalPopup = true;
                    return;                   
                }
                else
                {
                    afterLocalPopup = false;
                }
                //} modified by yongkyun.lee 2014-05-27 
                btnmodel.clear();

                //if(UIListener.IsSystemPopupVisible())//{ removed by yongkyun.lee 2014-05-27 for : ITS 238336
                //{
                //    UIListener.CloseSystemPopup();
                //}
                //pndrController.pandoraPopupID = text //{ removed by yongkyun.lee 2014-05-27             
                errorModel.set(0,{msg:popUpString})
                btnmodel.append( { "msg": QT_TR_NOOP("STR_PANDORA_ERROR_VIEW_OK"), "btn_id": "OK" } );
            }
            //} added by cheolhwan 2014-05-14. ITS 237346.
        }
        
        function hidePopup()
        {
            popup.visible = false;
            functionalTimer.stop();
            popup.showErrorView = false;
            popup.focus_visible = false;
            pndrController.pandoraPopupID = PopupIDPnd.POPUP_PANDORA_UNDEFINED;
            activeView.manageFocusOnPopUp(false); // added by jyjeon 2014-02-13 for ITS 224934
        }

        onBtnClicked:
        {            

            if( popup.visible === true)
            {
                switch ( btnId )
                {
                    case "OK":
                    {
                        functionalTimer.stop();
                        //{ modified by yongkyun.lee 2014-06-10 for : ITS 239774
                        if(pndrController.pandoraPopupID == PopupIDPnd.POPUP_PANDORA_DRIVING_RESTRICTION)
                              isDRSPopupShow = false;
                        //} modified by yongkyun.lee 2014-06-10 
                        // added by esjang 2013.08.14 for ITS #183734
                        if( ( pndrController.state === "pndrExplainView")
                             && (isDRSPopup === true)  )
                        {                           
                                pndrController.state = "pndrTrackView"                            
                                activeView.handleForegroundEvent();                        
                        }
                        //{ modified by yongkyun.lee 2014-08-22 for :  ITS 246133
                        else if( ( pndrController.state === "pndrListView" )
                               &&( pndrController.pandoraPopupID === PopupIDPnd.POPUP_REQUESTED_STATION_RANGE_NOT_VALID)  )
                        {
                            pndrController.state = "pndrTrackView"                            
                            activeView.handleForegroundEvent();   
                            pndrStationList.ClearCurrentRequest();
                        }
                        //} modified by yongkyun.lee 2014-08-22 
                        else if( ( pndrController.state === "pndrSearchView" )
                             && (isDRSPopup === true || pndrController.pandoraPopupID === PopupIDPnd.POPUP_PANDORA_STATION_LIST_IS_FULL )  ) //modified by yongkyun.lee 2014-05-13 for : ITS 236514
                        {                           

                            if(isNoStationExists)
                                pndrController.state = "pndrStationEntryErrorView"
                            else
                                pndrController.state = "pndrListView"

                                activeView.handleForegroundEvent();                        
                        }
                        else if(popup.showErrorView  && pndrController.state !== "pndrErrorView")
                        {
                            if(popup.visible === true){
                                pndrController.state = "pndrErrorView"
                                activeView.setTextChange(activeView.errorIndex); // add by cheolhwan 2013.12.04 for ITS 211672.
                                UIListener.Disconnect(); // modified by cheolhwan 2014-03-29. Disconnectting the device must move from MiddleWare to PandoraApp. // modified by cheolhwan 2014-0429. disconnect()->Disconnect()
                            }
                        }
                        else if( ( pndrController.state === "pndrStationEntryErrorView")
                             && (isDRSPopup === true)  )
                        {                           
                            pndrController.state = "pndrStationEntryErrorView"                            
                            //activeView.handleForegroundEvent();                        
                        }

                        popup.visible = false;
                        popup.hidePopup();  // added by jyjeon 2014-03-13 for popup ID
                        isDRSPopup = false; // added by esjang 2013.08.14 for ITS #183734
                    }
                    break;
                }
            }
        }

        onVisibleChanged:
        {
            errorType = 0;
            //if(UIListener.IsCalling()) return; // removed by jyjeon 2014-03-03 for ITS 226693
            if(popup.visible)
            {
                if(activeView != null)
                    activeView.manageFocusOnPopUp(true);
            }
            else
            {
                if(activeView != null)
                    activeView.manageFocusOnPopUp(false);
            }
            UIListener.SetLocalPopupVisibility(popup.visible)// modified by yongkyun.lee 2014-07-10 for :  popup OSD 
        }
    }

    //{ add by cheolhwan 2013.12.02. for ITS 210787.
    POPUPWIDGET.PopUpText
    {
        id:noStationPopup
        z: 1000
        y: 0
        icon_title: EPopUp.WARNING_ICON
        visible: false
        message: errorModel
        buttons: noStation
        focus_visible: noStationPopup.visible
        property bool showErrorView;

        function showNoStationPopup(text, errorView)
        {
            __LOG("[noStationPopup] showNoStationPopup() visible = " + visible, LogSysID.LOW_LOG);
            noStationPopup.showErrorView = errorView;
            if(!visible)
            {
                closePreviousPopup();

                if(UIListener.IsSystemPopupVisible())
                {
                    UIListener.CloseSystemPopup();
                }
                
                message:noStation
                errorModel.set(0,{msg:text})
                visible = true;
                //noStationPopup.showFocus();
            }
        }

        function hidePopup()
        {
            __LOG("noStationPopup hidePopup()  ", LogSysID.LOW_LOG);
            //noStationPopup.hideFocus();
            noStationPopup.visible = false;
            noStationPopup.showErrorView = false;
            noStationPopup.focus_visible = false;
        }

        onBtnClicked:
        {            
            //__LOG("[noStationPopup] onBtnClicked: noStationPopup.visible = " + noStationPopup.visible, LogSysID.LOW_LOG);
            if( noStationPopup.visible === true)
            {
                switch ( btnId )
                {
                    case "Yes":
                    {
                        __LOG("[noStationPopup] Pressed Yes", LogSysID.LOW_LOG);
                        if(pndrController.state === "pndrStationEntryErrorView")
                        {
                            popup.visible = false;
                            activeView.searchButtonClicked();
                        }
                    }
                    break;
                    case "No":
                    {
                        __LOG("[noStationPopup] Pressed No", LogSysID.LOW_LOG);
                        if(pndrController.state === "pndrStationEntryErrorView")
                        {
                             sendAppToBackground(true);
                        }
                    }
                    break;
                }
            }
        }

        onVisibleChanged:
        {
            __LOG("[noStationPopup] onVisibleChanged: noStationpopup.visible = " + noStationPopup.visible, LogSysID.LOW_LOG);
            if(noStationPopup.visible)
            {
                if(activeView != null)
                    activeView.manageFocusOnPopUp(true);
            }
            else
            {
                if(activeView != null)
                    activeView.manageFocusOnPopUp(false);
            }
        }
    }
    //} add by cheolhwan 2013.12.02. for ITS 210787.
    
    ListModel
    {
        id: btnmodel
            //{ modified by yongkyun.lee 2014-02-20 for : ITS 225866
            // ListElement
            // {
            //     btn_id: "OK"
            //     msg: "OK"
            // }
            //} modified by yongkyun.lee 2014-02-20             
    }

     ListModel
     {
         id: errorModel
         ListElement
         {
             msg: ""
         }
     }

     ListModel
     {
         id: noStation
         ListElement
         {
             btn_id: "Yes"
             msg: "Yes"
         }
         ListElement
         {
             btn_id: "No"
             msg: "No"
         }
     }
     Timer{
         id: functionalTimer
         running: false
         repeat: false
         interval: 3000
         onTriggered:{
             popup.visible = false;
             if(popup.showErrorView && pndrController.state !== "pndrErrorView" )
             {
                 popup.showErrorView = false;
                 pndrController.state = "pndrErrorView"
                 activeView.setTextChange(activeView.errorIndex); // add by cheolhwan 2013.12.04 for ITS 211672.
             }
             popup.showErrorView = false;
         }
     }
}
