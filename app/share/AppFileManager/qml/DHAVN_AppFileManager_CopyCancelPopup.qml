import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import AppEngineQMLConstants 1.0 // added by Michael.Kim 2014.08.12 to use UIListenerEnum value

Item
{
   id: root

   signal popupClosed()

   anchors.fill: parent

   property int popup_type: -1 // modified by ravikanth 23-07-13 for popup close on relaunch

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
       EngineListener.qmlLog("closePopup getCurrentScreen() = " + UIListener.getCurrentScreen());
       StateManager.breakCopyMode(); // modified by Michael.Kim 2014.10.07 for ITS 248905
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_RESTART ) // modified by Michael.Kim 2014.08.31 for ITS 242932
       root.popupClosed()
   }
   // } added by  yongkyun.lee 

   // {added by Michael.Kim 2014.07.31 for ITS 242932
   Connections {
      target: EngineListener
      onRestartToCopy:
      {
          UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_RESTART )
      }
   }
   // }added by Michael.Kim 2014.07.31 for ITS 242932

   //PopUpText
   DHAVN_AppFileManager_PopUp_Text
   {
      id: popup

      property int focus_x: 0
      property int focus_y: 0
      property string name: "PopUpText"
      focus_id: 0

      //title: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_TITLE") //deleted by aettie 2031.04.01 ISV 78226
      message: messageModel
      buttons: buttonModel

      onBtnClicked:
      {
         switch ( btnId )
         {
            case "OkId":
            {
               root.popupClosed()
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_CANCEL_CONFIRM )
            }
            break

            case "CancelId":
            {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_CONTINUE )
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
      	// { modifed by edo.lee 2012.12.13 ISV 64508
         //msg: QT_TR_NOOP("STR_MEDIA_MNG_KEEP_COPYING")
         // modified by ravikanth 24-07-13 for ITS 0181565 change string from Continue_Copy to No
         //msg: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL_FILE_COPY_CONTINUE")
          msg: QT_TR_NOOP("STR_MEDIA_MNG_NO")
        // } modifed by edo.lee
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
