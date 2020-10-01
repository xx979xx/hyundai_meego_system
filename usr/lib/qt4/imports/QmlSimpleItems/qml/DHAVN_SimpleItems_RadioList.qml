import Qt 4.7
import "DHAVN_SimpleItems_RadioList.js" as HM
import AppEngineQMLConstants 1.0

Item
{
   id: radioList

   /**radiomodel - model with input*/
   property variant radiomodel

   /**index of select radiobuton*/
   property int currentindex

   /**0 - RadoiList for settings; 1 - RadoiList for Video*/
   property bool bFullScreenList : false

   /** Path to focus image */
   // { modified by junggil 2012.08.29 for caption settings
   //property string focusImage: ""
   property string focusImage: "/app/share/images/general/bg_menu_tab_l_f.png"
   // } modified by junggil

   /** Focus image moving duration in msesc */
   property int focusMoveDuration: 1
   
   property int focus_id: -1//read_only
   property int focus_index: 0
   property bool focus_visible: false
   property bool is_focusable: true

   /**Number of items displayed at the same time */
   property int countDispalyedItems: 4

   /**Set Interactive */
   property bool interactive: true //added for ITS 225082 2014.02.17

   /**Font color */
   property string font_color:HM.const_COLOR_BRIGHT_GREY

   /** If focus should check enabled elements */
   property bool bCheckEnable: true
   property bool bLoopList: scrollbar.visible // modified by Sergey 16.11.2013 for ITS#209528, 209529
   //added by aettie CCP wheel direction for ME 20131014
   property bool middleEast: false
   property int pressed_index: -1 // added by Sergey 19.11.2013 for ITS#209528
   property bool bAutoBeep: true // added by Sergey 19.11.2013 for beep issue
   property bool bLostLeft: true
   property bool bLostRight: true // added by Sergey 12.12.2013 for ITS#214007
   property bool bLostEnabled: true // added by cychoi 2014.02.21 for ITS 213062

   /**signal sends index (nIndex) of selected radiobutton*/
   signal indexSelected( int nIndex )
   signal retranslateRB(variant context)
   signal radioList_lostFocus(variant direction )
   //should be deleted
   signal lostFocus ( int arrow, int focusID )
   signal beep() // added by Sergey 19.11.2013 for beep issue
   signal indexFlickSelected(int moveIndex) // added by yungi 2013.12.11 for ITS 213062
   signal qmlLog(string Log); // added by oseong.kwon 2014.08.04 for show log

   // { added by oseong.kwon 2014.08.04 for show log
   function __LOG(Log)
   {
       qmlLog( "DHAVN_SimpleItems_RadioList.qml: " + Log );
   }
   // } added by oseong.kwon 2014.08.04

   function retranslateUI( context )
   {
      if (context) { __lang_context = context }
      __emptyString = " "
      __emptyString = ""

      retranslateRB(context)
   }

   property string __lang_context: HM.const_LANGCONTEXT
   property string __emptyString: ""

   function handleJogEvent(jogEvent){}//empty methodfs to avoid resets
   function focusUpper() {}
   function focusLower(){}
   function focusClear() {}


   function focusDown()
   {
      if (!focus_visible)
      {
         return
      }

      // { modified by Sergey 16.11.2013 for ITS#209528, 209529
      do
      {
         if (focus_index + 1 > radioList.radiomodel.count - 1)
         {
            if(bLoopList)
            {
              focus_index = 0
            }
         }
         else
         {
             focus_index++
         }
      }
      while ( radioList.radiomodel.get(focus_index).enable == false )
      // } modified by Sergey 16.11.2013 for ITS#209528, 209529
   }

   function focusFirstOfList()
   {
      if (!focus_visible)
      {
         return
      }

      focus_index = 0
      while (( radioList.radiomodel.get(focus_index).enable == false ) && (focus_index < radioList.radiomodel.count-1))
      {
          focus_index++
      }
  }

  function focusEndOfList()
  {
      if (!focus_visible)
      {
          return
      }
      focus_index = radioList.radiomodel.count-1
      while (( radioList.radiomodel.get(focus_index).enable == false ) && (focus_index > 0))
      {
          focus_index--
      }
  }

   function focusUp()
   {
       if (!focus_visible)
       {
           return
       }

       // { modified by Sergey 16.11.2013 for ITS#209528, 209529
       do
       {
           if (focus_index -1 < 0)
           {
               if(bLoopList)
               {
                   focus_index = radioList.radiomodel.count - 1
               }
           }
           else
           {
               focus_index--
           }
       }
       while ( radioList.radiomodel.get(focus_index).enable == false )
       // } modified by Sergey 16.11.2013 for ITS#209528, 209529
   }

   function showFocus()
   {
      __LOG( "[RadioList]showFocus "+ focus_index)
      focus_visible = true
   }

   function hideFocus()
   {
      focus_visible = false
   }

   function checkModel()
   {
      __LOG( "[RadioList]checkModel" )

      if(!bCheckEnable)
          return true

      for( var i=0;i<radioList.radiomodel.count-1;i++)
      {
        if ( radioList.radiomodel.get(i).enable == true )
        {
          focus_index = i
          return true
        }
      }
      return false
   }

   function setDefaultFocus(arrow)
   {
      if (checkModel())
      {
         __LOG( "[RadioList]Focus enable count=" )
         return focus_id
      }
      else
      {
         lostFocus( arrow, focus_id )
         __LOG( "[RadioList]lost_focus arrow="+arrow )
         return -1
      }
   }

   // { added by yungi 2013.12.11 for ITS 213062
   function setIndexViewBeginning(abcd)
   {
       radioListView.positionViewAtIndex(abcd, radioListView.Beginning)
   }
   // } added by yungi 2013.12.11

//   Item
//   {

//    id: root

//      focus: true

//      Keys.onDigit5Pressed: UIListener.testKeyClickEvents( UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_CLICKED  )
//      Keys.onDigit8Pressed: UIListener.testKeyClickEvents( UIListenerEnum.JOG_UP, UIListenerEnum.KEY_STATUS_CLICKED  )
//      Keys.onDigit2Pressed: UIListener.testKeyClickEvents( UIListenerEnum.JOG_DOWN, UIListenerEnum.KEY_STATUS_CLICKED  )
//      Keys.onDigit4Pressed: UIListener.testKeyClickEvents( UIListenerEnum.JOG_LEFT, UIListenerEnum.KEY_STATUS_CLICKED  )
//      Keys.onDigit6Pressed: UIListener.testKeyClickEvents( UIListenerEnum.JOG_RIGHT, UIListenerEnum.KEY_STATUS_CLICKED  )
//      Keys.onDigit3Pressed: UIListener.testKeyClickEvents( UIListenerEnum.JOG_WHEEL_LEFT, UIListenerEnum.KEY_STATUS_CLICKED  )
//      Keys.onDigit7Pressed: UIListener.testKeyClickEvents( UIListenerEnum.JOG_WHEEL_RIGHT, UIListenerEnum.KEY_STATUS_CLICKED  )

//   }


   Connections
   {
      target: focus_visible ? UIListener: null

// { commented by Sergey 19.11.2013 for beep issue
//      onSignalJogCenterClicked:
//      {
//        __LOG("[RadioList]onSignalJogCenterClicked, index=" + currentindex)
//         currentindex = focus_index
//         indexSelected( currentindex )
//      }
// } commented by Sergey 19.11.2013 for beep issue

      onSignalJogNavigation:
      {
         __LOG("[RadioList]onSignalJogNavigation arrow=" + arrow)
//modified by aettie.ji 2013.04.30 for Click event deletion (for Focus ->Pressed / for Action -> Released) 
//         if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
         if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
            switch(arrow)
            {
            	// { added by Sergey 19.11.2013 for ITS#209528
                case UIListenerEnum.JOG_CENTER:
                {
                  pressed_index = focus_index;
                }
                break
                // } added by Sergey 19.11.2013 for ITS#209528

               case UIListenerEnum.JOG_UP:
               {
                 //focusUp(true)// deleted by yongkyun.lee 20130627 for : ITS 176480
               }
               break

               case UIListenerEnum.JOG_DOWN:
               {
                 //focusDown(true)// deleted by yongkyun.lee 20130627 for : ITS 176480
               }
               break

               case UIListenerEnum.JOG_LEFT:
               {
                   if(radioList.bLostEnabled && radioList.bLostLeft) // modified by cychoi 2014.02.21 for visual cue press animation // added by Sergey 12.12.2013 for ITS#214007
                       lostFocus(UIListenerEnum.JOG_LEFT,focus_id)

               }
               break

               case UIListenerEnum.JOG_RIGHT:
               {
                   if(radioList.bLostEnabled && radioList.bLostRight) // modified by cychoi 2014.02.21 for visual cue press animation // added by Sergey 12.12.2013 for ITS#214007
                       lostFocus(UIListenerEnum.JOG_RIGHT,focus_id)
               }
               break

               case UIListenerEnum.JOG_WHEEL_LEFT:
               {
	       //modified by aettie CCP wheel direction for ME 20131014
                    if(middleEast)
                    {
                         __LOG("[RadioList]wheel right")
                         focusDown()
                    }
                    else
                    {
                         __LOG("[RadioList]wheel left")
                         focusUp()
                    }
               }
               break

               case UIListenerEnum.JOG_WHEEL_RIGHT:
               {
	       //modified by aettie CCP wheel direction for ME 20131014
                    if(middleEast)
                    {
                         __LOG("[RadioList]wheel left")
                         focusUp()
                    }
                    else
                    {
                         __LOG("[RadioList]wheel right")
                         focusDown()
                    }
               }
               break
            }
         }

// { modified by sjhyun 2013.10.25 for ITS 193105
         else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
         {
             __LOG("[RadioList] UIListenerEnum.KEY_STATUS_LONG_PRESSED")
             if ( arrow == UIListenerEnum.JOG_DOWN)
             {
                 //focusEndOfList()
                 //UIListener.ManualBeep()
                 jogPressTimer.lastPressed = arrow;
                 jogPressTimer.start();
                 return
             }

             if ( arrow == UIListenerEnum.JOG_UP)
             {
                 //focusFirstOfList()
                 //UIListener.ManualBeep()
                 jogPressTimer.lastPressed = arrow;
                 jogPressTimer.start();
                 return
             }
         }
         else if (status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED) // added by Sergey 19.11.2013 for ITS#209528
         {
             __LOG("[RadioList] UIListenerEnum.KEY_STATUS_RELEASED")

             // { added by Sergey 19.11.2013 for ITS#209528
             if(arrow == UIListenerEnum.JOG_CENTER)
             {
                 pressed_index = -1;
                 currentindex = focus_index;
                 indexSelected( currentindex );
             }
             // } added by Sergey 19.11.2013 for ITS#209528

             jogPressTimer.stop();
             jogPressTimer.iterations = 0;
             jogPressTimer.lastPressed = -1;
         }
// } modified by sjhyun
      }
   }

   onIndexSelected: radioList.currentindex = nIndex

   width: bFullScreenList ? HM.const_LIST_WIDTH_VIDEO : HM.const_LIST_WIDTH_SETTINGS
   height: 1
   clip: true

   Component
   {
      id: listDelegate

      DHAVN_SimpleItems_RadioButton
      {
         id: radiobutton

         checked: ( radioList.currentindex == index )
         highlight: (focus_visible && ( focus_index == index ))
         bJogPressed: pressed_index == index // added by Sergey 19.11.2013 for ITS#209528
         Component.onCompleted: radioList.height = radioList.countDispalyedItems * radiobutton.height
         focus_selected: ( focus_index == index )
         bAutoBeep: radioList.bAutoBeep // added by Sergey 19.11.2013 for beep issue

         // { added by Sergey 19.11.2013 for beep issue
         onItemTapped:
         {
             if(!bAutoBeep)
                 beep();

             indexSelected(idx);
         }
         // } added by Sergey 19.11.2013 for beep issue
      }
   }

