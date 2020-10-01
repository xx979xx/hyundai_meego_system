import QtQuick 1.0

import "../System" as MSystem
MComponent{
    id: cueBg
    property bool isLeftBg: false
    //width: 1280//APP.const_APP_SETTINGS_MAIN_SCREEN_WIDTH
    //height: 720 - 93//APP.const_APP_SETTINGS_MAIN_SCREEN_HEIGHT
    anchors.top: parent.top

    MSystem.ImageInfo { id: imageInfo }
   property string imgFolderGeneral: imageInfo.imgFolderGeneral
    Image
    {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.topMargin:66
      source: imgFolderGeneral + "bg_menu.png"
    }

    Image
    {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.topMargin:73
      visible:isLeftBg
      source: imgFolderGeneral + "bg_menu_l_s.png"
    }

    Image
    {
      //anchors.left: parent.left
      anchors.left: parent.left
      anchors.leftMargin:585
      anchors.top: parent.top
      anchors.topMargin:73
      visible:!isLeftBg
      source:imgFolderGeneral + "bg_menu_r_s.png"
    }

//    Image
//    {
//       y: 32
//       x: 588
//       source: "/app/share/images/general/scroll_menu_bg.png"
//       visible: true //( list_view.count > 6 )
//       Item
//       {
//          height: list_view.visibleArea.heightRatio * 478
//          y: 478 * list_view.visibleArea.yPosition
//          Image
//          {
//             y: -parent.y
//             source: "/app/share/images/general/scroll_menu.png"
//          }
//          width: parent.width
//          clip: true
//       }
//    }




}
