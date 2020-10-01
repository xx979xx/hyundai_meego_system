import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   signal popupClosed()
   property int popup_type: -1 // modified by ravikanth 23-07-13 for popup close on relaunch

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
       root.popupClosed()
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

     // title: QT_TR_NOOP("STR_MEDIA_MOVE_FILE") //deleted by aettie 2031.04.01 ISV 78226
      message: messageModel
      buttons: buttonModel

      onBtnClicked:
      {
         switch ( btnId )
         {
            case "OkId":
            {
               root.popupClosed()
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_MOVE_FILE )
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
   }

   ListModel
   {
      id: messageModel
      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_LOCATION_MOVE_FILE")
      }
   }
}
