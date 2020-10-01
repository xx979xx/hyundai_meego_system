import QtQuick 1.0
//import QmlPopUpPlugin 1.0
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../popUp"
Item {
   id: progressPopUp

   property int copyPercentage: video_model.copyPercentage
   anchors.fill: parent
   //signal lostFocus(); //added by edo.lee 

   Component.onCompleted:
   {
      messageModel.clear()
      messageModel.append( { "msg": QT_TR_NOOP("STR_MEDIA_MNG_COPYING_FORMATTED"), "arg1" : 1 } )
      messageModel.append( {"msg": QT_TR_NOOP("STR_MEDIA_MNG_REMAINED_PROGRESS"), "arg1": progressPopUp.copyPercentage })
   }

   onCopyPercentageChanged:
   {
      messageModel.set(1, {"msg": QT_TR_NOOP("STR_MEDIA_MNG_REMAINED_PROGRESS"), "arg1": (progressPopUp.copyPercentage) }) // modified by wspark 2012.08.21 for DQA #47
   }

   //PopUpTextProgressBar
   DHAVN_MP_PopUp_TextProgressBar// added by edo.lee 2013.01.17
   {
      id: popup
      //anchors.verticalCenter: parent.verticalCenter
      //anchors.horizontalCenter: parent.horizontalCenter

      //title: QT_TR_NOOP("STR_MEDIA_MNG_COPY_FILE")
      message: messageModel
      buttons: buttonModel
      progressMin: CONST.const_POPUP_PROGRESS_MIN_VAL
      progressMax: CONST.const_POPUP_PROGRESS_MAX_VAL
      progressCur: video_model.copyPercentage

      onBtnClicked:
      {
      	if(!popup.visible) return;//added by edo.lee 01.19
         controller.onCancelClicked()
      }
   }

   ListModel
   {
      id: buttonModel

      ListElement
      {
         msg: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
         btn_id: "CancelId"
      }
   }

   ListModel
   {
      id: messageModel
   }
}
