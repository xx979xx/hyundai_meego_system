 // modified by Dmitry 07.05.13
import Qt 4.7
import QtQuick 1.1//Changed by Alexey Edelev 2012.10.15
import AppEngineQMLConstants 1.0
import AudioControllerEnums 1.0
import QmlSimpleItems 1.0
import QmlBottomAreaWidget 1.0
import ListViewEnums 1.0

import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

Item
{
    id : root_list
    height: MPC.const_APP_MUSIC_PLAYER_LIST_VIEW_HEIGHT
    width:  MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH

    LayoutMirroring.enabled: EngineListenerMain.middleEast
    LayoutMirroring.childrenInherit: EngineListenerMain.middleEast

    property int currentCategoryIndex;
    property string currentTabText: currentLoaderTab.item.categoryModel.get(currentCategoryIndex).cat_id;
//{modified by HWS 2013.03.24 for New UX
    property string currentListText: ""; //HWS
    property string compareFolders: ""; //HWS
    property string compareIcon: ""; //HWSE
//}modified by HWS 2013.03.24 for New UX
    /* currentLoaderTab holds active loader */
    property Loader currentLoaderTab;

    property bool isEditMode: false;
    property bool isCopyMode: false;
    property int  menuMode: 0;
    property int prevCategory: currentCategoryIndex;
    property int backupCount : -1 //  modified by yongkyun.lee 2013-08-19 for : NO CR MP3 list 0 - default focus
    /* Property to enable/disable checkbox for edit mode for Jukebox/USB source */
    property bool isCheckBoxEnabled: false;
    // { modified by lssanh 2012.01.24 ISV69815 rollback
//{modified by aettie 2013.03.21 for touch focus rule
    //property bool isListSelected:isCD? true:false; //modified by aettie 2013.02.25 for ISV 68153
    //[KOR][ITS][178101][ minor](aettie.ji)
    //[KOR][ITS][179014][comment](aettie.ji)
    property bool isListSelected:(isCD||!bgListCategory.visible)? true: (isTitleSelected ||isCategorySelected)? false : true; //modified by wonseok.heo fo new UX 2013.07.10
    property bool isTitleSelected:(isListSelected ||isCategorySelected)? false : true; 
    property bool isCategorySelected: (isListSelected ||isTitleSelected)? false : true;
//}modified by aettie 2013.03.21 for touch focus rule
    // } modified by lssanh 2012.01.24 ISV69815
    property string path: AudioListViewModel.JUKEBOX_ROOT;
    property string textItemViewList: "";
    property bool isVisibleText: false;
    property bool isCD:false    // Add by Naeo 2012.07.09 for CR 10970
    property bool isFirstRequestODCA: false; // added by kihyung 2012.07.11 for CR 11165
    // added by minho 2012.07.16
    // { for CR11940: additional fix for CR10185
    property int topItemTempIndex: -1; 
    property int bottomItemTempIndex: 0;
    // { added by junggil 2012.09.19 for CR13628 [Plan-B: Jukebox] Toast index letter is not displayed consistantly when scroll anywhere in music list screen using CCP Jogdial.
    property string currentIndexHistoryText: "";
    // } added by junggil
    // } add by minho
    property bool isPlaying:AudioController.IsPlaying() ? true : false //added by edo.lee 2013.01.24
    //property bool panning: false // rollbacked by cychoi 2015.10.13 for ITS 268465
    //property bool flicking: false // rollbacked by cychoi 2015.10.13 for ITS 268465

    property bool callFromCategory: false; 	//added by aettie 2013.04.05 for QA 41
    property bool changeFocusToList: false // added by Dmitry 20.04.13
    property bool requestForCopyAll: false // modified by ravikanth 28-04-13
    property bool jogCenterPressed: false // added by Dmitry 15.05.13
    property bool scrollingTicker: EngineListenerMain.scrollingTicker; //modified by aettie for ticker stop when DRS on
    property alias isCategoryEditMode : ipodCategoryEdit.visible //added by junam 2013.5.28 for ISV_KR84025
     property bool copyAllItemsListCreated: false // modified by ravikanth for 19.06.13 SMOKE_TC 7 & SANITY_CM_AK347

    property string currentFileOperationState:"" // modified by ravikanth 29-06-13 for ITS 0176909
    //removed by junam 2013.07.20 for ITS_NA_179108
    //property bool ipodList : (AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)? true: false

    //added by aettie 20130808 for category dimming(ITS 182674)
    property bool categoryDimmed: AudioListViewModel.isCategoryTabAvailable()? false : true;
    // {added by jaehwan 2013.10.26 for ISV 90617
    property string lastScrollLetter:"";
    property bool isScrolling:false;
    //} added by jaehwan
    property bool blockKeys: false // added by Dmitry 06.11.13 for ITS94041
    
    signal lostFocus(variant arrow) // added by Dmitry 17.05.13


    function __LOG( textLog )
    {
        if(mediaPlayer.isCurrentFrontView)
            EngineListenerMain.qmlLog("DHAVN_AppMediaPlayer_ListView.qml[F]: " + textLog);
        else
            EngineListenerMain.qmlLog("DHAVN_AppMediaPlayer_ListView.qml[R]: " + textLog);
    }
//{ added by eunhye 2012.09.04 for New UX
        function setQuickScrollVisible(visible)
    {
        quickScroll.visible = visible;
    }
//} added by eunhye 2012.09.04
    function backHandler()
    {
        // { rollbacked by cychoi 2015.10.13 for ITS 268465
        //if (root_list.panning || root_list.flicking) return
        if (itemViewList.moving || itemViewList.flicking) return //added by wonseok.heo for ITS 205899 2013.11.01
        // } rollbacked by cychoi 2015.10.13

// modified by Dmitry 05.10.13
        if (ipodCategoryEdit.visible)
        {
           currentLoaderTab.item.editHandler();
           setCategory (categoryTabList.currentIndex);
           return
        }

        if (isEditMode)
        {
            
            mediaPlayer.setDefaultFocus()
            cancelEditMode()
            return;
        }
// modified by Dmitry 05.10.13

        AudioListViewModel.resetPartialFetchData();

        EngineListener.onTuneTimerStop();   //added by sangmin.seol 2013.12.17 for ITS 0216026 TuneTimer stop when switched PlayerView.

        /* If Back key event is not handled by current tab, handle it here */
        if (!currentLoaderTab.item.backHandler())
        {
            //{changed by junam 2013.12.19 for LIST_ENTRY_POINT
            //AudioListViewModel.resetRequestData();
            //mediaPlayer.state = EngineListener.popScreen();
            //listView_loader.source = "" // added by ruindmby 2012.09.05 for CR13444
            //mediaPlayer.setDefaultFocus(); // added by Dmitry 23.04.13

            //switch (mediaPlayer.state)
            //{
            //    case ("jukebox"):
            //    {
            //        jukeboxTab.item.currentCategoryIndexJukeBox = currentCategoryIndex;
            //        break;
            //    }
            //    case ("usb"):
            //    {
            //        jukeboxTab.item.currentCategoryIndexUSB = currentCategoryIndex;
            //                AudioListViewModel.setCopyCompletedMode(false); // added by eugene 2012.11.29 for CR 16076
            //        break;
            //    }
            //    case ("ipod"):
            //    {
            //        ipodTab.item.currentCategoryIndex = currentCategoryIndex;
            //        break;
            //    }
            //    default:
            //    {
            //        __LOG("Undefined screen state");
            //        break;
            //    }
            //}
            //EngineListener.setFileManagerBG(); //added by edo.lee 2013.08.11
            //AudioController.setListMode(false);
            EngineListener.showListView(false);
            //}changed by junam

            AudioListViewModel.displayMode = AudioController.PlayerMode;
            if( AudioController.PlayerMode == MP.JUKEBOX && !EngineListener.IsSourceAvailable( "Jukebox" ) )
            {
                // { modified by cychoi 2015.06.03 for Audio/Video QML optimization
                popup_loader.showPopup(LVEnums.POPUP_TYPE_NO_MUSIC_FILES);
                //popup.message = noPlayableFileModel;
                //popupTimer.start();
                //popup.setFocus();
                //popup.visible = true;
                // } modified by cychoi 2015.06.03
                return;
            }
            // } added by wspark
            // } added by wspark
            //{removed by junam 2013.12.19 for LIST_ENTRY_POINT
            //if (AudioController.isBasicView == false)
            //    EngineListener.requestCovers();
            //}added by junam
        }
        else
        {
            // { moved by cychoi 2014.08.12 for ITS 245188, ITS 245190 list focus
            if (AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.MP3_CD)
            {
                centerCurrentPlayingItem();
            } //added by aettie 2013.02.25 for ISV 62706
            // } moved by cychoi 2014.08.12

            // modified by ruindmby 2012.09.05 for CR 13444
            if (AudioController.PlayerMode == MP.JUKEBOX)
            {
               currentLoaderTab.item.currentCategoryIndexJukeBox = currentCategoryIndex;
            }
            else if (AudioController.PlayerMode == MP.USB1 || AudioController.PlayerMode == MP.USB2)
            {
               currentLoaderTab.item.currentCategoryIndexUSB = currentCategoryIndex;
            } //{added by junam 2013.06.09 for etc focus
            else if (AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
            {
                currentLoaderTab.item.currentCategoryIndex = currentCategoryIndex;
                if(ipodTab.item.itemViewListModel  == ipodTab.item.categoryEtc)
                {
                    itemViewList.currentIndex = ipodTab.item.currentEtcIndex;
                }
            }//}added by junam
            else
            {
                currentLoaderTab.item.currentCategoryIndex = currentCategoryIndex;
            }
            // modified by ruindmby 2012.09.05 for CR 13444
        }
        //listView_loader.source = "" // removed by ruindmby 2012.09.05 for CR 13444

        // { deleted by wspark 2012.11.13 for playing song after copying to JB.
        // { added by wspark 2012.11.06 for showing no files popup after deleting all jukebox audio.
        /*
        AudioController.setListMode(false);
        AudioListViewModel.displayMode = AudioController.PlayerMode;
        if( AudioController.PlayerMode == MP.JUKEBOX && !EngineListener.IsSourceAvailable( "Jukebox" ) )
        {
            popup_loader.showPopup(LVEnums.POPUP_TYPE_NO_MUSIC_FILES);
            return;
        }
        */
        // } added by wspark
        // } deleted by wspark
        //[KOR][ITS][179014][comment](aettie.ji)
        isCategorySelected = false;
        isListSelected = true;
        isTitleSelected = false;


    }

// added by Dmitry 31.07.13 for ITS0180216
    function setDefaultFocus()
    {
        //{ modified by yongkyun.lee 2013-08-19 for : NO CR MP3 list 0 - default focus
        __LOG("setDefaultFocus()" + itemViewList.count);
        //{changed by junam 2013.10.10 for ITS_KOR_194644
        //if(itemViewList.count == 0)
        if(itemViewList.count == 0 && AudioController.PlayerMode == MP.DISC) //}changed by junam
        {
            isListSelected = false;
            isTitleSelected = true;
            isCategorySelected = false;
        }
        //} modified by yongkyun.lee 2013-08-19
        else if (itemViewList.count == 0 && (AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2))  // added for ITS 206519 // modified 2013.11.07
        {
            if(root_list.isVisibleText)
            {
                isListSelected = false;
                isTitleSelected = true;
                isCategorySelected = false;
            }
            else
            {
                isListSelected = false;
                isTitleSelected = false;
                isCategorySelected = true;
            }
        }
        else
        {
            isCategorySelected = false;
            isListSelected = true;
            isTitleSelected = false;
        }

        //{removed by junam 2013.10.30
        //if(currentLoaderTab == ipodTab)
        //    ipodTab.item.findHiddenFocus();
        //}removed by junam
    }
// added by Dmitry 31.07.13 for ITS0180216

    // { added by cychoi 2015.11.03 for ITS 269955
    function moveFocusToBottom()
    {
        __LOG("moveFocusToBottom()")
        if (EngineListenerMain.middleEast)
        {
            //itemViewList.lostFocus ( UIListenerEnum.JOG_LEFT )
            mediaPlayer.tmp_focus_index = rightButtonArea.setDefaultFocus( UIListenerEnum.JOG_WHEEL_LEFT )
        }
        else
        {
            //itemViewList.lostFocus ( UIListenerEnum.JOG_RIGHT )
            mediaPlayer.tmp_focus_index = rightButtonArea.setDefaultFocus( UIListenerEnum.JOG_WHEEL_RIGHT )
        }
        isListSelected = false
    }
    // } added by cychoi 2015.11.03

    // { added by honggi.shin 2013.11.04 for empty list focus issue after deleting music files
    function setEmptyMusicListFocus()
    {
        if(currentLoaderTab == jukeboxTab && root_list.isVisibleText && itemViewList.count == 0 )
        {
            isListSelected = false;
            isTitleSelected = true;
            isCategorySelected = false;
        }
    }
    // } added by honggi.shin 2013.11.04
    function cancelScroll() // modified for ITS 0207903
    {
        itemViewList.cancelFlick()
    }

    /* This function do not switches to previous category */
    function finishEditMode()
    {
        __LOG("finishEditMode()");
        if (AudioListViewModel.operation == LVEnums.OPERATION_ADD_TO_PLAYLIST)
            //setCategory(0);
            setCategory(5); //modified by aettie 2013.01.16 for ISV 68135/68124

        resetEditModeData();
    }

    function cancelEditMode()
    {
        if (isEditMode) //added by junam 2012.10.16 for CR14568
        {
            __LOG("cancelEditMode() displayMode: " + AudioController.PlayerMode);
            /* { deleted by yungi 2013.2.18 for UX Scenario 5. File Copy step reduction
                // { modified by eugene 2012.11.29 for CR 16076
          	if(AudioListViewModel.getCopyCompletedMode() == true)
          	{
          		AudioListViewModel.displayMode = MP.JUKEBOX;
				prevCategory = 3;  
          	}
			else
           */ //} deleted by yungi 2013.2.18 for UX Scenario 5. File Copy step reduction
	            AudioListViewModel.displayMode = AudioController.PlayerMode;
			// } modified by eugene 2012.11.29 for CR 16076

            setCategory(prevCategory);
            //{added by junam 2013.11.21 for ISV_EU_95040
            //if( currentLoaderTab.item.itemViewListModel.currentPlayingItem >= 0 ) // modified by ravikanth 25-06-13 for ITS 0176195
            //	itemViewList.currentIndex = currentLoaderTab.item.itemViewListModel.currentPlayingItem;
            //}added by junam

            resetEditModeData();
            //AudioListViewModel.requestUpdateListData(); // added by eugeny.novikov 2012.11.02 for CR 14824 // deleted by yungi 2013.02.27 for No CR UpdateListdata overlap

        }
        //{added by junam 2013.10.15 for ITS_EU_195234
        if (ipodCategoryEdit.visible )
        {
            currentLoaderTab.item.editHandler();
            setCategory (categoryTabList.currentIndex);
        }
        //}added by junam
    }

    function resetEditModeData()
    {
        rightButtonArea.curModel = null;
        isEditMode = false;
        isCheckBoxEnabled = false;
        isCopyMode = false;
        AudioListViewModel.setIsCreatingUrlList(false); // added by eugene.seo 2013.04.05
	// modifed by ravikanth for ITS 0189469, 0189876
        //if((popup_loader.popup_type != LVEnums.POPUP_TYPE_COPYING) && (popup_loader.popup_type != LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION)) // modified by eugene.seo 2012.10.23 for Function_USB_0190
        if(EngineListener.getCancelEditModeCheck() == false) //added by Michael.Kim 2014.08.26 for ITS 246688 
            AudioListViewModel.operation = LVEnums.OPERATION_NONE; // modified by eugeny.novikov 2012.10.11 for CR 14229
        //mediaPlayer.hideKeyPad();//removed by junam 2013.09.23 for not using code
        mediaPlayer.updateModeAreaHeader();
        emptyText.visible=false; //added by aettie.ji 2013.01.24 for ISV 70695 
    // { added by yungi 2013.03.06 for New UX FileCount
        AudioListViewModel.setFileURLCount(0);
        mediaPlayer.modeAreaFileCount = "";
	//[KOR][ITS][179014][comment](aettie.ji)
        AudioListViewModel.setCopyFromMainPlayer(false); 
        isCategorySelected = false;
        isListSelected = true;
        isTitleSelected = false;
        updateListCountInfo();
        EngineListener.setCancelEditModeCheck(false); //added by Michael.Kim 2014.08.26 for ITS 246688 
            // } added by yungi 2013.03.06 for New UX FileCount
    }

    function enableEditMode()
    {
        isEditMode = true;
        isCheckBoxEnabled = true;

        AudioListViewModel.enableAllCheckBoxes(false);
        AudioListViewModel.backupFileOperationData();
        mediaPlayer.modeAreaFileCount = "(0)"; //added by yungi 2013.03.06 for New UX FileCount

        if( currentLoaderTab.item.itemViewListModel.currentPlayingItem >= 0 ) // modified by ravikanth 25-06-13 for ITS 0176195
        {
            //itemViewList.currentIndex = currentLoaderTab.item.itemViewListModel.currentPlayingItem; //removed by junam 2013.11.21 for ISV_EU_95040
            //[KOR][ITS][179014][comment](aettie.ji)
            if(mediaPlayer.copyToJukeBox&&AudioListViewModel.getCopyFromMainPlayer())
            {
                itemViewList.currentIndex = currentLoaderTab.item.itemViewListModel.currentPlayingItem;  //added by junam 2013.11.21 for ISV_EU_95040
                currentLoaderTab.item.itemElementHandler (itemViewList.currentIndex, isCheckBoxEnabled);
            }
            mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")"; // modified by ravikanth 06-07-13 for Sanity fix selected items logic was not proper.
        } //[KOR][ISV][79666][B](aettie.ji)

        if ((AudioController.PlayerMode == MP.USB1 ||
             AudioController.PlayerMode == MP.USB2) &&
             menuMode == MP.OPTION_MENU_COPY_TO_JUKEBOX)
        {
            path = AudioListViewModel.JUKEBOX_ROOT;
            AudioListViewModel.operation = LVEnums.OPERATION_COPY;
        }
        else if (menuMode == MP.OPTION_MENU_ADD_TO_PLAYLIST)
        {
            AudioListViewModel.operation = LVEnums.OPERATION_ADD_TO_PLAYLIST;
        }
        //else if (AudioController.PlayerMode == MP.JUKEBOX )
        else if (AudioController.PlayerMode == MP.JUKEBOX || AudioListViewModel.getCopyCompletedMode() == true) // modified by eugene 2012.11.29 for CR 16076
        {
            mediaPlayer.copyToJukeBox = false
            if (menuMode == MP.OPTION_MENU_MOVE)
            {
                __LOG("*****JBMove******")

                path = AudioListViewModel.JUKEBOX_ROOT;
                AudioListViewModel.operation = LVEnums.OPERATION_MOVE;
            }
            else if (menuMode == MP.OPTION_MENU_DELETE)
            {
                __LOG("*****JBDelete******")
                AudioListViewModel.operation = LVEnums.OPERATION_DELETE;
            }
        }

        mediaPlayer.updateModeAreaHeader();
        setCurrentButtonModel();
	//[KOR][ISV][79666][B](aettie.ji)
        if(mediaPlayer.copyToJukeBox) setBottomButtonDim(false);
        else setBottomButtonDim(true);
	// { changed by eugeny - 12-09-15
//        mediaPlayer.createOptionMenu();
        EngineListener.SetOptionModel(mediaPlayer.state);
	// } changed by eugeny - 12-09-15
        menuMode = 0;
        updateListCountInfo();
        //if(itemViewList.count<=0){emptyText.visible=true;}else{emptyText.visible=false;} //added by aettie.ji 2013.01.24 for ISV 70695 // removed by eunhye 2013.2.26
        if(mediaPlayer.copyToJukeBox) moveFocusToBottom() // added by cychoi 2015.11.03 for ITS 269955
    }

    function setBottomButtonDim(isDimmed)
    {
        __LOG("setBottomButtonDim: isDimmed = " + isDimmed);

      //{ added by yongkyun.lee 20130401 for : ISV 77432
        if(itemViewList.count <= 0)
        {
            if (AudioListViewModel.operation == LVEnums.OPERATION_COPY)
            {
                copyToJukeboxBtnModel.setProperty(0, "is_dimmed", isDimmed);
                copyToJukeboxBtnModel.setProperty(1, "is_dimmed", isDimmed);
                copyToJukeboxBtnModel.setProperty(2, "is_dimmed", isDimmed);
            }
            else if (AudioListViewModel.operation == LVEnums.OPERATION_MOVE)
            {
                moveInJukeboxBtnModel.setProperty(0, "is_dimmed", isDimmed);
                moveInJukeboxBtnModel.setProperty(1, "is_dimmed", isDimmed);
                moveInJukeboxBtnModel.setProperty(2, "is_dimmed", isDimmed);
            }
            else if (AudioListViewModel.operation == LVEnums.OPERATION_DELETE)
            {
                deleteInJukeboxBtnModel.setProperty(0, "is_dimmed", isDimmed);
                deleteInJukeboxBtnModel.setProperty(1, "is_dimmed", isDimmed);
                deleteInJukeboxBtnModel.setProperty(2, "is_dimmed", isDimmed);
            }
            else if (AudioListViewModel.operation == LVEnums.OPERATION_ADD_TO_PLAYLIST)
            {
                addToPlaylistBtnModel.setProperty(0, "is_dimmed", isDimmed);
                addToPlaylistBtnModel.setProperty(1, "is_dimmed", isDimmed);
                addToPlaylistBtnModel.setProperty(2, "is_dimmed", isDimmed);
            }
            return;
        }
        //} added by yongkyun.lee 20130401 
        if (AudioListViewModel.operation == LVEnums.OPERATION_COPY)
        {
            copyToJukeboxBtnModel.setProperty(0, "is_dimmed", isDimmed);
            copyToJukeboxBtnModel.setProperty(1, "is_dimmed", false);//added by yongkyun.lee 20130401 for : ISV 77432
            copyToJukeboxBtnModel.setProperty(2, "is_dimmed", isDimmed);
        }
        else if (AudioListViewModel.operation == LVEnums.OPERATION_MOVE)
        {
            moveInJukeboxBtnModel.setProperty(0, "is_dimmed", isDimmed);
            moveInJukeboxBtnModel.setProperty(1, "is_dimmed", false);//added by yongkyun.lee 20130401 for : ISV 77432
            moveInJukeboxBtnModel.setProperty(2, "is_dimmed", isDimmed);
        }
        else if (AudioListViewModel.operation == LVEnums.OPERATION_DELETE)
        {
            deleteInJukeboxBtnModel.setProperty(0, "is_dimmed", isDimmed);
            deleteInJukeboxBtnModel.setProperty(1, "is_dimmed", false);//added by yongkyun.lee 20130401 for : ISV 77432
            deleteInJukeboxBtnModel.setProperty(2, "is_dimmed", isDimmed);
        }
        else if (AudioListViewModel.operation == LVEnums.OPERATION_ADD_TO_PLAYLIST)
        {
            addToPlaylistBtnModel.setProperty(0, "is_dimmed", isDimmed);
            addToPlaylistBtnModel.setProperty(1, "is_dimmed", false);//added by yongkyun.lee 20130401 for : ISV 77432
            addToPlaylistBtnModel.setProperty(2, "is_dimmed", isDimmed);
        }
        rightButtonArea.handleModelChange() // modified by Dmitry 02.08.13 for ITS0181495
        mediaPlayer.isAllItemsSelected = false
    }

    function setCurrentButtonModel()
    {
        __LOG("setCurrentButtonModel(): Current operation = " + AudioListViewModel.operation);

        switch (AudioListViewModel.operation)
        {
            case LVEnums.OPERATION_COPY:
                rightButtonArea.curModel = isCopyMode ? copyToJukeboxBtnModel //copySelectLocationBtnModel modified by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                                                      : copyToJukeboxBtnModel;
                break;

            case LVEnums.OPERATION_MOVE:
                rightButtonArea.curModel = isCopyMode ? moveSelectLocationBtnModel
                                                      : moveInJukeboxBtnModel;
                break;

            case LVEnums.OPERATION_DELETE:
                rightButtonArea.curModel = deleteInJukeboxBtnModel;
                break;

            case LVEnums.OPERATION_ADD_TO_PLAYLIST:
                rightButtonArea.curModel = addToPlaylistBtnModel;
                break;

            default:
                rightButtonArea.curModel = null;
                break;
        }
    }

    function listChangeSelection_onJogDial(arrow, status, repeat) //changed by junam 2013.11.13 for add repeat
    {
        __LOG("listChangeSelection_onJogDial arrow = " + arrow);

        if (blockKeys) return // added by Dmitry 06.11.13 for ITS94041
        if (mediaPlayer.focus_index == LVEnums.FOCUS_NONE)
            mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT;
// added by Dmitry 21.08.13 for ITS0183271
        if (timerPressedAndHold.lastPressed != -1)
        {
           if (arrow != UIListenerEnum.JOG_UP && arrow != UIListenerEnum.JOG_DOWN)
              return
        }
// modified by Dmitry 15.05.13 update
        if (UIListenerEnum.KEY_STATUS_PRESSED == status)
        {
            switch( arrow )
            {
                case UIListenerEnum.JOG_CENTER:
                {
                    //{added by junam 2013.06.27 for disable click in empty list
                    if (itemViewList.count == 0) 
                        return;
                    //}added by junam
                    jogCenterPressed = true
                    break;
                }
                //{changed by junam 2013.11.13 for add repeat
                case UIListenerEnum.JOG_WHEEL_LEFT:
                { 
                    // { rollbacked by cychoi 2015.10.13 for ITS 268465
                    //if (root_list.panning || root_list.flicking) return
                    if (itemViewList.moving || itemViewList.flicking) return // added by Dmitry 31.10.13
                    // } rollbacked by cychoi 2015.10.13

                    itemViewList.keyNavigationWraps = list_v_scroll.visible;
                    if (EngineListenerMain.middleEast)
                    {
                        itemViewList.incrementIndex(repeat);
                    }
                    else
                    {
                        itemViewList.decrementIndex(repeat);
                    }
                    break;
                }

                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    // { rollbacked by cychoi 2015.10.13 for ITS 268465
                    //if (root_list.panning || root_list.flicking) return
                    if (itemViewList.moving || itemViewList.flicking) return // added by Dmitry 31.10.13
                    // } rollbacked by cychoi 2015.10.13

                    itemViewList.keyNavigationWraps = list_v_scroll.visible;
                    if (EngineListenerMain.middleEast)
                    {
                        itemViewList.decrementIndex(repeat);
                    }
                    else
                    {
                        itemViewList.incrementIndex(repeat)
                    }
                    break;
                } 
		//}changed by junam
              case UIListenerEnum.JOG_LEFT:
              {
                 if (EngineListenerMain.middleEast)
                 {
                    if (isEditMode)
                    {
                        itemViewList.lostFocus ( arrow );
                    }
                 }
                 else
                 {
                     if(AudioController.PlayerMode == MP.DISC)
                     {
                         break;
                     }
                     // modified on 27-09-13 for ITS 0191899
                     //if (isEditMode)
                     //{
                     //    itemViewList.lostFocus ( arrow );
                     //}
                     //else
                     if (!isEditMode)
                     {
                         isListSelected = false;
                         isCategorySelected = true;
                         isTitleSelected = false;
                         if(categoryDimmed)
                         {
                             categoryTabList.currentIndex = 0;
                         }
                         if (categoryTabList.currentIndex == -1)
                         {
                             categoryTabList.currentIndex = currentCategoryIndex;
                         }
                     }
                 }
                 break;
              }

              case UIListenerEnum.JOG_RIGHT:
              {
                 if (EngineListenerMain.middleEast)
                 {
                    if(AudioController.PlayerMode == MP.DISC)
                    {
                        break;
                    }
                    if (isEditMode)
                    {
                        itemViewList.lostFocus ( arrow );
                    }
                    else
                    {
                        isTitleSelected = false;
                        isListSelected = false;
                        isCategorySelected = true;
                         if(categoryDimmed)
                         {
                             categoryTabList.currentIndex = 0;
                         }
                        if (categoryTabList.currentIndex == -1)
                        {
                            categoryTabList.currentIndex = currentCategoryIndex;
                        }
                    }
                 }
                 else
                 {
                     if (isEditMode)
                     {
                         itemViewList.lostFocus ( arrow );
                     }
                 }
                 break;
              }
	      //}modified by aettie Focus moves when pressed 20131015
            }
        }
        else if (UIListenerEnum.KEY_STATUS_LONG_PRESSED == status || UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED == status)
        {
            switch( arrow )
            {
                case UIListenerEnum.JOG_UP:
                case UIListenerEnum.JOG_DOWN:
                {
                    //{added by junam 2013.12.11 for ITS_CHN_214290
                    if(itemViewList.currentIndex < 0)
                        break;
                    //}added by junam

                    //EventsEmulator.lockScrolling(itemViewList, false); // modified by Dmitry 23.05.13
                    timerPressedAndHold.lastPressed = arrow;
                    timerPressedAndHold.start();
                    break;
                }
           }
        }
        else if (UIListenerEnum.KEY_STATUS_RELEASED == status)
        {
           switch (arrow)
           {
              case UIListenerEnum.JOG_UP:
              case UIListenerEnum.JOG_DOWN:
              {
                 if (timerPressedAndHold.lastPressed == -1)
                 {
                    // modified by Dmitry 17.05.13
		    //[KOR][ITS][178101][ minor](aettie.ji)
                    if (UIListenerEnum.JOG_UP == arrow) 
                    {
// modified by Dmitry 07.08.13 for ITS0180216		    
                    //[KOR][ITS][178101][ minor](aettie.ji)  
                        isListSelected = false;
                        isCategorySelected = false;
                        if(bg_item_view_text.visible&&/*!ipodList &&*/!isCopyMode&&!isEditMode)//removed by junam 2013.07.20 for ITS_NA_179108
                        {
                            isTitleSelected = true;
// modified by Dmitry 07.08.13 for ITS0180216
                        }
                        else if(/*ipodList ||*/isCopyMode||isEditMode) {//removed by junam 2013.07.20 for ITS_NA_179108
                            isTitleSelected = false;
                            root_list.lostFocus(UIListenerEnum.JOG_UP);
                        }
                        else  root_list.lostFocus(UIListenerEnum.JOG_UP);
                    }
                    //updateListCountInfo();
                    // modified by Dmitry 17.05.13
                 }
                 else
                 {
                    //EventsEmulator.lockScrolling(itemViewList, true); // modified by Dmitry 23.05.13
                    timerPressedAndHold.stop();
                    if(itemViewList.currentIndex >=0 && itemViewList.currentIndex < itemViewList.count)// && !itemViewList.atYEnd && !itemViewList.atYBeginning) // modified by Dmitry 16.04.13
                        itemViewList.positionViewAtIndex(itemViewList.currentIndex, arrow === UIListenerEnum.JOG_UP ? ListView.Beginning : ListView.End)
                    timerPressedAndHold.iterations = 0;
                    timerPressedAndHold.lastPressed = -1;
                 }
                 break;
              }

              case UIListenerEnum.JOG_CENTER:
              {
	      // modified by ravikanth 03-07-13 for ITS 0177700, Handle release only if pressed is on same control
                  if (itemViewList.count == 0 || !jogCenterPressed) //added by edo 2012.08.01 for CR 11855
                      return;

                  jogCenterPressed = false

                  if (isCopyMode)
                  {
                      path = AudioListViewModel.getUrl(itemViewList.currentIndex);
                  }

                  // modified by ruindmby 2012.08.27 for CR 12133
                  if (AudioListViewModel.isSelectable(itemViewList.currentIndex) || AudioController.PlayerMode == MP.DISC)//Changed by Alexey Edelev 2012.09.19. CR13888
                  {
                     if (AudioController.PlayerMode == MP.DISC &&
                         AudioController.DiscType == MP.AUDIO_CD)
                     {
                         // { commented by cychoi 2013.07.17 for MLT spec out
                         // { added by dongjin 2013.01.30 for ISV 70919
                         //if (AudioController.isPlayFromMLT)
                         //{
                         //    AudioController.ExitFromMLT();
                         //}
                         // } added by dongjin
                         // } commented by cychoi 2013.07.17
                         currentLoaderTab.item.itemElementHandlerCD (itemViewList.currentIndex, isCheckBoxEnabled);
                         currentLoaderTab.item.itemElementHandlerCDback ();
                     }
                     else
                     {
                         // { modified by ravikanth 27-04-13
                         // modified by ravikanth 26-06-13 for ITS 0175972.. uncomment the below code if popup to show on item check
//                         if( rightButtonArea.curModel == deleteInJukeboxBtnModel )//added by yungi 2013.03.11 for Nex Ux FileCount
//                         {
//                             if( (currentLoaderTab.item.itemViewListModel.currentPlayingItem == itemViewList.currentIndex) // this is similar to albumMarked.visible == true
//                                   && root_list.isPlaying )
//                             {
//                                 popup_loader.showPopup(LVEnums.POPUP_TYPE_FILE_CANNOT_DELETE);
//                             }
//                             else
//                             {
//                                 currentLoaderTab.item.itemElementHandler (itemViewList.currentIndex, isCheckBoxEnabled);
//                                 mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")"; //added by yungi 2013.03.06 for New UX FileCount
//                             }
//                         }
//                         else
                         {
                             currentLoaderTab.item.itemElementHandler (itemViewList.currentIndex, isCheckBoxEnabled);
                             if(rightButtonArea.curModel == copyToJukeboxBtnModel  || rightButtonArea.curModel == deleteInJukeboxBtnModel )//added by yungi 2013.03.11 for Nex Ux FileCount
                                 mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")"; //added by yungi 2013.03.06 for New UX FileCount
                         }
                     }
                  }
                  else
                  {
                      if(currentLoaderTab.item.isEtcList && currentLoaderTab.item.historyStack === 0)
                      {
                          currentLoaderTab.item.itemElementHandler (itemViewList.currentIndex, isCheckBoxEnabled);
                      }
                  }

                  if (isEditMode)
                  {
                      setBottomButtonDim(!AudioListViewModel.isAnyoneMarked());
                  }

                  EngineListener.DisplayOSD(true); // added by Sergey 17.05.2013
                  break; // added by Dmitry 19.05.13
              }
	      //moved
           }
        }
// added by Dmitry for ITS0176369
        else if (UIListenerEnum.KEY_STATUS_CANCELED == status)
        {
           switch (arrow)
           {
              case UIListenerEnum.JOG_CENTER:
                 jogCenterPressed = false
                 break;
// added by Dmitry 24.08.13 for ITS0186455
              case UIListenerEnum.JOG_UP:
              case UIListenerEnum.JOG_DOWN:
              {
                 if (timerPressedAndHold.lastPressed != -1)
                 {
                    timerPressedAndHold.stop();
                    if(itemViewList.currentIndex >=0 && itemViewList.currentIndex < itemViewList.count)// && !itemViewList.atYEnd && !itemViewList.atYBeginning) // modified by Dmitry 16.04.13
                        itemViewList.positionViewAtIndex(itemViewList.currentIndex, arrow === UIListenerEnum.JOG_UP ? ListView.Beginning : ListView.End)
                    timerPressedAndHold.iterations = 0;
                    timerPressedAndHold.lastPressed = -1;
                 }
              }
// added by Dmitry 24.08.13 for ITS0186455
              default:
                 break;
           }
        }
    }
    //[KOR][ITS][178101][ minor](aettie.ji)
    function titleChangeSelection_onJogDial(arrow, status)
    {
        __LOG("titleChangeSelection_onJogDial arrow = " + arrow);

        if (blockKeys) return // added by Dmitry 06.11.13 for ITS94041
        if (mediaPlayer.focus_index == LVEnums.FOCUS_NONE)
            mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT;
        if (UIListenerEnum.KEY_STATUS_PRESSED == status)
        {
            switch( arrow )
            {
	    //modified by aettie Focus moves when pressed 20131015
                  case UIListenerEnum.JOG_CENTER:
                  {
  				    bg_item_view_text.pressed = true;//added by edo.lee 2013.10.08 ITS 0194184 
                      break;
                  }
                  case UIListenerEnum.JOG_UP:
                  {
                    isTitleSelected = false;
                    isListSelected = false; // modified by Dmitry 31.07.13 for ITS0180216
                    isCategorySelected = false;

                    root_list.lostFocus(UIListenerEnum.JOG_UP);
                    break;
                  }
                  case UIListenerEnum.JOG_DOWN:
                  {
                      //{added by junam 2013.08.09 for block down focus on empty list
                      if(itemViewList.count == 0)
                          break;
                      //}added by junam
                      isTitleSelected = false;
                      isListSelected = true;
                      isCategorySelected = false;
                     break;
                  }
                  case UIListenerEnum.JOG_LEFT:
                  {
                     if (EngineListenerMain.middleEast) break
  
                     //{added by cychoi 2013.11.18 for ITS 208699 No move focus to CategoryTab
                     if(AudioController.PlayerMode == MP.DISC)
                     {
                         break;
                     }
                     //}added by cychoi 2013.11.18

                     isListSelected = false;
                     isTitleSelected = false;
  
                     isCategorySelected = true;
  
                     break;
                  }
                  case UIListenerEnum.JOG_RIGHT:
                  {
                      if (!EngineListenerMain.middleEast) break;
                      
                      //{added by cychoi 2013.11.18 for ITS 208699 No move focus to CategoryTab
                      if(AudioController.PlayerMode == MP.DISC)
                      {
                          break;
                      }
                      //}added by cychoi 2013.11.18

                      isListSelected = false;
                      isTitleSelected = false;
                      isCategorySelected = true;
  
                      break;
                  }
            }
        }
        else if (UIListenerEnum.KEY_STATUS_RELEASED == status)
        {
           switch (arrow)
           {
//moved
              case UIListenerEnum.JOG_CENTER:
              {
                  // {modified by Michael.Kim 2014.02.25 for ITS 226690
                  if(bg_item_view_text.pressed == true)
                  {
                      isTitleSelected = false;
                      isListSelected = true;
                      bg_item_view_text.pressed = false; //added by edo.lee 2013.10.08 ITS 0194184
                      isCategorySelected = false;
                      currentLoaderTab.item.backHandler();
                  }
                  // }modified by Michael.Kim 2014.02.25 for ITS 226690
                  break;
              }
//moved
            }
        }
    }
    function categoryChangeSelection_onJogDial( arrow, status )
    {
        // __LOG ("categoryChangeSelection_onJogDial arrow = " + arrow);
        if (blockKeys) return // added by Dmitry 06.11.13 for ITS94041
        if (mediaPlayer.focus_index == LVEnums.FOCUS_NONE)
        {
            mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT
            categoryTabList.currentIndex = currentCategoryIndex
        }
        if (UIListenerEnum.KEY_STATUS_PRESSED == status)
        {
            switch( arrow )
            {
                case UIListenerEnum.JOG_CENTER:
                {
                    jogCenterPressed = true;
                    break;
                }

                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    // { changed by junam 2013.06.05 for iPod playlist disable

                    //if (categoryTabList.currentIndex > 0)
                    //{
                    //    categoryTabList.currentIndex--;
                    //}
		    //added by aettie 20130808 for category dimming(ITS 182674)
		    //{modified by aettie CCP wheel direction for ME 20131014
                    if(!categoryDimmed)
                    {
                        if (EngineListenerMain.middleEast)
                        {
                            categoryTabList.incCurrentIndex();
                        }
                        else
                        {
                            categoryTabList.decCurrentIndex();
                        }
                    }
                    //}changed by junam
                    break;
                }
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    //{changed by junam 2013.06.05 for iPod playlist disable
                    //if ( categoryTabList.currentIndex < categoryTabList.count - 1 )
                    //    categoryTabList.currentIndex++
		    //added by aettie 20130808 for category dimming(ITS 182674)
                    if(!categoryDimmed)
                    {
                        if (EngineListenerMain.middleEast)
                        {
                            categoryTabList.decCurrentIndex();
                        }
                        else
                        {
                            categoryTabList.incCurrentIndex();
                        }
                    }
		    //}modified by aettie CCP wheel direction for ME 20131014
                    //}changed by junam
                    break;
                }
                case UIListenerEnum.JOG_UP:
                {
                    // added by Dmitry 31.07.13 for ITS0180216
                    isListSelected = false;
                    isTitleSelected = false;
                    isCategorySelected = false;
                    // added by Dmitry 31.07.13 for ITS0180216
                    root_list.lostFocus(UIListenerEnum.JOG_UP);
                    //updateListCountInfo();
                    // modified by Dmitry 17.05.13
                    break;
                 }
                case UIListenerEnum.JOG_LEFT:
                {
                   if (!EngineListenerMain.middleEast) break
                   if(itemViewList.count > 0)
                   {
                       isListSelected = true;
                       isTitleSelected = false;
                       isCategorySelected = false;
                   }
                   break;
                }
                case UIListenerEnum.JOG_RIGHT:
                {
                    if (EngineListenerMain.middleEast) break;
                    //{changed by junam 2013.12.19 for empty item focus
                    //if(currentLoaderTab == ipodTab)
                    //{
                    root_list.setDefaultFocus();
                    setEmptyMusicListFocus() // added by Michael.Kim 2014.02.25 for ITS 226690
                    //}
                    //else if(itemViewList.count > 0)
                    //{
                    //    isListSelected = true;
                    //    isTitleSelected = false;
                    //    isCategorySelected = false;
                    //}
                    //}changed by junam
                    break;
                }
            }
        }
        else if (UIListenerEnum.KEY_STATUS_RELEASED == status)
        {
            switch( arrow )
            {
                case UIListenerEnum.JOG_CENTER:
                {
                    if (categoryTabList.currentIndex >= 0 && categoryTabList.currentIndex < categoryTabList.count &&
                            (currentCategoryIndex != categoryTabList.currentIndex)||(currentLoaderTab.item.historyStack != 0 )||
                            (currentLoaderTab == ipodTab && currentCategoryIndex == 4 && categoryTabList.currentIndex == 4)) // added by junam 2013.10.23 // modified 2013.11.15
                     {
                         callFromCategory = true; 
                         setCategory (categoryTabList.currentIndex);
                     } 
                     if(itemViewList.count > 0)
                     {
                         isListSelected = true;
                         isTitleSelected = false;
                         isCategorySelected = false;
                     }
                     changeFocusToList = true
                     jogCenterPressed = false
                     break;
                }
//moved
            }
        }
