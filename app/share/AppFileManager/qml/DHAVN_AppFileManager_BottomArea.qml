import QtQuick 1.0

import "DHAVN_AppFileManager_General.js" as FM

DHAVN_AppFileManager_FocusedItem
{
   id: root

   property ListModel btnModel: ListModel{}

   signal btnPressed( variant btId );

   width: FM.const_APP_FILE_MANAGER_BOTTOMAREA_WIDTH
   height: FM.const_APP_FILE_MANAGER_BOTTOMAREA_HEIGHT

   Component
   {
      id: btnDelegate

      Image
      {
         id: btn_image

         width: FM.const_APP_FILE_MANAGER_BOTTOMAREA_WIDTH / btnModel.count
         fillMode: Image.TileHorizontally

         Image
         {
            anchors.right: parent.right
            source: "/app/share/images/general/btn_bottom_line_n.png"
            visible: index < btnModel.count - 1
         }

         Text
         {
            anchors.centerIn: parent
            text: qsTranslate(FM.const_APP_FILE_MANAGER_LANGCONTEXT, name) + LocTrigger.empty
            color: FM.const_APP_FILE_MANAGER_BOTTOMAREA_TEXT_COLOR
            // { modified by edo.lee 2012.11.29 New UX
            //font.pixelSize: FM.const_APP_FILE_MANAGER_BOTTOMAREA_FONT_SIZE
            font.pointSize: FM.const_APP_FILE_MANAGER_BOTTOMAREA_FONT_SIZE
            // { modified by edo.lee
         }

         Binding
         {
            target: btn_image
            property: "source"
            value: "/app/share/images/general/bottom_tab_n.png"
            when: !mouseArea.pressed
         }

         Binding
         {
            target: btn_image
            property: "source"
            value: "/app/share/images/general/bottom_tab_s.png"
            when: mouseArea.pressed
         }

         MouseArea
         {
            id: mouseArea

            anchors.fill: parent

            onClicked:
            {
               btnPressed(btId)
            }
         }
      }
   }

   Row
   {
      Repeater
      {
         model: btnModel
         delegate: btnDelegate
      }
   }
}
