import Qt 4.7

import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as RES
import CQMLLogUtil 1.0

Item
{
   id: root
   width: PR.const_PANDORA_ALPHABETIC_MENU_WIDTH
   //height: listView.height + list_view_top_margin
   height: PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT - PR.const_PANDORA_MODE_ITEM_HEIGHT //modified by checolhwan. 2014-01-14. ITS 218695.

   // Declarion  of various properties
   property int icon_search_left_margin
   property int icon_index_left_margin
   property int list_view_top_margin: PR.const_PANDORA_ALPHABETIC_LIST_LISTVIEW_TOP_MARGIN
   property int item_width
   property int item_height_top_part
   property int item_height_bottom_part
   property variant listInner : listView
   property alias listTextInner : listView.model;
   //{ added by esjang 2014.02.07 for ITS # 223522
   property variant hiddenListInner : hiddenListView
   property alias hiddenListTextInner : hiddenListView.model
   //} added by esjang 2014.02.07 for ITS # 223522
   
   property string logString :""

   // Declaration of QML Signals
  // signal alphaListClicked(int index, string indexChar);

   Image {
       id: bg
       source: RES.const_APP_PANDORA_LIST_VIEW_ALPHAMENU_BG
       anchors.fill: parent
   }

   Component
   {
      id: itemDelegate
      Item
      {
         width: parent.width
         height: 34 + 21//44 + iconIndex.height // added by esjang 2014.02.07 for ITS # 223522
//         MouseArea
//         {
//             anchors.fill: parent
//             //beepEnabled: false // added by esjang 2013.01.04 for remove Beep sound
//             onClicked:
//             {
//                 alphaListClicked(index,letter);
//             }
//         }

         Text
         {
            text: letter
            color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
            font.pointSize:PR.const_PANDORA_ALPHABETIC_TEXT_POINTSIZE
            font.family: PR.const_PANDORA_FONT_FAMILY_HDB
            anchors.bottom: iconIndex.top
            anchors.bottomMargin: 5 //21 - (letter.height/2) //modified by wonseok.heo for ITS 270604
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.Center
            horizontalAlignment: Text.Center
            width: PR.const_PANDORA_ALPHABETIC_TEXT_WIDTH
         }

         Image
         {
            id: iconIndex
            //y: PR.const_PANDORA_ALPHABETIC_MENU_ICON_Y// modified by esjang 2014.02.07 for ITS # 223522
            anchors.bottom: parent.bottom // modified by esjang for 2014.02.07 ITS # 223522
            anchors.bottomMargin:0 // modified by esjang for 2014.02.07 ITS # 223522
            anchors.horizontalCenter: parent.horizontalCenter
            source: RES.const_APP_PANDORA_LIST_VIEW_ALPHAMENU_DOT_IMAGE
            visible: (index + 1 == listView.count) ? false: true
         }
      }
   }
   // {added by esjang for ITS # 223522
   Component
   {
      id: hiddenItemDelegate
      Item
      {
         width: parent.width
         height: {
                     if (gap == -1) //visible letters
                     {
                         34 + 6 // modified by jaehwan 2013.11.19 , give more height to visible letter
                     }
                     else if (gap == -2) // '#' case, no other hidden letters.
                     {
                         33 + 21
                     }
                     else //invisible letters, dividing the space of '.' image.
                     {
                         ( 21 - 6) / gap // modified by jaehwan 2013.11.19 , give more height to visible letter
                     }
                  }

          Text
          {
             text: letter
        	 visible: false
             color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
             font.pointSize:PR.const_PANDORA_ALPHABETIC_TEXT_POINTSIZE
             font.family: PR.const_PANDORA_FONT_FAMILY_HDB
             //anchors.bottom: iconIndex.top  //removed by cheolhwan 2014-03-21. To prevent the qml error.
             anchors.bottomMargin: 21 - (letter.height/2)
             anchors.horizontalCenter: parent.horizontalCenter
             verticalAlignment: Text.Center
             horizontalAlignment: Text.Center
             width: PR.const_PANDORA_ALPHABETIC_TEXT_WIDTH
          }


       }
   }

   // }added by esjang for ITS # 223522
   ListView
   {
      id: listView
      width: parent.width
      height: listModel.count * ( 34 + 21 ) // added by esjang 2014.02.07 for ITS # 223522
      anchors.top: parent.top
      anchors.left: parent.left
//      anchors.topMargin: root.list_view_top_margin
      clip: true;
      model: listModel
      delegate: itemDelegate
      interactive: false
   }

   ListModel
   {
      id: listModel
      ListElement { letter: "#" }
      ListElement { letter: "A" }
      ListElement { letter: "D" }
      ListElement { letter: "G" }
      ListElement { letter: "J" }
      ListElement { letter: "M" }
      ListElement { letter: "P" }
      ListElement { letter: "S" }
      ListElement { letter: "V" }
   }
   // { added by esjang for ITS # 223522
   ListView
   {
      id: hiddenListView
      width: parent.width
      height: listModel.count * ( 34 + 21 )
      anchors.top: parent.top
      anchors.left: parent.left
      clip: true;
      model: hiddenListModel
      delegate: hiddenItemDelegate
      interactive: false
   }

   ListModel
   {
      id: hiddenListModel
      ListElement { letter: "#"; gap: -2 }
      ListElement { letter: "A"; gap: -2 }
      ListElement { letter: "B"; gap:  2 }
      ListElement { letter: "C"; gap:  2 }
      ListElement { letter: "D"; gap: -1 }
      ListElement { letter: "E"; gap:  2 }
      ListElement { letter: "F"; gap:  2 }
      ListElement { letter: "G"; gap: -1 }
      ListElement { letter: "H"; gap:  2 }
      ListElement { letter: "I"; gap:  2 }
      ListElement { letter: "J"; gap: -1 }
      ListElement { letter: "K"; gap:  2 }
      ListElement { letter: "L"; gap:  2 }
      ListElement { letter: "M"; gap: -1 }
      ListElement { letter: "N"; gap:  2 }
      ListElement { letter: "O"; gap:  2 }
      ListElement { letter: "P"; gap: -1 }
      ListElement { letter: "Q"; gap:  2 }
      ListElement { letter: "R"; gap:  2 }
      ListElement { letter: "S"; gap: -1 }
      ListElement { letter: "T"; gap:  2 }
      ListElement { letter: "U"; gap:  2 }
      ListElement { letter: "V"; gap: -1 }
      ListElement { letter: "W"; gap:  4 }
      ListElement { letter: "X"; gap:  4 }
      ListElement { letter: "Y"; gap:  4 }
      ListElement { letter: "Z"; gap:  4 }
   }
   // } added by esjang for ITS # 223522

/***************************************************************************/
/**************************** Private functions START **********************/
/***************************************************************************/

   function __LOG( textLog , level)
   {
      logString = "AlphaListMenu.qml::" + textLog ;
      logUtil.log(logString , level);
   }
/***************************************************************************/
/**************************** Private functions END ************************/
/***************************************************************************/

}
