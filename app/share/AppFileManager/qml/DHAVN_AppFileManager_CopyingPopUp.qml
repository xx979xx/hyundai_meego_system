import QtQuick 1.1
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import AppEngineQMLConstants 1.0 // added by Michael.Kim 2014.07.22 to use UIListenerEnum value
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   /** count of files */
   property int __count_of_files: 0
   property int iconType : (UIControl.currentFileType == UIDef.FILE_TYPE_PICTURE)? 2 : 1 //[KOR][ITS][170734][comment] (aettie.ji)
   property int popup_type: -1 // modified by ravikanth 23-07-13 for popup close on relaunch

   signal popupClosed()

   anchors.fill: parent

   MouseArea
   {
      anchors.fill: parent
   }

   function retranslateUi()
   {
      popup.retranslateUI(FM.const_APP_FILE_MANAGER_LANGCONTEXT)
   }

   // { added by  yongkyun.lee 2012.10.09 for add close popup
   function closePopup()
   {
      EngineListener.qmlLog("closePopup getCurrentScreen() = " + UIListener.getCurrentScreen());
      StateManager.breakCopyMode(); // modified by Michael.Kim 2014.10.07 for ITS 248905
      popupClosed()
   }
   // } added by  yongkyun.lee

   //PopUpTextProgressBar
//   DHAVN_AppFileManager_PopUp_TextProgressBar
   DHAVN_AppFileManager_PopUp_CopyIconProgressBar //modified for [KOR][ITS][170734][comment] (aettie.ji)
   {
      id: popup

      property string name: "PopUpTextProgressBar"

      //modified for [KOR][ITS][170734][comment] (aettie.ji)
      message_s: messageModel
      buttons: buttonModel
      progressMin_s: 0
      progressMax_s: 100
      progressCur_s: 0

      iconType: root.iconType

      onBtnClicked:
      {
         UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_CANCEL )
         popupClosed()
      }
   }

   ListModel
   {
      id: buttonModel

      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
         btn_id: "CancelId"
      }
   }

   ListModel
   {
      id: messageModel
   }

   Connections
   {
       target: FileManager

       onProgress:
       {
           // EngineListener.qmlLog("fileManager# onProgress " + copyPercentage + " of " + total)
           root.__count_of_files = total
           popup.progressCur_s = copyPercentage //[KOR][ITS][170734][comment] (aettie.ji)

           // { add by wspark 2012.07.25 for CR12226
           // showing popup differently according to copyAll Status.
           if(UIControl.is_CopyAll == true)
           {
                messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_ALL_FILES_COPYING") })
           }
           else if(UIControl.is_CopyAll == false)
           {
                messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_COPYING_FORMATTED"), "arg1": root.__count_of_files })
           }
           // } add by wspark
	   // modified by ravikanth 18-07-13 for copy index and count display
           messageModel.set(1, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_COPY_PROGRESSING"),
                            //"arg1": ( copyPercentage + "%") })
                            arguments:[{ "arg1" : ( copyPercentage + " %") },
                                       { "arg1" : index },
                                       { "arg1" : total }]} )

       }

       onOperationCopyComplete:
       {
          // EngineListener.qmlLog("fileManager# operation complete")
           UIControl.setCopyTotalCount(copyFilesCount) // modified by ravikanth 22-04-13
           UIControl.setCopySkipCount(skipCount) // modified by ravikanth 22-04-13
          // { add by wspark 2012.07.12 for CR9616
          // ignore CopyComplete signal when there is CORRUPTED ERROR popup.
          // commented for ITS 0208724
          // if( UIControl.currentPopupEvent != UIDef.POPUP_TYPE_CORROPTED_ERROR)
          // {
          //     if(!((copyFilesCount == 0) && (skipCount == 0)))
          //         UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_COMPLETED )
          // }
          // } add by wspark
          //popupClosed()
       }
   }

   // modified for ITS 0208724
   Connections
   {
       target: UiControl
       onCloseCopyProgressPopup:
       {
           closePopup()
       }
   }

   Component.onCompleted:
   {
      messageModel.clear()
      // { add by wspark 2012.07.25 for CR12226
      // showing popup differently according to copyAll Status.
      if(UIControl.is_CopyAll == true)
      {
            messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_ALL_FILES_COPYING") } )
      }
      else if(UIControl.is_CopyAll == false)
      {
            messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_COPYING_FORMATTED"), "arg1" : __count_of_files } )
      }
      // } add by wspark
      // modified by ravikanth 18-07-13 for copy index and count display
      messageModel.append( {"msg": QT_TR_NOOP("STR_MEDIA_MNG_COPY_PROGRESSING"),
                          //"arg1": popup.progressCur_s })
                          arguments:[{ "arg1" : popup.progressCur_s },
                                     { "arg1" : 0 },
                                     { "arg1" : 0 }]} ) //[KOR][ITS][170734][comment] (aettie.ji)
   }
}
