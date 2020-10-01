import QtQuick 1.0
//import QmlPopUpPlugin 1.0
import ListViewEnums 1.0
import "DHAVN_AppMusicPlayer_General.js" as MPC
import AppEngineQMLConstants 1.0
//import PopUpConstants 1.0 remove by edo.lee 2013.01.26
import AudioControllerEnums 1.0 // modified by ravikanth 16-04-13

import "../video/popUp/DHAVN_MP_PopUp_Constants.js" as EPopUp //added by edo.lee 2013.01.26
import "../video/popUp" // added by edo.lee 2013.01.17

Item {
    id: root
    anchors.fill: parent
// { add by yongkyun.lee@lge.com    2012.10.05 for CR 13484 (New UX: music(LGE) # MP3 File info POPUP
    property string plFolderName: ""
    property string plFileName: ""
    property string plBitRate: ""
    property string plFormat: ""
    property string plCreateDate: ""
// } add by yongkyun.lee@lge.com 
    property int popup_type: -1
    property int popup_type_pre: -1 // add by sslee 2012.06.29 for HMC_DH__SANITY_USB135

    property bool isAll: false
    property int file_count: 0
    property variant file_size:0
    property string popupTitle: ""
    property int playListIndex: -1
    property string replacedFile: ""
    property bool isPlayback: false // added by lssanh 2013.02.05 ISV72352
    property string plName: ""
    property bool skipUpdateData: false
    property bool replaceCopy: false // modified by ravikanth 07-07-13 for ITS 0178185

    property double all_size: 1
    property double use_size: 0
    // modified by ravikanth 21-08-13 for ITS 0185418
    property double capacity_value: use_size / all_size * 100  // modified by ruindmby 2012.08.22 for CR 12454
    property int masterTable_count: 0 // added by jungae 2012.10.10 CR 13753
    property int device_count: 0 // added by jungae 2012.10.10 CR 13753
    property int language_Id : AudioListViewModel.GetLanguage()//add by eunhye 2012.10.29 for No CR
    property int offset_y:0    //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
    
    signal popupClosed();
    signal showKeypad(string title);
    signal signalShowPopup(int type);
    signal deselectItem(); //add by eunhye 2012.07.02 for USB_115

    function closePopup()
    {
        __LOG("closePopup()");
        file_count = 0;
        file_size = 0;
        popupTitle = "";
        playListIndex = -1;
        use_size = 0;
        plName = "";
        skipUpdateData = false;
        popup_list.bIsNoActiv = false;

        messageModel.clear();
        buttonModel.clear();
        listModel.clear();

        popup_type = -1;
        popup_text.visible = false;
        popup_progress.visible = false;
        popup_icon_progress.visible = false; //[KOR][ITS][170734][comment] (aettie.ji)
        popup_dimmed.visible = false;
        popup_list.visible = false;
        property_text.visible = false; // added by edo 2013.1.19

        // { added by dongjin 2013.02.25 for ISV 73879
        if (timer.running)
        {
            timer.stop()
        }
        // } added by dongjin
        popupClosed();
    }

    function setDefaultFocus(arrow)
    {
        popup_text.setDefaultFocus(arrow)
        popup_progress.setDefaultFocus(arrow);
        popup_list.setDefaultFocus(arrow);
        return LVEnums.FOCUS_POPUP
    }

    // modified for ITS 0190394
    function resetOnPopUp() //modified by sangmin.seol ITS 0239925 change function name.
    {
        if( (root.popup_type == LVEnums.POPUP_TYPE_COPY_ALL)
                || (root.popup_type == LVEnums.POPUP_TYPE_DELETE && root.isAll) )
        {
            mediaPlayer.resetSelectAllItems();
        }
        else if(root.popup_type == LVEnums.POPUP_TYPE_COPYING || root.popup_type == LVEnums.POPUP_TYPE_DELETING )
        {
            AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION, 3); // to cancel edit mode
        }
        else if(root.popup_type == LVEnums.POPUP_TYPE_CAPACITY_ERROR ) // modified for ITS 0190530
        {
            AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_CAPACITY_ERROR_MANAGE, 0);
        }
        closePopup();
    }

    function __LOG(textLog)
    {
        EngineListenerMain.qmlLog("[MP] DHAVN_AppMediaPlayer_MP_PopUp.qml: " + textLog);
    }

    MouseArea
    {
        anchors.fill: parent
        beepEnabled: false // added by jungae 2013.01.04 for ISV64387
        noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445
    }

    ListModel
    {
        id: messageModel
    }

    ListModel
    {
        id: buttonModel
    }

    ListModel
    {
        id: listModel
    }

    ListModel
    {
        id: listModelData
    }

    function retranslateUi()
    {
        switch (popup_type)
        {
            case LVEnums.POPUP_TYPE_COPY:
            case LVEnums.POPUP_TYPE_DELETE:
            case LVEnums.POPUP_TYPE_EDIT_MODE:
            case LVEnums.POPUP_CREATE_FOLDER_INCORRECT_CHARACTER:
            case LVEnums.POPUP_CREATE_FOLDER_EMPTY_NAME:
            case LVEnums.POPUP_CREATE_FOLDER_NAME_IS_TOO_LONG:
            case LVEnums.POPUP_FOLDER_ALREADY_EXIST:
            case LVEnums.POPUP_FILE_ALREADY_EXIST:
            case LVEnums.POPUP_TYPE_CAPACITY_ERROR:
            case LVEnums.POPUP_TYPE_UNAVAILABLE_FILE:
            case LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE: //added by junam 2013.08.29 for ITS_KOR_185043
            case LVEnums.POPUP_TYPE_CORRUPT_FILE:
            case LVEnums.POPUP_TYPE_JUKEBOX_ERROR:
            case LVEnums.POPUP_TYPE_REPLACE:
            case LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION:
            case LVEnums.POPUP_TYPE_CANCEL_MOVE_QUESTION:
            case LVEnums.POPUP_TYPE_PL_FIRST_TIME: // added by eugene.seo 2013.01.08 for showing add to jukebox popup
            case LVEnums.POPUP_TYPE_PL_CREATE_NEW:
            case LVEnums.POPUP_TYPE_PL_ADD_ALL_FILES:
            case LVEnums.POPUP_QUICK_PLAYLIST_DELETE:
            case LVEnums.POPUP_QUICK_PLAYLIST_FILE_DELETE:
            case LVEnums.POPUP_QUICK_FOLDER_DELETE:
            case LVEnums.POPUP_QUICK_FILE_DELETE:
            case LVEnums.POPUP_TYPE_CLEAR_JUKEBOX:
            case LVEnums.POPUP_TYPE_TIP_ADD_PLAYLIST:
            case LVEnums.POPUP_TYPE_FOLDER_IS_USED:
            case LVEnums.POPUP_TYPE_FILE_IS_USED:
            case LVEnums.POPUP_TYPE_NO_MUSIC_FILES://Added by Alexey Edelev 2012.09.06. CR 9413
            case LVEnums.POPUP_TYPE_DETAIL_FILE_INFO:// added by yongkyun.lee@lge.com    2012.10.05 for CR 13484 (New UX: music(LGE) # MP3 File info POPUP
            case LVEnums.POPUP_TYPE_IPOD_AVAILABLE_FILES_INFO: // added by jungae 2012.10.10 CR 13753
            case LVEnums.POPUP_TYPE_MLT_NO_MATCH_FOUND: // added by dongjin 2013.02.04 for ISV 70377
            case LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM: // modified by ravikanth 16-04-13
            case LVEnums.POPUP_TYPE_FILE_CANNOT_DELETE: // modified by ravikanth 27-04-13
            case LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM: // modified by ravikanth 21-07-13 for copy cancel confirm on delete
            case LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_CLEAR_JUKEBOX:
            case LVEnums.POPUP_TYPE_BT_DURING_CALL:		//added by hyochang.ryu 20130731
            case LVEnums.POPUP_TYPE_HIGH_TEMPERATURE: // added by cychoi 2014.04.09 for HW Event DV2-1 1403-00067 HIGH TEMPERATURE handling
            case LVEnums.POPUP_TYPE_NOT_SUPPORTED: // added by cychoi 2015.01.20 for ITS 250091
            case LVEnums.POPUP_TYPE_UNAVAILABLE_FORMAT: // added by cychoi 2015.06.03 for Audio/Video QML optimization
            case LVEnums.POPUP_TYPE_ALL_UNAVAILABLE_FORMAT: // added by cychoi 2015.06.03 for Audio/Video QML optimization
            {
                popup_text.retranslateUI(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT);
                break;
            }
	    //[KOR][ITS][170734][comment] (aettie.ji)
            case LVEnums.POPUP_TYPE_COPYING:
            {
                popup_icon_progress.retranslateUI(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT);
                break;
            }
            case LVEnums.POPUP_TYPE_MOVING:
            case LVEnums.POPUP_TYPE_DELETING:
            case LVEnums.POPUP_TYPE_CAPACITY_VIEW:
            {
                popup_progress.retranslateUI(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT);
                break;
            }

            case LVEnums.POPUP_TYPE_COPY_COMPLETE:
            case LVEnums.POPUP_TYPE_MOVE_COMPLETE:
            case LVEnums.POPUP_TYPE_DELETE_COMPLETE:
            case LVEnums.POPUP_TYPE_PL_ADD_COMPLETE:
            case LVEnums.POPUP_TYPE_COPY_CANCELED:
            case LVEnums.POPUP_TYPE_MOVE_CANCELED:
            case LVEnums.POPUP_TYPE_IPOD_INDEXING: //added by junam 2012.08.07 for CR 12811
            case LVEnums.POPUP_TYPE_LOADING_DATA: //add by lssanh 2012.09.10 for CR9362
            case LVEnums.POPUP_TYPE_FORMATING: //added by lssanh 2012.09.12 for CR13482
            case LVEnums.POPUP_TYPE_FORMAT_COMPLETE: //added by lssanh 2012.09.12 for CR13482
            case LVEnums.POPUP_TYPE_DELETE_INCOMPLETE: // modified by ravikanth 21.06.13 for ITS 0174571
            {
                popup_dimmed.retranslateUI(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT);
                break;
            }

            case LVEnums.POPUP_TYPE_RENAME:
            case LVEnums.POPUP_TYPE_PL_CHOOSE_PLAYLIST:
            {
                popup_list.retranslateUI(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT);
                break;
            }
        }
    }

    onPopup_typeChanged:
    {
        if (root.popup_type == -1)
            return;

        ignoreTimer.start(); //added by junam 2014.01.02 for ITS_ME_217327
        messageModel.clear();
        buttonModel.clear();
        listModel.clear();
        popup_progress.visible = false; // added by sangmin.seol 2014.06.10 ITS 0239925
        popup_icon_progress.visible = false; // added by sangmin.seol 2014.06.10 ITS 0239925 intiailize copy popup progressbar

        switch ( root.popup_type )
        {
            case LVEnums.POPUP_TYPE_COPY:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_COPY_LOCATION_INFO") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                //popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_COPY_FILE");  //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_COPY_ALL:
            {
	    	// modified for ITS 0192676
                if(popup_dimmed.visible)
                {
                    popup_dimmed.visible = false;
                    timer.running = false;
                }
	    	// comment removed by ravikanth for 19.06.13 SMOKE_TC 7 & SANITY_CM_AK347
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_POPUP_COPY_ALL") } );  //deleted by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                //messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_COPY_CANCEL_INFO") } );  //added by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "Id_0" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_NO"), "btn_id": "Id_1" } );
                //popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_COPY_ALL"); //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_MOVE:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_SELECT_LOCATION_TO_MOVE") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                //popup_text.icon_title = EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_MOVE_ALL:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_POPUP_MOVE_ALL") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"), "btn_id": "Id_1" } );
               // popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_MOVE_ALL"); //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_DELETE:
            {
	    	// modified by ravikanth 25-08-13 for ITS 0184119 
                if (root.isAll)
                {
		    // modified for ITS 0192676
                    if(popup_dimmed.visible)
                    {
                        popup_dimmed.visible = false;
                        timer.running = false;
                    }
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FILES_IN_LIST") } );
                    buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "Id_0" } );
                }
                else
                {
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETE_SELECTED_CONFIRMATION") } );
                    buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "Id_2" } );
                }
		// modified by ravikanth 16-07-13 for ITS 0179867 & 0179865. changes button strings
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_NO"), "btn_id": "Id_1" } );
                //popup_text.title = QT_TR_NOOP("STR_MEDIA_SHORTCUT_DELETE"); //deleted by aettie 2013.03.24 for ISV 75584
                popup_text.visible = true;
                break;
            }
