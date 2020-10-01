import Qt 4.7

Item
{
   id: root

   //Properties for the main text
   property string text            // main text
   property string font_type  // font type of the main text
   property int font_size     // font size of the main text
   property string font_color // font color of the main text
   property string font_color_selected   // font color of the checked main text

   //Properties for the second text
   property string text2           // second text (right or bottom)
   property string font_type2      // font type of the second text
   property int font_size2         // font size of the second text
   property string font_color2     // font color of the second text

   property bool highlight: false

   //Item icon URL
   property url icon               // icon image for the item

   //Flags of the checkbox item
   property bool is_disabled       // true - if item is disabled

   //Properties for the checked image
   property url img_checked_n      // image for checked item, not disabled
   property url img_unchecked_n    // image for unchecked item, not disabled
   property url img_checked_d      // image for checked item, disabled
   property url img_unchecked_d    // image for unchecked item, disabled
   property url img_checked_f      // image for hilighting item
   property url img_item_selected   // image for selected item
   property url img_item // image for unselected item
   property url img_item_selected_bg // image for selected item bg
   property url img_item_bg // image for unselected item bg
   property url img_item_pressed_bg // image for pressed item bg
   property url img_item_focused_bg // image for focused item bg

   property int item_focused_bg_leftOffset // left offset for image for focused item bg
   property int item_focused_bg_topOffset // top offset for image for focused item bg
   property int item_selected_bg_leftOffset // left offset for image for selected item bg
   property int item_selected_bg_topOffset // top offset for image for selected item bg
   property int item_selection_topOffset

   //Layout properties
   property bool is_text_vcentered  // if true - main text is vertically centered
   property bool is_text_hcentered  // if true - main text is horizontally centered
   property int text_bottomOffset   // bottom offset for the main text (used when not vcentered)
   property int text_leftOffset     // left offset for the main text
   property int text2_rightOffset   // right offset of the second text (when it is right aligned)
   property int text2_leftOffset    // left offset of the second text (when it is left aligned)
   property int text2_bottomOffset  // bottom offset of the second text (when it is at the second line)
   property int icon_image_leftOffset // left offset of the icon image
   property bool is_2line_text      // true, if second text in the second line,
                                    // false, if second text is at the right side
   property int icon_image_topOffset // top offset of the icon image

   property int icon_image_height
   property bool is_checkable
   property bool is_items_selectable
   property bool unselect_item_on_next_click

   property int delimiter_height
   property int delimiter_leftOffset
   property string img_delimiter

   property int itemId

   Binding
   {
       target: icon_image;
       property: 'source'
       value: root.img_item_selected;
       when: ( listModel.get( index ).is_item_selected == true )
   }

   Binding
   {
       target: icon_image;
       property: 'source'
       value: root.img_item;
       when: ( listModel.get( index ).is_item_selected == null ||
               listModel.get( index ).is_item_selected == false )
   }

   Binding
   {
       target: icon_image_bg;
       property: 'source'
       value: root.img_item_selected_bg;
       when: ( listModel.get( index ).is_item_selected == true )
   }

   Binding
   {
       target: icon_image_bg;
       property: 'source'
       value: root.img_item_bg;
       when: ( listModel.get( index ).is_item_selected == null ||
               listModel.get( index ).is_item_selected == false )
   }

   Binding
   {
       target: mainText;
       property: 'color'
       value: root.font_color_selected
       when: ( listModel.get( index ).is_item_selected == true )
   }

   Binding
   {
       target: mainText;
       property: 'color'
       value: root.font_color;
       when: ( listModel.get( index ).is_item_selected == null ||
               listModel.get( index ).is_item_selected == false )
   }

   function checkbox_click()
   {
      if ( ! root.is_disabled )
      {
         listModel.get( index ).is_checked = !listModel.get( index ).is_checked
         item_checked( listModel.get( index ).is_checked, index, itemId, true )
      }
   }

   function item_click()
   {
      item_clicked(index, itemId)

      if (root.is_items_selectable)
      {
         if (selectedItemIndex != -1 && selectedItemIndex != index)
         {
            listModel.get( selectedItemIndex ).is_item_selected = false
            item_selected( false, selectedItemIndex, itemId )
            selectedItemIndex = -1
         }

         if ( listModel.get( index ).is_item_selected == true )
         {
            if (unselect_item_on_next_click)
            {
               listModel.get( index ).is_item_selected = false
               item_selected( false, index, itemId )
               selectedItemIndex = -1
            }
         }
         else
         {
            listModel.get( index ).is_item_selected = true
            selectedItemIndex = index
            item_selected( true, index, itemId )
         }
      }
   }

   function icon_resize_n()
   {
      if ( icon_image.sourceSize.height > ( root.height - delimiter.height ) )
      {
         return ( icon_image.sourceSize.height / ( root.height - delimiter.height ) );
      }
      else
      {
         return 1;
      }
   }

   function bestDelegate(is_checkable)
   {
      if (is_checkable)
      {
         return checkable;
      }
      else
      {
         return uncheckable;
      }
   }

   width: root.width
   height: root.height

   //Items delimiter
   Item
   {
      id: delimiter
      width: itemImage.width
      height: root.delimiter_height ? root.delimiter_height : itemImage.height
      anchors.bottom: parent.bottom
      Image
      {
         id: itemImage
         anchors.left: parent.left
         anchors.leftMargin: root.delimiter_leftOffset ? root.delimiter_leftOffset : 0
         anchors.verticalCenter: parent.verticalCenter
         source: ( index < root.listModel.count - 1 && ( root.parent.ListView.section == root.parent.ListView.nextSection ) )
                 ? root.img_delimiter : ""
      }
   }


   //BG
   Image
   {
      id: icon_image_bg
      x: item_selected_bg_leftOffset
      y:  (index == 0  ? root.item_selection_topOffset + item_selected_bg_topOffset : item_selected_bg_topOffset)

   }

   //Icon
   Image
   {
      id: icon_image
      height: root.icon_image_height ? root.icon_image_height : icon_image.sourceSize.height / icon_resize_n()
      width: root.icon_image_height ?  root.icon_image_height : icon_image.sourceSize.width / icon_resize_n()
      anchors.left: parent.left
      anchors.leftMargin: root.icon_image_leftOffset
      anchors.top: parent.top
      anchors.topMargin: root.icon_image_topOffset ? root.icon_image_topOffset : ( ( root.height - delimiter.height ) - icon_image.height )/2
   }

   //Main text
   Text
   {
      id: mainText
      text: root.text
      font.family: root.font_type
      font.pixelSize: root.font_size
      anchors.bottom: parent.bottom
      anchors.bottomMargin: root.is_text_vcentered ?
         ( ( ( root.height - delimiter.height ) - mainText.height ) / 2 ) + delimiter.height: root.text_bottomOffset + delimiter.height
      anchors.left: parent.left
      anchors.leftMargin: root.is_text_hcentered ? ( ( root.width - mainText.width ) / 2 ) : root.text_leftOffset
   }

   //Second text
   Text
   {
      //Right text, used only when is_2line_text is false
      id: rightText
      text: ! is_2line_text ? root.text2: ""
      color: root.font_color2 ? root.font_color2 : root.font_color
      font.family: root.font_type2 ? root.font_type2 : root.font_type
      font.pixelSize: root.font_size2 ? root.font_size2 : root.font_size
      anchors.right: parent.right
      //if right offset is not defined, then make it same as left offset
      anchors.rightMargin: root.text2_rightOffset ?
         loader.item.width + root.text2_rightOffset : loader.item.width + root.text_leftOffset
      anchors.bottom: parent.bottom
      //if not vcentered, then make bottom offset same as for main text
      anchors.bottomMargin: root.is_text_vcentered ?
         ( ( ( root.height - delimiter.height ) - rightText.height ) / 2 ) + delimiter.height : root.text_bottomOffset + delimiter.height
   }

   Text
   {
      //Bottom text, used only when is_2line_text is true
      id: bottomText
      text: is_2line_text ? root.text2 : ""
      color: root.font_color2 ? root.font_color2 : root.font_color
      font.family: root.font_type2 ? root.font_type2 : root.font_type
      font.pixelSize: root.font_size2 ? root.font_size2:root.font_size
      anchors.left: parent.left
      anchors.leftMargin: root.text2_leftOffset ? root.text2_leftOffset : root.text_leftOffset
      anchors.bottom: parent.bottom
      anchors.bottomMargin: root.text2_bottomOffset
   }

   MouseArea
   {
      id: mouseArea_item_check
      anchors.fill: root
      onClicked:
      {
         item_click()
      }
      onPressed:
      {
         if (listModel.get( index ).is_item_selected == null ||
             listModel.get( index ).is_item_selected == false)
         {
            icon_image_bg.source = root.img_item_pressed_bg
         }
      }
   }

   Loader
   {
      id: loader
      anchors.fill: parent
      sourceComponent: bestDelegate(root.is_checkable)
   }

   Component
   {
      id:checkable

      Item
      {

         Binding
         {
             target: checked_image;
             property: 'source'
             value: root.is_disabled ? root.img_unchecked_d : root.img_unchecked_n ;
             when: ( listModel.get( index ).is_checked == null ||
                     listModel.get( index ).is_checked == false )
         }

         Binding
         {
             target: checked_image;
             property: 'source'
             value: root.is_disabled ? root.img_checked_d : root.img_checked_n;
             when: ( listModel.get( index ).is_checked == true )
         }

         //Checked image
         Image
         {
            id: checked_image
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: ( ( root.height - delimiter.height ) - checked_image.height ) / 2 + delimiter.height
            //Highlight Icon
            Image
            {
                id: highlight_image
                source: img_checked_f
                anchors.centerIn: parent
                visible:  highlight
            }
         }                 

         MouseArea
         {
            id: mouseArea_check
            anchors.fill: checked_image
            onClicked: checkbox_click()
         }
      }
   }

   Component
   {
      id:uncheckable
      Item { }
   }
}



