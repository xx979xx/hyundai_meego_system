import QtQuick 1.0
import QmlOptionMenu 1.0
import ListViewEnums 1.0
import AudioControllerEnums 1.0
import AppEngineQMLConstants 1.0

OptionMenu
{
    id: optionMenu

    menumodel: EngineListener.optionMenuModel
    focus_id: LVEnums.FOCUS_OPTION_MENU
    focus_visible: (mediaPlayer.focus_index == focus_id)
//    z:10 // removed by eugeny.novikov 2012.11.30 for CR 16133
    autoHiding: true
    autoHideInterval: 10000 // modified by Sergey 01.08.2013
    visible: false
    middleEast: EngineListenerMain.middleEast // modified by Dmitry 11.05.13
    scrollingTicker: EngineListenerMain.scrollingTicker //[KOR][ISV][64532][C](aettie.ji)
    bAVPMode: true // DUAL_KEY
    property int previous_focus_index : 0 // added by wspark 2012.11.30 for ISV59938
    property bool isVisible : false //added by junam 2013.12.16 for ITS_ME_215036
    property bool soundSettings: false // added by Dmitry 27.08.13 for ITS0186485

    function showMenu()
    {
        EngineListenerMain.qmlLog("OptionMenu.qml", "showMenu") // modified by sangmin.seol 2014.09.12 reduce high log // added by sangmin.seol 2014.06.26 remain high log on show OptionMenu

        EngineListenerMain.sendTouchCleanUpForApps() //added by suilyou ITS 0191448
        optionMenu.visible = true
        optionMenu.bAVPMode=true
        optionMenu.isVisible = true //added by junam 2013.12.16 for ITS_ME_215036
        optionMenu.show()
    } // added by Sergey 02.08.2103 for ITS#181512

    onBeep: UIListener.ManualBeep(); // added by Sergey 02.11.2013 for ITS#205776
    onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

    onIsHidden:
    {
        EngineListenerMain.qmlLog("OptionMenu.qml", "OptionMenu isHidden") // modified by sangmin.seol 2014.09.12 reduce high log // added by sangmin.seol 2014.06.26 remain high log on OptionMenu disapeared

        // modified by Dmitry 26.04.13
        optionMenu.visible = false
        optionMenu.isVisible = false; //added by junam 2013.12.16 for ITS_ME_215036

        if(!mediaPlayer.systemPopupVisible) // added by sangmin.seol 2014.06.18 ITS 0240658
            mediaPlayer.setDefaultFocus();

        // modified by Dmitry 26.04.13
        EngineListener.tuneEnabled = true; //added by junam 2013.06.28 for ISV86231
        soundSettings = false // added by Dmitry 27.08.13 for ITS0186485
    }

    onTextItemSelect:
    {
        __LOG("optionMenu: onTextItemSelect " + itemId);

        switch (itemId)
        {
            //{ modified by wonseok.heo for ITS 176846 2013.06.28
            case MP.OPTION_MENU_SCAN_ALL:
            {
                AudioController.setScanMode(MP.SCANALL);
                break;
            }

            case MP.OPTION_MENU_SCAN_FOLDER:
            {
                AudioController.setScanMode(MP.SCANFILE);
                break;
            }
            // }modified by wonseok.heo for ITS 176846 2013.06.28
            case MP.OPTION_MENU_VIEW:
            {
                //{changed by junam 2013.12.19 for LIST_ENTRY_POINT
                if(AudioController.PlayerMode == MP.JUKEBOX || AudioController.PlayerMode == MP.USB1 || AudioController.PlayerMode == MP.USB2)
                {
                    if(AudioListViewModel.isCategoryTabAvailable())
                    {
                        AudioController.isBasicView = !AudioController.isBasicView; 
                        mediaPlayer.showPlayerView(AudioController.isBasicView);
                    }
                } 
                //else if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                //{
                //    if(AudioController.isMediaSyncfinished())
                //        mediaPlayer.showPlayerView(!AudioController.isBasicView);
                //    else
                //    {
                //        __LOG("MYTEST MP.OPTION_MENU_VIEW");
                //        popup_loader.showPopup(LVEnums.POPUP_TYPE_IPOD_INDEXING);
                //    }
                //}
                //}changed by junam
                break;
            }

            case MP.OPTION_MENU_NOW_PLAYING:
            {
                //{changed by junam 2013.12.19 for LIST_ENTRY_POINT
                //mediaPlayer.showPlayerView(true);
                AudioController.isBasicView = true;
                EngineListener.showListView(false); 
                //}changed by junam
                break;
            }

            case MP.OPTION_MENU_SCAN:
            {
                //{ added by junam 2013.06.24 for ISV_KR83931
                if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                {
                    delayedExecutionTimer.itemId = itemId; //added by junam 2013.07.02 for shuffle double click crash
                    delayedExecutionTimer.start();
                }
                else //}added by junam 
                {
                    if (AudioController.getScanMode() == MP.SCANOFF)
                        AudioController.setScanMode(MP.SCANALL);
                    else
                        AudioController.setScanMode(MP.SCANOFF);
                }  //added by junam 2013.06.24 for ISV_KR83931
                break;
            }

            case MP.OPTION_MENU_LIST:
            {
                //{changed by junam 2013.12.19 for LIST_ENTRY_POINT
                //if(AudioController.isPlayFromMLT)
                //{
                //    mediaPlayer.startMLT();
                //}
                //else
                //{
                //    mediaPlayer.restoreSavedCategoryTab(); //added by junam 2013.10.24 for ITS_NA_197365
                //    mediaPlayer.startFileList();
                //}
                EngineListener.showListView(true);
                //}changed by junam
                break;
            }

            case MP.OPTION_MENU_ADD_TO_PLAYLIST:
            {
                mediaPlayer.startAddToPlaylist();
                break;
            }

            case MP.OPTION_MENU_SHUFFLE_ON:
            {
                AudioController.setRepeatRandomMode(-1, MP.RANDOMFILE); // changed by eugeny - 12-09-15               
                //optionMenu.quickHide() //restored for ITS195746 29.Oct.2013// modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                break;
            }

            case MP.OPTION_MENU_SHUFFLE_OFF:
            {
                AudioController.setRepeatRandomMode(-1, MP.RANDOMOFF); // changed by eugeny - 12-09-15
                //optionMenu.quickHide() //restored for ITS195746 29.Oct.2013 // modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method

                break;
            }

            case MP.OPTION_MENU_COPY_TO_JUKEBOX:
            {
                mediaPlayer.checkForCopyProgress(itemId); // modified by ravikanth 16-04-13
                break;
            }

            case MP.OPTION_MENU_MOVE:
            case MP.OPTION_MENU_DELETE:
            {
                mediaPlayer.editHandler(itemId);
                break;
            }

            case MP.OPTION_MENU_CLEAR_JUKEBOX:
            {
                __LOG("onTextItemSelect OPTION_MENU_CLEAR_JUKEBOX");
		// modified by ravikanth 21-07-13 for copy cancel confirm on delete
                if(EngineListener.isCopyInProgress())
                {
                    popup_loader.showPopup(LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_CLEAR_JUKEBOX, 0);
                }
                else
                {
                    popup_loader.showPopup(LVEnums.POPUP_TYPE_CLEAR_JUKEBOX);
                }
                break;
            }
// { add by yongkyun.lee@lge.com    2012.10.05 for CR 13484 (New UX: music(LGE) # MP3 File info POPUP
            case MP.OPTION_MENU_FILE_INFO:
            {               
                AudioListViewModel.FileInfoPopUp();
                break;
            }
// } add by yongkyun.lee@lge.com 
            case MP.OPTION_MENU_CAPACITY:
            {
                __LOG("onTextItemSelect capacity")
                AudioListViewModel.capacityView();
                break
            }

            case MP.OPTION_MENU_SOUND_SETTING:
            {
                soundSettings = true // added by Dmitry 27.08.13 for ITS0186485
                EngineListener.LaunchHMISettings(isFrontView); //modified by edo.lee 2013.05.06
                break;
            }

            case MP.OPTION_MENU_CANCEL_OPERATION:
            {
	    // commented by ravikanth 11-08-13 for ITS 0183925
                if (listView_loader.item)
                {
                    // AudioListViewModel.operation = LVEnums.OPERATION_NONE; // removed by eugeny.novikov 2012.10.11 for CR 14229
                    // { added by eugene 2013.01.10 for ISV 69609
                    if(AudioListViewModel.operation == LVEnums.OPERATION_COPY) 
                    {
                        AudioListViewModel.cancelFileOperation();					
                    }
                    if(listView_loader.item.isEditMode)
                        listView_loader.item.cancelEditMode();	
                     // } added by eugene 2013.01.10 for ISV 69609
                }
                break;
            }

            case MP.OPTION_MENU_EDIT_CATEGORY:
            {
                mediaPlayer.editHandler();
                break;
            }

            case MP.OPTION_MENU_EXIT_MORE_LIKE_THIS:
            {
                AudioController.ExitFromMLT()
                // removed by Dmitry 15.05.13
                break;
            }

            case MP.OPTION_MENU_CONNECTION_SETTING:
            {
                EngineListener.LaunchBTSettings();
                break;
            }

            // { added by kihyung 2012.08.30 for DVD-Audio
            case MP.OPTION_MENU_TITLE_MENU:
            {
                AudioController.titleMenu();
                break;
            }

            case MP.OPTION_MENU_DISK_MENU:
            {
                AudioController.topMenu();
                break;
            }

            case MP.OPTION_MENU_DVD_SETTING:
            {
                EngineListener.launchSettings(true, true,isFrontView);//modified by edo.lee 2013.05.06
                break;
            }

            case MP.OPTION_MENU_DISPLAY_SETTING:
            {
                EngineListener.launchSettings(false, false, isFrontView);//modified by edo.lee 2013.05.06
                break;
            }
            // } added by kihyung
//{removed by junam 2013.09.23 for not using code
//            case MP.OPTION_MENU_KEYPAD_SETTING:
//            {
//                searchView_loader.item.showKeypadChinesePopup();
//                break;
//            }
//}removed by junam

            //{added by junam 2013.07.23 for ITS_KOR_181304
            case MP.OPTION_MENU_IPOD_MUISC_APP:
            {
                EngineListener.playIpodFiles();
                EngineListenerMain.invokeMethod(optionMenu,"hide"); // 2015.01.29
                break;
            }
            //}added by junam

            default:
            {
                __LOG("Start nId default");
            }
        }
         if (itemId != MP.OPTION_MENU_SOUND_SETTING && itemId != MP.OPTION_MENU_IPOD_MUISC_APP)		//added by hyochang.ryu 20130517 for ISV 79091 // modified 2015.01.29
            // optionMenu.quickHide() // modified by Sergey 02.08.2103 for ITS#181512
            EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
    }

    onRadioBtnSelect:
    {
        switch (itemId)
        {
	// { changed by eugeny - 12-09-15
            case MP.OPTION_MENU_REPEAT_ALL:
            {
                AudioController.setRepeatRandomMode(MP.REPEATALL, -1);
                //optionMenu.quickHide()//restored for ITS195746 29.Oct.2013// modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                break;
            }

            case MP.OPTION_MENU_REPEAT_FOLDER:
            {
                AudioController.setRepeatRandomMode(MP.REPEATFOLDER, -1);
                //optionMenu.quickHide() //restored for ITS195746 29.Oct.2013// modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                break;
            }

            case MP.OPTION_MENU_REPEAT_ONE:
            {
                AudioController.setRepeatRandomMode(MP.REPEATFILE, -1);
                //optionMenu.quickHide() //restored for ITS195746 29.Oct.2013// modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                break;
            }

            case MP.OPTION_MENU_SHUFFLE_ON:
            {
                //{added by junam 2013.07.02 for shuffle double click crash
                if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                {
                    delayedExecutionTimer.itemId = itemId;
                    delayedExecutionTimer.start();
                }
                else //}added by junam
                {
                    AudioController.setRepeatRandomMode(-1, MP.RANDOMFILE);
                }
                //optionMenu.quickHide() //restored for ITS195746 29.Oct.2013// modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                break;
            }

            case MP.OPTION_MENU_SHUFFLE_OFF:
            {
                //{added by junam 2013.07.02 for shuffle double click crash
                if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                {
                    delayedExecutionTimer.itemId = itemId;
                    delayedExecutionTimer.start();
                }
                else//}added by junam
                {
                    AudioController.setRepeatRandomMode(-1, MP.RANDOMOFF);
                }
                //optionMenu.quickHide() //restored for ITS195746 29.Oct.2013 // modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                break;
            }

            case MP.OPTION_MENU_SCAN_ALL:
            {
                AudioController.setScanMode(MP.SCANALL);
                //optionMenu.quickHide() // modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                break;
            }

            case MP.OPTION_MENU_SCAN_FOLDER:
            {
                AudioController.setScanMode(MP.SCANFILE);
                //optionMenu.quickHide() // modified by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenu,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                break;
            }
	    // } changed by eugeny - 12-09-15
        }
// removed by Dmitry 26.04.13
    }

// removed by Dmitry 26.04.13

    onCheckBoxSelect:
    {
        switch (itemId)
        {
            // { Deleted by yongkyun.lee@lge.com    2012.10.05 for CR 13484 (New UX: music(LGE) # MP3 File info POPUP
            //case MP.OPTION_MENU_FILE_INFO: //added by lyg  2012.08.30  for 3DPMS_136434 Audio Cd File info	
            // } Deleted by yongkyun.lee@lge.com
            case MP.OPTION_MENU_MORE_INFO:
            {
                albumView.isVisibleGenre = (flag) ? true: false;
                albumView.isVisibleComposer = (flag) ? true: false; // add by junggil 2012.06.29 for CR08958 : Composer info is not displayed on activating more info in Basic play back screen
                AudioController.bShowInfo = flag; // added by junam 2012.9.10 for CR13244
                break;
            }
        }
// removed by Dmitry 26.04.13
    }

    function __LOG( textLog )
    {
        EngineListenerMain.qmlLog("[MP] DHAVN_AppMediaPlayer_OptionMenu.qml: " + textLog)
    }
    // { modified by wspark 2012.08.02 for CR12020
    //function menuHandler()
    function menuHandler(nKeyType)
    // } modified by wspark
    {
        __LOG("menuHandler");
        //if( AudioController.isLoadingScreen) return; //removed by junam 2013.12.10 for code clean

	// { modified by ravikanth 17-05-13 for ISV 83180
        if( mediaPlayer.state == "listView" )
        {
            //{changed by junam 2013.5.28 for ISV_KR84025
            //EngineListener.SetOptionModel(mediaPlayer.state, listView_loader.item.isEditMode);
            var iseditState = ( listView_loader.item.isEditMode && !listView_loader.item.isCopyMode ) // modified for ITS 0211120
            EngineListener.SetOptionModel(mediaPlayer.state, iseditState || listView_loader.item.isCategoryEditMode);
            //}changed by junam
        }
        else
        {
            EngineListener.SetOptionModel(mediaPlayer.state)
        }
	// } modified by ravikanth 17-05-13

// } changed by eugeny - 12-09-15
        // { modified by eugeny.novikov 2012.08.17 for CR 13063
        // { added by kihyung 2012.08.09 for CR 12741
        if (mediaPlayer.state != "ipod" ||
           (mediaPlayer.state == "ipod" && AudioController.isMediaSyncfinished()))
        {
            // {modified by kihyung 2013.5.4 by HMC REQUEST
            // EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, true);
            if(mediaPlayer.state == "ipod" && AudioController.isFlowViewEnable()) {
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, true);
            }
	    // modified by ravikanth for hotfix on resume miner
            else if(mediaPlayer.state == "jukebox" && AudioController.PlayerMode == MP.JUKEBOX /*&& AudioController.isMinerFinished*/ && AudioListViewModel.isCategoryTabAvailable()) {
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, true);
            }
            else if(mediaPlayer.state == "usb" && AudioController.PlayerMode == MP.USB1 /*&& AudioController.isUSB1MinerFinished*/ && AudioListViewModel.isCategoryTabAvailable()) {
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, true);
            }
            else if(mediaPlayer.state == "usb" && AudioController.PlayerMode == MP.USB2 /*&& AudioController.isUSB2MinerFinished*/ && AudioListViewModel.isCategoryTabAvailable()) {
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, true);
            }
            else {
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, false);
            }
            // } modified by kihyung 2013.5.4 by HMC REQUEST
            
            if(mediaPlayer.state != "disc" || AudioController.DiscType == MP.AUDIO_CD)//{ added by yongkyun.lee 20130413 for : NO CR MP3 List  //modified by oseong.kwon 20140207 for ITS 223905
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_LIST, true);
            //EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_MORE_LIKE_THIS, EngineListener.getGracenoteIndexingStatus(AudioController.PlayerMode)); // modified by ravikanth 14-07-13 for MLT feature is spec out
        }
        // } added by kihyung
        // } modified by eugeny.novikov

