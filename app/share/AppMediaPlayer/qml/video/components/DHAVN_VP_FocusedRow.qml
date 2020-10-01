import Qt.labs.gestures 2.0
import AppEngineQMLConstants 1.0
import QtQuick 1.0
import Qt 4.7
import "../DHAVN_VP_CONSTANTS.js" as CONST

Row
{
   id: root

   property bool is_focusable: true
   property bool focus_visible: false
   property bool is_base_item: false//true

   property string name: "FocusedRow"
   property int focus_x: -1
   property int focus_y: -1

   property int __current_index: 0
   property int currentIndex : -1
   property ListModel repeaterModel//: ListModel {}
   property Component repeaterComponent//: Component { Item{} }

   signal lostFocus( int direction )
   signal jogSelected( int status )
   signal recheckFocus()
   signal moveFocus( int delta_x, int delta_y )

   Repeater
   {
      id: nestedRepeater
      model: repeaterModel
      delegate: repeaterComponent
   }

   //**************************************************************************
   function setDefaultFocus(direction)
   {
      EngineListenerMain.qmlLog("setDefaultFocus() "+name)
      root.currentIndex = 0
      root.__current_index = root.currentIndex
      return 0
   }


   //**************************************************************************
   function hideFocus()
   {
      focus_visible = false
      root.__current_index = root.currentIndex
      root.currentIndex = -1
   }


   //**************************************************************************
   function showFocus()
   {
      EngineListenerMain.qmlLog("showFocus() "+name)
      focus_visible = true
      root.currentIndex = root.__current_index
   }


   //**************************************************************************
// modified by Dmitry 15.05.13
   function handleJogEvent( event, status )
   {
      EngineListenerMain.qmlLog("handleJogEvent() " + name)
      switch ( event )
      {
         case   UIListenerEnum.JOG_UP: //UP
         {
	 //modified by aettie Focus moves when pressed 20131015
//            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               root.lostFocus( event )
            }
         }
         break

         case   UIListenerEnum.JOG_RIGHT: //RIGHT
         {
	 //modified by aettie Focus moves when pressed 20131015
//            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               if ( root.currentIndex  == nestedRepeater.count - 1)
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

         case   UIListenerEnum.JOG_DOWN: //DOWN
         {
	 //modified by aettie Focus moves when pressed 20131015
//            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               root.lostFocus( event )
            }
         }
         break

         case   UIListenerEnum.JOG_LEFT:
         {
	 //modified by aettie Focus moves when pressed 20131015
//            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               if ( root.currentIndex == 0 )
               {
                  root.currentIndex = nestedRepeater.count - 1
               }
               else
               {
                  root.currentIndex--
               }
            }
         }
         break

         case   UIListenerEnum.JOG_WHEEL_RIGHT:
         {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               if ( root.currentIndex + 1 == nestedRepeater.count )
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

         case   UIListenerEnum.JOG_WHEEL_LEFT: //ANTI_CLOCK_WISE
         {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               if ( root.currentIndex == 0 )
               {
                  root.currentIndex = nestedRepeater.count - 1
               }
               else
               {
                  root.currentIndex--
               }
            }
         }
         break

         case   UIListenerEnum.JOG_CENTER: //SELECT
         {
            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
               root.jogSelected( status )
            }
         }
         break

         default:
         {
            root.log( "handleJogEvent  incorrect event" )
         }
      }
   }
// modified by Dmitry 15.05.13

   //**************************************************************************
   function log( str )
   {
      EngineListenerMain.qmlLog( "FocusedRow [" + root.name + "]: " + str )
   }

   onMoveFocus:
   {
      root.log( "onMoveFocus" )
   }

   onJogSelected:
   {
     EngineListenerMain.qmlLog("onJogSelected"+ name + currentIndex)
   }

   Component.onCompleted:
   {
      root.currentIndex = -1
   }
}
