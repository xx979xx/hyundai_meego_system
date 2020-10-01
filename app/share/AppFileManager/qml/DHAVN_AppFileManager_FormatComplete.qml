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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_DELETE_COMPLETE_POPUP_CLOSED );
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
          UIControl.popupEventHandler( UIDef.POPUP_EVENT_DELETE_COMPLETE_POPUP_CLOSED );
          popupClosed()
      }
   }

   ListModel
   {
      id: messageModel

      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_FORMAT_COMPLETED")
      }
   }
}
