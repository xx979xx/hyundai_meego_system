import Qt 4.7
import "../DHAVN_VP_CONSTANTS.js" as CONST
import AppEngineQMLConstants 1.0

Item
{
   id: root

   property bool is_focusable: true
   property bool focus_visible: false
   property bool is_base_item: true
   property bool container_is_widget: false
   property bool __container_is_focused: false
   property bool container_is_focused: false

   property bool is_connected: false

   property string name: "FocusedItem"
   property int focus_x: -1
   property int focus_y: -1
   property int default_x: -1
   property int default_y: -1
   property int focus_z: 0
   property int __current_index: -1
   property bool __is_initialized: false
   property int __horizontal_size: 0
   property int __vertical_size: 0
   property int __current_x: -1
   property int __current_y: -1

   signal lostFocus( int direction, int focusID )
   signal jogSelected( int status )
   signal recheckFocus()
   signal moveFocus( int delta_x, int delta_y )


   /**************************************************************************/
   function setDefaultFocus( arrow )
   {
      root.log( "setDefaultFocus start " )

      if ( root.container_is_widget )
      {

         if(!root.visible)
         {
             return -1
         }
         root.__container_is_focused = true
         root.__current_index = -1
         root.__current_x = -1
         root.__current_y = -1
         return 0;
      }
      else
      {
         return root.setDefaultFocusInContainer( arrow )
      }
   }


   /**************************************************************************/
   function setDefaultFocusInContainer( arrow )
   {
      var i
      var index = -1
      var max_z = 0;

      root.log( "setDefaultFocusInContainer start" )

      if ( !root.__is_initialized )
      {
         root.__is_initialized = true

         for ( i = 0; i < root.children.length; i++ )
         {
            if ( root.children[i].is_focusable )
            {
               if ( root.children[i].focus_x + 1 > root.__horizontal_size )
               {
                  root.__horizontal_size = root.children[i].focus_x + 1
               }

               if ( root.children[i].focus_y + 1 > root.__vertical_size )
               {
                  root.__vertical_size = root.children[i].focus_y + 1
               }

               root.children[i].lostFocus.connect( root.lostFocusHandle )
               if ( root.children[i].is_base_item )
               {
                  root.children[i].recheckFocus.connect( root.recheckFocusHandle )
                  root.children[i].moveFocus.connect( root.moveFocusHandle )
               }
            }
         }
      }

      if ( root.default_x == -1 && root.default_y == -1 )
      {
         root.log( "setDefaultFocusInContainer  [root.default_x == -1 && root.default_y == -1]" )
         return 0
      }

      if ( !root.visible )
      {
         return -1
      }

      root.__current_index = -1
      root.__current_x = -1
      root.__current_y = -1

      for ( i = 0; i < root.children.length; i++ )
      {
         if ( root.children[i].is_focusable &&
              root.children[i].focus_x == root.default_x &&
              root.children[i].focus_y == root.default_y &&
              root.children[i].visible )
         {
            if ( index == -1 )
            {
               index = i
            }
            else
            {
               if ( root.children[i].focus_z > max_z )
               {
                  max_z = root.children[i].focus_z
               }
            }
         }
      }

      if ( index != -1 )
      {
         root.__current_index = index
         root.__current_x = root.default_x
         root.__current_y = root.default_y
         return root.children[index].setDefaultFocus( arrow )
      }

      return -1
   }


   /**************************************************************************/
   function hideFocus()
   {
      root.log( "hideFocus" )

      if ( root.container_is_widget && root.__container_is_focused )
      {
         root.container_is_focused = false
      }
      else
      {
         if ( root.__current_index != -1 && root.focus_visible )
         {
            root.children[root.__current_index].hideFocus()
         }
      }

      root.focus_visible = false
   }


   /**************************************************************************/
   function showFocus()
   {
      root.log( "showFocus" )

      root.focus_visible = true

      if ( !root.__is_initialized )
      {
         root.log( "showFocus - initialize" )
         root.setDefaultFocus(  UIListenerEnum.JOG_DOWN )
      }

      if ( root.container_is_widget && root.__container_is_focused )
      {
         root.container_is_focused = true
      }
      else
      {
         var new_index = 0
         root.log( "showFocus  root.__current_index = " + root.__current_index )

         new_index = root.searchIndex( root.__current_x, root.__current_y )

         if ( root.__current_index != -1 )
         {
            if ( root.children[root.__current_index].visible &&
                 root.__current_index == new_index )
            {
               root.log( "showFocus index/visible [" + root.__current_index + "][" + root.children[root.__current_index].visible + "]" )
               root.children[root.__current_index].showFocus()
            }
            else
            {
               //var index = root.searchIndex( root.__current_x, root.__current_y )

               if ( new_index != -1 )
               {
                  if ( root.children[new_index].setDefaultFocus( JOG_DOWN ) != -1 )
                  {
                     root.__current_index = new_index
                     root.children[root.__current_index].showFocus()
                  }
               }
            }
         }
      }
   }


   /**************************************************************************/
// modified by Dmitry 15.05.13 updated
   function handleJogEvent( event, status )
   {
      root.log( "handleJogEvent event = " + event )

      if ( !root.focus_visible )
      {
         if ( status ==  UIListenerEnum.KEY_STATUS_PRESSED ||
              event ==  UIListenerEnum.JOG_WHEEL_RIGHT ||
              event ==  UIListenerEnum.JOG_WHEEL_LEFT )
         {
            root.showFocus()
         }
         return
      }

      if ( root.container_is_widget && root.__container_is_focused )
      {
         if ( event ==  UIListenerEnum.JOG_CENTER &&
              status ==  UIListenerEnum.KEY_STATUS_PRESSED ) // modified by Dmitry 16.05.13
         {
            root.__container_is_focused = false
            root.container_is_focused = false
            setDefaultFocusInContainer( event )
            root.showFocus()
            return
         }
      }

      if ( root.__current_index != -1 )
      {
         root.children[root.__current_index].handleJogEvent( event, status )
      }
      else
      {
         switch ( event )
         {
            case  UIListenerEnum.JOG_UP:
            case  UIListenerEnum.JOG_RIGHT:
            case  UIListenerEnum.JOG_DOWN: // added by yongkyun.lee 20130624 for : ITS 175870
            case  UIListenerEnum.JOG_LEFT:
	    //removed by aettie Focus moves when pressed 20131015
            //{
            //   if ( status ==  UIListenerEnum.KEY_STATUS_RELEASED )
            //   {
            //      root.lostFocus( event, 0 )
            //   }
            //}
            break

            case  UIListenerEnum.JOG_WHEEL_RIGHT: //CLOCK_WISE
            case  UIListenerEnum.JOG_WHEEL_LEFT: //ANTI_CLOCK_WISE
            {
               if ( status ==  UIListenerEnum.KEY_STATUS_PRESSED )
               {
                  root.lostFocus( event, 0 )
               }
            }
            break

            case  UIListenerEnum.JOG_CENTER: //SELECT
            {
                root.jogSelected( status ) // modified by Sergey 20.07.2013
            }
            break

            default:
            {
               root.log( "handleJogEvent - incorrect event" )
            }
         }
      }
   }
// modified by Dmitry 15.05.13 updated

   // { added by wspark 2013.04.03 for ISV 78422
   function handleTouchEvent( event )
   {
       root.lostFocus( event, 0 )
   }
   // } added by wspark

   /**************************************************************************/
   function lostFocusHandle( event, focusID )
   {
      root.log( "lostFocusHandle event = " + event )

      var next_x = -1
      var next_y = -1

      switch ( event )
      {
         case  UIListenerEnum.JOG_UP: //UP
         {
            next_x = root.__current_x
            next_y = root.__current_y - 1
         }
         break

         case  UIListenerEnum.JOG_RIGHT: //RIGHT
         {
            next_x = root.__current_x + 1
            if(next_x == 2)
                next_x = 1; //added by Michael.Kim for 2013.05.27 ISV Issue #83919
            next_y = root.__current_y
         }
         break

         case  UIListenerEnum.JOG_DOWN: //DOWN
         {
            next_x = root.__current_x
            next_y = root.__current_y + 1
         }
         break

         case  UIListenerEnum.JOG_LEFT: //LEFT
         {
            next_x = root.__current_x - 1
            if(next_x == -1)
                next_x = 0; //added by Michael.Kim for 2013.07.23 for New UX
            next_y = root.__current_y
         }
         break

         case  UIListenerEnum.JOG_WHEEL_RIGHT: //CLOCK_WISE
         case  UIListenerEnum.JOG_WHEEL_LEFT: //ANTI_CLOCK_WISE
         {
            root.log( "lostFocusHandle CLOCK_WISE/ANTI_CLOCK_WISE does not supported" )
            return -1
         }
         break

         default:
         {
            root.log( "handleJogEvent - incorrect event" )
            return -1
         }
      }

      if ( next_x < 0 || next_x >= root.__horizontal_size ||
           next_y < 0 || next_y >= root.__vertical_size )
      {
         root.log( "lostFocusHandle  next_x/next_y  [" + next_x + "][" + next_y + "]" )
         root.log( "lostFocusHandle  horiz/vertic size [" + root.__horizontal_size + "][" + root.__vertical_size + "]" )
         root.lostFocus( event, 0 )
         return 0
      }

      var item_index = root.searchIndex( next_x, next_y )

      if ( item_index == -1 )
      {
         root.log( "lostFocusHandle  item not found [" + next_x + "][" + next_y + "]" )
         root.log( "lostFocusHandle  start trying to check all row" )
         if ( event == UIListenerEnum.JOG_DOWN || event == UIListenerEnum.JOG_UP)
         {
            for ( var j = 0; j < root.__horizontal_size; ++j )
            {
               item_index = root.searchIndex( j, next_y )
               if (item_index != -1)
               {
                  next_x = j
                  root.log( "found appropriate item" )
                  break
               }
            }
         }
         if (item_index == -1)
         {
             root.log( "lostFocusHandle item not found in all row" )
             return -1
         }
      }

      if ( root.children[item_index].setDefaultFocus( event ) != -1 )
      {
         root.log( "lostFocusHandle - root.children[item_index].setDefaultFocus() != -1" )
         root.log( "lostFocusHandle item_index = " + item_index + " [" + next_x + "][" + next_y + "]" )
         root.hideFocus()
         root.__current_index = item_index
         root.__current_x = next_x
         root.__current_y = next_y
         root.showFocus()
      }
      else
      {
         root.log( "lostFocusHandle  - root.children[item_index].setDefaultFocus() == -1  [" + root.children[item_index].name + "]" )
      }

      return 0
   }


   /**************************************************************************/
   function searchIndex( pos_x, pos_y )
   {
      var index = -1
      var max_z = 0

      for ( var i = 0; i < root.children.length; i++ )
      {
         if ( root.children[i].is_focusable &&
              root.children[i].focus_x == pos_x &&
              root.children[i].focus_y == pos_y &&
              root.children[i].visible )
         {
            if ( index == -1 )
            {
               index = i
            }
            else
            {
               if ( root.children[i].focus_z > max_z )
               {
                  max_z = root.children[i].focus_z
                  index = i
               }
            }
         }
      }

      return index
   }


   /**************************************************************************/
   function recheckFocusHandle()
   {
      if ( root.focus_visible )
      {
         root.log( "recheckFocusHandle" )
         root.hideFocus()
         root.showFocus()
      }
   }


   /**************************************************************************/
   function moveFocusHandle( delta_x, delta_y )
   {
      root.log( "[Mike]moveFocusHandle" )
      root.log( "[Mike]moveFocusHandle [" + delta_x + "][" + delta_y + "]" )

      if ( delta_x || delta_y )
      {
         var index = searchIndex( root.__current_x + delta_x, root.__current_y + delta_y )

         if ( index != -1 )
         {
            if ( root.children[index].setDefaultFocus( UIListenerEnum.JOG_DOWN ) != -1 )
            {
               root.hideFocus()
               root.__current_index = index
               root.__current_x = root.__current_x + delta_x
               root.__current_y = root.__current_y + delta_y
               root.showFocus()
            }
         }
      }
   }


   /**************************************************************************/
   function log( str )
   {
      EngineListenerMain.qmlLog( "FocusedItem ["+ root.name +"]: " + str )
   }


   onLostFocus:
   {
      root.log( "onLostFocus  is_connected = " + root.is_connected )
   }

   onVisibleChanged:
   {
      root.log( "onVisibleChanged visble = " + root.visible )
      root.recheckFocus()
   }

   onJogSelected:
   {
      root.log( "onJogSelected" )
   }
}
