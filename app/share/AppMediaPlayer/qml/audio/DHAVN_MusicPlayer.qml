import Qt 4.7
import Qt.labs.gestures 2.0
// import QmlStatusBarWidget 2.0 // removed by kihyung 2012.12.15 for STATUSBAR_NEW
import QmlSimpleItems 1.0
import QmlModeAreaWidget 1.0
import AudioControllerEnums 1.0
//import QmlPopUpPlugin 1.0
import AppEngineQMLConstants 1.0
import ListViewEnums 1.0
//import Transparency 1.0 // removed by junam 2013.09.30 for change raster
import QmlStatusBar 1.0 //modified by edo.lee 2013.04.04
import QtQuick 1.1 // added by Dmitry 05.05.13

// { commented by cychoi 2015.06.03 for Audio/Video QML optimization
//import "../video/components"
//import "../video/popUp"
// } commented by cychoi 2015.06.03

import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

// { changed by junam 2013.09.30 for change raster
Item
//TransparencyPainter
// } changed by junam
{
    id: mediaPlayer

    width: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH
    height: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_HEIGHT

    property alias modeAreaList: modeAreaListModel
    property alias modeAreaText: modeAreaListModel.text;
    property alias modeAreaFileCount: modeAreaListModel.file_count;  //added by yungi 2013.03.06 for New UX FileCount
    property alias modeAreaInfoText: modeAreaListModel.mode_area_right_text;
//{modified by HWS 2013.03.24 for New UX

    //{added by aettie.ji 2012.12.20 fot new ux
    property alias modeAreaInfoText_f: modeAreaListModel.mode_area_right_text_f; //HWS
    //  property alias modeAreaCategoryType: modeAreaListModel.mode_area_cat_type;
    property alias modeAreaCategoryIcon: modeAreaListModel.icon;  //HWS
    property alias modeAreaCategoryIcon_f: modeAreaListModel.icon_cat_folder; //HWS
//{modified by aettie 2013.04.01 for New UX        
    
//}modified by HWS 2013.03.24 for New UX
    property alias sCategoryId: albumView.sCategoryId;
   /* property alias modeAreaFolderFilesCount: modeAreaListModel.right_text_visible_f; 
//}modified by aettie 2013.04.01 for New UX  
    property alias modeAreaFoldersCount: modeAreaListModel.mode_area_right_folder;  
    //}added by aettie.ji 2012.12.20 fot new ux
    */
    // added by minho 20120821
    // { for NEW UX: Added menu button on ModeArea
    property alias modeAreaMenuText: modeAreaMenuModel.text;
    property alias modeAreaMenuInfoText: modeAreaMenuModel.mode_area_right_menu_text;
    // } added by minho
    property alias modeAreaMLTText: mltModeAreaModel.text;
    property alias modeAreaMLTInfoText: mltModeAreaModel.mode_area_right_text;
    property int tmp_focus_index: LVEnums.FOCUS_NONE;
    property int focus_index: LVEnums.FOCUS_CONTENT; //modified by aettie 2013.03.27 for Touch focus rule
    property bool disableList: false;
    property bool isLongEject: false
    property bool bScan: false
    property bool isMediaSyncFinished: false // added by kihyung 2012.08.01 for CR 11725
    property bool isSearchState : false // added by lyg 2012.08.14 for tuneOSD
    property int tranCount: 1;// added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42

    //deleted for gracenote logo spec changed 20131008
    // property bool isDvdListView : false // commented by cychoi 2015.06.03 for Audio/Video QML optimization // added by ravikanth
    property bool isDiscListView : false // added by minho 20120906 for deleted menu tab on modearea after inserted DISC
    property bool isAvaiableBTControl: true //added by edo.lee 2012.09.17 for New Ux Music(LGE) #43
    
    // { modified by ravikanth - 12-09-24
    property int offsetX: 0;
    property bool move_start: false
    // } modified by ravikanth - 12-09-24

    property int preDisplayMode: MP.UNDEFINED//added by edo.lee 2012.11.28  for ISV 64487 
    property bool bGoingToSearch : false // added by wspark 2012.12.20 for ITS150787
    property bool isTimerRunning : false // modified by oseong.kwon 2014.06.10 for ITS 239908 // modified by yongkyun.lee 2013-10-14 for : ITS 195248
    //property bool isTimerRunning : EngineListenerMain.getisBTCall() ? false : true //modified  by hyochang.ryu 20130916 for ITS190429	//false //modified by edo.lee 2013.01.17 // modified by lssanh 2013.04.24 NoCR BT trans ani always on
    property int playermodeBeforePopup: MP.UNDEFINED // added by wspark 2013.01.28 for ISV 71172
    property bool isPlayResumed : false // added by wspark 2013.01.18 for ITS 154750
    property int previousCategoryIndexJukeBox : 0 // added by eugene.seo 2013.02.06 for ISV #68937
    property int previousCategoryIndexUSB : 0 // added by eugene.seo 2013.02.06 for ISV #68937
    property bool isCurrentFrontView: true //added by edo.lee 2013.03.07
    // removed by Dmitry 16.05.13
    property bool isMP3CDReadComplete: false //{ added by yongkyun.lee 20130413 for : NO CR MP3 List 

    // removed by Dmitry 15.05.13
    property bool isFirstLoaded:true; //added by edo.lee 2013.06.07 for set play icon
    property bool openList:false;

    property bool cancelInEditState: false // modified by ravikanth 29-06-13 for ITS 0176909
    property bool copyToJukeBox: false; //[KOR][ISV][79666][B](aettie.ji)

    //{added by wonseok.heo 2013.07.04 disc in out test
    property int    testFullCount  : 10000
    property int    testCount  : 0
    property string testStatus : " - "
    property string testDiscStatus :"Please insert CDDA Disc"
    property int     discErrorChk : 0
    property int     discStatus  : 0
    property int     pStatus : 0
    property string testTrackNumber: ""
    property bool discTestMode: false
    property int entryTestMod: 0
    property int lastRandom: 0
    property int lastRepeat: 0
    //}added by wonseok.heo 2013.07.04 disc in out test

    property int last_Focus_flag: 0; // added by wonseok.heo for ITS 177631  2013.07.05
    property bool isAllItemsSelected: false // modified by ravikanth for ITS 0188110
    property bool systemPopupVisible: false // added by sangmin.seol for ITS 0217570 2013.12.30
    property bool bTransToCopyEditMode : false // added by sangmin.seol for ITS 0231004 2014.03.25 Add property for checking screen trans to copy mode from playerview
    property bool bNeedDelayedPopup: false   // added by sangmin.seol 2014.06.12 ITS 0239773
    property int delayedPopupType: -1   // added by sangmin.seol 2014.06.12 ITS 0239773

//added by suilyou ITS 0205778 START
    onFocus_indexChanged:
    {
        __LOG("onFocus_indexChanged " + focus_index)
        EngineListener.focusIndex = focus_index; //added by junam 2013.12.16 for ITS_ME_215036
        if(focus_index == LVEnums.FOCUS_CONTENT)
            AudioController.setCoverFlowEnable(true)
        else
            AudioController.setCoverFlowEnable(false)
    }
//added by suilyou ITS 0205778 END
    GestureArea
    {
        id: gesture_area1
        anchors.fill: parent

        Tap
        {
           onStarted:
           {
               // { deleted by wspark 2013.03.15 for ITS 159586
               /*
              if (focus_index != LVEnums.FOCUS_NONE)
              {
                  tmp_focus_index = LVEnums.FOCUS_NONE
                  focus_index = LVEnums.FOCUS_NONE
                  signalSetFocus()
              }
              */
               // } deleted by wspark
           }
        }
    }

    function __LOG( textLog )
    {
        if(isFrontView)
            EngineListenerMain.qmlLog("[MP] DHAVN_MusicPlayer.qml[F]: " + textLog)
        else
            EngineListenerMain.qmlLog("[MP] DHAVN_MusicPlayer.qml[R]: " + textLog)
    }

// modified by Dmitry 16.05.13
    function setDefaultFocus()
    {
        __LOG("setDefaultFocus() mediaPlayer focus_index = " + focus_index);

        // { commented by cychoi 2015.06.03 for Audio/Video QML optimization
        //if(popup.visible)
        //{
        //    popup.setFocus();
        //}
        //else if( popup_loader.visible )
        // } commented by cychoi 2015.06.03
        if( popup_loader.visible )
        {
            popup_loader.setFocus();
        }
// added by Dmitry 12.10.13 for ITS0195164
        else if (optionMenuLoader.status == Loader.Ready && optionMenuLoader.item.visible)
        {
           tmp_focus_index = LVEnums.FOCUS_OPTION_MENU
        }
//{removed by junam 2013.09.23 for not using code
//        else if (key_pad_loader.visible)
//        {
//            tmp_focus_index = key_pad_loader.item.setDefaultFocus(UIListenerEnum.JOG_CENTER);
//        }
//}removed by junam
        else
        {
           switch (state)
           {
              case "jukebox":
              case "usb":
              case "ipod":
              case "disc":
              case "bluetooth":
              case "aux": //added by Michaele.Kim 2013.08.30 for ITS 186913
              {
                  __LOG("setDefaultFocus() mediaPlayer playbackControls enabled = " + playbackControls.enabled);

                 if (AudioController.isBasicView || playbackControls.isBtMusic) //modified by oseong.kwon 2014.05.28 for ITS 238653, 238654
                 {
                     // { modofied by cychoi 2015.02.11 for new DRS menu UX & focus handling on LCD ON/OFF (ITS 241667)
                    //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
					//if(playbackControls.enabled)
					if(playbackControls.enabled && !AudioController.isiPodNoMediaMode()) // modified by cychoi 2016.02.22 for Mode Area has focus on double Media HK (Hyundai Spec Change 2015.12.28 No Media File)
                    {
                        tmp_focus_index = playbackControls.setDefaultFocus(UIListenerEnum.JOG_DOWN);
                    }
                    else
                    {
                        tmp_focus_index = modeAreaWidget.setDefaultFocus(state == "aux" ? UIListenerEnum.JOG_UP : UIListenerEnum.JOG_DOWN);//added by junam 2013.07.25 for dim control que
                    }
                     // } modofied by cychoi 2015.02.11
                 }
                 else // for cover flow
                    tmp_focus_index = LVEnums.FOCUS_CONTENT
                 break;
              }
              case "listView":
              {
                 tmp_focus_index = LVEnums.FOCUS_CONTENT
                 listView_loader.item.setDefaultFocus() // added by Dmitry 31.07.13 for ITS0180216
                 break;
              }
           }
        }
    }
// modified by Dmitry 16.05.13

    // { added by honggi.shin 2013.11.04 for empty list focus issue after deleting music files
    function setEmptyMusicListFocus()
    {
        listView_loader.item.setEmptyMusicListFocus();
    }
    // } added by honggi.shin 2013.11.04

    function changePlayStatus()
    {
        EngineListenerMain.qmlLog("DUAL_KEY playbackControls.is_scan =" + playbackControls.is_scan)
        if (playbackControls.is_scan)
        {
            AudioController.setScanMode(MP.SCANOFF); // modified by eugeny - 12-09-15
        }
        else
        {
        //{ added by hyochang.ryu 20130517 for BT Toggle
        if(mediaPlayer.state=="bluetooth")
        {
           //mediaPlayer.toggle(); //20131016 del function in qml
           EngineListener.Toggle();
        } else { 
        //} added by hyochang.ryu 20130517 for BT Toggle
            EngineListenerMain.qmlLog("DUAL_KEY EngineListener.IsPlaying() =" + EngineListener.IsPlaying())
            if (EngineListener.IsPlaying())
            {
                //mediaPlayer.pause(); //20131016 del function in qml
                EngineListener.Pause();
            }
            else
            {
                //mediaPlayer.resume(); //20131016 del function in qml
                EngineListener.Play();
            }
        } //added by hyochang.ryu 20130517 for BT Toggle
        }
    }

    function showPathView(bShow)
    {
        if (mediaPlayer.state == "jukebox" || mediaPlayer.state == "usb" || mediaPlayer.state == "ipod")
        {
            coverCarousel.visible = bShow;
	    //deleted for gracenote logo spec changed 20131008
        }
    }
    // { modified by ravikanth 16-04-13
    function checkForCopyProgress(mode)
    {
        if (EngineListener.isCopyInProgress() && (mediaPlayer.state == "usb" || mediaPlayer.state == "listView"))
        {
	    // Modified for ISV 96192
            if(mediaPlayer.state == "usb")
            {
                mediaPlayer.copyToJukeBox = true;
                AudioListViewModel.setCopyFromMainPlayer(true);
            }
            else if(mediaPlayer.state =="listView")
            {
                mediaPlayer.copyToJukeBox = false;
                AudioListViewModel.setCopyFromMainPlayer(false);
            }
            popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM);
        }
        else
        {
            if(mediaPlayer.state == "usb")
	    {
	    	//[KOR][ISV][79666][B](aettie.ji)
		//[KOR][ITS][179014][comment](aettie.ji)
                mediaPlayer.copyToJukeBox = true;
                AudioListViewModel.setCopyFromMainPlayer(true);

                //{ changed by junam 2014.01.06 for LIST_ENTRY_POINT
                //mediaPlayer.startFileList();
                bTransToCopyEditMode = true;   // added by sangmin.seol for ITS 0231004 2014.03.25 Add property for checking screen trans to copy mode from playerview
                EngineListener.showListView(true);
                return;
                //}changed by junam
	    } 
	    else if(mediaPlayer.state =="listView") 
          {
                mediaPlayer.copyToJukeBox = false;
                AudioListViewModel.setCopyFromMainPlayer(false);
            }
           else mediaPlayer.copyToJukeBox = false;
            mediaPlayer.editHandler(mode);
        }
    }
    // } modified by ravikanth 16-04-13
    function startFileList()
    {
        __LOG("startFileList()");
        // { changed by junam 2013.12.10 for code clean
        //if( AudioController.isLoadingScreen || listView_loader.status != Loader.Null) return; // modified by Dmitry 05.10.13 for ITS0193999
        if( listView_loader.status != Loader.Null) return; // modified by Dmitry 05.10.13 for ITS0193999
        //}changed by junam

        // removed by Dmitry 06.10.13
        mediaPlayer.openList = true; //added by edo.lee 2013.06.07
        EngineListener.setFileManager(isFrontView); // added by edo.lee 2013.08.12 ISV 88908
        
        AudioListViewModel.displayMode = AudioController.PlayerMode;
        mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_LIST_MENU"); //modified by aettie 20130621 for list title
        mediaPlayer.modeAreaFileCount = "";

        // removed by Dmitry 06.10.13
        tmp_focus_index = LVEnums.FOCUS_CONTENT // added by shkim for ITS 195507
        // { commented by cychoi 2015.06.03 for Audio/Video QML optimization
        //if (mediaPlayer.state == "disc" && AudioController.DiscType == MP.DVD_AUDIO)
        //{
        //    isDvdListView = true; // added by ravikanth
        //    listView_loader.source = "DHAVN_AppMediaPlayer_DVD_List.qml";
        //    EngineListener.GetDiscInfo();
        //    listView_loader.item.updateTitleData();
        //    listView_loader.item.updateChapterData();
        //    EngineListener.pushScreen( mediaPlayer.state );
        //    mediaPlayer.state = "listView";
        //    //modeAreaInfoText = ""; //deleted by aettie 2013.03.24 for New UX
        //    EngineListener.storeDVDdata(); // added by ravikanth - 12-09-26
        //    isDiscListView = true; // added by minho 20121017 for CR13942: [Disc] there should not be menu tab in DVD Audio list screen
        //}
	//{modified by aettie 2013.02.25 for ISV 68153, ISV 62706
        //else
        // } commented by cychoi 2015.06.03
        {
            //deleted for gracenote logo spec changed 20131008
            // isDvdListView = false; // commented by cychoi 2015.06.03 for Audio/Video QML optimization
            if (disableList == true)
            {
                return;
            }
            listView_loader.source = "DHAVN_AppMediaPlayer_ListView.qml";
            listView_loader.parent = mainViewArea;
            // removed by Dmitry 05.10.13 for ITS0193999
            EngineListener.pushScreen( mediaPlayer.state );
            switch (mediaPlayer.state)
            {
                case ("jukebox"):
                case ("usb"):
                {
		//[NA][ITS][182674][minor] (aettie.ji) 20130813
                    if(listView_loader.item.categoryDimmed)
                    {
                        listView_loader.item.currentCategoryIndex = 0;
                    }
		    else{
                    listView_loader.item.currentCategoryIndex = (mediaPlayer.state == "jukebox") ? mediaPlayer.previousCategoryIndexJukeBox
                                                                  : mediaPlayer.previousCategoryIndexUSB;
                    }
                    listView_loader.item.setSourceLoaderTab (jukeboxTab);
                    //listView_loader.item.currentCategoryIndex = (mediaPlayer.state == "jukebox") ? mediaPlayer.previousCategoryIndexJukeBox
                    //                                                                             : mediaPlayer.previousCategoryIndexUSB;//// deleted by yongkyun.lee 20130228 for : NO CR : Ipod list
                    isDiscListView = false;
                    break;
                }
                case ("disc"):
                {
                    listView_loader.item.isCD = false; //modified by wonseok.heo NOCR for new UX 2013.11.09 // added by wonseok.heo for NO CR mp3 disc M.E UX 2013.08.20
                    if (AudioController.DiscType == MP.AUDIO_CD)
                    {
                        discTab.source = "DHAVN_CDDAItem.qml"; //modified by wonseok.heo NOCR for new UX 2013.11.09
                        listView_loader.item.setSourceLoaderTab (discTab);
                        listView_loader.item.currentCategoryIndex = 0;
                    }
                    else //MP3CD
                    {
		    //{ISV 62706
                        discTab.source = "DHAVN_DiscItem.qml";
                        listView_loader.item.setSourceLoaderTab (discTab);
                        listView_loader.item.currentCategoryIndex = 0;
                        listView_loader.item.centerCurrentPlayingItem();
		    //}ISV 62706
                    }
                    //listView_loader.item.isCD = true;
                    listView_loader.item.setQuickScrollVisible(false);
                    isDiscListView = true;
                    break;
                }
                case ("ipod"):
                {
                    ipodTab.item.loadCategoryModel(); //added by junam 2013.07.04 for ITS172937
                    listView_loader.item.currentCategoryIndex = ipodTab.item.currentCategoryIndex;// added by yongkyun.lee 20130228 for : NO CR : Ipod list
                    listView_loader.item.setSourceLoaderTab (ipodTab);
                    //listView_loader.item.currentCategoryIndex = ipodTab.item.currentCategoryIndex; // deleted by yongkyun.lee 20130228 for : NO CR : Ipod list
                    isDiscListView = false;
                    break;
                }
                default:
                {
                    isDiscListView = false;
                    return;
                }
            }
            mediaPlayer.state = "listView";
            setDefaultFocus() // added by Dmitry 06.10.13
            AudioController.setListMode(true);
            if(!AudioListViewModel.isFileOperationInProgress())
                AudioListViewModel.operation = LVEnums.OPERATION_NONE;
        }
        // removed by Dmitry 16.05.13
    }

    //{added by junam 2013.10.24 for ITS_NA_197365
    function restoreSavedCategoryTab()
    {
        //{ by sam 2013.10.01
        __LOG("-- Loading File list... state: "+ mediaPlayer.state );
        if( mediaPlayer.state == "jukebox")
        {
            switch(AudioController.getCategoryTab(mediaPlayer.state))
            {
            case "Folder":
                jukeboxTab.item.currentCategoryIndexJukeBox = 0;
                break;
            case "Song":
                jukeboxTab.item.currentCategoryIndexJukeBox = 1;
                break;
            case "Album":
                jukeboxTab.item.currentCategoryIndexJukeBox = 2;
                break;
            case "Artist":
                jukeboxTab.item.currentCategoryIndexJukeBox = 3;
                break;
            case "Genre":
                jukeboxTab.item.currentCategoryIndexJukeBox = 4;
                break;
            }

            mediaPlayer.previousCategoryIndexJukeBox = jukeboxTab.item.currentCategoryIndexJukeBox;
            __LOG(" -- state jukebox: "+ jukeboxTab.item.currentCategoryIndexJukeBox );
        }
        else if( mediaPlayer.state == "usb")
        {
            switch(AudioController.getCategoryTab(mediaPlayer.state))
            {
            case "Folder":
                jukeboxTab.item.currentCategoryIndexUSB = 0;
                break;
            case "Song":
                jukeboxTab.item.currentCategoryIndexUSB = 1;
                break;
            case "Album":
                jukeboxTab.item.currentCategoryIndexUSB = 2;
                break;
            case "Artist":
                jukeboxTab.item.currentCategoryIndexUSB = 3;
                break;
            case "Genre":
                jukeboxTab.item.currentCategoryIndexUSB = 4;
                break;
            }

            mediaPlayer.previousCategoryIndexUSB =  jukeboxTab.item.currentCategoryIndexUSB;
            __LOG(" -- state usb: "+ jukeboxTab.item.currentCategoryIndexUSB );
        }
        //} by sam 2013.10.01
        //{ added 2013.10.30
        else if( mediaPlayer.state == "ipod")
        {
            __LOG("getCategoryTab mediaPlayer.state " + AudioController.getCategoryTab(mediaPlayer.state));
            setCurrentCategory(AudioController.getCategoryTab(mediaPlayer.state));
        }
        //} added 2013.10.30
    }
    //}added by junam


    function startAddToPlaylist()
    {
        // __LOG ("startAddToPlaylist(): state = " + mediaPlayer.state);

        AudioListViewModel.tipPopup();

        if (mediaPlayer.state == "listView")
        {
            mediaPlayer.editHandler(MP.OPTION_MENU_ADD_TO_PLAYLIST);
            popup_loader.showPopup(LVEnums.POPUP_TYPE_PL_FIRST_TIME); // added by eugene.seo 2013.01.08 for showing add to jukebox popup
        }
        else
        {
            if (AudioListViewModel.isPlaylistsExist())
                popup_loader.showPopup(LVEnums.POPUP_TYPE_PL_CHOOSE_PLAYLIST);
            else
                popup_loader.showPopup(LVEnums.POPUP_TYPE_PL_CREATE_NEW);
        }
    }

    // { modified by eugeny.novikov 2012.10.11 for CR 14229
    function closeListScreen()
    {
        __LOG("closeListScreen()");

        // { commented by cychoi 2015.06.03 for Audio/Video QML optimization
        //if (mediaPlayer.isDvdListView)
        //{
        //    mediaPlayer.state = EngineListener.popScreen();
        //    listView_loader.item.visible = false;
        //    listView_loader.source = "";
        //    AudioController.isBasicView = true; // modified by eugeny.novikov 2012.10.25 for CR 14047
        //}
        //else
        // } commented by cychoi 2015.06.03
        {
            // { added by wspark 2012.11.29 for CR14471
            if (popup_loader.status == Loader.Ready)
            {
                if (popup_loader.popup_type == LVEnums.POPUP_TYPE_CANCEL_MOVE_QUESTION ||
                    //popup_loader.popup_type == LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION || // modified for ISV 90644
                    popup_loader.popup_type == LVEnums.POPUP_TYPE_CAPACITY_ERROR_MANAGE)
                {
                    popup_loader.item.closePopup();
                    AudioListViewModel.popupEventHandler(popup_loader.popup_type, 0); // CANCEL
                }
                else if (popup_loader.popup_type == LVEnums.POPUP_TYPE_REPLACE ||
                         popup_loader.popup_type == LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION)
                {
                    popup_loader.item.closePopup();
                    AudioListViewModel.popupEventHandler(popup_loader.popup_type, 3); // CANCEL
                }
                else if(popup_loader.popup_type == LVEnums.POPUP_QUICK_FOLDER_DELETE ||
                        popup_loader.popup_type == LVEnums.POPUP_QUICK_FILE_DELETE)
                {
                    popup_loader.item.closePopup();
                    AudioListViewModel.popupEventHandler(popup_loader.popup_type, 1); // CANCEL
                }
            }
            // } added by wspark
            mediaPlayer.isAllItemsSelected = false
            AudioListViewModel.resetRequestData();
            AudioListViewModel.resetPartialFetchData();
            //listView_loader.item.currentLoaderTab.item.historyStack = 0;// removed by junam 2012.11.29 for CR16170
            if(EngineListener.isCopyInProgress())
                EngineListener.setCancelEditModeCheck(true); //added by Michael.Kim 2014.08.26 for ITS 246688 
            listView_loader.item.cancelEditMode(); //added by edo.lee 10.12 for ITS 0136564  when close list, cancel edit mode
            listView_loader.item.visible = false;// added by yongkyun.lee@lge.com : 2012.10.05 CR13792 -Display overlapped screen of List and currently playing screen
            mediaPlayer.state = EngineListener.popScreen();

            //{removed by junam 2013.12.12 for ITS_AU_214834
            //if(coverCarousel.visible)// && PathViewModel.firstEntry)
            //{
            //    EngineListener.requestCovers();//PathViewModel.firstEntry);
            //}
            //}removed by junam

            if (mediaPlayer.state == "jukebox")
            {
                jukeboxTab.item.currentCategoryIndexJukeBox = listView_loader.item.currentCategoryIndex;
                mediaPlayer.previousCategoryIndexJukeBox = listView_loader.item.currentCategoryIndex; // added by eugene.seo 2013.02.06 for ISV #68937
            }
            else if (mediaPlayer.state == "usb")
            {
                jukeboxTab.item.currentCategoryIndexUSB = listView_loader.item.currentCategoryIndex;									
                mediaPlayer.previousCategoryIndexUSB = listView_loader.item.currentCategoryIndex; // added by eugene.seo 2013.02.06 for ISV #68937
            }
            else if (mediaPlayer.state == "ipod")
                ipodTab.item.currentCategoryIndex = listView_loader.item.currentCategoryIndex;
            // { removed by kihyung 2013.1.4 for ISV 68141
            /*
            // { added by yungi 2012.11.30 for CR16108
            else if (mediaPlayer.state == "disc" && AudioController.DiscType == MP.MP3_CD)
                popup_loader.showPopup(LVEnums.POPUP_TYPE_LOADING_DATA);
            // } added by yungi 2012.11.30 for CR16108
            */
            // } removed by kihyung 2013.1.4 for ISV 68141

            listView_loader.source = "";
        }
        closeOptionMenu(true) // added by Dmitry 24.08.13 for ITS0186085

        // { modified by eugene.seo 2012.10.16 for closing popup when inserting ipod during usb jukebox copying (Function_USB_0230)
        if(popup_loader.status == Loader.Ready &&
                (popup_loader.popup_type == LVEnums.POPUP_TYPE_COPYING
                 || popup_loader.popup_type == LVEnums.POPUP_TYPE_CAPACITY_VIEW   //added by junam 2013.08.21 for ITS_EU_183947
                 || popup_loader.popup_type == LVEnums.POPUP_TYPE_CLEAR_JUKEBOX  //added by junam 2013.08.21 for ITS_EU_183947
                 || popup_loader.popup_type == LVEnums.POPUP_TYPE_MOVING ))
        {
            popup_loader.item.closePopup();
        }
        // } modified by eugene.seo 2012.10.16

        // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
        // added by sangmin.seol 2014.06.17 ITS 0240140 restoreplay if unsupported popup showing in closing list
        if(popup_loader.status == Loader.Ready &&
           popup_loader.popup_type == LVEnums.POPUP_TYPE_UNAVAILABLE_FORMAT)
        {
            popup_loader.item.closePopup();
        }
        //if(popup.visible == true && popup.message == unavailableFormatModel)
        //{
        //    popup.hidePopup(true);
        //}
        // added by sangmin.seol 2014.06.17 ITS 0240140 restoreplay if unsupported popup showing in closing list
        // } modified by cychoi 2015.06.03

		AudioController.setListMode(false); // modified by eugene.seo 2012.10.23 for Function_USB_0190
        // { added by  yongkyun.lee 2012.10.26 for : regression from CR 14229
        EngineListener.setFileManagerBG(); // added by edo.lee 2013.08.12 ISV 88908
        mediaPlayer.setDefaultFocus();
        AudioListViewModel.setCopyCompletedMode(false); // added by eugene 2012.11.29 for CR 16076
        // } added by  yongkyun.lee
    }
//{removed by junam 2013.09.23 for not using code
//    function closeSearchScreen()
//    {
//        __LOG("closeSearchScreen()");

//        searchView_loader.item.resetSearch();
//        mediaPlayer.state = EngineListener.popScreen();
//        searchView_loader.item.visible = false;

//        // { added by eugeny.novikov 2012.12.18 for CR 16432
//        if (!albumView.visible && !coverCarousel.visible && mediaPlayer.state != "listView")
//        {
//            mediaPlayer.showPlayerView(true);
//        }
//        // } added by eugeny.novikov 2012.12.18
//    }

//    function closeMltScreen()
//    {
//        __LOG("closeMltScreen()");

