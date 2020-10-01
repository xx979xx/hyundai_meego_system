import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   property int popup_type: -1 // modified by ravikanth 23-07-13 for popup close on relaunch
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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_FRAME_REPLACE_CANCEL ) // modified by ravikanth 05-07-13 for ITS 0178514
   }

   DHAVN_AppFileManager_PopUp_Text
   {
      id: popup

      property int focus_x: 0
      property int focus_y: 0
      property string name: "PopUpText"
      focus_id: 0

      buttons: buttonModel

      onBtnClicked:
      {
         popupClosed()

          switch ( btnId )
          {
             case "YesId":
             {
                UIControl.popupEventHandler( UIDef.POPUP_EVENT_REPLACE )
             }
             break

             case "CancelId":
             {
                 UIControl.popupEventHandler( UIDef.POPUP_EVENT_FRAME_REPLACE_CANCEL ) // modified by ravikanth 05-07-13 for ITS 0178514
             }
             break
          }
      }

      Binding
      {
         target: popup
         property: "message"
         value: messageModel
      }
   }

    ListModel
    {
        id: buttonModel

        ListElement
        {
            msg: QT_TR_NOOP("STR_MEDIA_MNG_YES")
            btn_id: "YesId"
        }

        ListElement
        {
            msg: QT_TR_NOOP("STR_MEDIA_MNG_NO") // modified by ravikanth 10-07-13 for ITS 0166999
            btn_id: "CancelId"
        }
    }

    ListModel
    {
        id: messageModel
    }

    Component.onCompleted:
    {
        messageModel.append({"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_REPLACE_JUKEBOX_MYFRAME"),
                         "arg1": UIControl.getProcessedFile()})
    }
}
