import Qt 4.7
import "DHAVN_AppClock_Main.js" as HM


Item
{
   id: mainScreen;
   width: HM.const_MAIN_SCREEN_WIDTH
   height: HM.const_MAIN_SCREEN_HEIGHT
   focus: true

   property string fontName: HM.FONT_BOLD
   Loader
   {
       id: clock_loader
       anchors.fill: parent
       source: ClockUpdate.fileLoad
   }

   MouseArea
   {
      anchors.fill: parent
      beepEnabled: false
      onClicked: ClockUpdate.TapOnScreen()
   }

   Connections
   {
       target: EngineListener
       onRetranslateUi:
       {
//           if(language > 2 && language < 5) fontName = "CHINESS_HDB" // "DFHeiW5-A"
//           else
               fontName = fontName
          LocTrigger.retrigger()
       }
   }

   Component.onCompleted:
   {
   }
}
