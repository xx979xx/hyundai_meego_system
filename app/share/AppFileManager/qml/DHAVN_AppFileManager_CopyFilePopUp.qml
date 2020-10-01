import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import PopUpConstants 1.0

Item
{
   id: root

   /** distination device to copy files */
   property int src: UIControl.currentDevice

   /** type of copied files */
   property int type: UIControl.currentFileType
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
     // title:  "STR_MEDIA_MNG_COPY_FILE" // modified by eugene.seo 2013.01.21 for ISV 69915
    //  icon_title: EPopUp.WARNING_ICON

      buttons: buttonModel

      onBtnClicked:
      {
         popupClosed()
         UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_CONFIRMATION )
      }

      Binding
      {
         target: popup
         property: "message"
         value: pictureModels.model
         when: type == UIDef.FILE_TYPE_PICTURE
      }

      Binding
      {
         target: popup
         property: "message"
         value: videoModels.model
         when: type == UIDef.FILE_TYPE_VIDEO
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

   Item
   {
      id: pictureModels

      property ListModel model: src == UIDef.DEVICE_JUKEBOX ? messagePictureUsbModel : messagePictureJukeBoxModel

      ListModel
      {
         id: messagePictureUsbModel
         ListElement
         {
            msg: QT_TR_NOOP("STR_MEDIA_MNG_COPY_LOCATION_USB")
         }
      }

      ListModel
      {
         id: messagePictureJukeBoxModel
         ListElement
         {
            msg: QT_TR_NOOP("STR_MEDIA_COPY_LOCATION_INFO_FILE_MANAGER")
         }
      }
   }

   Item
   {
      id: videoModels

      property ListModel model: src == UIDef.DEVICE_JUKEBOX ? messageVideoUsbModel : messageVideoJukeBoxModel

      ListModel
      {
         id: messageVideoUsbModel
         ListElement
         {
            msg: QT_TR_NOOP("STR_MEDIA_MNG_COPY_LOCATION_USB")
         }
      }

      ListModel
      {
         id: messageVideoJukeBoxModel
         ListElement
         {
            msg: QT_TR_NOOP("STR_MEDIA_COPY_LOCATION_INFO_FILE_MANAGER")
         }
      }
   }
}