// { add by yongkyun.lee@lge.com    2012.10.05 for CR 13484 (New UX: music(LGE) # MP3 File info POPUP
            case LVEnums.POPUP_TYPE_DETAIL_FILE_INFO:
            {               

		// { changed by junam 2012.12.17 for CR15426
		//if (plFormat != "CDA")
                if (plFormat != "CDA" && plFolderName.length ) //} changed by junam
                {
                    // { modified by changjin 2012.12.10 for CR 16364
                    //messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_FOLDERNAME"),
                    //                        "arg1" : EngineListener.makeElidedString( plFolderName, "HDR", 32, 780) } );
                    messageModel.append( { "name": QT_TR_NOOP("STR_MEDIA_FOLDERNAME"),
                                        "value" : EngineListener.getLastPathOfString(plFolderName) } ); //modified by aettie.ji for ISV 69107
                                        //"value" : EngineListener.makeElidedString( EngineListener.getLastPathOfString(plFolderName), "HDR", 32, 780) } );
                    // } modified by changjin 2012.12.10
                }
                if(plFileName.length) // added by junam 2012.12.17 for CR15426
                {
                    // } modified by eunhye 2012.12.06 for CR15959
                    messageModel.append( { "name": QT_TR_NOOP("STR_MEDIA_FILENAME"),
                                        "value" : plFileName} ); //modified by aettie.ji for ISV 69107
                                        //"value" : EngineListener.makeElidedString(plFileName, "HDR", 32, 780) } );
                    // } added by  yongkyun.lee
                }

                messageModel.append( { "name": QT_TR_NOOP("STR_MEDIA_BITRATE"),
                                        "value" : plBitRate } );
                messageModel.append( { "name": QT_TR_NOOP("STR_MEDIA_FORMAT"),
                                        "value" : plFormat} );
                messageModel.append( { "name": QT_TR_NOOP("STR_MEDIA_CREATEDATE"),
                                        "value" : plCreateDate } );

                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                //property_text.title = QT_TR_NOOP("STR_MEDIA_FILEINFORMATION"); remove by edo.lee 2013.01.19
                property_text.visible = true;

                break;
            }