// added by Dmitry for ITS0176369
        else if (UIListenerEnum.KEY_STATUS_CANCELED == status)
        {
           switch (arrow)
           {
              case UIListenerEnum.JOG_CENTER:
                 jogCenterPressed = false
                 break;

              default:
                 break;
           }
        }
    }
// modified by Dmitry 15.05.13 update

    function listSetFocus()
    {
        __LOG("### listSetFocus mediaPlayer.focus_index " + mediaPlayer.focus_index)
        //focus will be set by onSetCurrentPlayingItemPosition and onUpdateTrackInfo
    }

	
    //{removed by junam 2013.07.12 for music app
    //function nextItemSelect(isLoop)
    //{
    //    if( itemViewList.currentIndex  >= 0 && itemViewList.currentIndex < itemViewList.count - 1 ) // modified by eugene.seo 2013.03.07
    //    {
    //        itemViewList.currentIndex++
    //    }
    //    else if(isLoop && list_v_scroll.visible) //[KOR][ISV][64532][C](aettie.ji)
    //    {
    //        itemViewList.currentIndex = 0;
    //    }
    //}
    // } removed by junam


    //{removed by junam 2013.07.12 for music app
    //function prevItemSelect(isLoop)
    //{
    //    if( itemViewList.currentIndex > 0 )
    //    {
    //        itemViewList.currentIndex--
    //    }
    //    else if(isLoop && list_v_scroll.visible) //[KOR][ISV][64532][C](aettie.ji)
    //    {
    //        if( itemViewList.count > 0) // added by eugene.seo 2013.03.07
    //                itemViewList.currentIndex = itemViewList.count - 1;
    //        else
    //                itemViewList.currentIndex = 0; // added by eugene.seo 2013.03.07
    //    }
    //}
    // } removed by junam


    function moveToNext_Prev(lastPressed)
    {
        //{changed by junam 2013.07.12 for music app
        if (lastPressed == UIListenerEnum.JOG_UP)
        {
            //prevItemSelect(false)
            if (!ipodCategoryEdit.visible)
            {
                if(itemViewList.currentIndex > 0)    // added by sangmin.seol 2013.11.06 ITS_0206488 To stop the operation at both ends of the list
                {
                    //changed by junam 2013.11.13 for add repeat
                    itemViewList.keyNavigationWraps = false
                    itemViewList.decrementIndex(1);
                }
            }
            else //  ITS 236905
            {
                if(ipodCategoryEdit.currentIndex > 0)
                {
                    ipodCategoryEdit.keyNavigationWraps = false
                    ipodCategoryEdit.decrementIndexCE(1);
                }
            }
        }
        else if (lastPressed == UIListenerEnum.JOG_DOWN)
        {
            //nextItemSelect(false)
            if (!ipodCategoryEdit.visible)
            {
                if (itemViewList.currentIndex < (itemViewList.count - 1))	// added by sangmin.seol 2013.11.06 ITS_0206488 To stop the operation at both ends of the list
                {
                    //changed by junam 2013.11.13 for add repeat
                    itemViewList.keyNavigationWraps = false;
                    itemViewList.incrementIndex(1)
                }
            }
            else //  ITS 236905
            {
                if (ipodCategoryEdit.currentIndex < (ipodCategoryEdit.count - 1))
                {
                    ipodCategoryEdit.keyNavigationWraps = false;
                    ipodCategoryEdit.incrementIndexCE(1)
                }
            }
        }
	// } changed by junam
    }

    function setSourceLoaderTab ( newSource )
    {
        currentLoaderTab = newSource;

        if (currentCategoryIndex >= currentLoaderTab.item.categoryModel.count)
        {
            /* need to check for max category in the new tab. */
            currentCategoryIndex = 0;
        }

        // { added by cychoi 2015.11.17 for ITS 270213
        if(currentLoaderTab == jukeboxTab)
        {
            //{added by junam 2013.08.30 for ITS_KOR_187328
            if(AudioListViewModel.getCopyFromMainPlayer())
            {
                currentCategoryIndex = 0;
            }
            //}added by junam

            if(currentCategoryIndex == 2 || currentCategoryIndex == 3 || currentCategoryIndex == 4)
            {
                AudioListViewModel.clearHistoryStack();
            }
        }
        // } added by cychoi 2015.11.17
        setCategory(currentCategoryIndex);
    }

    function setCategory(category_index)
    {
        //{changed by junam 2013.09.23
        if(mediaPlayer.openList == false && category_index == currentCategoryIndex)
        {
            if(currentLoaderTab == ipodTab && category_index == 4)
            {
                __LOG("etc category..."+currentCategoryIndex);
                ipodTab.item.currentCategory = "";
            }
            //{added by junam 2013.12.03 for ITS_NA_212232
            else if(currentLoaderTab == jukeboxTab && category_index == 0 && callFromCategory)
            {
                //{added by junam 2014.01.14 for ITS_ME_219688
                if(AudioListViewModel.folderHistoryStack == 0)
                {
                    __LOG("Same folderHistoryStack... return");
                    return;
                }
                //}added by junam
                AudioListViewModel.folderHistoryStack = 0;
                AudioListViewModel.clearHistoryStack();
            }
            //}added by junam
            else if(currentLoaderTab.item.historyStack == 0 || callFromCategory == false)
            {
                __LOG("same category... return");

                if(currentLoaderTab == ipodTab)
                    setDefaultFocus();

                return;
            }
            else
            {
                __LOG("move to top historyStack");
                currentLoaderTab.item.historyStack = 0;
                AudioListViewModel.clearHistoryStack();
            }
        }
        //}changed by junam

        alphabeticList.listTextInner = alphabeticList.getListModel(); //added by junam 2013.08.21 for iPod sorting
        alphabeticList.hiddenListTextInner = alphabeticList.getHiddenListModel(); //added by jaehwan 2013.10.25 for ISV 90617

    	mediaPlayer.openList = false;
    	//added by edo.lee 2013.06.07
        AudioListViewModel.resetPartialFetchData();

        /* if category_index equal to -1, so load from previous category */
        if (category_index != -1)
        {
            currentCategoryIndex = category_index;
            // AudioController.setCurrentCategory(AudioController.PlayerMode, currentCategoryIndex); // removed by kihyugn 2013.2.17
        }

        root_list.isVisibleText = false;
//        currentLoaderTab.item.categoryTabHandler(currentCategoryIndex, isCopyMode); // need to check disk and iPOod appropriated functions
        quickimg.visible = false; //add by youngsim.jo - ITS 198880
        currentLoaderTab.item.categoryTabHandler(currentCategoryIndex, isCopyMode, callFromCategory); //modified by aettie 2013.04.05 for QA 41
        currentTabText = currentLoaderTab.item.categoryModel.get(currentCategoryIndex).cat_id;

        // { added by dongjin 2012.09.13 for CR13257
        if ( currentTabText == "Etc" && (currentLoaderTab.item.isEtcList == true) )
        {
            //{added by junam 2013.06.09 for etc focus
            if(itemViewList.currentIndex < 0)
                itemViewList.currentIndex = 0;
            //}added by junam

            mediaPlayer.modeAreaInfoText = "";
            //{added by junam 2013.06.03 for etc count
            mediaPlayer.modeAreaInfoText_f ="";
            mediaPlayer.modeAreaCategoryIcon = "";
            mediaPlayer.modeAreaCategoryIcon_f = "";
            //}added by junam
        }
        // } added by dongjin

        if (ipodCategoryEdit.visible)
        {
            /* Need to disable edit mode */
           if (AudioController.PlayerMode != MP.JUKEBOX &&
               AudioController.PlayerMode != MP.USB1 &&
               AudioController.PlayerMode != MP.USB2)
           {
               currentLoaderTab.item.editHandler();
           }
        }
        callFromCategory = false; 	//added by aettie 2013.04.05 for QA 41
    }
