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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_MOVE_CONTINUE )
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

      //title: QT_TR_NOOP("Move cancel") //deleted by aettie 2031.04.01 ISV 78226
      message: messageModel
      buttons: buttonModel

      onBtnClicked:
      {
         switch ( btnId )
         {
            case "OkId":
            {
               root.popupClosed()
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_MOVE_CANCEL_CONFIRM )
            }
            break

            case "CancelId":
            {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_MOVE_CONTINUE )
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
         msg: QT_TR_NOOP("STR_MEDIA_MNG_YES") // modified by eugene.seo 2013.06.17
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
         msg: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_CONFIRMATION")
      }
   }
}
