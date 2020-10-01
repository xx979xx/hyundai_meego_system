import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import PopUpConstants 1.0

Item
{
   id: root

   /** Total files size */
   property int filesSize : UIControl.getFilesSize()

   /** Copied files count */
   property int filesCount : UIControl.getFilesCount()
   //property int remainCapacity;

   signal popupClosed()
   property int popup_type: -1 // modified by ravikanth 23-07-13 for popup close on relaunch

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
       UIControl.popupEventHandler( UIDef.POPUP_EVENT_CAPACITY_ERROR_CONFIRM ) // modified for ITS 0188765
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

      //title: "  " //deleted by aettie 2031.04.01 ISV 78226
      //{ added by yongkyun.lee 20130315 for : ITS 157781 ,141428
      icon_title: EPopUp.NONE_ICON;
      //icon_title: EPopUp.WARNING_ICON;
      //} added by yongkyun.lee 20130315 
      buttons: buttonModel

      onBtnClicked:
      {
         popupClosed()

          switch ( btnId )
          {
             case "OkId":
             {
                UIControl.popupEventHandler( UIDef.POPUP_EVENT_CAPACITY_ERROR_CONFIRM )
             }
             break

// removed by Dmitry 02.08.13 for new spec
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
            msg: QT_TR_NOOP("STR_MEDIA_OK_BUTTON")
            btn_id: "OkId"
        }
// removed by Dmitry 02.08.13 for new spec
    }

    ListModel
    {
        id: messageModel
    }

    Component.onCompleted:
    {
        messageModel.clear()
	// modified by ravikanth 14-08-13 for ISV 88691
        //var totalCapacity = Math.round(UIControl.getJukeboxCapacity() * 100) / 100;
        //var usedSpace = Math.round(UIControl.getJukeboxUsedSize() * 100) / 100;
        //remainCapacity = totalCapacity - usedSpace
        var remainCapacity = Math.round(UIControl.RemainedCapacity() * 100) / 100

        // { modified by ravikanth for 20.06.13 ITS 0175115;

	// { modified by ravikanth for 27.08.13 ITS 0175115, ITS 186712
        if(remainCapacity < 1024) // 1024 = 1GB
        {
            if(filesSize < 1024)
            {
                messageModel.append(
                            { "msg" : QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_NO_FREE_SPACE"),
                            "arguments":[{ "arg1" : filesCount}, { "arg1" : filesSize}, {"arg1" : remainCapacity}] } )
            }
            else
            {
                messageModel.append(
                            { "msg" : QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_NO_FREE_SPACE_COPYSIZE_GB"),
                            "arguments":[{ "arg1" : filesCount}, { "arg1" : ( Math.round((filesSize/1024)*100) / 100 ) }, {"arg1" : remainCapacity}] } )
            }
        }
        else
        {
            var remainCapacityGB = Math.round((UIControl.RemainedCapacity()/1024) * 100) / 100
            messageModel.append(
                        { "msg" : QT_TR_NOOP("STR_MEDIA_MNG_FILE_COPY_NO_FREE_SPACE_GB"),
                        "arguments":[{ "arg1" : filesCount}, { "arg1" : ( Math.round((filesSize/1024)*100) / 100 ) }, {"arg1" : remainCapacityGB }] } )
        }
	// } modified by ravikanth for 20.06.13 ITS 0175115
    }
}
