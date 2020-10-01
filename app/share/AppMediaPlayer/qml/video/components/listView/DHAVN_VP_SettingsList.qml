import Qt 4.7
import "../../components"
import "../../models"
import "../../DHAVN_VP_CONSTANTS.js" as VP
import "../../DHAVN_VP_RESOURCES.js" as RES


ListView
{
   id: titleListView
   clip: true
   delegate: item_delegate
   highlight: item_highlight
   currentIndex: 0
   model: menu_model
   //cacheBuffer: 1000

   property variant menu_model: null
   property int currentTitleOrChapter: 0
   property string sListType: "title"
   property bool isListActive: true
   property real contentBottom: contentY + height

   property int upperVisibleIndex:  0
   property int lowerVisibleIndex: model.count > 0 ? (model.count > 6? 6:model.count): 0




Component
{
   id: item_delegate

   Item
   {
      id: item

      height: VP.const_TITLE_LIST_ITEM_HEIGHT
      width: parent.width


      property bool isVisible :  (((index * height) >= ListView.view.contentY &&
                                 (index * height) <= ListView.view.contentBottom) ||
                                 ((index * height) + height >= ListView.view.contentY &&
                                 (index * height) + height <= ListView.view.contentBottom))

      property bool selected: index == titleListView.currentTitleOrChapter && titleListView.isListActive



      onIsVisibleChanged:
      {
       if (isVisible)
       {
         if ( titleListView.upperVisibleIndex < 0 || titleListView.upperVisibleIndex > index)
         {
            titleListView.parent.upperVisibleIndex = index
         }
         if (titleListView.lowerVisibleIndex < 0 || titleListView.lowerVisibleIndex < index)
         {
            titleListView.lowerVisibleIndex = index
         }
       }
       else
       {
           if(titleListView.upperVisibleIndex == index) titleListView.upperVisibleIndex++
           if(titleListView.lowerVisibleIndex == index) titleListView.lowerVisibleIndex--
        }
      }

      function selectSource(selected)
      {
          var source = "/app/share/images/video/";
          if(titleListView.sListType == "title")
          {
             source += (selected ? "ico_title_s.png": "ico_title_n.png")
          }
          else
          {
             source += (selected ? "ico_chapter_s.png": "ico_chapter_n.png")
          }
          return source
      }


      Image
      {
         id: line_id
         anchors.top: parent.top
         anchors.horizontalCenter: parent.horizontalCenter
         width: parent.width
         source: (index > 0 ? (titleListView.isListActive ?"/app/share/images/general/line_menu_list.png":"/app/share/images/general/list_line.png") : "")
      }

      Image
      {
         id: image_p_id
         anchors.top: parent.top
         anchors.horizontalCenter: parent.horizontalCenter
         width: parent.width
         source: "/app/share/images/general/bg_menu_tab_l_p.png"
         visible: mouse_area.pressed
      }

      Image
      {
         id: image_s_id
         anchors.top: parent.top
         anchors.horizontalCenter: parent.horizontalCenter
         width: parent.width
         source: "/app/share/images/general/bg_menu_tab_l_s.png"
         visible: item.selected
      }

      Image
      {
         id: ico_title
         anchors.verticalCenter: parent.verticalCenter
         x: 11
         width: 54
         height: 54
         source: selectSource(item.selected)
      }

      Text
      {
         id: text_id
         property string title_text: QT_TR_NOOP("STR_MEDIA_TITLE")
         anchors.left: image_p_id.left
         anchors.leftMargin: 87
         anchors.bottom: parent.bottom
         width: parent.width
         anchors.bottomMargin: VP.const_SEARCH_CHAPTER_ITEM_TEXT_BOTTOM_MARGIN - text_id.height / 2
         text: qsTranslate(VP.const_LANGCONTEXT, title_text) + " " + itemName + LocTrigger.empty
         color: item.selected? VP.const_FONT_COLOR_BLACK:VP.const_FONT_COLOR_BRIGHT_GREY
         font.family: VP.const_FONT_FAMILY_NEW_HDB
         font.pointSize: 40 //modified by aettie.ji 2012.11.28 for uxlaunch update
      }

      MouseArea
      {
         id: mouse_area
         anchors.fill: parent

         onClicked:
         {
            titleListView.currentTitleOrChapter = index
            titleListView.isListActive = true
            controller.onTitleClicked(index+1)
         }
      }
   }
}

Component
{
   id: item_highlight

   Item
   {
      height: VP.const_TITLE_LIST_ITEM_HEIGHT
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width
      visible: true

      Image
      {
         id: focus_image
         anchors.left: parent.left
         anchors.bottom: parent.bottom
         anchors.top: parent.top
         anchors.right: parent.right
         source: "/app/share/images/general/bg_menu_tab_l_f.png"
      }
   }
}

}

