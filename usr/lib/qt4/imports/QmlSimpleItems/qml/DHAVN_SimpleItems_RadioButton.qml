import Qt 4.7
import "DHAVN_SimpleItems_RadioList.js" as HM

Item
{
   id: radioButton

   property bool checked: false

   property bool highlight: false
   property bool focus_selected: false
   property bool bMousePressed: false // added by Sergey 19.11.2013 for ITS#209528
   property bool bJogPressed: false // added by Sergey 19.11.2013 for ITS#209528
   property bool bAutoBeep: true // added by Sergey 19.11.2013 for beep issue

   property string __emptyString : ""
   property string __lang_context: HM.const_LANGCONTEXT

   signal itemTapped(int idx) // added by Sergey 19.11.2013 for beep issue

   function retranslateUI(context)
   {
      if (context) __lang_context = context
      __emptyString = " "
      __emptyString = ""
   }

   Connections
   {
      target: radioList
      onRetranslateRB: radioButton.retranslateUI(context)
   }

   width: radioList.bFullScreenList ? HM.const_BUTTON_WIDTH_VIDEO : HM.const_BUTTON_WIDTH_SETTINGS
   height: ( 0 == bottom_text.text.length ) ? HM.const_BUTTON_HEIGHT_WO_COMMENT :
                                              HM.const_BUTTON_HEIGHT_W_COMMENT

   z: radioButton.highlight ? 10 : 0 // added by cychoi 2014.02.28 for UX & GUI fix
                                              
      // { moved by cychoi 2014.02.28 for UX & GUI fix
      Image
      {
         id:line_id
         anchors.left: parent.left
         anchors.bottom: parent.bottom
         anchors.bottomMargin: -3 // modified by raviaknth 15-03-13
      
         source: radioList.bFullScreenList ? HM.const_URL_IMG_VIDEO_LINE_LIST : HM.const_URL_IMG_SETTINGS_LINE_LIST
         //modified by aettie.ji for New UX 2012.11.19
         //visible: ( index < radioList.radiomodel.count - 1 )
         visible: (!radioButton.highlight && (index < radioList.radiomodel.count)) ? true : false // modified by cychoi 2014.02.28 for UX & GUI fix
      }
      // } moved by cychoi 2014.02.28

      // { modified by raviaknth 15-03-13						      
      Image
      {
          id:radio_f_id
          anchors.top: parent.top
          anchors.left: parent.left
          visible: radioButton.highlight
          source: "/app/share/images/general/bg_menu_tab_l_f.png"
      }
      // } modified by raviaknth 15-03-13

      // { added by Sergey 19.11.2013 for ITS#209528
      Image
      {
          id:radio_p_id
          
          anchors.top: parent.top
          anchors.left: parent.left
          visible: radioButton.bMousePressed || radioButton.bJogPressed
          source: "/app/share/images/general/bg_menu_tab_l_p.png"
      }
	  // } added by Sergey 19.11.2013 for ITS#209528

    Item
    {
      id: scrolledLabel
      width: radioList.bFullScreenList ? HM.const_TEXT_WIDTH_VIDEO : HM.const_TEXT_WIDTH_SETTINGS

      anchors.verticalCenter: parent.top
       
      anchors.left: parent.left
      anchors.leftMargin: radioList.bFullScreenList ? HM.const_TOP_TEXT_LO_VIDEO : HM.const_TOP_TEXT_LO_SETTINGS
      visible: true
      height: parent.height * 2
      clip:true
      state: "left"
      states: [
         State {
            name: "left"
            AnchorChanges {
               target: top_text
               anchors.left: scrolledLabel.left
               anchors.right: undefined
            }
            AnchorChanges {
               target: bottom_text
               anchors.left: scrolledLabel.left
               anchors.right: undefined
            }
         },
         State {
            name: "right"
            AnchorChanges {
               target: top_text
               anchors.right: (top_text.width > scrolledLabel.width) ? scrolledLabel.right : undefined
               anchors.left: (top_text.width > scrolledLabel.width) ? undefined : anchors.left
            }
            AnchorChanges {
               target: bottom_text
               anchors.right: (bottom_text.width > scrolledLabel.width) ? scrolledLabel.right : undefined
               anchors.left: (bottom_text.width > scrolledLabel.width) ? undefined : anchors.left
            }
         }
      ]

      transitions: Transition {
         ParallelAnimation {
            AnchorAnimation
            {
               targets:top_text
               duration: (radioList.focus_visible && radioList.focus_index == index) * Math.floor( (( top_text.width) / HM.const_TEXT_WIDTH_SETTINGS ) * HM.const_RADIO_LIST_ANIMATION_SPEED)
            }
            AnchorAnimation
            {
               targets:bottom_text
               duration: (radioList.focus_visible && radioList.focus_index == index) * Math.floor( (( bottom_text.width) / HM.const_TEXT_WIDTH_SETTINGS ) * HM.const_RADIO_LIST_ANIMATION_SPEED)
            }
         }
      }

      Timer {
         id: scroll_timer
         repeat: true
         running: radioList.focus_visible && (radioList.focus_index == index)
         interval: top_text.interval >= bottom_text.interval ? top_text.interval : bottom_text.interval
            onRunningChanged:
            {
               if(!running) {
                  scrolledLabel.state = "left"
               }
            }

         triggeredOnStart: true
         onTriggered: {
            if(scrolledLabel.state === "left")
            {
               scrolledLabel.state = "right"
            }
            else
            {
               scrolledLabel.state = "left"
            }
         }
      }

      Text
      {
         id: top_text
         visible: true
         anchors.verticalCenter: parent.verticalCenter
         anchors.verticalCenterOffset: radioList.bFullScreenList ? HM.const_TOP_TEXT_CO_VIDEO :
                                    ( ( 0 == bottom_text.text.length ) ? HM.const_TOP_TEXT_CO_SETTINGS_WO_COMMENT :
                                                                         HM.const_TOP_TEXT_CO_SETTINGS_W_COMMENT )

         // { added  by junggil 2012.08.29 for caption settings
         anchors.bottom: parent.bottom
         anchors.bottomMargin: -20     
         // } added  by junggil
         text: qsTranslate( __lang_context, title_of_radiobutton) + __emptyString
         font.pixelSize: HM.const_FONT_SIZE_PIXEL_TOPTEXT
         //font.bold: true // added  by junggil 2012.08.29 for caption settings //deleted by aettie.ji 2012.11.19 for ISV 59871
         //font.family: HM.const_TEXT_FONT_FAMILY
	 //modified by aettie.ji Selected font color 20131015
//         font.family: ( radioButton.checked )? HM.const_TEXT_FONT_FAMILY_NEW_HDB : HM.const_TEXT_FONT_FAMILY_NEW
         font.family: HM.const_TEXT_FONT_FAMILY_NEW // modified by Sergey 16.11.2013 for ITS#209528, 209529
         //style: Text.Sunken   ////deleted by aettie.ji 2012.11.19 for ISV 59871
//         color: ( radioButton.highlight )? HM.const_COLOR_BRIGHT_GREY : ( radioButton.checked )? HM.const_COLOR_SELECTED_BLUE : HM.const_COLOR_BRIGHT_GREY
         color: HM.const_COLOR_BRIGHT_GREY // modified by Sergey 16.11.2013 for ITS#209528, 209529
         property int interval: Math.floor( 1000 + (( top_text.width) / HM.const_TEXT_WIDTH_SETTINGS ) * HM.const_RADIO_LIST_ANIMATION_SPEED)
      }

      Text
      {
          id: bottom_text
          anchors.verticalCenter: parent.verticalCenter
          anchors.verticalCenterOffset: HM.const_BOTTOM_TEXT_CO

          text: qsTranslate( __lang_context, comment_of_radiobutton ) + __emptyString
          font.pixelSize: HM.const_FONT_SIZE_PIXEL_BOTTOMTEXT
        // font.family: HM.const_TEXT_FONT_FAMILY
	//modified by aettie.ji Selected font color 20131015
//         font.family: ( radioButton.checked )? HM.const_TEXT_FONT_FAMILY_NEW_HDB : HM.const_TEXT_FONT_FAMILY_NEW
		 font.family: HM.const_TEXT_FONT_FAMILY_NEW // modified by Sergey 16.11.2013 for ITS#209528, 209529

          style: Text.Sunken
          color: enable ? HM.const_COLOR_DIMMED_GREY : HM.const_COLOR_DISABLE_GREY
          state: "left"
          property int interval: Math.floor( 1000 + (( bottom_text.width) / HM.const_TEXT_WIDTH_SETTINGS ) * HM.const_RADIO_LIST_ANIMATION_SPEED)
      }
    }

   Image
   {
      id: radioImage

      anchors.top: parent.top
      anchors.topMargin: radioList.bFullScreenList ? HM.const_BUTTON_IMAGE_TO_VIDEO : HM.const_BUTTON_IMAGE_TO_SETTINGS
      anchors.left: parent.left
      anchors.leftMargin: radioList.bFullScreenList ? HM.const_BUTTON_IMAGE_LO_VIDEO : HM.const_BUTTON_IMAGE_LO_SETTINGS
      source: HM.const_URL_IMG_GENERAL_RADIO +
              ( ( radioButton.checked ) ? "_on" : "_off" ) +
              ( ( enable ) ? "_n.png" : "_d.png" )
   }

   /** Highlight Icon */
//{ deleted by yungi 2013.11.03 for ITS 206055
//   Image
//   {
//      id: highlight_image
//      source: radioButton.highlight ? ( HM.const_URL_IMG_GENERAL_RADIO + "_f.png" ) : ""
//      anchors.centerIn: radioImage
//   }
//} deleted by yungi

   // { modified by Sergey 19.11.2013 for beep issue
   MouseArea
   {
      id: mouseArea

      anchors.fill: parent
      enabled: enable
      beepEnabled: radioButton.bAutoBeep

      onPressed: bMousePressed = true; // added by Sergey 19.11.2013 for ITS#209528
      onReleased:
      {
          if(bMousePressed)
          {
              itemTapped(index);
              bMousePressed = false;
          }
      }
      onCanceled: bMousePressed = false;
      onExited: bMousePressed = false; // added by Sergey 19.11.2013 for ITS#209528
   }
   // } added by Sergey 19.11.2013 for beep issue
}
