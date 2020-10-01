import QtQuick 1.0
import ListViewEnums 1.0
import AppEngineQMLConstants 1.0

Loader
{
   id: root
   //modified by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
   anchors.fill: parent
    //y:93
   visible: false
   property int popup_type;
   // { add by yongkyun.lee@lge.com    2012.10.05 for CR 13484 (New UX: music(LGE) # MP3 File info POPUP
   property string plfileName;
   property string plfolderName;
   property string plbitRate;
   property string plfileFormat;
   property string plcreateDate;
   // } add by yongkyun.lee@lge.com 

   function __LOG(textLog)
   {
       EngineListenerMain.qmlLog("[MP] DHAVN_AppMediaPlayer_PopUpLoader.qml: " + textLog)
   }

   function retranslateUi()
   {
      if (status == Loader.Ready)
      {
         item.retranslateUi()
      }
   }

   function showPopup(type, extParam, extParam2)
   {
       __LOG("showPopup(): type = " + type);

       if (status == "")
       {
           source = "DHAVN_AppMediaPlayer_MP_PopUp.qml";
       }

	   // { added by eugene.seo 2013.02.05 for no capacity error popup
	   if( popup_type == LVEnums.POPUP_TYPE_CAPACITY_ERROR && type ==  LVEnums.POPUP_TYPE_UNAVAILABLE_FILE )
	   	   return;
	   // } added by eugene.seo 2013.02.05 for no capacity error popup

       // { added by sangmin.seol 2014.09.17 show unsupported file only one
       if( mediaPlayer.isUnsupportedPopupVisible() == true && type == LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE )
           return;
       // } added by sangmin.seol 2014.09.17 show unsupported file only one

       // added by sangmin.seol 2014.06.12 ITS 0239773
       if(mediaPlayer.systemPopupVisible == true)
       {
           mediaPlayer.bNeedDelayedPopup = true;
           mediaPlayer.delayedPopupType = type;
           EngineListenerMain.CloseSystemPopup();
           return;
       }
       // added by sangmin.seol 2014.06.12 ITS 0239773

       popup_type = type;

       //item.offset_y = -93;    //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded

       switch (type)
       {
           case LVEnums.POPUP_TYPE_DELETE:
           case LVEnums.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM:
           {
               item.isAll = extParam;
               break;
           }
           case LVEnums.POPUP_TYPE_DELETING:
           {
               if (extParam)
               {
                   // DELETING popUp is called during "Clear Jukebox" process.
                   EngineListener.notifyFormatJukeboxBegin();
               }

               break;
           }
           case LVEnums.POPUP_TYPE_RENAME:
           {
               // { modified by junggil 2012.08.31 for NEW UX modified to display correctly about lengthy file
               //item.popupTitle = extParam;
               item.popupTitle = EngineListener.makeElidedString(extParam, "DH_HDR", 44, 980);
               // } modified by junggil
               item.playListIndex = extParam2;
               break;
           }
           case LVEnums.POPUP_TYPE_CAPACITY_ERROR:
           {
               __LOG("POPUP_TYPE_CAPACITY_ERROR: " + extParam + " " + extParam2);
               item.file_count = extParam;
               item.file_size = Math.round(extParam2 * 100) / 100; // modified by ruindmby 2012.09.26 for CR#11543
               break;
           }
           case LVEnums.POPUP_TYPE_CAPACITY_VIEW:
           {
               __LOG("POPUP_TYPE_CAPACITY_VIEW: " + extParam + " " + extParam2);
	       // modified by ravikanth 21-08-13 for ITS 0185418
               item.all_size = extParam;
               item.use_size = extParam2;
               break;
           }
           case LVEnums.POPUP_TYPE_REPLACE:
           {
               __LOG("POPUP_TYPE_REPLACE: " + extParam);
               // { modified by lssanh 2013.02.19 ISV72922
               //item.replacedFile = extParam;
               item.replacedFile = EngineListener.makeElidedString(extParam, "DH_HDR", 44, 900);
               // } modified by lssanh 2013.02.19 ISV72922
               item.isPlayback = extParam2; // added by lssanh 2013.02.05 ISV72352
               break;
           }

           case LVEnums.POPUP_TYPE_PL_ADD_COMPLETE:
           {
               __LOG("POPUP_TYPE_PL_ADD_COMPLETE: " + extParam);
               // { modified by junggil 2012.08.31 for CR13013 Name of the playlist is showing outside of popup 
               //item.plName = extParam;
               item.plName = EngineListener.makeElidedString(extParam, "DH_HDR", 32, 700);
               // } modified by junggil
               break;
           }
           // { add by yongkyun.lee@lge.com    2012.10.05 for CR 13484 (New UX: music(LGE) # MP3 File info POPUP
           case LVEnums.POPUP_TYPE_DETAIL_FILE_INFO:
           {
               __LOG("POPUP_TYPE_DETAIL_FILE_INFO: " );              
               item.plFileName    = plfileName;
               item.plFolderName  = plfolderName;
               item.plBitRate     = plbitRate;
               item.plFormat      = plfileFormat;
               item.plCreateDate  = plcreateDate;
               break;
           }
           // } add by yongkyun.lee@lge.com 
           // { added by jungae 2012.10.10 CR 13753
           case LVEnums.POPUP_TYPE_IPOD_AVAILABLE_FILES_INFO:
           {
               __LOG("POPUP_TYPE_IPOD_AVAILABLE_FILES_INFO: " + extParam + extParam2);

                item.masterTable_count = extParam;
                item.device_count = extParam2;
                break;
           }
           // } added by jungae
	   // modified by ravikanth 07-07-13 for ITS 0178185
           case LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION:
           {
               __LOG("POPUP_TYPE_CANCEL_COPY_QUESTION: " + extParam );
               item.replaceCopy = extParam;
               break;
           }
           // { removed by sangmin.seol 2013.11.18 POPUP_TYPE_COPY_CANCELED, POPUP_TYPE_COPY_COMPLETE
           // { added by honggi.shin 2013.11.15 for ITS 0209339 Move list index to currentPlayingItem with delete complete popup.
           case LVEnums.POPUP_TYPE_DELETE_COMPLETE:
           {
               listView_loader.item.centerCurrentPlayingItem();
               break;
           }
           // } added by honggi.shin 2013.11.15 END
           default: break;
       }
       item.popup_type = type;
       AudioListViewModel.isPopupID(type);//added by yongkyun.lee 2012.12.07 for file info Popup update

       if (mediaPlayer.focus_index != LVEnums.FOCUS_NONE)
       {
          mediaPlayer.tmp_focus_index = setDefaultFocus(UIListenerEnum.JOG_DOWN);
       }
       visible = true;
   }

   function setDefaultFocus(arrow)
   {
       return item.setDefaultFocus(arrow);
   }

   onVisibleChanged:
   {
       if ( !visible )
       {
           if (mediaPlayer.focus_index == LVEnums.FOCUS_POPUP)
           {
               switch (popup_type)
               {
                   case LVEnums.POPUP_TYPE_EDIT_MODE:
                       listView_loader.item.isListSelected = true;
                       break;

                   default:
                       //mediaPlayer.tmp_focus_index = LVEnums.FOCUS_CONTENT; // modified for ITS 0198888
                       break;
               }
           }
           else
           {
               mediaPlayer.setDefaultFocus();
           }

           AudioController.setIsShowPopup(false);   // added by sangmin.seol 2014.06.23 SMOKE Local Popup OSD
           //EngineListener.onAudioPopupClosed(); // removed by sangmin.seol 2014.07.11 POPUP_OSD
           // { added by cychoi 2015.06.03 for Audio/Video QML optimization
           if(popup_type == LVEnums.POPUP_TYPE_NO_MUSIC_FILES ||
              popup_type == LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE)
           {
               EngineListener.onUnsupportedPopupClosed(popup_type);
           }
           // } added by cychoi 2015.06.03
       }
       //{ modified by yongkyun.lee 2013-11-19 for : ITS 209808
       else
       {
           if (mediaPlayer.focus_index != LVEnums.FOCUS_NONE)
           {
              mediaPlayer.tmp_focus_index = setDefaultFocus(UIListenerEnum.JOG_DOWN);
           }

           AudioController.setIsShowPopup(true);    // added by sangmin.seol 2014.06.12 Local Popup OSD
       }
       //} modified by yongkyun.lee 2013-11-19 
   }

   Connections
   {
      target: item

      onPopupClosed:
      {
          __LOG("onPopupClosed signal");
          // { added by cychoi 2014.04.09 for HW Event DV2-1 1403-00067 HIGH TEMPERATURE handling
          if(root.popup_type == LVEnums.POPUP_TYPE_HIGH_TEMPERATURE)
          {
              EngineListener.sendDeckErrorToUISH();
          }
          // } added by cychoi 2014.04.09
          // { added by Michael.Kim 2014.07.31 for ITS 242932
          else if(root.popup_type == LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION) 
          {
              AudioListViewModel.sendRestartToCopy();
          }
          // } added by Michael.Kim 2014.07.31 for ITS 242932
          // { added by cychoi 2015.06.03 for Audio/Video QML optimization
          else if(root.popup_type == LVEnums.POPUP_TYPE_NO_MUSIC_FILES ||
                  root.popup_type == LVEnums.POPUP_TYPE_UNAVAILABLE_FORMAT ||
                  root.popup_type == LVEnums.POPUP_TYPE_ALL_UNAVAILABLE_FORMAT ||
                  root.popup_type == LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE) // added by cychoi 2015.09.24 for ITS 268908
          {
              EngineListener.onUnsupportedPopupClosed(root.popup_type);
          }
          // } added by cychoi 2015.06.03

          root.popup_type = -1;// modified by yongkyun.lee 2013-11-19 for : ITS 209808
          visible = false;
          AudioListViewModel.isPopupID(-1);//added by yongkyun.lee 2012.12.07 for file info Popup update      
          mediaPlayer.setDefaultFocus(); // added by junggil 2012.07.31 for CR11820

          mediaPlayer.setEmptyMusicListFocus(); //added by honggi.shin 2013.11.04 for empty list focus issue after deleting music files
      }

      onSignalShowPopup:
      {
          showPopup(type);
      }
// { add by eunhye 2012.07.02 for USB_115
      onDeselectItem:
      {
          AudioListViewModel.enableAllCheckBoxes(false);
          listView_loader.item.setBottomButtonDim(true);
      }
// } add by eunhye 2012.07.02 for USB_115
   }

   Connections
   {
      target: AudioListViewModel

      onSignalShowPopup:
      {
          mediaPlayer.closeOptionMenu(true) // added by Dmitry 21.08.13 for ITS0185492
          __LOG("onSignalShowPopup from AudioListViewModel");

		  // { removed by eugene.seo 2013.01.09 for ISV 68334
		  /*
		  if (type == LVEnums.POPUP_TYPE_COPY_COMPLETE && mediaPlayer.state != "listView")
                {
          	  __LOG("no popup");
		  }
		  else
		  */
		  // } removed by eugene.seo 2013.01.09 for ISV 68334
	      showPopup(type, extParam, extParam2);
       }
      // { add by yongkyun.lee@lge.com    2012.10.05 for CR 13484 (New UX: music(LGE) # MP3 File info POPUP
      onSignalFileInfo:
      {
          plfileName   = fileName;
          plfolderName = folderName;
          plbitRate    = bitRate;
          plfileFormat = fileFormat;
          plcreateDate = createDate;
          __LOG("onSignalFileInfo");
      }
      // } add by yongkyun.lee@lge.com 

   }

   Connections
   {
      target: EngineListener

      onRetranslateUi:
      {
         if ( status == Loader.Ready )
         {
            item.retranslateUi()
         }
      }
      //{added by junam 2013.11.28 for ITS_CHN_211039
      onShowPopup:
      {
          mediaPlayer.closeOptionMenu(true)
          showPopup(type);
      }
      //}added by junam
   }

   // {added by Michael.Kim 2014.09.30 for ITS 249302
   Connections {
      target:EngineListenerMain
      onRestartToCopy:
      {
          if(root.popup_type == LVEnums.POPUP_TYPE_CANCEL_COPY_QUESTION)
            AudioListViewModel.sendRestartToCopy();
      }
   }
   // }added by Michael.Kim 2014.09.30 for ITS 249302
}
