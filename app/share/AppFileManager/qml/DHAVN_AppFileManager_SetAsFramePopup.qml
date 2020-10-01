import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_SAVE_FRAME_CANCEL )
       root.popupClosed()
   }
   // } added by  yongkyun.lee


   //DHAVN_AppFileManager_PopUp_Text
   PopUpText // for popup animation 20130723
   {
       id: popup

       property int focus_x: 0
       property int focus_y: 0
       property string name: "PopUpText"
       focus_id: 0

       //title: UIControl.selectedPictureName //deleted by aettie 201300613 for ITS 173605
       message: messageModel
       buttons: buttonModel
       visible:true
       _useAnimation:true
       onBtnClicked:
       {
           switch ( btnId )
           {
           case "OkId":
           {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_SAVE_FRAME_JUKEBOX )
           }
           break

           case "CancelId":
           {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_SAVE_FRAME_CANCEL )
               root.popupClosed()
           }
           break
           }
       }
   }

   ListModel
   {
      id: buttonModel

      ListElement
      {
         msg: QT_TR_NOOP("STR_POPUP_OK")
         btn_id: "OkId"
      }
      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
         btn_id: "CancelId"
      }
   }

   ListModel
   {
      id: messageModel

      ListElement
      {
          msg: QT_TR_NOOP("STR_MEDIA_MNG_SAVE_FRAME_REQUEST")
      }
   }

   Connections
   {
       target: FileManager

       onOperationCopyComplete:
       {
          // EngineListener.qmlLog("!!!fileManager# operation complete")

          UIControl.popupEventHandler( UIDef.POPUP_EVENT_SAVE_FRAME_COMPLETED )
          root.popupClosed()
       }
   }
}