// { changed by eugeny - 12-09-15
//        if (AudioController.getScanMode() != MP.SCANOFF)
//        {
//            EngineListener.optionMenuModel.itemTextChange(MP.OPTION_MENU_SCAN, "Stop Scan");
//        }
//        else
//        {
//            EngineListener.optionMenuModel.itemTextChange(MP.OPTION_MENU_SCAN, "STR_MEDIA_SCAN");
//        }
// } changed by eugeny - 12-09-15

        if (AudioController.isBasicView && mediaPlayer.state != "disc") // modified by eugeny.novikov 2012.10.25 for CR 14047
        {
            EngineListener.optionMenuModel.itemTextChange(MP.OPTION_MENU_VIEW, "STR_MEDIA_FLOW_VIEW");
        }
        else
        {
            EngineListener.optionMenuModel.itemTextChange(MP.OPTION_MENU_VIEW, "STR_MEDIA_MAIN_PLAYER"); //modified by eunhye 2013.02.05 for UX Scenario_Changed the text.
        }
// { changed by eugeny - 12-09-15
//        if (mediaPlayer.state == "disc")
//        {
//            if (AudioController.DiscType == MP.DVD_AUDIO)
//            {
//                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_FULL_SCREEN, false);
//                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_DISPLAY_SETTING, false);
//            }
//            else
//            {
//                var isAudioCD = (AudioController.DiscType == MP.AUDIO_CD);
//                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_MORE_LIKE_THIS, isAudioCD);
//            }
//        }
// } changed by eugeny - 12-09-15
        //{Modified by Radhakrushna 2012.08.15 3pdms # 136382
        if (mediaPlayer.state == "listView" /*&& AudioListViewModel.operation != LVEnums.OPERATION_NONE*/)
        {
            if(AudioListViewModel.operation != LVEnums.OPERATION_NONE)
            {
                //}Modified by Radhakrushna 2012.08.15 3pdms # 136382
		        switch (AudioListViewModel.operation)
		        {
		            case LVEnums.OPERATION_COPY:
		                EngineListener.optionMenuModel.itemTextChange(MP.OPTION_MENU_CANCEL_OPERATION,
		                                                              "STR_MEDIA_MNG_CANCEL_COPY");
		                break;

		            case LVEnums.OPERATION_DELETE:
		                EngineListener.optionMenuModel.itemTextChange(MP.OPTION_MENU_CANCEL_OPERATION,
		                                                              "STR_MEDIA_MNG_CANCEL_DELETE");
		                break;
			//{added by lyg for 3DPMS 136285
		            case LVEnums.OPERATION_ADD_TO_PLAYLIST:
		                EngineListener.optionMenuModel.itemTextChange(MP.OPTION_MENU_CANCEL_OPERATION,
		                                                              "STR_MEDIA_MNG_CANCEL");
		                break;
			//}added by lyg for 3DPMS 136285                   


		            default:
                                //EngineListener.optionMenuModel.itemTextChange(MP.OPTION_MENU_CANCEL_OPERATION,
                                //                                              "STR_MEDIA_MNG_MOVE_CANCEL");
		                break;
		        }
			//{Modified by Radhakrushna 2012.08.15 3pdms # 136382
            }
            else
            {
                __LOG("Dimmed some specific optiond for play list");

                __LOG("currentTabText -> " + listView_loader.item.currentTabText);

                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_ADD_TO_PLAYLIST,
                                                          (listView_loader.item.currentTabText == "Play_list") ? false : true);

                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_MOVE,
                                                          (listView_loader.item.currentTabText == "Play_list") ? false : true);
                //EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_COPY_TO_JUKEBOX,
                //                                          (listView_loader.item.currentTabText == "Play_list") ? false : true); // commented by ravikanth 13-04-13
                if(listView_loader.item.currentTabText == "Play_list")
                    EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_DELETE, false);
            }
            //}Modified by Radhakrushna 2012.08.15 3pdms # 136382
        }

	// removed by Sergey 02.08.2103 for ITS#181512

        if (mediaPlayer.focus_index != LVEnums.FOCUS_NONE || nKeyType == true) // true : HARD menu key, false : SOFT menu key
        {
            mediaPlayer.tmp_focus_index = LVEnums.FOCUS_OPTION_MENU
        }