//        if (mediaPlayer.state == "mltView") //added by junam for CR14654
//        {
//            mediaPlayer.state = EngineListener.popScreen();
//            mlt_screen_loader.item.visible = false;
//            EngineListener.setMltState(false);
//            mediaPlayer.setDefaultFocus(); //added by junam 2013.03.28 for ISV77692
//            EngineListener.ClearOSD(isFrontView);//added by edo.lee 2013.07.09
//        }
//    }
//}removed by junam

    // { modified by eugeny.novikov 2012.11.13 for CR 15121
    function closeAllListViews()
    {
        // __LOG("closeAllListViews()");

        if (mediaPlayer.state == "listView")
        {
            mediaPlayer.closeListScreen();
        }
//{removed by junam 2013.09.23 for not using code
//        else if (mediaPlayer.state == "searchView")
//        {
//            mediaPlayer.closeSearchScreen();
//        }
//        else if (mediaPlayer.state == "mltView")
//        {
//            mediaPlayer.closeMltScreen();
//        }
//        else if (mediaPlayer.state == "keypad")
//        {
//            mediaPlayer.hideKeyPad();
//        }
//}removed by junam 

        //{removed by junam 2013.10.25 for not using code
        /* Finally, close ListView after Search, Keypad or Mlt */
        //if (mediaPlayer.state == "listView")
        //{
        //    mediaPlayer.closeListScreen();
        //}
        //}removed by junam
    }
    // } modified by eugeny.novikov

    function showPlayerView(bType)
    {
        __LOG("showPlayerView(): " + bType);

        if(bType == false)
        {
            if(AudioController.isControllerDisable(MP.CTRL_DISABLE_FLOWVIEW))//changed by junam 2013.07.12 for music app
                return;

        }
        else //{added by junam 2013.11.28 for ITS_NA_211655
        {
            screenTransitionDisableTimer.interval = 1000;
            screenTransitionDisableTimer.restart();
        }
        //}added by junam

        //}changed

        if (mediaPlayer.state != "bluetooth" &&
            mediaPlayer.state != "aux" &&
            mediaPlayer.state != "disc" ) // rollback by wonseok.heo NOCR for Disc focus at cover flower 2013.11.28
            //mediaPlayer.state != "keypad")  //removed by junam 2013.09.23 for not using code
            // mediaPlayer.state != "ipod") // added by kihyung 2013.5.3 by HMC REQUEST
        {	
            EngineListener.onTuneTimerStop(); // added by lssanh 2013.02.19 ISV72789

            if (mediaPlayer.state == "ipod" && AudioController.isFlowViewEnable() == false)
            {
                __LOG("isMediaSyncFinished is false. Return");
                return;
            }
            // } added by kihyung

            //{changed by junam 2013.12.20 for LIST_ENTRY_POINT   // modified for ITS 222912
            if (mediaPlayer.state == "listView")
            {
                __LOG("state=listView currentSelectedIndex=" + modeAreaWidget.currentSelectedIndex);
                if ( modeAreaWidget.currentSelectedIndex == MP.IPOD1 || modeAreaWidget.currentSelectedIndex == MP.IPOD2 )
                {
                    mediaPlayer.closeAllListViews();
                    //EngineListener.HandleBackKey();
                    EngineListener.HandleSoftIpod(); // ITS 247904
                }
                else
                {
                    __LOG("ERROR - tring to change view in list screen")
                    AudioController.isBasicView = bType;
                    return;
                }
            }
            //}changed by junam

			//Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            //albumView.visible = bType;
            //coverCarousel.visible = !bType;
            //prBar.btextVisible = !bType; //removed by junam 2013.12.09 for ITS_NA_212868
            //playbackControls.visible = bType

            if(mediaPlayer.state !== "ipod")
            {
                albumView.visible = bType;
                playbackControls.visible = bType
            }

            coverCarousel.visible = !bType;
			//end of Hyundai Spec Change


            AudioController.isBasicView = bType;

            //changed by junam 2013.12.19 for LIST_ENTRY_POINT
            //if (coverCarousel.visible)
            if ( !bType && (AudioController.PlayerMode == MP.JUKEBOX ||  AudioController.PlayerMode == MP.USB1 || AudioController.PlayerMode == MP.USB2))
            {
                EngineListener.requestCovers();
                AudioController.updateCoverFlowMediaInfo(AudioController.PlayerMode, true, false); //moved by junam 2013.11.11 for ITS_NA_208040
            }

            //if(AudioController.getFrontLcdMode()){//added by taihyun.ahn 2013.10.24 for 194172 // removed by sangmin.seol 2013.11.07 for ITS 0207202
            if( EngineListener.isAudioTempMode() == false && systemPopupVisible == false )  // modified by sangmin.seol 2014.07.14 ITS 0242815 remain focus temporal fg mode
                mediaPlayer.setDefaultFocus(); // added by eugeny.novikov 2012.11.13 for CR 15121
            //}
            //{added by junam 2013.10.14 for ITS_KOR_195303
            if( coverCarousel.status == Loader.Ready)
                coverCarousel.item.stopJogDial();
            //}added by junam

            EngineListener.setAudioTempMode(false);     // added by sangmin.seol 2014.07.14 ITS 0242815 remain focus temporal fg mode
        }
    }

// modified by Dmitry 24.05.13
    function backHandler()
    {
        __LOG("backHandler(): mediaPlayer.state = " + mediaPlayer.state);
        EngineListener.ClearOSD(isFrontView); //added by edo.lee 2013.07.09
        loadView(false); //modified by edo.lee 2013.03.30
        //mediaPlayer.setDefaultFocus(); // removed by Dmitry 23.04.13
   }

    function loadView(isSoftBack, bRRC)  //modified by aettie 20130620 for back key event
    {
        if (coverCarousel.visible)
        {
            mediaPlayer.showPlayerView(true);
            return;
        }

        // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
        // added by sangmin.seol 2014.06.17 ITS 0240140 restoreplay if unsupported popup showing in closing list
        if(popup_loader.status == Loader.Ready &&
           (popup_loader.popup_type == LVEnums.POPUP_TYPE_NO_MUSIC_FILES ||
            popup_loader.popup_type == LVEnums.POPUP_TYPE_UNAVAILABLE_FORMAT ||
            popup_loader.popup_type == LVEnums.POPUP_TYPE_ALL_UNAVAILABLE_FORMAT ||
            popup_loader.popup_type == LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE)) // added by cychoi 2015.09.24 for ITS 268908
        {
            AudioController.isRunFromFileManager = false
            popup_loader.item.closePopup();
            return
        }
        //if (popup.visible)
        //{
        //   AudioController.isRunFromFileManager = false
        //   popup.hidePopup(true)
        //   return
        //}
        // } modified by cychoi 2015.06.03

        switch (mediaPlayer.state)
        {
            case ("listView"):
                // modified by Dmitry 05.10.13 for ITS0193999
                if (listView_loader.status == Loader.Ready)
                    listView_loader.item.backHandler();
                break;

            default:
            	//added by edo.lee 2013.03.30
            	if(isSoftBack)
            		EngineListener.HandleSoftBackKey(isFrontView, bRRC); //modified by aettie 20130620 for back key event
            	else
            	//added by edo.lee 2013.03.30
	                EngineListener.HandleBackKey();
                break;
        }

        // removed by junam 2013.12.12 for ITS_AU_214834
        //if (!albumView.visible)
        //{
        //    showPathView(true);
        //    EngineListener.requestCovers();
        //}
        //}removed by junam
    }
// modified by Dmitry 24.05.13

    function editHandler(mode)
    {
        __LOG("editHandler(): mode = " + mode);

        if (mediaPlayer.state == "listView")
        {
            listView_loader.item.currentLoaderTab.item.editHandler(mode)
        }
    }

    //{added by junam 2013.07.18 for ITS_NA_180278
    function changeTabModel(tabId)
    {
        __LOG(" GetVariantRearUSB = "+EngineListenerMain.GetVariantRearUSB());
        switch(tabId)
        {
	//[KOR][ITS][181982][minor](aettie.ji)
        case MP.USB1:
            mode_area_model.setProperty( MP.USB1, "name", QT_TR_NOOP("STR_MEDIA_AUDIO_USB_FRONT")); // modified by AVP 2014.04.24 for KH GUI
            mode_area_model.setProperty( MP.USB1, "name_fr", QT_TR_NOOP(EngineListenerMain.GetVariantRearUSB() ? "STR_MEDIA_FRONT" : "")); 
            break;
        case MP.USB2:
            mode_area_model.setProperty( MP.USB2, "name", QT_TR_NOOP("STR_MEDIA_AUDIO_USB_REAR")); // modified by AVP 2014.04.24 for KH GUI
            mode_area_model.setProperty( MP.USB2, "name_fr", QT_TR_NOOP(EngineListenerMain.GetVariantRearUSB() ? "STR_MEDIA_REAR" : "")); 
            break;
        case MP.IPOD1:
            mode_area_model.setProperty( MP.IPOD1, "name", QT_TR_NOOP("STR_MEDIA_IPOD1")); // modified by AVP 2014.04.24 for KH GUI
            mode_area_model.setProperty( MP.IPOD1, "name_fr", QT_TR_NOOP(EngineListenerMain.GetVariantRearUSB() ? "STR_MEDIA_FRONT" : "")); 
            break;
        case MP.IPOD2:
            mode_area_model.setProperty( MP.IPOD2, "name", QT_TR_NOOP("STR_MEDIA_IPOD2")); // modified by AVP 2014.04.24 for KH GUI
            mode_area_model.setProperty( MP.IPOD2, "name_fr", QT_TR_NOOP(EngineListenerMain.GetVariantRearUSB() ? "STR_MEDIA_REAR" : "")); 
            break;
        }
    }
    // } added by junam

    // { modified by eugeny.novikov 2012.11.13 for CR 15121
    // { added by junam 2012.10.09 for CR14118
    function clearSeekMode()
    {
        if (AudioController.isLongPress)
        {
            //{ modified by Jeeeun Jang 1012.10.17 for Function_DISC_0270
            if (playbackControls.is_ff_rew == false)
            //if(EngineListener.isSeekHardKeyPressed)
            //} modified by Jeeeun Jang 
            {
                __LOG("clear seek mode which invoked from hard seek key")
                //{changed by junam 2013.09.07 for ITS_KOR_185529
                //EngineListener.isSeekHardKeyPressed = false;
                EngineListener.isNextHardKeyPressed = false;
                EngineListener.isPrevHardKeyPressed = false;
                //}changed by junam
                EngineListener.normalPlay();
            }
            else
            {
                // { added by kihyung 2013.2.5 for ISV 72327
                //playbackControls.is_ff_rew = false;// added by yongkyun.lee 20130417 for : Multi Key-Only First key
                playbackControls.setPauseState();
                // } added by kihyung 2013.2.5 for ISV 72327
                
                __LOG("clear seek mode which invoked from soft seek button")
                if(AudioController.isLongPress == 1)
                    playbackControls.handleOnRelease("Next");
                else if(AudioController.isLongPress == -1)
                    playbackControls.handleOnRelease("Prev");
            }
        }
    }
    // } added by junam

    //{ added by yongkyun.lee 2012.12.19 for CR 14219 ,POPUP/list close
    function closePopup()
    {
        if (popup_loader.status == Loader.Ready && popup_loader.item.visible)
            popup_loader.item.closePopup();
        
    }
    //} added by yongkyun.lee 


    // { added by sangmin.seol 2014.09.17 show unsupported file only one
    function isUnsupportedPopupVisible()
    {
        // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
        if(popup_loader.status == Loader.Ready &&
           (popup_loader.popup_type == LVEnums.POPUP_TYPE_NO_MUSIC_FILES ||
            popup_loader.popup_type == LVEnums.POPUP_TYPE_UNAVAILABLE_FORMAT ||
            popup_loader.popup_type == LVEnums.POPUP_TYPE_ALL_UNAVAILABLE_FORMAT ||
            popup_loader.popup_type == LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE)) // added by cychoi 2015.09.24 for ITS 268908
        {
            return true;
        }
        //if(popup.visible == true)
        //    return true;
        // } modified by cychoi 2015.06.03

        return false;
    }
    // } added by sangmin.seol 2014.09.17 show unsupported file only one

// modified by Dmitry 16.08.13
    function closeOptionMenu(quick)
    {
       if (quick == undefined) quick = false
       if (optionMenuLoader.status == Loader.Ready)
       {
           if (optionMenuLoader.item.isVisible) //added by junam 2013.12.16 for ITS_ME_215036
           {
               quick ? EngineListenerMain.invokeMethod(optionMenuLoader.item,"quickHide") : optionMenuLoader.item.hide() //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
           }
       }
    }
// modified by Dmitry 16.08.13

    // added by sangmin.seol 2014.08.19 ITS-0244518 restore mediaPlayer.state on viewchanged temporal mode case
    function isChangedStateOnTempMode(tabId)
    {
        if(!EngineListener.isAudioTempMode() || mediaPlayer.state == "listView") // modified by sangmin.seol SMOKE 2014.08.22 listview -> listView
            return false;

        switch(tabId)
        {
        case MP.JUKEBOX:
            if(mediaPlayer.state == "jukebox")
                return false;
            break;
        case MP.USB1:
        case MP.USB2:
            if(mediaPlayer.state == "usb")
                return false;
            break;
        case MP.DISC:
            if(mediaPlayer.state == "disc")
                return false;
            break;
        case MP.IPOD1:
        case MP.IPOD2:
            if(mediaPlayer.state == "ipod")
                return false;
            break;
        case MP.BLUETOOTH:
            if(mediaPlayer.state == "bluetooth")
                return false;
            break;
        case MP.AUX:
            if(mediaPlayer.state == "aux")
                return false;
            break;
        default:
            return false;
        }

        return true;
    }

	// removed by Sergey 02.08.2103 for ITS#181512
    // { modified by kihyung 2013.07.08
    function activateTab(tabId, isVisible, isSelected) 
    {
        __LOG("activateTab(): tabId " + tabId + " visible " + isVisible + " selected " + isSelected + " PlayerMode " +AudioController.PlayerMode);

        if (isVisible)
        {
            if(!isChangedStateOnTempMode(tabId) && bGoingToSearch && AudioController.PlayerMode == tabId)
            {
                __LOG("Temporal Mode. isMediaOnFromOff " + EngineListenerMain.isMediaOnFromOff());

                if(EngineListenerMain.isMediaOnFromOff()) 
                {
                    //mediaPlayer.resume(); //20131016 del function in qml
                    EngineListener.Play();
                }
                
                return;
            }

            // removed by Dmitry 17.07.13

            // { added by kihyung 2013.3.12 for sync onModeArea_Tab.
            if (AudioController.isSourceChanged == false)
            {
                __LOG("activateTab(): ________________ERROR __________________");
                __LOG("activateTab(): AudioController.isSourceChanged is false");
                return;
            }
            // } added by kihyung 2013.3.12 for sync onModeArea_Tab.

            mediaPlayer.closeAllListViews(); //revert by junam 2014.01.14 for ITS_NA_219735
            EngineListener.isKeypadSettings = false;
            mediaPlayer.bGoingToSearch = false;
	    // removed by Sergey 02.08.2103 for ITS#181512
            __LOG("activateTab  TempMode() : "+EngineListener.isAudioTempMode());
            if(EngineListener.isAudioTempMode()==false)
            {
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                if(AudioController.PlayerMode != tabId || popup_loader.popup_type != LVEnums.POPUP_TYPE_ALL_UNAVAILABLE_FORMAT)
                {
                    closePopup();
                }
                // { modified by kihyung 2013.09.12 for ISV 90605
                //if(AudioController.PlayerMode != tabId || popup.message != allUnavailableFormatModel)
                //{
                //    popup.visible = false; // added by edo.lee 2013.06.26 for close error popup
                //    closePopup(); //added by edo.lee 2013.06.22
                //}
                // } modified by kihyung 2013.09.12 for ISV 90605
                // } modified by cychoi 2015.06.03
            }

            // { modified by cychoi 2014.07.31 for ITS 244518 (ITS187394)
            if(AudioController.PlayerMode == MP.BLUETOOTH && MP.BLUETOOTH != tabId) 
            {
                albumBTView.visible= false;
                playbackControls.isBtMusic = false;     
            }
            else if(AudioController.PlayerMode == MP.BLUETOOTH && MP.BLUETOOTH == tabId) 
            {
                albumBTView.visible= true;
                playbackControls.isBtMusic = true;
                mediaPlayer.isAvaiableBTControl = EngineListener.getIsRemoteCtrl(); // added by cychoi 2015.05.15 for ITS 262799
            }
            else if(AudioController.PlayerMode != MP.BLUETOOTH && MP.BLUETOOTH != tabId)
            {
                albumBTView.visible= false;
                playbackControls.isBtMusic = false;     
            }
            // } modified by cychoi 2014.07.31

           //{ modified by yongkyun.lee 2013-07-26 for : new UX 
           if(tabId == MP.DISC ){
               // { modified by wonseok.heo NOCR for Disc focus at cover flower 2013.11.28
               coverCarousel.visible = false;
               AudioController.isBasicView = true;
               if(EngineListener.isAudioTempMode()==false)   //added by sangmin.seol for LCD OFF 2014.07.01
                   mediaPlayer.setDefaultFocus();
               // } modified by wonseok.heo NOCR for Disc focus at cover flower 2013.11.28
               mode_area_model.setProperty( MP.DISC, "name", QT_TR_NOOP(AudioController.DiscType == MP.AUDIO_CD ? "STR_MEDIA_DISC_CD" : AudioController.DiscType == MP.MP3_CD ? "STR_MEDIA_DISC_MP3" : "DISC" )); // modified by wonseok.heo for 180937 2013.08.12
           }
           //} modified by yongkyun.lee 2013-07-26
           
           //{ modified by yongkyun.lee 2013-08-18 for : NOCR MP3 List button disable
           if(tabId == MP.DISC && AudioController.DiscType == MP.AUDIO_CD)
              mode_area_model.bDisabled = false
           //} modified by yongkyun.lee 2013-08-18 
           
           //{deleted by Michael.Kim 2013.08.30 for ITS 186913
           //{ added by hyochang.ryu 20130815 for ITS183714/6 -> 183463/183509
           // if(tabId == MP.AUX) 
           // 	{
           // 
           //     auxTab.visible = true;
           //     albumView.visible = false;
           //     albumBTView.visible = false;
           //     playbackControls.visible = false;
           //     coverCarousel.visible = false;
           //     prBar.visible = false;
           //     //prBar.btextVisible = false;
           //     //prBar.bPrBarVisible = false;
           //     //prBar.nCurrentTime =0;
           //     modeAreaWidget.modeAreaModel = mode_area_model;
           //     mode_area_model.rb_visible = false;
           //     mode_area_model.mb_visible = true;
           //     mode_area_model.right_text_visible = false;
           //     gracenote_logo_item.visible = false;
           //     textDVDAudioInfo.visible = false;
           // 	}
           //} added by hyochang.ryu 20130815 for ITS183714/6 -> 183463/183509
           //}deleted by Michael.Kim 2013.08.30 for ITS 186913

            if (isSelected)
            {
                isPlayResumed = true; // added by wspark 2013.01.18 for ITS 154750      
                
                //removed by junam 2013.07.30 for music app list button
                //playbackControls.enabled = (tabId != MP.IPOD1 && tabId != MP.IPOD2) || AudioController.isBasicControlEnableStatus;

                if (modeAreaWidget.currentSelectedIndex != tabId && tabId != MP.UNDEFINED)
                {                    
                    mode_area_model.set(mediaPlayer.preDisplayMode, {"isVisible": false}); // added by edo.lee 2013.01.07 ISV 67768
                    if (modeAreaWidget.currentSelectedIndex != -1)
                    {
                        mode_area_model.set(modeAreaWidget.currentSelectedIndex, { isVisible: false });
                    }
                    //added by edo.lee 2013.06.07 for setting play icon
                    else
                    {
                        if(EngineListener.IsPlaying() == true )
                        {
                            isPlayResumed = true;
                        }
                        else if(EngineListener.isPaused() == true )
                        {
                            isPlayResumed = false;
                        }
                    }
                    
                    mode_area_model.set(tabId, { isVisible: true });
                    modeAreaWidget.currentSelectedIndex = tabId;
                }
                else if (AudioController.PlayerMode != tabId)
                {
                    //modified by edo.lee 2013.08.21
                    if(EngineListenerMain.getPowerOffBTCall()&& EngineListenerMain.getisBTCall())           
                          isPlayResumed = false;
                    //modified by edo.lee 2013.08.21
                
                    modeAreaWidget.currentSelectedIndex = -1;
                    modeAreaWidget.currentSelectedIndex = tabId;
                }
                else if(EngineListener.isAudioOff() || (EngineListener.SaveLastState() == false && EngineListener.IsPlaying() == false && !albumBTView.visible))
                {
                    if(AudioController.PlayerMode != tabId || EngineListenerMain.getIsFromOtherAV() || mediaPlayer.isFirstLoaded ) //added by edo.lee 2013.06.07 for setting play icon
                    {
                        //mediaPlayer.resume(); //20131016 del function in qml
                        EngineListener.Play();
                        playbackControls.setPauseState(); // added by kihyung 2013.06.09
                    }
                    else
                    {
                        isPlayResumed = false; //added by edo.lee 2013.06.18 for keep icon changing same mode
                    }
                }
                //{ added by hyochang.ryu 20130527
                else if(EngineListener.isAudioOff() || (EngineListener.SaveLastState() == false && AudioController.PlayerMode == MP.BLUETOOTH && !albumBTView.visible)) 
                {
                    //mediaPlayer.resumeBT();  // added by hyochang.ryu 20130705 //20131016 del function in qml
                    EngineListener.ResumeBT();
                    playbackControls.setPauseState(); // added by kihyung 2013.06.09
                }
                //} added by hyochang.ryu 20130527
                //{ added by edo.lee 2013.08.01 bt call pwr off
                else if(EngineListenerMain.getPowerOffBTCall()&& EngineListenerMain.getisBTCall())//modified by edo.lee 2013.08.21
                {
                    //{ added by taihyun.ahn 2013.10.07 for 0180008
                    if(EngineListenerMain.getAccOffFromOn()){
                        isPlayResumed = true;
                        EngineListenerMain.setAccOffFromOn(false);
                    }
                    else{
                        isPlayResumed = false;
                    }
                    //}
                }//} added by edo.lee 2013.08.01 bt call pwr off
                else
                {
                    if(EngineListener.isPaused() && !mediaPlayer.isFirstLoaded)//added by edo.lee 2013.06.07 for setting play icon
                        isPlayResumed = false;
                }

                //{added by wonseok.heo 2013.07.04 disc in out test
                if (mediaPlayer.discTestMode == true)
                {
                    albumView.visible = false;
                    playbackControls.visible = false;
                    coverCarousel.visible = false;
                    prBar.btextVisible = false;
                    prBar.bPrBarVisible = false;
                    prBar.nCurrentTime =0;
                    //mediaPlayer.resume(); //added by wonseok.heo 2013.09.23 disc in out test //20131016 del function in qml
                    EngineListener.Play();
                }
                //{removed by junam 2013.12.19 for LIST_ENTRY_POINT
                //else
                //{
                //    mediaPlayer.showPlayerView(true);
                //}
                //}removed by junam

                //{modified edo.lee 2013.06.07 for setting play icon
                /*if(EngineListener.IsPlaying() == true )
                {
                    playbackControls.setPauseState();
                }*/
                __LOG("!!!!!! isPlayResumed : "+isPlayResumed);
                mediaPlayer.isFirstLoaded = false;
                //}modified edo.lee 2013.06.07 for setting play icon

// modified by Dmitry for ITS0179896 on 14.07.2013
                if(tabId == MP.IPOD1 || tabId == MP.IPOD2)
                {
                    if(EngineListener.IsPlaying() == true )
                    {
                        // { added by wonseok.heo for ITS 219603 2014.01.13
                        if(playbackControls.is_scan)
                        {
                            playbackControls.state = "Scan";
                            playbackControls.setScanState();
                        }
                        else
                        {
                            playbackControls.state = "Play";
                            playbackControls.setPauseState();
                        }
                        // } added by wonseok.heo for ITS 219603 2014.01.13
                    }
                    else if(EngineListener.isPaused() == true )
                    {
                        playbackControls.state = "Pause";
                        playbackControls.setPlayState();
                    }
                }//}added by junam
// modified by Dmitry for ITS0179896 on 14.07.2013
                else if(isPlayResumed == false)
                // } modified by wspark
                {
                    // { removed by junam 2013.12.10 for code clean
                    //if(AudioController.isTAScanComplete(tabId) == true) {
                    //    AudioController.isLoadingScreen = false;
                    //}
                    // } removed by junam

                    //{modified edo.lee 2013.06.07 for setting play icon
                    playbackControls.state = "Pause";
                    playbackControls.setPlayState();  //added by edo.lee 2013.06.22

                    prBar.nCurrentTime = AudioController.GetCurrentMediaPosition(tabId); //added by junam 2013.10.25 for ITS_KOR_195270
                }
                else
                {
                    // { added by wonseok.heo for ITS 219603 2014.01.13
                    if(playbackControls.is_scan)
                    {
                        playbackControls.state = "Scan";
                        playbackControls.setScanState();
                    }
                    else if(EngineListener.isPaused() == true) // added by sangmin.seol 2014.09.17 ITS 0247230 sync play,pause icon state on activate tab
                    {
                        playbackControls.state = "Pause";
                        playbackControls.setPlayState();
                    }
                    else
                    {
                        playbackControls.state = "Play";
                        playbackControls.setPauseState(); // added by kihyung 2013.06.09
                    }
                    // } added by wonseok.heo for ITS 219603 2014.01.13
                }
                //}modified edo.lee 2013.06.07 for setting play icon
            }
            //{removed by junam 2013.12.19 for LIST_ENTRY_POINT
            //if (albumView.visible)
            //{
            //    playbackControls.visible = albumView.visible;
            //    showPathView(false);
            //}
            //}removed by junam
            // { deleted by wspark 2013.04.28 for cluster IOT
            /*
                    if (tabId == MP.AUX || tabId == MP.BLUETOOTH)
                    {
                        AudioController.sendOpStateForNotifier(tabId);
                    }
                    */
            // } deleted by wspark
            //{ rollback by hyochang.ryu 20130720-> 20130926 for unknown  -> 20131102 for cluster sync
            //{ modified by yongkyun.lee 2013-08-21 for : BT Mode key - unknown OSD
            __LOG("MusicPlayer.qml : getBTSetInfo= " + EngineListener.getBTSetInfo());
            if(tabId == MP.BLUETOOTH &&  EngineListener.getBTSetInfo())		//hyochang.ryu 20130821 for P1#4
            //} modified by yongkyun.lee 2013-08-21 
            {
                //{ modified by hyochang.ryu 20130516 for BT OSD
                if (albumBTView.status == Loader.Ready)
                {
                    AudioController.resumeTpMessage(albumBTView.item.sSongName, MP.BLUETOOTH)            //moved by wspark 2013.04.30 for cluster IOT
                    __LOG("MusicPlayer.qml : sSongName= " + albumBTView.item.sSongName + " , " + albumBTView.item.sAlbumName + " , " + albumBTView.item.sArtistName );
                }
                //AudioController.BTMusicInfoChanged(albumBTView.sSongName , albumBTView.sAlbumName , albumBTView.sArtistName , 0);
                //} modified by hyochang.ryu 20130516 for BT OSD
            }
            //} rollback by hyochang.ryu 20130720-> 20130926 for unknown  -> 20131102 for cluster sync
            //remove by edo.lee 2013.06.22
            //if(EngineListenerMain.isBTCall)
            //    playbackControls.setPlayState(); 
            //added by edo.lee 2013.06.13               
        }
        else // isVisible == false
        {
            mode_area_model.set(tabId, { "isVisible": false });

            if (AudioController.PlayerMode == tabId) 
            {
                mediaPlayer.closeAllListViews();
            }
//{removed by junam 2013.09.23 for not using code
//            else  if (mediaPlayer.state == "searchView")
//            {
//                searchView_loader.item.refreshSearchList();
//            }
//}removed by junam
            if (modeAreaWidget.currentSelectedIndex == tabId)
            {
                __LOG("Hide currently played source");
                if(mediaPlayer.discTestMode == false)
                { //added by wonseok.heo 2013.07.04 disc in out test
                    modeAreaWidget.currentSelectedIndex = -1;
                    mediaPlayer.state = "default";
                    prBar.reset();
                } //added by wonseok.heo 2013.07.04 disc in out test
            }
        }

        //{ added by yongkyun.lee 20130413 for : NO CR MP3 List 
        if( tabId == MP.DISC && isVisible == false && isSelected == false )
            mediaPlayer.isMP3CDReadComplete = false;
        //} added by yongkyun.lee 20130413 

        //Suryanto Tan ITS 0267966 2015.11.16,
        //When re-entering the iPod mode in rear screen, we need to call this to change to 3rd party mode.
        if(tabId == MP.IPOD1 || tabId == MP.IPOD2) // added by cychoi 2015.11.30 for ITS 270557
        {
			//Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            if(AudioController.iPodHasPlayableContent(tabId))
            {
                if(AudioController.isBasicControlEnableStatus)
                {
                    showiPodPlaybackScreen(MPC.iPodPlaybackMode_Normal)
                }
                else
                {
                    showiPodPlaybackScreen(MPC.iPodPlaybackMode_3rdParty)
                }
            }
            else
            {
                showiPodPlaybackScreen(MPC.iPodPlaybackMode_NoMedia)
            }
        }
    }
    // } modified by kihyung 2013.07.08

//{removed by junam 2013.09.23 for not using code
//    function showKeyPad(defaultText)
//    {
//        __LOG("showKeyPad(): text = " + defaultText);

//        if (mediaPlayer.state == "keypad")
//        {
//            __LOG("Keypad already shown!");
//            return;
//        }

//        EngineListener.pushScreen(mediaPlayer.state);
//        mediaPlayer.state = "keypad";

//        key_pad_loader.visible = true;
//        key_pad_loader.item.title = defaultText;
//        mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_INPUT_NEW_NAME");

//        if (mediaPlayer.focus_index != LVEnums.FOCUS_NONE)
//        {
//            mediaPlayer.tmp_focus_index = key_pad_loader.item.setDefaultFocus(UIListenerEnum.JOG_DOWN);
//        }
//    }

//    function hideKeyPad()
//    {
//        if (mediaPlayer.state != "keypad")
//            return;

//        key_pad_loader.visible = false;
//        mediaPlayer.state = EngineListener.popScreen();
//        mediaPlayer.updateModeAreaHeader();
//        mediaPlayer.setDefaultFocus();
//    }
//}removed by junam
    function updateModeAreaHeader()
    {
        if (mediaPlayer.state == "listView")
        {
            if (AudioListViewModel.operation == LVEnums.OPERATION_COPY && !AudioListViewModel.isCopyMode)
                mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_COPY_TO_JUKEBOX");
            else if (AudioListViewModel.operation == LVEnums.OPERATION_MOVE)
                mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_MOVE");
            else if (AudioListViewModel.operation == LVEnums.OPERATION_DELETE)
                mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_DELETE");
            else if (AudioListViewModel.operation == LVEnums.OPERATION_ADD_TO_PLAYLIST)
                mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_ADD_TO_PLAYLIST");
            else
                mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_LIST_MENU");//modified by aettie 20130621 for list title
        }
    }

    // { added by eugeny.novikov 2012.10.25 for CR 14047
    function enableModeAreaTabs(isEnabled)
    {
        __LOG("enableModeAreaTabs(): isEnabled " + isEnabled);

        modeAreaTimer.stop();

        if (!isEnabled)
            modeAreaTimer.start();

        mode_area_model.isTabBtnsDisable = !isEnabled;
    }
    // } added by eugeny.novikov