//{changed by junam 2013.05.08 for quick view performance
    function handleQuickScrollEvent(popupIndex, status)
    {
        // { rollbacked by cychoi 2015.10.13 for ITS 268465
        // added by jaehwan 2013.10.31 to avoid freezing when quick scroll & list scroll at same time.
        //if (root_list.panning || root_list.flicking) return
        if (itemViewList.moving || itemViewList.flicking) return;
        // } rollbacked by cychoi 2015.10.13

        // { modified by jaehwan 2013.10.25 for ISV 90617 listInner -> hiddenListInner
        if(popupIndex > -1 && popupIndex < alphabeticList.hiddenListInner.count)
        {
            // TO-DO : manage duplicated event
            if(status == UIListenerEnum.KEY_STATUS_PRESSED || status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                if (lastScrollLetter != alphabeticList.hiddenListTextInner.get(popupIndex).letter)
                {
                    if(isScrolling)
                    {
                        EngineListenerMain.qmlLog("@@@@@current scrolling..................");
                        return;
                    }
                    isScrolling = true;
                    quickScrollDelayTimer.restart();
                    var popupLetter = AudioListViewModel.getListIndexWithLetter(alphabeticList.hiddenListTextInner.get(popupIndex).letter);
                    EngineListenerMain.qmlLog("popupLetter: "+ popupLetter)
                    if ( popupLetter != '') {
                        itemViewList.quickPopup(popupLetter)

                    }
                    lastScrollLetter = alphabeticList.hiddenListTextInner.get(popupIndex).letter
                }
            }

            if (status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
                lastScrollLetter = "";
            }
        }
        //} modified by jaehwan.
    }

    function updateListCountInfo()
    {
        if(itemViewList.disableCountUpdate)
            return;

        currentTabText = currentLoaderTab.item.categoryModel.get(currentCategoryIndex).cat_id;

        //{changed by junam 2013.07.10 for ITS_179155
        //if (currentTabText == "Etc" && currentLoaderTab.item.isEtcList)
        if ((currentTabText == "Etc" && currentLoaderTab.item.isEtcList) || ipodCategoryEdit.visible)
        {//}changed by junam
            mediaPlayer.modeAreaInfoText = "";
            mediaPlayer.modeAreaInfoText_f ="";//HWS
            mediaPlayer.modeAreaCategoryIcon = "";//HWS
            mediaPlayer.modeAreaCategoryIcon_f = "";//HWS
        }
        else if(itemViewList.currentIndex == -1 && itemViewList.count ) //changed by junam 2013.07.20 for ITS_NA_179108
        {
            __LOG("currentIndex = -1, count ="+itemViewList.count);
            if (currentLoaderTab == ipodTab)
            {
                // modified for 196351
                if (ipodTab.item.currentCategory == "Song")
                    centerCurrentPlayingItem();
                setDefaultFocus();
            }
        }
        else
        {
            //if ( currentLoaderTab == ipodTab && ipodTab.item.currentCategory == "Play_list" && itemViewList.currentIndex == 0 && itemViewList.count > 0 ) // added 2013.11.13
            if ( currentLoaderTab == ipodTab && itemViewList.currentIndex == 0 && itemViewList.count > 0 ) // added 2013.11.13
                setDefaultFocus();

            // modified by sangmin.seol for ITS 0217570 2013.12.30 add systemPopupVisible case
            var isListFocused = ((mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT  || mediaPlayer.focus_index == LVEnums.FOCUS_POPUP || mediaPlayer.focus_index == LVEnums.FOCUS_OPTION_MENU || mediaPlayer.systemPopupVisible) && isListSelected); // modified by Michael.Kim 2013.08.24 for ISV 89370
            mediaPlayer.modeAreaInfoText = (isEditMode && !isCopyMode) ? "" : currentLoaderTab.item.itemViewListModel.getCountInfo(itemViewList.currentIndex, isListFocused); //HWS
            mediaPlayer.modeAreaInfoText_f = (isEditMode && !isCopyMode) ? "" : currentLoaderTab.item.itemViewListModel.getCountInfoFirst(itemViewList.currentIndex, isListFocused); //HWS

            currentListText = currentLoaderTab.item.itemViewListModel.getListStatus(); //HWS
            compareIcon = currentLoaderTab.item.itemViewListModel.getListFolders(); //HWS
            compareFolders = currentLoaderTab.item.itemViewListModel.getCompareFolders(itemViewList.currentIndex, isListFocused); //HWS

            // modified by ravikanth 06-09-13 for ISV 90703
            //if(!isEditMode)
            //    mediaPlayer.setCategoryIcon(currentTabText, currentListText, compareIcon, compareFolders); //HWS
            //else
            //    mediaPlayer.setCategoryIcon("", currentListText, compareIcon, compareFolders);
            if(isEditMode && !isCopyMode || mediaPlayer.modeAreaInfoText =="")//add by youngsim do not display icon
            {
                mediaPlayer.setCategoryIcon("", currentListText, compareIcon, compareFolders);
            }
            else
            {
                mediaPlayer.setCategoryIcon(currentTabText, currentListText, compareIcon, compareFolders); //HWS
            }

            mediaPlayer.sCategoryId = currentTabText;

            //{ modified by yongkyun.lee 2013-08-19 for : NO CR MP3 list 0 - default focus
            if(AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.MP3_CD && (itemViewList.count > 0 && backupCount ==0) )
                setDefaultFocus();
            //} modified by yongkyun.lee 2013-08-19 
	}
        
        //{ modified by yongkyun.lee 2013-08-19 for : NO CR MP3 list 0 - default focus
        if(AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.MP3_CD)
            backupCount  = itemViewList.count;
        //} modified by yongkyun.lee 2013-08-19 
        //removed by junam 2013.07.16 for playlist count blinking
        //if(itemViewList.count<=0){emptyText.visible=true;}else{emptyText.visible=false;}// { modified by eunhye 2013.02.26 for UX Scenario The process of 'Copy to Jukebox' is equal to that of list
    }
    // } added by dongjin

    function centerCurrentPlayingItem()
    {
        __LOG("centerCurrentPlayingItem()");

        if (isCopyMode) return; // added by Dmitry 17.08.13 for ITS0180675 ITS0180672 // modified by ravikanth 08-09-13 for ISV 90645
        //{Added by Alexey Edelev 2012.10.15
        if (timerPressedAndHold.lastPressed >= 0)
            return;
        //}Added by Alexey Edelev 2012.10.15
        // { added by dongjin 2012.11.16 for CR14033
        if (!AudioListViewModel.isFocusChange)
        {
           AudioListViewModel.isFocusChange = true;
           //return; // removed by eugene.seo 2013.01.19 for audio list error
        }
        // } added by dongjin

        
        //{ added by yongkyun.lee 20130613 for :  ITS 83292
        if (AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.MP3_CD)
        {
            //{ modified by yongkyun.lee 2013-09-30 for :  NO CR - MP3CD List crash
            var topIndex;
            topIndex = itemViewList.indexAt(600, itemViewList.contentY + 5);
    
            if(currentLoaderTab.item.itemViewListModel.currentPlayingItem != -1 && topIndex != -1 ) // // { modified by wonseok.heo for NOCR focus at list 2013.12.10
            {
                itemViewList.currentIndex = currentLoaderTab.item.itemViewListModel.currentPlayingItem; // // { modified by wonseok.heo for NOCR focus at list 2013.12.10
                //itemViewList.positionViewAtIndex(itemViewList.currentIndex, ListView.Center);
                itemViewList.positionViewAtIndex(itemViewList.currentIndex -2, ListView.Beginning); // modified by oseong.kwon 2014.06.30 for ITS 241654, 241659
            }
            else
            {
                itemViewList.currentIndex = 0
                itemViewList.positionViewAtIndex(itemViewList.currentIndex, ListView.Beginning);
            }
            //} modified by yongkyun.lee 2013-09-30 
        }
        // {added by Michael.Kim 2013.06.19 for Multimedia Issue #66
        else if (AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.AUDIO_CD)
        {
            itemViewList.currentIndex = currentLoaderTab.item.itemViewListModel.currentPlayingItem;
            //itemViewList.positionViewAtIndex(currentLoaderTab.item.itemViewListModel.currentPlayingItem, ListView.Center);
            itemViewList.positionViewAtIndex(currentLoaderTab.item.itemViewListModel.currentPlayingItem -2, ListView.Beginning);    // modified by oseong.kwon 2014.06.30 for ITS 241654, 241659
        }
        // {added by Michael.Kim 2013.06.19 for Multimedia Issue #66
        else
        {
        //} added by yongkyun.lee 20130613
            //{added by junam 2013.07.03 for ITS177762
            if(currentLoaderTab == ipodTab && ipodTab.item.itemViewListModel == ipodTab.item.categoryEtc)
            {
                __LOG("Ipod etc tab do not have play icon");
                itemViewList.currentIndex = ipodTab.item.currentEtcIndex;
            }//}added by junam
            else if (currentLoaderTab.item.itemViewListModel.currentPlayingItem == -1)
            {
                if(itemViewList.count)  //added by junam 2013.10.10 for ITS_KOR_194644
                {
                    itemViewList.currentIndex = 0
                    itemViewList.positionViewAtIndex(itemViewList.currentIndex, ListView.Beginning);
                }
            }
            else
            {
                //{removed by junam 2013.10.16 for ITS_KOR_196053
                //    var topIndex;
                //    topIndex = itemViewList.indexAt(600, itemViewList.contentY + 5);
                //    if (topIndex == -1)
                //        topIndex = itemViewList.indexAt(600, itemViewList.contentY + 5 + 46 /* 46 = section height + 1 */);

                //    var bottomIndex;
                //    bottomIndex = itemViewList.indexAt(600, itemViewList.contentY + itemViewList.height - 5);
                //    if (bottomIndex == -1)
                //        bottomIndex = itemViewList.indexAt(600, itemViewList.contentY + itemViewList.height - (5 + 46 /* 46 = section height + 1 */));
                //}removed by junam

                itemViewList.currentIndex = currentLoaderTab.item.itemViewListModel.currentPlayingItem;

                //{removed by junam 2013.10.16 for ITS_KOR_196053
                //    if (currentLoaderTab.item.itemViewListModel.currentPlayingItem + 1 == topIndex)
                //        itemViewList.decrementCurrentIndex();
                //    //modified by aettie.ji 2013.02.08 for ISV 62706
                //    //else if (currentLoaderTab.item.itemViewListModel.currentPlayingItem == bottomIndex + 1)
                //    else if ((currentLoaderTab.item.itemViewListModel.currentPlayingItem == bottomIndex + 1)&&
                //        (currentLoaderTab.item.itemViewListModel.currentPlayingItem!= 0))
                //        itemViewList.incrementCurrentIndex();
                //}removed by junam
                if((currentLoaderTab == jukeboxTab || currentLoaderTab == ipodTab) && itemViewList.currentIndex == itemViewList.count - 1) //added by sangmin.seol 2015.03.19 for ITS 260190 To Fix Frame work View Port Error
                {
                    itemViewList.positionViewAtBeginning() // ITS 243371,243372
                }
                itemViewList.positionViewAtIndex(currentLoaderTab.item.itemViewListModel.currentPlayingItem - 2, ListView.Beginning); // added by Dmitry 23.10.13
            }
        }// added by yongkyun.lee 20130613 for : ITS 83292
        //root_list.setDefaultFocus() //removed by Michael.Kim for ITS 191900
    }
    // } modified by eugeny.novikov

    // { added by lssanh 2013.02.26 ISV73837
    function scrollAcceleratorStop()
    {
        __LOG("scrollAcceleratorStop()");
        
        if (timerPressedAndHold.lastPressed >= 0)
        {
            //EventsEmulator.lockScrolling(itemViewList, true); // modified by Dmitry 23.05.13
            timerPressedAndHold.stop();
            if(itemViewList.currentIndex >=0 && !itemViewList.atYEnd && !itemViewList.atYBeginning)
                itemViewList.positionViewAtIndex(itemViewList.currentIndex, timerPressedAndHold.lastPressed === UIListenerEnum.JOG_UP ? ListView.Beginning : ListView.End)
            timerPressedAndHold.iterations = 0;
            timerPressedAndHold.lastPressed = -1;    
        }
    }
    // } added by lssanh 2013.02.26 ISV73837

    // modified by ravikanth 29-06-13 for ITS 0176909
    function startCopyAll()
    {
        __LOG("***** Copy All Called ******");
        requestForCopyAll = false;
        copyAllItemsListCreated = false
	// modified by ravikanth 25-08-13 for ITS 0184119 
        //AudioListViewModel.handleSelectAllItems();
        //mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")"; // added by lssanh 2013.03.23 NoCR copyall cancel
        //setBottomButtonDim(false);
        AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_COPY_ALL, 0);
        //popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY_ALL);
        mediaPlayer.setDefaultFocus();
    }

    function startCopy()
    {
        isCopyMode = true;
        prevCategory = currentCategoryIndex;

        if (itemViewList.count <=0)emptyText.visible=true;
        else emptyText.visible=false;
        //added by aettie.ji 2013.01.24 for ISV 70695

        AudioListViewModel.setCopyAll(false); // add by wspark 2012.07.25 for CR12226.
        // { modified by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
        AudioListViewModel.displayMode = AudioController.PlayerMode; // added by wspark 2012.08.04 for CR11532
        //mediaPlayer.setDefaultFocus(); // added by minho 20120915 for CCP/RRC jogdial is not working in Jukebox list screen of jukebox while copying music file from USB

        //popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY);
        // popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY_CANCEL_INFO);
        AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_COPY_CANCEL_INFO, 0);
        //mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_COPY_LOCATION");
        // } modifid by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
        mediaPlayer.setDefaultFocus();
    }

    Connections
    {
        target: currentLoaderTab.item;

        onEditMode:
        {
            __LOG("onEditMode signal: command = " + commandID);

            if (commandID == "iPODEdit")
            {
                ipodCategoryEdit.visible = !ipodCategoryEdit.visible;
                //{added by junam 2013.07.04 for ITS172937
                if(ipodCategoryEdit.visible)
                    ipodTab.item.loadCategoryEditModel(ipodCategoryEdit.model)
                else
                    ipodTab.item.saveCategoryEditModel(ipodCategoryEdit.model)
                //}added by junam
                quickScroll.visible = false;
                mediaPlayer.modeAreaInfoText = "";

                //{changed by junam 2013.07.10 for ITS_179155
                //{added by HWS 2013.03.24 for New UX
                //mediaPlayer.modeAreaInfoText_f ="";//HWS
                //mediaPlayer.modeAreaCategoryIcon = "";//HWS
                //mediaPlayer.modeAreaCategoryIcon_f = "";//HWS
                //}added by HWS 2013.03.24 for New UX
                updateListCountInfo();
                //}changed by junam

                //{removed by junam 2013.07.04 for ITS172937
                //for (var i = 0; i < ipodCategoryEdit.count - 1; i++)
                //{
                //    if (i < 4)
                //    {
                //        ipodEditModel.setProperty(i,"cat_type","Category")
                //    }
                //    else
                //    {
                //        ipodEditModel.setProperty(i,"cat_type","More")
                //    }
                //}
                //}remvoed by junam
                //{added by junam 2013.05.30 for edit category focus.
                if(ipodCategoryEdit.visible)
                {
                    AudioController.saveCategoryTab(currentLoaderTab.item.currentCategory); // added ITS 211811
                    ipodCategoryEdit.currentIndex = 0; // modified ITS 211811

                    //{added by junam 2013.06.17 for ISV_KR_85465
                    if(ipodCategoryEdit.isIpodCategoryEdit)
                    {
                        //ipodCategoryEdit.categoryCueState = "noneActive"; //removed by junam dead code
                        ipodCategoryEdit.isIpodCategoryEdit = false;
                    }
                    //}added by junam
                }
                else
                {
                    //{removed ITS 211811
                    //if( ipodCategoryEdit.currentIndex > 4 )
                    //    categoryTabList.currentIndex = 4; //ETC
                    //else
                    //    categoryTabList.currentIndex = ipodCategoryEdit.currentIndex;
                    //}removed ITS 211811
                    //{added ITS 211811
                    categoryTabList.currentIndex = ipodTab.item.setCurrentCategory(AudioController.getCategoryTab("ipod"));
                    if( categoryTabList.currentIndex > 4 )
                        categoryTabList.currentIndex = 4; //ETC
                    //}added ITS 211811
                    //{added by junam 2013.08.12 disabled item category edit
                    if( categoryTabList.currentIndex < categoryTabList.model.count && categoryTabList.model.get(categoryTabList.currentIndex).isSelectable == false)
                    {
                        var idx;
                        for(idx = categoryTabList.currentIndex + 1; idx < 4 ; idx++)
                        {
                            if(categoryTabList.model.get(idx).isSelectable)
                            {
                                categoryTabList.currentIndex = idx;
                                break;
                            }
                        }
                        if(idx >= 4)
                            categoryTabList.currentIndex = 4;
                    }
                    //}added by junam
                    currentCategoryIndex = -1;
                    setCategory (categoryTabList.currentIndex);
                    quickScroll.visible = currentLoaderTab.item.itemViewListModel.isQuickViewVisible(); //added by junam 2013.06.10 for ITS_179109
                }
                //}added by junam

                itemViewList.visible = !ipodCategoryEdit.visible;
                categoryTabList.visible = !ipodCategoryEdit.visible;
                //quickScroll.visible = !ipodCategoryEdit.visible; //removed by junam 2013.06.10 for ITS_179109
                mediaPlayer.modeAreaText = ipodCategoryEdit.visible ? QT_TR_NOOP("STR_MEDIA_EDIT_CATEGORY") : QT_TR_NOOP("STR_MEDIA_LIST");//added by junam 2013.5.28 for ISV_KR84024
            }
            else if (commandID == "switchCheckBoxes")
            {
                menuMode = mode;
                // { modified by eugeny.novikov 2012.10.11 for CR 14229
                isEditMode ? cancelEditMode() : enableEditMode();
                // } modified by eugeny.novikov
            }
        }
        //{removed by junam 2013.10.30
        //onFindHiddenFocus:
        //{
        //    if(itemViewList.count == 0 && isListSelected)
        //    {
        //        isListSelected = false;
        //        isTitleSelected = true;
        //        isCategorySelected = false;
        //    }
        //    if(bg_item_view_text.visible == false && isTitleSelected)
        //    {
        //        isListSelected = false;
        //        isTitleSelected = false;
        //        isCategorySelected = true;
        //    }
        //}
        //}removed by junam
    }
    // added by edo.lee 2013.01.24
    Connections
    {
        target: AudioController

        // { removed by sangmin.seol 2013.12.13 For ITS 0215045 keep playicon animate state in ff,rew mode
        /*onPlaybackStarted:
        {
            __LOG("list onPlaybackStarted event");
            root_list.isPlaying = true;
        }

        onPlaybackPaused:
        {
            __LOG("list onPlaybackStarted event");
            root_list.isPlaying = false;
        }*/
        // } removed by sangmin.seol 2013.12.13 For ITS 0215045 keep playicon animate state in ff,rew mode

        // Added by sangmin.seol 2013.12.13 For ITS 0215045 keep playicon animate state in ff,rew mode
        onStateChanged:
        {
            // { added by wonseok.heo for ITS 220389 2014.01.16
            if(AudioController.PlayerMode == MP.DISC ){
                root_list.isPlaying = AudioController.IsDiscNormalPlaying();
            }else{
                root_list.isPlaying = AudioController.IsPlaying();
            } // } added by wonseok.heo for ITS 220389 2014.01.16
        }
    }
	// added by edo.lee
    Connections
    {
        target: (isFrontView == mediaPlayer.isCurrentFrontView) ? currentLoaderTab.item.itemViewListModel : null // changes for ITS 0193892

        onCloseList:
        {
            __LOG("onCloseList signal");
            //{changed by junam 2013.12.19 for LIST_ENTRY_POINT
            //mediaPlayer.showPlayerView(true);
            AudioController.isBasicView = true;
            EngineListener.showListView(false);
            //}changed by junam

            //{added by junam 2013.11.14 for ITS_EU_208749
            if(currentLoaderTab == jukeboxTab || currentLoaderTab == ipodTab)
            {
                AudioController.saveCategoryTab(currentLoaderTab.item.currentCategory);
            }
            //}added by junam
        }
        onDisableListBtn:
        {
            // __LOG ("onDisableListBtn event");
            mediaPlayer.disableList = true;
        }
        onEnableListBtn:
        {
            // __LOG ("onEnableListBtn event");
            mediaPlayer.disableList = false;
        }

        // { added by eugeny.novikov 2012.10.18 for CR 14542
        onSetCurrentPlayingItemPosition:
        {
            // {modified by Michael.Kim 2014.02.25 for ITS 226690
            if(!isEditMode && !isSeekTrack) {   // modified by sangmin.seol ITS 0237463 remove focus moving while prev, next in list    // modified by ravikanth for ITS 0180675
                centerCurrentPlayingItem();
                setEmptyMusicListFocus();
            }
            // }modified by Michael.Kim 2014.02.25 for ITS 226690
        }

        //{ modified by yongkyun.lee 2013-08-19 for : NO CR MP3 list 0 - default focus
        onListDefaultFocus:
        {
            root_list.setDefaultFocus();
        }
        //} modified by yongkyun.lee 2013-08-19 
        
        onSignalUpdateCountInfo:
        {
            updateListCountInfo();
        }
        // } added by eugeny.novikov

        //{ modified by yongkyun.lee 2013-07-12 for : NEW UX: Folder Header : MP3 cd
        onUpdateTextItemView:
        {
            // modified on 27-09-13 for ITS 0185355
            //added by junam 2013.07.20 for ITS_NA_179108
            //if(currentLoaderTab == ipodTab)
            //{
            if(historyStack == 0 && currentCategoryIndex != 4)  //changed by junam 2013.09.06 for ITS_KOR_188332
            {
                root_list.textItemViewList = "";
                root_list.isVisibleText = false;
                return;
            }
            //}
            //}added by junam
            //{ added by junam 2013.12.31 for unknown
            if(title == " ")
            {
                root_list.textItemViewList = qsTranslate("main", "STR_MEDIA_UNKNOWN")
                root_list.isVisibleText = true
            }
            else //}added by junam
            {
                root_list.textItemViewList = title;
                root_list.isVisibleText = (title != "")
            }
        }
        //} modified by yongkyun.lee 2013-07-12 

        //{added by junam 2013.03.14 for list item selection crash
        onClearSelection:
        {
            itemViewList.currentIndex = -1
        }
        //}added by junam

        //{moved by junam 2013.06.10 for ITS_179109
        onSignalQuickScrollInfo:
        {
            //Suryanto Tan: ITS 258678, don't show quickscroll if isCategoryEditMode is true.
            if (!isCategoryEditMode)
            {
                quickScroll.visible = quickInfo
            }
        }
        //}moved by junam
    }

    Connections
    {
        target: (isFrontView == mediaPlayer.isCurrentFrontView) ? AudioListViewModel : null // changes for ITS 0193892
	//added by aettie 20130808 for category dimming(ITS 182674)
        onCategoryTabUpdated:
        {
            EngineListenerMain.qmlLog("categorydim : onCategoryTabUpdate updated = " + updated);
            root_list.categoryDimmed = !updated;

            //{added by junam 2013.11.20 for dim update
            if((updated == false) && !isEditMode) // modified to avoid list update in edit state on copy complete 
                setCategory(0);
            //}added by junam
        }

        onFinishEditMode:
        {
            __LOG("onFinishEditMode signal from AudioListViewModel");
            finishEditMode();
        }

        onCancelEditMode:
        {
            __LOG("onCancelEditMode signal from AudioListViewModel");
            cancelEditMode();
        }

        onEditPopupClosed:
        {
            enableEditMode();
        }

        onCopyingPopupClosed:
        {
            isCopyMode = false
            mediaPlayer.modeAreaText = currentLoaderTab.item.currentModeAreaText;
            currentLoaderTab.item.editHandler();
        }

        onCopyAllConfirmed:
        {
            __LOG("onCopyAllConfirmed signal received");
	    // modified by ravikanth 04-07-13 for copy cancel confirm if copy all confirm popup is already launched
            if (EngineListener.isCopyInProgress() && !isCopyMode)
            {
                currentFileOperationState = "CopyAll"
                mediaPlayer.cancelInEditState = true
                popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM);
            }
            else
            {
                // modified by ravikanth for 19.06.13 SMOKE_TC 7 & SANITY_CM_AK347
                requestForCopyAll = true;
                // modified by ravikanth 25-08-13 for ITS 0184119
                if(!copyAllItemsListCreated)
                {
                    AudioListViewModel.handleSelectAllItems();
                    mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")"; // added by lssanh 2013.03.23 NoCR copyall cancel
                    setBottomButtonDim(false);
                }
                else //(copyAllItemsListCreated)
                {
                    requestForCopyAll = false;
                    isCopyMode = true;
                    if (AudioListViewModel.operation == LVEnums.OPERATION_COPY)
                    {
                        //{modified yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                        //popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY);
                        AudioListViewModel.startFileOperation(path);
                        mediaPlayer.setDefaultFocus(); // added by minho 20120915 for CCP/RRC jogdial is not working in Jukebox list screen of jukebox while copying music file from USB
                        //}modified yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                    }
                    else
                    {
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_MOVE);
                        mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_LOCATION_TO_BE_MOVED");
                    }
                    isCheckBoxEnabled = false;
                    prevCategory = currentCategoryIndex
                    //AudioListViewModel.displayMode = MP.JUKEBOX; //deleted by yungi 2013.2.18 for UX Scenario 5. File Copy step reduction
                    //setCategory(5);
                    //setCategory(0); //modified by aettie 2013.01.16 for ISV 68135/68124 //deleted by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                    setCurrentButtonModel();

                }
            }
        }
	
	// modified by ravikanth 25-08-13 for ITS 0184119 
        onDeleteAllConfirmed:
        {
            mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")"; // added by lssanh 2013.03.23 NoCR copyall cancel
            setBottomButtonDim(false);
        }

        onManageJB:
        {
            isCopyMode = true;
            isCheckBoxEnabled = isEditMode;

            if (isCheckBoxEnabled)
            {
                AudioListViewModel.enableAllCheckBoxes(false);
                setBottomButtonDim(!AudioListViewModel.isAnyoneMarked());
            }

            // modified by ruindmby 2012.09.26 for CR#11543
            prevCategory = currentCategoryIndex
            AudioListViewModel.operation = LVEnums.OPERATION_DELETE;
            AudioListViewModel.displayMode = MP.JUKEBOX;
           // setCategory(5);
            setCategory(0); //modified by aettie 2013.01.16 for ISV 68135/68124
            // modified by ruindmby 2012.09.26 for CR#11543
            rightButtonArea.curModel = isEditMode ? deleteInJukeboxBtnModel : null
        }

        // { modified by eugeny.novikov 2012.10.18 for CR 14542
        onSetSelectedAlphaOnTop:
        {
            itemViewList.positionViewAtIndex( alphaIndex, ListView.Beginning)

            //{added by junam 2013.08.21 for ITS_NA_184412
            itemViewList.currentIndex = alphaIndex;
            if (!isListSelected)
                mediaPlayer.setDefaultFocus();
            //}added by junam
        }

        //{moved by junam 2013.06.10 for ITS_179109
        //onSignalQuickScrollInfo:
        //{
        //    quickScroll.visible = quickInfo
        //}
        //}moved by junam

        //{removed by junam 2013.07.20 for ITS_NA_179108
        //onUpdateTextItemView:
        //{
        //    //{changed by junam 2013.07.03 for ITS177762
        //    if(currentLoaderTab == ipodTab && ipodTab.item.itemViewListModel == ipodTab.item.categoryEtc)
        //    {
        //        __LOG("onUpdateTextItemView: no need update at etcList ");
        //        root_list.textItemViewList = "";
        //        root_list.isVisibleText = false;
        //        return;
        //    }
        //    //}changed by junam
        //    __LOG("onUpdateTextItemView: title = " + title);

        //    root_list.textItemViewList = title;
        //    root_list.isVisibleText = (title != "");
        //}
        //}removed by junam

        // { removed by kihyung 2013.05.24
        /*
        // { added by lssanh 2013.02.08 for loading 
        onSignalListLoadingIcon: 
        {
            loadingAnimate.visible = visible;
            loadingText.visible = visible;
        }
        // } added by lssanh 2013.02.08 for loading 
        */
        // } removed by kihyung 2013.05.24
        
        // { added by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
        onCopyCancelInfo:
        {
            if (AudioListViewModel.operation == LVEnums.OPERATION_COPY)
            {
                AudioListViewModel.startFileOperation(path);
                mediaPlayer.setDefaultFocus(); // added by minho 20120915 for CCP/RRC jogdial is not working in Jukebox list screen of jukebox while copying music file from USB
            }
            isCopyMode = true;
            isCheckBoxEnabled = true;
            prevCategory = currentCategoryIndex
            setCurrentButtonModel();
       }
       // } added by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
       // { modified by ravikanth 28-04-13 to remove copy cancel confirm popup
        onContentRequestAllComplete:
        {
            EngineListenerMain.qmlLog("ContentRequestAllComplete "+requestForCopyAll)
            copyAllItemsListCreated = true // modified by ravikanth for 19.06.13 SMOKE_TC 7 & SANITY_CM_AK347
            if(requestForCopyAll && currentFileOperationState == "CopyAll")
            {
                requestForCopyAll = false;
                AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_COPY_ALL, 0);
            }
            else if(currentFileOperationState == "DeleteAll")
            {
                AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_DELETE, 2);
            }
        }
	// } modified by ravikanth 28-04-13

        onMoveTopHistoryStack:
        {
            currentLoaderTab.item.historyStack = 0;
        }



        onResetSelectAllItems:
        {
            mediaPlayer.resetSelectAllItems();
        }

        // { added by eugeny.novikov 2012.11.20 for CR 15408
        onActivateTab:
        {
            __LOG("activateTab from List View");
            mediaPlayer.activateTab(tabId, isVisible, isSelected);
        }
        // } added by eugeny.novikov 2012.11.20

        //{removed by junam 2013.10.29 for playlist population
        //onFlickingEnabled:
        //{
        //    if(itemViewList.enabled != bEnabled)
        //        itemViewList.enabled = bEnabled;
        //}
        //}removed by junam
        onListItemsUpdated:
        {
            if(root_list.isVisibleText && (itemViewList.count == 0))
                {
                    jboxListEmptyStr.visible = true
                }
        }
        //{added by junam 2013.10.30
        onEmptyItemViewList:
        {
            if(currentLoaderTab == ipodTab && itemViewList.count == 0 && isListSelected)
            {
                isListSelected = false;
                isTitleSelected = ( historyStack != 0 || currentCategoryIndex == 4 )
                isCategorySelected = !isTitleSelected;
            }
        }
        //}added by junam
    }
    // } modified by eugeny.novikov

