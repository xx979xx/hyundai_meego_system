import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_MOVE_CANCELED_POPUP_CLOSED );
       popupClosed()
   }
   // } added by  yongkyun.lee 

   //PopUpDimmed
   DHAVN_AppFileManager_PopUp_Dimmed // modified by eunhye 2013.03.20
   {
      id: popup

      message: messageModel

      onClosed:
      {
          UIControl.popupEventHandler( UIDef.POPUP_EVENT_MOVE_CANCELED_POPUP_CLOSED );
          popupClosed()
      }
   }

   ListModel
   {
      id: messageModel

      ListElement
      {
         //{modified by yungi 2012.12.07 for No CR Hard Code Message Chagned by TS name
         //msg: QT_TR_NOOP("Move completed")
           msg: QT_TR_NOOP("STR_MEDIA_MNG_MOVE_COMPLETED")
         //}modified by yungi 2012.12.07 for No CR Hard Code Message Chagned by TS name
      }
   }
}
