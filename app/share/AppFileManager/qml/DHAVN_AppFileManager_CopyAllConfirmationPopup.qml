import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_ALL_CANCEL_CONFIRMATION )
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

      // title: QT_TR_NOOP("STR_MEDIA_MNG_COPY_ALL") // deleted by lssanh 2013.03.23 NoCR copyall cancel // modified by eugene.seo 2013.01.21 for ISV 69915
      message: messageModel
      buttons: buttonModel

      onBtnClicked:
      {
         switch ( btnId )
         {
            case "OkId":
            {
               //UIControl.setCopyAllStatus(true) // add by wspark 2012.07.25 for CR12226. //deleted by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
               root.popupClosed()
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_ALL_CONFIRMATION )
            }
            break

            case "CancelId":
            {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_ALL_CANCEL_CONFIRMATION )
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
         msg: QT_TR_NOOP("STR_MEDIA_MNG_YES")
         btn_id: "OkId"
      }
      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_MNG_NO")
         btn_id: "CancelId"
      }
   }

   ListModel
   {
      id: messageModel
      ListElement
      {
      // modified by ravikanth for 19.06.13 SMOKE_TC 7 & SANITY_CM_AK347
         msg: QT_TR_NOOP("STR_MEDIA_MNG_POPUP_COPY_ALL") //deleted by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
         //msg: QT_TR_NOOP("STR_MEDIA_COPY_CANCEL_INFO") //added by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
      }
   }
}
