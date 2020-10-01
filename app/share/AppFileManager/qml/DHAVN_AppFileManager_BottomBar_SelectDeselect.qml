import QtQuick 1.0
import com.filemanager.uicontrol 1.0
import QmlBottomAreaWidget 1.0

DHAVN_AppFileManager_FocusedItemNew
{
   id: root

   anchors.bottom: parent.bottom

//{ added by yongkyun.lee 20130317 for : ISV 76129
   Connections
   {
      target: EngineListener
   
      onRetranslateUi:
      {
          LocTrigger.retrigger();
          select_deselect_bar.retranslateUI("main")
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

   CmdButtonAreaWidget
   {
      id: select_deselect_bar

      property string name: "BottomBar_SelecectDeselectAll"

      focus_id: 0
      btnModel: selectDeselectModel

      onCmdBtnArea_clicked:
      {
         switch ( btnId )
         {
            case "selectAll":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_SELECT_ALL )
            }
            break

            case "deselectAll":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_DESELECT_ALL )
            }
            break
         }
      }
   }

   ListModel
   {
      id: selectDeselectModel
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_SELECTALL")
         btn_id: "selectAll"
         btn_width: 640  //  1280 / 2
      }
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_SELEC_CLEAR")
         btn_id: "deselectAll"
         btn_width: 640  //  1280 / 2
      }
   }
}
