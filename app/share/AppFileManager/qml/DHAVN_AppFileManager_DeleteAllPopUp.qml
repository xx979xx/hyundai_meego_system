import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   signal popupClosed()
   property int popup_type: -1 // added by Dmitry for ITS0180018 on 16.07.13

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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_DELETE_ALL_CANCEL )
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

      //title: QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FOLDER_ALL") //deleted by aettie 2013.03.24 for ISV 75584 
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
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_DELETE_ALL_CANCEL )
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
         msg: QT_TR_NOOP("STR_MEDIA_MNG_YES") // modified by ravikanth 16-07-13 for ITS 0179867 & 0179865. changes button strings
         btn_id: "OkId"
      }
      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_MNG_NO") // modified by ravikanth 16-07-13 for ITS 0179867 & 0179865. changes button strings
         btn_id: "CancelId"
      }
   }

   ListModel
   {
      id: messageModel
      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FILES_IN_LIST")
      }
   }
}
