import QtQuick 1.0
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../DHAVN_VP_RESOURCES.js" as RES

Item {

   id: playbackInfoRoot

   //visible: (video_model.playbackStatus == 1)? true: false
   visible: false  //modified by aettie.ji 2012.11.12 for New UX

   anchors.left: parent.left
   anchors.leftMargin: CONST.const_POPUP_PBINFO_ROOT_LEFT_OFFSET
   anchors.top: parent.top
   anchors.topMargin: CONST.const_POPUP_PBINFO_ROOT_TOP_OFFSET

   Image {
      id: backgroundImg
      anchors.centerIn: parent.Center
      source: RES.const_URL_IMG_PB_INFO_BG
      visible: parent.visible

   }
   Image {
      id: stateImg

      anchors.left: backgroundImg.left
      anchors.leftMargin: CONST.const_POPUP_PBINFO_PAUSE_LEFT_OFFSET
      anchors.top: backgroundImg.top
      anchors.topMargin: CONST.const_POPUP_PBINFO_PAUSE_TOP_OFFSET
      source: RES.const_URL_IMG_PB_INFO_PAUSE
   }
}
