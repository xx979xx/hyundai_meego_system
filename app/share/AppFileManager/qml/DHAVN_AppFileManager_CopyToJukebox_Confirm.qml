import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root
   // removed by ravikanth 24-07-13 for copy spec changes
   signal popupClosed()

   anchors.fill: parent

   property int popup_type: -1 // modified by ravikanth 21-07-13 for copy cancel confirm on delete

   MouseArea
   {
      anchors.fill: parent
   }

   function retranslateUi()
   {
      popup.retranslateUI(FM.const_APP_FILE_MANAGER_LANGCONTEXT)
   }

   function closePopup()
   {
       //UIControl.popupEventHandler( UIDef.POPUP_EVENT_JUKEBOX_COPY_CANCEL_CONFIRM )
       if(popup_type != UIDef.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM) //added by Michael.Kim 2013.09.25 ITS 191431
           UIControl.popupEventHandler( UIDef.POPUP_EVENT_CLEAR_STATE_TO_NONE ) // modified by ravikanth 21-07-13 for copy cancel confirm on delete
       else	// Added by sangmin.seol 2013.10.22 ITS 0195517 for reset sellect-all when copy confirm popup canceled
           UIControl.popupEventHandler( UIDef.POPUP_EVENT_CANCEL_COPY_ALL_FOR_COPY_CONFIRM )

       root.popupClosed()
   }

   //PopUpText
   DHAVN_AppFileManager_PopUp_Text
   {
      id: popup

      property int focus_x: 0
      property int focus_y: 0
      property string name: "PopUpText"
      focus_id: 0

      // title: QT_TR_NOOP("Add Tile here on UX request")
      message: messageModel
      buttons: buttonModel

      onBtnClicked:
      {
         switch ( btnId )
         {
            case "OkId":
            {
                root.popupClosed()
		// modified by ravikanth 21-07-13 for copy cancel confirm on delete
                if(popup_type == UIDef.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM)
                {
                    UIControl.popupEventHandler( UIDef.POPUP_EVENT_JUKEBOX_COPY_CANCEL_CONFIRM )
                }
                else
                {
                    UIControl.popupEventHandler( UIDef.POPUP_EVENT_CANCEL_COPY_FOR_DELETE_CONFIRM )
                }
            }
            break

            case "CancelId":
            {
                root.popupClosed()
                if(popup_type != UIDef.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM && popup_type != UIDef.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM) //modified for ITS 230427
                   UIControl.popupEventHandler( UIDef.POPUP_EVENT_CLEAR_STATE_TO_NONE )
                else	// Added by sangmin.seol 2013.10.22 ITS 0195517 for reset sellect-all when copy confirm popup canceled
                   UIControl.popupEventHandler( UIDef.POPUP_EVENT_CANCEL_COPY_ALL_FOR_COPY_CONFIRM )
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
         msg: QT_TR_NOOP("STR_MEDIA_CANCEL_COPY_TO_JUKEBOX")
      }
   }
   // modified by ravikanth 24-07-13 for copy cancel confirm on delete
   ListModel
   {
      id: messageModelDeleteConfirm
      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_CANCEL_COPY_FOR_DELETE")
      }
   }

   ListModel
   {
      id: messageModelClearJukeboxConfirm
      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_CANCEL_COPY_FOR_CLEAR_JUKEBOX")
      }
   }

   Binding
   {
      target: popup
      property: "message"
      value: messageModel
      when: popup_type == UIDef.POPUP_TYPE_COPY_TO_JUKEBOX_CONFIRM
   }

   Binding
   {
      target: popup
      property: "message"
      value: messageModelDeleteConfirm
      when: popup_type == UIDef.POPUP_TYPE_CANCEL_COPY_FOR_DELETE_CONFIRM
   }

   Binding
   {
      target: popup
      property: "message"
      value: messageModelClearJukeboxConfirm
      when: popup_type == UIDef.POPUP_TYPE_CANCEL_COPY_FOR_CLEAR_JUKEBOX_CONFIRM
   }
}