//{modified by HWS 2013.03.24 for New UX

    function setDiskIcon()
    {
        modeAreaCategoryIcon_f = "/app/share/images/music/list_ico_folder.png";
        modeAreaCategoryIcon =  "/app/share/images/music/list_ico_song.png";

    }

    //{ added by yongkyun.lee 20130413 for : NO CR MP3 List 
    function setListButtonShow( readComplete)
    {
        __LOG("setListButtonShow : " +readComplete)
        mediaPlayer.isMP3CDReadComplete = readComplete;
        if(mediaPlayer.state == "disc" && AudioController.DiscType == MP.MP3_CD)
        {
            mode_area_model.bDisabled = readComplete ? false:true // modified by yongkyun.lee 2013-08-18 for : NOCR MP3 List button disable
            //{ added by oseong.kwon 20140311 for : ITS 228846
            if(readComplete == true && optionMenuLoader.item.visible)
            {
                EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_LIST, true);
            }
            //} added by oseong.kwon 20140311
        }
    }
    //} added by yongkyun.lee 20130413

    //{added by wonseok.heo 2013.07.04 disc in out test
    function setDiscTestMode(){

        prBar.bScanStatus   = true;
        prBar.nRepeatStatus = 0;
        prBar.nRandomStatus = 0;
        __LOG("setDiscTestMode");

    }
    //}added by wonseok.heo 2013.07.04 disc in out test

    // HWS
    function setCategoryIcon(catId, listText, compareicon ,compare)
    {
        __LOG("setCategoryIcon catId : " +catId+" listText : "+listText)

        switch(catId)
        {        
        case "Etc":
            modeAreaCategoryIcon_f = "";
            //{changed by junam 2013.11.21 for ISV_NA_90331
            if(listText =="Playlists") modeAreaCategoryIcon = "/app/share/images/music/list_ico_music_list.png";
            else if(listText =="Artists") modeAreaCategoryIcon = "/app/share/images/music/list_ico_artist.png";
            else if(listText =="Albums") modeAreaCategoryIcon = "/app/share/images/music/list_ico_album.png";
            else if(listText =="Songs") modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            else if(listText =="iTunes U") modeAreaCategoryIcon = "/app/share/images/music/ico_itunesu.png";
            else if(listText =="Podcasts") modeAreaCategoryIcon = "/app/share/images/music/ico_podcast.png";
            else if(listText =="Audiobooks") modeAreaCategoryIcon = "/app/share/images/music/ico_audio_books.png";
            else if(listText =="Composer") modeAreaCategoryIcon = "/app/share/images/music/ico_composer.png";
            else if(listText =="Genres") modeAreaCategoryIcon = "/app/share/images/music/list_ico_genre.png";
            else modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            //}changed by junam
            break;
        case "Album":
            modeAreaCategoryIcon_f = "";
            if(listText =="Songs"){
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            }else{
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_album.png";

            }
            break;
        case "Artist":
            modeAreaCategoryIcon_f = "";
            if(listText =="Songs"){
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            }else{
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_artist.png";
            }
            break;
        case "Play_list":
            modeAreaCategoryIcon_f =  "";
            if(listText =="Songs"){
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            }else{
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_music_list.png";
            }
            break;
        case "Song":
            modeAreaCategoryIcon_f =  "";
            modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            break;
        case "Folder":
            if( modeAreaInfoText_f != "")
            {
                //{changed by junam 2014.01.10 for list counter icon
                //modeAreaCategoryIcon_f = "/app/share/images/music/list_ico_song.png";
                //modeAreaCategoryIcon =  "/app/share/images/music/list_ico_folder.png";
                modeAreaCategoryIcon_f =  "/app/share/images/music/list_ico_folder.png";
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
                //}changed by junam
            }
            else
            {
                if(listText =="Songs")
                {
                    modeAreaCategoryIcon_f="";
                    modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
                }
                else if(listText =="DiskInfo")
                {
                    if(compare =="icofolder2")
                    {
                        modeAreaCategoryIcon_f="";
                        modeAreaCategoryIcon = "/app/share/images/music/list_ico_folder.png";
                    }
                    else
                    {
                        modeAreaCategoryIcon_f="";
                        modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
                    }
                }
                else if(listText =="Track")
                {
                    modeAreaCategoryIcon_f="";
                    modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
                }
                else
                {
                    if(compareicon !="comparefolder")
                    {
                        modeAreaCategoryIcon_f="";
                        modeAreaCategoryIcon = "/app/share/images/music/list_ico_folder.png";
                    }
                    else
                    {
                        if(compare =="icofoler")
                        {
                            modeAreaCategoryIcon_f="";
                            modeAreaCategoryIcon = "/app/share/images/music/list_ico_folder.png";
                        }
                        else
                        {
                            modeAreaCategoryIcon_f="";
                            modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
                        }
                    }
                }
            }            
            break;
        case "Genre":
            modeAreaCategoryIcon_f =  "";
            if(listText =="Songs"){
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            }else{
                modeAreaCategoryIcon = "/app/share/images/music/list_ico_genre.png";
            }
            break;

            //{changed by junam 2013.11.21 for ISV_NA_90331
        case "Composer":
            modeAreaCategoryIcon_f =  "";
            if(listText =="Composer") modeAreaCategoryIcon = "/app/share/images/music/ico_composer.png";
            else if(listText =="Albums") modeAreaCategoryIcon = "/app/share/images/music/list_ico_album.png";
            else if(listText =="Songs") modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            else modeAreaCategoryIcon = "/app/share/images/music/list_ico_music_list.png";
            break;
            
        case "itunes":
            modeAreaCategoryIcon_f =  "";
            if(listText =="iTunes U") modeAreaCategoryIcon = "/app/share/images/music/ico_itunesu.png";
            else modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            break;

        case "Audiobook":
            modeAreaCategoryIcon_f =  "";
            if(listText =="Audiobooks") modeAreaCategoryIcon = "/app/share/images/music/ico_audio_books.png";
            else modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            break;

        case "Podcast":
            modeAreaCategoryIcon_f =  "";
            if(listText =="Podcasts") modeAreaCategoryIcon = "/app/share/images/music/ico_podcast.png";
            else modeAreaCategoryIcon = "/app/share/images/music/list_ico_song.png";
            break;
            //}changed by junam
        default:
            modeAreaCategoryIcon = "";
            modeAreaCategoryIcon_f = "";
            break;
        }
        __LOG("setCategoryIcon Icon source : " + modeAreaCategoryIcon)
    }
    //}added by aettie.ji 2012.12.20 for new ux

//{added by junam 2013.05.19 for album entry
    function setCurrentCategory( categoryID ) 
    {
        if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
        {
            __LOG("list setCurrentCategory event : categoryId ="+categoryID);
            ipodTab.item.currentCategoryIndex = ipodTab.item.setCurrentCategory(categoryID);
        }
    }
//}added by junam

    // modified by ravikanth 29-06-13 for ITS 0176909
    signal initiateCopyStart()

    function startCopy()
    {
        initiateCopyStart()
    }

    // modified by ravikanth for ITS 0188110
    function resetSelectAllItems()
    {
        __LOG("resetSelectAllItems List View");
        mediaPlayer.isAllItemsSelected = false
        if(mediaPlayer.modeAreaText != QT_TR_NOOP("STR_MEDIA_LIST_MENU"))
        {
            mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")";
        }
    }

//}modified by HWS 2013.03.24 for New UX
//{modified by aettie.ji 20130904 for gracenote logo
    states: [
        State
        {
            name: "jukebox"
            PropertyChanges { target: jukeboxTab; visible: true}
            PropertyChanges { target: prBar; nShortSize: 0 }
            PropertyChanges { target: prBar; visible: true}
            PropertyChanges { target: mediaPlayer; focus: true}
            PropertyChanges { target: modeAreaWidget; modeAreaModel: mode_area_model}//added by aettie.ji 2013.01.09
            PropertyChanges { target: modeAreaListModel; rb_visible: true}
            PropertyChanges { target: modeAreaMenuModel; mb_visible: true} // added by minho 20120821 for NEW UX: Added menu button on ModeArea
            PropertyChanges { target: playbackControls; visible: albumView.visible}
            PropertyChanges { target: albumBTView; visible: false} // added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
            PropertyChanges { target: albumView; gracenote_logo_visible: true}

            PropertyChanges { target: mode_area_model; right_text_visible: true}
            PropertyChanges { target: iPod3rdPartyTxt; visible: false}

            //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            PropertyChanges { target: mode_area_model; rb_visible: true}
            PropertyChanges { target: mode_area_model; mb_visible: true}
            PropertyChanges { target: iPodNoMediaFileText; visible: false}
            //end of Hyundai Spec Change
        },
        State
        {
            name: "usb"
            PropertyChanges { target: jukeboxTab; visible: true}
            PropertyChanges { target: prBar; nShortSize: 0 }
            PropertyChanges { target: prBar; visible: true}
            PropertyChanges { target: mediaPlayer; focus: true}
            PropertyChanges { target: modeAreaWidget; modeAreaModel: mode_area_model}////added by aettie.ji 2013.01.09
            PropertyChanges { target: modeAreaListModel; rb_visible: true}
            PropertyChanges { target: modeAreaMenuModel; mb_visible: true} // added by minho 20120821 for NEW UX: Added menu button on ModeArea
            PropertyChanges { target: playbackControls; visible: albumView.visible}
            PropertyChanges { target: albumBTView; visible: false} // added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
            PropertyChanges { target: albumView; gracenote_logo_visible: true}
            PropertyChanges { target: mode_area_model; right_text_visible: true}
            PropertyChanges { target: iPod3rdPartyTxt; visible: false}

			//Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            PropertyChanges { target: mode_area_model; rb_visible: true}
            PropertyChanges { target: mode_area_model; mb_visible: true}
            PropertyChanges { target: iPodNoMediaFileText; visible: false}
            //end of Hyundai Spec Change
        },
        State
        {
            name: "disc"
            PropertyChanges { target: discTab; visible: true}
            PropertyChanges { target: prBar; nShortSize: 0 }
            PropertyChanges { target: prBar; visible: /*AudioController.DiscType == MP.DVD_AUDIO ? false :*/ true} // modified by cychoi 2015.06.03 for Audio/Video QML optimization
            PropertyChanges { target: mediaPlayer; focus: true}
            PropertyChanges { target: modeAreaWidget; modeAreaModel: mode_area_model}////added by aettie.ji 2013.01.09
            PropertyChanges { target: mode_area_model; rb_visible: true; bDisabled: AudioController.DiscType != MP.MP3_CD ? false:  isMP3CDReadComplete ? false:true }// added by yongkyun.lee 20130413 for : NO CR MP3 List // modified by eunhye 2013.04.23
            PropertyChanges { target: modeAreaListModel; rb_visible: true}
            PropertyChanges { target: modeAreaMenuModel; mb_visible: true} // added by minho 20120821 for NEW UX: Added menu button on ModeArea
            PropertyChanges { target: albumView; visible: /*AudioController.DiscType == MP.DVD_AUDIO ? false :*/ true} // modified by cychoi 2015.06.03 for Audio/Video QML optimization
            PropertyChanges { target: coverCarousel; visible: false}
            PropertyChanges { target: prBar; btextVisible: false}
            PropertyChanges { target: playbackControls; visible:true}
            PropertyChanges { target: albumBTView; visible: false} // added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
            PropertyChanges { target: albumView; gracenote_logo_visible: /*AudioController.DiscType == MP.DVD_AUDIO ? false:*/ true} // modified by cychoi 2015.06.03 for Audio/Video QML optimization
            PropertyChanges { target: mode_area_model; right_text_visible: true}
            PropertyChanges { target: iPod3rdPartyTxt; visible: false}

			//Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            PropertyChanges { target: mode_area_model; mb_visible: true}
            PropertyChanges { target: iPodNoMediaFileText; visible: false}
            //end of Hyundai Spec Change
        },
        State
        {
            name: "ipod"
            PropertyChanges { target: ipodTab; visible: true}
            PropertyChanges { target: prBar; nShortSize: 0 }

            ////Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            //PropertyChanges { target: prBar; visible: true}//2015.12.21

            PropertyChanges { target: mediaPlayer; focus: true}
            PropertyChanges { target: modeAreaWidget; modeAreaModel: mode_area_model}////added by aettie.ji 2013.01.09

            //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            //PropertyChanges { target: mode_area_model; rb_visible: AudioController.isBasicControlEnableStatus} //added by junam 2013.07.30 for music app list button

            PropertyChanges { target: modeAreaListModel; rb_visible: true}
            PropertyChanges { target: modeAreaMenuModel; mb_visible: true} // added by minho 20120821 for NEW UX: Added menu button on ModeArea

            //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            //PropertyChanges { target: playbackControls; visible: albumView.visible}

            PropertyChanges { target: albumBTView; visible: false} // added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
            PropertyChanges { target: albumView; gracenote_logo_visible: false}

            //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            //PropertyChanges { target: mode_area_model; right_text_visible: true}
            //PropertyChanges { target: iPod3rdPartyTxt; visible: false}
            //end of Hyundai Spec Change
        },
        State
        {
            name: "bluetooth"
            PropertyChanges { target: prBar; visible: false}
            PropertyChanges { target: mediaPlayer; focus: true}
            PropertyChanges { target: albumBTView; visible: true} // modified by eunkoo 2012.07.26 for CR11898
            PropertyChanges { target: coverCarousel; visible: false} // modified by Radhakrushna 2012.08.24 for CR12716
            // added by minho 20121115 for removed list button on BT
            PropertyChanges { target: modeAreaWidget; modeAreaModel: mode_area_model}
            PropertyChanges { target: mode_area_model; rb_visible: false}
            // added by minho
            PropertyChanges { target: modeAreaMenuModel; mb_visible: true} // added by minho 20120821 for NEW UX: Added menu button on ModeArea
            PropertyChanges { target: playbackControls; visible: mediaPlayer.isAvaiableBTControl?true:false}//modified by edo.lee for New UX Music(LGE) #43            
            //PropertyChanges { target: view_count; visible: false}  //deleted by aettie for New UX 2013.04.01
            PropertyChanges { target: albumView; visible: false} // modified by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
            //PropertyChanges { target: textDVDAudioInfo; visible: false} // commented by cychoi 2015.06.03 for Audio/Video QML optimization // added by kihyung 2012.08.30 for DVD-Audio
	    //modified for gracenote logo spec changed 20131008
            PropertyChanges { target: mode_area_model; right_text_visible: false} //added by yungi 2013.04.15 for ISV_KR 79925 [C]
            PropertyChanges { target: iPod3rdPartyTxt; visible: false}

            //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            PropertyChanges { target: mode_area_model; mb_visible: true}
            PropertyChanges { target: iPodNoMediaFileText; visible: false}
            //end of Hyundai Spec Change
         },
        State
        {
            name: "aux"
            PropertyChanges { target: auxTab; visible: true}
            PropertyChanges { target: prBar; visible: false}
            PropertyChanges { target: mediaPlayer; focus: true}
            PropertyChanges { target: playbackControls; visible:false}
            //{ modified by Michaele.Kim 2013.08.30 for ITS 186913
            PropertyChanges { target: playbackControls; enabled:false}
            //} modified by Michaele.Kim 2013.08.30 for ITS 186913
            PropertyChanges { target: modeAreaWidget; modeAreaModel: mode_area_model}
            PropertyChanges { target: mode_area_model; rb_visible: false}
            PropertyChanges { target: mode_area_model; mb_visible: true}
            PropertyChanges { target: albumView; visible: false}
            PropertyChanges { target: coverCarousel; visible: false}
            PropertyChanges { target: albumBTView; visible: false} // added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
            //PropertyChanges { target: textDVDAudioInfo; visible: false} // commented by cychoi 2015.06.03 for Audio/Video QML optimization // added by kihyung 2012.08.30 for DVD-Audio
	    //modified for gracenote logo spec changed 20131008
            PropertyChanges { target: mode_area_model; right_text_visible: false} //added by yungi 2013.04.06 for No CR  display song count Mode Area
            PropertyChanges { target: iPod3rdPartyTxt; visible: false}

            //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            PropertyChanges { target: iPodNoMediaFileText; visible: false}
        },
        State
        {
            name: "listView"
            PropertyChanges { target: coverCarousel; visible: false}
            PropertyChanges { target: listView_loader.item; visible: true}
            PropertyChanges { target: prBar; visible: false}
            //PropertyChanges { target: prBar; btextVisible: true} //removed by junam 2013.12.09 for ITS_NA_212868
            PropertyChanges { target: modeAreaWidget; modeAreaModel: modeAreaListModel}
            PropertyChanges { target: mediaPlayer; focus: true}
            PropertyChanges { target: playbackControls; visible:false}
            PropertyChanges { target: albumView; visible: false}
            PropertyChanges { target: modeAreaListModel; rb_visible: false}
            PropertyChanges { target: modeAreaMenuModel; mb_visible: true} // added by minho 20120821 for NEW UX: Added menu button on ModeArea
            //PropertyChanges { target: view_count; visible: false}  //deleted by aettie for New UX 2013.04.01
            PropertyChanges { target: albumBTView; visible: false} // added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
            //PropertyChanges { target: textDVDAudioInfo; visible: false} // commented by cychoi 2015.06.03 for Audio/Video QML optimization // added by kihyung 2012.08.30 for DVD-Audio
	    //modified for gracenote logo spec changed 20131008

            //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            PropertyChanges { target: iPodNoMediaFileText; visible: false}
            PropertyChanges { target: iPod3rdPartyTxt; visible: false}
            //end of Hyundai Spec Change
        },
//{removed by junam 2013.09.23 for not using code
//        State
//        {
//            name: "mltView"
//            PropertyChanges { target: coverCarousel; visible: false}
//            PropertyChanges { target: mlt_screen_loader.item; visible: true}
//            PropertyChanges { target: prBar; visible: false}
//            PropertyChanges { target: modeAreaWidget; modeAreaModel: mltModeAreaModel}
//            PropertyChanges { target: albumView; visible: false}
//            PropertyChanges { target: mediaPlayer; focus: true}
//            PropertyChanges { target: playbackControls; visible:false}
//            PropertyChanges { target: modeAreaListModel; rb_visible: false}
//            PropertyChanges { target: modeAreaMenuModel; mb_visible: true} // added by minho 20120821 for NEW UX: Added menu button on ModeArea
//            //PropertyChanges { target: view_count; visible: false}  //deleted by aettie for New UX 2013.04.01
//            PropertyChanges { target: albumBTView; visible: false} //added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
//            PropertyChanges { target: textDVDAudioInfo; visible: false} // added by kihyung 2012.08.30 for DVD-Audio
//            //PropertyChanges { target: gracenote_logo_item; visible: false} // added by kihyung 2012.08.29
//            PropertyChanges { target: mediaPlayer; gracenote_logo_visible: false}
//        },
//        State
//        {
//            name: "searchView"
//            PropertyChanges { target: coverCarousel; visible: false}
//            PropertyChanges { target: searchView_loader.item; visible: true}
//            PropertyChanges { target: prBar; visible: false}
//            PropertyChanges { target: albumView; visible: false}
//            PropertyChanges { target: modeAreaWidget; modeAreaModel: modeAreaSearchModel}
//            PropertyChanges { target: mediaPlayer; focus: true}
//            PropertyChanges { target: playbackControls; visible:false}
//            //PropertyChanges { target: view_count; visible: false}  //deleted by aettie for New UX 2013.04.01
//            PropertyChanges { target: albumBTView; visible: false} // added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
//            PropertyChanges { target: textDVDAudioInfo; visible: false} // added by kihyung 2012.08.30 for DVD-Audio
//            //PropertyChanges { target: gracenote_logo_item; visible: false} // added by kihyung 2012.08.29
//            PropertyChanges { target: mediaPlayer; gracenote_logo_visible: false}
//        },
//        State
//        {
//            name: "keypad"
//            PropertyChanges { target: coverCarousel; visible: false }
//            PropertyChanges { target: albumView; visible: false }
//            PropertyChanges { target: prBar; visible: false }
//            PropertyChanges { target: prBar; btextVisible: false }
//            PropertyChanges { target: modeAreaWidget; modeAreaModel: modeAreaListModel }
//            PropertyChanges { target: mediaPlayer; focus: true }
//            PropertyChanges { target: playbackControls; visible: false }
//            PropertyChanges { target: modeAreaListModel; rb_visible: false }
//            PropertyChanges { target: modeAreaListModel; mb_visible: false } // added by minho 20121108 for Remove menu button when enabled keypad.
//            PropertyChanges { target: modeAreaListModel; right_text_visible: false } // added by minho 20121122 for Remove total count on modearea when entered keypad screen.
//           // PropertyChanges { target: view_count; visible: false }  //deleted by aettie for New UX 2013.04.01
//            PropertyChanges { target: textDVDAudioInfo; visible: false} // added by kihyung 2012.08.30 for DVD-Audio
//            //PropertyChanges { target: gracenote_logo_item; visible: false} // added by kihyung 2012.08.29
//            PropertyChanges { target: mediaPlayer; gracenote_logo_visible: false}
//        },
//}removed by junam
        State
        {
            name: "default"
        }
    ]
//}modified by aettie.ji 20130904 for gracenote logo
    onStateChanged: EngineListener.stateUI = state; // added by junam 2012.12.10 for CR16482

    /*
    function resetRepeatOne()
    {
        if (AudioController.getRepeatMode() == MP.REPEATFILE)
        {
            __LOG("Reset RepeatOne state");
            AudioController.setRepeatRandomMode(MP.REPEATALL, -1);
        }
    }
    */

    function startPlay()
    {
        __LOG( "startPlay() is called" );
        prBar.nCurrentTime = 0;
        AudioController.resetRepeatOne();// mediaPlayer.resetRepeatOne(); // modofied by eugeny - 12-09-15
        EngineListener.Play();//resume(); //20131016 del function in qml

    }
/*
    function resume()
    {
        // __LOG ("resume() start");
        EngineListener.Play();
    }

    function stop()
    {
        // __LOG ("stop()");
        EngineListener.Stop();
    }

    function pause()
    {
        // __LOG ("pause()");
        EngineListener.Pause();
    }

    //{ added by hyochang.ryu 20130517
    function toggle()
    {
        EngineListener.Toggle();
    }

    //} added by hyochang.ryu 20130517

    //{ added by hyochang.ryu 20130705
    function resumeBT()
    {
        EngineListener.ResumeBT();
    }
    //} added by hyochang.ryu 20130705
*/
    function previousTrack (isDirectPrev)
    {
        // __LOG ("previousTrack()");
        AudioController.isEnableErrorPopup = false
        AudioController.resetRepeatOne();//mediaPlayer.resetRepeatOne();
        EngineListener.PrevTrack(isDirectPrev);
    }   

    function nextTrack ()
    {
        // __LOG ("nextTrack()");
        AudioController.isEnableErrorPopup = false
        AudioController.resetRepeatOne();//mediaPlayer.resetRepeatOne();
        EngineListener.NextTrack();
    }
/*
    function tuneWheel(tuneForward)
    {
       EngineListener.tuneWheel(tuneForward) ;
    }

    function switchToTuned()
    {
        EngineListener.switchToTuned();
    }
*/
    // { added by wonseok.heo 2013.07.04 disc in out test
    function discTestModeOff(){


        mediaPlayer.testStatus = "-";
        isPassfail.text = "-"
        mediaPlayer.testDiscStatus = "Please insert CDDA Disc";
        mediaPlayer.discErrorChk =0;
        mediaPlayer.discStatus = 0;
        mediaPlayer.pStatus = 0;
        mediaPlayer.testTrackNumber = "";
        mediaPlayer.entryTestMod = 0;
        mediaPlayer.lastRandom = 0;
        mediaPlayer.lastRepeat = 0;
        EngineListenerMain.qmlLog("EngineListener.testModeOff();");
        EngineListener.testModeOff();
    }
    function discTestModeOn(){
        EngineListenerMain.qmlLog("EngineListener.testModeOn(); ");

        EngineListener.testModeOn();
    }

    // } added by wonseok.heo 2013.07.04 disc in out test

//{removed by junam 2013.09.23 for not using code
//    function startMLT()
//    {
//        EngineListenerMain.qmlLog("startMLT AudioController.isPlayFromMLT = " + AudioController.isPlayFromMLT)
//        if(!AudioController.isPlayFromMLT)
//        {
//            EngineListener.requestMLTList();
//        }
//        else
//        {
//            EngineListener.pushScreen( mediaPlayer.state );
//            mlt_screen_loader.source = "DHAVN_MoreLikeThis.qml";
//            mlt_screen_loader.parent = mainViewArea;
//            mlt_screen_loader.item.width = mlt_screen_loader.parent.width;
//            mlt_screen_loader.item.height = mlt_screen_loader.parent.height;
//            mediaPlayer.state = "mltView";
//            mediaPlayer.setDefaultFocus(); //added by yungi 2013.03.23 ISV76941
//        }
//        EngineListener.setMltState(true);// added by edo.lee 2013.07.07
//    }
//}removed by junam
    
    // { modified by Sergey 02.08.2103 for ITS#181512
    function showOptionMenu()
    {
        __LOG("showOptionMenu");
        if (popup_loader.visible == false)
        {
            //{changed by junam 2013.06.28 for ISV86231
            //EngineListener.onTuneTimerStopByMenu();//modified by edo.lee 2013.04.05 78867
            EngineListener.tuneEnabled = false;
            //}changed by junam

	    //{changed by junam 2013.09.07 for ITS_KOR_185529
            //EngineListener.isSeekHardKeyPressed = false
            EngineListener.isNextHardKeyPressed = false;
            EngineListener.isPrevHardKeyPressed = false;
            //}changed by junam

            // AudioController.cancelFFRW(); // modified by Dmitry DUAL_KEY
            if(mediaPlayer.state == "listView") // modified for ITS 0207903
            {
                listView_loader.item.cancelScroll();
            }

            //if(mediaPlayer.state != "searchView") //removed by junam 2013.09.23 for not using code
            {
                if(optionMenuLoader.status == Loader.Ready)
                {
                    if (!optionMenuLoader.item.visible)
                    {
// modified by Dmitry 13.08.13 for ITS0183710
                        optionMenuLoader.item.visible = true
                        optionMenuLoader.item.showFocus(); //added by aettie 20131016 menu focus 
                        optionMenuLoader.item.menuHandler();
                        optionMenuLoader.item.showMenu()
                        tmp_focus_index = LVEnums.FOCUS_OPTION_MENU
                        modeAreaMenuInfoText = "";
                    }
                }
                else
                {
                    optionMenuLoader.source = "DHAVN_AppMediaPlayer_OptionMenu.qml";
                }
            }
        }
    }
    // } modified by Sergey 02.08.2103 for ITS#181512

    signal changeHighlight( int arrow, int status, int repeat) //changed by junam 2013.11.13 for add repeat
    signal signalSetFocus()
    signal signalJogWheel( int arrow )
    signal clearPlaybackControlsJog()

    onTmp_focus_indexChanged:
    {
        __LOG("onTmp_focus_indexChanged: focus_index: " + focus_index + ", tmp_focus_index: " + tmp_focus_index);
        //[KR][ITS][183091][comment](aettie.ji) 20130809
        if (focus_index == LVEnums.FOCUS_PLAYBACK_CONTROL && tmp_focus_index != LVEnums.FOCUS_PLAYBACK_CONTROL)
        {
            clearPlaybackControlsJog();
        }

        if (tmp_focus_index != LVEnums.FOCUS_NONE)
        {
            focus_index = tmp_focus_index;
        }
        
        // { added by junggil 2012.07.26 for CR11681
        // Not able to stop scan using CCP/RRC
        if (tmp_focus_index == LVEnums.FOCUS_PLAYBACK_CONTROL)
        {
            EngineListener.setFocusPlaybackControl(true);
            playbackControls.isCommonJogEnabled = true; // added by sangmin.seol ITS_0219026
        }
        else
        {
            EngineListener.setFocusPlaybackControl(false);
//{ modified by Michaele.Kim 2013.08.30 for ITS 186913
            if(mediaPlayer.state == "aux")
                modeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
//} modified by Michaele.Kim 2013.08.30 for ITS 186913
        }
        // } add by junggil
    }

    // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
    Image
    {
        id: main_bg_image

        anchors.fill: parent

        source:
        {
            if (mediaPlayer.state == "listView" )
            {
                return RES.const_APP_MUSIC_PLAYER_URL_IMG_GENERAL_BACKGROUND_1;
            }
            else if (!albumView.visible && !albumBTView.visible && !auxTab.visible)
            {
                return "";
            }
            else if (coverCarousel.visible)
            {
                return "";
            }
            else
            {
                return RES.const_APP_MUSIC_PLAYER_URL_IMG_GENERAL_BACKGROUND_5;
            }
        }
    }

    Image
    {
        id: coverflow_bg_image

        anchors.fill: parent

        source:
        {
            if (mediaPlayer.state == "listView" )
            {
                return "";
            }
            else if (!albumView.visible && !albumBTView.visible && !auxTab.visible)
            {
                return RES.const_APP_MUSIC_PLAYER_URL_IMG_GENERAL_BACKGROUND_3;
            }
            else if (coverCarousel.visible)
            {
                return RES.const_APP_MUSIC_PLAYER_URL_IMG_GENERAL_BACKGROUND_3;
            }
            else
            {
                return "";
            }
        }
    }
    // } modified by cychoi 2015.06.03

    //moved by aettie.ji 2013.03.11
     Image
    {
        id: bg_bottom
        source: "/app/share/images/music/bg_basic_bottom.png"
        //visible: (albumView.visible || albumBTView.visible) //modified by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
        visible: (albumView.visible || albumBTView.visible||coverCarousel.visible) //modified by aettie.ji 2013.03.14 for New UX 
        anchors.bottom: parent.bottom
    }
    //moved by aettie.ji 2013.03.11

