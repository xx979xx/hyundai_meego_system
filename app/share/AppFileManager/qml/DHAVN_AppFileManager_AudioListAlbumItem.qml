import QtQuick 1.0
import "DHAVN_AppFileManager_Resources.js" as RES
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   height: FM.const_APP_FILE_MANAGER_AUDIO_ALBUM_LIST_ITEM_HEIGHT
   width: parent.width

   property string mainText
   property url icon
   property bool is_checked: false
   property bool isCurPlayed: false
   property variant listModel: ListModel{}

   function checked()
   {
      listModel.checkElement(index, !is_checked)
   }

   //Delimiter
   Image
   {
      id: delimeter
      anchors { left: parent.left; top: parent.top }
      anchors.leftMargin: FM.const_APP_FILE_MANAGER_AUDIO_LIST_DELIMETER_LEFT_MERGIN
      source: index > 0 ? RES.const_APP_FILE_MANAGER_AUDIO_LIST_DELIMITER_URL : ""
   }

   //Icon
   Image
   {
      id: icon_image
      height: FM.const_APP_FILE_MANAGER_AUDIO_LIST_ICON_SIZE
      width: FM.const_APP_FILE_MANAGER_AUDIO_LIST_ICON_SIZE
      anchors { left: parent.left; top: parent.top }
      anchors.leftMargin: FM.const_APP_FILE_MANAGER_AUDIO_ALBUM_ICON_LEFT_MERGIN
      anchors.topMargin: FM.const_APP_FILE_MANAGER_AUDIO_LIST_ITEM_ICON_TOP_MERGIN
      source: icon
   }

   //Main text
   Text
   {
      id: mainText
      text: root.mainText
      // { modified by edo.lee 2012.11.29 New UX
      //font.pixelSize: FM.const_APP_FILE_MANAGER_AUDIO_LIST_ITEM_FONT_SIZE
      font.pointSize: FM.const_APP_FILE_MANAGER_AUDIO_LIST_ITEM_FONT_SIZE
      // } modified by edo.lee
      color: FM.const_APP_FILE_MANAGER_AUDIO_LIST_ITEM_FONT_COLOR
      anchors { left: parent.left; top: parent.top }
      anchors.topMargin:
      {
         var value = FM.const_APP_FILE_MANAGER_AUDIO_LIST_ITEM_TEXT_TOP_MERGIN - mainText.height / 2
         return value
      }
      anchors.leftMargin: FM.const_APP_FILE_MANAGER_AUDIO_ALBUM_TEXT_LEFT_MERGIN
      width: FM.const_APP_FILE_MANAGER_AUDIO_TEXT_WIDTH
      clip: true
   }

   //Checked image
   Image
   {
      id: checked_image
      source: is_checked ? RES.const_APP_FILE_MANAGER_AUDIO_LIST_CHECKED_N_URL : RES.const_APP_FILE_MANAGER_AUDIO_LIST_UNCHECKED_N_URL
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.topMargin: FM.const_APP_FILE_MANAGER_AUDIO_LIST_ITEM_TOP_MERGIN
   }

   MouseArea
   {
      id: mouseArea_check
      anchors.fill: checked_image
      onClicked:
      {
         listModel.checkElement(index, !is_checked)
      }
   }
}
