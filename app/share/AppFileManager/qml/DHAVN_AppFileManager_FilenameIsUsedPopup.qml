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

      //title: " "
     // icon_title: EPopUp.WARNING_ICON;
      message: messageModel
      buttons: buttonModel

      onBtnClicked:
      {
         popupClosed()

          switch ( btnId )
          {
             case "OkId":
             {
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
            msg: QT_TR_NOOP("STR_MEDIA_OK_BUTTON")
            btn_id: "OkId"
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
          case UIDef.POPUP_TYPE_FOLDER_IS_USED:
          {
             messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_MEDIA_MNG_CANNOT_CHANGE_FOLDERNAME") )
          }
          break

          case UIDef.POPUP_TYPE_FILE_IS_USED:
          {
             messageModel.setProperty( 0, "msg", QT_TR_NOOP("STR_MEDIA_MNG_CANNOT_CHANGE_FILENAME") )
          }
          break
       }
    }
}
