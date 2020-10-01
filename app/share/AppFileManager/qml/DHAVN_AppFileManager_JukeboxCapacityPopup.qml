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
   }
   // } added by  yongkyun.lee

   //PopUpTextProgressBar
   DHAVN_AppFileManager_PopUp_TextProgressBar
   {
      id: popup

      property string name: "PopUpTextProgressBar"

      //title: ""
      message: messageModel
      buttons: buttonModel
      progressMin: 0
      progressMax: 100
      progressCur: 0
      useRed: true // added by Dmitriy Bykov 2012.09.24 for CR 11336

      onBtnClicked:
      {
         UIControl.popupEventHandler( UIDef.POPUP_EVENT_JUKEBOX_CAPACITY_OK )
         popupClosed()
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
   }

   Component.onCompleted:
   {
// modified by ruindmby 2012.08.22 for CR 12454
      // modified by ravikanth 21-08-13 for ITS 0185418
      var totalCapacity = UIControl.getJukeboxCapacity()
      var usedSpace = UIControl.getJukeboxUsedSize()
      var percenatgeUsed = 0.0
      messageModel.clear()

      if (totalCapacity > 0)
      {
          percenatgeUsed =  usedSpace / totalCapacity * 100
          percenatgeUsed = parseFloat(percenatgeUsed).toFixed(2)
          percenatgeUsed = (percenatgeUsed > 100) ? 100 : percenatgeUsed
          totalCapacity = parseFloat(totalCapacity/1024).toFixed(2);
      }	  
      // { added by eugene.seo 2013.06.05
      if(usedSpace < 1024)
      {
         //var usedSpace = Math.round(usedSpace * 1000);
         usedSpace =  parseFloat(usedSpace).toFixed(2);
         messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_JUKEBOX_USAGE_MB"),
                              arguments:[{ "arg1" : percenatgeUsed },
                                         { "arg1" : usedSpace },
                                         { "arg1" : totalCapacity }] })
      }
      else
      {
         usedSpace =  parseFloat(usedSpace/1024).toFixed(2);
         messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_JUKEBOX_USAGE"),
                              arguments:[{ "arg1" : percenatgeUsed },
                                         { "arg1" : usedSpace },
                                         { "arg1" : totalCapacity }] })
      }
      // } added by eugene.seo 2013.06.05
// modified by ruindmby 2012.08.22 for CR 12454    
      popup.progressCur = percenatgeUsed
   }
}
