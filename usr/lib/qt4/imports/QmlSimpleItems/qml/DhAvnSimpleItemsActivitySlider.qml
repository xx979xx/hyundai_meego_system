import Qt 4.7
import "DhAvnSimpleItemsActivitySlider.js" as HM
import AppEngineQMLConstants 1.0

Image
{
   id: background_activitySlider

   /** true - current value "off", false - current value "on"*/
   property bool bCurrentActivitySlider
   /** true - value changes are possible. false - are not possible */
   property bool bEnabled: true
   /** false - big type, true - small type*/
   property bool bActivitySliderSmall: false

   property int focus_id: -1//read_only
   property bool is_focusable: true
   property bool focus_visible: false

   signal lostFocus ( int arrow, int focusID )

   source: bActivitySliderSmall ? "/app/share/images/autocare/bg_info_switch.png" :
                                  "/app/share/images/settings/bg_switch.png"

   /** Signal */
   signal switchPressed()

   function handleJogEvent(jogEvent) { }//empty method for Settings
   function showFocus() { focus_visible = true }
   function hideFocus() { focus_visible = false }
   function setDefaultFocus(arrow)
   {
      if ( bEnabled ) return focus_id
      lostFocus( arrow, focus_id )
      return -1
   }

   Connections
   {
      target: focus_visible && bEnabled ? UIListener: null
      onSignalJogCenterClicked: bCurrentActivitySlider = !bCurrentActivitySlider
      onSignalJogNavigation:
      {
//modified by aettie.ji 2013.04.30 for Click event deletion (for Focus ->Pressed / for Action -> Released) 
//         if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
         if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
            switch(arrow)
            {
               case UIListenerEnum.JOG_WHEEL_RIGHT:
                  bCurrentActivitySlider = true

               case UIListenerEnum.JOG_WHEEL_LEFT:
                  bCurrentActivitySlider = false

               default:
                  lostFocus( arrow,focus_id )
            }
         }
      }
   }

   /** focus */
   Rectangle
   {
      anchors.fill: parent
      anchors.margins: -5
      color: "transparent"
      border.color: "#0087EF"
      border.width: 5
      visible: focus_visible && bEnabled
      radius: 4
   }

   Image
   {
      id: tumbler
      y: -1
      source: bActivitySliderSmall ? "/app/share/images/autocare/info_switch.png" :
                                     "/app/share/images/settings/switch.png"
      transitions: Transition {
         PropertyAnimation { id: animate_slider; target: tumbler; properties: "x"; duration: 0 }
      }
      state: bCurrentActivitySlider ? "off" : "on"
      states: [
         State {
            name: "on"
            PropertyChanges { target: tumbler; x: 1 }
         },
         State {
            name: "off"
            PropertyChanges { target: tumbler; x: tumbler.sourceSize.width - 2 }
         }
      ]
   }

   onBCurrentActivitySliderChanged: switchPressed()

   MouseArea
   {
      anchors.fill: parent
      enabled: bEnabled
      onPositionChanged:
      {
         if ( mouseX <= tumbler.sourceSize.width ) bCurrentActivitySlider = false
         else bCurrentActivitySlider = true
      }
      onClicked:
      {
         if ( mouseX <= tumbler.sourceSize.width ) bCurrentActivitySlider = false
         else bCurrentActivitySlider = true
      }
   }

   Component.onCompleted: { animate_slider.duration = 200 }
}
