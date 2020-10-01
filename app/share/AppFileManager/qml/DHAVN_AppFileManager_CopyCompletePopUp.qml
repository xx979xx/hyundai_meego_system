import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root
   property int skipcount: UIControl.currentCopySkipCount // modified by ravikanth 22-04-13
   property int totalFileCount: UIControl.currentCopyTotalCount // modified by ravikanth 22-04-13

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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_COMPLETE_POPUP_CLOSED );
       popupClosed()
   }
   // } added by  yongkyun.lee 

   //PopUpDimmed
   DHAVN_AppFileManager_PopUp_Dimmed // modified by eunhye 2013.03.20
   {
      id: popup

      message: messageModel

      onClosed:
      {
          UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_COMPLETE_POPUP_CLOSED );
          popupClosed()
      }
   }

   ListModel
   {
      id: messageModel

      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_MNG_COPY_COMPLETED")
      }
   }
   
   // { modified by ravikanth 22-04-13  
   ListModel
   {
      id: messageModelPartialCopy
   }

   Binding
   {
       target: popup
       property: "message"
       value: messageModel
       when: UIControl.currentCopySkipCount == 0
   }

   Binding
   {
       target: popup
       property: "message"
       value: messageModelPartialCopy
       when: UIControl.currentCopySkipCount > 0
   }

   Component.onCompleted:
   {
      messageModelPartialCopy.clear()
      messageModelPartialCopy.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_COPY_COMPLETED_PARTIAL"),
                                     arguments:[{ "arg1" : ( totalFileCount - skipcount ) },
                                                { "arg1" : totalFileCount }]} ) // modified by ravikanth 09-07-13 for SMOKE localization string change
   }
   // } modified by ravikanth 22-04-13
}
