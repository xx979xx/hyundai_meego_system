import Qt 4.7

import "../../components"
import "../../models"
import "../../DHAVN_VP_CONSTANTS.js" as VP
import "../../DHAVN_VP_RESOURCES.js" as RES


Image
{
   property real verticalOffset: 0
   property real coverage: 0
   source: "/app/share/images/general/scroll_menu_list_bg.png"
   clip: true

   Image
   {
      id: image_s_id
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width - 2
      height: parent.height*coverage - 2
      y: parent.height*verticalOffset
      source: "/app/share/images/general/scroll_t.png"
   }
}