// { removed by kihyung 2012.12.15 for STATUSBAR_NEW
/*
//        QmlStatusBarWidget
//        {
//            id: annun

//            focus_id: LVEnums.FOCUS_STATUS_BAR
//            isMenuBtnVisible: false
//            isHomeBtnVisible : true //added by eunhye 2012.08.21 for DH_SW 0137741
//            focus_visible: (mediaPlayer.focus_index == LVEnums.FOCUS_STATUS_BAR)

//            onLostFocus:
//            {
//                __LOG("StatusBarWidget onLostFocus");
//                tmp_focus_index = modeAreaWidget.setDefaultFocus(arrow);
//            }
//        }
*/
// } removed by kihyung 2012.12.15 for STATUSBAR_NEW

	//modified by edo.lee 2013.04.04
	QmlStatusBar {
		id: statusBar
		x: 0; 
		y: 0;
                z: 0
		width: 1280; 
		height: 93;
		homeType: "button"
		middleEast: EngineListenerMain.middleEast //[ME][ITS][177647][minor](aettie.ji)
	}


    QmlModeAreaWidget
    {
        id: modeAreaWidget

        visible: true //added by wonseok.heo 2013.07.04 disc in out test

        y: 93
        z: 0

        focus_id: LVEnums.FOCUS_MODE_AREA
        focus_visible: (mediaPlayer.focus_index == focus_id) &&  AudioController.isForeground // modified for ITS 0193803, added isForeground check
         isAVPMode: true // DUAL_KEY
        modeAreaModel: mode_area_model
        is_MP3CDReadComplete: mode_area_model.bDisabled//added by eunhye 2013.04.23
        isSameScreem:isFrontView == mediaPlayer.isCurrentFrontView

        mirrored_layout: EngineListenerMain.middleEast        //added by aettie 20130514 for mode area layout mirroring
        bAutoBeep: false // added by Sergey 19.11.2013 for beep issue
        onBeep: EngineListenerMain.ManualBeep(); // added by Sergey 19.11.2013 for beep issue
        onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

        property bool modeArea_highlited: false
        property bool tabBackSwitched: false //Added by Alexey Edelev 2012.09.06. CR 9413
        //property bool btTab: false  //Removed by Radhakrushna 2012.25.12. CR 16680

        //{Added by Radhakrushna 20121009 cr 14261
        function deactivateTab(tabId)
        {
            mode_area_model.set(tabId, {"isVisible": false});
        }
        //}Added by Radhakrushna 20121009 cr 14261

        Connections
        {
            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
            target: (modeAreaWidget.focus_visible && isFrontView == mediaPlayer.isCurrentFrontView) ? /*UIListener*/EngineListener : null //DUAL_KEY
            //target: (modeAreaWidget.focus_visible && !popup.visible && isFrontView == mediaPlayer.isCurrentFrontView) ? /*UIListener*/EngineListener : null //DUAL_KEY
            // } modified by cychoi 2015.06.03

            onSignalJogNavigation:
            {

                /**
                 * If status bar is focused on the right button ("Search"),
                 * on the left handling focus should be moved to "SearchBox" element.
                 */
                //{ added by yongkyun.lee 20130214 for : ISV 70301
                if(modeAreaWidget.focus_index <= 0)
                    modeAreaWidget.focus_index = 11;
                //} added by yongkyun.lee 20130214 
//{removed by junam 2013.09.23 for not using code                
//                if (modeAreaWidget.focus_visible &&
//                   (modeAreaWidget.focus_index) == 1 &&
//                    arrow == UIListenerEnum.JOG_LEFT &&
//                    mediaPlayer.state == "searchView" &&
//                    status == UIListenerEnum.KEY_STATUS_RELEASED) // removed by Dmitry 15.05.13
//                {
//                    tmp_focus_index = mainViewArea.setDefaultFocus(arrow);
//                }
//}removed by junam
                //added by edo.lee 2013.03.30
                __LOG("modeAreaWidget:onSignalJogNavigation"+ modeAreaWidget.focus_index);
                if(modeAreaWidget.focus_index == 13)
                {
                    if ( arrow == UIListenerEnum.JOG_CENTER && status == UIListenerEnum.KEY_STATUS_RELEASED ) // removed by Dmitry 15.05.13
                    {
                        __LOG("Back_key: setIsBackPressByJog true");
                        EngineListener.setIsBackPressByJog(true);
                    }
                    else if ( arrow == UIListenerEnum.JOG_DOWN && status == UIListenerEnum.KEY_STATUS_PRESSED
                             && (AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                             && ( EngineListenerMain.getisBTCall())
                             )
                    {
                        AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE) // ITS 248653
                    }
                }

            }
        }
//{ Removed by Radhakrushna 2012.25.12. CR 16680
//        onBtTabChanged:
//        {
//            __LOG("btTab is changed : " + btTab);
//            mode_area_model.set(6,{"isVisible": modeAreaWidget.btTab})
//        }
//} Removed by Radhakrushna 2012.25.12. CR 16680
        onLostFocus:
        {
            __LOG("modeAreaWidget onLostFocus");

            if (arrow == UIListenerEnum.JOG_DOWN)
            {
                mediaPlayer.setDefaultFocus(); // modified by Dmitry 17.05.13
                setEmptyMusicListFocus(); // added by Michael.Kim 2014.02.25 for ITS 226690
            }
            else if (arrow == UIListenerEnum.JOG_UP)
            {
                tmp_focus_index = modeAreaWidget.setDefaultFocus(arrow);
            }
            else
            {
                if( ( arrow == UIListenerEnum.JOG_WHEEL_RIGHT || arrow == UIListenerEnum.JOG_WHEEL_LEFT ) &&
                    ( mediaPlayer.focus_index == LVEnums.FOCUS_MODE_AREA ) )
                    return;
                mediaPlayer.setDefaultFocus();
            }
        }

        onModeArea_BackBtn:
        {
            __LOG("QmlModeAreaWidget: onModeArea_BackBtn : "+isFrontView);//mediaPlayer.isCurrentFrontView); //modified by edo.lee 2013.06.07
            //EngineListener.setIsFrontView(mediaPlayer.isCurrentFrontView);//remove by edo.lee 2013.03.21
            __LOG("Back_key: setIsBackPressByJog ="+isJogDial);
            EngineListener.setIsBackPressByJog(isJogDial); //added by aettie 20130620 for back key event
            if (optionMenuLoader.status == Loader.Ready && optionMenuLoader.item.visible)//ys-20130910 ITS-0189177
                closeOptionMenu();
            else
                mediaPlayer.loadView(true, bRRC); //modified by aettie 20130620 for back key event            

//{ Removed 2014.02.24 UX review
//            if(mediaPlayer.state == "listView") // ys-20130910 ITS 0188282
//                mediaPlayer.setDefaultFocus();//added by edo.lee 2013.04.14
//} Removed 2014.02.24 UX review
        }

        onModeArea_RightBtn:
        {
            if(AudioController.isControllerDisable(MP.CTRL_DISABLE_LIST))//changed by junam 2013.07.12 for music app
                return;
    
            mode_area_model.bDisabled = true;//added by junam 2013.10.19
            mode_area_model.bDisabled = false; // added by Sergey 01.11.2013 for ITS#205803
            closeOptionMenu(true) // modified by Dmitry 24.08.13 for ITS0186085

            //Commented out by Tan.
            //Go to any audio, using ccp, click list and quickly turn jog right,
            //Defect: Crash.
            //RCA: the unblock UI created an event loop, causing event to be received
            //even before the startFileList is executed.
            //ITS191449 will have to be solved by other means.
            //EngineListenerMain.unblockUI() // added by Sergey 2013.09.26 for ITS#191449
            EngineListenerMain.repaintUI(); // added by Sergey 01.11.2013 for ITS#205803
            EngineListenerMain.repaintUI(); // added by Sergey 01.11.2013 for ITS#205803

            EngineListener.onTuneTimerStop() //added by junam 2013.08.15 for ITS_KOR_184145

            EngineListener.isNextHardKeyPressed = false;
            EngineListener.isPrevHardKeyPressed = false;
            //}changed by junam
            AudioController.cancelFFRW();

            //mediaPlayer.restoreSavedCategoryTab(); //removed by junam 2013.12.30 for LIST_ENTRY_POINT
            //}changed by junam

            if( mediaPlayer.state != "listView") //added by junam 2013.10.19
            {
                //{changed by junam 2013.12.19 for LIST_ENTRY_POINT
                //startFileList();
                EngineListener.showListView(true);
                //}changed by junam
            }
            //mode_area_model.bDisabled = false;//added by junam 2013.10.19 // commented by Sergey 01.11.2013 for ITS#205803
        }

        onModeArea_MenuBtn:
        {
            // { rollback by 2014.04.01 oseong.kwon for ITS 232921 // { modified by oseong.kwon 2014.01.27 for ITS 222710
            //if(playbackControls.isBtMusic != true)
            //{
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_MENU))//changed by junam 2013.07.12 for music app
                    return;
            //}
            // } rollback by oseong.kwon 2014.04.01 // } modified by oseong.kwon 2014.01.27

            AudioController.invokeMethod(mediaPlayer, "showOptionMenu");
        }

        onModeArea_Tab:
        {
            __LOG("QmlModeAreaWidget: onModeArea_Tab START " + mediaPlayer.state + "->" + tabId);
			isAvaiableBTControl = EngineListener.getIsRemoteCtrl();//added by edo.lee 2013.02.01
            /*if (tabId == "Bluetooth" &&  !mediaPlayer.isAvaiableBTControl) //remove by edo.lee 2013.02.14
                btmusic_nocontrol_info.visible = true
            else
                btmusic_nocontrol_info.visible = false*/

            if (modeAreaWidget.tabBackSwitched)
            {
	    	//{added by aettie 2013.04.02 for QA
                __LOG("onModeArea_Tab(): ________________ERROR __________________");
                __LOG("onModeArea_Tab(): modeAreaWidget.tabBackSwitched");

                modeAreaWidget.tabBackSwitched = false;
                tabId = "";
	    	//}added by aettie 2013.04.02 for QA
                return;
            }
            
            // { added by kihyung 2013.2.12 for MEDIA HK Crash
            if (AudioController.isSourceChanged == false)
            {
                __LOG("onModeArea_Tab(): ________________ERROR __________________");
                __LOG("onModeArea_Tab(): AudioController.isSourceChanged is false");
                return;
            }
            // } added by kihyung 2013.2.12 for MEDIA HK Crash

            if (!EngineListener.IsSourceAvailable(tabId))
            {
	    	//{added by aettie 2013.04.02 for QA
                __LOG("onModeArea_Tab(): ________________ERROR ------------------ " );
                __LOG("onModeArea_Tab(): Source ids NOT Available " + tabId);
                tabId = "";
	    	//}added by aettie 2013.04.02 for QA
                // { added by dongjin 2012.12.14 for CR16437
                if ( (mediaPlayer.preDisplayMode == MP.UNDEFINED) && (tabId == "Jukebox") )
                {
                    mediaPlayer.preDisplayMode = MP.JUKEBOX;
                }
                // } added by dongjin
                // { modified by edo.lee 2012.11.28  for ISV 64487
                if (AudioController.IsNoSourceByDeviceid(mediaPlayer.preDisplayMode) == false
                || mediaPlayer.preDisplayMode == MP.BLUETOOTH //  added by edo.lee 2012.12.03
                || mediaPlayer.preDisplayMode == MP.AUX)  //  added by edo.lee 2012.12.03 
                {
                    modeAreaWidget.tabBackSwitched = true;
                    modeAreaWidget.currentSelectedIndex = AudioListViewModel.displayMode;
                }
                // { deleted by edo.lee 2012.12.03
                //else
                //{
                //    albumView.sSongName = "";
                //    albumView.sAlbumName = "";
                //    albumView.sArtistName = "";
                //    albumView.sFolderName = "Music";
                //    albumView.sCoverAlbum = "";
                //    albumView.sFilesCount = 0;
                //    emptyText.visible = true;
                //}
                // } modified by edo.lee
                // } deleted by edo.lee
                EngineListenerMain.ManualBeep();
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
		        // modified by minho 20121213 for CR16337 When select jukebox music that has noting using Media hard key, displayed "No File Available"
                popup_loader.showPopup(LVEnums.POPUP_TYPE_NO_MUSIC_FILES);
                //popup.message = noPlayableFileModel;
                //popupTimer.start();
                //popup.setFocus();
                //popup.visible = true;
		        // modified by minho
                // } modified by cychoi 2015.06.03
                return;
            }

            mediaPlayer.enableModeAreaTabs(false); // added by eugeny.novikov 2012.10.25 for CR 14047
            AudioListViewModel.displayMode = modeAreaWidget.currentSelectedIndex;
            mediaPlayer.preDisplayMode = modeAreaWidget.currentSelectedIndex; //added by edo.lee 2012.11.28  for ISV 64487

            //{ modify by wonseok.heo 2013.08.12 for ITS 183728
            if(tabId == "Disc" && AudioController.DiscType == MP.MP3_CD)
                prBar.bPrBarVisible = false;
            else
                prBar.bPrBarVisible = true;
            //} modify by wonseok.heo 2013.08.12 for ITS 183728
            coverCarousel.visible = false;
            //emptyText.visible = false; //deleted by aettie.ji 2013.01.24 for ISV 70695 
            playbackControls.isBtMusic = false; //added by edo.lee 2013.01.14

            //move line after state change
            //closeOptionMenu() // moved by junam 2013.06.12 for mode switch delay

            //modeAreaWidget.isListDisabled = false; //removed by junam 2013.06.05 for unusing code
            if (popup_loader.status == Loader.Ready && popup_loader.item.visible) {
                popup_loader.item.closePopup();
            }   
            // { removed by junam 2013.04.26 for disable list button at sync
            //else if (popup_loader.status == Loader.Ready && popup_loader.popup_type == LVEnums.POPUP_TYPE_IPOD_INDEXING)
            //{
            //    popup_loader.item.closePopup();
            //}
            // } removed by junam
            // { added by kihyung 2013.3.21.
            else if(tabId != "Disc") 
            {
                if(popup_loader.status == Loader.Ready && popup_loader.popup_type == LVEnums.POPUP_TYPE_LOADING_DATA)
                    popup_loader.item.closePopup();
            }
            // } added by kihyung 2013.3.21.   
            closeOptionMenu(true) // added by Dmitry 16.08.13

            mediaPlayer.clearSeekMode(); //added by junam 2012.10.09 for CR14118

            //{changed by junam 2013.08.16 for ITS_KOR_184840
            //prBar.reset();
            prBar.nCurrentTime = 0
            prBar.nTotalTime = AudioController.GetMediaDuration(AudioController.PlayerMode); // added by cychoi 2013.10.08 for ITS 190742 CDDA duration
            prBar.sAlbumName = ""
            prBar.sFilesCount = ""
            //}changed by junam

            prBar.bTuneTextColor = false;
            AudioController.isPlayFromMLT = false;
            EngineListener.tuneReset();
            //mediaPlayer.setDefaultFocus();  //moved by yongkyun.lee 20130423 for : ITS 164532

            jukeboxTab.source = "";
            discTab.source = "";
            ipodTab.source = "";
            auxTab.source = "";

            //{changed by junam 2013.11.06 for coverflow update
            //PathViewModel.firstEntry = true
            PathViewModel.clearModelData();
            //}changed by junam
            AudioListViewModel.folderHistoryStack = -1 // added by Dmitry 21.08.13 for ITS0185511

            switch (tabId)
            {
                case "Jukebox":
                {
                    AudioController.PlayerMode = MP.JUKEBOX;
                    jukeboxTab.source = "DHAVN_JukeboxItem.qml"
                    if (coverCarousel.visible) //added by junam 2013.03.20 for do not request when cover is hidden
                        EngineListener.requestCovers();
                    mediaPlayer.state = "jukebox";

                    if( mediaPlayer.discTestMode != true){ //added by wonseok.heo 2013.07.04 disc in out test

                    albumView.visible = true;
                    albumView.gracenote_logo_visible = true; //added for gracenote logo spec changed 20131008
                    playbackControls.visible = true;
                    //AudioController.isBasicView = true; // removed by sangmin.seol 2014.04.17 unnecessary isBasicView set in onModeArea_Tab
                    } //added by wonseok.heo 2013.07.04 disc in out test
                    //EngineListener.NofityAudioPathChanged(AudioController.PlayerMode);
                    EngineListenerMain.NofityAudioPathChanged(AudioController.PlayerMode);
                    albumBTView.visible = false;
                    coverCarousel.visible = false;
                    prBar.btextVisible = false;
                    playbackControls.isBtMusic = false;	//rollback control_area->playbackControl 20130608 //added by hyochang.ryu 20130528
                    break;
                }

                case "USB1":
                case "USB2":
                {
                    AudioController.PlayerMode = ( tabId == "USB1" ) ? MP.USB1 : MP.USB2;
                    jukeboxTab.source = "DHAVN_JukeboxItem.qml"
                    if (coverCarousel.visible)//added by junam 2013.03.20 for do not request when cover is hidden
                        EngineListener.requestCovers();
                    mediaPlayer.state = "usb";

                    albumView.visible = true;
                    albumView.gracenote_logo_visible = true; //added for gracenote logo spec changed 20131008
                    playbackControls.visible = true
                    //AudioController.isBasicView = true    // removed by sangmin.seol 2014.04.17 unnecessary isBasicView set in onModeArea_Tab
                    //EngineListener.NofityAudioPathChanged(AudioController.PlayerMode);
                    EngineListenerMain.NofityAudioPathChanged(AudioController.PlayerMode);
                    albumBTView.visible = false;
                    coverCarousel.visible = false;
                    prBar.btextVisible = false;
                    playbackControls.isBtMusic = false;	//rollback control_area->playbackControl 20130608 //added by hyochang.ryu 20130528
                    break;
                }

                case "Disc":
                {
                    AudioController.PlayerMode = MP.DISC;

                    if (AudioController.DiscType != MP.AUDIO_CD)
                    {
                        /* next workaround it's necessary for correct update current time. */
                        prBar.nTotalTime = 5000;
                        discTab.source = "DHAVN_DiscItem.qml"

                        // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                        //if (AudioController.DiscType == MP.DVD_AUDIO)
                        //{
                        //    albumView.visible = false;
                        //    textDVDAudioInfo.visible = true;
                        //}
                        //else
                        // } modified by cychoi 2015.06.03
                        {
                            albumView.visible = true;
                            albumView.gracenote_logo_visible = true; //added for gracenote logo spec changed 20131008

                            //textDVDAudioInfo.visible = false; // commented by cychoi 2015.06.03 for Audio/Video QML optimization
                        }

                        // { removed by kihyung 2013.1.4 for ISV 68141
                        /*
                        // { added by lssanh 2012.10.03 for CR9362_r1
                        if (AudioController.DiscType == MP.MP3_CD)
                        {
                            if (popup_loader.status == Loader.Ready && popup_loader.popup_type == LVEnums.POPUP_TYPE_LOADING_DATA)
                            {
                                popup_loader.item.closePopup();
                            }
                            popup_loader.showPopup(LVEnums.POPUP_TYPE_LOADING_DATA);
                        }
                        // } added by lssanh 2012.10.03 for CR9362_r1
                        */
                        // } removed by kihyung 2013.1.4 for ISV 68141
                    }
                    else
                    {
                        if( mediaPlayer.discTestMode != true){ //added by wonseok.heo 2013.07.04 disc in out test

                        albumView.visible = true;
                        } //added by wonseok.heo 2013.07.04 disc in out test
                        discTab.source = "DHAVN_CDDAItem.qml"; // modified by wonseok.heo NOCR for new UX 2013.11.09
                    }

                    prBar.bPrBarVisible = !(AudioController.DiscType == MP.MP3_CD /*||
                                            AudioController.DiscType == MP.DVD_AUDIO*/); // modified by cychoi 2015.06.03 for Audio/Video QML optimization

                    mediaPlayer.state = "disc";
                    albumBTView.visible = false;
                    //EngineListener.NofityAudioPathChanged(AudioController.PlayerMode);
                    EngineListenerMain.NofityAudioPathChanged(AudioController.PlayerMode);
                    coverCarousel.visible = false;
                    prBar.btextVisible = false;
                    playbackControls.isBtMusic = false;	//rollback control_area->playbackControl 20130608 //added by hyochang.ryu 20130528
                    break;
                }

                case "iPod1":
                case "iPod2":
                {
                    AudioController.PlayerMode = ( tabId == "iPod1" ) ? MP.IPOD1 : MP.IPOD2;;
                    ipodTab.source = "DHAVN_iPodItem.qml";
                    if (coverCarousel.visible)//added by junam 2013.03.20 for do not request when cover is hidden
                        EngineListener.requestCovers();
                    mediaPlayer.state = "ipod";

					//Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
                    //albumView.visible = true;
                    //albumView.gracenote_logo_visible = false; //added for gracenote logo spec changed 20131008
                    //playbackControls.visible = true
					//end of Hyundai Spec Change
                    EngineListenerMain.NofityAudioPathChanged(AudioController.PlayerMode);
                    albumBTView.visible = false;

                    coverCarousel.visible = false;
                    prBar.btextVisible = false;
                    playbackControls.isBtMusic = false;	//rollback control_area->playbackControl 20130608 //added by hyochang.ryu 20130528
                    break;
                }

                case "Bluetooth":
                {
                    //2014.10.21 Tan, ITS 0250594
                    //play ipod 3rd party, go to bluetooth audio, go to jukebox,
                    //song index/count does not shown.
                    //Move the mediaPlayer.state = "bluetooth" after set PlayerMode
                    //mediaPlayer.state = "bluetooth"
                    AudioController.PlayerMode = MP.BLUETOOTH;
                    mediaPlayer.state = "bluetooth"
                    EngineListener.setAudioPathRPM();
                    albumView.visible = false;
                    albumBTView.visible = true;
                    playbackControls.visible = mediaPlayer.isAvaiableBTControl;
                    //AudioController.isBasicView = true    // removed by sangmin.seol 2014.04.17 unnecessary isBasicView set in onModeArea_Tab
                    //EngineListener.NofityAudioPathChanged(AudioController.PlayerMode);
                    //EngineListenerMain.NofityAudioPathChanged(AudioController.PlayerMode);
                    coverCarousel.visible = false;
                    prBar.btextVisible = false;
                    mediaPlayer.enableModeAreaTabs(true);
                    playbackControls.isBtMusic = true; //added by edo.lee 2013.01.14
                    playbackControls.setPlayState(); //added by edo.lee 2013.02.01
                    break;
                }

                case "AUX":
                {
                    AudioController.PlayerMode = MP.AUX;
                    auxTab.source = "DHAVN_AUXItem.qml"
                    mediaPlayer.state = "aux";
                    EngineListener.setAudioPathRPM ();
                    //EngineListener.NofityAudioPathChanged(AudioController.PlayerMode);
                    albumView.visible = false;
                    albumBTView.visible = false;
                    coverCarousel.visible = false;
                    prBar.btextVisible = false;
                    mediaPlayer.enableModeAreaTabs(true);
                    playbackControls.isBtMusic = false;	//rollback control_area->playbackControl 20130608 //added by hyochang.ryu 20130528
                    break;
                }

                default:
                {
                    __LOG("Unhandled onModeArea_Tab signal");
                    break;
                }
            }
            //close option model after switch state
// removed by Dmitry 16.08.13

            mediaPlayer.setDefaultFocus(); //moved by yongkyun.lee 20130423 for : ITS 164532      

            //{removed by junam 2013.03.26 for not using anymore
            // { added by wspark 2012.12.05 for ISV64495
            //if(mediaPlayer.state != "jukebox")
            //    emptyText.visible = false;
            // } added by wspark
            //}removed by juanm

            // { deleted by wspark 2013.02.18 for ISV 73389
            /*
            prBar.sMPstate = mediaPlayer.state; //added by changjin 2012.10.29 for ISV 61843
            prBar.bSeekableMedia = AudioController.isSeekableMedia(); //modified by changjin 2012.10.29 for ISV 61843
            */
            // } deleted by wspark

            __LOG("QmlModeAreaWidget: onModeArea_Tab END " + mediaPlayer.state + "->" + tabId);
        }

        // { add by yongkyun.lee@lge.com  2012.10.30 : : CR 13733  : Sound Path
        onModeArea_TabClicked:
        {
            EngineListener.DisplayOSD(true); //{ added by  yongkyun.lee 2012.11.12 for  Check Video/audio OSD
            EngineListener.modeTabClicked (true) ;
        }
        // } add by yongkyun.lee@lge.com

        ListModel
        {
            id: mltModeAreaModel;
            property string text: "";
            property bool text_visible: true;
            property string mode_area_right_text: "";
            property bool right_text_visible:true
            property string icon: "/app/share/images/music/list_ico_song.png" //modified by HWS 2013.03.24 for New UX
        }

        ListModel
        {
            id: modeAreaSearchModel;
            property string text: "";
            property bool text_visible: true;

            property string rb_text: QT_TR_NOOP("STR_MEDIA_SEARCH");
            property bool rb_visible: true;
            // added by minho 20121221 for CR16795 Add to show up Chinese keypad popup in option menu 
            property string mb_text: QT_TR_NOOP("STR_SETTING_SYSTEM_DISPLAY");
            property bool mb_visible: (AudioListViewModel.GetCountryVariant() == 2)? true: false 
            // added by minho 20121221
        }

        ListModel
        {
            id: modeAreaListModel
            property string file_count : ""; // added by yungi 2013.03.06 for New UX FileCount
            property string text;
            property string mode_area_right_text;
//{modified by HWS 2013.03.24 for New UX
            property string mode_area_right_text_f; //added by aettie.ji 2012.12.20 for new ux//HWS
            property bool right_text_visible:true;
            property bool right_text_visible_f:true; //added by aettie.ji 2012.12.20 for new ux//HWS
            //  property bool mode_area_right_folder; //added by aettie.ji 2012.12.20 for new ux
            property string rb_text: QT_TR_NOOP("STR_MEDIA_LIST_MENU");
            property bool rb_visible: true;
            //  property string mode_area_cat_type; //added by aettie.ji 2012.12.20 for new ux

            property string search_text: "";
            property bool search_visible: false;
            property bool text_visible: true;

            property string mb_text: QT_TR_NOOP("STR_SETTING_SYSTEM_DISPLAY");
            property bool mb_visible: (albumBTView.visible ) ? false: true; // modified by yongkyun.lee 2013-07-18 for : ITS 180724

            property string icon: "" //added by aettie.ji 2012.12.20 for new ux//HWS
            property string icon_cat_folder: "" //added by aettie.ji 2012.12.20 for new ux//HWS
//}modified by HWS 2013.03.24 for New UX

        }

        ListModel
        {
            id: modeAreaMenuModel

            property string text;
            property string mode_area_right_menu_text;
            property bool right_text_visible:true
            property string mb_text: QT_TR_NOOP("STR_SETTING_SYSTEM_DISPLAY");
            property bool mb_visible: true;
            property bool text_visible: true;
        }

        ListModel
        {
            id: mode_area_model
	    //{added by aettie 2013.04.01 for New UX  
            property string rb_text: QT_TR_NOOP("STR_MEDIA_LIST_MENU");
            property bool rb_visible: true;
            property bool isTabBtnsDisable: false;
            property bool isMusicState: true;

            property string mb_text: QT_TR_NOOP("STR_SETTING_SYSTEM_DISPLAY");
            property bool mb_visible: true;

            property bool right_text_visible:true;
            property string mode_area_right_text:albumView.sFilesCount;
            property bool bDisabled: false;// added by eunhye 2013.04.23


            property string icon: "/app/share/images/music/list_ico_song.png"
            //property string icon: (albumView.sCategoryId == "Album")? "/app/share/images/music/list_ico_album.png":
            //    (albumView.sCategoryId == "Song")? "/app/share/images/music/list_ico_song.png":
            //    (albumView.sCategoryId == "Play_list") ? "/app/share/images/music/list_ico_music_list.png":
            //    (albumView.sCategoryId == "Genre")? "/app/share/images/music/list_ico_genre.png":
            //    (albumView.sCategoryId == "Folder")?
            //        ((mediaPlayer.state == "disc")? "/app/share/images/music/list_ico_song.png":
            //                "/app/share/images/music/list_ico_folder.png"
            //        )
            //        :"/app/share/images/music/list_ico_song.png"
	    //}added by aettie 2013.04.01 for New UX  	    
            ListElement
            {
                // modified by minho 20121205 for removed tab on modearea.
                // name: "/app/share/images/general/ico_music_tab_jukebox.png"
                // isVisible: true; // mino 0813
                // selected: false;
		//modified by aettie 20130806 for ITS 0182945
                name: QT_TR_NOOP("STR_MEDIA_AUDIO_JUKEBOX")
                isVisible: false; 
                // modified by minho
                tab_id: "Jukebox"
            }
//[KOR][ITS][181982][minor](aettie.ji)
            ListElement
            {
                // modified by minho 20121205 for removed tab on modearea.
                // name: "/app/share/images/general/ico_music_tab_usb.png"
                name: QT_TR_NOOP("STR_MEDIA_AUDIO_USB_FRONT")
                name_fr: "" // added by AVP for VI GUI 2014.04.28
                // modified by minho
                isVisible: false;
                tab_id: "USB1"
            }

            ListElement
            {
                // modified by minho 20121205 for removed tab on modearea.
                // name: "/app/share/images/general/ico_music_tab_usb.png"
                name: QT_TR_NOOP("STR_MEDIA_AUDIO_USB_REAR")
                name_fr: "" // added by AVP for VI GUI 2014.04.28
                // modified by minho
                isVisible: false;
                tab_id: "USB2"
            }

            ListElement
            {
                // modified by minho 20121205 for removed tab on modearea.
                // name: "/app/share/images/general/ico_music_tab_disc.png"
                name: QT_TR_NOOP("STR_MEDIA_DISC")
                // modified by minho
                isVisible: false;
                tab_id: "Disc"
            }

            ListElement
            {
                // modified by minho 20121205 for removed tab on modearea.
                // name: "/app/share/images/general/ico_music_tab_ipod.png"
                name: QT_TR_NOOP("STR_MEDIA_IPOD1")
                name_fr: "" // added by AVP for VI GUI 2014.04.28
                // modified by minho
                isVisible: false;
                tab_id: "iPod1"
            }

            ListElement
            {
                // modified by minho 20121205 for removed tab on modearea.
                // name: "/app/share/images/general/ico_music_tab_ipod.png"
                name: QT_TR_NOOP("STR_MEDIA_IPOD2")
                name_fr: "" // added by AVP for VI GUI 2014.04.28
                // modified by minho
                isVisible: false;
                tab_id: "iPod2"
            }

            ListElement
            {
                // modified by minho 20121205 for removed tab on modearea.
                // name: "/app/share/images/general/ico_music_tab_bt.png"
                //name: QT_TR_NOOP("STR_MEDIA_BLUETOOTH")
                name: QT_TR_NOOP("STR_MEDIA_AUDIO_BLUETOOTH")		//modified by hyochang.ryu for ITS182945->186756 ("Bluetooth"->"Bluetooth Audio")
                // modified by minho
                isVisible: false;
                tab_id: "Bluetooth"
            }

            ListElement
            {
                // modified by minho 20121205 for removed tab on modearea.
                // name: "/app/share/images/general/ico_music_tab_aux.png"
                name: QT_TR_NOOP("STR_MEDIA_AUX")
                // modified by minho
                isVisible: false;
                tab_id: "AUX"
            }

            ListElement
            {
                name: QT_TR_NOOP("AlbumView")
                isVisible: false;
                tab_id: "list_album"
            }
//{moved by aettie 2013.04.01 for New UX  
//            property string rb_text: QT_TR_NOOP("STR_MEDIA_LIST_MENU");
//            property bool rb_visible: true;
//            property bool isTabBtnsDisable: false;
//            property bool isMusicState: true;

  //          property string mb_text: QT_TR_NOOP("STR_SETTING_SYSTEM_DISPLAY");
 //           property bool mb_visible: true;
//}moved by aettie 2013.04.01 for New UX   
        }
    }

    Item
    {
        id: mainViewArea

        anchors
        {
            top: modeAreaWidget.bottom
            left: parent.left
            right: parent.right
        }

        height: MPC.const_APP_MUSIC_PLAYER_MUSIC_CAROUSEL_HEIGHT
        focus_visible: (mediaPlayer.focus_index == focus_id)

        property bool focus_visible
        property int focus_id: LVEnums.FOCUS_CONTENT
	 //{added by aettie 2013.04.01 for ISV 76119
        function setScanIcon(state)
        {
            __LOG("setScanIcon : " + state);
            if (state == 10) 
                scan_item.img_source = "/app/share/images/music/ico_radio_scan.png"
            else scan_item.img_source = "/app/share/images/music/ico_radio_folder_scan.png"
        }
	//} added by aettie 2013.04.01 for ISV 76119
        function setDefaultFocus(arrow)
        {
            __LOG("mainViewArea :: setDefaultFocus : arrow= " + arrow );
            //{ added by yongkyun.lee 20130221 for : : NO CR  , modearea focus
            //if (albumView.visible)
            if (albumView.visible || albumBTView.visible )
            //} added by yongkyun.lee 20130221 
            {
                tmp_focus_index = modeAreaWidget.setDefaultFocus(arrow); // modified by Dmitry 17.05.13
            }
//{removed by junam 2013.09.23 for not using code
//            else if(key_pad_loader.visible)
//            {
//                return key_pad_loader.item.setDefaultFocus(UIListenerEnum.JOG_DOWN);
//            } 
//}removed by junam
            else
            {
                signalSetFocus();
                return focus_id;
            }
        }

// removed by Dmitry 16.05.13

        Item
        {
            id: scan_item
            LayoutMirroring.enabled: EngineListenerMain.middleEast // added by Dmitry 05.05.13

            width: scan_image.width
            height: scan_image.height
            visible: mediaPlayer.bScan && (albumView.visible || coverCarousel.visible) //&& gracenote_logo_item.visible == false
            // { added by yungi 2013.04.09 for ISV_KR 78869
            onVisibleChanged :{
                if(!scan_item.visible) {scan_anim.stop ; scan_image.visible = false}
            }
            // } added by yungi 2013.04.09 for ISV_KR 78869
            anchors.top: parent.top
            anchors.topMargin: 13
            anchors.right: parent.right
            anchors.rightMargin: 15
            z: Math.max(albumView.z, coverCarousel.z) + 1 // modified by Dmitry Bykov 12.04.2013

            property string img_source:""
            
            SequentialAnimation
            {
                id: scan_anim

                loops: Animation.Infinite
                running: mediaPlayer.bScan 

                NumberAnimation
                {
                    target: scan_image
                    property: "visible"
                    from: 0
                    to: 1
                    duration: 500
                }

                NumberAnimation
                {
                    target: scan_image
                    property: "visible"
                    from: 1
                    to: 0
                    duration: 500
                }
            }

            Image
            {
                id: scan_image
                source: scan_item.img_source
                //visible: mediaPlayer.bScan
            }
        }
        // } added by dongjin

//{ modified by junam 2013.09.23 for using loader
        //DHAVN_AppMediaPlayer_SingleRowAlbumView
        Loader
        {
            id: coverCarousel
            visible: false //changed by junam 2013.11.11 for ITS_NA_208040

            //{added by junam 2013.11.01 for focus change
            property int focus_id: LVEnums.FOCUS_CONTENT
            property bool focus_visible: ( mediaPlayer.focus_index == focus_id )
            //}added by junam

            onVisibleChanged : // ITS 188336
            {
                if(visible)
                {
                    mode_area_model.right_text_visible = false;
                    if (status != Loader.Ready)
                        //source = "DHAVN_AppMediaPlayer_SingleRowAlbumView.qml"
                        source = "DHAVN_AppMediaPlayer_CoverflowView.qml"
                }
                else
                {
                    mode_area_model.right_text_visible = true;
                }
            }

            anchors.fill: parent

            // added by Dmitry 29.09.13
            onLoaded:
            {
                prBar.bTuneTextColor = false;
                prBar.sSongName = AudioController.song
                prBar.sArtistName = AudioController.artist
            }
            // added by Dmitry 29.09.13

            Connections
            {
                target: coverCarousel.item
                onLostFocus:
                {
                    __LOG("onLostFocus coverCarousel");
                    if (arrow == UIListenerEnum.JOG_UP)
                    {
                        tmp_focus_index = modeAreaWidget.setDefaultFocus(arrow);
                    }
                    else if (arrow == UIListenerEnum.JOG_DOWN && playbackControls.visible)
                    {
                        tmp_focus_index = playbackControls.setDefaultFocus(arrow);
                    }
                }
                //{removed by junam 2013.12.09 for ITS_NA_212868
                //onSetJoggedCover:
                //{
                //    prBar.bTuneTextColor = c_color;
                //    prBar.sSongName =  (c_album == "Unknown Albums") ? (qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty) : c_album;
                //    prBar.sArtistName =  (c_artist == "Unknown Artists") ? (qsTranslate("main", "STR_MEDIA_UNKNOWN") + LocTrigger.empty) : c_artist;
                // }
                //}removed by junam
            }
        }
//} modified by junam

        DHAVN_AlbumView_basic
        {
            id: albumView
            visible: true;
            gracenote_logo_visible: true; //added for gracenote logo spec changed 20131008

    	    // { added by eugene.seo 2013.03.16
    	    onShowIndexingPopUp:
    	    {
                popup_loader.showPopup(LVEnums.POPUP_TYPE_GRACENOTE_INDEXING);
    	    }
    	    // } added by eugene.seo 2013.03.16			

            // { added by kihyung 2013.4.7 for IPOD
            onShowIPODIndexingPopUp:
            {
                __LOG("MYTEST onShowIPODIndexingPopUp");
                
                popup_loader.showPopup(LVEnums.POPUP_TYPE_IPOD_INDEXING);
    	    }
            // } added by kihyung 2013.4.7 for IPOD            
        }

        //{added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
        //DHAVN_Albumview_BT
        Loader
        {
            id: albumBTView
            visible: false;

            onVisibleChanged : // ITS 188336
            {
                if(visible)
                {

                    if (status != Loader.Ready)
                        source = "DHAVN_Albumview_BT.qml"
                }

            }
        }
        //}added by edo.lee

        // { modified by cychoi 2015.06.03 for Audio/Video QML optimization // { modified by ravikanth - 12-09-24
        // added for flick event on DVD screen
        //Item
        //{
        //    width: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH
        //    height: MPC.const_APP_MUSIC_PLAYER_MUSIC_PATH_VIEW_HEIGHT
        //    MouseArea
        //    {
        //        id: itemMouse_dvdAudio
        //        anchors.fill: parent
        //        beepEnabled: false  //added by edo.lee 2013.01.08
        //        noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445
        //        visible: ( !albumView.visible && !coverCarousel.visible  // add coverCarousel.visible  by ravikanth
        //        && !albumBTView.visible) //modified by edo.lee 2013.01.08

        //        onPressed:
        //        {
        //            mediaPlayer.move_start = true;
        //            offsetX = mouseX;
        //        }

        //        onPositionChanged:
        //        {
        //            //{ added by yungi 2012.11.30 for CR16108
        //            if(popup_loader.status == Loader.Ready && popup_loader.popup_type == LVEnums.POPUP_TYPE_LOADING_DATA)
        //            {
        //                popup_loader.item.closePopup();
        //            }
        //            //} added by yungi 2012.11.30 for CR16108
        //            if ((offsetX - mouseX) >= 100 && mediaPlayer.move_start)
        //            {
        //                mediaPlayer.move_start = false;
        //                if (mediaPlayer.state != "listView")
        //                {
        //                    __LOG("itemMouse_dvdAudio next");
        //                    mediaPlayer.nextTrack();
        //                }
        //            }
        //            else if ((offsetX - mouseX) <= -100 && mediaPlayer.move_start)
        //            {
        //                mediaPlayer.move_start = false;
        //                if (mediaPlayer.state != "listView")
        //                {
        //                    __LOG("itemMouse_dvdAudio previous");
        //                    mediaPlayer.previousTrack(true);
        //                }
        //            }
        //        }
        //    }
        //}
        // } modified by cychoi 2015.06.03 // } modified by ravikanth - 12-09-24

        DHAVN_AudioPlaybackControls // modified by Sergey 24.08.2013 for ITS#185556 
        {
            id: playbackControls

            anchors.top: parent.top
            anchors.topMargin: 294
            //enabled: !EngineListenerMain.isBTCall // modified by edo.lee 2013.06.11

            property int focus_id: LVEnums.FOCUS_PLAYBACK_CONTROL
            property bool focus_visible: (mediaPlayer.focus_index == focus_id)

            /* Add model and properties which are necessary for PlaybackControl -
             * just to prevent qml warnings */
            property string icon_n: ""
            property string icon_p: ""
            property string icon_d: ""
            isAudio: true // added by Dmitry 26.05.13

            property bool bPressed : false; // added by junam 2012.10.30 for CR14512

            ListModel
            {
                id: video_model

                property bool tuneMode: false
                property int playbackStatus: -1
                property string progressBarMode: "Default"
            }

// added by Dmitry 11.09.13
// isCommonJogEnabled just hides focus on playback controls
            onVisibleChanged:
            {
               if (!visible) isCommonJogEnabled = false
               //added by suilyou ITS 0204972 START
               else
                   if(focus_visible)
                       isCommonJogEnabled = true
               //added by suilyou ITS 0204972 END
            }
// added by Dmitry 11.09.13

            function setDefaultFocus(arrow)
            {
                playbackControls.isCommonJogEnabled = true; //added by junam 2012.11.01 for CR15033
                return LVEnums.FOCUS_PLAYBACK_CONTROL; // modified by Dmitry 23.04.13
            }

// modified by Dmitry 16.05.13
            Connections
            {
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                target: (playbackControls.focus_visible
                && isFrontView == mediaPlayer.isCurrentFrontView && AudioController.isForeground) ? /*UIListener*/EngineListener : null
                //target: (playbackControls.focus_visible && !popup.visible
                //&& isFrontView == mediaPlayer.isCurrentFrontView && AudioController.isForeground) ? /*UIListener*/EngineListener : null
                // } modified by cychoi 2015.06.03

                onSignalJogNavigation:
                {                    
                    if( mediaPlayer.discTestMode ==false){ //added by wonseok.heo 2013.07.04 disc in out test
                        __LOG("onSignalJogNavigation playbackControls arrow = " + arrow + " status = " + status );
                        playbackControls.handleJogEvent(arrow, status, bRRC);
                    } //added by wonseok.heo 2013.07.04 disc in out test
                }
            }
// modified by Dmitry 16.05.13
            Connections
            {
                target: (playbackControls.visible // mediaPlayer.state != "listView" && coverCarousel.visible == false // modified by sangmin.seol 2014.12.23 for ITS 254979
                         && isFrontView == mediaPlayer.isCurrentFrontView && AudioController.isForeground) ? EngineListener : null
                onSignalTunePressed:
                {
                    EngineListenerMain.qmlLog("onSignalTunePressed")
                    playbackControls.bTunePressed = true;
                }
                onSignalTuneReleased:
                {
                    EngineListenerMain.qmlLog("onSignalTuneReleased")
                    playbackControls.bTunePressed = false;
                }
                // { DUAL_KEY added for TunePressed Cancel.
                onSignalTuneCanceled:
                {
                    EngineListenerMain.qmlLog("onSignalTuneCanceled")
                    playbackControls.bTunePressed = false;
                }
                // } DUAL_KEY added for TunePressed Cancel.
            }

            Connections
            {
                target: AudioController
                onClearAllJog:
                {
                    playbackControls.clearAllJogs();
                }
            }

            Connections
            {
                target: mediaPlayer

                onClearPlaybackControlsJog:
                {
                    playbackControls.isCommonJogEnabled = false // modified by Dmitry Bykov 07.04.2013 for ISV75839
                    //{changed by junam 2013.09.07 for ITS_KOR_185529
                    //EngineListener.isSeekHardKeyPressed = false
                    EngineListener.isNextHardKeyPressed = false;
                    EngineListener.isPrevHardKeyPressed = false;
                    //}changed by junam
                    playbackControls.clearAllJogs()
                }
            }

            // { changed by junam 2012.09.12 for CR13632
            //onPlay_button_clicked: mediaPlayer.changePlayStatus();
            onPlay_button_clicked:
            {
                EngineListenerMain.qmlLog("DUAL_KEY onPlay_button_clicked ")
                //{ added by hyochang.ryu 20130726 for 181814
                if (mediaPlayer.focus_index != LVEnums.FOCUS_PLAYBACK_CONTROL)
                {
                    mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT	//PLAYBACK_CONTROL
                    mediaPlayer.setDefaultFocus()	//(UIListenerEnum.JOG_DOWN)
                }
                //} added by hyochang.ryu 20130726 for 181814
                EngineListenerMain.qmlLog("DUAL_KEY  if (mediaPlayer.focus_index != LVEnums.FOCUS_PLAYBACK_CONTROL) ")
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;
                EngineListenerMain.qmlLog("DUAL_KEY if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))")
                //{added by junam 2013.08.18 for iPod next crash
                if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                {
                    AudioController.invokeMethod(playbackControls, "doPlayButtonClicked");
                    return;
                }
                //}added by junam
                EngineListenerMain.qmlLog("DUAL_KEY if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)")
                if (!EngineListener.selectTune())
                {
                    EngineListenerMain.qmlLog("DUAL_KEY mediaPlayer.changePlayStatus() ")
                    mediaPlayer.changePlayStatus();
                }
            }
            // } changed by junam

            onPrev_clicked:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;

                //{added by junam 2013.08.18 for iPod next crash
                if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                {
                    AudioController.invokeMethod(playbackControls, "doPrevClicked");
                    return;
                }
                //}added by junam

                __LOG("onPrev_clicked");

                if (AudioController.isLongPress)
                {
                    EngineListener.normalPlay();
                }
                else
                {
                    // { modified by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap & apply prev,next list 3 second rule
                    if(EngineListener.getPrevNextKeySwapState())
                        mediaPlayer.nextTrack();
                    else
                        mediaPlayer.previousTrack(false);

        // added by aettie 2013.08.01 for ITS 0181682
                    /* KEY_SWAP if(mediaPlayer.state == "listView" && AudioController.isForeground && !EngineListener.rewReachedFirst) // modified by sangmin.seol 2014.03.17 skip next track if reached first track. // modified by kihyung 2013.11.12 for ITS 0205241
                    {
                        mediaPlayer.nextTrack();
                    }
                    else  KEY_SWAP */
                    //{
                        /*if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2 || !EngineListener.rewReachedFirst)
                            mediaPlayer.previousTrack(false);
                        else
                            mediaPlayer.previousTrack();*/
                    // }  modified by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap & apply prev,next list 3 second rule
                    
                    //}
                    //{changed by junam 2013.06.09 for prev key
                    //if( !EngineListener.rewReachedFirst) // added by Sergey 28.05.2013
                    //if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2 || !EngineListener.rewReachedFirst)
                    //    mediaPlayer.previousTrack(false);
                    //}changed by junam
                }
            }

	    // { added by Sergey 19.05.2013
            onPrev_pressed:
            {
                // modified by Dmitry 10.09.13
		// modified for ITS 0191197, added focus_index != LVEnums.FOCUS_POPUP
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                if ((mediaPlayer.state != "listView") && AudioController.isBasicView && (focus_index != LVEnums.FOCUS_POPUP)) // modified by junam 2013.09.23 for not using code
                //if ((mediaPlayer.state != "listView") && AudioController.isBasicView && /*!popup.visible &&*/ (focus_index != LVEnums.FOCUS_POPUP)) // modified by junam 2013.09.23 for not using code
                // } modified by cychoi 2015.06.03
                {
                   mediaPlayer.tmp_focus_index = LVEnums.FOCUS_PLAYBACK_CONTROL
                }
                
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE, false))//changed by junam 2013.07.12 for music app //modified for ITS 196266
                    return;

                EngineListener.onTuneTimerStop()
            }

            onNext_pressed:
            {
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                if ((mediaPlayer.state != "listView") && AudioController.isBasicView && (focus_index != LVEnums.FOCUS_POPUP)) // modified by junam 2013.09.23 for not using code
                //if ((mediaPlayer.state != "listView") && AudioController.isBasicView && /*!popup.visible &&*/ (focus_index != LVEnums.FOCUS_POPUP)) // modified by junam 2013.09.23 for not using code
                // } modified by cychoi 2015.06.03
                {
                   mediaPlayer.tmp_focus_index = LVEnums.FOCUS_PLAYBACK_CONTROL
                }
                // modified by Dmitry 10.09.13
                
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE, false))//changed by junam 2013.07.12 for music app //modified for ITS 196266
                    return;

                EngineListener.onTuneTimerStop()
            } 
	    // } added by Sergey 19.05.2013
