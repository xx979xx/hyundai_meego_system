import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   /** count of files */
   property int __count_of_files: 0
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
       popupClosed()
   }
   // } added by  yongkyun.lee

   //PopUpTextProgressBar
   DHAVN_AppFileManager_PopUp_TextProgressBar
   {
      id: popup

      property string name: "PopUpTextProgressBar"

      //title: QT_TR_NOOP("Moving")
      message: messageModel
      buttons: buttonModel
      progressMin: 0
      progressMax: 100
      progressCur: 0

      onBtnClicked:
      {
         UIControl.popupEventHandler( UIDef.POPUP_EVENT_MOVE_CANCEL )
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
           popup.progressCur = copyPercentage

           messageModel.set(0, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_MOVING_FORMATTED"), "arg1": root.__count_of_files })
           messageModel.set(1, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_PROGRESSING"), "arg1": ( copyPercentage + "%") })
       }

       onOperationMoveComplete:
       {
          // EngineListener.qmlLog("fileManager# operation complete: MoveComplete")

          UIControl.popupEventHandler( UIDef.POPUP_EVENT_MOVE_COMPLETED )
          popupClosed()
       }
   }

   Component.onCompleted:
   {
      messageModel.clear()
      messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_MOVING_FORMATTED"), "arg1" : __count_of_files } )
      messageModel.append( {"msg": QT_TR_NOOP("STR_MEDIA_MNG_PROGRESSING"), "arg1": popup.progressCur })
   }
}
