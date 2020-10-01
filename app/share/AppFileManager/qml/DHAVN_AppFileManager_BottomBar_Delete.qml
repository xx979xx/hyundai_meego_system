import QtQuick 1.0
import com.filemanager.uicontrol 1.0
import QmlBottomAreaWidget 1.0
import AppEngineQMLConstants 1.0

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
          deleteBar.retranslateUI("main")
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
      id: deleteBar
      middleEast: EngineListener.middleEast // added by Dmitry 03.05.13

      property string name: "BottomBar_Delete"

      focus_id: 0
      onBeep: EngineListener.MBeep() //added by Michael.Kim 2014.06.19 for ITS 240741

      onCmdBtnArea_clicked:
      {
         switch ( btnId )
         {
            case "deleteId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_DELETE )
            }
            break

            case "deleteAllId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_DELETE_ALL )
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

// modified by Dmitry 02.08.13 for ITS0181495
   ListModel
   {
      id: deleteModel
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE")
         btn_id: "deleteId"
         is_dimmed: false
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FOLDER_ALL")
         btn_id: "deleteAllId"
         is_dimmed: false
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_SELEC_CLEAR")
         btn_id: "deselectId"
         is_dimmed: false
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
         btn_id: "cancelId"
         is_dimmed: false
      }
   }

   ListModel
   {
      id: deleteModelNoSelection
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE")
         btn_id: "deleteId"
         is_dimmed: true
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE_FOLDER_ALL")
         btn_id: "deleteAllId"
         is_dimmed: false
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
         is_dimmed: false
      }
   }
// modified by Dmitry 02.08.13 for ITS0181495

   Binding
   {
      target: deleteBar
      property: "btnModel"
      value: deleteModel
      when: UIControl.currentDevice == UIDef.DEVICE_JUKEBOX && UIControl.deselectAllEnabled
   }

   Binding
   {
      target: deleteBar
      property: "btnModel"
      value: deleteModelNoSelection
      when: UIControl.currentDevice == UIDef.DEVICE_JUKEBOX && !UIControl.deselectAllEnabled
   }

}
