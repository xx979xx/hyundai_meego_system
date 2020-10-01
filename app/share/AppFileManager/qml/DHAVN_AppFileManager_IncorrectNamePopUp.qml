import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import PopUpConstants 1.0

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

      buttons: buttonModel
      message: messageModel
    //  icon_title: EPopUp.WARNING_ICON;
      //added by edo.lee 2012.09.03 for CR 9313
      //title: " ";
      //title : QT_TR_NOOP("STR_STANDBY_LABEL")
      //added by edo.lee
      onBtnClicked:
      {
         popupClosed()

          if((root.popup_type == UIDef.POPUP_TYPE_FOLDER_ALREADY_EXIST) || (root.popup_type == UIDef.POPUP_TYPE_FILE_ALREADY_EXIST))
          {
              key_pad_loader.item.clearText();
          }
      }
   }

   ListModel
   {
      id: buttonModel

      ListElement
      {
         msg: QT_TR_NOOP("STR_POPUP_OK")
         btn_id: "OKId"
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
         case UIDef.POPUP_TYPE_EMPTY_FOLDER_NAME:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_FILEMANAGER_ENTER_FOLDER_NAME") )
         }
         break

         case UIDef.POPUP_TYPE_EMPTY_FILE_NAME:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_FILEMANAGER_ENTER_FILE_NAME") )
         }
         break

         case UIDef.POPUP_TYPE_FOLDER_NAME_IS_TOO_LONG:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_MEDIA_MNG_FILE_LONG_NAME") )
         }
         break

         case UIDef.POPUP_TYPE_FILE_NAME_IS_TOO_LONG:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_MEDIA_MNG_LIMITED_FILE_NAME") )
         }
         break

         case UIDef.POPUP_TYPE_INCORRECT_CHARACTER:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_MEDIA_MNG_FILE_INCORRECT_NAME") )
         }
         break

         case UIDef.POPUP_TYPE_FOLDER_ALREADY_EXIST:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_FILEMANAGER_FOLDER_IS_ALREADY_EXIST") )
         }
         break

         case UIDef.POPUP_TYPE_FILE_ALREADY_EXIST:
         {
            messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_FILEMANAGER_FILE_IS_ALREADY_EXIST") )
         }
         break
      }
   }
}