// DUAL_KEY START
            onPrev_canceled:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;
                __LOG("onPrev_canceled");
                EngineListener.normalPlay();
            }
            onNext_canceled:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;
                __LOG("onNext_canceled");
                EngineListener.normalPlay();

            }
            onPlay_button_canceled:
            {
                //{ added by hyochang.ryu 20130726 for 181814
                if (mediaPlayer.focus_index != LVEnums.FOCUS_PLAYBACK_CONTROL)
                {
                    mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT	//PLAYBACK_CONTROL
                    mediaPlayer.setDefaultFocus()	//(UIListenerEnum.JOG_DOWN)
                }
                //} added by hyochang.ryu 20130726 for 181814

                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;
            }

// DUAL_KEY END
	    
            onLong_rew:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;

                EngineListener.HandleRW4X();
                EngineListenerMain.ManualBeep() // added by sangmin.seol 2014.06.05 ITS 0230761 Beep on FF, REW State change
            }

            onCritical_rew:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;

                EngineListener.HandleRW20X();
                EngineListenerMain.ManualBeep() // added by sangmin.seol 2014.06.05 ITS 0230761 Beep on FF, REW State change
            }

            onNext_clicked:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;

                //{added by junam 2013.08.18 for iPod next crash
                if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                {
                    AudioController.invokeMethod(playbackControls, "doNextClicked");
                    return;
                }
                //}added by junam

                if (AudioController.isLongPress)
                {
                    EngineListener.normalPlay();
                }
                else
                {
                    // {  modified by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap & apply prev,next list 3 second rule
                    if(EngineListener.getPrevNextKeySwapState())
                        mediaPlayer.previousTrack(false);
                    else
                        mediaPlayer.nextTrack();

		// added by aettie 2013.08.01 for ITS 0181682
                    /* KEY_SWAP
                    if(mediaPlayer.state == "listView" && AudioController.isForeground) // modified by kihyung 2013.11.12 for ITS 0205241 
                    {
                        //if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2 || !EngineListener.rewReachedFirst)//modified by yongkyun.lee 2013-08-07 for : ISV 88683
                        // { modified by cychoi 2014.03.05 for ITS 227604 forced track change in List View // { added by wonseok.heo for NOCR List Focus of Disc 2013.12.30
                        //if (AudioController.PlayerMode == MP.DISC){
                        //    mediaPlayer.previousTrack(false);
                        //}else{
                            mediaPlayer.previousTrack(true); //chage false to true by junam 2013.11.15 for list prev
                        //}
                        // } modified by cychoi 2014.03.05 // } added by wonseok.heo for NOCR List Focus of Disc 2013.12.30
                    }
                    else  KEY_SWAP mediaPlayer.nextTrack();*/
					// }  modified by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap & apply prev,next list 3 second rule
                }
            }

            onLong_ff:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;

                EngineListener.HandleFF4X();
                EngineListenerMain.ManualBeep()  // added by sangmin.seol 2014.06.05 ITS 0230761 Beep on FF, REW State change
            }

            onCritical_ff:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))//changed by junam 2013.07.12 for music app
                    return;

                EngineListener.HandleFF20X();
                EngineListenerMain.ManualBeep()  // added by sangmin.seol 2014.06.05 ITS 0230761 Beep on FF, REW State change
            }

            onCancel_ff_rew:
            {
                if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE,false))//added by junam 2013.09.03 for ITS_KOR_187595 //modified ITS 218503
                    return;
                if(AudioController.GetFfRewState() == true)
                    EngineListener.normalPlay();
            }
            //{added by junam 2013.05.18 for ISV_KR81848
            onReleased:
            {
                if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                    AudioController.UpdateStateTrackOSD(false);
            }
            //}added by junam
            onCanceled:
            {
                EngineListenerMain.qmlLog("DUAL_KEY DHAVN_MusicPlayer.qml playbackcotrols onCancel")
            }

            onHideFocusInParent:
            {
                //{changed by junam 2013.09.07 for ITS_KOR_185529
                //if (AudioController.isLongPress && EngineListener.isSeekHardKeyPressed)
                if (AudioController.isLongPress && (EngineListener.isNextHardKeyPressed || EngineListener.isPrevHardKeyPressed))
                {
                    __LOG("Seek HK already pressed...");
                    //EngineListener.isSeekHardKeyPressed = false;
                    EngineListener.isNextHardKeyPressed = false;
                    EngineListener.isPrevHardKeyPressed = false;
                    EngineListener.normalPlay();
                }
                //}changed by junam
            }
// added by Dmitry 15.05.13
            onLostFocus:
            {
               if (direction == UIListenerEnum.JOG_UP)
               {
                  if (albumView.visible || albumBTView.visible /*|| textDVDAudioInfo.visible*/ || mediaPlayer.state == "aux" ) // modified by cychoi 2015.06.03 for Audio/Video QML optimization
                  {
                      tmp_focus_index = modeAreaWidget.setDefaultFocus(direction);
                  }
               }
            }
// added by Dmitry 15.05.13

            //{added by junam 2013.08.18 for iPod next crash
            function doNextClicked()
            {
                __LOG("doNextClicked");
                if (AudioController.isLongPress)
                {
                    EngineListener.normalPlay();
                }
                else
                {
		    // {  modified by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap & apply prev,next list 3 second rule
                    if(EngineListener.getPrevNextKeySwapState())
                        mediaPlayer.previousTrack(false);
                    else
                        mediaPlayer.nextTrack();

                    /* KEY_SWAPif(mediaPlayer.state == "listView" && AudioController.isForeground) // modified by junam 2013.11.15 for ITS 0205241
                        mediaPlayer.previousTrack(true);  //chage false to true by junam 2013.11.15 for list prev
                    else KEY_SWAP
                        mediaPlayer.nextTrack(); */
		    // } modified by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap & apply prev,next list 3 second rule                        
                }
            }

            function doPrevClicked()
            {
                __LOG("doPrevClicked");
                if (AudioController.isLongPress)
                {
                    EngineListener.normalPlay();
                }
                else
                {
		    // {  modified by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap & apply prev,next list 3 second rule
                    if(EngineListener.getPrevNextKeySwapState())
                        mediaPlayer.nextTrack();
                    else
                        mediaPlayer.previousTrack(false);

                    /* KEY_SWAP if(mediaPlayer.state == "listView" && AudioController.isForeground)
                        mediaPlayer.nextTrack();
                    else KEY_SWAP
                        mediaPlayer.previousTrack(false); */
		    // } modified by sangmin.seol 2014.05.20 modify SEEK/TRACK Key swap & apply prev,next list 3 second rule
                }
            }

            function doPlayButtonClicked()
            {
                if (!EngineListener.selectTune())
                {
                    mediaPlayer.changePlayStatus();
                }
            }
            // } added by junam

        }

        Text {
            id: iPod3rdPartyTxt
            text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,"STR_SUPPORTED_CONTROLS_ARE_SHOWN") + LocTrigger.empty
            visible: false;

            anchors.top: parent.top
            anchors.topMargin: 483
            anchors.horizontalCenter: parent.horizontalCenter

            color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_GREY
            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
            font.pointSize:
            {
                var textWidth = EngineListener.getStringWidth(text, MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB,
                                                              MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT);
                if(textWidth > MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH - 120 )
                    return MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT * (MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH - 120) / textWidth;
                return MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT;
            } // ITS 250422
        }

		//Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
        Image
        {
            id: iPodNoMediaFileText
            visible: false;
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width
            height: parent.height
            z: 1000
            source: main_bg_image.source

            Text
            {
                text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,"STR_NO_MEDIA_FILES_AVAILABLE") + LocTrigger.empty
                anchors.top: parent.top
                anchors.topMargin: 277 -  MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT/2
                anchors.horizontalCenter: parent.horizontalCenter
                color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
                font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT
            }
        }
        //end of Hyundai Spec Change

    }
//{deleted by aettie.ji 2013.01.24 for ISV 70695 
   /* Text
    {
        id: emptyText
        visible: false
        anchors.centerIn: parent
        color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
        font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT   //modified by aettie.ji 2012.11.28 for uxlaunch update
        text:  qsTranslate( MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,"STR_MEDIA_EMPTY")
    }
*/
//}deleted by aettie.ji 2013.01.24 for ISV 70695 
//deleted by aettie.ji 2013.03.11
//    Image
//    {
//        id: bg_bottom
//        source: "/app/share/images/music/bg_basic_bottom.png"
//        visible: (albumView.visible || albumBTView.visible) //modified by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
//        anchors.bottom: parent.bottom
//    }
//deleted by aettie.ji 2013.03.11
    //{added by edo.lee 2012.09.17 for New UX : Music (LGE) # 43
    Image
    {
        id : btmusic_nocontrol_info
        source: "/app/share/images/music/bg_popup.png"
        // { modified by cychoi 2015.05.15 for ITS 262799
        visible : (albumBTView.visible && !albumBTView.item.isRemoteCtrl) //added by edo.lee 2013.02.14
        //visible : (albumBTView.visible && EngineListener.getIsRemoteCtrl()==false) //added by edo.lee 2013.02.14
        // } modified by cychoi 2015.05.15
        x: 161
        y: 468
        width: 958
        height: 138

        Text
        {
            text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,"STR_MEDIA_BT_INFO") + LocTrigger.empty
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.verticalCenter: btmusic_nocontrol_info.verticalCenter
            
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157
            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
            font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT   //modified by aettie.ji 2012.11.28 for uxlaunch update
        }
    }
    //}added by edo.lee

    //{added by edo.lee 2012.08.17 for New UX : Music (LGE) # 42
    Item
    {
        id: bt_transferring_view
        visible:  albumBTView.visible
        property bool isReverse : false //added by edo.lee 2013.01.10
        property bool isRunning : false // modified by oseong.kwon 2014.06.10 for ITS 239908 // modified by yongkyun.lee 2013-12-02 for : ISV 95731
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        // { modified by oseong.kwon 2014.06.10 for ITS 239908 // { commented by oseong.kwon 2014.05.07 for ISV 99883
        //{ modified by yongkyun.lee 2013-12-02 for :  ISV 95731 
        onVisibleChanged:
        {
            __LOG("onVisibleChanged signal =" +  visible);
            if(visible)
            {
                mediaPlayer.isTimerRunning = AudioController.isBTStreaming;
                isRunning = mediaPlayer.isTimerRunning
                //EngineListenerMain.qmlLog("DHAVN_MusicPlayer", "onVisibleChanged signal[isRunning] = " + isRunning)
            }
        }
        //} modified by yongkyun.lee 2013-12-02 
        // } modified by oseong.kwon 2014.06.10 // } commented by oseong.kwon 2014.05.07
        Timer
        {
            id: image_timer
            interval: 100; 
            running:  bt_transferring_view.isRunning  //{ modified by yongkyun.lee 2013-12-02 for : ISV 95731
            repeat: true //modified by edo.lee 2013.01.23
            onTriggered: tran_img.source = bt_transferring_view.getTransferringImage()
        }

        function getTransferringImage()
        {
            if(tranCount >= 30)
            	tranCount = 1;
            else
                tranCount++;

            return (tranCount < 10) ? "/app/share/images/music/streaming/streaming_0" + tranCount + ".png"
                                    : "/app/share/images/music/streaming/streaming_"  + tranCount + ".png";
        }

        Text
        {
            id: transfer_text
            // { modified by cychoi 2014.09.30 for HMC Request. Display "Paused" when Streaming is stopped (KH)
            x: MPC.const_BT_MUSIC_PLAYER_TRANSFERRING_LEFT_MARGIN
            anchors.bottom: parent.bottom
            anchors.bottomMargin:
            {
                var textWidth = EngineListener.getStringWidth(text,MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB,MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_28_FONT);
                if(textWidth > width)
                {
                    var textHeight1 = EngineListener.getFontHeight(MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB,MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_28_FONT);
                    var textHeight2 = EngineListener.getFontHeight(MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB,MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_28_FONT * width / textWidth);
                    return MPC.const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_BOTTOM_MARGIN * textHeight1 / textHeight2;
                }
                return MPC.const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_BOTTOM_MARGIN
            }
            //anchors.left: parent.left + 10
            //anchors.bottom: parent.bottom
            //anchors.leftMargin: MPC.const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_LEFT_MARGIN
            //anchors.bottomMargin: MPC.const_BT_MUSIC_PLAYER_TRANSFERRING_ITEM_BOTTOM_MARGIN
            // } modified by cychoi 2014.09.30
            width: MPC.const_BT_MUSIC_PLAYER_TRANSFERRING_TEXT_WIDTH //added by edo.lee 2012.08.29 for New UX BT Music
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_141_179_255

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment  : Text.AlignVCenter
            text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,bt_transferring_view.isRunning ? "STR_MEDIA_BT_STREAMING" : "STR_MEDIA_BT_STREAMING_PAUSED") + LocTrigger.empty // modified by cychoi 2014.09.19 for HMC Request. Display "Paused" when Streaming is stopped (KH) // modified by edo.lee 2013.01.10
            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
            // { modified by cychoi 2014.09.30 for HMC Request. Display "Paused" when Streaming is stopped (KH)
            font.pointSize:
            {
                var textWidth = EngineListener.getStringWidth(text,MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB,MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_28_FONT);
                if(textWidth > width)
                    return MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_28_FONT * width / textWidth;
                return MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_28_FONT;
            }
            //font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_28_FONT  //modified by aettie.ji 2012.11.28 for uxlaunch update
            // } modified by cychoi 2014.09.30
        }

        Image
        {
            id: tran_img
            x: 280
            anchors.bottom: parent.bottom
            anchors.bottomMargin: MPC.const_BT_MUSIC_PLAYER_TRANSFERRING_BOTTOM_MARGIN

            source: bt_transferring_view.getTransferringImage();
        }
    }
    // } added by edo.lee

    //{removed by junam 2013.04.26 for disable list button at sync
//    Item
//    {
//        id: ipod_indexing
//        visible: ((mediaPlayer.isMediaSyncFinished == false) && (AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2))
//        x: 1058
//        y: 207
//        width: 191
//        height: 70

