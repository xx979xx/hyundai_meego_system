import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import PopUpConstants 1.0

Item
{
   id: root

   /** Replaced file name */
   property string replacedFile
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
//deleted by aettie 2031.04.01 ISV 78226
      //title: " "
      //icon_title: EPopUp.WARNING_ICON;
      message: messageModel
      buttons: buttonModel

//{Changed by Alexey Edelev 2012.10.05 CR14235
      onBtnClicked:
      {
          popup.disappearePopUp()
      }

      Timer {
          id: popupDisappeareTimer
          interval: 3000
          repeat: false
          triggeredOnStart: false
          onTriggered: {
              popup.disappearePopUp()
          }
      }

      Component.onCompleted: {
          popupDisappeareTimer.start()
      }

      onVisibleChanged: {
          if(visible) {
              popupDisappeareTimer.start()
          } else {
              popupDisappeareTimer.stop()
          }
      }

      function disappearePopUp() {
          popupClosed()

          root.popupClosed()
          UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_CANCEL_CONFIRM )

          popupDisappeareTimer.stop()
      }
      //}Changed by Alexey Edelev 2012.10.05 CR14235
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
        	// { modified by edo.lee 2012.12.28 ITS 153515
            //msg: QT_TR_NOOP("File cannot be copied.This file is corrupted or unavailable format.")
            msg: QT_TR_NOOP("STR_MEDIA_MNG_ERROR_CORRUPTED")
            // } modified by edo.lee

        }
    }
}

