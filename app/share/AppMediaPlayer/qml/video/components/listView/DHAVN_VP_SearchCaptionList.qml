// { modified by Sergey 20.07.2013
import Qt 4.7
import QtQuick 1.1
import "../../components/listView"
import "../../components"
import "../../models"
import "../../DHAVN_VP_CONSTANTS.js" as VP
import "../../DHAVN_VP_RESOURCES.js" as RES
import AppEngineQMLConstants 1.0


DHAVN_VP_FocusedListCppModel
{
   id: input_lang_list
   clip: true
   delegate: item_delegate
   currentIndex: 0
   model: captionModel
   LayoutMirroring.enabled: east //added by Michael.Kim 2013.08.02 for Middle East UI
   LayoutMirroring.childrenInherit: east //added by Michael.Kim 2013.08.02 for Middle East UI
   property bool east: EngineListenerMain.middleEast //added by Michael.Kim 2013.08.02 for Middle East UI
   property int jogSelectIndex: -1 // added by cychoi 2014.02.28 for UX & GUI fix

   Component
   {
      id: item_delegate

      Item
      {
         id: item
         // { added by cychoi 2014.03.28 for ITS 232218 GUI fix
         anchors.left: parent.left
         anchors.leftMargin: 43
         // } added by cychoi 2014.03.28
         height: 89 //modified by Michael.Kim 2013.07.23 for New UX
         width: parent.width
         //property bool focused: input_lang_list.focus_visible && input_lang_list.currentIndex == index

         Image
         {
            id: line_id
            // { modified by cychoi 2014.02.28 for UX & GUI fix
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -3
            source: "/app/share/images/general/line_menu_list.png"
            visible: (!input_lang_list.focus_visible || ((input_lang_list.currentIndex != index) && (index < input_lang_list.count))) ? true : false
            // } modified by cychoi 2014.02.28
         }

         Image
         {
            id: image_f_id
            // { modified by cychoi 2014.02.28 for UX & GUI fix
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: -9
            // } modified by cychoi 2014.02.28
            source: "/app/share/images/general/bg_menu_tab_l_f.png"
            visible: input_lang_list.focus_visible && input_lang_list.currentIndex == index
         }

         Image
         {
            id: image_p_id
            // { modified by cychoi 2014.02.28 for UX & GUI fix
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: -9
            // } modified by cychoi 2014.02.28
            source: "/app/share/images/general/bg_menu_tab_l_p.png"
            visible: mouse_area.pressed || input_lang_list.jogSelectIndex == index // modified by cychoi 2014.02.28 for UX & GUI fix
         }

         //added by Michael.Kim 2013.07.20 for New UX
         Text
         {
             id: text_id
             anchors.left: parent.left
             anchors.leftMargin: 19 // modified by cychoi 2014.03.28 for ITS 232218 GUI fix //modified by Michael.Kim 2013.08.02 for Middle East UI
             anchors.top: parent.top
             anchors.topMargin: 16
             horizontalAlignment: east ? (LayoutMirroring.enabled ? Text.AlignLeft : Text.AlignRight ) :  Text.AlignLeft // modified by yungi 2013.12.03 for ITS 212329
             anchors.verticalCenter:  parent.verticalCenter
             width: parent.width
             height: 45
             text: text1
             color: VP.const_FONT_COLOR_BRIGHT_GREY
             font.family: VP.const_FONT_FAMILY_NEW_HDR
             font.pointSize: 40
         }

         // Caption name
         Text
         {
             id: text2_id
             // x: 414  // commented by yungi 2013.12.03 for ITS 212329
             anchors.right : parent.right // modified by cychoi 2014.03.28 for ITS 232218 GUI fix // added by yungi 2013.12.03 for ITS 212329
             anchors.rightMargin : 70 // added by cychoi 2014.03.28 for ITS 232218 GUI fix
             anchors.leftMargin : east ? 17 : 0 // added by yungi 2013.12.03 for ITS 212329
             anchors.top: parent.top
             anchors.topMargin: 16
             horizontalAlignment: east ? (LayoutMirroring.enabled ? Text.AlignRight : Text.AlignLeft ) :  Text.AlignRight // modified by yungi 2013.12.03 for ITS 212329
             anchors.verticalCenter:  parent.verticalCenter
             height: 45
             text: text2
             color: VP.const_FONT_COLOR_BRIGHT_GREY
             font.family: VP.const_FONT_FAMILY_NEW_HDR
             font.pointSize: 40
         }
         //added by Michael.Kim 2013.07.20 for New UX

         MouseArea
         {
            id: mouse_area
            anchors.fill: parent
            beepEnabled: false // added by cychoi 2014.07.04 for add manual beep

            onClicked:
            {
               UIListener.ManualBeep() // added by cychoi 2014.07.04 for add manual beep
               input_lang_list.currentIndex = index
               EngineListenerMain.qmlLog("[Mike]onClicked: " + index) 
               controller.onCodeEntered(index) //added by Michael.Kim 2013.07.23 for New UX
            }
         }
      }
   }

   onJogSelected:
   {
       if ( status == UIListenerEnum.KEY_STATUS_RELEASED)
       {
           EngineListenerMain.qmlLog("[Mike]currentIndex: " + currentIndex)
           input_lang_list.jogSelectIndex = -1 // added by cychoi 2014.02.28 for UX & GUI fix
           controller.onCodeEntered(currentIndex) //added by Michael.Kim 2013.07.23 for New UX
       }
       // { added by cychoi 2014.02.28 for UX & GUI fix
       else if ( status == UIListenerEnum.KEY_STATUS_PRESSED)
       {
           input_lang_list.jogSelectIndex = currentIndex
       }
       // } added by cychoi 2014.02.28
       // { added by cychoi 2014.10.06 for ITS 249690, ITS 249692 Key Cancel on SearchCaption
       else if ( status == UIListenerEnum.KEY_STATUS_CANCELED)
       {
           input_lang_list.jogSelectIndex = -1
       }
       // } added by cychoi 2014.10.06
   }
}
// } modified by Sergey 20.07.2013
