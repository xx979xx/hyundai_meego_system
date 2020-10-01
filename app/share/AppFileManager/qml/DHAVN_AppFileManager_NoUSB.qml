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
       popupClosed()
   }
   // } added by  yongkyun.lee

   //PopUpText
   DHAVN_AppFileManager_PopUp_Text
   {
      id: popup

      property int focus_x: 0
      property int focus_y: 0
      property string name: "PopUpText"
      focus_id: 0

      title: ""
      message: messageModel
      buttons: buttonModel

      onBtnClicked:
      {
         UIControl.popupEventHandler( UIDef.POPUP_EVENT_NOUSB_OK )
         popupClosed()
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
   }

   ListModel
   {
      id: messageModel
      ListElement
      {
         msg: "No USB is connected"
      }
   }
}
