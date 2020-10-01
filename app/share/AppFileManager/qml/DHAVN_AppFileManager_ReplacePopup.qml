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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_REPLACE_CANCEL )
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

     // title: QT_TR_NOOP("STR_MEDIA_MNG_COPY_FILE") //deleted by aettie 2031.04.01 ISV 78226
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

             case "YesAllId":
             {
                UIControl.popupEventHandler( UIDef.POPUP_EVENT_REPLACE_ALL )
             }
             break

             case "NoId":
             {
                 UIControl.popupEventHandler( UIDef.POPUP_EVENT_NO_REPLACE )
             }
             break

             case "CancelId":
             {
	         // { modified by eugene.seo 2013.06.07
		 // modified by ravikanth 18.03.13 for ISV 0174610
                 UIControl.popupEventHandler( UIDef.POPUP_EVENT_REPLACE_CANCEL )
                 // UIControl.popupEventHandler( UIDef.POPUP_EVENT_COPY_CANCEL )
 	         // } modified by eugene.seo 2013.06.07
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
            //msg: QT_TR_NOOP("Yes")
            msg: QT_TR_NOOP("STR_MEDIA_MNG_YES") // modified by  eunhye 2012.11.20 No CR
            btn_id: "YesId"
        }

        ListElement
        {
            msg: QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_ALL")
            btn_id: "YesAllId"
            is_dimmed: false // modified by ravikanth 07-07-13 for ITS 0178184
        }

        ListElement
        {
            //msg: QT_TR_NOOP("No")
            msg: QT_TR_NOOP("STR_MEDIA_MNG_NO") // modified by  eunhye 2012.11.20 No CR
            btn_id: "NoId"
        }

        ListElement
        {
            msg: QT_TR_NOOP("STR_MEDIA_CANCEL_BUTTON")
            btn_id: "CancelId"
        }
    }

    ListModel
    {
        id: messageModel
    }

    Component.onCompleted:
    {
        messageModel.append({"msg": QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_REPLACE"),
                         "arg1": UIControl.getProcessedFile()})
	// modified by ravikanth 07-07-13 for ITS 0178184			 
        if(UIControl.currentCopyReplaceCount() == 1)
        {
            buttonModel.get(1).is_dimmed = true
        }
        else
        {
            buttonModel.get(1).is_dimmed = false
        }
    }
}