// } add by yongkyun.lee@lge.com 
            case LVEnums.POPUP_TYPE_CLEAR_JUKEBOX:
            {
	    //[EU][ITS][172934][ minor](aettie.ji)
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETE_JUKEBOX_ALL") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "Id_0" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_NO"), "btn_id": "Id_1" } );
                //popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FOLDER_ALL"); //deleted by aettie 2031.04.01 ISV 78226
                //popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_CLEAR_JUKEBOX"); // modify by eunhye 2012.12.26 for ISV 64014
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_EDIT_MODE:
            {
                messageModel.append( {"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_EDIT_MODE") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                //popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_TIP"); //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }
            case LVEnums.POPUP_TYPE_TIP_ADD_PLAYLIST:
            {
                messageModel.append( {"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_TIP_ADD_PLAYLIST") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                //popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_TIP"); //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }
            case LVEnums.POPUP_CREATE_FOLDER_INCORRECT_CHARACTER:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_INCORRECT_NAME") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId" } );
              //  popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_CREATE_FOLDER_EMPTY_NAME:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_ENTER_FOLDERNAME") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId" } );
               // popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_CREATE_FOLDER_NAME_IS_TOO_LONG:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_LONG_NAME") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId" } );
            //    popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_FOLDER_ALREADY_EXIST:
            case LVEnums.POPUP_FILE_ALREADY_EXIST:
            {
                if (root.popup_type == LVEnums.POPUP_FOLDER_ALREADY_EXIST)
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FOLDER_NAME_USED") } );
                else
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_NAME_EXIST") } );

                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId" } );
                //{ added by yongkyun.lee 20130320 for : ISV 76742
                //popup_text.title = " ";
               // popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                //} added by yongkyun.lee 20130320                
                //popup_text.icon_title = EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

          case LVEnums.POPUP_TYPE_CAPACITY_ERROR:
            {
                // modified by ruindmby 2012.09.26 for CR#11543
                var capacity = Math.round(AudioListViewModel.RemainedCapacity() * 100) / 100
		// { modified by ravikanth for 27.08.13 ITS 0175115, ITS 186712
                if(capacity < 1024) // 1024 = 1GB
                {
                    if(file_size < 1024)
                    {
                        messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_NO_FREE_SPACE"),
                                            "arguments": [{"arg1" : file_count}, {"arg1" : file_size }, {"arg1": capacity}] });
                    }
                    else
                    {
                        messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_NO_FREE_SPACE_COPYSIZE_GB"),
                                            "arguments": [{"arg1" : file_count}, {"arg1" : ( Math.round((file_size/1024) * 100) / 100) }, {"arg1": capacity}] });
                    }

                }
                else
                {
                    var capacityGB = Math.round((AudioListViewModel.RemainedCapacity()/1024) * 100) / 100
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_NO_FREE_SPACE_GB"),
                                        "arguments": [{"arg1" : file_count}, {"arg1" : ( Math.round((file_size/1024) * 100) / 100) }, {"arg1": capacityGB}] });
                }
		// } modified by ravikanth for 20.06.13 ITS 0175115

                // modified by ruindmby 2012.09.26 for CR#11543
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "CapacityOk" } );
                //buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_FILEMANAGER"), "btn_id": "ManageJB" } ); // removed by Dmitry 02.08.13 for new spec
                //popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_UNAVAILABLE_FILE:
            case LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE: //added by junam 2013.08.29 for ITS_KOR_185043
            case LVEnums.POPUP_TYPE_UNAVAILABLE_FORMAT: // added by cychoi 2015.06.03 for Audio/Video QML optimization
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_UNAVAILABLE_FILE") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId"   } );
                //popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true ;
                break;
            }
//Added by Alexey Edelev 2012.09.06. CR 9413
//{
            case LVEnums.POPUP_TYPE_NO_MUSIC_FILES:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_NO_MUSIC_FILES") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId" } );
                //popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                timer.running = true; // added by cychoi 2015.06.03 for Audio/Video QML optimization
                popup_text.visible = true;
                break;
            }