//        Image
//        {
//            anchors.left: parent.left
//            anchors.top: parent.top
//            source: "/app/share/images/music/list_ico_song.png"
//        }

//        Text
//        {
//            visible: true
//            anchors.right: parent.right
//            anchors.bottom: parent.bottom
//            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157
//            text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,"STR_MEDIA_IPOD_INDEXING") + LocTrigger.empty
//            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
//            font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_22_FONT
//        }
//    }
    //}added by junam

	//deleted for gracenote logo spec changed 20131008
    // { modified by cychoi 2015.06.03 for Audio/Video QML optimization // { added by kihyung 2012.08.30 for DVD-Audio Group/Track Number
    //Item
    //{
    //    id: textDVDAudioInfo
    //    x: 20
    //    y: 656
    //    width: 1270

    //    property string  strDVDAudioTrackNum: ""
    //    property int     nDVDAudioCurrTime: 0

    //    Text
    //    {
    //        id: textGroupNumber
    //        text: AudioController.groupNumber
    //        anchors.left: parent.left
    //        anchors.top: parent.top
    //        font.pointSize: 30   //modified by aettie.ji 2012.11.28 for uxlaunch update
    //        font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
            
    //        color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
    //    }

    //    Text
    //    {
    //        id: textTrackNumber
    //        anchors.left: textGroupNumber.right
    //        anchors.top: textGroupNumber.top
    //        anchors.leftMargin: 39
    //        text: strDVDAudioTrackNum
    //        font.pointSize: 30   //modified by aettie.ji 2012.11.28 for uxlaunch update
    //        font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
    //       // color: prBar.bTuneTextColor ? "#800000" : MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
    //       color: prBar.bTuneTextColor? MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT : MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY //modified by aettie.ji 2013.01.28 for ISV 61921
    //    }

    //    Text
    //    {
    //        id: textPlaybackTime
    //        anchors.right: parent.right
    //        anchors.top: parent.top
    //        horizontalAlignment: Text.AlignLeft
    //        width: 156
    //        font.pointSize: 32  //modified by aettie.ji 2012.11.28 for uxlaunch update
    //        font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
    //        text: convertTime(nDVDAudioCurrTime)
    //        color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_GREY
    //    }

    //    function convertTime( t )
    //    {
    //        var hour = Math.floor( t / 3600 )
    //        t = t % 3600
    //        var min = Math.floor( t / 60 )
    //        var sec = t % 60
    //        var str = min + ":" + sec
    //        str = str.replace( /^(\d):/, "0" + min + ":" )
    //        str = str.replace( /:(\d)$/, ":0" + sec )
    //        str = hour + ":" + str
    //        str = str.replace( /^(\d):/, "0" + hour + ":" )
    //        return str
    //    }

    //    onNDVDAudioCurrTimeChanged:
    //    {
    //        __LOG("onNDVDAudioCurrTimeChanged");
    //        textPlaybackTime.text = convertTime(nDVDAudioCurrTime);
    //    }

    //    onStrDVDAudioTrackNumChanged:
    //    {
    //        textTrackNumber.text = strDVDAudioTrackNum;
    //    }
    //}
    // } modified by cychoi 2015.06.03 // } added by kihyung

    // { added by kihyung 2012.12.04 for ISV 62683 
    Item {
        id: inhibition_item

        visible: false
        x: 1176
        y: 175
        width: 92
        height: 92

        Image {
            id: icon_image
            anchors.left: parent.left
            anchors.top: parent.top
            source: "/app/share/images/video/ico_dvd_error.png"
        }

        Timer {
            id: icon_timer
            interval: 3000
            repeat: false
            triggeredOnStart: false
            running: false
            onTriggered: 
            {
                EngineListenerMain.qmlLog("[MP][QML] MP Screen_Playback :: onShowPlaybackControls: onTriggered");
                inhibition_item.visible = false
            }
        }
    }
        // } added by kihyung

    // {added by wonseok.heo 2013.07.04 disc in out test
    Item {
        id : discInOut_Test
        visible: false
        x: 100
        y: 175
        width: 92
        height: 92

        Text{
            id: testo_text
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157
            text: "DISC IN OUT TEST MODE"//

            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
            font.pointSize: 40
        }

        Text {
            x: 138 ;y:120

            text: mediaPlayer.testDiscStatus
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157

            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
            font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_22_FONT
        }


        Text {
            x: 138 ;y:230
            text: "TEST COUNT :"
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157

            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
            font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_22_FONT
        }
        Text {
            id : discTestCount
            x: 500 ;y:230
            text: mediaPlayer.testCount  + "/" + mediaPlayer.testFullCount
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157


            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
            font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_22_FONT
        }


        Text {
            x: 138 ;y:330

            text: "TEST STATUS :"
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157


            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
            font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_22_FONT
        }
        Text {
            x: 500 ;y:330

            text: testStatus
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157

            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
            font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_22_FONT
        }


        Text {
            id: isPassfail
            x: 1000 ;y:440
            width: 100 ; height : 40
            text: if (mediaPlayer.testCount == 10000){ 
                      "PASS"
                  }else {
                      "-"
                  }

            color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_146_148_157

            font.family:  MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
            font.pointSize: 40
        }

    }

    // }added by wonseok.heo 2013.07.04 disc in out test



    AudioProgressBar
    {
        id: prBar
        anchors.left: parent.left
        anchors.bottom: main_bg_image.bottom //modified by aettie.ji 2013.03.11
        //btextVisible: !albumView.visible; //removed by junam 2013.12.09 for ITS_NA_212868
        bPrBarRandomVisible: !AudioController.isPlayFromMLT // added by Dmitry 27.04.13
        middleEast: EngineListenerMain.middleEast // added by Dmitry 05.05.13
        mpDisc: AudioController.PlayerMode == MP.DISC // added by cychoi 2013.05.28 for Smoke Test 35 fail

        property int changedTime;

        onChangePlayingPosition:
        {
            // { added by sangmin.seol 2016.05.10 for ITS 272913 prevent progressbar postion change on CP call State
            if(EngineListenerMain.getisCPCallLineType())
            {
                __LOG("ChangePlayingPosition called on CP call State!! Return!")
                return
            }
            // } added by sangmin.seol 2016.05.10

            if(AudioController.isControllerDisable(MP.CTRL_DISABLE_PRGRESSBAR))
            {
                return;
            }

            if(mediaPlayer.state == "ipod" && AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE)) // added ITS 210706,7
            {
                return;
            }

            // { added by lssanh 2013.03.15 ITS158764
            if (playbackControls.is_scan)
            {
                AudioController.setScanMode(MP.SCANOFF); 
            }
            // } added by lssanh 2013.03.15 ITS158764

            //{ added by yongkyun.lee 20130627 for : ITS 176339
            if (playbackControls.is_ff_rew)
            {
                playbackControls.isSeekPressed = false;
                playbackControls.handleOnCancel_ff_rew()   
            }
            //} added by yongkyun.lee 20130627 

            if(prBar.bPrBarVisible)
                EngineListener.setPlayingPosition(second); // modified by kihyung 2013.07.02 for ITS 0177424 
        }

        // { added by cychoi 2013.06.02 for sound noise when dragged progress bar
        onBeep:EngineListenerMain.ManualBeep();
        onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

        onChangeDiscMuteState:
        {
            // AudioController.setDiscMuteState(prBar.bDiscMuteState); // removed by Michael.Kim 2013.07.25 for ITS Issue #181538
        }
        // } added by cychoi 2013.06.02
        
		// { added by edo.lee 2013.06.13
        onChangeDragMuteState:
        {
        	// AudioController.setDragMuteState(prBar.bDragMuteState); // removed by kihyung 2013.07.03 for crash problem.
        }
   		// } added by edo.lee 2013.06.13
   		
        onChangeRepeatMode:
        {
            __LOG("onChangeRepeatMode");
            //{ modified by yongkyun.lee 2013-08-15 for : ISV 85716
            //{changed by junam 2013.09.07 for ITS_KOR_185529
            //if(EngineListener.isSeekHardKeyPressed)
            // { removed by sangmin.seol 2013.11.29 DUAL_KEY Allow repeatmode change in ff,rew mode
            //if(EngineListener.isNextHardKeyPressed || EngineListener.isPrevHardKeyPressed) //}changed by junam
            //{
            //    return;
            //}
            // } removed by sangmin.seol 2013.11.29 DUAL_KEY Allow repeatmode change in ff,rew mode
            if(mediaPlayer.state == "ipod" && AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE))  // added ITS 210706,7
            {
                return;
            }
            //} modified by yongkyun.lee 2013-08-15 
            AudioController.toggleRepeatMode();

        }

        onChangeRandomMode:
        {
            __LOG("onChangeRandomMode");
            // { modified by yongkyun.lee 2013-08-15 for : ISV 85716
            //{changed by junam 2013.09.07 for ITS_KOR_185529
            //if(EngineListener.isSeekHardKeyPressed)
            // { removed by sangmin.seol 2013.11.29 DUAL_KEY Allow randommode change in ff,rew mode
            //if(EngineListener.isNextHardKeyPressed || EngineListener.isPrevHardKeyPressed) //}changed by junam
            //{
            //    return;
            //}
            // } removed by sangmin.seol 2013.11.29 DUAL_KEY Allow randommode change in ff,rew mode            
            if(EngineListener.isNextHardKeyPressed || EngineListener.isPrevHardKeyPressed) //}changed by junam
            {
                return;
            }
            if(mediaPlayer.state == "ipod" && AudioController.isControllerDisable(MP.CTRL_DISABLE_PLAYQUE)) // added ITS 210706,7
            {
                return;
            }
            //} modified by yongkyun.lee 2013-08-15 
            AudioController.toggleRandomMode();
        }
        //{moved by junam 2013.09.25 for using loader
        //Connections
        //{
        //    target: coverCarousel
        //        onSetJoggedCover:
        //        {
        //            prBar.bTuneTextColor = false; //[KOR][ITS][181167][minor](aettie.ji)
        //            prBar.sSongName = c_album;
        //            prBar.sArtistName = c_artist;
        //        }
        //}
	//}moved by junam
    }
//{removed by junam 2013.09.23 for not using code
//    Connections
//    {
//        target: mlt_screen_loader.item

//        onCloseMLTScreen:
//        {
//            mediaPlayer.closeMltScreen();
//            // removed by Dmitry 15.05.13
//        }
//    }
//}removed by junam

	//added by edo.lee 2013.05.01 update UI front & rear view
    Connections
    {
    	target: AudioController
        //{ added by hyochang.ryu 20130731 for 181088
        onSigShowBTCallPopup:
        {
            mediaPlayer.closeOptionMenu(true); // added by cychoi 2014.06.09 for ITS 239745 close option menu on popup open
            //popup.message = duringBtCallModel;
            popup_loader.showPopup(LVEnums.POPUP_TYPE_BT_DURING_CALL);
        }
        //} added by hyochang.ryu 20130731 for 181088

        //{ added by hyochang.ryu 20130913 for ITS190345  
        onSigCloseBTCallPopup:
        {
            //popup.message = duringBtCallModel;
            popup_loader.item.closePopup();
        }
        //} added by hyochang.ryu 20130913 for ITS190345

        // { added by cychoi 2015.01.20 for ITS 250091
        onSigShowNotSupportedPopup:
        {
            mediaPlayer.closeOptionMenu(true);
            popup_loader.showPopup(LVEnums.POPUP_TYPE_NOT_SUPPORTED);
        }

        onSigCloseNotSupportedPopup:
        {
            popup_loader.item.closePopup();
        }
        // } added by cychoi 2015.01.20

        // { added by cychoi 2014.04.09 for HW Event DV2-1 1403-00067 HIGH TEMPERATURE handling
        onSigShowDeckHighTempPopup:
        {
            mediaPlayer.closeOptionMenu(true); // added by cychoi 2014.06.09 for ITS 239745 close option menu on popup open
            popup_loader.showPopup(LVEnums.POPUP_TYPE_HIGH_TEMPERATURE);
        }

        onSigCloseDeckHighTempPopup:
        {
            if(popup_loader.status == Loader.Ready &&
               popup_loader.popup_type == LVEnums.POPUP_TYPE_HIGH_TEMPERATURE)
            {
                popup_loader.item.closePopup();
            }
        }
        // } added by cychoi 2014.04.09
        
    	 onSetRandomRepeatIcons:
        {
                __LOG("set repeat randome icon");
            prBar.nRepeatStatus = repeatIcon;
            prBar.nRandomStatus = randomIcon;
        }
	//added by edo.lee 2013.05.03
        onResetSpeedIcon:
        {
            __LOG( "onResetSpeedIcon:");
            playbackControls.setPauseState();
        }
        // { added by cychoi 2015.09.07 for ITS 268472
        onResetSpeedIconToPlayIcon:
        {
            __LOG("onResetSpeedIconToPlayIcon");
            playbackControls.setPlayState();
        }
        // } added by cychoi 2015.09.07
        onResetPlayIconBT:
        {
            __LOG("onResetPlayIconBT");
            playbackControls.setPlayState();
        }
        onSetSpeedIcon:
        {
            __LOG( "onSetSpeedIcon:rate = " + rate);
            playbackControls.setSpeedRate(rate);
        }
        onPlaybackStarted:
        {
            __LOG("onPlaybackStarted event");

            // { added by wspark 2012.09.04 for 3PDMS #136569
            if(playbackControls.is_scan)
            {
                playbackControls.state = "Scan"; // added by wonseok.heo for ITS 219603 2014.01.13
                playbackControls.setScanState();
            }
            else
            {
                playbackControls.state="Play";
                playbackControls.setPauseState();
            }
            // } added by wspark 2012.09.04 for 3PDMS #136569
            playbackControls.setTuneState(false); // added by wspark 2012.08.17 for DQA #26
            EngineListenerMain.qmlLog("playbackControls.state = "+ playbackControls.state)

            //deleted by yongkyun.lee 2013-11-10 for : ITS 208024
            //prBar.bTuneTextColor = false;// modified by yongkyun.lee 2013-11-21 for : EU - Tune 
            // { modified by wonseok.heo for smoke Test countInfo issue 2013.12.07
            if(AudioController.DiscType != MP.AUDIO_CD){
                prBar.sFilesCount = EngineListener.GetFilesCountInfo();
                albumView.sFilesCount = prBar.sFilesCount;  // add by jungae 2012.07.24 CR11642 : after autoplay media index is shown for song playing.
            } // } modified by wonseok.heo for smoke Test countInfo issue 2013.12.07
            //albumView.sCategoryId = EngineListener.GetCurrentCategoryId(); //added by aettie.ji 2012.12.18 for new ux
        }

        //{added by junam 2013.07.24 for iPOD FF/RW icon
        onPlaybackForcedStart:
        {
            __LOG("onPlaybackForcedStart event");
            playbackControls.setPause();
        }
        //}added by junam

        onPlaybackPaused:
        {
            __LOG("onPlaybackPaused event");
            playbackControls.state = "Pause";
        }
        onStartScan:
        {
            __LOG("onStartScan event");
            
            AudioController.isEnableErrorPopup = false // added by kihyung 2013.11.08 for ITS 0207561 
            mediaPlayer.bScan = true;
            playbackControls.is_scan = true;

            mainViewArea.setScanIcon(AudioController.getScanMode());

            if (playbackControls.state == "Scan")
                playbackControls.setScanState();
            else{
                playbackControls.state = "Scan";
                playbackControls.setScanState();
            }


            prBar.bScanStatus   = true;
            prBar.nRandomStatus = 0; 
            prBar.nRepeatStatus = 0;
        }

        onStopScan:
        {
            __LOG("onStopScan event");
            // { added by wonseok.heo for ITS CN 216258 2013.12.18
            if(AudioController.PlayerMode == MP.DISC && playbackControls.state == "Tune"){
                _LOG("onStopScan playbackController is Tuning");
                return;
            }// } added by wonseok.heo for ITS CN 216258 2013.12.18
            prBar.bScanStatus = false;
            mediaPlayer.bScan = false;
            playbackControls.is_scan = false;
            // { added by wonseok.heo for ISV 86609 2013.07.20
            if( AudioController.PlayerMode == MP.DISC && EngineListener.isBTPaused() == true
                    && EngineListener.isBtCallAfterScan() == true){//added by sh.kim 2013.08.09 for ITS 183042
                __LOG(":: Scan -> Bt Call -> MP3 DISC case")
                playbackControls.state = "Pause";
                playbackControls.setPlayState();
            }else{
                // { modified by kihyung 2013.10.30 for ITS 0196326 
                // { added by Michael.Kim 2013.08.27 for ITS 186710
                if(AudioController.isLongPress == 1 || AudioController.isLongPress == -1)
                {
                    return 
                }
                else if(AudioController.IsPlaying() == true) // display play icon
                {
                    playbackControls.state = "Play";
                    playbackControls.setPauseState();
                }
                else // display pause icon
                {
                    playbackControls.state = "Pause";
                    playbackControls.setPlayState();
                }
                // } modified by kihyung 2013.10.30 for ITS 0196326 
            } 
            // } added by Michael.Kim 2013.08.27 for ITS 186710
            // } added by wonseok.heo for ISV 86609 2013.07.20

        }
		//added by edo.lee 2013.05.03

        onShowPlayerView: mediaPlayer.showPlayerView(true);//added by junam 2013.05.15 for disbable flow view during re-sync
    }

    //{ added by sangmin.seol 2014.09.25 ITS 0249088 reset systemPopupVisible property on hidepopup event
    Connections
    {
        target: EngineListener

        onSystemPopupClosed: mediaPlayer.systemPopupVisible = false;

        //{ added by sangmin.seol 2014.09.30 ITS 0249352 close copy to jukebox confirm popup on copy completed in BG State
        onCloseCopyCancelConfirmPopup: // modified for ITS 0217509
        {
            if(popup_loader.popup_type == LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM)
            {
                popup_loader.item.closePopup();
            }
        }
        //} added by sangmin.seol 2014.09.30 ITS 0249352 close copy to jukebox confirm popup on copy completed in BG State
    }
    //} added by sangmin.seol 2014.09.25 ITS 0249088 reset systemPopupVisible property on hidepopup event

    //added by edo.lee 2013.05.01
    Connections
    {
        target: (isFrontView == mediaPlayer.isCurrentFrontView)? AudioController: null  //AudioController modified by edo.lee 2013.04.03

        // { added by eugeny.novikov 2012.10.25 for CR 14047
        onEnableModeArea:
        {
            mediaPlayer.enableModeAreaTabs(true);
        }
        // } added by eugeny.novikov

        onShowNoFoundPopup:
        {
            // { modified by dongjin 2013.02.04 for ISV 70377
            /*popupTimer.stop();
            popup.message = noMatchFoundModel;
            popupTimer.start(); // Added by Radhakrushna CR 14232 20121005
            popup.setFocus();
            popup.visible = true;*/
            popup_loader.showPopup(LVEnums.POPUP_TYPE_MLT_NO_MATCH_FOUND);
            // } modified by dongjin
        }

        onShowPopupError:
        {
            __LOG("onShowPopupError signal");
            // { modified by kihyung 2013.09.12 for ISV 90605
            // { added by sangmin.seol 2014.03.05 for ITS 0227261, 0218702 unsupported file skip when Audio is BG
            if ( !AudioController.isForeground )
            {
                AudioController.setSkipTrack();
            }
            else
            {
            // } added by sangmin.seol 2014.03.05 for ITS 0227261, 0218702 unsupported file skip when Audio is BG
                if ( AudioController.isEnableErrorPopup || bUnsupportedAll == true)
                {
                    // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                    //if(bUnsupportedAll == true)
                    //    popup.message = allUnavailableFormatModel;
                    //else
                    //    popup.message = unavailableFormatModel;
                    // } modified by cychoi 2015.06.03

                    playermodeBeforePopup = AudioController.PlayerMode // added by wspark 2013.01.28 for ISV 71172
                    //popupTimer.start(); //remove by edo.lee 2013.05.06
                    //popup.setFocus();	// modified by sangmin.seol 2014.06.12 ITS 0239773
                    // added by Dmitry 11.10.13 for ITS0194940
                    if (EngineListener.tuneEnabled)
                    {
                       playbackControls.setPlayState()
                       playbackControls.setTuneState(false)
                       prBar.bTuneTextColor = false;
                    }
                    // added by Dmitry 11.10.13 for ITS0194940

                    // commented by sangmin.seol 2015.06.29 commented useless code by fixing for Audio/Video QML optimization
                    // { modified by sangmin.seol 2014.06.12 ITS 0239773
                    //if(systemPopupVisible == true)
                    //{
                    //    delayedPopupType = -1;
                    //    bNeedDelayedPopup = true;
                    //    EngineListenerMain.CloseSystemPopup();
                    //}
                    // commented by sangmin.seol 2015.06.29 commented useless code by fixing for Audio/Video QML optimization
                    // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                    //else
                    //{
                    //    // added by sangmin.seol 2014.06.19 ITS 0239925 close local popup if unsupported file popup showing
                    //    if (popup_loader.status == Loader.Ready && popup_loader.item.visible)
                    //    {
                    //        popup_loader.item.resetOnPopUp();
                    //    }

                    if(bUnsupportedAll == true)
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_ALL_UNAVAILABLE_FORMAT);
                    else
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_UNAVAILABLE_FORMAT);

                    //    popup.setFocus();
                    //    popup.visible = true;
                    //    AudioController.isEnableErrorPopup = false; // add by changjin 2012.08.08 : for CR 12479
                    //    AudioController.setIsShowPopup(true);//added by edo.olee 2013.09.02 ITS 0184880
                    //}
                    // } modified by cychoi 2015.06.03
                    // } modified by sangmin.seol 2014.06.12 ITS 0239773
                }
                // } modified by kihyung 2013.09.12 for ISV 90605
                else
                {
                    // { modified by kihyung 2013.12.17 for ITS 0214009
                    /*
                    AudioController.setSkipTrack(true);//added by edo.lee 2013.08.30
                    AudioController.isEnableErrorPopup = false
                    var tmpIsRunFromFM = AudioController.isRunFromFileManager;//Added by Alexey Edelev. Fix bug 13058. 2012.09.13
                    if (AudioController.isForwardDirection)
                    {
                        EngineListener.NextTrack(true); // modified by sangmin.seol 2013-12-13 for : ITS 0215489
                    }
                    else
                    {
                        EngineListener.PrevTrack(false);
                    }

                    AudioController.isRunFromFileManager = tmpIsRunFromFM;//Added by Alexey Edelev. Fix bug 13058. 2012.09.13
                    */

                    // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                    if(isUnsupportedPopupVisible() == false)
                    //if(!popup.visible) // added by sangmin.seol 2014.09.17 ITS-0248541 remain Stop unsupported file error occured during unsupported popup showing.
                        AudioController.setSkipTrack();
                    // } modified by cychoi 2015.06.03
                    // } modified by kihyung 2013.12.17 for ITS 0214009
                }
            }   // added by sangmin.seol 2014.03.05 for ITS 0227261, 0218702 unsupported file skip when Audio is BG
        }

        // { added by kihyung 2013.4.7 for IPOD
        onChangeIPodCategory:
        {
            __LOG("IPODERR. onChangeIPodCategory signal");
            ipodTab.item.currentCategoryIndex = categoryIndex;
        }
        // } added by kihyung 2013.4.7 for IPOD
        /* remove by edo.lee 2013.05.02
        onResetSpeedIcon:
        {
            __LOG( "onResetSpeedIcon:");
            // { Added by Kihyung 2012.06.29 for CDDA/DVD-Audio/CompAudio CR 9855
            // playbackControls.setPlayState();
            playbackControls.setPauseState();
            // } Added by Kihyung
        }

        // { added by kihyung 2012.08.04
        // for CR 12585 - [3PDMS 132371] [Domestic] Toggle error with BT music Play /Pause
        onResetPlayIconBT:
        {
            __LOG("onResetPlayIconBT");
            playbackControls.setPlayState();
        }
        // } added by kihyung

        onSetSpeedIcon:
        {
            __LOG( "onSetSpeedIcon:rate = " + rate);
            playbackControls.setSpeedRate(rate);
        }*/

//{removed by junam 2013.09.23 for not using code
//        onSendMoreLikeThisList:
//        {
//            // { added by wspark 2013.03.15 for ITS 136210
//            EngineListener.pushScreen( mediaPlayer.state );
//            mlt_screen_loader.source = "DHAVN_MoreLikeThis.qml";
//            mlt_screen_loader.parent = mainViewArea;
//            mlt_screen_loader.item.width = mlt_screen_loader.parent.width;
//            mlt_screen_loader.item.height = mlt_screen_loader.parent.height;
//            //{modified by aettie 2013.03.07 for ISV 64501
//            if(!AudioController.isPlayFromMLT)
//            {
//                __LOG("!AudioController.isPlayFromMLT");
//                mlt_screen_loader.item.clearModel();
//                mlt_screen_loader.item.visible = false;
//            }
//            //}modified by aettie 2013.03.07 for ISV 64501
//            // } added by wspark
//            //{changed by junam 2013.07.01 for mlt play icon
//            //mlt_screen_loader.item.fillModel(names, artists) //modified by aettie.ji 2013.02.18 for ux optimization
//            mlt_screen_loader.item.fillModel(names, artists, files)
//            //}changed by junam
//            mediaPlayer.state = "mltView";

//            if (focus_index != -1)
//               	tmp_focus_index = LVEnums.FOCUS_CONTENT;

