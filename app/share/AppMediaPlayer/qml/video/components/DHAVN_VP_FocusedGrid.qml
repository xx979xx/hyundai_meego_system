import Qt 4.7
import AppEngineQMLConstants 1.0

import "../DHAVN_VP_CONSTANTS.js" as CONST // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update

GridView
{
   id: root

   property bool is_focusable: true
   property bool focus_visible: false
   property bool is_base_item: true
   property int is_jog_event: -1 // modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update //added by yungi 2013.11.08 for ITS 207748

   property string name: "FocusedGrid"
   property int focus_x: -1
   property int focus_y: -1

   property int __current_index: 0

   signal lostFocus( int direction )
   signal jogSelected( int status )
   signal recheckFocus()
   signal moveFocus( int delta_x, int delta_y )
   //{ added by yongkyun.lee 20130624 for : ITS 175870
//   signal moveCurrentIndexUp() // removed by yungi 2014.02.14 for ITS 225174
//   signal moveCurrentIndexDown() // removed by yungi 2014.02.14 for ITS 225174
   //} added by yongkyun.lee 20130624 
   //{ modified by yongkyun.lee 2013-07-20 for : ITS 180917
//   signal moveCurrentIndexRight() // removed by yungi 2014.02.14 for ITS 225174
//   signal moveCurrentIndexLeft() // removed by yungi 2014.02.14 for ITS 225174
   signal moveCurrentIndex( int direction )
   //} modified by yongkyun.lee 2013-07-20 

   /**************************************************************************/
   function setDefaultFocus(arrow)
   {
      root.currentIndex = 0
      root.__current_index = root.currentIndex
      return 0
   }


   /**************************************************************************/
   function hideFocus()
   {
      root.__current_index = root.currentIndex
      root.currentIndex = -1
      root.focus_visible = false
   }


   /**************************************************************************/
   function showFocus()
   {
      root.currentIndex = root.__current_index
      root.focus_visible = true
   }


   /**************************************************************************/
// { modified by Sergey 20.07.2013
   function handleJogEvent( event, status )
   {
       EngineListenerMain.qmlLog("event"+ event  );
       if ( !root.focus_visible )
       {
          if ( status ==  UIListenerEnum.KEY_STATUS_RELEASED ||
               event ==  UIListenerEnum.JOG_WHEEL_RIGHT ||
               event ==  UIListenerEnum.JOG_WHEEL_LEFT )
          {
             root.setDefaultFocus()
             root.showFocus()
          }
          return
       }
       //{ added by cychoi 2013.12.01 for Clear current jog event
       if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
       {
          root.is_jog_event = -1
       }
       //} added by cychoi 2013.12.01
      switch ( event )
      {
         case UIListenerEnum.JOG_UP: //UP
         {
	 //modified by aettie Focus moves when pressed 20131015
          //  if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               //{ modified by yongkyun.lee 2013-07-20 for : ITS 180917
               EngineListenerMain.qmlLog("moveCurrentIndexUp"  );
               root.is_jog_event = CONST.const_JOG_EVENT_ARROW_UP //added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
               moveCurrentIndex(UIListenerEnum.JOG_UP) // modified by yungi 2014.02.14 for ITS 225174
               //} modified by yongkyun.lee 2013-07-20 
            }
         }
         break

         case UIListenerEnum.JOG_RIGHT: //RIGHT
         {
	 //modified by aettie Focus moves when pressed 20131015
          //  if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                  //{ modified by yongkyun.lee 2013-07-20 for : ITS 180917
                  EngineListenerMain.qmlLog("moveCurrentIndexRight"  );
                  root.is_jog_event = CONST.const_JOG_EVENT_ARROW_RIGHT //modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update //added by yungi 2013.11.08 for ITS 207748
                  moveCurrentIndex(UIListenerEnum.JOG_RIGHT) // modified by yungi 2014.02.14 for ITS 225174
                  //} modified by yongkyun.lee 2013-07-20 
            }
         }
         break

         case UIListenerEnum.JOG_DOWN: //DOWN
         {
	 //modified by aettie Focus moves when pressed 20131015
          //  if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                  //{ modified by yongkyun.lee 2013-07-20 for : ITS 180917
                  EngineListenerMain.qmlLog("moveCurrentIndexDown"  );
                  root.is_jog_event = CONST.const_JOG_EVENT_ARROW_DOWN // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
                  moveCurrentIndex(UIListenerEnum.JOG_DOWN) // modified by yungi 2014.02.14 for ITS 225174
                  //} modified by yongkyun.lee 2013-07-20 
            }
         }
         break

         case UIListenerEnum.JOG_LEFT:
         {
	 //modified by aettie Focus moves when pressed 20131015
          //  if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED ) // added by cychoi 2013.11.26 for ITS 211070
            {
                //{ modified by yongkyun.lee 2013-07-20 for : ITS 180917
                EngineListenerMain.qmlLog("moveCurrentIndexLeft"  );
                root.is_jog_event = CONST.const_JOG_EVENT_ARROW_LEFT // modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update //added by yungi 2013.11.08 for ITS 207748
                moveCurrentIndex(UIListenerEnum.JOG_LEFT) // modified by yungi 2014.02.14 for ITS 225174
                //} modified by yongkyun.lee 2013-07-20 
            }
         }
         break

         // { added by yungi 2014.02.14 for ITS 225174
         case UIListenerEnum.JOG_TOP_RIGHT:
         {
             if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
             {
                 EngineListenerMain.qmlLog("moveCurrentIndexTopRight"  );
                 root.is_jog_event = CONST.const_JOG_EVENT_ARROW_UP_RIGHT
                 moveCurrentIndex(UIListenerEnum.JOG_TOP_RIGHT)
             }
         }
         break

         case UIListenerEnum.JOG_BOTTOM_RIGHT:
         {
             if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
             {
                 EngineListenerMain.qmlLog("moveCurrentIndexBottomRight"  );
                 root.is_jog_event = CONST.const_JOG_EVENT_ARROW_DOWN_RIGHT
                 moveCurrentIndex(UIListenerEnum.JOG_BOTTOM_RIGHT)
             }
         }
         break

         case UIListenerEnum.JOG_TOP_LEFT:
         {
             if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
             {
                 EngineListenerMain.qmlLog("moveCurrentIndexTopLeft"  );
                 root.is_jog_event = CONST.const_JOG_EVENT_ARROW_UP_LEFT
                 moveCurrentIndex(UIListenerEnum.JOG_TOP_LEFT)
             }
         }
         break

         case UIListenerEnum.JOG_BOTTOM_LEFT:
         {
             if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
             {
                 EngineListenerMain.qmlLog("moveCurrentIndexBottomLeft"  );
                 root.is_jog_event = CONST.const_JOG_EVENT_ARROW_DOWN_LEFT
                 moveCurrentIndex(UIListenerEnum.JOG_BOTTOM_LEFT)
             }
         }
         break
         // } added by yungi 2014.02.14

         case UIListenerEnum.JOG_WHEEL_RIGHT:
         {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               root.is_jog_event = CONST.const_JOG_EVENT_WHEEL_RIGHT // modified by yungi 2013.12.05 for ITS 211269 // modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update //added by yungi 2013.11.08 for ITS 207748
               if ( root.currentIndex + 1 == root.count )
               {
                  root.currentIndex = 0
               }
               else
               {
                  root.currentIndex++
               }
            }
         }
         break

         case UIListenerEnum.JOG_WHEEL_LEFT: //ANTI_CLOCK_WISE
         {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               root.is_jog_event = CONST.const_JOG_EVENT_WHEEL_LEFT // modified by yungi 2013.12.05 for ITS 211269 // modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update //added by yungi 2013.11.08 for ITS 207748
               if ( root.currentIndex == 0 )
               {
                  root.currentIndex = root.count - 1
               }
               else
               {
                  root.currentIndex--
               }
            }
         }
         break

         case UIListenerEnum.JOG_CENTER: //SELECT
         {
            root.jogSelected( status )
            root.is_jog_event = CONST.const_JOG_EVENT_CENTER // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
         }
         break

         default:
         {
            root.log( "handleJogEvent  incorrect event" )
         }
      }
   }
// } modified by Sergey 20.07.2013

   /**************************************************************************/
   function log( str )
   {
      EngineListenerMain.qmlLog( "FocusedGrid [" + root.name + "]: " + str )
   }

   highlightMoveDuration: 1

   onMoveFocus:
   {
      root.log( "onMoveFocus" )
   }

   Component.onCompleted:
   {
      root.currentIndex = -1
   }
}