//}
//Added by Alexey Edelev 2012.09.06. CR 9413

            case LVEnums.POPUP_TYPE_CORRUPT_FILE:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_ERROR_CORRUPTED") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId" } );
                //popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                AudioListViewModel.operation == LVEnums.OPERATION_NONE // added by eugene.seo 2013.02.01 for option menu after usb removed during jukebox copying
                corruptFileTimer.running = true; //added by yungi 2013.2.18 for ISV 72964
                break;
            }

            case LVEnums.POPUP_TYPE_JUKEBOX_ERROR:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_ERROR_JUKEBOX") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId" } );
               // popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_REPLACE:
            {
                messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_REPLACE"),
                                      "arg1": root.replacedFile });
                // { added by lssanh 2013.02.05 ISV72352
                /* removed by eugene.seo 2013.06.10
                if (isPlayback == true)
                {
                   buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"),           "btn_id": "Id_0" });
                   buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_CANCEL_BUTTON"),     "btn_id": "Id_3" });
                }
                else
                {               
                */
                // } added by lssanh 2013.02.05 ISV72352
                   buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"),           "btn_id": "Id_0" });
		   // modified by ravikanth 07-07-13 for ITS 0178184
                if(AudioListViewModel.currentCopyReplaceCount() == 1)
                {

                    buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_ALL"), "btn_id": "Id_1" , "is_dimmed": true });
                }
                else
                {
                    buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_ALL"), "btn_id": "Id_1" , "is_dimmed": false });
                }
                   buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_NO"),            "btn_id": "Id_2" });
                   buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_CANCEL_BUTTON"),     "btn_id": "Id_3" });
                //} //added by lssanh 2013.02.05 ISV72352
                popup_text.icon_title = EPopUp.NONE_ICON;

               // if (AudioListViewModel.operation == LVEnums.OPERATION_COPY) //deleted by aettie 2031.04.01 ISV 78226
                //    popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_COPY_FILES");
               // else
               //     popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_MOVE_FILES");

                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_CANCEL_MOVE_QUESTION:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_CONFIRMATION") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "Id_0" } ); // modified by eugene.seo 2013.06.17
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_MOVE_CONTINUE"), "btn_id": "Id_1" } );
               // popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_MOVE_TITLE"); //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_CONFIRMATION") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "Id_0" } ); // modified by eugene.seo 2013.06.17
		// modified by ravikanth 07-07-13 for ITS 0178185
                if(!replaceCopy)
                {
                    // modified by ravikanth 24-07-13 for ITS 0181565 change string from Continue_Copy to No
                    // buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_CONTINUE"), "btn_id": "Id_1" } );
                    buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_NO"), "btn_id": "Id_1" } );
                }
                else
                {
                    // modified by ravikanth 24-07-13 for ITS 0181565 change string from Continue_Copy to No
                    // buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_CONTINUE"), "btn_id": "Id_2" } );
                    buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_NO"), "btn_id": "Id_2" } );
                }
           //     popup_text.title = QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_TITLE"); //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_QUICK_FOLDER_DELETE:
            case LVEnums.POPUP_QUICK_FILE_DELETE:
            case LVEnums.POPUP_QUICK_PLAYLIST_DELETE:
            case LVEnums.POPUP_QUICK_PLAYLIST_FILE_DELETE:
            {
	    	// modified by ravikanth 14-08-13
                popup_dimmed.visible = false;
                if (root.popup_type == LVEnums.POPUP_QUICK_FOLDER_DELETE)
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FOLDER_CONFIRMATION") } );
                else if (root.popup_type == LVEnums.POPUP_QUICK_PLAYLIST_DELETE)
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_POPUP_DELETE_PLAYLIST") } );
                else
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETE_SELECTED_CONFIRMATION") } );

                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"), "btn_id": "Id_1" } );
                popup_text.icon_title = EPopUp.NONE_ICON; 
                //popup_text.title = QT_TR_NOOP("STR_MEDIA_SHORTCUT_DELETE");//deleted by aettie 2013.03.24 for ISV 75584
                popup_text.visible = true;
                break;
            }

	    // { added by eugene.seo 2013.01.08 for showing add to jukebox popup
	    case LVEnums.POPUP_TYPE_PL_FIRST_TIME: 
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_SELECT_AND_SAVE") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId" } );
               // popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }
	    // } added by eugene.seo 2013.01.08 for showing add to jukebox popup
	    
            case LVEnums.POPUP_TYPE_PL_CREATE_NEW:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_CREATE_PLAYLIST") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "new_pl_ok" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_CANCEL_BUTTON"), "btn_id": "new_pl_cancel" } );
             //   popup_text.title = QT_TR_NOOP("STR_MEDIA_NEW_PLAYLIST"); //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_PL_ADD_ALL_FILES:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_POPUP_ADD_ALL_FILE") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "add_all_ok" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_CANCEL_BUTTON"), "btn_id": "add_all_cancel" } );
         //       popup_text.title = QT_TR_NOOP("STR_MEDIA_ADD_TO_PLAYLIST"); //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_COPYING:
            {
	    //[KOR][ITS][170734][comment] (aettie.ji)
              /*  popup_progress.progressCur = 0 // added by wspark 2012.12.18 for ISV65071

                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILES_COPYING"),
                                       "arg1": file_count } );
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_PROGRESSING"),
                                       "arg1":  (popup_progress.progressCur + "%") } ); // added by wspark 2012.12.18 for ISV65071
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"), "btn_id": "CancelId" } );
                popup_progress.title = "";
                popup_progress.visible = true;
                break;*/

                popup_icon_progress.progressCur_s = 0 
                if(AudioListViewModel.isCopyAll() == true)
                {
                    messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_ALL_FILES_COPYING")});
                }
                else
                {
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_COPYING_FORMATTED"),
                                        "arg1": file_count } );
                }
		// modified by ravikanth 27-07-13 for copy index and count display, ITS 0181307 
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_COPY_PROGRESSING"),
                                      // "arg1":  (popup_progress.progressCur + "%") } );
                                    "arguments":[{ "arg1" : ( popup_icon_progress.progressCur_s + "%") },
                                               { "arg1" : 0 },
                                               { "arg1" : 0 }]} );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"), "btn_id": "CancelId" } );
                popup_icon_progress.visible = true;
                break;            
             }

            case LVEnums.POPUP_TYPE_MOVING:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILES_MOVING"),
                                       "arg1": file_count } );
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_PROGRESSING"),
                                       "arg1": popup_progress.progressCur } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"), "btn_id": "CancelId" } );
                popup_progress.title = "";
                popup_progress.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_DELETING:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_DELETE"),
                                       "arg1": file_count } );
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_PROGRESSING"),
                                       "arg1": ( popup_progress.progressCur + "%" )} ); // modified by ravikanth 14-08-13
                //buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"), "btn_id": "CancelId" } ); // modified by ravikanth 10.09.13 for ITS 0174577, 0187211
                popup_progress.title = "";
                popup_progress.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_CAPACITY_VIEW:
            {	
                // { modified by eugene.seo 2013.06.05
		// modified by ravikanth 21-08-13 for ITS 0185418
                var allSize =  parseFloat(root.all_size / 1024 ).toFixed(2);
                var capacity_value =  parseFloat(root.capacity_value).toFixed(2);
                capacity_value = (capacity_value > 100) ? 100 : capacity_value
                if(root.use_size < 1024)
                {
                    var useSize =  parseFloat(root.use_size).toFixed(2);
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CAPACITY_PERCENTAGE_MB"),
                                    arguments:[{ "arg1" : capacity_value }, // modified by Dmitry 28.05.13
                                               { "arg1" : useSize },
                                               { "arg1" : allSize } ] } );
                }
                else 
                {
                    var useSize = parseFloat(root.use_size / 1024).toFixed(2);
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CAPACITY_PERCENTAGE"),
                                    arguments:[{ "arg1" : capacity_value }, // modified by Dmitry 28.05.13
                                               { "arg1" : useSize },
                                               { "arg1" : allSize } ] } );
                }
                // } modified by eugene.seo 2013.06.05
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );

                popup_progress.progressCur = allSize ? capacity_value : 100;
                popup_progress.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_PL_ADD_COMPLETE:
            {
                /* Dimmed popup doesn't support arguments in msg text.
                 * Once it will be fixed, following line should be used */
                //messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_ADDED_TO_PLAYLIST"), "arg1": root.plName });

                if (language_Id == 2 )//modify by eunhye 2012.10.29 for No CR
                //if (AudioListViewModel.GetLanguage() == 2)
                {
                    messageModel.append({ "msg": root.plName });
                    messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_ADDED_TO_PLAYLIST") });
                }
                else
                {
                    messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_ADDED_TO_PLAYLIST") });
                    messageModel.append({ "msg": root.plName });
                }

                root.skipUpdateData = true;
                popup_dimmed.visible = true;
                timer.running = true;
                break;
            }

            case LVEnums.POPUP_TYPE_COPY_COMPLETE:
            case LVEnums.POPUP_TYPE_MOVE_COMPLETE:
            case LVEnums.POPUP_TYPE_DELETE_COMPLETE:
            {
	    // { modified by ravikanth 22-04-13
                if (root.popup_type == LVEnums.POPUP_TYPE_COPY_COMPLETE)
                {
                    if(AudioListViewModel.getSkipFileCount() == 0)
                        messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_COPY_COMPLETED") } );
                    else
                        messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_COPY_COMPLETED_PARTIAL"),
                                            arguments:[{ "arg1" :  ( AudioListViewModel.getCopyFileCount() - AudioListViewModel.getSkipFileCount() ) },
                                                       { "arg1" : AudioListViewModel.getCopyFileCount() }]} ); // modified by ravikanth 09-07-13 for SMOKE localization string change                   
                    //no need to update after copy finished.
                    root.skipUpdateData = true; //added by junam 2013.06.03 for ISV83151
                }
		// } modified by ravikanth 22-04-13
                else if (root.popup_type == LVEnums.POPUP_TYPE_MOVE_COMPLETE)
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_MOVE_COMPLETED") } );
                else
                {
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETE_COMPLETED") } );
                    root.skipUpdateData = true; // added by sangmin.seol for ITS-0209339
                }

                if (AudioListViewModel.operation == LVEnums.OPERATION_CLEAR)
                {
                    EngineListener.notifyFormatJukeboxEnd();
                }

                popup_dimmed.visible = true;
                timer.running = true;
                break;
            }

            case LVEnums.POPUP_TYPE_COPY_CANCELED:
            case LVEnums.POPUP_TYPE_MOVE_CANCELED:
            {
                if (root.popup_type == LVEnums.POPUP_TYPE_COPY_CANCELED)
                    messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_CANCELLED") });
                else
                    messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_MOVE_CANCELED") });

                popup_dimmed.visible = true;
                root.skipUpdateData = true; // changes for ISV 91480
                timer.running = true;
		// changes for ISV 89264
                //EngineListener.setCopyToJukeboxStatus(false, 0) // modified by eugene.seo 2013.05.29
                AudioListViewModel.operation = LVEnums.OPERATION_NONE // added by eugene.seo 2013.02.01 for option menu after usb removed during jukebox copying
                break;
            }
            //{added by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
            case LVEnums.POPUP_TYPE_COPY_CANCEL_INFO:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_COPY_CANCEL_INFO") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"), "btn_id": "Id_1" } );
               // popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;

                break;
            }
            //}added by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
            case LVEnums.POPUP_TYPE_RENAME:
            {
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL") ,
                                      "btn_id": "CancelId" } );
		// { changed by junam 2012.12.17 for CR16785
                if (AudioListViewModel.getCategoryState() != 2 )//LVEnums.PLAYLIST_DEPTH_1 TODO add enum later
                    listModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CHANGE_NAME"), "index": 0 } );      
	    	// } changed by junam
                listModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETE"), "index": 1 } );
                // { modified by junggil 2012.08.31 for NEW UX modified to display correctly about lengthy file
                //popup_list.title = root.popupTitle;
                popup_list.title =  EngineListener.makeElidedString(root.popupTitle, "DH_HDR", 32, 980);
                // } modified by junggil
                popup_list.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_FOLDER_IS_USED:
            case LVEnums.POPUP_TYPE_FILE_IS_USED:
            {
                if (root.popup_type == LVEnums.POPUP_TYPE_FOLDER_IS_USED)
                    messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANNOT_CHANGE_FOLDER_NAME") });
                else
                    messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANNOT_CHANGE_FILENAME") });

                buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" });

                //{ added by yongkyun.lee 20130320 for : ISV 76742
                //popup_text.title = " ";
                //popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                //} added by yongkyun.lee 20130320                
                //popup_text.icon_title = EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                popup_text.setDefaultFocus(UIListenerEnum.JOG_DOWN);
                break;
            }

            case LVEnums.POPUP_TYPE_PL_CHOOSE_PLAYLIST:
            {
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_NEW_PLAYLIST"), "btn_id": "new_pl" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_CANCEL_BUTTON"), "btn_id": "choose_cancel" } );
                popup_list.title = QT_TR_NOOP("STR_MEDIA_CHOOSE_PLAYLIST");
                popup_list.bIsNoActiv = true;
                AudioListViewModel.updatePopupList();
                popup_list.visible = true;
                break;
            }

            case LVEnums.POPUP_TYPE_GRACENOTE_INDEXING:
            {
               messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_GRACENOTE_INDEXING") });
               popup_dimmed.visible = true;
               timer.running = true;
               break;
            }
	    //{added by junam 2012.08.07 for CR 12811
            case LVEnums.POPUP_TYPE_IPOD_INDEXING:
            {
               // { modified by jungae 2012.11.05, No CR, reflect the modified UI scenario.
               // messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_GRACENOTE_INDEXING") }); 
               messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_IPOD_INDEXING") });
               // } modified by jungae 2012.11.05, No CR, reflect the modified UI scenario.
               popup_dimmed.visible = true;
               //popup_dimmed.bHideByTimer = false;
               timer.running = true; // added by kihyung 2013.4.7
               break;
            }
	    //}added by junam
	    // { added by jungae 2012.10.10 for CR 13753
            case LVEnums.POPUP_TYPE_IPOD_AVAILABLE_FILES_INFO:
            {
               messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_IPOD_AVAILABLE_FILES"),
                                   "arguments": [{"arg1" : root.device_count}, {"arg1" : root.masterTable_count}]});
               //popup_text.icon_title = EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226
               //{ added by yongkyun.lee 20130320 for : ISV 76742
               //popup_text.title = " ";
               //popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
               //} added by yongkyun.lee 20130320                
               popup_text.visible = true;
               timer.running = true;
               break;
            }
	    // } added by jungae