//            mlt_screen_loader.item.setDefaultFocus(UIListenerEnum.JOG_DOWN);//added by junam 2013.06.07 for mlt focus
//        }
//}removed by junam
        onBluetoothPlaybackStarted:
        {
            // { modified by oseong.kwon 2014.06.10 for ITS 239908
            EngineListenerMain.qmlLog("DHAVN_MusicPlayer", "onBluetoothPlaybackStarted signal = " + AudioController.isBTStreaming)
            //__LOG("onBluetoothPlaybackStarted signal =" +  AudioController.isBTStreaming);
            // } modified by oseong.kwon 2014.06.10
            //{ modified by yongkyun.lee 2013-12-02 for : ISV 95731
            mediaPlayer.isTimerRunning = AudioController.isBTStreaming;
            bt_transferring_view.isRunning = mediaPlayer.isTimerRunning; // modified by oseong.kwon 2014.06.10 for ITS 239908 // commented by oseong.kwon 2014.05.07 for ISV 99883
            //} modified by yongkyun.lee 2013-12-02 
        }

        onBluetoothPlaybackPaused:
        {
            // { modified by oseong.kwon 2014.06.10 for ITS 239908
            EngineListenerMain.qmlLog("DHAVN_MusicPlayer", "onBluetoothPlaybackPaused signal = " + AudioController.isBTStreaming)
            //__LOG("onBluetoothPlaybackPaused signal =" +  AudioController.isBTStreaming);
            // } modified by oseong.kwon 2014.06.10
            //{ modified by yongkyun.lee 2013-12-02 for : ISV 95731
            mediaPlayer.isTimerRunning = AudioController.isBTStreaming;
            bt_transferring_view.isRunning = mediaPlayer.isTimerRunning; // modified by oseong.kwon 2014.06.10 for ITS 239908 // commented by oseong.kwon 2014.05.07 for ISV 99883
            //} modified by yongkyun.lee 2013-12-02 
        }
		/* remove by edo.lee 2013.05.03
        onPlaybackStarted:
        {
            __LOG("onPlaybackStarted event");

            // { added by wspark 2012.09.04 for 3PDMS #136569
            if(playbackControls.is_scan)
            {
                playbackControls.setScanState();
            }
            // } added by wspark 2012.09.04 for 3PDMS #136569
            playbackControls.setTuneState(false); // added by wspark 2012.08.17 for DQA #26
            playbackControls.state = "Play";
            prBar.bTuneTextColor = false;
            prBar.sFilesCount = EngineListener.GetFilesCountInfo();
            albumView.sFilesCount = prBar.sFilesCount;  // add by jungae 2012.07.24 CR11642 : after autoplay media index is shown for song playing.
            //albumView.sCategoryId = EngineListener.GetCurrentCategoryId(); //added by aettie.ji 2012.12.18 for new ux
        }

        onPlaybackPaused:
        {
            __LOG("onPlaybackPaused event");
            playbackControls.state = "Pause";
        }*/
        onPlaybackTuned:
        {
            __LOG("onPlaybackTuned event");
            // { added by cychoi 2015.01.07 for move focus to control cue on TuneWheel
            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
            if ((mediaPlayer.state != "listView") && AudioController.isBasicView && (focus_index != LVEnums.FOCUS_POPUP)) // modified by junam 2013.09.23 for not using code
            //if ((mediaPlayer.state != "listView") && AudioController.isBasicView && /*!popup.visible &&*/ (focus_index != LVEnums.FOCUS_POPUP)) // modified by junam 2013.09.23 for not using code
            // } modified by cychoi 2015.06.03
            {
               mediaPlayer.tmp_focus_index = LVEnums.FOCUS_PLAYBACK_CONTROL
            }

            // { added by sangmin.seol 2014.01.08 for move focus to control cue on TuneWheel after closing systemPopup
            if(systemPopupVisible)
            {
                if(mediaPlayer.state == "listView" || coverCarousel.visible == true)
                {
                    last_Focus_flag = LVEnums.FOCUS_CONTENT
                }
                else
                {
                    last_Focus_flag = LVEnums.FOCUS_PLAYBACK_CONTROL;
                }
            }
            // } added by sangmin.seol 2014.01.08

            if(bTuneOn == false)
            {
                // just return if same file on TuneWheel
                return
            }
            // } added by cychoi 2015.01.07
            // {added by Michael.Kim 2013.09.22 for ITS 191197 //{removed by Michael.Kim 2013.11.04 for ISV 92144
            //if(popup_loader.visible == false) {
            // { added by junam 2012.10.5 for CR14119
                if(AudioController.isLongPress == 1)
                    playbackControls.handleOnRelease("Next");
                else if(AudioController.isLongPress == -1)
                    playbackControls.handleOnRelease("Prev");
                playbackControls.state = "Tune";
                // } added by junam
                playbackControls.setTuneState(true); // modified by wspark 2012.08.17 for DQA #26
            //}// }added by Michael.Kim 2013.09.22 ITS 191197 //}removed by Michael.Kim 2013.11.04 for ISV 92144
        }

        onPlaybackStopped:
        {
            __LOG("onPlaybackStopped event");
            playbackControls.state = "Pause";
            // if (!EngineListenerMain.isPowerOff()) prBar.nCurrentTime = 0; // added by Dmitry 14.07.13 // removed by kihyung 2013.07.18 for ITS 0179389 
            // { added by eugene 2012.11.26 for ISV #59906
            if (AudioController.m_NewState == -1)
            {
                modeAreaWidget.currentSelectedIndex = AudioController.m_NewState;
                AudioController.m_NewState = 0; // reset
            }
            // } added by eugene 2012.11.26 for ISV #59906
        }
        // { added by eugene 2012.11.26 for ISV #59906
        onResetCurrentIndex:
        {
            modeAreaWidget.currentSelectedIndex = -1;
        }
        // } added by eugene 2012.11.26 for ISV #59906
	
        /* remove by edo.lee 2013.05.01
        onSetRandomRepeatIcons:
        {
            prBar.nRepeatStatus = repeatIcon;
            prBar.nRandomStatus = randomIcon;
        }*/
        // } modified by eugeny - 12-09-15
        /*remove by edo.lee 2013.05.02
        onStartScan:
        {
            __LOG("onStartScan event");
            mediaPlayer.bScan = true;
            playbackControls.is_scan = true;

            mainViewArea.setScanIcon(AudioController.getScanMode()); //added by aettie 2013.04.01 for ISV 76119

            if (playbackControls.state == "Scan")
                playbackControls.setScanState();
            else
                playbackControls.state = "Scan";

            prBar.bScanStatus   = true; // added by kihyung 2012.07.26 for CR 11894
            prBar.nRandomStatus = 0;  // modified by kihyung 2012.06.30
            prBar.nRepeatStatus = 0;
        }

        onStopScan:
        {
            __LOG("onStopScan event");
            prBar.bScanStatus = false; // added by kihyung 2012.07.26 for CR 11894
            mediaPlayer.bScan = false;
            playbackControls.is_scan = false;
            playbackControls.setPauseState();
        }*/
        // {added by yungi 2012.11.30 for CR16108
        onAllTagReceived:
        {
            __LOG("onAllTagReceived event");
            if(popup_loader.status == Loader.Ready && popup_loader.popup_type == LVEnums.POPUP_TYPE_LOADING_DATA)
                 popup_loader.item.closePopup();
        }
        //}added by yungi 2012.11.30 for CR1610

        // removed by yongkyun.lee 2013-10-18 for : NOCR BT song info

        onDurationChanged:
        {
            __LOG("cursorMA onDurationChanged" + duration);
            prBar.nTotalTime = duration;

            //{changed by junam 2014.01.10 for ITS_ME_218697
            //if (AudioController.isLongPress && playbackControls.is_ff_rew == true)
            // { removed by sangmin.seol 2014.02.26 for ITS 0227242
            //if (AudioController.isLongPress != 0) //}changed by junam
            //    rateKeeper.start();
            // } removed by sangmin.seol 2014.02.26 for ITS 0227242

            prBar.bSeekableMedia = AudioController.isSeekableMedia(); // added by wspark 2013.02.18 for ISV 73389
        }

        onTrackChanged:
        {
            __LOG("onTrackChanged");
            //{removed by junam 2013.09.10 for ITS_KOR_189008
            // { added by eugene.seo 2013.04.10
            //if(popup.visible == true && popup.message == unavailableFormatModel)
            //{
            //    popupTimer.stop();
            //    popup.hidePopup(false);
            //}
            // } added by eugene.seo 2013.04.10
            //}removed by junam

            // removed by Dmitry 27.04.13

            if (index >= 0 && quantity > 0)
            {
                if (mediaPlayer.state == "disc" || albumView.visible)
                {
                    albumView.sFilesCount = EngineListener.GetFilesCountInfo();
                }
                else
                {
                    prBar.sFilesCount = EngineListener.GetFilesCountInfo();
                    //prBar.nCurrentTime = 0;  //removed by junam 2013.05.31 for let controller handling position.
                    albumView.sFilesCount = EngineListener.GetFilesCountInfo(); //added by junam 2012.09.24 for CR13593
                   // albumView.sCategoryId = EngineListener.GetCurrentCategoryId(); //added by aettie.ji 2012.12.18 for new ux
                }
            }
        }

        onTuneTextColorChanged:
        {
            prBar.bTuneTextColor = isTuneColor;
        }

        onPositionChanged:
        {
            // { modified by kihyung 2013.07.02 for ITS 0177424 
            /*
            // { modified by kihyung 2013.06.23 for 0175689
            if(prBar.bPressed == false)
                prBar.nCurrentTime = position;
            // } modified by kihyung 2013.06.23
            */
            //__LOG("onPositionChanged : " + position);
            prBar.nCurrentTime = position;
            // } modified by kihyung 2013.07.02
            
            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization // { added by kihyung 2012.08.30 for DVD-Audio
            //if (AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.DVD_AUDIO)
            //{
            //    textDVDAudioInfo.nDVDAudioCurrTime = position/1000; // modified by kihyung 2012.11.08
            //}
            // } modified by cychoi 2015.06.03 // } added by kihyung
        }

        // { added by sangmin.seol 2014.09.29 For fixing cluster timing issue
        onPositionCleared:
        {
            prBar.nCurrentTime = 0;

            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
            //if (AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.DVD_AUDIO)
            //{
            //    textDVDAudioInfo.nDVDAudioCurrTime = 0;
            //}
            // } modified by cychoi 2015.06.03
        }
        // } added by sangmin.seol 2014.09.29 For fixing cluster timing issue

        onPlayListReadyAutoStart:
        {
            __LOG("receive onPlayListReadyAutoStart signal");
            mediaPlayer.startPlay();
        }
		// { added by edo.lee 2012.12.14 ISV 64893 
        onPlayListStartSameSong:
        {
                 __LOG("receive onPlayListReadySameSong signal");
        	 EngineListener.normalPlay();
        }
        // } added by edo.lee

        //{ added by yongkyun.lee 2012.12.11 for CR 16366 No display cover flow on MLT list.
        onShowPathView:
        {
            __LOG("receive onShowPathView signal, " + isVisible);
            mediaPlayer.showPlayerView(isVisible);
        }
        //} added by yongkyun.lee

        // { added by wonseok.heo for ITS 172869 2013.06.08
        onClearRepeatRandom:
        {
            AudioController.resetRepeatOne();//mediaPlayer.resetRepeatOne();
        }
        // }added by wonseok.heo for ITS 172869 2013.06.08

        onTuneSearch:
        {
            __LOG("onTuneSearch signal received");
            //{ added by yongkyun.lee  2012.10.17  for Current file is white color
            if (m_samefile)
                prBar.bTuneTextColor = false;
            else
                // } added by yongkyun.lee
                prBar.bTuneTextColor = true;

            if (mediaPlayer.state == "disc" || albumView.visible)
            {
                // albumView.sCoverAlbum = m_coverart; // modified by Michael.Kim 2013.04.05 for Quality Assurance Issue

                //{ modified by shkim 2013.11.01 for ITS 204960
                if(AudioController.DiscType == MP.AUDIO_CD)
                {
                    __LOG("MP.AUDIO AlbumView Exception. ");
                    if(m_artist !="")
                        albumView.sArtistName = m_artist;

                    if(m_song !="")
                        albumView.sSongName = m_song;

                    if(m_album !="")
                        albumView.sFolderName = m_folder;

                    if(m_countInfo != "")
                        albumView.sFilesCount = m_countInfo;

                }
                else
                {

                    albumView.sArtistName = m_artist;
                    albumView.sSongName = m_song;
                    albumView.sAlbumName = m_album;
                    albumView.sFolderName = m_folder;
                    //{removed by junam 2013.03.26 for ISV72425
                    //albumView.sGenre = m_genre;
                    //albumView.sComposer = m_composer;
                    //}removed by junam
                    albumView.sFilesCount = m_countInfo;
                }
                //} modified by shkim 2013.11.01 for ITS 204960

                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization // { added by kihyung 2012.08.30 for DVD-Audio
                //if (AudioController.DiscType == MP.DVD_AUDIO)
                //{
                //    textDVDAudioInfo.strDVDAudioTrackNum = m_song;
                //}
                // } modified by cychoi 2015.06.03 // } added by kihyung
            }
            else
            {
                prBar.sSongName = m_song;
                prBar.sArtistName = m_artist;
                prBar.sFilesCount = m_countInfo; //modified by changjin 2012.11.26 for Used  Invail parameter : countInfo  //prBar.sFilesCount = countInfo;
            }
        }

        // { added by junam 2012.11.9 for tune speed
        onTuneCounter:
        {
            //{removed by junam 2013.06.01 for enable flowview tune count
            //if (albumView.visible)
            albumView.sFilesCount = count;
            //else
            //    prBar.sFilesCount = count;
            //}removed by junam
        }

        onTuneMetaData:
        {
            if (albumView.visible)
            {
                //albumView.sCoverAlbum = RES.const_IMG_DEFAULT_COVER; // modified by Michael.Kim 2013.03.26 for Quality Assurance Issue
                albumView.sArtistName = artist;
                albumView.sSongName = song;
                albumView.sAlbumName = album;
                albumView.sFolderName = folder;
                //{removed by junam 2013.03.26 for ISV72425
                //albumView.sGenre = genre;
                //albumView.sComposer = composer;
                //}removed by junam
            }
            else
            {
                prBar.sSongName = song;
                prBar.sArtistName = artist;
            }
            prBar.bTuneTextColor = isColor;
        }
        // } added by junam

        // { added by junam 2012.8.29 for CR12745
        onTuneCoverart:
        {
            if(albumView.visible == true)
            {
                //albumView.sCoverAlbum = coverart; / modified by Michael.Kim 2013.03.26 for Quality Assurance Issue
            }
        }
        // } added by junam

        onContentSize:
        {
            __LOG("onContentSize():" + count);

            //emptyText.visible = ((count == 0) && AudioController.PlayerMode == MP.JUKEBOX) // added by wspark 2012.12.05 for ISV64495
	    //deleted by aettie.ji 2013.01.24 for ISV 70695 

            if (AudioController.IsNoSourceBySourceid(source)) //added by edo.lee 2012.11.28  for ISV 64487
                return;

            /* Should be removed after requirements changed */
            // { modified by wspark 2012.12.05 for ISV64495
            //if (count == 0 &&
            //    mediaPlayer.state != "listView")
            if (count == 0 &&
                mediaPlayer.state != "listView" && AudioController.PlayerMode == MP.JUKEBOX)
            // } modified by wspark
            {
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                popup_loader.showPopup(LVEnums.POPUP_TYPE_NO_MUSIC_FILES);
                //popup.message = noPlayableFileModel;
                //popupTimer.start();
                //popup.setFocus();
                //popup.visible = true;
                // } modified by cychoi 2015.06.03
                // { added by edo.lee 2012.11.28  for ISV 64487
                albumView.sSongName = "";
                albumView.sAlbumName = "";
                albumView.sArtistName = "";
                //albumView.sFolderName = "Music";
//                albumView.sFolderName = "/.."; //modified by aettie.ji 2013.01.31 for ISV 70943
		// modified by aettie 20130812 for ITS 183630
                //albumView.sFolderName = "Root"; //modified by aettie 2013 08 05 for ISV NA 85625
                albumView.sFolderName = qsTranslate( LocTrigger.empty + "main",QT_TR_NOOP(   "STR_MEDIA_ROOT_FOLDER"  )); 
                albumView.sCoverAlbum = "";
                albumView.sFilesCount = 0;
                // } added by edo.lee
            }
            //emptyText.visible = (count == 0); // deleted by wspark 2012.12.05 for ISV64495
        }

        // { add by yongkyun.lee@lge.com  2012.10.30 : : CR 13733  : Sound Path
        onSerch_TabClicked:
        {
            EngineListener.modeTabClicked (true) ;
        }
        // } add by yongkyun.lee@lge.com  2012.10.30 : : CR 13733  : Sound Path

        onActivateTab:
        {
            __LOG("onActivateTab(): tabId = " + tabId + ", visible = " + isVisible + ", selected = " + isSelected);
             changeTabModel(tabId); //added by junam 2013.07.18 for ITS_NA_180278
            //modified by edo.lee 2013.06.07 for mode change
            //if(AudioController.PlayerMode != tabId || EngineListenerMain.getIsFromOtherAV() || mediaPlayer.isFirstLoaded ) //added by edo.lee 2013.06.04
            //{
            activateTab(tabId, isVisible, isSelected);
            //    mediaPlayer.isFirstLoaded = false;
            //}

            __LOG("playerMode, isOtherMode : "+AudioController.PlayerMode+", "+EngineListenerMain.getIsFromOtherAV() );

        }

        onUpdateUIForDisc:
        {
            __LOG("onUpdateUIForDisc() signal: DiscType = " + AudioController.DiscType);

            if (mediaPlayer.state == "disc")
            {
                prBar.bPrBarVisible = !(AudioController.DiscType == MP.MP3_CD /*||
                                        AudioController.DiscType == MP.DVD_AUDIO*/); // modified by cychoi 2015.06.03 for Audio/Video QML optimization
            }
        }
        //{removed by junam 2013.09.23 for not using code
        //onClosePopUp:
        //{
        //    __LOG( "onClosePopUp signal received" );
        //    coverCarousel.closePopUp();
        //}
        //}removed by junam

        // { added by  yongkyun.lee 2012.11.13 for ISV  62700
        onClosePopUpLoader:
        {
            //__LOG( "onClosePopUpLoader" );
            if( popup_loader.popup_type == LVEnums.POPUP_TYPE_DETAIL_FILE_INFO)
                popup_loader.item.closePopup();
        }
        // { added by  yongkyun.lee

//{removed by junam 2013.09.23 for not using code
//        onSignalCloseSearch:
//        {
//            if (mediaPlayer.state == "searchView") //added by junam 2012.10.19 for CR14660
//                mediaPlayer.closeSearchScreen(); // modified by eugeny.novikov 2012.10.11 for CR 14229
//        }
//}removed by junam

        // { added by jungae 2012.10.10 for CR 13753
        onIPodPlayableSongCount:
        {
            __LOG("onIPodPlayableSongCount MasterTableCount" + MasterTableCount);
            __LOG("onIPodPlayableSongCount DeviceCount" + DeviceCount);
            popup_loader.showPopup(LVEnums.POPUP_TYPE_IPOD_AVAILABLE_FILES_INFO, MasterTableCount, DeviceCount);
        }
        // } added by jungae

        onMediaSyncfinished:
        {
            __LOG("IPodSignal: onIPodSyncfinished " + bFinished);
            isMediaSyncFinished = bFinished;

            // { removed by junam 2013.06.05 for unusing code
            //if(AudioController.isMediaSyncfinished())
            //    modeAreaWidget.isListDisabled = false;
            //}removed by junam
        }

        // { added by kihyung 2012.08.30 for DVD-Audio
        onTrackNumberChanged:
        {
            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
            //__LOG("onTrackNumberChanged");
            //textTrackNumber.text = textDVDAudioInfo.strDVDAudioTrackNum = AudioController.trackNumber;
            //textGroupNumber.text = AudioController.groupNumber;
            // } modified by cychoi 2015.06.03
        }
        // } added by kihyung

        // { add by lssanh 2012.09.10 for CR9362
        onShowPopupLoadingData:
        {
            // { modified by kihyung 2013.1.4 for ISV 68141 
            if(popup_loader.status == Loader.Ready && popup_loader.item.popup_type == LVEnums.POPUP_TYPE_DETAIL_FILE_INFO)
            {
                __LOG("onShowPopupLoadingData() return");
                return;
            }
            
            if(popup_loader.status == Loader.Ready && popup_loader.item.popup_type == LVEnums.POPUP_TYPE_LOADING_DATA)
            {
                __LOG("onShowPopupLoadingData() closePopup");
                popup_loader.item.closePopup();
            }
            
            if(mediaPlayer.state == "disc") 
            {
                __LOG("onShowPopupLoadingData() showPopup");
                popup_loader.showPopup(LVEnums.POPUP_TYPE_LOADING_DATA);
            }
            // } modified by kihyung
        }
        // } add by lssanh 2012.09.10 for CR9362
        
        onClearSeekMode: mediaPlayer.clearSeekMode(); //added by junam 2012.10.10 for clear seek mode

        // { added by kihyung 2012.12.04 for ISV 62683 
        onShowInhibitionIcon:
        {
            if(AudioController.PlayerMode == MP.DISC /*&& AudioController.DiscType == MP.DVD_AUDIO*/) // modified by cychoi 2015.06.03 for Audio/Video QML optimization
            {
                __LOG("MP Screen_Playback :: onShowInhibitionIcon: " + bShow);
                inhibition_item.visible = bShow;
                if(bShow == true)
                    icon_timer.start();
                else
                    icon_timer.stop();
            }
        }
        // } added by kihyung    

        // { added by kihyung 2013.4.9 for ISV 77100
        onUpdateMP3CDFileCount:
        {
            __LOG("onUpdateMP3CDFileCount");
            albumView.sFilesCount = EngineListener.GetFilesCountInfo();
        }
        // } added by kihyung 2013.4.9 for ISV 77100

// added by Dmitry 20.04.13 for ISV77651
        onUpdateSongsCount:
        {
           albumView.sFilesCount = EngineListener.GetFilesCountInfo();
        }
// added by Dmitry 20.04.13 for ISV77651
// added by Dmitry 23.04.13
        onChangeFastFowardRewind:
        {
            //playbackControls.is_ff_rew = isFFRew;// deleted by yongkyun.lee 20130601 for : ITS 146106
            playbackControls.handleJogEvent(arrow, status);            
// added by aettie 2013.08.01 for ITS 0181682
//            if (focus_index != LVEnums.FOCUS_PLAYBACK_CONTROL)  playbackControls.isCommonJogEnabled = false
            if (focus_index != LVEnums.FOCUS_PLAYBACK_CONTROL && focus_index != LVEnums.FOCUS_POPUP ) //changed by junam 2013.09.10 for ITS_KOR_189008
            {
                if(mediaPlayer.state != "listView")
                    playbackControls.isCommonJogEnabled = false
            }
        }
// added by Dmitry 23.04.13

        // {added by wonseok.heo 2013.07.04 disc in out test
        onSendPositon:
        {
            mediaPlayer.testCount = discStatus;
            discTestCount.text = mediaPlayer.testCount  + "/" + mediaPlayer.testFullCount;

        }

        onSendPlayStatus:
        {
            mediaPlayer.pStatus = playstatus;
            mediaPlayer.testTrackNumber = trackNum;


            __LOG("SendPlayStatus : " + mediaPlayer.pStatus + "and " + mediaPlayer.testTrackNumber);

            if(mediaPlayer.pStatus == 1){
                isPassfail.text = "-";
                mediaPlayer.testStatus = "Track "+ mediaPlayer.testTrackNumber +" playing";
                mediaPlayer.testDiscStatus = "PLAYING"
            }else if(mediaPlayer.pStatus == 2){
                isPassfail.text = "-";
                mediaPlayer.testStatus = "Track "+ mediaPlayer.testTrackNumber +" playing";
                mediaPlayer.testDiscStatus = "PLAYING"
            }else if(mediaPlayer.pStatus == 3){

                mediaPlayer.testStatus ="STOP"
                mediaPlayer.testDiscStatus = "EJECTED"
            }else if(mediaPlayer.pStatus == 4){
                mediaPlayer.testStatus ="STOP"
                mediaPlayer.testDiscStatus = "Finished"
                isPassfail.text = "PASS"
            }

        }

        onWrongDisc:{

            mediaPlayer.testStatus = "This is not CDDA please insert only CDDA";

        }
        // }added by wonseok.heo 2013.07.04 disc in out test

        //{added by junam 2013.07.23 for ITS_KOR_181304
        onBasicControlEnableStatusChanged:
        {
            //Suryanto Tan: 2016.02.02 ITS 271278,
            //When re-enter iPod, the scan got cancelled.
            //this three lines of code was in showiPodPlaybackScreen function.
            closeOptionMenu();
            EngineListener.onTuneTimerStop();
            AudioController.setScanMode(MP.SCANOFF);
            //ITS 271278

            //Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
            if(enable == true)
            {
                showiPodPlaybackScreen(MPC.iPodPlaybackMode_Normal);
            }
            else
            {
                showiPodPlaybackScreen(MPC.iPodPlaybackMode_3rdParty);
            }
            //end of Hyundai Spec Change
        }
        //}added by junam

    }

    Keys.onReleased:
    {
        switch (event.key)
        {
            case Qt.Key_O :
            {
                //mediaPlayer.switchToTuned() //20131016 del function in qml
                EngineListener.switchToTuned();
                prBar.bTuneTextColor = false;
            }

            case Qt.Key_Minus:
            {
                //mediaPlayer.tuneWheel(0); //20131016 del function in qml
                EngineListener.tuneWheel(0) ;
            }

            case Qt.Key_F9:
            {
                //mediaPlayer.tuneWheel(1); //20131016 del function in qml
                EngineListener.tuneWheel(1) ;
            }

            case Qt.Key_F6:
            case Qt.Key_Q:
            case Qt.Key_V:
            {
                /* Next track */
                mediaPlayer.nextTrack();
                break;
            }

            case Qt.Key_F7:
            case Qt.Key_W:
            case Qt.Key_C:
            {
                /* Prev track */
                mediaPlayer.previousTrack(false);
                break;
            }

            case Qt.Key_Backspace:
            case Qt.Key_J:
            case Qt.Key_Comma:
            {
                /* Back */
                //            mediaPlayer.backHandler();
                break;
            }

            case Qt.Key_I:
            case Qt.Key_L:
            case Qt.Key_Slash:
            {
                /* Menu */
                //            mediaPlayer.menuHandler();
                break;
            }

            default:
                break;
        }
    }

	//Suryanto Tan: Hyundai Spec Change 2015.12.28 No Media File
    function showiPodPlaybackScreen(mode)
    {
        if(mediaPlayer.state !== "ipod")
            return;

        switch(mode)
        {
        case MPC.iPodPlaybackMode_NoMedia:
            AudioController.SetIsShowingiPodNoMediaScreen(true)
            showNoMediaPlaybackScreen()
            break;
        case MPC.iPodPlaybackMode_Normal:
            AudioController.SetIsShowingiPodNoMediaScreen(false)
            showNormalPlaybackScreen()
            break;
        case MPC.iPodPlaybackMode_3rdParty:
            AudioController.SetIsShowingiPodNoMediaScreen(false)
            show3rdPartyPlaybackScreen()
            break;
        default:
            break;
        }
        AudioController.invokeMethod(mediaPlayer, "setDefaultFocus");

    }
    //end of Hyundai Spec Change

    function showNormalPlaybackScreen()
    {
        __LOG("showNormalPlaybackScreen");
        prBar.visible = true;
        mode_area_model.right_text_visible = true;
        mode_area_model.rb_visible = true;
        mode_area_model.mb_visible = true;
        playbackControls.visible = true;
        albumView.visible = true;
        iPod3rdPartyTxt.visible = false;
        iPodNoMediaFileText.visible = false;
    }

    function show3rdPartyPlaybackScreen()
    {
        __LOG("show3rdPartyPlaybackScreen");
        prBar.visible = false;
        mode_area_model.right_text_visible = false;
        mode_area_model.rb_visible = false;
        mode_area_model.mb_visible = true;
        playbackControls.visible = true;
        albumView.visible = true;
        iPod3rdPartyTxt.visible = true;
        iPodNoMediaFileText.visible = false;
    }

    function showNoMediaPlaybackScreen()
    {
        __LOG("showNoMediaPlaybackScreen");
        prBar.visible = false;
        mode_area_model.right_text_visible = false;
        mode_area_model.rb_visible = false;
        mode_area_model.mb_visible = false;
        playbackControls.visible = false;
        albumView.visible = true;
        iPod3rdPartyTxt.visible = false;
        iPodNoMediaFileText.visible = true;
    }

    Connections
    {
        target: (isFrontView == mediaPlayer.isCurrentFrontView)? EngineListener: null //modified by edo.lee 2013.03.07

        onRetranslateUi:
        {
            LocTrigger.retrigger()
            modeAreaWidget.retranslateUI( MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT )
        }
// removed by Dmitry 15.05.13

        onPauseCommandFromVR:
        {
            //mediaPlayer.pause(); //20131016 del function in qml
            EngineListener.Pause();
        }

        onPlayCommandFromVR:
        {
            mediaPlayer.startPlay();
        }

        onNextCommandFromVR:
        {
            mediaPlayer.nextTrack();
        }

        onPrevCommandFromVR:
        {
            mediaPlayer.previousTrack(true);
        }
        //{ add by yongkyun.lee@lge.com 2012.07.24 for CR 11593
        /*  //20131016 is not used
        onSearchCommandFromVR:
        {
            mediaPlayer.startSearchView();
        }
        */
        //} add by yongkyun.lee@lge.com
	// { modified by Sergey 02.08.2103 for ITS#181512
        onFgReceived:
        {
           prBar.nTotalTime = AudioController.GetMediaDuration(AudioController.PlayerMode); //added by suilyou 20140102 ITS 0210820
           // modified by Dmitry 27.08.13 for ITS0186485
           if(optionMenuLoader.status == Loader.Ready && optionMenuLoader.item.visible && optionMenuLoader.item.soundSettings)
              optionMenuLoader.item.quickHide()
           else if (optionMenuLoader.status == Loader.Ready && optionMenuLoader.item.visible && !optionMenuLoader.item.soundSettings)
               tmp_focus_index = LVEnums.FOCUS_OPTION_MENU;
        //deleted for gracenote logo spec changed 20131008
        }
	// } modified by Sergey 02.08.2103 for ITS#181512
        

        // { add by yongkyun.lee@lge.com 2012.08.10 : CR 12912
        onBgReceived:
        {
            //{removed by junam 2013.10.14 for ITS_KOR_195481
            // { added by wonseok.heo for ITS 188640 2013.09.06
            //if(coverCarousel.visible)
            //mediaPlayer.backHandler();
            // } added by wonseok.heo for ITS 188640 2013.09.06
            //}removed by junam

            //{ added by yongkyun.lee 20130417 for : Multi Key-Only First key
            if(playbackControls.is_ff_rew)
                playbackControls.handleJogEvent(playbackControls.keyLock , UIListenerEnum.KEY_STATUS_RELEASED);
            //{ added by yongkyun.lee 20130417
            //remove by edo.lee 2013.06.22

            // modified by Dmitry 12.10.13 for ITS0195164
            // removed by sangmin.seol 2014.03.28 for ITS 0231833 optionmenu close on FG Event.
            //if (AudioController.getFrontLcdMode() && !AudioController.getCamMode() &&
            //   (((UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_REAR) && EngineListenerMain.IsSwapDCEnabled()) ||
            //   ((UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_FRONT) && !EngineListenerMain.IsSwapDCEnabled())))
            //   closeOptionMenu(true);
            // removed by sangmin.seol 2014.03.28 for ITS 0231833 optionmenu close on FG Event.

            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
            // modified by Dmitry 12.10.13 for ITS0195164
            if(isUnsupportedPopupVisible() == true)
            {
               AudioController.isRunFromFileManager = false
               popup_loader.item.closePopup();
            }
            //if (popup.visible)
            //{
            //   AudioController.isRunFromFileManager = false
            //   popup.hidePopup(true)
            //}
            // modified by Dmitry 11.10.13 for ITS0194991
            // } modified by cychoi 2015.06.03
        }

        //{ modified by yongkyun.lee 2013-10-17 for : ITS 196623
        onResetPlaybackControl:
        {
            playbackControls.resetPlaybackControl();
        }
        //} modified by yongkyun.lee 2013-10-17 

        onStartMusicList:
        {
            if (mediaPlayer.state != "listView") //added by junam 2013.01.17 for ITS_NA_220799
            {
                //{changed by junam 2014.01.06 for LIST_ENTRY_POINT
                mediaPlayer.restoreSavedCategoryTab();
                startFileList();

                // { Modified by sangmin.seol for ITS 0231004 2014.03.25 Add property for checking screen trans to copy mode from playerview
                //if(mediaPlayer.copyToJukeBox && AudioListViewModel.getCopyFromMainPlayer())
                if(bTransToCopyEditMode == true)
                {
                    mediaPlayer.editHandler(MP.OPTION_MENU_COPY_TO_JUKEBOX);
                    bTransToCopyEditMode = false;
                }
                // } Modified by sangmin.seol for ITS 0231004 2014.03.25 Add property for checking screen trans to copy mode from playerview
                //}changed by junam
            }
        }

        onTuneTimerOff:
        {
            __LOG( "onTuneTimerOff signal received" );

            // { added by wspark 2012.09.04 for 3PDMS #136569
            if (playbackControls.is_scan)
            {
                playbackControls.setScanState();
            }
            else
            {
                // { changed by junam 2012.10.5 for CR14119
                if (EngineListener.IsPlaying())
                    playbackControls.setPauseState();
                else
                    playbackControls.setPlayState();
                // } changed by junam
            }
            // } added by wspark 2012.09.04 for 3PDMS #136569

            playbackControls.setTuneState(false); // added by wspark 2012.08.17 for DQA #26

            prBar.bTuneTextColor = false;
			playbackControls.bTunePressed = false; // added by edo.lee 2013.11.20 ITS 0210032 

            //{changed by junam 2013.09.05 for ITS_KOR_188224
            //if ((mediaPlayer.state == "disc" || albumView.visible) && !inhibition_item.visible)
            if ((mediaPlayer.state == "disc" || AudioController.isBasicView) && !inhibition_item.visible) // modified by lssanh 2013.03.16 ISV76343 // modified by eugene.seo 2013.02.19
            {
                albumView.sFilesCount = EngineListener.GetFilesCountInfo();
                albumView.sCoverAlbum = cov;
                albumView.sArtistName = art == "" ? qsTranslate("main", "STR_MEDIA_UNKNOWN") : art; // modified by wonseok.heo for tune nob issue 2013.11.12
                albumView.sSongName = tit;
                albumView.sAlbumName = alb == "" ? qsTranslate("main", "STR_MEDIA_UNKNOWN") : alb; // modified by wonseok.heo for tune nob issue 2013.11.12
                albumView.sFolderName = fol;
                //{removed by junam 2013.03.26 for ISV72425
                //albumView.sGenre = gen;
                //albumView.sComposer = com;
                //}removed by juanm

                //albumView.sCategoryId = EngineListener.GetCurrentCategoryId(); //added by aettie.ji 2012.12.18 for new ux
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization // { added by kihyung 2012.08.30 for DVD-Audio
                //if (AudioController.DiscType == MP.DVD_AUDIO)
                //{
                //    textDVDAudioInfo.strDVDAudioTrackNum = AudioController.trackNumber;
                //}
                // } modified by cychoi 2015.06.03 // } added by kihyung
            }
            else
            {                
                prBar.sFilesCount = EngineListener.GetFilesCountInfo();
                albumView.sFilesCount = EngineListener.GetFilesCountInfo();//added by junam 2013.06.01 for enable flowview tune count

                //{changed by junam 2013.06.21 for ITS0175219
                //prBar.sSongName = tit;
                //prBar.sArtistName = art;
                prBar.sSongName = alb;
                prBar.sArtistName = tit;
                //}changed by junam
            }

            EngineListener.tuneReset();
        }        
        
	// { modified by eugeny.novikov 2012.10.11 for CR 14229
        onCloseListView:
        {
            __LOG( "onCloseListView signal received" );
            if (mediaPlayer.state == "listView")
            {
                mediaPlayer.closeListScreen();
            }
            mediaPlayer.showPlayerView(AudioController.isBasicView); //added by junam 2013.12.19 for LIST_ENTRY_POINT
        }

        // {added by wonseok.heo 2013.07.04 disc in out test
        onSendTestModeStatus: //start Teston
        {
           mediaPlayer.discTestMode =  mode;

            mediaPlayer.startPlay();

            if(mediaPlayer.discTestMode == true){
                modeAreaWidget.visible = false
                mediaPlayer.lastRandom = prBar.nRandomStatus;
                mediaPlayer.lastRepeat =prBar.nRepeatStatus;
                mediaPlayer.setDiscTestMode();
                EngineListener.Stop();
                __LOG( " mediaPlayer.discTestMode =" + mediaPlayer.discTestMode );
                discInOut_Test.visible = true;
                albumView.visible = false;
                playbackControls.visible = false;
                coverCarousel.visible = false;
                prBar.btextVisible = false;
                prBar.bPrBarVisible = false;
                prBar.bScanStatus   = true;
                prBar.nRepeatStatus = 0;
                prBar.nRandomStatus = 0;
            }
        }

        // }added by wonseok.heo 2013.07.04 disc in out test


	// { modified by Sergey 02.08.2103 for ITS#181512
        onMenuKeyPressed:
        {
            //if( AudioController.isLoadingScreen) return; //removed by junam 2013.12.10 for code clean

            //{added by junam 2013.08.15 for disable menu icon
            if(AudioController.isControllerDisable(MP.CTRL_DISABLE_MENU))
                return;
            //}added by junam

            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
            if (popup_loader.visible == false) //changed by junam 2013.11.27
            //if (popup_loader.visible == false && popup.visible == false) //changed by junam 2013.11.27
            // } modified by cychoi 2015.06.03
            {
                EngineListener.tuneEnabled = false;
                if(optionMenuLoader.status == Loader.Ready)
                {
                    if (!optionMenuLoader.item.visible)
                    {
                        if(mediaPlayer.state == "listView") // modified for ITS 0207903
                        {
                            listView_loader.item.cancelScroll();
                        }
                        // modified by Dmitry 13.08.13 for ITS0183710
                        optionMenuLoader.item.visible = true
                        optionMenuLoader.item.menuHandler();
                        optionMenuLoader.item.showFocus(); //added by aettie 20131016 menu focus
                        optionMenuLoader.item.showMenu()
                        tmp_focus_index = LVEnums.FOCUS_OPTION_MENU;// modified by Dmitry 26.04.13
                        modeAreaMenuInfoText = "";
                    }
                    else
                    {
                        closeOptionMenu()
                    }
                }
                else
                {
                    optionMenuLoader.source = "DHAVN_AppMediaPlayer_OptionMenu.qml";
                }
            }
        }
        onMenuOptionClose:
        {
        	closeOptionMenu(true) // modified by Sergey 02.10.2013 for ITS#192678
        }
	// } modified by Sergey 02.08.2103 for ITS#181512
        onBackKeyPressed:
        {
            if ( optionMenuLoader.status == Loader.Ready && optionMenuLoader.visible && optionMenuLoader.item.visible ) // modified by Dmitry 03.08.13
            {
                optionMenuLoader.item.backLevel() // modified by Dmitry 26.04.13
            }
            else if ( popup_loader.visible == false )
            {
                mediaPlayer.backHandler();
            }
            // { added by eugene 2013.01.03 for ISV 64016
	    else if (popup_loader.item && popup_loader.visible) 
            {
                // { added by lssanh 2013.02.20 close replace popup
                // { modified by lssanh 2013.02.22 ISV73569
		// modified by ravikanth 20-07-13 for ISV 86974
                if (popup_loader.popup_type == LVEnums.POPUP_TYPE_REPLACE )
                    // || popup_loader.popup_type == LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION )
                    //popup_loader.popup_type == LVEnums.POPUP_TYPE_COPYING ) // delete by eugene.seo 2013.06.10
                {
                    AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_REPLACE, 3);
                }
                else if(popup_loader.popup_type == LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION)
                {
                    if(popup_loader.item.replaceCopy == false)
                        {
                        // dont close popup before check else item content will not be valid
                        popup_loader.item.closePopup();
                        AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION, 1);
                        }
                    else
                        {
                        popup_loader.item.closePopup();
                        AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION, 2);
                    }

                }
                else if(popup_loader.popup_type == LVEnums.POPUP_TYPE_CAPACITY_ERROR) // modified by ravikanth 08-09-13 for ITS 0188765
                {
                    popup_loader.item.closePopup();
                    AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_CAPACITY_ERROR_MANAGE, 0);
                }
                // } modified by lssanh 2013.02.22 ISV73569
                // } added by lssanh 2013.02.20 close replace popup
                // { modified by lssanh 2013.02.26 do not close index popup
                else
                {
                    //popup_loader.item.closePopup(); //removed by Michael.Kim 2013.12.03 for ITS 212510

                    if (popup_loader.popup_type == LVEnums.POPUP_TYPE_IPOD_INDEXING || popup_loader.popup_type == LVEnums.POPUP_TYPE_COPYING) // modified by ravikanth 12.06.13
                    {
                        popup_loader.item.closePopup(); // added by Michael.Kim 2013.12.03 for ITS 212510
                        mediaPlayer.backHandler();
                    }
                    else if(popup_loader.popup_type == LVEnums.POPUP_TYPE_COPY_ALL || popup_loader.popup_type == LVEnums.POPUP_TYPE_DELETE ||
                            popup_loader.popup_type == LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM || popup_loader.popup_type == LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM)	 // modified by cychoi 2016.02.23 for ISV 125334 // modified by sangmin.seol 2013.10.22 ITS-0195517
                    {
                        popup_loader.item.closePopup(); // added by Michael.Kim 2013.12.03 for ITS 212510
		    	// modified by ravikanth for ITS 0188110
                        mediaPlayer.isAllItemsSelected = false
                        mediaPlayer.resetSelectAllItems();
                    }
                    else
                    {
                        popup_loader.item.closePopup(); // modified for ITS 0216025
                    }
                }
                // } modified by lssanh 2013.02.26 do not close index popup
            }			
            // } added by eugene 2013.01.03 for ISV 64016
        }

	//{ deleted by sangmin.seol 2014.09.30 ITS 0249352 close copy to jukebox confirm popup on copy completed in BG State
        //onCloseCopyCancelConfirmPopup: // modified for ITS 0217509
        //{
        //    if (popup_loader.item && popup_loader.visible)
        //    {
        //        if(popup_loader.popup_type == LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM)
        //        {
        //            popup_loader.item.closePopup();
        //        }
        //    }
        //}
	//} deleted by sangmin.seol 2014.09.30 ITS 0249352 close copy to jukebox confirm popup on copy completed in BG State	

        onEjectHardkeyPressed:
        {
            if (!isLongEject)
            {
                __LOG("onEjectHardkeyPressed")
                ejectButtonHandler( mode )
            }
            isLongEject = (mode != 0);
        }

	//deleted for gracenote logo spec changed 20131008
        //{ added by edo.lee 2012.08.23 for adding bt music tab
        onActivateBTTab:
        {
            //{ Modified by Radhakrushna 20121004 cr 14124
            // __LOG ("onActivateBTTab signal: tabId = " + tabId);
            //playbackControls.isBtMusic = isVisible//remove by edo.lee 2013.02.25
            //changeTabModel(tabId);

            if(albumBTView.visible)
            {
                activateTab(tabId, isVisible, isSelected);
            }
            else
            {
                //{ Modified by Radhakrushna 20122512 cr16680
                //modeAreaWidget.btTab = isVisible ;
                //mode_area_model.set(tabId, {"isVisible": isVisible}); remove by edo.lee 2012.12.27 ITS 150907
                //} Modified by Radhakrushna 20122512 cr16680
            }
            //} Modified by Radhakrushna 20121004 cr 14124
        }
        //} added by edo.lee

        //{ added by edo.lee 2012.09.18 for New UX Music(LGE) #43
        onUpdateBTDeviceName:
        {
            __LOG("bIsRemoteCtrl: " + bIsRemoteCtrl)
            mediaPlayer.isAvaiableBTControl= bIsRemoteCtrl
        }
        //} added by edo.lee

        onClearSeekMode: mediaPlayer.clearSeekMode();

        //{ added by junam 2012.10.15 for CR14476
        onClearSeekModeSoftKey:
        {
            __LOG("onClearSeekModeSoftKey: isLongPress " + AudioController.isLongPress);

            if (AudioController.isLongPress == 1)
                playbackControls.handleOnRelease("Next");
            else if(AudioController.isLongPress == -1)
                playbackControls.handleOnRelease("Prev");
        }
        // } added by junam

        // removed by Dmitry 23.04.13

        //{ added by yongkyun.lee 20130413 for : NO CR MP3 List 
        onMp3ListReadState:
        {
            mediaPlayer.setListButtonShow(listRead)
        }
        //} added by yongkyun.lee 20130413 

        // { added by kihyung 2013.5.2
        onHideBasicBTMusic:
        {
            //{ modified by yongkyun.lee 2013-10-16 for :  ITS 195932
            if (albumBTView.status == Loader.Ready)
            {
                albumBTView.item.sSongName  = "Unknown"
                albumBTView.item.sAlbumName = "Unknown"
                albumBTView.item.sArtistName= "Unknown"
            }
            //} modified by yongkyun.lee 2013-10-16 
            __LOG("onHideBasicBTMusic");
            //{ modified by yongkyun.lee 2013-10-16 for : ITS 195737
            playbackControls.isBtMusic = false; 
            playbackControls.setPlayState(); 
            //} modified by yongkyun.lee 2013-10-16 
            albumBTView.visible = false;
        }
        // } added by kihyung 2013.5.2
