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

      property string name: "BottomBar_CopyTo"

      focus_id: 0
      btnModel: copyToModel

      onCmdBtnArea_clicked:
      {
          // { added by eugeny.novikov 2012.11.26 for CR 15770
          if (backHandlerTimer.running)
          {
              root.log("onCmdBtnArea_clicked: Ignore event cause its a duplicate click from ModeArea");
              return;
          }
          // } added by eugeny.novikov 2012.11.26

         switch ( btnId )
         {
            case "copyHereId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_COPY_HERE )
            }
            break

            case "createFolderId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_CREATE_FOLDER )
            }
            break

            case "cancelId":
            {
               UIControl.bottomBarEventHandler( UIDef.BOTTOM_BAR_EVENT_CANCEL )
            }
            break
         }
      }
   }

   ListModel
   {
      id: copyToModel
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_COPY_HERE")
         btn_id: "copyHereId"
      }
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_NEW_FOLDER")
         btn_id: "createFolderId"
      }
      ListElement
      {
         name: QT_TR_NOOP("STR_MEDIA_MNG_CANCEL")
         btn_id: "cancelId"
      }
   }
}