//[KOR][ITS][178101][ minor](aettie.ji)
    onIsCopyModeChanged: {
        AudioListViewModel.isCopyMode = isCopyMode; // added by junam 2012.10.16 for CR14582
        if(isCopyMode)
        {
            isTitleSelected = false;
            isListSelected = true;
            isCategorySelected = false; //[KOR][ITS][179014][comment](aettie.ji)

            // modified for ISV 90703
            mediaPlayer.modeAreaFileCount = "";
            mediaPlayer.updateModeAreaHeader();
            updateListCountInfo();
        }
    }
    onIsEditModeChanged: {
        if(isEditMode)
        {
            isTitleSelected = false;
            isListSelected = true;
            isCategorySelected = false; //[KOR][ITS][179014][comment](aettie.ji)
        }
        else
        {
            AudioListViewModel.RequestListDataOnContentChanged(); // modified to avoid list update in edit state on copy complete 
        }
    }

    onIsListSelectedChanged:
    {
        if(currentLoaderTab == ipodTab && ipodTab.item.currentCategory == "Play_list" ) // modified for ITS 221840
            __LOG("onIsListSelectedChanged skip");
        else
            updateListCountInfo();

        //{added by junam 2013.10.31 for ITS_KOR_198892
        if(isListSelected == false)
            jogCenterPressed = false;
        //}added by junam
    }
    //{added by junam 2013.10.31 for ITS_KOR_198892
    onIsTitleSelectedChanged:
    {
        if(isListSelected == false)
            bg_item_view_text.pressed = false
    }
    //}added by junam