// added by Dmitry 11.10.13 for ITS0194940
        onCloseUnsupportedPopup:
        {
            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
            // modified by Dmitry 12.10.13 for ITS0195164
            if(isUnsupportedPopupVisible() == true)
            {
               popup_loader.item.closePopup();
            }
           //if (popup.visible)
           //   popup.visible = false
            // } modified by cychoi 2015.06.03
        }
// added by Dmitry 11.10.13 for ITS0194940

        // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
        onUnsupportedPopupClosed:
        {
            __LOG("onUnsupportedPopupClosed signal");
            if (popupType == LVEnums.POPUP_TYPE_NO_MUSIC_FILES)
            {
                if (modeAreaWidget.currentSelectedIndex != MP.JUKEBOX && EngineListener.IsSourceAvailable("Jukebox"))
                {
                    modeAreaWidget.currentSelectedIndex = MP.JUKEBOX;
                }
                EngineListener.HandleBackKey();
            }
            else if (popupType == LVEnums.POPUP_TYPE_UNAVAILABLE_FORMAT && !EngineListener.isAudioOff())
            {
                if(playermodeBeforePopup == AudioController.PlayerMode)
                {
                    AudioController.restoreLastPlay();
                }
            }
            else if (popupType == LVEnums.POPUP_TYPE_ALL_UNAVAILABLE_FORMAT && !EngineListener.isAudioOff())
            {
                EngineListener.SetNotifyAllUnsupported()
            }
        }
        // } modified by cychoi 2015.06.03

        onSetDraggable:  // added ITS 210706,7
        {
            prBar.bDraggable = isDraggable;

            // added SPEC 140103
            if(mediaPlayer.state == "ipod")
            {
                if (isDraggable)
                {
                    if (playbackControls.isBasicControlEnableStatus) // check APPMODE
                        playbackControls.enabled = true;
                    modeAreaWidget.is_lockoutMode = false;
                    modeAreaWidget.isListDisabled = false;
                }
                else
                {
                    closeOptionMenu(true); // ITS 237448
                    playbackControls.enabled = false;
                    modeAreaWidget.is_lockoutMode = true;
                    modeAreaWidget.isListDisabled = true;
                }
                if ( systemPopupVisible == false ) // ITS_247085_247091 247077
                    setDefaultFocus();
            }
        }

        // added by sagnmin.seol 2014.07.02 ITS 0241684
        onInternalPopupClose:
        {
            // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
            if(isUnsupportedPopupVisible() == true)
            {
                AudioController.isRunFromFileManager = false
            }
            //if (popup.visible)
            //{
            //    AudioController.isRunFromFileManager = false
            //    popup.visible = false;
            //    bNeedDelayedPopup = false;
            //}
            // } modified by cychoi 2015.06.03

            if(popup_loader.item && popup_loader.visible)
            {
                bNeedDelayedPopup = false;
                popup_loader.item.closePopup()
            }
        }
    }
    // { added by wspark 2012.12.20 for ITS150787
    Connections
    {
        target: EngineListenerMain
        onMiddleEastChanged:
        {
            albumView.sFilesCount = EngineListener.GetFilesCountInfo();
        }
        onSignalAudioFgReceived:
        {
            //AudioController.isBasicView();//added by suilyou ITS 0206043 remove by ys ITS-207232
            __LOG("audio onSignalFgReceived temp:" +  fgState);

            EngineListener.setAudioTempMode(fgState); // added by sangmin.seol 2014.07.16 seperation isTempMode memeber variable

            if((/*mediaPlayer.state == "keypad" || mediaPlayer.state == "searchView" ||*/ mediaPlayer.state == "listView" || AudioController.isBasicView == false) && fgState)  //removed by junam 2013.09.23 for not using code
            {
                bGoingToSearch = true;
            }
            else
            {
                bGoingToSearch = false;
            }
            // { modified by sangmin.seol 2014.07.14 ITS 0242815 remain focus temporal fg mode
            //if(AudioController.getFrontLcdMode()){//added by Taihyun.ahn for ITS 0194172
            //    setDefaultFocus() // added by Dmitry 23.04.13
            //}
            if(!fgState)
            {
                closeOptionMenu(true); // added by suilyou 20131114 ITS 0208566
                setDefaultFocus();
            }
            // } modified by sangmin.seol 2014.07.14 ITS 0242815 remain focus temporal fg mode

            // { added by sangmin.seol 2014.04.24 ITS 0235546, 0235551 reset TuneState when Audio FG Received
            prBar.bTuneTextColor = false;
            playbackControls.setTuneState(false);
            // } added by sangmin.seol 2014.04.24 ITS 0235546, 0235551 reset TuneState when Audio FG Received
        }
        //added by edo.lee 2013.03.07

// removed by Dmitry 11.10.13 for ITS0194991

        onIsCurrentFrontViewChanged:
        {
            //{changed by junam 2013.12.30 for LIST_ENTRY_POINT
            if(mediaPlayer.isCurrentFrontView != isFront)
            {
                if( listView_loader.status == Loader.Ready && mediaPlayer.state == "listView")
                    mediaPlayer.closeListScreen();
                if(popup_loader.status == Loader.Ready)
                    popup_loader.item.closePopup();
            }
            //}changed by junam
            __LOG("isFront : "+isFront+" isFrontView : "+isFrontView)
            mediaPlayer.isCurrentFrontView = isFront;
        }
        //added by edo.lee
        //added by edo.lee 2013.06.07 for reset visual cue icon
        onClearPlaybackJog:
        {
                __LOG(" onClearPlaybackJog");
        	clearPlaybackControlsJog(); //added by edo.lee 2013.06.05
        }



        // { added by wonseok.heo 2013.07.04 disc in out test
        onDiscStatusData:
        {

            mediaPlayer.discStatus = statuschk;
            __LOG(" DiscStatusData :  " + statuschk);
            switch(mediaPlayer.discStatus){
            case 3:
                //EngineListener.Play();
            case 7:
            case 9:
            case 10:
            {
                //prBar.visible = true;
                mediaPlayer.testDiscStatus = "Disc Loading";
                //discTestCount.text=  mediaPlayer.testCount  + "/" + mediaPlayer.testFullCount;

                if(mediaPlayer.testCount == 10000)
                {
                    mediaPlayer.testCount = 0;
                    //mediaPlayer.testStatus = "-";
                   // isPassfail.text = "-";
                }
                break;
            }
            //case 6:
            case 8:
            {
                //prBar.visible = false;
                mediaPlayer.testDiscStatus = "Disc ejecting";
                //prBar.nCurrentTime =0;
                //mediaPlayer.testStatus = "-";
                break;
            }
            case 99:
            {
                mediaPlayer.testCount = 0;
                mediaPlayer.discTestModeOff();
                mediaPlayer.discTestMode = false;
                discInOut_Test.visible = false;
                albumView.visible = true;
                playbackControls.visible = true;
                coverCarousel.visible = true;
                prBar.bPrBarVisible = true;
                prBar.bScanStatus   = false;
                prBar.nRandomStatus = mediaPlayer.lastRandom;
                prBar.nRepeatStatus = mediaPlayer.lastRepeat;
                modeAreaWidget.visible = true;
                mediaPlayer.discErrorChk = 0;
                mediaPlayer.backHandler();

                break;
            }


            default:{
                return;
            }

            }
        }


        onDeckTestError:
        {

            mediaPlayer.discErrorChk = errorValue;
            __LOG(" disc Error :  " + discErrorChk);
            isPassfail.text = "FAIL";

            switch(mediaPlayer.discErrorChk){
            case 81:{
                discTestCount.text = "PLAYER_FILENOTSUPPORTED";
                EngineListener.Stop();

                break;
            }
            case 82:{
                discTestCount.text= "PLAYER_FILENOTFOUND";
                EngineListener.Stop();

                break;
            }
            case 83:{
                discTestCount.text= "PLAYER_COMMANDNOTSUPPORTED";
                EngineListener.Stop();

                break;
            }
            case 84:{
                discTestCount.text= "PLAYER_INVALIDSTATE";
                EngineListener.Stop();

                break;
            }
            case 85:{
                discTestCount.text= "PLAYER_DISCCORRUPTED";
                EngineListener.Stop();

                break;
            }
            case 86:{
                discTestCount.text= "PLAYER_DISCNOTLOADED";
                EngineListener.Stop();

                break;
            }
            case 87:{
                discTestCount.text= "PLAYER_HIGHTEMPERATURE";
                EngineListener.Stop();

                break;
            }
            case 88:{
                discTestCount.text = "PLAYER_NOMEDIA";
                EngineListener.Stop();

                break;
            }
            case 89:{
                discTestCount.text = "PLAYER_DISC_READ_ERROR";

                break;
            }
            case 90:{
                discTestCount.text = "PLAYER_DISC_MECHANIC_ERROR";

                break;
            }
            case 91:{
                discTestCount.text = "PLAYER_DISC_LOW_CONSUMPTION";
                EngineListener.Stop();

                break;
            }
            case 92:{
                discTestCount.text = "PLAYER_DISC_REGION_ERROR";
                EngineListener.Stop();

                break;
            }
            case 93:{
                discTestCount.text = "PLAYER_DISC_PARENTAL_ERROR";
                EngineListener.Stop();

                break;
            }
            case 94:{
                discTestCount.text = "PLAYER_DISC_DRM_ALL_UNSUPPORTED";
                EngineListener.Stop();

                break;
            }
            default:{
                return;
            }

            }

        }
        //}added by wonseok.heo 2013.07.04 disc in out test

        //{added by junam 2013.07.06 for ITS178188
        onNotifyBtCallProgressing:
        {
            EngineListenerMain.qmlLog("onNotifyBtCallProgressing = "+value)
            if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
            {
                if(value && EngineListenerMain.getisBTCall()) // modified ITS 220833
                {
                    EngineListener.onTuneTimerStop(); // ITS 247229
                    hideUITimer.start();
                    //mediaPlayer.showPlayerView(true)
                }
            }
            //EngineListener.tuneEnabled = value ? false : true;
        }
        //}added by junam

         //added by suilyou ITS 0192903 START
//         onSignalACCchanged:
//         {
//             closeOptionMenu();
//         }
         //added by suilyou ITS 0192903 END
/*        onCamEnable:
        {
            if(on ==true)//added by suilyou 20131106 ITS 0206832
                AudioController.cancelFFRW();
         }*/ // removed by suilyou 20131127 DUAL_KEY
    }
    // } added by wspark

    Connections
    {
        target: (isFrontView == mediaPlayer.isCurrentFrontView && AudioController.isForeground)? /*UIListener*/EngineListener:null // modified by Dmitry 16.05.13
        // modified by Dmitry 16.05.13
        onSignalJogNavigation:
        {
            __LOG("onSignalJogNavigation mediaPlayer " + mediaPlayer.focus_index);

            if (mediaPlayer.focus_index == LVEnums.FOCUS_NONE)
            {
                if (popup_loader.visible)
                {
                    mediaPlayer.tmp_focus_index = popup_loader.setDefaultFocus(arrow)
                }
                else
                {
                    mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT;
                    mediaPlayer.setDefaultFocus();
                }
            }
            else if (mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)
            {
                // added by sangmin.seol 2014.07.21 for ITS 0242575
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                if( arrow == UIListenerEnum.JOG_CENTER && popup_loader.visible)
                //if( arrow == UIListenerEnum.JOG_CENTER && (popup.visible || popup_loader.visible))
                // } modified by cychoi 2015.06.03
                {
                    return;
                }

                changeHighlight(arrow, status, nRepeat) //changed by junam 2013.11.13 for add repeat
            }

            if (mediaPlayer.focus_index == LVEnums.FOCUS_PLAYBACK_CONTROL)
            {
                EngineListener.setFocusPlaybackControl(true);
            }
            else
            {
                EngineListener.setFocusPlaybackControl(false);
            }
        }
        // modified by Dmitry 16.05.13
    }

    //{added by junam 2014.01.10 for ITS_NA_218638
    Connections
    {
        target: (isFrontView == mediaPlayer.isCurrentFrontView && AudioController.isForeground)? UIListener :null 
    //}added by junam
        onSignalShowSystemPopup:
        {
            __LOG("signalShowSystemPopup");

            // { added by cychoi 2105.08.06 for the focus disappeared when opened System Popup consecutively
            if(systemPopupVisible==true)
            {
                __LOG("ignore signalShowSystemPopup if already opened System Popup")
                return
            }
            // } added by cychoi 2105.08.06

            if ( optionMenuLoader.status == Loader.Ready && optionMenuLoader.visible && optionMenuLoader.item.visible )
            {
                //optionMenuLoader.item.quickHide(); // added by Sergey 02.08.2103 for ITS#181512
                EngineListenerMain.invokeMethod(optionMenuLoader.item,"quickHide"); //modified by edo.lee 2013.11.22 hideoption is changed to use invoke method
                optionMenuLoader.item.visible = false;

		// { modified by sangmin.seol 2014.06.18 ITS 0240658
                if(mediaPlayer.state == "listView" || coverCarousel.visible == true)
                {
                    last_Focus_flag = LVEnums.FOCUS_CONTENT;
                }
                else
                {
                    last_Focus_flag = LVEnums.FOCUS_PLAYBACK_CONTROL;
                }
		// } modified by sangmin.seol 2014.06.18 ITS 0240658

                tmp_focus_index = LVEnums.FOCUS_NONE;
                focus_index = tmp_focus_index;
            }else {
                if (popup_loader.status == Loader.Ready && popup_loader.item.visible) {
                    //popup_loader.item.closePopup();
                    popup_loader.item.resetOnPopUp(); //modified by sangmin.seol ITS 0239925 change function name. // modified for ITS 0190394
                }

                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                if(isUnsupportedPopupVisible() == true)
                {
                    popup_loader.item.closePopup();
                }
                // { added by sangmin.seol 2014.06.12 ITS 0239773
                //if(popup.visible == true)
                //{
                //    popup.hidePopup(true); // modified by eugene.seo 2013.04.10
                //}
                // } added by sangmin.seol 2014.06.12 ITS 0239773
                // } modified by cychoi 2015.06.03

                last_Focus_flag = tmp_focus_index;
                tmp_focus_index = LVEnums.FOCUS_NONE;
                focus_index = tmp_focus_index;
            }
            albumView.gesture_enable = false; // modified by ravikanth 02-10-13 for ITS 0190988
            systemPopupVisible = true;        // added by sangmin.seol for ITS 0217570 2013.12.30
        }

        onSignalHideSystemPopup:
        {
            __LOG("signalHideSystemPopup last_Focus_flag = " + last_Focus_flag);

            if(systemPopupVisible==false)
            {
                __LOG("ignore invalid signalHideSystemPopup");
                return; // suilyou 20140319 ITS 0229970
            }

            albumView.gesture_enable = true; // modified by ravikanth 02-10-13 for ITS 0190988
            // { modified by sangmin.seol 2014.06.18 ITS 0240658
            //if(last_Focus_flag == LVEnums.FOCUS_PLAYBACK_CONTROL){
            tmp_focus_index = last_Focus_flag;
            focus_index = tmp_focus_index;
	    // { modified by sangmin.seol 2015.01.08 for move focus to control cue on TuneWheel after closing systemPopup
            if(mediaPlayer.state == "listView" && last_Focus_flag == LVEnums.FOCUS_CONTENT)
            {
                setDefaultFocus()
            }
	    // } modified by sangmin.seol 2015.01.08
            /*}else{
                tmp_focus_index = last_Focus_flag;
                focus_index = tmp_focus_index;
            }*/
            // } modified by sangmin.seol 2014.06.18 ITS 0240658

            systemPopupVisible = false;        // added by sangmin.seol for ITS 0217570 2013.12.30

            // { added by sangmin.seol 2014.06.12 ITS 0239773
            if( bNeedDelayedPopup == true )
            {
                __LOG("signalHideSystemPopup delayedPopupType" + delayedPopupType);

                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                //if(delayedPopupType == -1 && AudioController.isEnableErrorPopup)
                //{
                //    popup.visible = true;
                //    popup.setFocus();
                //    AudioController.setIsShowPopup(true);
                //    AudioController.isEnableErrorPopup = false;
                //}
                //else
                // } modified by cychoi 2015.06.03
                {
                    popup_loader.showPopup(delayedPopupType);
                }

                bNeedDelayedPopup = false;
            }
            // } added by sangmin.seol 2014.06.12 ITS 0239773
        }
    }

    Loader { id: jukeboxTab; parent: mainViewArea }
    Loader { id: discTab; parent: mainViewArea }
    Loader { id: ipodTab; parent: mainViewArea }
    Loader { id: auxTab; parent: mainViewArea }
// modified by Dmitry 17.05.13
    Loader {
       id: listView_loader;

       onLoaded:
       {
          item.connect(lostFocus)
       }

       Connections
       {
          target: listView_loader.item

          onLostFocus:
          {
              EngineListenerMain.qmlLog("ListView lostFocus")
              if (UIListenerEnum.JOG_UP == arrow)
                 tmp_focus_index = modeAreaWidget.setDefaultFocus(arrow);
          }
       }
    }
    //{ removed by junam 2013.12.10 for code clean
    //Loader
    //{
    //    id: loadingScreen_loader

    //    anchors.fill: parent
    //    z: 1001

    //    source: AudioController.isLoadingScreen || (EngineListener.loadingOnCopy && mediaPlayer.state != "listView") ? "DHAVN_AppMediaPlayer_LoadingScreen.qml" : "" // modified by ravikanth 18-04-13
    //}
    //} removed by junam

    Loader
    {
        id: optionMenuLoader;
        z: 1200
        //added by suilyou 20131014 ITS 0195275 START
        onVisibleChanged:
        {
            if(optionMenuLoader.item.visible)
              optionMenuLoader.item.showFocus();
            else
              optionMenuLoader.item.hideFocus();
        }
        //added by suilyou 20131014 ITS 0195275 END
	// { added by Sergey 02.08.2103 for ITS#181512
        onStatusChanged:
        {
            if (optionMenuLoader.status == Loader.Ready)
            {
                if (!optionMenuLoader.item.visible)
                {
                    if(mediaPlayer.state == "listView") // modified for ITS 0207903
                    {
                        listView_loader.item.cancelScroll();
                    }
// modified by Dmitry 13.08.13 for ITS0183710
                    optionMenuLoader.item.visible = true
                    optionMenuLoader.item.menuHandler()
                    optionMenuLoader.item.showMenu()
                    optionMenuLoader.item.showFocus(); //added by aettie 20131016 menu focus
                    tmp_focus_index = LVEnums.FOCUS_OPTION_MENU
                    modeAreaMenuInfoText = ""
                }
            }
        }
	// } added by Sergey 02.08.2103 for ITS#181512

        // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
        property bool popupVisible: popup_loader.visible;
        //property bool popupVisible: popup.visible || popup_loader.visible;
        // } modified by cychoi 2015.06.03
    }

    Timer
    {
        id: rateKeeper
        interval: 2000
        repeat: false
        onTriggered:
        {
            __LOG("onTriggered rateKeeper");

            if (AudioController.isLongPress == 1)
                EngineListener.HandleFF20X();
            else if (AudioController.isLongPress == -1)
                EngineListener.HandleRW20X();
        }
    }

    // { added by eugeny.novikov 2012.10.25 for CR 14047
    // This timer is necessary to enable ModeArea enyway in exceptional cases after 2 sec
    Timer
    {
        id: modeAreaTimer
        interval: 2000
        repeat: false

        onTriggered:
        {
            __LOG("onTriggered modeAreaTimer");
            mediaPlayer.enableModeAreaTabs(true);
        }
    }
    // } added by eugeny.novikov

    DHAVN_AppMediaPlayer_PopUpLoader
    {
        id: popup_loader
        z: 10
        //anchors.fill: parent
        y: 93 //modified by aettie 20130611 for ITS 167263

        // { added by junggil 2012.07.31 for CR11820
        function setFocus()
        {
            if (mediaPlayer.focus_index != LVEnums.FOCUS_NONE)
            {
                tmp_focus_index = popup_loader.setDefaultFocus(UIListenerEnum.JOG_DOWN);
            }
        }
        // } added by junggil

        // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
        Timer
        {
            id: hideUITimer
            interval: 2000
            repeat: false
            onTriggered:
            {
                mediaPlayer.showPlayerView(true);
            }
        }
        // } modified by cychoi 2015.06.03
    }

    //{added by junam 2013.11.22 for coverflow click
    Timer
    {
        id: screenTransitionDisableTimer
        interval: 1000
        running: false
    }
    //}added by junam
}
// } modified by eugeny.novikov 2012.11.30 for CR 16133
