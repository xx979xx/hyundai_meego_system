import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   /** count of files */
   property int __count_of_files: 0
   property int popup_type: -1 // added by Dmitry for ITS0180018 on 16.07.13

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
       popupClosed()
   }
   // } added by  yongkyun.lee

   //PopUpTextProgressBar
   DHAVN_AppFileManager_PopUp_TextProgressBar
   {
      id: popup

      property string name: "PopUpTextProgressBar"

      //title: "Delete All files" //QT_TR_NOOP("Delete file")
      message: messageModel
      progressMin: 0
      progressMax: 100
      progressCur: 0
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
          popup.progressCur = copyPercentage

           messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETING_FILES"), "arg1": root.__count_of_files })
           messageModel.set(1, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_REMAINED_PROGRESS"), "arg1":  copyPercentage })
       }

       onOperationDeleteComplete:
       {
          // EngineListener.qmlLog("fileManager# operation complete")

          UIControl.popupEventHandler( UIDef.POPUP_EVENT_DELETE_COMPLETED )
          popupClosed()
       }
   }

   Component.onCompleted:
   {
      messageModel.clear()
      messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_DELETING_FILES"), "arg1" : __count_of_files } )
      messageModel.append( {"msg": QT_TR_NOOP("STR_MEDIA_MNG_REMAINED_PROGRESS"), "arg1": popup.progressCur })
   }
}