// modified by Dmitry 26.04.13
    }

// removed by Dmitry 16.05.13

    // { added by kihyung 2012.08.01 for CR 11725
    Connections
    {
    //[EU][IVS][84553][84633][c][EU][ITS][167240][comment] [KOR][ISV][64532][C](aettie.ji)
        target:EngineListenerMain
        onTickerChanged:
        {
            __LOG("onTickerChanged ticker(audio option) : " + ticker);
            optionMenu.scrollingTicker = ticker;
        }
    }
    Connections
    {
        target: AudioController

        // { modified by kihyung 2012.08.04 for CR 11725
        /*
        onIPodSyncStep:
        {
            __LOG("onIPodSyncStep " + syncType);
            if(syncType != 0)
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, true);
            else
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, false);
        }
        */
        onMediaSyncfinished:
        {
            if(mediaPlayer.state == "ipod") //added by oseong.kwon 20140207 for ITS 223905
            {
                __LOG("IPodSignal: onIPodSyncfinished " + bFinished);
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_VIEW, bFinished);
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_LIST, bFinished);
                //EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_MORE_LIKE_THIS, bFinished);  //deleted by aettie.ji 2013.02.22 for ISV 71131 etc.
            }
        }
        // } modified by kihyung
    }
    // } added by kihyung

    //{ changed by junam 2013.07.02 for shuffle double click crash
    Timer
    {
        property int itemId : -1 
        id: delayedExecutionTimer
        interval : 1
        onTriggered:
        {
            switch(itemId)
            {
            case MP.OPTION_MENU_SCAN:
                if (AudioController.getScanMode() == MP.SCANOFF)
                    AudioController.setScanMode(MP.SCANALL);
                else
                    AudioController.setScanMode(MP.SCANOFF);
                break;

            case MP.OPTION_MENU_SHUFFLE_ON:
                AudioController.setRepeatRandomMode(-1, MP.RANDOMFILE);
                break;

            case MP.OPTION_MENU_SHUFFLE_OFF:
                AudioController.setRepeatRandomMode(-1, MP.RANDOMOFF);
                break;
            }
            itemId = -1;
        }
    }
    //}changed by junam
}
