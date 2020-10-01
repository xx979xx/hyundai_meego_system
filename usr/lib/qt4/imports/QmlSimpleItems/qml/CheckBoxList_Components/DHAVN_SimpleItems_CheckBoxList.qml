import Qt 4.7
import "DHAVN_SimpleItems_CheckBoxList.js" as HM

Item
{
   id: root

   //List model
   property ListModel checkBoxListModel: ListModel {}
   property ListView checkBoxListView: list

   //Properties for the main text
   property string font_type  // font type of the main text
   property int font_size     // font size of the main text
   property string font_color // font color of the main text
   property int font_size_checked       // font size of the checked main text
   property string font_color_selected   // font color of the checked main text

   property string font_type_list_index  // font type of the list index text
   property int font_size_list_index     // font size of the list index text
   property string font_color_list_index // font color of the list index text

   //Properties for the second text
   property string font_type2    // font type of the second text
   property int font_size2       // font size of the second text
   property string font_color2   // font color of the second text

   //Properties for the checked image
   property url img_checked_n    // image for checked item, not disabled
   property url img_unchecked_n  // image for unchecked item, not disabled
   property url img_checked_d    // image for checked item, disabled
   property url img_unchecked_d  // image for unchecked item, disabled

   //Property for highlight image
   property url img_checked_f      // image for hilighting item

   property string img_item_selected // image for selected item bg
   property string img_item // image for selected item bg
   property url img_item_selected_bg // image for selected item bg
   property url img_item_bg // image for unselected item bg
   property url img_item_pressed_bg // image for pressed item bg
   property url img_item_focused_bg // image for focused item bg

   property int item_focused_bg_leftOffset // left offset for image for focused item bg
   property int item_focused_bg_topOffset // top offset for image for focused item bg
   property int item_selected_bg_leftOffset // left offset for image for selected item bg
   property int item_selected_bg_topOffset // top offset for image for selected item bg

   property url img_footer

   property url img_bg_list_index // image for bg list index

   //Properties for the list row
   property int row_height       // height of the list row
   property url img_delimiter    // image used as row delimiter

   property int delimiter_leftOffset // row delimiter left offset
   property int delimiter_height     // row delimiter left height

   //Layout properties
   property bool is_text_vcentered  // if true - main text is vertically centered
   property bool is_text_hcentered  // if true - main text is horizontally centered
   property int text_bottomOffset   // bottom offset for the main text (used when not vcentered)
   property int text_leftOffset     // left offset for the main text
   property int text2_rightOffset   // right offset of the second text (when it is right aligned)
   property int text2_leftOffset    // left offset of the second text (when it is left aligned)
   property int text2_bottomOffset  // bottom offset of the second text (when it is at the second line)
   property bool is_2line_text      // true, if second text in the second line,
                                    // false, if second text is at the right side

   property int list_index_text_leftOffset //left offset for the list index text
   property int footer_leftOffset
   property int icon_image_leftOffset // left offset of the icon image
   property int icon_image_topOffset // top offset of the icon image

   property int icon_image_height

   property bool is_checkable: true
   property bool is_items_selectable: false
   property string select_property
   property int select_leftOffset
   property int select_height
   property bool unselect_item_on_next_click: false
   property bool is_interative: true
   property bool select_item: false
   property int selected_item_index
   property int item_selection_topOffset

   // Highlight properties
   property int highLightPosition: 0
   property bool highlightVisible: false

   property int focusIndex: -1

   signal item_clicked(variant index, variant itemId);
   signal item_checked(variant checked, variant index, variant itemId, bool bFingerClick );
   signal item_selected(variant selected, variant index, variant itemId);
   signal checkBoxList_lostFocus(variant direction );

   onHighlightVisibleChanged:
   {
       if( highLightPosition != list.currentIndex )
           highLightPosition = list.currentIndex

       if( highlightVisible )
       {
           root.checkBoxListModel.get( highLightPosition ).highlight = true;
       }
       else
       {
           root.checkBoxListModel.get( highLightPosition ).highlight = false;
       }
   }

   function setSection()
   {
      if (is_items_selectable && select_item)
      {
         root.checkBoxListModel.get( root.selected_item_index ).is_item_selected = true
         return root.selected_item_index
      }
      return -1
   }

   function wheelRight()
   {
       if( highlightVisible == false )
       {
           highlightVisible = true;
           return;
       }

       if(highLightPosition != -1)
           root.checkBoxListModel.get( highLightPosition ).highlight = false
       highLightPosition += 1;
       if( highLightPosition == root.checkBoxListModel.count )
           highLightPosition = 0;
       root.checkBoxListModel.get( highLightPosition ).highlight = true
       list.currentIndex = highLightPosition;
   }

   function pickOnSelected()
   {
       if( highlightVisible == false ||
           root.checkBoxListModel.get( highLightPosition ).is_disabled == true )
           return;

       if( root.checkBoxListModel.get( highLightPosition ).is_checked == true )
            root.checkBoxListModel.get( highLightPosition ).is_checked = false
       else
           root.checkBoxListModel.get( highLightPosition ).is_checked = true

       item_checked( root.checkBoxListModel.get( highLightPosition ).is_checked, highLightPosition, root.checkBoxListModel.get( highLightPosition ).itemId, false )
   }

   function wheelLeft()
   {
       if( highlightVisible == false )
       {
           highlightVisible = true;
           return;
       }

       if(highLightPosition != -1)
           root.checkBoxListModel.get( highLightPosition ).highlight = false
       highLightPosition -= 1;
       if( highLightPosition == -1 )
           highLightPosition = root.checkBoxListModel.count - 1;
       root.checkBoxListModel.get( highLightPosition ).highlight = true
       list.currentIndex = highLightPosition;
   }

   function focusDown()
   {
      if( focusIndex < 0 )
      {
         return
      }

      var throwlostFocus = false

      if (arguments.length == 1)
      {
         throwlostFocus = arguments[0]
      }

      ++focusIndex;

      if( focusIndex >= root.checkBoxListModel.count )
      {
         focusUpper()
         if(throwlostFocus)
         {
            checkBoxList_lostFocus(HM.const_CHECKBOX_LIST_LOWER_FOCUS_LOST)
         }
      }
   }

   function focusUp()
   {
      if( focusIndex < 0 )
      {
         return
      }

      var throwlostFocus = false

      if (arguments.length == 1)
      {
         throwlostFocus = arguments[0]
      }

      --focusIndex;

      if( focusIndex < 0 )
      {
         focusLower()
         if(throwlostFocus)
         {
            checkBoxList_lostFocus(HM.const_CHECKBOX_LIST_UPPER_FOCUS_LOST)
         }
      }
   }

   function focusUpper()
   {
      focusIndex = 0;
   }

   function focusLower()
   {
      focusIndex = root.checkBoxListModel.count-1;
   }

   function focusClear()
   {
      focusIndex = -1;
   }

   function handleJogEvent(jogEvent)
   {
      if (focusIndex < 0)
      {
         return
      }

      if (jogEvent == HM.const_JOG_EVENT_WHEEL_LEFT ||
          jogEvent == HM.const_JOG_EVENT_ARROW_DOWN)
      {
         focusDown(jogEvent == HM.const_JOG_EVENT_ARROW_DOWN)
      }

      else if (jogEvent == HM.const_JOG_EVENT_WHEEL_RIGHT ||
               jogEvent == HM.const_JOG_EVENT_ARROW_UP)
      {
          focusUp(jogEvent == HM.const_JOG_EVENT_ARROW_UP)
      }

   }


   property int selectedItemIndex: setSection()

   function retranslateUI( context )
   {
       if ( context ) { __lang_context = context }
       __emptyString = " "
       __emptyString = ""
   }

   property string __lang_context: HM.const_CHECKBOX_LANGCONTEXT
   property string __emptyString: ""

   Item
   {
      id: listArea
      width: root.width
      height: root.height

      Component
      {
         id: listDelegate

         Column
         {
            id: columnId
            //List item
            DHAVN_SimpleItems_CheckBoxListItem
            {
               property ListModel listModel: checkBoxListModel
               property int focusWidth:root.checkBoxListModel.get( index ).focuswidth ?
                                        root.checkBoxListModel.get( index ).focuswidth : 0

               id: item
               text: qsTranslate( __lang_context, root.checkBoxListModel.get( index ).text ) + __emptyString
               text2: root.checkBoxListModel.get( index ).text2 ? qsTranslate( __lang_context, root.checkBoxListModel.get( index ).text2 ) + __emptyString : ""
               font_type: root.font_type
               font_type2: root.font_type2 ? root.font_type2 : root.font_type
               font_size: root.font_size
               font_color: root.font_color
               font_color_selected: root.font_color_selected ? root.font_color_selected : root.font_color
               font_size2: root.font_size2
               font_color2: root.font_color2
               width: root.width
               height:  root.row_height + (index == 0  ? item_selection_topOffset : 0)
               is_disabled: root.checkBoxListModel.get( index ).is_disabled ? root.checkBoxListModel.get( index ).is_disabled : false
               img_checked_n: root.checkBoxListModel.get( index ).img_checked_n ? root.checkBoxListModel.get( index ).img_checked_n : root.img_checked_n
               img_unchecked_n: root.checkBoxListModel.get( index ).img_unchecked_n ? root.checkBoxListModel.get( index ).img_unchecked_n : root.img_unchecked_n
               img_checked_d: root.checkBoxListModel.get( index ).img_checked_d ? root.checkBoxListModel.get( index ).img_checked_d : root.img_checked_d
               img_unchecked_d: root.checkBoxListModel.get( index ).img_unchecked_d ? root.checkBoxListModel.get( index ).img_unchecked_d : root.img_unchecked_d
               img_checked_f: root.img_checked_f
               img_item_selected: root.checkBoxListModel.get( index ).img_item_selected ? root.checkBoxListModel.get( index ).img_item_selected : (root.img_item_selected ? root.img_item_selected : "")
               img_item: root.checkBoxListModel.get( index ).img_item ? root.checkBoxListModel.get( index ).img_item : (root.img_item ? root.img_item : "")
               img_item_selected_bg: root.checkBoxListModel.get( index ).img_item_selected_bg ? root.checkBoxListModel.get( index ).img_item_selected_bg : (root.img_item_selected_bg ? root.img_item_selected_bg : root.img_item_bg)
               img_item_bg: root.checkBoxListModel.get( index ).img_item_bg ? root.checkBoxListModel.get( index ).img_item_bg : (root.img_item_bg ? root.img_item_bg : "")
               img_item_pressed_bg: root.checkBoxListModel.get( index ).img_item_pressed_bg ? root.checkBoxListModel.get( index ).img_item_pressed_bg : (root.img_item_pressed_bg ? root.img_item_pressed_bg : root.img_item_bg)
               img_item_focused_bg: root.checkBoxListModel.get( index ).img_item_focused_bg ? root.checkBoxListModel.get( index ).img_item_focused_bg : (root.img_item_focused_bg ? root.img_item_focused_bg : root.img_item_bg)
               item_focused_bg_leftOffset: root.item_focused_bg_leftOffset
               item_focused_bg_topOffset: root.item_focused_bg_topOffset
               item_selected_bg_leftOffset: root.item_selected_bg_leftOffset
               item_selected_bg_topOffset: root.item_selected_bg_topOffset
               item_selection_topOffset: root.item_selection_topOffset
               icon_image_leftOffset: root.icon_image_leftOffset ? root.icon_image_leftOffset : 0
               icon_image_topOffset: root.icon_image_topOffset
               icon_image_height: root.icon_image_height
               is_text_vcentered: root.is_text_vcentered
               is_text_hcentered: root.is_text_hcentered
               text_bottomOffset: root.text_bottomOffset
               text_leftOffset: root.text_leftOffset
               text2_rightOffset: root.text2_rightOffset
               is_2line_text: root.is_2line_text
               text2_leftOffset: root.text2_leftOffset
               text2_bottomOffset: root.text2_bottomOffset
               is_checkable: root.is_checkable
               is_items_selectable: root.is_items_selectable
               unselect_item_on_next_click: root.unselect_item_on_next_click
               delimiter_height: root.delimiter_height
               delimiter_leftOffset: root.delimiter_leftOffset
               img_delimiter: root.img_delimiter
               itemId: ( null != root.checkBoxListModel.get( index ).itemId ) ? root.checkBoxListModel.get( index ).itemId : -1
               highlight: root.checkBoxListModel.get( index ).highlight ? root.checkBoxListModel.get( index ).highlight : false
               
               Rectangle
               {
                  id: focus
                  visible: focusIndex == index

                  width:  item.width - 2*delimiter_leftOffset
                  height: item.height

                  x: 0
                  y: 0

                  color: HM.const_TRANSPARENT_COLOR

                  border.color: HM.const_SELECTION_COLOR
                  border.width: HM.const_BORDER_SELECTION_WIDTH
               }

            }

            function item_click()
            {
               console.log("log" + columnId.ListView.currentSection)
               return "text"
            }
         }
      }

      // The delegate for header
      Component
      {
         id: heading

         Item
         {
            width: root.width
            height: itemImage.height
            //Icon
            Image
            {
               id: itemImage
               anchors.left: parent.left
               anchors.leftMargin: footer_leftOffset ? footer_leftOffset : 0
               source: root.img_footer ? root.img_footer : ""
            }
         }
      }

      // The delegate for each section header
      Component
      {
          id: sectionHeading
          Item
          {
             width: select_leftOffset ? select_leftOffset : itemImage.width
             height: select_height ? select_height : itemImage.height
             //Icon
             Image
             {
                id: itemImage
                anchors.left: parent.left
                anchors.leftMargin: select_leftOffset ? select_leftOffset : 0
                source: root.img_bg_list_index ? root.img_bg_list_index : ""

                Text
                {
                   id: mainText
                   text: section
                   color: root.font_color_list_index
                   font.family: root.font_type_list_index
                   font.pixelSize: root.font_size_list_index
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.left: parent.left
                   anchors.leftMargin: root.list_index_text_leftOffset
                }
             }
          }
      }

      ListView
      {
         id: list
         header: heading
         anchors.fill: parent
         model: root.checkBoxListModel
         delegate: listDelegate
         clip: true
         interactive: is_interative

         section.property: root.select_property ? root.select_property : ""
         section.criteria: ViewSection.FirstCharacter
         section.delegate: sectionHeading
      }
   }
}