//{added by aettie.ji 2013.01.24 for ISV 70695 
    Text
    {
        id: emptyText
        visible: false
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.horizontalCenterOffset: -rightButtonArea.width/2

        color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
        //font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT   //modified by aettie.ji 2012.11.28 for uxlaunch update
        //font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT
        font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_40_FONT //modified by Michael.Kim 2013.12.19 for ITS 216393
        font.family:MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDR //modified by Michael.Kim 2013.12.19 for ITS 216393
        text:  qsTranslate( MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,"STR_MEDIA_EMPTY")
    }//}added by aettie.ji 2013.01.24 for ISV 70695 

    // { removed by kihyung 2013.05.24
    /*
    // { added by lssanh 2013.02.08 for loading 
    Text
    {
        id: loadingText
        visible: false
        x: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH/2
        y: 160
        
        text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT, "STR_MEDIA_LOADING_DATA") + LocTrigger.empty
        font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
        color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
    }

    AnimatedImage
    {
        id: loadingAnimate
        visible: false
        x: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH/2 + 15
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: loadingText.bottom
        anchors.topMargin: 15
        
        source: RES.const_URL_IMG_LOADING_ICON
        smooth: true
    }
    // } added by lssanh 2013.02.08 for loading 
    */
    // } removed by kihyung 2013.05.24    

    RightCmdButtonAreaWidget
    {
        id: rightButtonArea

        middleEast: EngineListenerMain.middleEast
        z: 200;
        visible: (!ipodCategoryEdit.visible && isEditMode && !isCopyMode) // modified by ravikanth 23-08-13 for ISV 89592
        anchors.right:root_list.right

        focus_id: LVEnums.FOCUS_BOTTOM_MENU
        focus_visible: ( mediaPlayer.focus_index == focus_id )
        property ListModel curModel : addToPlaylistBtnModel ? addToPlaylistBtnModel : null

        btnModel: curModel
        onBeep: EngineListenerMain.ManualBeep(); //added by Michael.Kim 2014.06.23 for ITS 240741

        onLostFocus:
        {
           if (!EngineListenerMain.middleEast)
           {
              if (arrow == UIListenerEnum.JOG_LEFT)
                  mediaPlayer.setDefaultFocus();
           }
           else
           {
              if (arrow == UIListenerEnum.JOG_RIGHT)
                  mediaPlayer.setDefaultFocus();
           }
            // modified by Dmitry 17.05.13
            if (arrow == UIListenerEnum.JOG_UP)
            {
	        // added by Dmitry 31.07.13 for ITS0180216
               isListSelected = false;
               isTitleSelected = false;
               isCategorySelected = false;
	       // added by Dmitry 31.07.13 for ITS0180216
                root_list.lostFocus(UIListenerEnum.JOG_UP);
            }
            // modified by Dmitry 17.05.13
        }

        onCmdBtnArea_pressed:
        {
            // __LOG ("CmdButtonAreaWidget: onCmdBtnArea_pressed btnID = " + btnId);
            // { added by wspark 2012.12.18 for ISV65071
            // { removed by eugene.seo 2013.01.18 for jukebox copy error
            /*
            switch (btnId)
            {
                case ("CopyToHere"):
                {
                    popup_loader.showPopup(LVEnums.POPUP_TYPE_LOADING_DATA);
                    break;
                }
            }
            */
            // } removed by eugene.seo 2013.01.18 for jukebox copy error
            // } added by wspark
        }

        onCmdBtnArea_clicked: //modified by nhj 2013.10.09
        {
            // __LOG ("CmdButtonAreaWidget: onCmdBtnArea_released btnID = " + btnId);
            currentFileOperationState = btnId
            switch (btnId)
            {
                case ("CopyToHere"):
                {
                    AudioListViewModel.displayMode = AudioController.PlayerMode; // added by wspark 2012.08.04 for CR11532
                    AudioListViewModel.startFileOperation(path);
                    mediaPlayer.setDefaultFocus(); // added by minho 20120915 for CCP/RRC jogdial is not working in Jukebox list screen of jukebox while copying music file from USB
                    break;
                }

                case ("MoveToHere"):
                {
                    AudioListViewModel.startFileOperation(path);
                    mediaPlayer.setDefaultFocus(); // added by minho 20120915 for CCP/RRC jogdial is not working in Jukebox list screen of jukebox while copying music file from USB
                    break;
                }

                case ("CreateFolder"):
                {
                    AudioListViewModel.onNewFolderBtnClicked();
                    mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_INPUT_NEW_NAME");
                    break;
                }

                case ("Copy"):
                case ("Move"):
                {
                    __LOG("***** CopyMove button clicked ******");
                    //isCheckBoxEnabled = false;// added by yongkyun.lee 20130322 for : NOCR , POPUP->back key
		    // { modified by ravikanth 16-04-13 
                    if (EngineListener.isCopyInProgress() && btnId == "Copy")
                    {
		    // modified by ravikanth 29-06-13 for ITS 0176909
                         currentFileOperationState = "Copy"
                        mediaPlayer.cancelInEditState = true
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM);
                    }
                    else
                    {
                        isCopyMode = true;
                        prevCategory = currentCategoryIndex;
                        // { modified yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                        //AudioListViewModel.displayMode = MP.JUKEBOX;
                        //setCategory(5); // set to Folder
                        //setCategory(0); // modified by aettie 2013.01.16 for ISV 68135/68124
                        // } modified yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                        // setCurrentButtonModel(); // removed by Sergey 10.04.2013 for ISV#77223

                        if (itemViewList.count <=0)emptyText.visible=true;
                        else emptyText.visible=false;
                        //added by aettie.ji 2013.01.24 for ISV 70695


                        if (btnId == "Copy")
                        {
                            AudioListViewModel.setCopyAll(false); // add by wspark 2012.07.25 for CR12226.
                            // { modified by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                            AudioListViewModel.displayMode = AudioController.PlayerMode; // added by wspark 2012.08.04 for CR11532
                            mediaPlayer.setDefaultFocus(); // added by minho 20120915 for CCP/RRC jogdial is not working in Jukebox list screen of jukebox while copying music file from USB

                            //popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY);
                            // popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY_CANCEL_INFO);
                            AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_COPY_CANCEL_INFO, 0);
                            //mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_COPY_LOCATION");
                            // } modifid by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                        }
                        else
                        {
                            popup_loader.showPopup(LVEnums.POPUP_TYPE_MOVE);
                            mediaPlayer.modeAreaText = QT_TR_NOOP("STR_MEDIA_MNG_LOCATION_TO_BE_MOVED");
                        }
			// } modified by ravikanth 16-04-13 
                    }
                    mediaPlayer.setDefaultFocus();
                    break;
                }

                case ("Delete"):
                {
                    __LOG("***** Delete button clicked ******");
		    // modified by ravikanth 26-06-13 for ITS 0175972
                    if(currentLoaderTab.item.itemViewListModel.isCheckBoxMarked(currentLoaderTab.item.itemViewListModel.currentPlayingItem) && root_list.isPlaying)
                    {
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_FILE_CANNOT_DELETE);
                    }
                    else
                    {
		    	// modified by ravikanth 04-07-13 for ISV 86272
                        //popup_loader.showPopup(LVEnums.POPUP_TYPE_DELETE, false);
			// modified by ravikanth 21-07-13 for copy cancel confirm on delete
                        if(EngineListener.isCopyInProgress())
                        {
                            popup_loader.showPopup(LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM, false);
                        }
                        else
                        {
                             AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_DELETE, 2);
                        }
                    }
                    break;
                }

                case ("Add"):
                {
                    __LOG("***** Add button clicked ******");
                    if (AudioListViewModel.isPlaylistsExist())
                    {
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_PL_CHOOSE_PLAYLIST);
                    }
                    else
                    {
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_PL_CREATE_NEW);
                    }
                    break;
                }

                case ("CopyAll"):
                case ("MoveAll"):
                case ("DeleteAll"):
                case ("Add_all"):
                {
                    __LOG("***** All button clicked ******");
		    // { modified by ravikanth 28-04-13 
                    if (EngineListener.isCopyInProgress() && btnId == "CopyAll")
                    {
		    // modified by ravikanth 29-06-13 for ITS 0176909
                        mediaPlayer.cancelInEditState = true
                        popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM);
                    }
                    else
                    {
		    	// { modified by ravikanth for 19.06.13 SMOKE_TC 7 & SANITY_CM_AK347
                        if (btnId == "CopyAll")
                        {
                            requestForCopyAll = false;
                            copyAllItemsListCreated = false
                            //AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_COPY_ALL, 0);
                            mediaPlayer.isAllItemsSelected = true
                            mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getTotalItemCount() + ")";
                            popup_loader.showPopup(LVEnums.POPUP_TYPE_COPY_ALL);
                        }
                        else if (btnId == "MoveAll")
                        {
                            popup_loader.showPopup(LVEnums.POPUP_TYPE_MOVE_ALL);
                        }
                        else if (btnId == "DeleteAll")
                        {
                            // { rollbacked by cychoi 2015.08.26 for ITS 267905
                            //if (currentLoaderTab.item.itemViewListModel.currentPlayingItem >= 0 && root_list.isPlaying)
                            //{
                            //    popup_loader.showPopup(LVEnums.POPUP_TYPE_FILE_CANNOT_DELETE);
                            //    return;
                            //}
                            // } added by cychoi 2015.08.26
                            currentFileOperationState = "DeleteAll"
                            if(EngineListener.isCopyInProgress()) // modified by ravikanth 21-07-13 for copy cancel confirm on delete
                            {
                                mediaPlayer.isAllItemsSelected = true // added by cychoi 2016.02.23 for ISV 125334
                                mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getTotalItemCount() + ")"; // added by cychoi 2016.02.23 for ISV 125334
                                popup_loader.showPopup(LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM, true);
                            }
                            else
                            {
                                mediaPlayer.isAllItemsSelected = true
                                mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getTotalItemCount() + ")";
                                popup_loader.showPopup(LVEnums.POPUP_TYPE_DELETE, true);
                            }
                        }
                        else
                            popup_loader.showPopup(LVEnums.POPUP_TYPE_PL_ADD_ALL_FILES);
                    }
		    // } modified by ravikanth 28-04-13 

                    mediaPlayer.setDefaultFocus();
                    break;
                }

                case ("Deselect"):
                {
                    __LOG("***** Deselect button clicked ******");
                    AudioListViewModel.enableAllCheckBoxes(false);
                    setBottomButtonDim(true);
                    AudioListViewModel.setFileURLCount(0); //added by yungi 2013.03.06 for New UX FileCount
                    mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")"; //added by yungi 2013.03.06 for New UX FileCount
                    // { added by cychoi 2015.09.07 for ITS 268407 & ITS 268412
                    mediaPlayer.tmp_focus_index = LVEnums.FOCUS_CONTENT;
                    mediaPlayer.setDefaultFocus();
                    // } added by cychoi 2015.09.07
                    break;
                }

                case ("Add_cancel"):
                case ("Delete_cancel"):
                case ("Move_cancel"):
                case ("CopyCancel"):
                case ("CopyToJB_cancel"):
                {
                    __LOG("***** Cancel button clicked ******");
                    cancelScroll(); // modified for ITS 0207903
//                    AudioListViewModel.operation = LVEnums.OPERATION_NONE; // removed by eugeny.novikov 2012.10.11 for CR 14229
                    mediaPlayer.tmp_focus_index = LVEnums.FOCUS_CONTENT; //modify ys ITS-0206339

                    cancelEditMode();
                    mediaPlayer.setDefaultFocus();
                    break;
                }

                default:
                    break;
            }
        }
    }

    /*********************************************/
    /************** Category List ****************/

    /* Left part of screen */

    Image
    {
        id: bgListCategory
        mirror: EngineListenerMain.middleEast
        source: RES.const_APP_MUSIC_PLAYER_URL_IMG_BACKGROUND_LIST  //width: 276
        anchors.left: parent.left
        height: parent.height
	//{modified by aettie.ji 2012.12.1 for New UX
        //width: (bgListCategory.visible) ? MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_CATEGORY_LIST
        //                                : 0;
        width: (bgListCategory.visible) ? 276     
                                        : 0;
    	//}modified by aettie.ji 2012.12.1 for New UX
        visible: (ipodCategoryEdit.visible || (isEditMode && !isCopyMode) || isCD) ? false : true    // Modify by Naeo 2012.07.09 for CR 10970

        ListView
        {
            id: categoryTabList;

            interactive: false;
            width: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_CATEGORY_LIST
            height:parent.height;

            model: currentLoaderTab ? currentLoaderTab.item.categoryModel : null;
            delegate: categoryTabDelegate
//{modified by aettie 2013.03.21 for touch focus rule
            //currentIndex: -1
            currentIndex: root_list.currentCategoryIndex //deleted by aettie 2013.03.20 for list default focus
//}modified by aettie 2013.03.21 for touch focus rule
            //{removed by junam 2013.06.05 for iPod playlist disable
            //onCurrentIndexChanged:
            //{
            //    if((AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2) && model.get(currentIndex).cat_id == "Song")
            //         alphabeticList.setListModel(true);
            //    else
            //        alphabeticList.setListModel(false);
            //}
            //}removed by junam

            //{removed by junam 2013.07.12 for music app
            //property bool playlistDisabled : ((AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
            //                                  && AudioController.isFlowViewEnable() == false) ? true : false;
            //}removed by junam
            function getDuplicateItem (listmodel, text)
            {
                /* Return index of duplicated element, otherwise -1.*/
                for (var i=0; i< listmodel.count ; i++)
                {
                    if (listmodel.get(i).categoryName == text)
                    {
                        return i;
                    }
                }
                return -1;
            }
            //{added by junam 2013.06.05 for iPod playlist disable
            function incCurrentIndex()
            {
                for( var idx = currentIndex + 1; idx < count; idx++)
                {
                    //{changed by junam 2013.07.12 for music app
                    //if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                    //{
                    //    if ((model.get(idx).cat_id == "Play_list") && AudioController.isFlowViewEnable() == false)
                    //        continue;
                    //}
                    if(model.get(idx).isSelectable == false)
                        continue;
                    //}changed
                    currentIndex = idx;
                    break;
                }
            }

            function decCurrentIndex()
            {
                for( var idx = currentIndex - 1; idx >=0 ; idx--)
                {
                    //{changed by junam 2013.07.12 for music app
                    //if(AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                    //{
                    //    if ((model.get(idx).cat_id == "Play_list") && AudioController.isFlowViewEnable() == false)
                    //        continue;
                    //}
                    if(model.get(idx).isSelectable == false)
                        continue;
                    //}changed by junam
                    currentIndex = idx;
                    break;
                }
            }
            //}added by junam

            Connections
            {
                target: (visible  && !popup_loader.visible) ? mediaPlayer : null

                onSignalSetFocus:
                {
                    // __LOG ("onSignalSetFocus");
                    // { deleted by wspark 2013.03.14 for ITS 159579
                    //quickScroll.visible = (mediaPlayer.focus_index == LVEnums.FOCUS_NONE) ? true : false; // add by junggil 2012.06.29 for CR10482 : Disappear the quick scroll when Jog Dial is used on List screen.
                    // } deleted by wspark
                    listSetFocus();
                }

                onChangeHighlight:
                {
                    if (!ipodCategoryEdit.visible)
                    {
                        // { added by dongjin 2012.11.23
                        if (isEditMode && mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)
                        {
			//[KOR][ITS][178101][ minor](aettie.ji)
                           isListSelected = true;
                            isTitleSelected = false;
                            isCategorySelected = false;

                        }
                        // } added by dongjin
                        // { added by dongjin 2012.09.25 for CR 13630
                        if (arrow == UIListenerEnum.JOG_DOWN && mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)
                        {
                            updateListCountInfo();
                        }
                        // } added by dongjin
			//[KOR][ITS][178101][ minor](aettie.ji)
                        //if (isListSelected)
                        //    listChangeSelection_onJogDial( arrow, status )
                        //else 
                        //    categoryChangeSelection_onJogDial( arrow, status )
                        if (isTitleSelected)
                            titleChangeSelection_onJogDial( arrow, status )
                        else if(isListSelected)
                            listChangeSelection_onJogDial( arrow, status, repeat ) //changed by junam 2013.11.13 for add repeat
                        else 
                            categoryChangeSelection_onJogDial( arrow, status )
                    }
                }
            }
	    
            Connections
            {
                target : (!visible && /*!popup.visible &&*/ !popup_loader.visible && !ipodCategoryEdit.visible &&
                          !(optionMenuLoader.status == Loader.Ready && optionMenuLoader.item.visible )) ?
                              EngineListener : null; // modified by cychoi 2015.06.03 for Audio/Video QML optimization
                onSignalTuneReleased:
                {
                   if (isListSelected)
                       listChangeSelection_onJogDial( UIListenerEnum.JOG_CENTER,
                                                  UIListenerEnum.KEY_STATUS_CANCELED, 1); //changed by junam 2013.11.13 for add repeat
                   else if (isTitleSelected)
                       titleChangeSelection_onJogDial( UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_CANCELED );
                }
            }

            // { added by junam 2012.12.10 for CR16482
            Connections
            {
                target : (visible && /*!popup.visible &&*/ !popup_loader.visible && !ipodCategoryEdit.visible &&
                          !(optionMenuLoader.status == Loader.Ready && optionMenuLoader.item.visible )) ?
                              EngineListener : null; // modified by cychoi 2015.06.03 for Audio/Video QML optimization
// modified by Dmitry 07.08.13 for ITS0180216 ITS0175300
                onSignalTuneNavigation:
                {
                    if(itemViewList.count > 0)
                    {
                        if (!isListSelected)
                           mediaPlayer.setDefaultFocus();
                        else
                           listChangeSelection_onJogDial( arrow, status, 1); //changed by junam 2013.11.13 for add repeat
                    }
                }

                //{added by junam 2013.07.12 for ITS_177486
                onSignalTunePressed:
                    if (isListSelected)
                        listChangeSelection_onJogDial( UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_PRESSED, 1); //changed by junam 2013.11.13 for add repeat
                    else if (isTitleSelected)
                        titleChangeSelection_onJogDial( UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_PRESSED);
                //}added by junam

                onSignalTuneReleased:
                {
                   if (isListSelected)
                       listChangeSelection_onJogDial( UIListenerEnum.JOG_CENTER,
                                                  UIListenerEnum.KEY_STATUS_RELEASED, 1); //changed by junam 2013.11.13 for add repeat
                   else if (isTitleSelected)
                       titleChangeSelection_onJogDial( UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_RELEASED );
                }

                // { DUAL_KEY added for TunePressed Cancel.
                onSignalTuneCanceled:
                {
                   if (isListSelected)
                       listChangeSelection_onJogDial( UIListenerEnum.JOG_CENTER,
                                                  UIListenerEnum.KEY_STATUS_CANCELED, 1); //changed by junam 2013.11.13 for add repeat
                }
                // } DUAL_KEY added for TunePressed Cancel.
// modified by Dmitry 07.08.13 for ITS0180216 ITS0175300

                // { added by lssanh 2013.02.26 ISV73837
                onBgReceived:
                {
                    __LOG ("onBgReceived slot");

                    scrollAcceleratorStop();
                }

                onScrollAccStop:
                {
                    __LOG ("onScrollAccStop slot");

                    scrollAcceleratorStop();
                }
                // } added by lssanh 2013.02.26 ISV73837
            }
            // } added by junam
            //{changed by junam 2013.07.12 for music app
            Connections
            {
                //target : (AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2) ? AudioController : null;
                target : (currentLoaderTab == ipodTab) ? AudioController : null;

                onMediaSyncfinished:
                {
                    //categoryTabList.playlistDisabled = ((AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2)
                    //                                    && AudioController.isFlowViewEnable() == false) ? true : false;
                    ipodTab.item.loadCategoryModel();
                }
                onIPodSortingOrderChanged:
                {
                    alphabeticList.listTextInner = alphabeticList.getListModel();
                    alphabeticList.hiddenListTextInner = alphabeticList.getHiddenListModel();
                }
                onSigCloseBTCallPopup:
                {
                    __LOG ("onSigCloseBTCallPopup loadCategoryModel again"); // ITS 225484
                    ipodTab.item.loadCategoryModel();
                }
            }
            //}changed by junam
        }
    }

    /* Delegate for Category List view. */
    Component
    {
        id: categoryTabDelegate

        Item
        {
            id: tabItem //added by aettie 2013.01.16 for ISV 68135/68124
            height: itemHeight ? itemHeight : categoryTabList.height / categoryTabList.model.count
            // { modified by dongjin 2012.08.27 for New UX
            width: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_CATEGORY_LIST //modified by nhj 2013.10.10 New UX 276
            // } modified by dongjin
	    //added by aettie 20130808 for category dimming(ITS 182674)
            property bool isSelected: categoryDimmed? ( (cat_id == "Folder")?  true : false ):((currentCategoryIndex == index)? true : false)
            property bool categoryDimmed : root_list.categoryDimmed;
            
	    //{added by aettie 2013.03.21 for touch focus rule
            property bool isTabFocused: (categoryTabList.currentIndex == index)
                                         && (mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)
                                         //&& !isListSelected
                                         && isCategorySelected //[KOR][ITS][178101][ minor](aettie.ji)
            //}added by aettie 2013.03.21 for touch focus rule
            property bool pressed : false; // added by junam 2013.06.10 for ITS172844
            Image
            {
                id: tabElement
                mirror: EngineListenerMain.middleEast
                source: 
                {
                    //changed by junam 2013.06.10 for ITS172844
                    //if(tabMouseArea.pressed || (!isListSelected && jogCenterPressed && categoryTabList.currentIndex == index)) return categoryImage_fp; // modified by Dmitry 15.05.13

                    if( ( tabItem.pressed && !categoryDimmed )
                    || ( tabItem.pressed && categoryDimmed && cat_id == "Folder")
                    || (isCategorySelected && jogCenterPressed && categoryTabList.currentIndex == index)) return categoryImage_fp; //[KOR][ITS][178101][ minor](aettie.ji)
                    else if (isTabFocused) return categoryImage_f;
                    else return "";
                }
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                width: 274 //modified for list focus image 20131029

                Image
                {
                    id: categoryIcon
                    anchors.left: parent.left
                    anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_ICON_MARGIN_X
                    z:100 //added by aettie 2013.01.16 for ISV 68135/68124
                    width:MPC.const_APP_MUSIC_PLAYER_FILE_LIST_ICON_WIDTH
		    
		    //{modified by aettie 2013.03.21 for touch focus rule
                    source: 
                    {
                    	//{ modified by hyejin.noh 20140611 for ITS 0239320
                        if(AudioController.PlayerMode == MP.DISC && cat_id == "Folder"){  
                            return "/app/share/images/music/categoryIcon_Song_s.png";
                        }else{
                            if( !isSelectable )  
                                return "/app/share/images/music/categoryIcon_"+cat_id+"_n.png";

                            if(isSelected)
                            {
                                if(isTabFocused)
                                    return "/app/share/images/music/categoryIcon_"+cat_id+"_f.png";
                                return "/app/share/images/music/categoryIcon_"+cat_id+"_s.png";
                            }
                            else
                            {
                                if(isTabFocused || tabItem.pressed)
                                    return "/app/share/images/music/categoryIcon_"+cat_id+"_f.png";
                                return "/app/share/images/music/categoryIcon_"+cat_id+"_n.png";
                            }
                        } //} modified by hyejin.noh 20140611

                        //{changed by junam 2013.07.04 for ITS172937
                        //if(tabItem.pressed || (!isListSelected && jogCenterPressed && categoryTabList.currentIndex == index)) return categoryIcon_fp;
                        //else if (isTabFocused) return categoryIcon_f;
                        //else if (isSelected) return categoryIcon_s;
                        //else return categoryIcon_n;
			//{[KOR][ISV][83981][C](aettie.ji)
                        /*if(tabItem.pressed || (isCategorySelected && jogCenterPressed && categoryTabList.currentIndex == index))
                            return "/app/share/images/music/categoryIcon_"+cat_id+"_p.png";
                        else if (isTabFocused)
                            return "/app/share/images/music/categoryIcon_"+cat_id+"_f.png";
                        else if (isSelected)
                            return "/app/share/images/music/categoryIcon_"+cat_id+"_s.png";
                        else
                            return "/app/share/images/music/categoryIcon_"+cat_id+"_n.png";*/

                         /*//{ modified by wonseok.heo NOCR for new UX 2013.11.09 //removed by hyejin.noh 20140611 for ITS 0239320
                        if(AudioController.PlayerMode == MP.DISC && cat_id == "Folder"){
                            //{  modified by wonseok.heo for ISV 94815 2013.11.19
//                            if( !isSelectable ) return "/app/share/images/music/categoryIcon_Song_n.png";
//                            if( ( tabItem.pressed && !categoryDimmed )
//                                || ( tabItem.pressed && categoryDimmed && cat_id == "Folder")
//                                || (isCategorySelected && jogCenterPressed && categoryTabList.currentIndex == index))
//                            {
//                                return "/app/share/images/music/categoryIcon_Song_p.png";
//                            }
//                            else if (isSelected && !isTabFocused)
//                            {
                                return "/app/share/images/music/categoryIcon_Song_s.png";
//                            }
//                            else
//                            {
//                                return "/app/share/images/music/categoryIcon_Song_f.png";
//                            }
                            // } modified by wonseok.heo for ISV 94815 2013.11.19

                        }else{
                             //} modified by wonseok.heo NOCR for new UX 2013.11.09
			    
                            if( !isSelectable ) return "/app/share/images/music/categoryIcon_"+cat_id+"_n.png";
                            //added by aettie 20130808 for category dimming(ITS 182674)
                            if(categoryDimmed && cat_id != "Folder" )
                            {
                                return "/app/share/images/music/categoryIcon_"+cat_id+"_n.png";
                            }
                            else if( ( tabItem.pressed && !categoryDimmed )
                                || ( tabItem.pressed && categoryDimmed && cat_id == "Folder")
                                || (isCategorySelected && jogCenterPressed && categoryTabList.currentIndex == index))
                            {

                                return "/app/share/images/music/categoryIcon_"+cat_id+"_p.png";
                            }
                            //modified by aettie for focused text color 20131002
    //                        else if (isSelected)
                            else if (isSelected && !isTabFocused)
                            {
                                return "/app/share/images/music/categoryIcon_"+cat_id+"_s.png";
                            }
                            else
                            {
                                return "/app/share/images/music/categoryIcon_"+cat_id+"_f.png";
                            }
                            //}[KOR][ISV][83981][C](aettie.ji)
                            //}changed by junam
                        }  // modified by wonseok.heo NOCR for new UX 2013.11.09*///removed by hyejin.noh 20140611 for ITS 0239320

                    }
		    //}modified by aettie 2013.03.21 for touch focus rule
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_TOPMARGIN_AREA_CONTAINER //added by eunhye 2012.08.25 for Music(LGE) # 4-22
                }

                Text
                {
                     id: categoryTitle
                     anchors.verticalCenter: parent.verticalCenter
                     width: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_TITLE_WIDTH
                     anchors.left: parent.left
                     anchors.leftMargin:MPC.const_APP_MUSIC_PLAYER_FILE_LIST_TITLE_MARGIN_X
		     //{modified by aettie 2013.01.16 for ISV 68135/68124
                     z:100
		     //{modified by aettie 2013.03.21 for touch focus rule
                     //color: isCopyMode ? MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_GREY :
                      //                   MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_DIMMED_GREY

                     color:
                     {
                         if( !isSelectable ) return MPC.const_APP_MUSIC_PLAYER_COLOR_DISABLE_GREY; //changed by junam 2013.07.12 for music app
                         //changed by junam 2013.06.10 for ITS172844
                         //if(tabMouseArea.pressed || (!isListSelected && jogCenterPressed && categoryTabList.currentIndex == index)) return MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY; // modified by Dmitry 15.05.13
                         //{[KOR][ISV][83981][C](aettie.ji)
			 //if( tabItem.pressed || (isCategorySelected && jogCenterPressed && categoryTabList.currentIndex == index)) return MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY; // [KOR][ITS][178101][ minor](aettie.ji)
                         //else if (isTabFocused) return MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY;
                         //else if (isSelected) return MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT;
                         //else return MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_DIMMED_GREY;
			 //added by aettie 20130808 for category dimming(ITS 182674)
                         if(categoryDimmed && cat_id != "Folder" )
                         {
                             return MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_DIMMED_GREY;
                         }
			//modified by aettie for focused text color 20131002
//                         else if (isSelected) return MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT;
                         else if (isSelected && !isTabFocused) return MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT;
                         else return MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY;
			 //}[KOR][ISV][83981][C](aettie.ji)
                     }
		     //}modified by aettie 2013.03.21 for touch focus rule
		     //}modified by aettie 2013.01.16 for ISV 68135/68124

                     //{changed by junam 2013.07.02 for ISV86699
                     //font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT //modified by aettie.ji 2012.11.28 for uxlaunch update
                     font.pointSize:
                     {
                         var textWidth = EngineListener.getStringWidth(text,
                                                                       (index == 0) ? MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB : MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR, // modified ITS 212608
                                                                       MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT);
                         // { added by wonseok.heo for ITS 211210 2013.11.26
                         if(AudioController.PlayerMode == MP.DISC){
                             if(textWidth > MPC.const_APP_MUSIC_PLAYER_DISC_FILE_LIST_TITLE_WIDTH )
                                 return MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT * MPC.const_APP_MUSIC_PLAYER_DISC_FILE_LIST_TITLE_WIDTH / textWidth;
                             return MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT;
                         } else {
                             if(textWidth > width )
                                 return MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT * width / textWidth;
                             return MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT;
                         } // } added by wonseok.heo for ITS 211210 2013.11.26
                     }
                     //}changed by junam
		     //modified bt aettie.ji 20130925 ux fix
                     font.family: isSelected? MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB:
                                                        MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR //modified by eunhye 2013.03.04 for New UX
                     text:  qsTranslate( MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT, categoryName ) + LocTrigger.empty
                 }
            }
            states:
            [
                State
                {
                    name: "active";
                    PropertyChanges
                    {
                        target: tabElement;

                        x: tabMouseArea.mouseX - width/2;
                        y: tabMouseArea.mouseY - height/2;
                        z: 100 ;
                    }
                }
            ]


             MouseArea
             {
                 id: tabMouseArea
                 anchors.fill: parent
                 beepEnabled: false // modified by ravikanth for ISV 90401                 
                 noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445

                 //added by junam 2013.06.10 for ITS172844
                 onExited: tabItem.pressed = false;
                 onReleased: tabItem.pressed = false; 
                 //}added by junam

		 //{added by aettie 2013.01.16 for ISV 68135/68124
                 onPressed:
                 {
                     tabItem.pressed = true; //added by junam 2013.06.10 for ITS172844
                     //{added by junam 2013.07.12 for music app
		     //added by aettie 20130808 for category dimming(ITS 182674)
                     if(categoryDimmed && cat_id != "Folder")
                     {
                         __LOG("onPressed : Categoty is Dimmed and it's not folder category")
                     }
                     else if( !isSelectable )
                     {
                         __LOG("onPressed : Playlist is not loading yet...")
                     }//}added by junam
                     else if ( false == mediaPlayer.disableList ) //added by junam 2013.04.23 to block mulitple request.
                     {
                         if(AudioListViewModel.getCurrentRequestCount() > 0 )
                         {
                             __LOG("onClicked : CurrentRequest")
                             return //added by yungi 2013.1.24 for ITS 153711
                         }
                     } //added by junam 2013.04.23 to block mulitple request.


                 }
                 //{changed by junam 2013.06.10 for ITS172844
                 //onReleased
                 onClicked://}changed by junam
                 {
                     EngineListenerMain.qmlLog("MusicPlayer.qml Category Tab onClicked") // added by sangmin.seol 2014.06.02 remain high log on category tab clicked

		 //added by aettie 20130808 for category dimming(ITS 182674)
                     if(categoryDimmed && cat_id != "Folder")
                     {
                         __LOG("onClicked : Categoty is Dimmed and it's not folder category")
                     }
                     //{added by junam 2013.07.12 for music app
                     else if( !isSelectable)
                     {
                         __LOG("onClicked : Not selectable item")
                     }//}added by junam
                     else if(mediaPlayer.disableList) //changed by junam 2013.07.16 for playlist count blinking
                     {
                         __LOG("onClicked : List is disabled")
                     }
                     else
                     {
                         if(AudioListViewModel.getCurrentRequestCount() > 0 || AudioController.PlayerMode == MP.DISC) //added by wonseok.heo NOCR for new UX 2013.11.09
                         {
                             __LOG("onClicked : CurrentRequest")
                             return //added by yungi 2013.1.24 for ITS 153711
                         }
                         //tabItem.state = "selected" //deleted by aettie 2013.03.21 for touch focus rule

                         //__LOG("TabClicked***")   // removed by sangmin.seol 2014.06.02
                         //{added by aettie 2013.03.21 for touch focus rule
                         EngineListenerMain.ManualBeep(); // modified by ravikanth for ISV 90401

                         categoryTabList.currentIndex = index
                         // modified by Dmitry 28.09.13 for ITS0190277
                         if(currentLoaderTab != ipodTab) //added for by junam 2013.11.22 for ISV_ME_94566
                         {
                             isListSelected = true
                             isCategorySelected = false
                         }

                         mediaPlayer.tmp_focus_index = LVEnums.FOCUS_CONTENT;//ys-20131111 ITS 0208108

                         //{added by junam 2013.07.04 for ITS172937
                         //if( (AudioController.PlayerMode == MP.IPOD1 || AudioController.PlayerMode == MP.IPOD2) //added by junam 2013.06.22 for ITS0175644
                         //        && ( ipodEditModel.get(index).cat_id == "Play_list"  ||  ipodEditModel.get(index).cat_type == "More" ) )
                         if(currentLoaderTab == ipodTab && ( ipodTab.item.categoryModel.get(index).cat_id == "Play_list"  ||  ipodTab.item.categoryModel.get(index).cat_id == "Etc" ) )
                         { //}changed by junam
                             quickScroll.visible = false;
                         }
                         //{removed by junam 2013.06.29 for ITS0177133
                         //else
                         //{
                         //    quickScroll.visible = true; // add by junggil 2012.06.29 for CR10482 : Disappear the quick scroll when Jog Dial is used on List screen.
                         //}
                         //}removed by junam

                         if (!(currentLoaderTab.item.historyStack < 0))
                         {
                             if( !isCopyMode )
                             {
                                 callFromCategory = true;
                                 setCategory (index);
                             }
                             else
                             {
                                 // __LOG ("Copy mode: it's not possible to change Categoty now");
                                 EngineListenerMain.qmlLog("MusicPlayer.qml Copy mode: it's not possible to change Categoty now")// added by sangmin.seol 2014.06.02 category tab error log
                             }
                         }
                         else
                         {
                             EngineListenerMain.qmlLog("MusicPlayer.qml repeated press on the tab!! currentLoaderTab.item.historyStack =  " + currentLoaderTab.item.historyStack) // added by sangmin.seol 2014.06.02 category tab error log
                             // __LOG ("repeated press on the tab");
                         }
                         //}added by aettie 2013.01.16 for ISV 68135/68124
                         //{added by WJL 2014.03.13 for ITS 229199
                         if(currentLoaderTab == ipodTab && ipodTab.item.currentCategory == "Etc")
                         {
                             setDefaultFocus();
                         }
                         //}added by WJL 2014.03.13 for ITS 22919
                     }//added by junam 2013.04.23 to block mulitple request.
                 }
             }
        }
    }

    /*********************************************/
    /************** ItemView List ****************/

    VerticalScrollBar
    {
        id: list_v_scroll //[KOR][ISV][64532][C](aettie.ji)
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 34
        anchors.rightMargin: (isEditMode && !isCopyMode) ? MPC.const_APP_MUSIC_PLAYER_EDIT_RIGHT_MARGIN : 8
        height: 465
        position: itemViewList.visibleArea.yPosition
        pageSize: itemViewList.visibleArea.heightRatio
        visible: ((pageSize < 1) && itemViewList.count > 0) && !ipodCategoryEdit.visible //Modified by Radhakrushna CR#13631 20120915
    }

    Image
    {
        height: parent.height

        anchors
        {
            left: parent.left
            leftMargin: (bgListCategory.visible) ? MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_CATEGORY_LIST : 0
            right: parent.right;
            rightMargin: (!ipodCategoryEdit.visible && isEditMode && !isCopyMode) ? (quickScroll.visible? 322 : MPC.const_APP_MUSIC_PLAYER_EDIT_RIGHT_MARGIN + 24)
                                                                   : (quickScroll.visible ? 77 : 33)
        }
// modified by Dmitry 08.05.13
        Image
        {
            id: bg_item_view_text
            mirror: EngineListenerMain.middleEast
	    //[KOR][ITS][178101][ minor](aettie.ji)
            property bool focused:(mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)
                                         && isTitleSelected &&!isCopyMode/*&&!root_list.ipodList*/ //removed by junam 2013.07.20 for ITS_NA_179108
            property bool pressed : false; 
//[KOR][ITS][181720][minor](aettie.ji)
            // { modified by wonseok.heo NOCR for new UX 2013.11.09 modified by yungi 2013.08.02 for ITS 181722
            source:// if (AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.MP3_CD)
//                    {
//                        pressed? RES.const_APP_MUSIC_PLAYER_URL_MP3CD_IMG_TAP_ICON_INDEX_P :
//                                 focused? RES.const_APP_MUSIC_PLAYER_URL_MP3CD_IMG_TAP_ICON_INDEX_F :
//                                 RES.const_APP_MUSIC_PLAYER_URL_MP3CD_IMG_TAP_ICON_INDEX
//                    }
//                    else
                   // {
                        pressed? RES.const_APP_MUSIC_PLAYER_URL_IMG_TAP_ICON_INDEX_P :
                                 focused? RES.const_APP_MUSIC_PLAYER_URL_IMG_TAP_ICON_INDEX_F :
                                 RES.const_APP_MUSIC_PLAYER_URL_IMG_TAP_ICON_INDEX
                   // }
            // } modified by wonseok.heo NOCR for new UX 2013.11.09
            // {
            //     if (/*root_list.ipodList ||*/ isCopyMode || isEditMode) //removed by junam 2013.07.20 for ITS_NA_179108
            //     {
            //         return RES.const_APP_MUSIC_PLAYER_URL_IMG_TAP_ICON_INDEX
            //     }
            //     else
            //    {
            //           return pressed? RES.const_APP_MUSIC_PLAYER_URL_IMG_TAP_ICON_INDEX_P : 
            //                    focused? RES.const_APP_MUSIC_PLAYER_URL_IMG_TAP_ICON_INDEX_F : 
            //                    RES.const_APP_MUSIC_PLAYER_URL_IMG_TAP_ICON_INDEX
            //   }           
            // }
            anchors.top: parent.top;
            // { modified by wonseok.heo NOCR for new UX 2013.11.09 modified by wonseok.heo for ITS 187104 2013.08.28
            anchors.topMargin: //if (AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.MP3_CD)
                               //{
                                  // MPC.const_APP_MUSIC_PLAYER_LIST_VIEW_MP3_TOP_MARGIN
                              // }else{
                                   MPC.const_APP_MUSIC_PLAYER_LIST_VIEW_TOP_MARGIN
                              // }
            // } modified by wonseok.heo NOCR for new UX 2013.11.09 modified by wonseok.heo for ITS 187104 2013.08.28

//[KOR][ITS][181720][minor](aettie.ji)
            visible: ( root_list.isVisibleText && itemViewList.visible ) && !( isCopyMode || isEditMode )
            //anchors.right: parent.right //removed by junam 2013.11.21 for ISV_NA_90331
            anchors.left: parent.left

            Image
            {
                id: folder_img
                source: "/app/share/images/music/ico_tab_folder.png";
                anchors.top: parent.top;
                anchors.topMargin: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_COLUMN_SPACING
                //visible: ((currentCategoryIndex == 0) && (currentLoaderTab != ipodTab)) //removed by junam 2013.08.20 for up icon
                anchors
                {
                    left:parent.left
                    leftMargin: MPC.const_APP_MUSIC_PLAYER_EDIT_MODE_FILE_LIST_VIEW_SECTION_IMAGE_LEFT_MARGIN
                    verticalCenter: parent.verticalCenter
                }
            }
// modified by Dmitry 08.05.13

	    //[KOR][ITS][178101][ minor](aettie.ji)
	    //{added by aettie 20130904 for JAT_ITS_188339
	       DHAVN_Marquee_Text
             {
                 id: text_item_view
                 text: root_list.textItemViewList

                 scrollingTicker: root_list.scrollingTicker && bg_item_view_text.focused	    

                 color: MPC.const_APP_MUSIC_PLAYER_COLOR_SUB_TEXT_GREY

                 anchors
                 {
                     left:parent.left
                     leftMargin: folder_img.visible ? MPC.const_APP_MUSIC_PLAYER_FILE_LIST_MARGIN_X : MPC.const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_MARGIN_X 
                     verticalCenter: parent.verticalCenter
                 }
                 
                 width: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_TEXT_WIDTH   
                 fontSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_30_FONT
                 fontFamily: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
             }
	     //}JAT_ITS_188339
            MouseArea
            {
	    //[KOR][ITS][178101][ minor](aettie.ji)
                id: tab_mouse_area 
                anchors.fill: parent
                noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445
                beepEnabled : false;     //added by sangmin.seol 2014.06.19 ITS 0240747 list folder manualbeep

                onExited: {
                    if (/*root_list.ipodList ||*/isCopyMode|| isEditMode) return; //removed by junam 2013.07.20 for ITS_NA_179108

                    bg_item_view_text.pressed = false;
                    //{ modified by yongkyun.lee 2013-07-25 for : NOCR : LYK-NOCR_ListFocus_FolderBar
                    if ( currentLoaderTab == ipodTab && itemViewList.count == 0 )
                    {
                        __LOG("skip onExited:")  // ITS 250826
                    }
                    else
                    {
                        isTitleSelected = false
                        isListSelected =  true
                        isCategorySelected = false
                    }
                    //} modified by yongkyun.lee 2013-07-25 
                }
                onReleased: 
                {
                    if (/*root_list.ipodList ||*/ isCopyMode|| isEditMode) return;//removed by junam 2013.07.20 for ITS_NA_179108
                    bg_item_view_text.pressed = false;
                    //{ modified by yongkyun.lee 2013-07-25 for : NOCR : LYK-NOCR_ListFocus_FolderBar
                    if ( currentLoaderTab == ipodTab && itemViewList.count == 0 )
                    {
                        __LOG("skip onReleased:")  // ITS 250826
                    }
                    else
                    {
                        isTitleSelected = false
                        isListSelected =  true
                        isCategorySelected = false
                    }
                    //} modified by yongkyun.lee 2013-07-25
                }
                onPressed:
                {
                    if (/*root_list.ipodList ||*/ isCopyMode|| isEditMode) return;//removed by junam 2013.07.20 for ITS_NA_179108
                    bg_item_view_text.pressed = true;
                         isTitleSelected = true
                         isCategorySelected = false
                }
                onClicked:
                {
                    __LOG("tab_mouse_area onClicked " );
                    if (/*root_list.ipodList||*/ isCopyMode|| isEditMode) return;//removed by junam 2013.07.20 for ITS_NA_179108

                    EngineListenerMain.ManualBeep();    //added by sangmin.seol 2014.06.19 ITS 0240747 list folder manualbeep
                    currentLoaderTab.item.backHandler();
                }
            }
        }

        /* Common view */
        ListView
        {
            id: itemViewList
            // { rollbacked by cychoi 2015.10.13 for ITS 268465
            //snapMode: root_list.panning ? ListView.SnapToItem : ListView.NoSnap
            snapMode: moving ? ListView.SnapToItem : ListView.NoSnap // modified by Dmitry 27.07.13
            // } rollbacked by cychoi 2015.10.13
            property real contentBottom: contentY + height
            property bool disableCountUpdate: false//added by junam 2013.07.23 for ONDEMAND_PLAYLIST
            enabled: false //ys 2013-11-8 As soons as list enter, and push the item, then list black

            anchors{
                fill: parent
                topMargin : (bg_item_view_text.visible)? (isCD ? 50: 75) : 1 //modified by wonseok.heo for ITS 195112 2013.10.12
            }

            onHeightChanged:
            {
                if (currentLoaderTab == ipodTab) // ITS 211579
                    centerCurrentPlayingItem()
            }

            //{added by junam 2013.07.15 for ISV_NA_87444
// modified by Dmitry 07.08.2013 for ITS0175300
            onMovementEnded:
            {
                //changed by junam 2013.08.22 for ITS_NA_184266
                //if (!isListSelected)               
                if (isListSelected == false && (optionMenuLoader.status != Loader.Ready || optionMenuLoader.item.visible == false))
                {//}changed by junam
                    mediaPlayer.setDefaultFocus();
                }

                // modified by Dmitry 22.08.13 for ITS0185396
                // modified by raviknath 03-10-13 for ITS 0191657
                var tmp_start_index = indexAt(10, contentY + 10)
                if (tmp_start_index == -1)
                    tmp_start_index = indexAt(10, contentY + MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_HEIGHT + 10)

                var tmp_end_index = indexAt(10, contentBottom - 10)
                if (tmp_end_index == -1)
                    tmp_end_index = indexAt(10, contentBottom - ( MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_HEIGHT + 10 ))

                //{added by junam 2013.11.18 for ITS_NA_207149
                if(tmp_end_index < 0)
                {
                    __LOG("item count is smaller than screen")
                }//}added by junam
                else if(!((currentIndex >= tmp_start_index) && (currentIndex <= tmp_end_index)))
                {
                    // added by Dmitry 29.10.13
                    if ((tmp_end_index == (itemViewList.count - 1)) && isVisibleText && !isEditMode)
                       tmp_start_index += 1
                    currentIndex = tmp_start_index
                    if (currentIndex == -1)
                        currentIndex = indexAt(10, contentY + MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_HEIGHT + 10)
                }
                // { added by sangmin.seol 2014.03.27 for ITS_NA_0231339 Move focus to the first item when it is not possible to display the current focused item entire
                else if(currentIndex == tmp_end_index)
                {
                    if((height - (currentItem.y - contentY)) < currentItem.height)
                        currentIndex = tmp_start_index
                }
                // } added by sangmin.seol 2014.03.27 for ITS_NA_0231339 Move focus to the first item when it is not possible to display the current focused item entire

                AudioListViewModel.moving = false;
                //root_list.panning = false; // rollbacked by cychoi 2015.10.13 for ITS 268465
                EngineListenerMain.qmlCritical("DHAVN_AppMediaPlayer_ListView.qml", "onMovementEnded panning = " + root_list.pannin)
            }
            // modified by Dmitry 07.08.2013 for ITS0175300
            onMovementStarted:
            {
                if( mediaPlayer.focus_index == LVEnums.FOCUS_MODE_AREA )
                    mediaPlayer.focus_index = LVEnums.FOCUS_NONE
                AudioListViewModel.moving = true;
                //root_list.panning = true; // rollbacked by cychoi 2015.10.13 for ITS 268465
                EngineListenerMain.qmlCritical("DHAVN_AppMediaPlayer_ListView.qml", "onMovementStarted panning = " + root_list.pannin)
            }
            //}added by junam

            // { rollbacked by cychoi 2015.10.13 for ITS 268465
            //onFlickEnded:
            //{
            //    root_list.flicking = false
            //    EngineListenerMain.qmlCritical("DHAVN_AppMediaPlayer_ListView.qml", "onFlickEnded flicking = " + root_list.flicking)
            //}

            //onFlickStarted:
            //{
            //    root_list.flicking = true
            //    EngineListenerMain.qmlCritical("DHAVN_AppMediaPlayer_ListView.qml", "onFlickStarted flicking = " + root_list.flicking)
            //}
            // } rollbacked by cychoi 2015.10.13

            delegate: itemViewListDelegate;
            model: currentLoaderTab ? currentLoaderTab.item.itemViewListModel : null;
            // modified by Dmitry Bykov 11.04.2013 for blinking highlight
            highlightMoveDuration: 1    //Added by Alexey Edelev 2012.10.15
            highlight: highlightItem
            highlightFollowsCurrentItem: true
            // modified by Dmitry Bykov 11.04.2013 for blinking highlight

            clip: true
            focus: true

            section.property: "firstChar"
            section.criteria: ViewSection.FullString
            section.delegate: itemViewListSectionDelegate
            maximumFlickVelocity: 10000 //revert to high speed by junam

            //{removed by junam 2013.10.29 for playlist population
            //function indexChangeToVisible(enteringIndex)
            //{
            //    AudioListViewModel.handleListScrollEvent(enteringIndex);
            //}
            //}removed by junam

            // added by Dmitry 20.04.13
            onCountChanged:
            {               
               if (count > 0)
               {
                  enabled=true //ys 2013-11-8 As soons as list enter, and push the item, then list black
                  jboxListEmptyStr.visible = false
	       //[KOR][ITS][178101][ minor](aettie.ji)
                  if (changeFocusToList)
		  {
                     isListSelected = true
                     isCategorySelected = false
                  }
                  EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_COPY_TO_JUKEBOX, true); //added by Michael.Kim 2013.11.05 for Hyundai Cooperative Test Issue #7

                  //{added by junam 2013.12.04 for ITS_NA_212672
                  if(optionMenuLoader.status == Loader.Ready && optionMenuLoader.item.visible)
                  {
                      if( AudioController.PlayerMode == MP.JUKEBOX )
                      {
                          EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_NOW_PLAYING, true);
                          EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_DELETE, true);
                          EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_CLEAR_JUKEBOX, true);
                      }
                  }
                  //}added by junam
               }
               else
               {
                   enabled= false //ys 2013-11-8 As soons as list enter, and push the item, then list black
               }

               changeFocusToList = false
	       // modified by ravikanth 17-05-13 for bottom area button enable on copy launch from player
               if(isEditMode && count > 0)
               {
                   setBottomButtonDim(true)
               }
            }
            // added by Dmitry 20.04.13

            onCurrentIndexChanged:
            {
                //{added by junam 2013.06.28
                if(model == AudioListViewModel)
                {
                    AudioListViewModel.currentFocuseIndex = currentIndex;
                }
                //}added by junam

                updateListCountInfo();

                var isListFocused = (mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT && isListSelected);
                if (isListFocused == false) scrollAcceleratorStop(); // added by lssanh 2013.03.11 ISV73837 
            }

            Text
            {
                id: jboxListEmptyStr

                visible: false
                text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,
                                  QT_TR_NOOP("STR_MEDIA_EMPTY")) + LocTrigger.empty

                anchors.centerIn: parent
                color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
                //font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT   //modified by aettie.ji 2012.11.28 for uxlaunch update
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDR_40_FONT //modified by Michael.Kim 2013.12.19 for ITS 216393
                font.family:MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDR //modified by Michael.Kim 2013.12.19 for ITS 216393
            }

            Text
            {
                id: jboxEmptyStr

                visible: false
                text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,
                                  QT_TR_NOOP("STR_MEDIA_MNG_JUKEBOX_EMPTY")) + LocTrigger.empty

                anchors.centerIn: parent
                color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_32_FONT   //modified by aettie.ji 2012.11.28 for uxlaunch update

                Connections
                {
                    target: AudioListViewModel

                    onShowJBoxEmptyStr:
                    {
                        jboxEmptyStr.visible = (isVisible && !isEditMode);
                        if(jboxEmptyStr.visible)
                            jboxListEmptyStr = false
                    }
                }
            }

            onContentYChanged:
            {
//{Added by Alexey Edelev 2012.10.15
                /* modify by youngsim.jo when push the ccp long, all list is focused when 62~68 line displayed
                var tmpIndex = -1;
                switch(timerPressedAndHold.lastPressed)
                {
                case UIListenerEnum.JOG_UP:
                    tmpIndex = indexAt ( 10, Math.floor(contentY + 10) );
                    break;
                case UIListenerEnum.JOG_DOWN:
                    tmpIndex = indexAt ( 10, Math.floor(contentY + height - 10) );
                    break;
                }
                if(tmpIndex >= 0 ) {
                    EngineListenerMain.qmlLog("tmpIndex: " + tmpIndex);
                    currentIndex = tmpIndex;
                }
                */
            }

            signal lostFocus( variant arrow )

            onLostFocus:
            {
               if (!EngineListenerMain.middleEast)
               {
                  if ( arrow == UIListenerEnum.JOG_RIGHT )
                      mediaPlayer.tmp_focus_index = rightButtonArea.setDefaultFocus( arrow )
               }
               else
               {
                  if ( arrow == UIListenerEnum.JOG_LEFT )
                      mediaPlayer.tmp_focus_index = rightButtonArea.setDefaultFocus( arrow )
               }
               isListSelected = false; // modified by Dmitry 07.08.13 for ITS0175300
            }

            function cancelFlick() // modified for ITS 0207903
            {
                 __LOG("cancelFlick()");
                if(AudioListViewModel.moving)
                    returnToBounds()
            }

            function quickPopupByJog(text)
            {
                quickimg.visible = true;
                textid.text = text;
                quicktim.restart();
            }

            function quickPopup(text)
            {
                quickimg.visible = true;
                textid.text = text;
//{changed by junam 2013.05.08 for quick view performance
                //quicktim.running = true;
                quicktim.restart();
//}changed by junam
            }

            //{changed by junam 2013.11.13 for add repeat
            function incrementIndex(repeat)
            {
                var nextIndex = currentIndex;
                for(var n = 0; n < repeat; n++ )
                {

                    if (nextIndex == indexAt(width / 2, contentY + height - currentItem.height/2 - 10))
                        positionViewAtIndex(nextIndex == count - 1 ? 0 : nextIndex + 1, ListView.Beginning)// modified by Dmitry 03.11.13

                    if(nextIndex < count - 1)
                        nextIndex++;
                    else if(keyNavigationWraps)
                        nextIndex = 0;
                }
                currentIndex = nextIndex;
            }

            function decrementIndex(repeat)
            {
                var nextIndex = currentIndex;
                for(var n = 0; n < repeat; n++ )
                {
                    if (nextIndex == indexAt(width / 2, contentY + currentItem.height/2 + 10))
                        positionViewAtIndex(nextIndex == 0 ? count - 1 : nextIndex - 1, ListView.End)// modfied by Dmitry 03.11.13

                    if(nextIndex > 0)
                        nextIndex--;
                    else if(keyNavigationWraps)
                        nextIndex = count-1;
                }
                currentIndex = nextIndex;
            }
            //}changed by junam

           Image
           {
               id: quickimg
               visible: false
               // { modified by cychoi 2015.08.21 for ITS 267745
               anchors
               {
                   left: parent.left
                   leftMargin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_LEFTMARGIN
                   top: parent.top
                   topMargin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_TOPMARGIN
               }
               //anchors.centerIn: itemViewList
               // } modified by cychoi 2015.08.21
               opacity: 1.0
               source: RES.const_APP_MUSIC_PLAYER_URL_IMG_QUICKSCROLL_POPUP

               Text
               {
                   id : textid
//                   width: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_TEXT_WIDTH
//                   anchors
//                   {
//                       left : quickimg.left
//                       leftMargin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_TEXT_LEFTMARGIN
//                       verticalCenter: quickimg.top
//                       verticalCenterOffset: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_POPUP_TEXT_TOPMARGIN
//                   }
                   anchors.centerIn: parent  // ITS 238998

                   color: MPC.const_APP_MUSIC_PLAYER_COLOR_SUB_TEXT_GREY // modified by cychoi 2015.08.21 for ITS 267745
                   font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
                   font.pointSize: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_FONT_SIZE_TEXT_HDB_100_FONT    //modified by aettie.ji 2012.11.28 for uxlaunch update
//                   horizontalAlignment: Text.AlignHCenter
               }
           }

            Timer
            {
                id : quicktim
                interval: 1000; running: false; repeat: false
                onTriggered: quickimg.visible = false;
            }
