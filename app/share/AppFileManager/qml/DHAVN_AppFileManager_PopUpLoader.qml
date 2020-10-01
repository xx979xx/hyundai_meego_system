import Qt 4.7
import com.filemanager.uicontrol 1.0
import AppEngineQMLConstants 1.0

DHAVN_AppFileManager_FocusedLoaderNew
{
   id: root

   name: "PopUpLoader"

   visible: false // added by eugeny.novikov 2012.11.26 for CR 15770
   property int popup_type // added by lssanh 2013.02.22 ISV73569
   property int pending_popup_type

// removed by Dmitry Bykov 04.04.2013

   function closePopup()
   {
// modified by Dmitry 22.08.13
       if (status == Loader.Ready)
       {
           //{added for ITS 242182 2014.07.14
           if(EngineListener.IsSwapDCEnabled() || EngineListener.getCloneMode() == 2 ? !StateManager.isFrontInstance() : StateManager.isFrontInstance())
           {
               EngineListener.setFrontPopup(false);
           }
           //}added for ITS 242182 2014.07.14
          popup_type = -1 // added by lssanh 2013.02.22 ISV73569
          root.item.popup_type =  -1
          root.item.closePopup()
          visible= false;
          root.item.popup_type = UIDef.POPUP_TYPE_MAX//added for Reset type at closePopup 2014.06.17
          focusShow();//added for Double Focus 2014.10.02
       }
   }     

   // {added by Michael.Kim 2013.09.26 for ITS 191681
   function onShowSystemPopup()
   {
       EngineListener.qmlLog("onSignalShowSystemPopup console.log");
       //{added for ITS 242182 2014.07.14
       if(EngineListener.IsSwapDCEnabled() || EngineListener.getCloneMode() == 2 ? !StateManager.isFrontInstance() : StateManager.isFrontInstance())
       {
           EngineListener.setFrontSystemPopup(true);
       }
       //}added for ITS 242182 2014.07.14
       closePopup();
       EngineListener.isPopupID(true)
       StateManager.breakCopyMode(); // modified by ravikanth 08-08-13
       focusHide();//added for Double Focus 2014.10.02
   }

   function onHideSystemPopup()
   {
       //{added for ITS 242182 2014.07.14
       if(EngineListener.IsSwapDCEnabled() || EngineListener.getCloneMode() == 2 ? !StateManager.isFrontInstance() : StateManager.isFrontInstance())
       {
           EngineListener.setFrontSystemPopup(false);
       }
       // { added by cychoi 2015.07.16 for ITS 266531
       else
       {
           if (UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_FRONT || !EngineListener.isFrontDisplayFG())
           {
               EngineListener.setFrontSystemPopup(false);
           }
       }
       // } added by cychoi 2015.07.16
       //}added for ITS 242182 2014.07.14
       EngineListener.qmlLog("onSignalHideSystemPopup");
       if(!visible)
       {
           EngineListener.isPopupID(false)
           focusShow();//added for Double Focus 2014.10.02
       }
   }
   // {added by Michael.Kim 2013.09.26 for ITS 191681

   function focusHide()//added for Double Focus 2014.10.02
   {
       if (options_menu.status == Loader.Ready && options_menu.item.visible)
           options_menu.item.quickHide()
       mainScreen.focus_default = 6 // focus is taken by popup
   }

   function focusShow()//added for Double Focus 2014.10.02
   {
       if(!mainScreen.systemPopup) {
           // { modified by cychoi 2016.01.21 for ITS 271265
           if (mainScreen.lockoutVisible)
               mainScreen.focus_default = 1
           else if (mainScreen.currentLoaderCount == 0)
               mainScreen.focus_default = 4
           else
           {
               source = ""
               mainScreen.focus_default = 2 // return focus to content
           }
           // } modified by cychoi 2016.01.21
       } else {
              if (options_menu.status == Loader.Ready && options_menu.item.visible)
           	      options_menu.item.quickHide()
              mainScreen.focus_default = 6 // focus is taken by popup
       }
   }

   onVisibleChanged:
   {
       EngineListener.onAudioPopupVisibleChanged(UIListener.getCurrentScreen(), visible); // modified by cychoi 2015.11.03 for ITS 269995 // added by cychoi 2015.09.23 for ITS 269113
       /*if ( !visible )
       {
          // {added by Michael.Kim 2014.01.25 for ITS 221044
          if (mainScreen.currentLoaderCount == 0)
              mainScreen.focus_default = 4
          else
          {
          source = ""
          mainScreen.focus_default = 2 // return focus to content
          }
          // }added by Michael.Kim 2014.01.25 for ITS 221044
       }
      else
      {
         // added by Dmitry 21.08.13
         if (options_menu.status == Loader.Ready && options_menu.item.visible)
             options_menu.item.quickHide()
         mainScreen.focus_default = 6 // focus is taken by popup
      }*/
   }

   Connections
   {
      target: (status == Loader.Ready) ? root.item : null // modified by Dmitry Bykov 04.04.2013
      onPopupClosed:
      {
          //{added for ITS 242182 2014.07.14
          if(EngineListener.IsSwapDCEnabled() || EngineListener.getCloneMode() == 2 ? !StateManager.isFrontInstance() : StateManager.isFrontInstance())
          {
              EngineListener.setFrontPopup(false);
          }
          //}added for ITS 242182 2014.07.14
          visible = false
          EngineListener.isPopupID(visible) // add by eunhye 2013.02.06 for ISV70222/70319, ITS150138/149862
          EngineListener.resetFileSelected(); // added by Michael.Kim 2014.12.02 for ITS 253894
          focusShow();//added for Double Focus 2014.10.02
      }
   }

   Connections
   {
      target: UIControl

      onShowPopup:
      {
         //visible = true
         popup_type = type;  // added by lssanh 2013.02.22 ISV73569
          //added for System Popup Control 2014.06.17
          if(EngineListener.getSystemPopupState())
          {
              EngineListener.CloseSystemPopup();
              pending_popup_type = popup_type;
          }
          //added for System Popup Control 2014.06.17
         //EngineListener.isPopupID(visible) //move by edo.lee 2013.10.01 ITS  0177248  
         switch ( type )
         {
            case UIDef.POPUP_TYPE_START:
            {
               source = "DHAVN_AppFileManager_StartUpPopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_COPY:
            {
               source = "DHAVN_AppFileManager_CopyFilePopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_COPYING:
            {
               source = "DHAVN_AppFileManager_CopyingPopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_COPY_COMPLETE:
            {
               source = "DHAVN_AppFileManager_CopyCompletePopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_MOVE:
            {
               source = "DHAVN_AppFileManager_MovePopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_MOVE_ALL:
            {
               source = "DHAVN_AppFileManager_MoveAllPopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_DELETE:
            {
               source = "DHAVN_AppFileManager_DeletePopUp.qml"
               root.item.popup_type =  UIDef.POPUP_EVENT_FILE_OPERATION_DELETE
            }
            break            

            case UIDef.POPUP_TYPE_DELETE_FOLDER:
            {
               source = "DHAVN_AppFileManager_DeletePopUp.qml"
               root.item.popup_type =  UIDef.POPUP_EVENT_FOLDER_OPERATION_DELETE
            }
            break

            case UIDef.POPUP_TYPE_DELETE_ALL:
            {
               source = "DHAVN_AppFileManager_DeleteAllPopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_DELETING:
            {
               source = "DHAVN_AppFileManager_DeletingPopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_DELETE_COMPLETE:
            {
               source = "DHAVN_AppFileManager_DeleteCompletePopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_NOUSB:
            {
               source = "DHAVN_AppFileManager_NoUSB.qml"
            }

            case UIDef.POPUP_TYPE_FOLDER_OPERATION:
            {
               source = "DHAVN_AppFileManager_FolderActionPopUp.qml"
               root.item.popup_type = UIDef.FOLDER_MODE_FOLDER
            }
            break

            case UIDef.POPUP_TYPE_SET_AS_FRAME:
            {
               source = "DHAVN_AppFileManager_SetAsFramePopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_FRAME_SAVED:
            {
               source = "DHAVN_AppFileManager_FrameSavedPopup.qml"
            }
            break
            
            case UIDef.POPUP_TYPE_EDIT_MODE:
            {
               source = "DHAVN_AppFileManager_EditModePopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_FILE_VIDEO_JUKEBOX_OPERATION:
            {
                source = "DHAVN_AppFileManager_FolderActionPopUp.qml"
                root.item.popup_type = UIDef.FOLDER_MODE_FILE_VIDEO_JUKEBOX
            }
            break

            case UIDef.POPUP_TYPE_FILE_VIDEO_USB_OPERATION:
            {
                // Nothing to do for USB video
            }
            break

            case UIDef.POPUP_TYPE_FILE_PICTURE_JUKEBOX_OPERATION:
            {
                source = "DHAVN_AppFileManager_FolderActionPopUp.qml"
                root.item.popup_type = UIDef.FOLDER_MODE_FILE_PICTURE_JUKEBOX
            }
            break

            case UIDef.POPUP_TYPE_FILE_PICTURE_USB_OPERATION:
            {
                source = "DHAVN_AppFileManager_FolderActionPopUp.qml"
                root.item.popup_type = UIDef.FOLDER_MODE_FILE_PICTURE_USB
            }
            break

            case UIDef.POPUP_TYPE_EMPTY_FOLDER_NAME:
            {
               source = "DHAVN_AppFileManager_IncorrectNamePopUp.qml"
               root.item.popup_type = UIDef.POPUP_TYPE_EMPTY_FOLDER_NAME
            }
            break

            case UIDef.POPUP_TYPE_EMPTY_FILE_NAME:
            {
                source = "DHAVN_AppFileManager_IncorrectNamePopUp.qml"
                root.item.popup_type = UIDef.POPUP_TYPE_EMPTY_FILE_NAME
            }
            break

            case UIDef.POPUP_TYPE_FOLDER_NAME_IS_TOO_LONG:
            {
               source = "DHAVN_AppFileManager_IncorrectNamePopUp.qml"
               root.item.popup_type = UIDef.POPUP_TYPE_FOLDER_NAME_IS_TOO_LONG
            }
            break

            case UIDef.POPUP_TYPE_FILE_NAME_IS_TOO_LONG:
            {
               source = "DHAVN_AppFileManager_IncorrectNamePopUp.qml"
               root.item.popup_type = UIDef.POPUP_TYPE_FILE_NAME_IS_TOO_LONG
            }
            break

            case UIDef.POPUP_TYPE_INCORRECT_CHARACTER:
            {
               source = "DHAVN_AppFileManager_IncorrectNamePopUp.qml"
               root.item.popup_type = UIDef.POPUP_TYPE_INCORRECT_CHARACTER
            }
            break

            case UIDef.POPUP_TYPE_FOLDER_ALREADY_EXIST:
            {
               source = "DHAVN_AppFileManager_IncorrectNamePopUp.qml"
               root.item.popup_type = UIDef.POPUP_TYPE_FOLDER_ALREADY_EXIST
            }
            break

            case UIDef.POPUP_TYPE_FILE_ALREADY_EXIST:
            {
               source = "DHAVN_AppFileManager_IncorrectNamePopUp.qml"
               root.item.popup_type = UIDef.POPUP_TYPE_FILE_ALREADY_EXIST
            }
            break

            case UIDef.POPUP_TYPE_REPLACE_FILE:
            {
                source = "DHAVN_AppFileManager_ReplacePopup.qml"
            }
            break
//added by aettie 201300613 for ITS 173605
            case UIDef.POPUP_TYPE_REPLACE_FRAME_FILE:
            {
                source = "DHAVN_AppFileManager_ReplaceFramePopup.qml"
            }
            break
            
            case UIDef.POPUP_TYPE_CAPACITY_ERROR:
            {
                source = "DHAVN_AppFileManager_CapacityErrorPopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_COPY_CANCEL:
            {
                source = "DHAVN_AppFileManager_CopyCancelPopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_COPY_CANCELLED:
            {
                source = "DHAVN_AppFileManager_CopyCancelledPopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_JUKEBOX_CAPACITY:
            {
                source = "DHAVN_AppFileManager_JukeboxCapacityPopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_OPTION_MENU_DELETE_ALL:
            {
                source = "DHAVN_AppFileManager_OptionMenu_DeleteAllPopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_DELETING_ALL:
            {
                source = "DHAVN_AppFileManager_DeletingAllPopUp.qml"
            }
            break

            case UIDef.POPUP_TYPE_MOVING:
            {
               source = "DHAVN_AppFileManager_MovingPopUp.qml"
            }

            case UIDef.POPUP_TYPE_MOVE_CANCEL:
            {
               source = "DHAVN_AppFileManager_MoveCancelPopUp.qml"
            }

            case UIDef.POPUP_TYPE_MOVE_CANCELLED:
            {
                source = "DHAVN_AppFileManager_MoveCancelledPopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_MOVE_COMPLETE:
            {
               source = "DHAVN_AppFileManager_MoveCompletePopUp.qml"
            }
            break;

            case UIDef.POPUP_TYPE_CORROPTED_ERROR:
            {
                source = "DHAVN_AppFileManager_CorruptedErrorPopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_JUKEBOX_ERROR:
            {
                source = "DHAVN_AppFileManager_JukeboxErrorPopup.qml"
            }
            break

            case UIDef.POPUP_TYPE_FOLDER_IS_USED:
            {
                source = "DHAVN_AppFileManager_FilenameIsUsedPopup.qml"
                root.item.popup_type = UIDef.POPUP_TYPE_FOLDER_IS_USED
            }
            break

            case UIDef.POPUP_TYPE_FILE_IS_USED:
            {
                source = "DHAVN_AppFileManager_FilenameIsUsedPopup.qml"
                root.item.popup_type = UIDef.POPUP_TYPE_FILE_IS_USED
            }
            break

             case UIDef.POPUP_TYPE_COPY_ALL_CONFIRMATION:
            {
                source = "DHAVN_AppFileManager_CopyAllConfirmationPopup.qml"
            }
            break

            // { added by lssanh 2012.09.17 for CR13482
            case UIDef.POPUP_TYPE_FORMATTING:
            {
                source = "DHAVN_AppFileManager_Formatting.qml"
            }
            break

            case UIDef.POPUP_TYPE_FORMAT_COMPLETE:
            {
                source = "DHAVN_AppFileManager_FormatComplete.qml"
            }
            break
            // } added by lssanh 2012.09.17 for CR13482

            // { added by Sergey 10.11.2013 new DivX popups
            case UIDef.POPUP_TYPE_UNSUPPORTED_FILE:
            case UIDef.POPUP_TYPE_AUDIO_FORMAT_UNSUPPORTED:
            case UIDef.POPUP_TYPE_RESOLUTION_UNSUPPORTED:
            {
                source = "DHAVN_AppFileManager_UnsupportedPopup.qml"
                root.item.popup_type = type
            }
            break
            // } added by Sergey 10.11.2013 new DivX popups

            // { added by Sergey 15.09.2013 for ITS#185233
            case UIDef.POPUP_TYPE_DRM_EXPIRED:
            case UIDef.POPUP_TYPE_DRM_NOT_AUTH:
            case UIDef.POPUP_TYPE_DRM_CONFIRM:
            {
                source = "DHAVN_AppFileManager_DRM_Popup.qml"
                root.item.popup_type = type
            }
            break
			// } added by Sergey 15.09.2013 for ITS#185233
			
	    // { modified by ravikanth 16-04-13 
            case UIDef.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM:
           {
               source = "DHAVN_AppFileManager_CopyToJukebox_Confirm.qml"
               root.item.popup_type = UIDef.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM // modified by ravikanth 21-07-13 for copy cancel confirm on delete
           }
            break
	    // { modified by ravikanth 27-04-13
            case UIDef.POPUP_TYPE_FILE_CANNOT_DELETE:
            {
                source = "DHAVN_AppFileManager_CannotDeletePlayingFilePopup.qml"
            }
           break
	   // modified by ravikanth 21.06.13 for ITS 0174571
            case UIDef.POPUP_TYPE_DELETE_INCOMPLETE:
            {
                source = "DHAVN_AppFileManager_DeleteIncomplete.qml"
            }
           break
	   // } modified by ravikanth 27-04-13 
	   // modified by ravikanth 24-07-13 for copy cancel confirm on delete
            case UIDef.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM:
            {
                source = "DHAVN_AppFileManager_CopyToJukebox_Confirm.qml"
                root.item.popup_type = UIDef.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM
            }
            break;
            case UIDef.POPUP_TYPE_CANCEL_COPY_FOR_CLEAR_JUKEBOX_CONFIRM:
            {
                source = "DHAVN_AppFileManager_CopyToJukebox_Confirm.qml"
                root.item.popup_type = UIDef.POPUP_TYPE_CANCEL_COPY_FOR_CLEAR_JUKEBOX_CONFIRM
            }
            break;
            default:
            {
               // EngineListener.qmlLog( "AppFileManager::PopUpLoader   onShowPopup: invalid popup type" )
            }
         }
         //{added for ITS 242182 2014.07.14
         if(EngineListener.IsSwapDCEnabled() || EngineListener.getCloneMode() == 2 ? !StateManager.isFrontInstance() : StateManager.isFrontInstance())
         {
             EngineListener.setFrontPopup(true);
         }
         //}added for ITS 242182 2014.07.14
         visible = true
         EngineListener.isPopupID(visible)//move by edo.lee 2013.10.01 ITS  0177248 
         focusHide();//added for Double Focus 2014.10.02
      }

       // { added by  yongkyun.lee 2012.10.09 for add close popup
//      onPopupClosed:
//      {
//           closePopup()
//      }
      // } added by  yongkyun.lee 

      onHidePopup:
      {
          //{added for ITS 242182 2014.07.14
          if(EngineListener.IsSwapDCEnabled() || EngineListener.getCloneMode() == 2 ? !StateManager.isFrontInstance() : StateManager.isFrontInstance())
          {
              EngineListener.setFrontPopup(false);
          }
          //}added for ITS 242182 2014.07.14
         visible = false
          focusShow();//added for Double Focus 2014.10.02
      }

      // modified by ravikanth 10-07-13 for ITS 0179181
      onHidePopupOnFG:
      {
          //EngineListener.qmlLog("onHidePopupOnFG " +display+ "current display= "+UIListener.getCurrentScreen())
          if( display == UIListener.getCurrentScreen())
          {
              closePopup() // modified by Dmitry for ITS0180018 on 16.07.13
          }
      }
   }

//{moved by Michael.Kim 2013.09.26 for ITS 191681
//{added by aettie 2013.03.29 for System popup handle
   //Connections
   //{
   //     target: UIListener
   //     onSignalShowSystemPopup:
   //     {
   //         EngineListener.qmlLog("onSignalShowSystemPopup");
   //         closePopup();
   //         StateManager.breakCopyMode(); // modified by ravikanth 08-08-13
   //     }
   //     onSignalHideSystemPopup:
   //     {
   //         EngineListener.qmlLog("onSignalHideSystemPopup");
   //     }
   //}
//}added by aettie 2013.03.29 for System popup handle
//{moved by Michael.Kim 2013.09.26 for ITS 191681

   Connections
   {
      target: EngineListener

      onRetranslateUi:
      {
         if ( status == Loader.Ready )
         {
            root.item.retranslateUi()
         }
      }
      
      // modified for ITS 0217509
      onCloseCopyCancelConfirmPopup:
      {
          if (status == Loader.Ready)
          {
              EngineListener.qmlLog("OnCloseCopyCancelConfirmPopup "+ root.item.popup_type)
              if(root.item.popup_type == UIDef.POPUP_TYPE_CANCEL_COPY_FOR_CLEAR_JUKEBOX_CONFIRM
                      || root.item.popup_type == UIDef.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM
                      || root.item.popup_type == UIDef.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM)
                  closePopup();
          }
      }
	  //{added for ITS 227374 2014.02.27
      onCloseDRMPopup:
      {
          if (status == Loader.Ready)
          {
              EngineListener.qmlLog("OnCloseDRMPopup "+ root.item.popup_type)
              if(root.item.popup_type == UIDef.POPUP_TYPE_DRM_CONFIRM
                      || root.item.popup_type == UIDef.POPUP_TYPE_DRM_EXPIRED
                      || root.item.popup_type == UIDef.POPUP_TYPE_DRM_NOT_AUTH)
                  closePopup();
          }
      }
	  //}added for ITS 227374 2014.02.27

      //{added for ITS 231147 2014.03.26
      onClosePopupOnFG:
      {
          if (status == Loader.Ready)
          {
              EngineListener.qmlLog("onClosePopupOnFG "+ root.item.popup_type)
              closePopup();
          }
      }

      // { added by cychoi 2015.07.16 for ITS 266390
      onClosePopupByDisplay:
      {
          if(isFront != StateManager.isFrontInstance())
              return
          
          if (status == Loader.Ready)
          {
              EngineListener.qmlLog("closePopupByDisplay "+ root.item.popup_type)
              closePopup();
          }
      }
      // } added by cychoi 2015.07.16

      onFocusHide:
      {
          EngineListener.qmlCritical("","ANTA onFocusHide");
          focusHide()
      }


      onFocusShow:
      {
          EngineListener.qmlCritical("","ANTA onFocusShow");
          if(!visible)
              focusShow()
      }

      //}added for ITS 231147 2014.03.26
   }
// modified by Dmitry Bykov 04.04.2013
}