// { add by lssanh 2012.09.10 for CR9362
            case LVEnums.POPUP_TYPE_LOADING_DATA:
            {
               messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_LOADING_DATA") });
               popup_dimmed.visible = true;
               // modified by minho 20120917
               // { for CR9362
               // timer.interval = 5000;
               // timer.running = true;

                popup_dimmed.bHideByTimer = false;
               // } modified by minho
               break;
            }
// } add by lssanh 2012.09.10 for CR9362

// { added by lssanh 2012.09.12 for CR13482
            case LVEnums.POPUP_TYPE_FORMATING:
            {
               messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_FORMATTING") });
               popup_dimmed.visible = true;
               popup_dimmed.bHideByTimer = false;
               EngineListener.notifyFormatJukeboxBegin();
               break;
            }

            case LVEnums.POPUP_TYPE_FORMAT_COMPLETE:
            {
               messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_FORMAT_COMPLETED") });
               popup_dimmed.visible = true;
               timer.running = true;
               EngineListener.notifyFormatJukeboxEnd();
               break;
            }
// } added by lssanh 2012.09.12 for CR13482

            // { added by dongjin 2013.02.04 for ISV 70377
            case LVEnums.POPUP_TYPE_MLT_NO_MATCH_FOUND:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_NO_MATCH_FOUND") } );
                buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" });
                //{ added by yongkyun.lee 20130320 for : ISV 76742
                //popup_text.title = " ";
                // popup_text.title = ""; //deleted by aettie 2031.04.01 ISV 78226
                //} added by yongkyun.lee 20130320                
                //popup_text.icon_title = EPopUp.WARNING_ICON; //deleted by aettie 2031.04.01 ISV 78226
                popup_text.visible = true;
                // timer.running = true; // removed by kihyung 2013.06.18 for ITS 174235
                break;
            }
            // } added by dongjin
	    // { modified by ravikanth 16-04-13
            case LVEnums.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_CANCEL_COPY_TO_JUKEBOX") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "cancel_copy" } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_NO"), "btn_id": "Id_1" } );
                popup_text.visible = true;
                break;
            }
	    // } modified by ravikanth 16-04-13
	    // { modified by ravikanth 27-04-13
            case LVEnums.POPUP_TYPE_FILE_CANNOT_DELETE:
            {
                popup_dimmed.visible = false; // modified by ravikanth 14-08-13
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANNOT_DELETE_FILE") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" } );
                popup_text.visible = true;
                break;
            }
	    // } modified by ravikanth 27-04-13
	    // modified by ravikanth 21.06.13 for ITS 0174571
            case LVEnums.POPUP_TYPE_DELETE_INCOMPLETE:
            {
                messageModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETE_INCOMPLETE") });
                popup_dimmed.visible = true;
                timer.running = true;
                AudioListViewModel.operation = LVEnums.OPERATION_NONE // added by eugene.seo 2013.02.01 for option menu after usb removed during jukebox copying
                break;
            }
	    // modified by ravikanth 21-07-13 for copy cancel confirm on delete
            case LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM:
            case LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_CLEAR_JUKEBOX:
            {
	    // modified by ravikanth 24-07-13 for copy spec changes
                if (root.popup_type == LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM)
                {
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_CANCEL_COPY_FOR_DELETE") } );
                    buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "cancel_copy_delete" } );
                }
                else
                {
                    messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_CANCEL_COPY_FOR_CLEAR_JUKEBOX") } );
                    buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_YES"), "btn_id": "cancel_copy_clear" } );
                }
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_NO"), "btn_id": "Id_2"/*Id_1*/} ); //modified by Michael.Kim 2013.10.15 for ITS 195171
                popup_text.visible = true;
                break;
            }
            // { added by hyochang.ryu 20130731 for ITS181088
            case LVEnums.POPUP_TYPE_BT_DURING_CALL:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_BT_DURING_CALL") } );
                buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" });
                //timer.running = true;	//deleted by hyochang.ryu 20130827 for ITS186908
                popup_text.visible = true;
                break;
            }
            // } added by hyochang.ryu 20130731 for ITS181088
            // { added by cychoi 2015.01.20 for ITS 250091
            case LVEnums.POPUP_TYPE_NOT_SUPPORTED:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_OPERATION_NOT_SUPPORTED") } );
                buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" });
                popup_text.visible = true;
                break;
            }
            // } added by cychoi 2015.01.20
            // { added by cychoi 2014.04.09 for HW Event DV2-1 1403-00067 HIGH TEMPERATURE handling
            case LVEnums.POPUP_TYPE_HIGH_TEMPERATURE:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_STOP_FUNCTION") } );
                buttonModel.append({ "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "Id_0" });
                popup_text.visible = true;
                break;
            }
            // } added by cychoi 2014.04.09
            // { added by cychoi 2015.06.03 for Audio/Video QML optimization
            case LVEnums.POPUP_TYPE_ALL_UNAVAILABLE_FORMAT:
            {
                messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_UNAVAILABLE_FILE_ALL") } );
                buttonModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_OK_BUTTON"), "btn_id": "OkId"   } );
                popup_text.visible = true ;
                break;
            }
            // } added by cychoi 2015.06.03
            default:
            {
                __LOG("onPopup_typeChanged: invalid popup type " + root.popup_type);
                closePopup();
                break;
            }
        }
    }

    //PopUpPropertyTable
    DHAVN_MP_PopUp_PropertyTable
    {
		id:property_text
		focus_id: LVEnums.FOCUS_POPUP
		//focus_visible: ( mediaPlayer.focus_index == focus_id ) && visible
		focus_visible: visible // modified by Sergey 10.04.2013 for ISV#79043
		visible: false
            	offset_y : root.offset_y //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
		message: messageModel
		buttons: buttonModel

		onBtnClicked:
		{
			closePopup();
		}
    }

    //PopUpText    
    DHAVN_MP_PopUp_Text
    {
       id: popup_text

       focus_id: LVEnums.FOCUS_POPUP
       //focus_visible: ( mediaPlayer.focus_index == focus_id ) && visible
       focus_visible: visible // modified by Sergey 10.04.2013 for ISV#79043
       visible: false
       offset_y : root.offset_y //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
       message: messageModel
       buttons: buttonModel
       //connectionTarget: "EngineListener"	// removed by sangmin.seol 2014.07.21 for ITS 0242575
       onBtnClicked:
       {
           __LOG("popup_text onBtnClicked: btnId = " + btnId);
           //{added by junam 2014.01.02 for ITS_ME_217327
           if(ignoreTimer.running)
           {
               __LOG("popup_text onBtnClicked : ignoreTimer running ");
               return;
           }
           //}added by junam

           var popupType = root.popup_type;
           if( btnId != "add_all_ok")
               closePopup();

           switch ( btnId )
           {
               case "Id_0":
               {
                   AudioListViewModel.popupEventHandler(popupType, 0);
                   break;
               }
               case "Id_1":
               {
                   mediaPlayer.cancelInEditState = false; // modified by ravikanth 29-06-13 for ITS 0176909
                   AudioListViewModel.popupEventHandler(popupType, 1);
                   break;
               }
               case "Id_2":
               {
                   AudioListViewModel.popupEventHandler(popupType, 2);
                   break;
               }
               case "Id_3":
               {
                   AudioListViewModel.popupEventHandler(popupType, 3);
                   break;
               }
               case "CapacityOk":
               {
                   AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_CAPACITY_ERROR_MANAGE, 0);
                   break;
               }
               case "ManageJB":
               {
                   // TODO: open juke box on Folder tab with delete option active
                   AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_CAPACITY_ERROR_MANAGE, 1);
                   break;
               }
               case ("new_pl_ok"):
               {
                   showKeypad("");
                   break;
               }
               case ("add_all_ok"):
               {
                   popup_text.visible = false;
                   popup_type_pre = LVEnums.POPUP_TYPE_PL_ADD_ALL_FILES; // add by sslee 2012.06.29 for HMC_DH__SANITY_USB135
                   if (AudioListViewModel.isPlaylistsExist())
                       signalShowPopup(LVEnums.POPUP_TYPE_PL_CHOOSE_PLAYLIST);
                   else
                       signalShowPopup(LVEnums.POPUP_TYPE_PL_CREATE_NEW);
                   break;
               }
// { add by eunhye 2012.07.02 for USB_115
               case ("add_all_cancel"):
               {
                   deselectItem();
                   break; // added by Dmitry 24.05.13
               }
// } add by eunhye 2012.07.02 for USB_115

               // { added by sungkim for CR9616
               case ("OkId"):
               {
                    AudioListViewModel.popupEventHandler(popupType, 0);
                    break; // added by Dmitry 24.05.13
               }
               // } added by sungkim for CR9616

               //{ added by changjin 2012.09.20 for CR 11546
               case ("new_pl_cancel"):
               {
                   signalShowPopup(LVEnums.POPUP_TYPE_PL_ADD_ALL_FILES);
                   break;
               }
               //} added by changjin 2012.09.20 for CR 11546
	       // { modified by ravikanth 16-04-13
               case("cancel_copy"):
               {
	       // modified by ravikanth 29-06-13 for ITS 0176909
                   if(mediaPlayer.cancelInEditState)
                   {
                       mediaPlayer.cancelInEditState = false
                       EngineListener.CancelCopyJukebox();
                       mediaPlayer.startCopy()
                   }
                   else
                   {
                       AudioListViewModel.operation = LVEnums.OPERATION_COPY; // modified for ISV 90644
                       EngineListener.CancelCopyJukebox();
                       EngineListener.CancelAudioCopy(false, true); // modified by cychoi 2015.10.27 for ITS 269858
                       if(mediaPlayer.state == "usb")
                       {
                           // modified on 03-10-13 for ITS 0193710
                           AudioListViewModel.setCopyFromMainPlayer(true);
                           mediaPlayer.startFileList();
                       }
                       mediaPlayer.editHandler(MP.OPTION_MENU_COPY_TO_JUKEBOX);
                   }
                   break;
               }
	       // modified by ravikanth 21-07-13 for copy cancel confirm on delete
               case("cancel_copy_delete"):
               {
                   EngineListener.CancelCopyJukebox();
                   //EngineListenerMain.qmlLog("root.isAll "+ root.isAll)
                   if(root.isAll)
                   {
                       AudioListViewModel.popupEventHandler(popupType, 1);
                   }
                   else
                   {
                       AudioListViewModel.popupEventHandler(popupType, 0);
                   }
                   break;
               }
               case("cancel_copy_clear"):
               {
                   EngineListener.CancelCopyJukebox();
                   AudioListViewModel.popupEventHandler(popupType, 0);
                   break;
               }
               // } modified by ravikanth 16-04-13
           }
       }
    }

    //PopUpTextProgressBar
    DHAVN_MP_PopUp_TextProgressBar
    {
       id: popup_progress

       focus_id: LVEnums.FOCUS_POPUP
       //focus_visible: ( mediaPlayer.focus_index == focus_id ) && visible
	   focus_visible: visible // modified by Sergey 10.04.2013 for ISV#79043
       visible: false
	offset_y : root.offset_y //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
       message: messageModel
       buttons: buttonModel
       progressMin: 0
       progressMax: 100
       progressCur: 0
       useRed: (root.popup_type == LVEnums.POPUP_TYPE_CAPACITY_VIEW) ? true : false // added by Dmitriy Bykov 2012.09.24 for CR 11336 

       onBtnClicked:
       {
           __LOG("popup_progress onBtnClicked: btnId = " + btnId);
	   if(!popup_progress.visible) return;//added by edo.lee 01.19
           var popupType = root.popup_type;
           closePopup();

           switch (popupType)
           {
               case LVEnums.POPUP_TYPE_COPYING:
               {
                   AudioListViewModel.popupEventHandler(popupType, 0 /*cancel*/);
                   break;
               }
               case LVEnums.POPUP_TYPE_MOVING:
               {
                   AudioListViewModel.popupEventHandler(popupType, 0 /*cancel*/);
                   break;
               }
	       //[KOR][ITS][170734][comment] (aettie.ji)
               case LVEnums.POPUP_TYPE_CAPACITY_VIEW:
               {
                   break;
               }
               case LVEnums.POPUP_TYPE_DELETING:
               {
                   AudioListViewModel.popupEventHandler(popupType, 0 /*cancel*/);
                   break;
               }
		default:
                    break;

           }
       }
    }
    //[KOR][ITS][170734][comment] (aettie.ji)
    DHAVN_MP_PopUp_CopyIconProgressBar
    {
        id: popup_icon_progress

        focus_id: LVEnums.FOCUS_POPUP
        focus_visible: visible 
        visible: false
        offset_y : root.offset_y 
        message_s: messageModel
        buttons: buttonModel
        progressMin_s: 0
        progressMax_s: 100
        progressCur_s: 0

        iconType:0

       onBtnClicked:
       {
           __LOG("popup_icon_progress onBtnClicked: btnId = " + btnId);
	     if(!popup_icon_progress.visible) return;
           var popupType = root.popup_type;
           closePopup();

           switch (popupType)
           {
               case LVEnums.POPUP_TYPE_COPYING:
               {
                   AudioListViewModel.popupEventHandler(popupType, 0 /*cancel*/);
                   break;
               }
                default:
                    break;
           }
       }
    }
    //PopUpDimmed
    DHAVN_MP_PopUp_Dimmed
    {
        id: popup_dimmed

        visible: false
        message: messageModel
        offset_y : root.offset_y //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
        onClosed: // modified for ITS 0194515
        {
            if (!root.skipUpdateData)
                AudioListViewModel.requestUpdateListData();
            closePopup();
        }
    }

    //PopUpListAndButtons
    DHAVN_MP_PopUp_ListAndButtons
    {
        id: popup_list

        focus_id: LVEnums.FOCUS_POPUP
        //focus_visible: ( mediaPlayer.focus_index == focus_id ) && visible
        focus_visible: visible // modified by Sergey 10.04.2013 for ISV#79043
        visible: false

        title: root.popupTitle
        listmodel:listModel
        buttons: buttonModel
	  offset_y : root.offset_y //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
        onBtnClicked:
        {
            __LOG("popup_list onBtnClicked: btnId = " + btnId);

            closePopup();
            if (btnId == "new_pl")
            {
                showKeypad("");
            }
// { add by sslee 2012.06.29 for HMC_DH__SANITY_USB135	    
            else if (btnId == "choose_cancel" && popup_type_pre == LVEnums.POPUP_TYPE_PL_ADD_ALL_FILES) //lssanh
            {
                signalShowPopup(LVEnums.POPUP_TYPE_PL_ADD_ALL_FILES);
            }
            popup_type_pre = -1; //lssanh
// } add by sslee 2012.06.29 for HMC_DH__SANITY_USB135	    
        }

        onListItemClicked:
        {
            if (root.popup_type == LVEnums.POPUP_TYPE_PL_CHOOSE_PLAYLIST)
            {
                if (mediaPlayer.state == "listView")
                    AudioListViewModel.startFileOperation("", listModelData.get(index).name);
                else
                    AudioListViewModel.addPlayingTrackToPlaylist(listModelData.get(index).name);
            }
            else if (root.popup_type == LVEnums.POPUP_TYPE_RENAME)
            {
                closePopup();
                AudioListViewModel.onQuickEdit(index);
            }
        }
    }

    Connections
    {
        target: AudioListViewModel

        onHidePopup:
        {
            __LOG("onHidePopup signal from AudioListViewModel");
            closePopup();
        }

        onProgressToPopup:
        {
            __LOG("onProgress " + percentage + "% of " + total + " copy index "+index);

            // { modified by eugeny.novikov 2012.10.11 for CR 14229
            if (AudioListViewModel.operation == LVEnums.OPERATION_NONE ||
               (root.popup_type != LVEnums.POPUP_TYPE_COPYING &&
                root.popup_type != LVEnums.POPUP_TYPE_MOVING &&
                root.popup_type != LVEnums.POPUP_TYPE_DELETING))
            {
                __LOG("Incorrect popup or no active operation! Return.");
                return;
            }
            // } modified by eugeny.novikov

	      root.file_count = total;
//[KOR][ITS][170734][comment] (aettie.ji)
            if(root.popup_type != LVEnums.POPUP_TYPE_COPYING) 
	     {
                popup_progress.progressCur = percentage;
            }else popup_icon_progress.progressCur_s = percentage;
	    
	    // modified by ravikanth 18-07-13 for copy index and count display
            //messageModel.set(1, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_PROGRESSING"), "arg1": (percentage + "%") });

            switch ( root.popup_type )
            {
                case LVEnums.POPUP_TYPE_COPYING:
                {
                    messageModel.set(1, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_COPY_PROGRESSING"),
                                     //"arg1": (percentage + "%") });
                                     "arguments":[{ "arg1" : ( percentage + " %") },
                                                { "arg1" : index },
                                                { "arg1" : total }]} );
                    // { add by wspark 2012.07.25 for CR12226
                    // showing popup differently according to copyAll Status.
                    if(AudioListViewModel.isCopyAll() == true)
                    {
                        messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_ALL_FILES_COPYING")
                                         });
                    }
                    else if (AudioListViewModel.isCopyAll() == false)
                    {
                        messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_COPYING_FORMATTED"),
                                             "arg1": root.file_count });
                    }
                    // } add by wspark
                    break;
                }

                case LVEnums.POPUP_TYPE_MOVING:
                {
                    messageModel.set(1, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_PROGRESSING"), "arg1": (percentage + "%") });

                    messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILES_MOVING"),
                                         "arg1": root.file_count });
                    break;
                }

                case LVEnums.POPUP_TYPE_DELETING:
                {
                    messageModel.set(1, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_PROGRESSING"), "arg1": (percentage + "%") });

                    messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_DELETE"),
                                         "arg1": root.file_count });
                    break;
                }
            }
        }

        onSignalUpdatePopupList:
        {
            listModel.clear();
            for ( var index in plNames )
            {
               // { modified by junggil 2012.08.31 for NEW UX modified to display correctly about lengthy file
               //listModel.append( { "name": plNames[index], "index": index } );
               listModel.append( { "name": EngineListener.makeElidedString(plNames[index], "DH_HDR", 32, 980), "index": index } );
               // } modified by junggil
            }

            listModelData.clear();
            for ( var index in plSources )
            {
               listModelData.append( { "name": plSources[index] } );
            }
            __LOG("onSignalUpdatePopupList: listModel.count = " + listModel.count);
        }

        onRestartTimerForListUpdate:
        {
            timer.running = true;
        }
    }

	 // { remove by eugene.seo 2012.10.16 
	/*
	Connections
	{
	   target: EngineListenerMain

	   onHidePopup://closePopUp
	   	{
			root.closePopup()
	   	}
	}
	*/
	 // } remove by eugene.seo 2012.10.16 
	  
//add by eunhye 2012.10.29 for No CR
    Connections
    {
        target: EngineListener
        onRetranslateUi:
            language_Id = languageId
    }
//add by eunhye 2012.10.29
    Timer
    {
        id: timer

        interval: 3000
        running: false

        onTriggered:
        {
            if (!root.skipUpdateData)
                AudioListViewModel.requestUpdateListData();

            root.skipUpdateData = false;
            closePopup();
        }
    }
// { added by yungi 2013.2.18 for ISV 72964
    Timer
    {
        id: corruptFileTimer

        interval: 3000
        running: false

        onTriggered:
        {
            if (!root.skipUpdateData)
                AudioListViewModel.requestUpdateListData();

            root.skipUpdateData = false;
            closePopup();
            AudioListViewModel.popupEventHandler(LVEnums.POPUP_TYPE_CORRUPT_FILE, 0);
        }
    }
// } added by yungi 2013.2.18 for ISV 72964
    //{added by junam 2014.01.02 for ITS_ME_217327
    Timer
    {
        id: ignoreTimer
        interval: 10
        repeat: false
        running: false
    }
    //}added by junam
}