// { added by sjhyun 2013.10.25 for ITS 193105
   Timer
   {
       id: jogPressTimer
       interval: 100
       repeat: true
       running: false
       triggeredOnStart: true
       property int iterations: 0
       property int lastPressed: -1

       onTriggered:
       {
           if(lastPressed == UIListenerEnum.JOG_UP)
           {
               if (focus_index != 0)
               {
                   __LOG("[RadioList] --> jogPressTimer UP");
                   focusUp();
               }
               else
               {
                   __LOG("[RadioList] --> jogPressTimer UP SKIP");
               }
               return;
           }

           if(lastPressed == UIListenerEnum.JOG_DOWN) {
               if (focus_index != radioList.radiomodel.count-1)
               {
                   __LOG("[RadioList] --> jogPressTimer DOWN");
                   focusDown();
               }
               else
               {
                   __LOG("[RadioList] --> jogPressTimer DOWN SKIP");
               }
               return;
           }
       }
   }
// } added by sjhyun

// removed by raviaknth 15-03-13

   /** This rectangle should be removed after when resource will be provided */

   ListView
   {
      id:radioListView
      property real contentBottom: contentY + height  // added by yungi 2013.11.26 for ITS 209986
      width: radioList.bFullScreenList ? HM.const_LIST_WIDTH_VIDEO : HM.const_LIST_WIDTH_SETTINGS
      clip: true
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      delegate: listDelegate
      model: radioList.radiomodel
      orientation: ListView.Vertical
//    highlight: focusImageComponent // { modified by raviaknth 15-03-13
      highlightMoveDuration: radioList.focusMoveDuration
      currentIndex: focus_visible? radioList.focus_index : -1

      interactive : radioList.interactive //added for ITS 225082 2014.02.17

      // { added by yungi 2013.11.26 for ITS 209986
      onMovementEnded:
      {
          var tmp_start_index = indexAt(10, contentY + 10)
          if (tmp_start_index == -1)
              tmp_start_index = indexAt(10, contentY + HM.const_RADIO_LIST_SECTION_HEIGHT + 10)

          var tmp_end_index = indexAt(10, contentBottom - 10)
          if (tmp_end_index == -1)
              tmp_end_index = indexAt(10, contentBottom - ( HM.const_RADIO_LIST_SECTION_HEIGHT + 10 ))

          if(tmp_end_index < 0)
          {
              __LOG( "[RadioList]item count is smaller than screen")
          }
          else if(!((radioList.focus_index >= tmp_start_index) && (radioList.focus_index <= tmp_end_index)))
          {
              radioList.focus_index = tmp_start_index

              if (radioList.focus_index == -1)
              {
                  radioList.focus_index = indexAt(10, contentY + HM.const_RADIO_LIST_SECTION_HEIGHT + 10)
              }
              if(focus_visible == false) indexFlickSelected(radioList.focus_index) // added by yungi 2013.12.11 for ITS 213062
          }
          if(focus_visible == false) indexFlickSelected(0) // added by yungi 2013.12.11 for ITS 213062
      }
      // } added by yungi
   }

   DHAVN_SimpleItems_VerticalScrollBar
   {
      id: scrollbar
      anchors.top: parent.top
      anchors.right: parent.right
      height: radioListView.height
      position: radioListView.visibleArea.yPosition
      pageSize: radioListView.visibleArea.heightRatio
      visible: ( pageSize < 1 )
   }
}
