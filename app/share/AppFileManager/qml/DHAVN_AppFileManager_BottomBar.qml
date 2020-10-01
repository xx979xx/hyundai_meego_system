import QtQuick 1.0
import QmlBottomAreaWidget 1.0
import com.filemanager.uicontrol 1.0

import "DHAVN_AppFileManager_General.js" as FM

DHAVN_AppFileManager_FocusedLoaderNew
{
   id: root
   node_id: 3

   signal bottomBarEvent( int event )

   height: FM.const_APP_FILE_MANAGER_RIGHT_BAR_HEIGHT
   width: FM.const_APP_FILE_MANAGER_RIGHT_BAR_WIDTH
   state: "InvisibleMode"

   name: "RightCmdButtons" // modified by eugeny.novikov 2012.11.26 for CR 15770

   Connections
   {
      target: EngineListener

      onRetranslateUi:
      {
          LocTrigger.retrigger();
      }
   }

   onStateChanged:
   {
      // EngineListener.qmlLog( "onStateChanged     --> " + state )
      switch( state )
      {
         case "CopyFromMode":
         {
            source = "DHAVN_AppFileManager_BottomBar_CopyFromMode.qml"
         }
         break

         case "CopyToMode":
         {
            source = "DHAVN_AppFileManager_BottomBar_CopyTo.qml"
         }
         break

         case "MoveToMode":
         {
            source = "DHAVN_AppFileManager_BottomBar_MoveTo.qml"
         }
         break

         case "SelectDeselectMode":
         {
            source = "DHAVN_AppFileManager_BottomBar_SelectDeselect.qml"
         }
         break

         case "DeleteMode":
         {
            source = "DHAVN_AppFileManager_BottomBar_Delete.qml"
         }
         break

         case "MoveMode":
         {
            source = "DHAVN_AppFileManager_BottomBar_Move.qml"
         }
         break
      }
   }

   Connections
   {
      target: UIControl

      onBottomBarModeChanged:
      {
         switch ( UIControl.bottomBarMode )
         {
            case UIDef.BOTTOM_BAR_INVISIBLE:
            {
               state = "InvisibleMode"
            }
            break

            case UIDef.BOTTOM_BAR_COPY_TO:
            {
               state = "CopyToMode"
            }
            break

            case UIDef.BOTTOM_BAR_COPY_FROM:
            {
               state = "CopyFromMode"
            }
            break

            case UIDef.BOTTOM_BAR_SELECT_DESELECT:
            {
                state = "SelectDeselectMode"
            }
            break

            case UIDef.BOTTOM_BAR_MOVE_TO:
            {
                state = "MoveToMode"
            }
            break

            case UIDef.BOTTOM_BAR_DELETE:
            {
                state = "DeleteMode"
            }
            break

            case UIDef.BOTTOM_BAR_MOVE:
            {
                state = "MoveMode"
            }
            break

            default:
            {
               // EngineListener.qmlLog( "AppFileManager::BottomBar:  onBottomBarModeChanged  incorrect mode" )
            }
         }
      }
   }

   states:
   [
      State
      {
         name: "InvisibleMode"
      },
      State
      {
         name: "CopyFromMode"
      },
      State
      {
         name: "CopyToMode"
      },
      State
      {
         name: "SelectDeselectMode"
      },
      State
      {
          name: "MoveToMode"
      },
      State
      {
          name: "DeleteMode"
      },
      State
      {
          name: "MoveMode"
      }

   ]

   Component.onCompleted:
   {
      root.bottomBarEvent.connect( UIControl.bottomBarEventHandler )
   }
}