//{added by jaehwan 2013.10.29 to improve qucikscroll performance
            Timer
            {
                id : quickScrollDelayTimer
                interval: 100;
                running: false;
                repeat: false
                onTriggered:  { root_list.isScrolling = false; }
            }
//} added by jaehwan
            Timer
            {
//{Changed by Alexey Edelev 2012.10.15
               id: timerPressedAndHold
               interval: 20 // modified by Dmitry 24.05.13
               running: false
               repeat: true
               triggeredOnStart: true
               property int iterations: 0
               property int lastPressed: -1

               onTriggered:
               {
// modified by Dmitry 24.05.13
//                   if(lastPressed === UIListenerEnum.JOG_UP
//                           && (itemViewList.contentY + itemViewList.currentItem.height/2) >= itemViewList.currentItem.y) {
//                       if(iterations < 30) {
//                           iterations++
//                       }
//                       EventsEmulator.sendWheel(UIListenerEnum.JOG_UP, (120 + 120 * Math.floor(iterations / 10)), itemViewList);
//                       return;
//                   }

//                   if(lastPressed === UIListenerEnum.JOG_DOWN
//                           && (itemViewList.contentY + itemViewList.height - 10) <= (itemViewList.currentItem.y + itemViewList.currentItem.height)) {
//                       if(iterations < 30) {
//                           iterations++
//                       }
//                       EventsEmulator.sendWheel(UIListenerEnum.JOG_DOWN, (120 + 120 * Math.floor(iterations / 10)), itemViewList);
//                       return;
//                   }
// modified by Dmitry 24.05.13
                   moveToNext_Prev(lastPressed);
               }
//}Changed by Alexey Edelev 2012.10.15
            }
        }
    }
// added by Dmitry Bykov 11.04.2013 for blinking highlight
    Component
    {
       id: highlightItem

       Image
       {
          id: itemFocused
 	  //deleted for list focus image 20131029 	       
          width: isCD ? MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_WIDTH :
                                ((quickScroll.visible) ?  MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_IMAGE_WIDTH_SHORT :
                                                               MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_IMAGE_WIDTH)
          //anchors.left: !(isCD||isEditMode)? parent.left : 281
          //anchors.leftMargin: !(isCD||isEditMode)? 0 : (isCD? 15 : 37)
          anchors.left: parent.left
          anchors.leftMargin: isEditMode ? MPC.const_APP_MUSIC_PLAYER_EDIT_MODE_FILE_LIST_VIEW_SECTION_IMAGE_LEFT_MARGIN :
                (isCD) ?  MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_IMAGE_X : 1
	  //modified for list focus image 20131029
          anchors.top : itemViewList.currentItem.bottom
          anchors.topMargin : -93

          anchors.bottom : itemViewList.currentItem.bottom
          anchors.bottomMargin : isCD? -4 : -3.3

          source: isCD ?  "/app/share/images/general/list_f.png":"/app/share/images/music/tab_list_02_f.png"
          visible: itemViewList.currentItem.isfocused
       }
    }
// added by Dmitry Bykov 11.04.2013 for blinking highlight

