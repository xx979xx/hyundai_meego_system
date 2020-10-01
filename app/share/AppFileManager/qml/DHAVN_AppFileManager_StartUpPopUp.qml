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
      popupClosed()
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

   //PopUpText
   DHAVN_AppFileManager_PopUp_Text
   {
      id: popup

      //title: QT_TR_NOOP("STR_MEDIA_MNG_TIP") //deleted by aettie 2031.04.01 ISV 78226
      message: messageModel
   }

   ListModel
   {
      id: messageModel
      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_MNG_INFO")
      }
   }

   Component.onCompleted:
   {
      timer.running = true
   }
}
