import Qt 4.7
import "DHAVN_AppStandBy_General.js" as General
import "DHAVN_AppStandBy_Images.js" as Images


Item //Image
{
   id: mergeMain;

   width: 1280
   height: 720
   focus: true

   property int focusIndex: General.const_APP_STANDBYCLOCK_FOCUSINDEX_NONE

   Connections {
       target:EngineListener
       onSetFocusIndex:
       {
           if ( screenId != UIListener.getCurrentScreen() )  return;
           focusIndex = index
       }
       onShowSos: {
           if ( screenId != UIListener.getCurrentScreen() )  return;
           sos_loader.source = "DHAVN_AppStandBy_SOS.qml"
           sos_loader.visible = true;

           idMain.visible = false
           idClock.visible = false
       }
       onHideSos: {
           if ( screenId != UIListener.getCurrentScreen() )  return;
           sos_loader.visible = false;
           sos_loader.source = ""
       }
       onQmlLoad:
       {
           if ( screenId != UIListener.getCurrentScreen() )  return;
           if ( state )
           {
               focusIndex = General.const_APP_STANDBYCLOCK_FOCUSINDEX_STANDBY_MAIN
               idMain.visible = true
               idClock.visible = false
           }
           else
           {
               focusIndex = General.const_APP_STANDBYCLOCK_FOCUSINDEX_CLOCK
               if ( idClock.source != "DHAVN_AppClock_main.qml" ) idClock.source = "DHAVN_AppClock_main.qml"
               idClock.visible = true
//               idMain.visible = false     // ISV 119310 언어변경 화면 내 drag 중 disp off 시 drag 멈추는 문제 수정 위해 visible 수정
           }
       }
   }

   DHAVN_AppStandBy_Background {
       id: idMain;
       y: 0;
       visible: true
   }

   Loader {id: idClock; y:0; visible: false }

   Loader {
       id: sos_loader;
       visible: false
       onVisibleChanged:
       {
       }
   }
}
