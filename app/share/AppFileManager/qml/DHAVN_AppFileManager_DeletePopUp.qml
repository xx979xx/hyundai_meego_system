import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   property int popup_type: -1

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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_DELETE_CANCEL )
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

      //title: QT_TR_NOOP("STR_MEDIA_MNG_DELETE") //deleted by aettie 2013.03.24 for ISV 75584 
      message: messageModel
      buttons: buttonModel

      onBtnClicked:
      {
         switch ( btnId )
         {
            case "OkId":
            {
               root.popupClosed()
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_DELETE_CONFIRMATION )
            }
            break

            case "CancelId":
            {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_DELETE_CANCEL )
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
         msg: ""
      }
   }

   onPopup_typeChanged:
   {
      switch ( root.popup_type )
      {
         case UIDef.POPUP_EVENT_FILE_OPERATION_DELETE:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_MEDIA_MNG_DELETE_SELECTED_CONFIRMATION") )
         }
         break

         case UIDef.POPUP_EVENT_FOLDER_OPERATION_DELETE:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FOLDER_CONFIRMATION") )
         }
         break
      }
   }
}
