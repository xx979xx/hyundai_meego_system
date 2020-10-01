import QtQuick 1.0
import QmlPopUpPlugin 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   signal popupClosed()

   anchors.fill: parent

   function retranslateUi()
   {
       popup.retranslateUI(FM.const_APP_FILE_MANAGER_LANGCONTEXT)
   }

   // { added by  yongkyun.lee 2012.10.09 for add close popup
   function closePopup()
   {
       root.popupClosed()
   }
   // } added by  yongkyun.lee 

   Timer
   {
      id: timer

      interval: 3000
      running: false

      onTriggered:
      {
         popupClosed()
      }
   }

   MouseArea
   {
      anchors.fill: parent
   }
//modified by aettie 201300613 for ITS 173605
   //PopUpText
  // DHAVN_AppFileManager_PopUp_Text
  // {
  //    id: popup

//      message: messageModel
//   }

   DHAVN_AppFileManager_PopUp_Dimmed 
   {
      id: popup

      message: messageModel

   }
   ListModel
   {
      id: messageModel

      ListElement
      {
          msg: QT_TR_NOOP("STR_SAVE_FRAME_INFO")
      }
   }

   Component.onCompleted:
   {
      timer.running = true
   }
}
