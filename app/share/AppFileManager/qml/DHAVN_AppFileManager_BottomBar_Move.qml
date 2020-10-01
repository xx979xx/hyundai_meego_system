import QtQuick 1.0
import com.filemanager.uicontrol 1.0
import QmlBottomAreaWidget 1.0

DHAVN_AppFileManager_FocusedItemNew
{
   id: root

   node_id: 3

//{ added by yongkyun.lee 20130317 for : ISV 76129
   Connections
   {
      target: EngineListener
   
      onRetranslateUi:
      {
          LocTrigger.retrigger();
          moveBar.retranslateUI("main")
      }
   }
//} added by yongkyun.lee 20130317 

   onShowFocus:
   {
      deleteBar.setDefaultFocus(UIListenerEnum.JOG_RIGHT)
      deleteBar.showFocus()
   }

   onHideFocus:
   {
      deleteBar.hideFocus()
   }

   RightCmdButtonAreaWidget
   {
      id: moveBar
      middleEast: EngineListener.middleEast // added by Dmitry 03.05.13

      property string name: "BottomBar_Move"

      focus_id: 0

      onCmdBtnArea_clicked:
      {
         switch ( btnId )
         {
            case "moveId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_MOVE )
            }
            break

            case "moveAllId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_MOVE_ALL )
            }
            break

            case "deselectId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_DESELECT_ALL )
            }
            break

            case "cancelId":
            {
                UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_CANCEL_ON_FIRST_LEVEL )
            }
            break
         }
      }
   }

   ListModel
   {
      id: moveModel
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_MOVE")
         btn_id: "moveId"
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_MOVE_ALL")
         btn_id: "moveAllId"
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_SELEC_CLEAR")
         btn_id: "deselectId"
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
         btn_id: "cancelId"
      }
   }

   ListModel
   {
      id: moveModelNoSelection
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_MOVE")
         btn_id: "moveId"
         is_dimmed: true
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_MOVE_ALL")
         btn_id: "moveAllId"
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_SELEC_CLEAR")
         btn_id: "deselectId"
         is_dimmed: true
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
         btn_id: "cancelId"
      }
   }

   Binding
   {
      target:moveBar
      property: "btnModel"
      value: moveModel
      when: UIControl.currentDevice == UIDef.DEVICE_JUKEBOX && UIControl.deselectAllEnabled
   }

   Binding
   {
      target: moveBar
      property: "btnModel"
      value: moveModelNoSelection
      when: UIControl.currentDevice == UIDef.DEVICE_JUKEBOX && !UIControl.deselectAllEnabled
   }

}
