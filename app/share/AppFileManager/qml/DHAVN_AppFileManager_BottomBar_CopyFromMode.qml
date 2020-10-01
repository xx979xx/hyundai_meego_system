import QtQuick 1.0
import com.filemanager.uicontrol 1.0
import QmlBottomAreaWidget 1.0
import AppEngineQMLConstants 1.0

DHAVN_AppFileManager_FocusedItemNew
{
   id: root

   node_id: 3
   anchors.bottom: parent.bottom

//{ added by yongkyun.lee 20130317 for : ISV 76129
   Connections
   {
      target: EngineListener
   
      onRetranslateUi:
      {
          LocTrigger.retrigger();
          copyFromBar.retranslateUI("main")
      }
   }
//} added by yongkyun.lee 20130317

   onShowFocus:
   {
      copyFromBar.setDefaultFocus(UIListenerEnum.JOG_RIGHT)
      copyFromBar.showFocus()
   }

   onHideFocus:
   {
      copyFromBar.hideFocus()
   }
       
   RightCmdButtonAreaWidget
   {
      id: copyFromBar
      middleEast: EngineListener.middleEast // added by Dmitry 03.05.13

      property string name: "BottomBar_CopyFrom"

      focus_id: 0
      onBeep: EngineListener.MBeep() //added by Michael.Kim 2014.06.19 for ITS 240741

      onCmdBtnArea_clicked:
      {
         switch ( btnId )
         {
            case "copyId":
            {
             //UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_COPY )    //deleted by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_COPY_HERE ) //added by yungi 2013.2.7 for UX Scenario 5. File Copy step reduction
            }
            break

            case "deleteId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_DELETE )
            }
            break

            case "copyAllId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_COPY_ALL )
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
      id: copyFromUSBModel
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_COPY")
         btn_id: "copyId"
         is_dimmed: false
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_COPY_ALL")
         btn_id: "copyAllId"
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
      id: copyFromUSBModelNoSelection
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_COPY")
         btn_id: "copyId"
         is_dimmed: true
      }

      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_COPY_ALL")
         btn_id: "copyAllId"
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
      target: copyFromBar
      property: "btnModel"
      value: copyFromUSBModel
      when: UIControl.currentDevice == UIDef.DEVICE_USB && UIControl.deselectAllEnabled
   }

   Binding
   {
      target: copyFromBar
      property: "btnModel"
      value: copyFromUSBModelNoSelection
      when: UIControl.currentDevice == UIDef.DEVICE_USB && !UIControl.deselectAllEnabled
   }

}
