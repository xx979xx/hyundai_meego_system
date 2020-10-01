import QtQuick 1.0
import "../../DHAVN_VP_CONSTANTS.js" as CONST
//modified by aettie 20130621 for component changed
Item {
   id: rootItem
   anchors.top: parent.top
   anchors.left: parent.left
   anchors.leftMargin: 720
   width: 490
   height:540

   Text {
      id: sText
      width: CONST.const_FS_CAPTION_TEXT_WIDTH
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      wrapMode: Text.WordWrap
      text: qsTranslate(CONST.const_LANGCONTEXT,QT_TR_NOOP("STR_MEDIA_CAPTION_SETTING_TYPE_INFO"))
      color: CONST.const_FONT_COLOR_BRIGHT_GREY
      font.family: CONST.const_FONT_FAMILY_NEW_HDR 
      font.pointSize: CONST.const_FS_CAPTION_TEXT_SIZE  
      horizontalAlignment: Text.Center
      verticalAlignment: Text.Center
   }
}