//{added by aettie 2013.02.26 for New UX
    Component
    {
        id: itemViewListDelegate

        Item
        {
            id: listItem
	    //added by aettie 2013.03.12 for New UX
            property bool isfocused: (mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)&&(itemViewList.currentIndex == model.index)
                                                    && isListSelected
            anchors.left: parent.left
            anchors.right: parent.right

            height: MPC.const_APP_MUSIC_PLAYER_LISTVIEW_ITEM_HEIGHT /*92*/

	    //modified for list focus image 20131029
        /* List Item delimiter */
            Image
            {
                id: line_id 

                y: 92
                
                anchors.left: parent.left
                anchors.right: parent.right
                fillMode: Image.Stretch

                visible: true
                source: isCD ? "/app/share/images/general/list_line.png" : "/app/share/images/general/edit_list_line.png"
            }
            Image
            {
               id: itemPressed
		//deleted for list focus image 20131029
               width: isCD ? MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_WIDTH :
                                     ((quickScroll.visible) ?  MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_IMAGE_WIDTH_SHORT :
                                                                    MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_IMAGE_WIDTH)
               //anchors.left: !(isCD||isEditMode)? parent.left : 281
               //anchors.leftMargin: !(isCD||isEditMode)? 0 : (isCD? 15 : 37)
               anchors.left: parent.left
               anchors.leftMargin:  (isEditMode && !isCopyMode) ? MPC.const_APP_MUSIC_PLAYER_EDIT_MODE_FILE_LIST_VIEW_SECTION_IMAGE_LEFT_MARGIN :
                     (isCD) ?  MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_IMAGE_X : 1
	       //added for list focus image 20131029
               anchors.top: line_id.top
               anchors.topMargin : -94
               anchors.bottom : line_id.bottom
               anchors.bottomMargin : isCD? -3.55 : 0
               
               source: isCD ?  "/app/share/images/general/list_p.png":"/app/share/images/music/tab_list_02_p.png"
               visible: mouse_area.pressed || (isListSelected && jogCenterPressed && itemViewList.currentIndex == index) // modified by Dmitry 15.05.13
            }

             AnimatedImage
             {
                 id: albumMarked

                 anchors.verticalCenter: parent.verticalCenter
                 anchors.left: parent.left
                 anchors.leftMargin: isCD ? 37 /*37-15*/ : 6 //20131025 GUI fix

                 source: "/app/share/images/video/icon_play.gif";
                 // { rollbacked by cychoi 2015.10.13 for ITS 268465
                 //playing: isPlaying && !root_list.panning
                 playing: isPlaying && !itemViewList.moving
                 // } rollbacked by cychoi 2015.10.13

                 visible: (currentLoaderTab.item.itemViewListModel.currentPlayingItem == index)
                 opacity: 1 //20131115 GUI fix (isEditMode && !isCopyMode) ? 0 : 1
             }

             Image
             {
                 id: itemIconImage

                 anchors.verticalCenter: parent.verticalCenter;
                 source: itemViewImage ? itemViewImage : "";
                 visible: isImageVisible
                 opacity: (isCD && albumMarked.visible) ? 0 : 1 //20131025 GUI fix
                 
                 anchors.left: parent.left
//                    anchors.leftMargin: isEditMode? 55 /*92 - 37 */ : isCD ? 92 : 50
//20131025 GUI fix
                 anchors.leftMargin: 
                 {

                    if(itemViewImage == "/app/share/images/music/ico_tab_list_folder.png")
                    {
                        if(isCD)
                        {
                            return 21
                        }
                        else 36
                    }
                    else if (isCD) return 99
                    else if (isEditMode && !isCopyMode)
                    {
                        return 92
                    }
                    else
                        return 50
//                    ((isEditMode && !isCopyMode) || isCD)? 92 : (itemViewImage == "/app/share/images/music/ico_tab_list_folder.png")? 34 : 50
                 }


                 width : 78
                 height : 78

                 Component.onDestruction: AudioListViewModel.onComponentDestruction(index);
                 Component.onCompleted: AudioListViewModel.onComponentCompleted(index);
             }

             DHAVN_List_Marquee_Text
             {
                 id: itemTitle
                 property bool isSelected: (currentLoaderTab.item.itemViewListModel.currentPlayingItem == index)
                 text: itemViewTitle ? ( currentLoaderTab.item.isEtcList ?
                                             qsTranslate( MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT, itemViewTitle ) + LocTrigger.empty : itemViewTitle) : "";

                 //scrollingTicker: EngineListenerMain.scrollingTicker && model.index == itemViewList.currentIndex
                 scrollingTicker: root_list.scrollingTicker && model.index == itemViewList.currentIndex 	    //modified by aettie for ticker stop when DRS on
                                              && (mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)
                                              && isListSelected
                                              && timerPressedAndHold.lastPressed < 0

                 /* itemURLsorce refer to song */
                 property string itemURLsource: itemURL ? itemURL : "";

                 //{changed by junam 2013.07.12 for music app
                 //color: isSelected? MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT :
                 //            MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
                 color:
                 {
		     //modified by aettie for focused text color 20131002
                     if(!isSelectable) return MPC.const_APP_MUSIC_PLAYER_COLOR_DISABLE_GREY;
                     else if(isSelected && !isfocused) return MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT;
                     else return MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY;
                 }
                 //}changed by junam

                 anchors.verticalCenter: parent.verticalCenter

                 anchors.left: parent.left
                 //20131025 GUI fix
                 anchors.leftMargin:
                 {
                    if(isImageVisible) //changed by junam 2013.11.12
                    {
                        if (itemViewImage == "/app/share/images/music/ico_tab_list_folder.png") {
                            if(isCD) return 99  
                            else return 125
                        }
                        else if(isEditMode && !isCopyMode && !ipodCategoryEdit.visible) return 198
                        else return 155
                    }
                    else
                    {
                        if(isCD) return 99
                        else if (isEditMode && !isCopyMode && !ipodCategoryEdit.visible) return 93 
                        else return 50 
                    }
                }                                             
                 fontSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
		     //modified bt aettie.ji 20130925 ux fix
                 fontFamily: (isSelected)? MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB:
                                                       MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                 //changed by junam 2013.11.12
                 width: isImageVisible ? (isEditMode && !ipodCategoryEdit.visible? 692 : isCD? 1025 : 759):
                                                 (isEditMode && !ipodCategoryEdit.visible? 792 : isCD? 1125 : 859)
             }

             Image
             {
                 id: itemCheckIconImage
		 
		 // modified by ravikanth for ITS 0188110
                 source: ( isCheckBoxMarked || mediaPlayer.isAllItemsSelected ) ? "/app/share/images/general/checkbox_check.png"
                                                          : "/app/share/images/general/checkbox_uncheck.png"

                 anchors.verticalCenter: parent.verticalCenter;
                 anchors.left: parent.left
                 anchors.leftMargin: (quickScroll.visible)? 895 : 939
                 visible: (currentCategoryIndex == 5 || isCopyMode) ? false : isCheckBoxEnabled; // modified by ravikanth 23-08-13 for ISV 89592
             }

            MouseArea
            {
                id: mouse_area //added by aettie 2013.03.12 for New UX
                anchors.fill: parent
                noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445

                beepEnabled : false;

                onClicked:
                {
                    if ( false == mediaPlayer.disableList )//added by junam 2013.04.23 to block mulitple request.
                    {
                        EngineListenerMain.ManualBeep();
                        __LOG("isListSelected " +  isListSelected );

                        //}added by aettie 2013.03.24 for touch focus rule
                        if (isCopyMode)
                        {
                            path = itemTitle.itemURLsource;
                        }

                        if (isSelectable)
                        {
                            //{moved by junam 2013.07.12 for music app
                            if(currentLoaderTab == jukeboxTab && jukeboxTab.item.currentCategory === "Song" && !isEditMode) // modified by ravikanth 02-06-13 for ITS 0177696
                            {
                                __LOG("Song category do not need change list selection");
                            }
                            else
                            {
                                //{added by aettie 2013.03.24 for touch focus rule
                                if(currentLoaderTab == ipodTab) // modified by ravikanth 16-08-13 for hotfix change index on touch
                                    itemViewList.disableCountUpdate = true;//added by junam 2013.07.23 for ONDEMAND_PLAYLIST
                                itemViewList.currentIndex = index;
                                __LOG("itemViewList.currentIndex " +  itemViewList.currentIndex );
                                isListSelected = true;
                                isCategorySelected =false;
                                isTitleSelected = false; //[KOR][ITS][178101][ minor](aettie.ji)
                                itemViewList.disableCountUpdate = false;//added by junam 2013.07.23 for ONDEMAND_PLAYLIST
                            }
                            //}moved by junam

                            if (AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.AUDIO_CD)
                            {
                                // { commented by cychoi 2013.07.17 for MLT spec out
                                //if (AudioController.isPlayFromMLT)
                                //{
                                //    AudioController.ExitFromMLT();
                                //}
                                // } commented by cychoi 2013.07.17
                                //AudioController.setRepeatRandomMode(MP.REPEATALL ,MP.RANDOMOFF  );//added by yongkyun.lee 20130612 for : its 172869 //deleted by Michael.Kim 2013.08.07 for ITS Issue 174020
                                currentLoaderTab.item.itemElementHandlerCD(index, isCheckBoxEnabled);
                                currentLoaderTab.item.itemElementHandlerCDback();
                            }
                            else
                            {
                                currentLoaderTab.item.itemElementHandler (index, isCheckBoxEnabled);
                                if(rightButtonArea.curModel == copyToJukeboxBtnModel  || rightButtonArea.curModel == deleteInJukeboxBtnModel )//added by yungi 2013.03.11 for Nex Ux FileCount
                                    mediaPlayer.modeAreaFileCount = "(" + AudioListViewModel.getFileURLCount() + ")"; //added by yungi 2013.03.06 for New UX FileCount

                            }
                        }
                        if (isEditMode)
                        {
                            mediaPlayer.setDefaultFocus();  // added by Michael.Kim 2014.02.11 for ITS 224257
                            setBottomButtonDim(!AudioListViewModel.isAnyoneMarked());
                            //itemViewList.currentIndex = index; //removed by aettie 2013.03.24 for touch focus rule
                        }
                    }
                    EngineListener.DisplayOSD(true); //added by Michael.Kim 2013.05.04 for New OSD Implementation
                }//added by junam 2013.04.23 to block mulitple request.
            }
//moved for list focus image 20131029

        }

    }

    // The delegate for section header
    Component
    {
        id: itemViewListSectionDelegate

        /* Section Backgorund */
        Image
        {
            mirror: EngineListenerMain.middleEast
	//{modified by aettie 2013.03.20 for New UX
            height: MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_HEIGHT //changed by junam 2013.08.10 for ITS_KOR_183783
            width: {
                var sectionWidth;
                if(ipodCategoryEdit.visible)
                    sectionWidth = MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_WIDTH
                else if(quickScroll.visible)
                    sectionWidth = MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_SECTION_IMAGE_WIDTH_SHORT
                else sectionWidth = MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_SECTION_IMAGE_WIDTH
                return sectionWidth;                                               
            }
            source: {
                var sectionSrc;
                if(ipodCategoryEdit.visible)
                    sectionSrc = RES.const_APP_MUSIC_PLAYER_URL_IMG_IPOD_SECTION_BACKGROUND
                else if(quickScroll.visible)
                    sectionSrc = RES.const_APP_MUSIC_PLAYER_URL_IMG_FILE_LIST_VIEW_SECTION_BACKGROUND_SHORT
                else sectionSrc = RES.const_APP_MUSIC_PLAYER_URL_IMG_FILE_LIST_VIEW_SECTION_BACKGROUND
                return sectionSrc;                                                
            }
            anchors.left: parent.left
            anchors.leftMargin: isEditMode ? MPC.const_APP_MUSIC_PLAYER_EDIT_MODE_FILE_LIST_VIEW_SECTION_IMAGE_LEFT_MARGIN :
                 (ipodCategoryEdit.visible) ? MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_IMAGE_X : 1
            Text
            {
                anchors.left: parent.left
		//modified by aettie 20130924 for ux fix
                anchors.leftMargin: (ipodCategoryEdit.visible) ? MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_TEXT_X :
                                        isEditMode? MPC.const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_NEW_MARGIN_X_EDIT:
                                                 MPC.const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_NEW_MARGIN_X //MPC.const_APP_MUSIC_PLAYER_FILE_LIST_INDEX_MARGIN_X
                anchors.verticalCenter: parent.verticalCenter

                text: section
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_30_FONT   
                font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR
                color: MPC.const_APP_MUSIC_PLAYER_COLOR_RGB_BLUE_TEXT //20131025 GUI fix
                horizontalAlignment: Text.AlignLeft
	//}modified by aettie 2013.03.20 for New UX
            }
        }
    }

    ListView
    {
        id: ipodCategoryEdit
        snapMode: moving ? ListView.SnapToItem : ListView.NoSnap
        property real contentBottom: contentY + height
        visible: false;
        anchors.fill: root_list
        //anchors.topMargin: MPC.const_APP_MUSIC_PLAYER_LIST_VIEW_TOP_MARGIN //removed by junam 2013.08.10 for ITS_KOR_183783
        //boundsBehavior: Flickable.StopAtBounds
        highlightMoveDuration:1
        highlightFollowsCurrentItem: true

        property bool isDraging: false;
        //property string categoryCueState: "noneActive" //removed by junam dead code
        property int curCat_id: -1
        property int newId: 0
        property int newId_1: 0
        property bool isIpodCategoryEdit: false

        onVisibleChanged:
        {
            EngineListener.isCategoryEditMode = visible  //added by junam 2013.06.24 for ISV_KR_85467
            //{added by junam 2013.08.03 for ITS_KOR_187031
            if(visible)
            {
                mediaPlayer.modeAreaInfoText = "";
                mediaPlayer.modeAreaInfoText_f ="";
                mediaPlayer.modeAreaCategoryIcon = "";
                mediaPlayer.modeAreaCategoryIcon_f = "";
            }
            //}added by junam
        }

        // ITS 236344
        onMovementEnded:
        {
            if (( mediaPlayer.focus_index == LVEnums.FOCUS_MODE_AREA ) && (optionMenuLoader.status != Loader.Ready || optionMenuLoader.item.visible == false))
            {
                mediaPlayer.setDefaultFocus();
            }

            if(!isIpodCategoryEdit)
            {
                var tmp_start_index = indexAt(10, contentY + 10)
                var tmp_end_index = indexAt(10, contentBottom - 10)
                if(!((currentIndex >= tmp_start_index) && (currentIndex <= tmp_end_index)))
                {
                    currentIndex = tmp_start_index
                    if (currentIndex == -1)
                        currentIndex = indexAt(10, contentY + MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_HEIGHT + 10)
                }
            }

            AudioListViewModel.moving = false;
        }

        onMovementStarted:
        {
            AudioListViewModel.moving = true;
        }

        model: ipodEditModel;
        delegate: iPodCategoryDelegate

        clip: true
        focus: true

        section.property: "cat_type"
        section.criteria: ViewSection.FullString;
        section.delegate: itemViewListSectionDelegate;

// modified by Dmitry 15.05.13
        function ipodCategoryEditChangeSelection_onJogClicked(arrow, status) // modified ITS 236905
        {
            if (UIListenerEnum.KEY_STATUS_RELEASED == status)
            {
                switch( arrow )
                {
                    case UIListenerEnum.JOG_CENTER:
                    {
                    // { modified by yongkyun.lee@lge.com  2012.09.05 for:(New UX: music(LGE) # 35
                        if(isIpodCategoryEdit)  //added by junam 2013.03.28 for ISV77657
                        {
                            //ipodCategoryEdit.categoryCueState = "noneActive";//removed by junam dead code
                            isIpodCategoryEdit = false;
                        }//{added by junam 2013.03.28 for ISV77657
                        else
                        {
                            isIpodCategoryEdit = true;
                            //ipodCategoryEdit.categoryCueState = "Active";//removed by junam dead code
                            curCat_id = ipodCategoryEdit.currentIndex;
                        }
                        //}added by junam 2013.03.28

                        jogCenterPressed = false  // ITS 250823
                        break;
                    }
                    case UIListenerEnum.JOG_UP:
                    case UIListenerEnum.JOG_DOWN:
                    {
                        if (timerPressedAndHold.lastPressed == -1)
                        {
                            if (arrow === UIListenerEnum.JOG_UP)
                            {
                                if(isIpodCategoryEdit)
                                {
                                    isIpodCategoryEdit = false;
                                }
                                root_list.lostFocus(UIListenerEnum.JOG_UP);
                            }
                        }
                        else
                        {
                            timerPressedAndHold.stop();
                            if(ipodCategoryEdit.currentIndex >=0 && ipodCategoryEdit.currentIndex < ipodCategoryEdit.count)
                                ipodCategoryEdit.positionViewAtIndex(ipodCategoryEdit.currentIndex, arrow === UIListenerEnum.JOG_UP ? ListView.Beginning : ListView.End)
                            timerPressedAndHold.iterations = 0;
                            timerPressedAndHold.lastPressed = -1;
                        }
                        break;
                    }
                    case UIListenerEnum.JOG_LEFT:
                    case UIListenerEnum.JOG_RIGHT:
                    {
                        break;
                    }
                }
		
            }
            else if (UIListenerEnum.KEY_STATUS_PRESSED == status)
            {
               switch (arrow)
               {
                  case UIListenerEnum.JOG_WHEEL_LEFT:
                  {
                      if (!isIpodCategoryEdit)
                      {
		      //{modified by aettie CCP wheel direction for ME 20131014
                            if (EngineListenerMain.middleEast)
                            {
                                  if (ipodCategoryEdit.currentIndex < ipodCategoryEdit.count - 1)
                                  {
                                      ipodCategoryEdit.currentIndex++;
                                  }
                            }
                            else
                            {
                                  if (ipodCategoryEdit.currentIndex > 0)
                                  {
                                      ipodCategoryEdit.currentIndex--;
                                  }
                            }
                      }
                      else
                      {
                          //ipodCategoryEdit.categoryCueState = "upActive";//removed by junam dead code
                            if (EngineListenerMain.middleEast)
                            {
                                  if (ipodCategoryEdit.currentIndex < ipodCategoryEdit.count - 1)
                                  {
                                      newId = ++ipodCategoryEdit.currentIndex;
                                  }
                            }
                            else
                            {
                                  if (ipodCategoryEdit.currentIndex  > 0)
                                  {
                                      newId = --ipodCategoryEdit.currentIndex;
                                  }
                            }
			    //}modified by aettie CCP wheel direction for ME 20131014
                          ipodEditModel.move(curCat_id, newId, 1);
                          curCat_id = newId;
                          ipodCategoryEdit.currentIndex = curCat_id;

                          for (var i = 0; i < ipodCategoryEdit.count; i++)
                          {
                              if (i < 4)
                              {
                                  ipodEditModel.setProperty(i,"cat_type", "Category")
                                  currentLoaderTab.item.categoryModel.set(i,
                                          {"categoryName": ipodEditModel.get(i).name,
                                          //{removed by junam 2013.07.04 for ITS172937
                                          //"categoryIcon_s": ipodEditModel.get(i).categoryIcon_s,
                                          //"categoryIcon_n":ipodEditModel.get(i).categoryIcon_n,
                                          //"categoryIcon_f": ipodEditModel.get(i).categoryIcon_f,
                                          //"categoryIcon_fp":ipodEditModel.get(i).categoryIcon_fp,
                                          //}removed by junam
                                          "cat_id":ipodEditModel.get(i).cat_id });
                              }
                              else
                              {
                                  ipodEditModel.setProperty(i,"cat_type","More")
                                  currentLoaderTab.item.categoryEtc.set(i-4,
                                          {"itemViewTitle": ipodEditModel.get(i).name,
                                          "cat_id": ipodEditModel.get(i).cat_id});
                              }
                          }
                      }
                      break;
                  }
                  case UIListenerEnum.JOG_WHEEL_RIGHT:
                  {
                      if (!isIpodCategoryEdit)
                      {
		      //{modified by aettie CCP wheel direction for ME 20131014
                            if (EngineListenerMain.middleEast)
                            {
                                  if (ipodCategoryEdit.currentIndex > 0)
                                  {
                                      ipodCategoryEdit.currentIndex--;
                                  }
                            }
                            else
                            {
                                  if (ipodCategoryEdit.currentIndex < ipodCategoryEdit.count - 1)
                                  {
                                      ipodCategoryEdit.currentIndex++;
                                  }
                            }
                      }
                      else
                      {
                          //ipodCategoryEdit.categoryCueState = "downActive";//removed by junam dead code

                            if (EngineListenerMain.middleEast)
                            {
                                  if (ipodCategoryEdit.currentIndex  > 0)
                                  {
                                      newId = --ipodCategoryEdit.currentIndex;
                                  }
                            }
                            else
                            {
                                  if (ipodCategoryEdit.currentIndex < ipodCategoryEdit.count - 1)
                                  {
                                      newId = ++ipodCategoryEdit.currentIndex;
                                  }
                            }
			  //}modified by aettie CCP wheel direction for ME 20131014
                          ipodEditModel.move(curCat_id, newId, 1);
                          curCat_id = newId;
                          ipodCategoryEdit.currentIndex = curCat_id;

                          for (var i = 0; i < ipodCategoryEdit.count; i++)
                          {
                              if (i < 4)
                              {
                                  ipodEditModel.setProperty(i, "cat_type", "Category");
                                  currentLoaderTab.item.categoryModel.set(i,
                                          {"categoryName": ipodEditModel.get(i).name,
                                          //{removed by junam 2013.07.04 for ITS172937
                                          //"categoryIcon_s": ipodEditModel.get(i).categoryIcon_s,
                                          //"categoryIcon_n":ipodEditModel.get(i).categoryIcon_n,
                                          //"categoryIcon_f": ipodEditModel.get(i).categoryIcon_f,
                                          //"categoryIcon_fp":ipodEditModel.get(i).categoryIcon_fp,
                                          //}removed by junam
                                          "cat_id":ipodEditModel.get(i).cat_id });
                              }
                              else
                              {
                                  ipodEditModel.setProperty(i, "cat_type", "More");
                                  currentLoaderTab.item.categoryEtc.set(i-4,
                                          {"itemViewTitle": ipodEditModel.get(i).name,
                                          "cat_id": ipodEditModel.get(i).cat_id});
                              }
                          }
                      }
                      break;
                  }
                  case UIListenerEnum.JOG_CENTER:
                  {
                      jogCenterPressed = true
                      break;
                  }  // ITS 250823

                  default:
                     break;
               }
            }
        }
// modified by Dmitry 15.05.13

        function ipodCategoryEditChangeSelection_onJogDial(arrow, status) // modified ITS 236905
        {
            if (mediaPlayer.focus_index == LVEnums.FOCUS_NONE)
            {
                mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT
            }

            if (timerPressedAndHold.lastPressed != -1)
            {
               if (arrow != UIListenerEnum.JOG_UP && arrow != UIListenerEnum.JOG_DOWN)
                  return
            }

            if ( (UIListenerEnum.KEY_STATUS_PRESSED == status) || (UIListenerEnum.KEY_STATUS_RELEASED == status)) // modified by Dmitry 15.05.13
            {        
                // add by yongkyun.lee@lge.com  2012.09.05 for:(New UX: music(LGE) # 35
                ipodCategoryEditChangeSelection_onJogClicked(arrow, status)
            }
            else if (UIListenerEnum.KEY_STATUS_LONG_PRESSED == status || UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED == status)
            {
                switch( arrow )
                {
                    case UIListenerEnum.JOG_UP:
                    case UIListenerEnum.JOG_DOWN:
                    {
                        if(ipodCategoryEdit.currentIndex < 0)
                            break;

                        if(isIpodCategoryEdit)
                            break;

                        timerPressedAndHold.lastPressed = arrow;
                        timerPressedAndHold.start();
                        break;
                    }
               }
            }
            else if (UIListenerEnum.KEY_STATUS_CANCELED == status)
            {
               switch (arrow)
               {
                  case UIListenerEnum.JOG_UP:
                  case UIListenerEnum.JOG_DOWN:
                  {
                     if (timerPressedAndHold.lastPressed != -1)
                     {
                        timerPressedAndHold.stop();
                        if(ipodCategoryEdit.currentIndex >=0 && ipodCategoryEdit.currentIndex < ipodCategoryEdit.count)
                            ipodCategoryEdit.positionViewAtIndex(ipodCategoryEdit.currentIndex, arrow === UIListenerEnum.JOG_UP ? ListView.Beginning : ListView.End)
                        timerPressedAndHold.iterations = 0;
                        timerPressedAndHold.lastPressed = -1;
                     }
                  }
                  default:
                     break;
               }
            }
        }

        function incrementIndexCE(repeat) // for ipodCategoryEdit
        {
            var nextIndex = currentIndex;
            for(var n = 0; n < repeat; n++ )
            {
                if(nextIndex < count - 1)
                    nextIndex++;
                else if(keyNavigationWraps)
                    nextIndex = 0;
            }
            currentIndex = nextIndex;
        }

        function decrementIndexCE(repeat) // for ipodCategoryEdit
        {
            var nextIndex = currentIndex;
            for(var n = 0; n < repeat; n++ )
            {
                if(nextIndex > 0)
                    nextIndex--;
                else if(keyNavigationWraps)
                    nextIndex = count-1;
            }
            currentIndex = nextIndex;
        }

    property bool draggingOnScrollZoneTop: false

    property bool draggingOnScrollZoneBottom: false

        // added for ISV 92295  // Modified for ITS 196317
        Connections
        {
            target : (/*!popup.visible &&*/ !popup_loader.visible && ipodCategoryEdit.visible ) ?
                          EngineListener : null; // modified by cychoi 2015.06.03 for Audio/Video QML optimization

            onSignalTuneNavigation:
            {
                if (mediaPlayer.focus_index == LVEnums.FOCUS_MODE_AREA)
                {
                    mediaPlayer.setDefaultFocus();
                }
                else if (ipodCategoryEdit.visible)
                {
                    ipodCategoryEdit.ipodCategoryEditChangeSelection_onJogDial(arrow, status)
                }
            }
            onSignalTunePressed:
            {
                if (ipodCategoryEdit.visible && mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)
                    ipodCategoryEdit.ipodCategoryEditChangeSelection_onJogDial(UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_PRESSED)
            }
            onSignalTuneReleased:
            {
                if (ipodCategoryEdit.visible && mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT)
                    ipodCategoryEdit.ipodCategoryEditChangeSelection_onJogDial(UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_RELEASED)
            }
        }

        Connections
        {
            target: visible ? mediaPlayer:null

            onChangeHighlight:
            {
                if (ipodCategoryEdit.visible)
                {
                    ipodCategoryEdit.ipodCategoryEditChangeSelection_onJogDial(arrow, status)
                }
            }
	    // modified by ravikanth 29-06-13 for ITS 0176909
            onInitiateCopyStart:
            {
                if( currentFileOperationState == "Copy")
                {
                    startCopy();
                }
                else if (currentFileOperationState == "CopyAll")
                {
                    startCopyAll();
                }
            }
        }

        VerticalScrollBar
        {
            id : ipod_list_v_scroll //[KOR][ISV][64532][C](aettie.ji)
        //{modified by aettie 2013.03.20 for New UX
           //anchors.top: parent.top
           anchors.verticalCenter: parent.verticalCenter
           anchors.right: parent.right
           anchors.rightMargin: isEditMode? 0 : 8 //added by aettie.ji 2012.12.1 for New UX
           //height: parent.height
           height: 465
        //}modified by aettie 2013.03.20 for New UX
           position: parent.visibleArea.yPosition
           pageSize: parent.visibleArea.heightRatio
           visible: ( pageSize < 1 )
        }

        Component.onCompleted:
        {
           //scrollUpTimer.restart()//removed by junam 2013.06.28 for ITS167419
           ipodCategoryEdit.currentIndex = 0
        }
    }
    /*iPodEditCategory delegate*/
    Component
    {
        id: iPodCategoryDelegate

        Item
        {
            id: iPodCategoryItem

            //height: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_ROW_HEIGHT
            height: MPC.const_APP_MUSIC_PLAYER_LISTVIEW_ITEM_HEIGHT /*92*///modified by aettie 2013.03.20 for New UX
            width: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_AREA_CONTAINER   

            Item
            {
                id: iPodCategoryElement;

                height: parent.height 
                width: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_AREA_CONTAINER
		
            	//modified for list focus image 20131029
		/* Horizontal delimeter line */
                Image
                {
                    id: upLine
                    y: 92
                    width:MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_WIDTH_AREA_CONTAINER
                    source: "/app/share/images/music/tab_list_line.png"
                    //visible: iPodCategoryElement.state == "active" ? true :
                    //            ((index == 0 || index == 4)? false : true)
                }
                Image
                {
                    id: ipodListItemFocused
                    source : "/app/share/images/music/category_f.png"
                    anchors.top: upLine.top
                    anchors.topMargin: -93
                    anchors.bottom: upLine.bottom
                    anchors.bottomMargin: -1
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    visible: (mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT) 
                                                                && ipodCategoryEdit.visible&&(ipodCategoryEdit.currentIndex == index) && !jogCenterPressed  // modified ITS 250823
                }
                Image
                {
                    id: ipodListItemPressed
                    source : "/app/share/images/music/category_p.png"
                    anchors.top: upLine.top
                    anchors.topMargin: -93
                    anchors.bottom: upLine.bottom
                    anchors.bottomMargin: -1
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    visible: iPodCategoryMouseArea.pressed
                             || ( mediaPlayer.focus_index == LVEnums.FOCUS_CONTENT && ipodCategoryEdit.visible && jogCenterPressed && ipodCategoryEdit.currentIndex == index)  // modified ITS 250823
//moved for list focus image 20131029
                }

                Image
                {
                    id: ipodCatHandler //added by aettie.ji 2013.02.27 for NewUX

                    source: "/app/share/images/bt/ico_handler.png"
                    anchors.right: parent.right
                    // { modified by dongjin 2012.09.14 for New UX
                    //anchors.rightMargin: 95;
                    anchors.rightMargin: 113;
                    // } modified by dongjin
                    anchors.verticalCenter: parent.verticalCenter
                    visible : (ipodCategoryEdit.currentIndex != index) || (ipodCategoryEdit.isIpodCategoryEdit == false)//added by junam 2013.05.29 for ISV_KR84003
                }
                //{added by junam 2013.05.29 for ISV_KR84003
                Image
                {
                    //{changed by junam 2013.06.17 for ISV_KR_85465
                    //source: "/app/share/images/music/ico_arrow_u_n.png"
                    source:  (ipodCategoryEdit.currentIndex != 0)  ? "/app/share/images/music/ico_arrow_u_n.png" :  "/app/share/images/music/ico_arrow_u_d.png"
                    //}changed by junam
                    anchors.right: parent.right
                    anchors.rightMargin: 121;
                    anchors.top: parent.top
                    anchors.topMargin:  22
                    //{changed by junam 2013.06.17 for ISV_KR_85465
                    //visible : (ipodCategoryEdit.currentIndex == index) && (ipodCategoryEdit.isIpodCategoryEdit == true) && (ipodCategoryEdit.currentIndex != 0)
                    visible : (ipodCategoryEdit.currentIndex == index) && (ipodCategoryEdit.isIpodCategoryEdit == true)
                    //}changed by junam
                }

                Image
                {
                    //{changed by junam 2013.06.17 for ISV_KR_85465
                    //source: "/app/share/images/music/ico_arrow_d_n.png"
                    source:  (ipodCategoryEdit.currentIndex != 8) ? "/app/share/images/music/ico_arrow_d_n.png" :  "/app/share/images/music/ico_arrow_d_d.png"
                    //}changed by junam
                    anchors.right: parent.right
                    anchors.rightMargin: 121;
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 22
                    //{changed by junam 2013.06.17 for ISV_KR_85465
                    //visible : (ipodCategoryEdit.currentIndex == index) && (ipodCategoryEdit.isIpodCategoryEdit == true) && (ipodCategoryEdit.currentIndex != 8)
                    visible : (ipodCategoryEdit.currentIndex == index) && (ipodCategoryEdit.isIpodCategoryEdit == true)
                    //}changed by junam
                }
                //}added by junam
                Text
                {
                    id:categoryTitle
                    // { modified by yongkyun.lee@lge.com  2012.09.05 for:(New UX: music(LGE) # 35                    
                    anchors.left: parent.left
                    anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_TITLE_MARGIN_X
                    //x: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_SECTION_TEXT_X
                    // } modified by  yongkyun.lee@lge.com   
                    text: qsTranslate( MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT, name ) + LocTrigger.empty
                    //font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB
                    font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDR //modified by aettie.ji 2013.02.27 for NewUX
                    // { modified by yongkyun.lee@lge.com  2012.09.05 for:(New UX: music(LGE) # 35                    
                    font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT   //modified by aettie.ji 2012.11.28 for uxlaunch update
                    // } modified by  yongkyun.lee@lge.com                    
                    color: (ipodCategoryEdit.isIpodCategoryEdit == false || (ipodCategoryEdit.currentIndex == index) && (ipodCategoryEdit.isIpodCategoryEdit == true)) ?  // modified ITS 225960
                               MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY : MPC.const_APP_MUSIC_PLAYER_COLOR_DISABLE_GREY

                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                }
            }

            states:
            [
                State
                {
                    name: "active";
                    PropertyChanges
                    {
                        target: iPodCategoryElement;

                        anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_FILE_LIST_VIEW_SECTION_TEXT_X
                        //y: iPodCategoryMouseArea.mouseY - iPodCategoryItem.height/4; //removed by junam 2013.07.03 for ITS177317

                        z:350 ;
                    }
                }
            ]

            MouseArea
            {
                id: iPodCategoryMouseArea
                anchors.fill: parent
                hoverEnabled: true;
                noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445
                property int nPreviousMouseY; //added by tan to check moving direction

		//{added by aettie 2013.03.21 for touch focus rule
                onClicked:
                {
                    __LOG("Clicked***")
                    ipodCategoryEdit.currentIndex = index;
                    //{added by junam 2013.07.01 for ITS164263
                    if(ipodCategoryEdit.isIpodCategoryEdit)
                    {
                        if(ipodCategoryEdit.curCat_id == index){
                            ipodCategoryEdit.isIpodCategoryEdit = false;    // added for ITS191131
                        }
                        else
                        {
                            ipodCategoryEdit.curCat_id = index;
                        }

                    }
                    //}added by junam
                }
		//}added by aettie 2013.03.21 for touch focus rule
                onPressAndHold:
                {
                    __LOG("PressAndHold***")
                    iPodCategoryItem.state = "active"
                    ipodCategoryEdit.isDraging = true;
                    ipodCategoryEdit.isIpodCategoryEdit = true; //added by junam 2013.07.03 for ITS177317
                    ipodCategoryEdit.currentIndex = index; //added by aettie 2013.03.21 for touch focus rule

                    ipodCategoryEdit.curCat_id = index
                    ipodCategoryEdit.interactive = false;

                    nPreviousMouseY = mouseY;

                    //scrollUpTimer.restart()//added by junam 2013.08.10 for ITS_KOR_183783 // removed for ITS 196158
                }
                onReleased:
                {
                    iPodCategoryItem.state = ""
                    //{added by junam 2013.07.03 for ITS177317
                    if(ipodCategoryEdit.isDraging)
                        ipodCategoryEdit.isIpodCategoryEdit = false;
                    //}added by junam
                    ipodCategoryEdit.isDraging = false;

                    ipodCategoryEdit.interactive = true;

                    ipodCategoryEdit.draggingOnScrollZoneTop = false
                    ipodCategoryEdit.draggingOnScrollZoneBottom = false

                    //scrollUpTimer.stop()//added by junam 2013.08.10 for ITS_KOR_183783 // removed for ITS 196158
                }

                onMousePositionChanged:
                {
                    if( ipodCategoryEdit.isDraging )
                    {
                        var mouseDirectionDown = ((mouseY - iPodCategoryMouseArea.nPreviousMouseY) > 0);
                        iPodCategoryMouseArea.nPreviousMouseY = mouseY;


                        ipodCategoryEdit.draggingOnScrollZoneBottom = ipodCategoryEdit.isDraging &&
                                                                      (iPodCategoryMouseArea.mapToItem(ipodCategoryEdit, iPodCategoryMouseArea.mouseX, iPodCategoryMouseArea.mouseY).y >= ipodCategoryEdit.y + ipodCategoryEdit.height - iPodCategoryItem.height) &&
                                                                      (iPodCategoryMouseArea.mapToItem(ipodCategoryEdit, iPodCategoryMouseArea.mouseX, iPodCategoryMouseArea.mouseY).y <= ipodCategoryEdit.y + ipodCategoryEdit.height)

                        ipodCategoryEdit.draggingOnScrollZoneTop = ipodCategoryEdit.isDraging &&
                                                                   iPodCategoryMouseArea.mapToItem(ipodCategoryEdit, iPodCategoryMouseArea.mouseX, iPodCategoryMouseArea.mouseY).y >= ipodCategoryEdit.y &&
                                                                   iPodCategoryMouseArea.mapToItem(ipodCategoryEdit, iPodCategoryMouseArea.mouseX, iPodCategoryMouseArea.mouseY).y <= ipodCategoryEdit.y + iPodCategoryItem.height
                        //{added for ITS 196158
                        if(ipodCategoryEdit.draggingOnScrollZoneTop && ipodCategoryEdit.currentIndex > 0)
                        {
                            ipodCategoryEdit.positionViewAtIndex(ipodCategoryEdit.currentIndex - 1, ListView.Contain);
                        }
                        if(ipodCategoryEdit.draggingOnScrollZoneBottom && mouseDirectionDown && ipodCategoryEdit.currentIndex < ipodCategoryEdit.count-1 )
                        {
                            ipodCategoryEdit.positionViewAtIndex(ipodCategoryEdit.currentIndex + 1, ListView.Contain);
                        }
                        //}added for ITS 196158

                        ipodCategoryEdit.newId = ipodCategoryEdit.indexAt( mouseX, mouseY + iPodCategoryItem.y )
                        //{added by junam 2013.08.10 for ITS_KOR_183783
                        if(ipodCategoryEdit.newId == -1)
                            ipodCategoryEdit.newId = ipodCategoryEdit.indexAt( mouseX, mouseY + iPodCategoryItem.y + MPC.const_APP_MUSIC_PLAYER_IPOD_EDIT_CATEGORY_SECTION_HEIGHT)
                        //}added by junam
                        if (ipodCategoryEdit.newId != -1 && ipodCategoryEdit.curCat_id!=-1 && ipodCategoryEdit.newId != ipodCategoryEdit.curCat_id)
                        {
                            //Suryanto Tan 2016.01.07: ISV 121838
                            //Edit category drag item up can cause blank screen.
                            //Previous code:
                            //ipodEditModel.move(ipodCategoryEdit.curCat_id, ipodCategoryEdit.curCat_id = ipodCategoryEdit.newId, 1)
                            var from = ipodCategoryEdit.curCat_id;
                            var to = ipodCategoryEdit.newId;
                            ipodCategoryEdit.curCat_id = ipodCategoryEdit.newId
                            if(from > to)
                            {
                                var temp;
                                temp = from;
                                from = to;
                                to = temp;
                            }
                            ipodEditModel.move(from, to, 1)
                            //end of ISV 121838

                            for (var i = 0;i< ipodCategoryEdit.count; i++)
                            {
                                if (i<4)
                                {
                                    ipodEditModel.setProperty(i,"cat_type","Category")
                                    currentLoaderTab.item.categoryModel.set(i,
                                            {"categoryName": ipodEditModel.get(i).name,
                                            //{removed by junam 2013.07.04 for ITS172937
                                            //"categoryIcon_s": ipodEditModel.get(i).categoryIcon_s,
                                            //"categoryIcon_n":ipodEditModel.get(i).categoryIcon_n,
                                            //"categoryIcon_f": ipodEditModel.get(i).categoryIcon_f,
                                            //"categoryIcon_fp":ipodEditModel.get(i).categoryIcon_fp,
                                            //}removed by junam
                                            "cat_id":ipodEditModel.get(i).cat_id });
                                }
                                else
                                {
                                    ipodEditModel.setProperty(i,"cat_type","More")
                                    currentLoaderTab.item.categoryEtc.set(i-4,
                                            {"itemViewTitle": ipodEditModel.get(i).name,
                                            "cat_id": ipodEditModel.get(i).cat_id});
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Image
    {
        id : quickScroll
        source: "/app/share/images/music/quickscroll_bg.png"
        visible: false
        anchors
        {
	//{modified by aettie 2013.03.20 for New UX
            top: parent.top
            topMargin: 22//25 //modified by ys-20130322 new ux music 1.2.8
            right: parent.right
            rightMargin: (isEditMode && !isCopyMode)? MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_RIGHT_MARGIN_EDITMODE
                                                :MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_RIGHT_MARGIN
	//}modified by aettie 2013.03.20 for New UX
        }
        /*********************************************/
        /************** Alphabetic List **************/

        DHAVN_AppMusicPlayer_AlphabeticList
        {
            id: alphabeticList

            anchors
            {
                top: parent.top
                //topMargin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_TOP_MARGIN
                topMargin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ITEM_HEIGHT_BOTTOM_PART // modified by eunhye 2012.08.23 for New UX:Music(LGE) #5,7,8,11,14,17,18
		right: parent.right
                //rightMargin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_RIGHT_MARGIN
                rightMargin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ICON_INDEX_LEFT_MARGIN // modified by eunhye 2012.08.23 for New UX:Music(LGE) #5,7,8,11,14,17,18
            }

            visible:true

            icon_search_left_margin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ICON_SEARCH_LEFT_MARGIN
            icon_index_left_margin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ICON_INDEX_LEFT_MARGIN
            item_width: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_WIDTH
            //{removed by junam 2013.08.20 for quick bar
            //item_height_top_part : countryvariant ? ((countryvariant == 4) ? MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART_MED :
            //                                         MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART_ENG) : MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART;
            //item_height_bottom_part : countryvariant ? ((countryvariant == 4) ? MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART_MED :
            //                                            MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART_ENG) : MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART;
            // }removed by junam
            MouseArea
            {
                id: mouseArea
                //anchors.fill: parent
                // UX change 2013/09/26
                anchors
                {
                    top: parent.top
                    left: parent.left
                }
                noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445

                width: 98
                height: 508
                clip: false


//{changed by junam 2013.05.08 for quick view performance
                onPressed:
                {
                    //modified by jaehwan 2013.10.26 from listInnder to hiddenListInnder for ISV 90617
                    handleQuickScrollEvent(alphabeticList.hiddenListInner.indexAt(15,mouseY), UIListenerEnum.KEY_STATUS_PRESSED) // UX change 2013/09/26
                }
                onPositionChanged:
                {
                    //modified by jaehwan 2013.10.26 from listInnder to hiddenListInnder for ISV 90617
                    handleQuickScrollEvent(alphabeticList.hiddenListInner.indexAt(15,mouseY), UIListenerEnum.KEY_STATUS_PRESSED) // UX change 2013/09/26
                }
                onReleased:
                {
                    //modified by jaehwan 2013.10.26 from listInnder to hiddenListInnder for ISV 90617
                    handleQuickScrollEvent(alphabeticList.hiddenListInner.indexAt(15,mouseY), UIListenerEnum.KEY_STATUS_RELEASED) // UX change 2013/09/26
                }
//}changed by junam
            }
        }

        ListModel
        {
            id: ipodEditModel
        }

        ListModel
        {
            id: copyToJukeboxBtnModel

            property Component  btn_text_style: Component
            {
                Text
                {
                    color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BUTTON_GREY
                    font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT
                }
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_COPY")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed : false // added by wspark 2012.09.25 for sanity 1405
                btn_id: "Copy"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_COPY_ALL") //modified by eugene.seo 2013.01.19 for ISV 69915 
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed : false //  added by yongkyun.lee 20130404 for : ISV 77432
                btn_id: "CopyAll"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_SELEC_CLEAR")
                btn_width: 426
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed : false // added by wspark 2012.09.25 for sanity 1405
                btn_id: "Deselect"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed: false;
                btn_id: "CopyToJB_cancel"
            }
        }

        ListModel
        {
            id: copySelectLocationBtnModel

            property Component  btn_text_style: Component
            {
                Text
                {
                    color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BUTTON_GREY
                    font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT
                }
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_COPY_HERE")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "CopyToHere"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_NEW_FOLDER")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "CreateFolder"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
                btn_width: 426
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "CopyCancel"
            }
        }

        ListModel
        {
            id: moveInJukeboxBtnModel

            property Component  btn_text_style: Component
            {
                Text
                {
                    color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BUTTON_GREY
                    font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT
                }
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_SHORTCUT_MOVE")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "Move"
				is_dimmed: true // added by ravikanth - 12-09-17 - cr 12942
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_MOVE_ALL")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "MoveAll"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_SELEC_CLEAR")
                btn_width: 426
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "Deselect"
				is_dimmed: true // added by ravikanth - 12-09-17 - cr 12942
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed: false;
                btn_id: "Move_cancel"
            }
        }

        ListModel
        {
            id: moveSelectLocationBtnModel

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_MOVE_HERE")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "MoveToHere"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_NEW_FOLDER")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "CreateFolder"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
                btn_width: 426
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "Move_cancel"
            }
        }

        ListModel
        {
            id: deleteInJukeboxBtnModel

            property Component  btn_text_style: Component
            {
                Text
                {
                    color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BUTTON_GREY
                    font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT
                }
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "Delete"
				is_dimmed: true // added by ravikanth - 12-09-17 - cr 12942
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FOLDER_ALL")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed : false //  added by yongkyun.lee 20130404 for : ISV 77432
                btn_id: "DeleteAll"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_SELEC_CLEAR")
                btn_width: 426
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                btn_id: "Deselect"
				is_dimmed: true // added by ravikanth - 12-09-17 - cr 12942
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed: false;
                btn_id: "Delete_cancel"
            }
        }

        ListModel
        {
            id: addToPlaylistBtnModel

            property Component btn_text_style: Component
            {
                Text
                {
                    color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BUTTON_GREY
                    font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT
                }
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_ADD")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed: true;
                btn_id: "Add"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_ADD_ALL")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed: false;
                btn_id: "Add_all"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_SELEC_CLEAR")
                btn_width: 426
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed: true;
                btn_id: "Deselect"
            }

            ListElement
            {
                name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
                btn_width: 427
                icon_n: ""
                icon_p: ""
                bg_image_p: ""
                is_dimmed: false;
                btn_id: "Add_cancel"
            }
        }
    }
    Connections
    {
        target:EngineListenerMain
        onRetranslateUi:
        {
            LocTrigger.retrigger()
            rightButtonArea.retranslateUI( MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT )

            // added by sangmin.seol 2014.08.26 ITS 0246073
            if(!AudioController.isForeground)
                return;

            //{ added by wonseok.heo 2013-11-19 for : ISV 94814
            if(AudioController.PlayerMode == MP.DISC && AudioController.DiscType == MP.MP3_CD) // modified by sangmsin.seol 2014.03.05 ISV 98063
            {
                centerCurrentPlayingItem();
            }
            else // }added by wonseok.heo 2013-11-19 for : ISV 94814
            {
                // modified for ISV, focus not visable on arabic language change
                if(isEditMode)
                {
                    centerCurrentPlayingItem();
                }
                else
                {
                    //{added by junam 2013.12.11 for ITS_CHN_214290
                    if (timerPressedAndHold.lastPressed != -1)
                    {
                        timerPressedAndHold.stop();
                        timerPressedAndHold.iterations = 0;
                        timerPressedAndHold.lastPressed = -1;
                    }
                    //}added by junam
                    AudioListViewModel.requestUpdateListData();

                    // added by sangmin.seol 2014.08.01 ITS 0244522, 0244521 Exceptional case initialize itemViewList.moving on list update
                    if(AudioListViewModel.moving)
                        AudioListViewModel.moving = false;
                }
            }
        }
//added by aettie for ticker stop when DRS on	
        onTickerChanged:
        {
            __LOG("onTickerChanged ticker : " + ticker);
            root_list.scrollingTicker = ticker;
        }
// added by Dmitry 06.11.13 for ITS94041
        onFormatting:
        {
           // modified by Dmitry 07.11.13
           if (AudioController.PlayerMode == MP.JUKEBOX)
              blockKeys = started
        }
    }

    Component.onCompleted:
    {
       blockKeys = false
    }
}
