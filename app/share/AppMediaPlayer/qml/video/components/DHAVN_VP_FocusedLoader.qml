import Qt 4.7

Loader
{
   id: root

   property bool is_focusable: true
   property bool focus_visible: false
   property bool is_base_item: true

   property string name: "FocusedLoader"
   property int focus_x: -1
   property int focus_y: -1
   property int default_x: -1
   property int default_y: -1
   property int focus_z: 0

   signal lostFocus( int direction )
   signal recheckFocus()
   signal moveFocus( int delta_x, int delta_y )


   /**************************************************************************/
   function setDefaultFocus()
   {
      if ( root.status == Loader.Ready &&
           root.item.is_focusable )
      {
         root.log( "setDefFocus:  call sub item" )
         return root.item.setDefaultFocus()
      }

      return -1
   }


   /**************************************************************************/
   function hideFocus()
   {
      root.log( "hideFocus" )

      root.focus_visible = false

      if ( root.status == Loader.Ready &&
           root.item.is_focusable )
      {
         root.item.hideFocus()
      }
   }


   /**************************************************************************/
   function showFocus()
   {
      root.log( "showFocus" )

      root.focus_visible = true

      if ( root.status == Loader.Ready &&
           root.item.is_focusable )
      {
         root.item.showFocus()
      }
   }


   /**************************************************************************/
   function handleJogEvent( event, status )
   {
      root.log( "handleJogEvent event = " + event )

      if ( root.status == Loader.Ready &&
           root.item.is_focusable )
      {
         root.item.handleJogEvent( event, status )
      }
   }


   /**************************************************************************/
   function log( str )
   {
      EngineListenerMain.qmlLog( "FocusedLoader [" + root.name + "]: " + str )
   }


   onStatusChanged:
   {
      if ( root.status == Loader.Ready )
      {
         root.log( "onLoaded" )
         if ( !root.item.is_focusable )
         {
            root.log( "onLoaded - root.item.is_focusable = false " )
         }
         else
         {
            root.item.lostFocus.connect( root.lostFocus )
            root.item.recheckFocus.connect( root.recheckFocus )
            root.recheckFocus()
         }
      }
   }

   onVisibleChanged:
   {
      root.log( "onVisibleChanged visble = " + root.visible )
      root.recheckFocus()
   }
}
