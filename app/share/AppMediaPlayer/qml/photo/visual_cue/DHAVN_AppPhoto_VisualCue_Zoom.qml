import Qt 4.7
import QtQuick 1.0
import "../DHAVN_AppPhoto_Constants.js" as CONST
import AppEngineQMLConstants 1.0

Item
{

   id: visualcue_zoom
   /** Signals */
   signal center_clicked();//?????? TODO
   signal lostFocus(variant arrow) // added by Dmitry 18.05.13

   /** Properties */
   property url centerImageUrl_n: "/app/share/images/general/media_visual_cue_n.png"
   property url centerImageUrl_f: "/app/share/images/general/media_visual_cue_f.png"
   property url centerImageUrl_p: "/app/share/images/general/media_visual_cue_p.png" //added by Michael.Kim 2014.02.27 for ITS 227487
   //modified by aettie for Master Car QE issue 20130523
   property url wheelLeftUrl: mainImage.scale <= 1 ? "/app/share/images/photo/photo_wheel_zoom_l_d.png" :
                             ( is_focused ? "/app/share/images/photo/photo_wheel_zoom_l_f.png" : //Changed by Alexey Edelev 2012.09.19. CR12989
                                            "/app/share/images/photo/photo_wheel_zoom_l_n.png" )
   property url wheelRightUrl: mainImage.scale >= 4 ? "/app/share/images/photo/photo_wheel_zoom_r_d.png" :
                             ( is_focused ? "/app/share/images/photo/photo_wheel_zoom_r_f.png" : //Changed by Alexey Edelev 2012.09.19. CR12989
                                            "/app/share/images/photo/photo_wheel_zoom_r_n.png" )
   property bool is_focused: root.photo_focus_visible&&( root.photo_focus_index == root.focusEnum.cue)
   property bool is_mouse_pressed: false
   /** reset properties */
   function reset()
   {
      // removed by sangmin.seol 2014.12.23 for ITS 254979
      visual_cue_zoom_model.setProperty( 1, "is_pressed", false )
      visual_cue_zoom_model.setProperty( 3, "is_pressed", false )
      visual_cue_zoom_model.setProperty( 5, "is_pressed", false )
      visual_cue_zoom_model.setProperty( 7, "is_pressed", false )
      // { added by ravikanth 12-12-13
      timerPressedAndHoldCritical.running = false
      timerPressedAndHoldCritical.lastPressed = ""
      // { added by ravikanth 12-12-13
      is_mouse_pressed = false

   }

// modified by Dmitry 15.05.13
   function handleJogEvent( arrow, status )
   {
      // EngineListenerMain.qmlLog( "[MP_Photo] handleZoomJogEvents()" +arrow )
      switch( arrow )
      {
      case UIListenerEnum.JOG_UP:
      {
         if( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
            visual_cue_zoom_model.setProperty( 1, "is_pressed", true ) // modified by sangmin.seol 2014.12.23 for ITS 254979
            timerPressedAndHoldCritical.lastPressed = "up_arrow"
            visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
            timerPressedAndHoldCritical.running = true

         }
         else if( status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )
         {
            visual_cue_zoom_model.setProperty( 1, "is_pressed", false ) // modified by sangmin.seol 2014.12.23 for ITS 254979
            timerPressedAndHoldCritical.running = false
         }
         break
      }

      case UIListenerEnum.JOG_DOWN:
      {
         if( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
            visual_cue_zoom_model.setProperty( 7, "is_pressed", true ) // modified by sangmin.seol 2014.12.23 for ITS 254979
            timerPressedAndHoldCritical.lastPressed = "down_arrow"
            visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
            timerPressedAndHoldCritical.running = true
         }
         else if( status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )
         {
            visual_cue_zoom_model.setProperty( 7, "is_pressed", false) // modified by sangmin.seol 2014.12.23 for ITS 254979
            timerPressedAndHoldCritical.running = false
         }
         break
      }

      case UIListenerEnum.JOG_LEFT:
      {
         if( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
            visual_cue_zoom_model.setProperty( 3, "is_pressed", true ) // modified by sangmin.seol 2014.12.23 for ITS 254979
            timerPressedAndHoldCritical.lastPressed = "left_arrow"
            visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
            timerPressedAndHoldCritical.running = true

         }
         else if( status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )
         {
            visual_cue_zoom_model.setProperty( 3, "is_pressed", false ) // modified by sangmin.seol 2014.12.23 for ITS 254979
            timerPressedAndHoldCritical.running = false
         }
         break
      }

      case UIListenerEnum.JOG_RIGHT:
      {
         if( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
            visual_cue_zoom_model.setProperty( 5, "is_pressed", true ) // modified by sangmin.seol 2014.12.23 for ITS 254979
            timerPressedAndHoldCritical.lastPressed = "right_arrow"
            visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
            timerPressedAndHoldCritical.running = true

         }
         else if( status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )
         {
            visual_cue_zoom_model.setProperty( 5, "is_pressed", false ) // modified by sangmin.seol 2014.12.23 for ITS 254979
            timerPressedAndHoldCritical.running = false
         }
         break
      }

      // { modified by ravikanth 11.06.2013
      case UIListenerEnum.JOG_TOP_RIGHT:
      {
         if( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
         //[NA][ITS][190683][minor](aettie.ji)
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visual_cue_zoom_model.setProperty( 1, "is_pressed", true )
            visual_cue_zoom_model.setProperty( 5, "is_pressed", true )
            // } modified by sangmin.seol 2014.12.23
            timerPressedAndHoldCritical.lastPressed = "up_right_arrow"
            visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
            timerPressedAndHoldCritical.running = true

         }
         else if( status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )
         {
         //[NA][ITS][190683][minor](aettie.ji)
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visual_cue_zoom_model.setProperty( 1, "is_pressed", false )
            visual_cue_zoom_model.setProperty( 5, "is_pressed", false )
            // } modified by sangmin.seol 2014.12.23
            timerPressedAndHoldCritical.running = false
         }
         break
      }

      case UIListenerEnum.JOG_BOTTOM_RIGHT:
      {
         if( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
         //[NA][ITS][190683][minor](aettie.ji)
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visual_cue_zoom_model.setProperty( 5, "is_pressed", true )
            visual_cue_zoom_model.setProperty( 7, "is_pressed", true )
            // } modified by sangmin.seol 2014.12.23
            timerPressedAndHoldCritical.lastPressed = "down_right_arrow"
            visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
            timerPressedAndHoldCritical.running = true

         }
         else if( status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )
         {
         //[NA][ITS][190683][minor](aettie.ji)
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visual_cue_zoom_model.setProperty( 5, "is_pressed", false )
            visual_cue_zoom_model.setProperty( 7, "is_pressed", false )
            // } modified by sangmin.seol 2014.12.23
            timerPressedAndHoldCritical.running = false
         }
         break
      }

      case UIListenerEnum.JOG_TOP_LEFT:
      {
         if( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
         //[NA][ITS][190683][minor](aettie.ji)
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visual_cue_zoom_model.setProperty( 1, "is_pressed", true )
            visual_cue_zoom_model.setProperty( 3, "is_pressed", true )
            // } modified by sangmin.seol 2014.12.23
            timerPressedAndHoldCritical.lastPressed = "up_left_arrow"
            visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
            timerPressedAndHoldCritical.running = true

         }
         else if( status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )
         {
         //[NA][ITS][190683][minor](aettie.ji)
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visual_cue_zoom_model.setProperty( 1, "is_pressed", false )
            visual_cue_zoom_model.setProperty( 3, "is_pressed", false )
            // } modified by sangmin.seol 2014.12.23
            timerPressedAndHoldCritical.running = false
         }
         break
      }

      case UIListenerEnum.JOG_BOTTOM_LEFT:
      {
         if( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
         //[NA][ITS][190683][minor](aettie.ji)
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visual_cue_zoom_model.setProperty( 3, "is_pressed", true )
            visual_cue_zoom_model.setProperty( 7, "is_pressed", true )
            // } modified by sangmin.seol 2014.12.23
            timerPressedAndHoldCritical.lastPressed = "down_left_arrow"
            visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
            timerPressedAndHoldCritical.running = true

         }
         else if( status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED )
         {
         //[NA][ITS][190683][minor](aettie.ji)
            // { modified by sangmin.seol 2014.12.23 for ITS 254979
            visual_cue_zoom_model.setProperty( 3, "is_pressed", false )
            visual_cue_zoom_model.setProperty( 7, "is_pressed", false )
            // } modified by sangmin.seol 2014.12.23
            timerPressedAndHoldCritical.running = false
         }
         break
      }
      // } modified by ravikanth 11.06.2013

      case UIListenerEnum.JOG_WHEEL_LEFT:
      {
         if( status == UIListenerEnum.KEY_STATUS_RELEASED ) // modified by Dmitry 18.05.13
         {
            visual_cue_zoom_model.setProperty( 0, "is_pressed", true )
            imageViewer.zoomOut()
         }
         break;
      }

      case UIListenerEnum.JOG_WHEEL_RIGHT:
      {
         if( status == UIListenerEnum.KEY_STATUS_RELEASED ) // modified by Dmitry 18.05.13
         {
            visual_cue_zoom_model.setProperty( 0, "is_pressed", true )
            imageViewer.zoomIn()
         }
         break;
      }

      case UIListenerEnum.JOG_CENTER:
      {
          if( status == UIListenerEnum.KEY_STATUS_PRESSED )
          {
              visual_cue_center.is_pressed = true; //added by Michael.Kim 2014.02.27 for ITS 227487
          }
          else if( status == UIListenerEnum.KEY_STATUS_RELEASED )
          {
          //restored by aettie 20130904 for ITS_185782
              if(!imageViewer.imageLargerThanScreen)
                  root.state = (root.state === "normal") ? "fullScreen" : "normal"
              else
                  root.state = (root.state === "normal") ? "zoom" : "normal"
              visual_cue_center.is_pressed = false; //added by Michael.Kim 2014.02.27 for ITS 227487
          }
          // {added by Michael.Kim 2014.04.07 for ITS 233607
          else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
          {
             visual_cue_center.is_pressed = false;
          }
          // }added by Michael.Kim 2014.04.07 for ITS 233607
          break
      } // added by Sergey 28.05.2013

      default:
         break
      }
   }
// modified by Dmitry 15.05.13

   Image
   {
      id: visual_cue_center

      property bool is_pressed: false //added by Michael.Kim 2014.02.27 for ITS 227487

      anchors.horizontalCenter: visualcue_zoom.horizontalCenter
      anchors.verticalCenter: visualcue_zoom.verticalCenter
      source: is_pressed ? centerImageUrl_p : ( visualcue_zoom.is_focused ? centerImageUrl_f : centerImageUrl_n ) // modified by sangmin.seol 2014.12.23 for ITS 254979

      MouseArea
      {
         id: centerMouseArea
         anchors.fill:  parent
         beepEnabled: false //added by Michael.Kim 2014.07.04 for ITS 240747

         onPressed:
         {
            visual_cue_center.is_pressed = true; //added by Michael.Kim 2014.02.27 for ITS 227487
         }

         onClicked:
         {
         //[KOR][ITS][178095][ minor](aettie.ji)
            //visualcue_zoom.center_clicked()
            // {modified by Michael.Kim 2013.12.27 for ITS 217362
            //EngineListenerMain.qmlLog("Do nothing");
            EngineListenerMain.ManualBeep() // added by Michael.Kim 2014.07.04 for ITS 240747
            if(!imageViewer.imageLargerThanScreen)
                root.state = (root.state === "normal") ? "fullScreen" : "normal"
            else
                root.state = (root.state === "normal") ? "zoom" : "normal"
            // }modified by Michael.Kim 2013.12.27 for ITS 217362
            visual_cue_center.is_pressed = false; //added by Michael.Kim 2014.02.27 for ITS 227487
         }

         onReleased:
         {
             visual_cue_center.is_pressed = false; //added by Michael.Kim 2014.02.27 for ITS 227487
         }
         onExited:
         {
             visual_cue_center.is_pressed = false; //added by Michael.Kim 2014.02.27 for ITS 227487
         }
         onCanceled:
         {
             visual_cue_center.is_pressed = false; //added by Michael.Kim 2014.02.27 for ITS 227487
         }
      }
   }

   Image
   {
      id: wheelLeft
      anchors.top: visual_cue_center.top
      anchors.topMargin: CONST.const_VISUAL_CUE_WHEEL_TOP_MARGIN
      anchors.left: visual_cue_center.left
      anchors.leftMargin: CONST.const_VISUAL_CUE_WHEEL_L_LEFT_MARGIN
      source: wheelLeftUrl
   }

   Image
   {
      id: wheelRight
      anchors.top: visual_cue_center.top
      anchors.topMargin: CONST.const_VISUAL_CUE_WHEEL_TOP_MARGIN
      anchors.left: visual_cue_center.left
      anchors.leftMargin: CONST.const_VISUAL_CUE_WHEEL_R_LEFT_MARGIN
      source: wheelRightUrl
   }

   GridView
   {
      id: arrow_elements
      interactive:  false
      model: visual_cue_zoom_model
      delegate: vc_delegate
      width: 300
      height: 300
      anchors.horizontalCenter: visual_cue_center.horizontalCenter
      anchors.verticalCenter: visual_cue_center.verticalCenter
      visible: true
   }

   Component
   {
      id: vc_delegate

      Item
      {
         width: 100
         height: 100

         Image
         {
            id: arrow_image
            //modified by aettie.ji 2013.02.08
            //anchors.fill:  parent
            anchors.centerIn: parent
            width: model.icon_width
            height: model.icon_height
            //modified by aettie.ji 2013.02.08
            // removed by sangmin.seol 2014.12.23 for ITS 254979
            property bool is_pressed: model.is_pressed || false
         //[KOR][ITS][181070][minor](aettie.ji)
            source: (mouseArea.pressed && is_mouse_pressed )|| arrow_image.is_pressed ? (model.icon_source_p || "") : (model.icon_source_n || "") // modified by sangmin.seol 2014.12.23 for ITS 254979
         }

         MouseArea
         {
            id: mouseArea
            enabled: arrow_image.source != ""
            anchors.fill:  parent
            beepEnabled: false //added by Michael.Kim 2014.07.04 for ITS 240747
            onPressed:
            {
               EngineListenerMain.ManualBeep() // added by Michael.Kim 2014.07.04 for ITS 240747
               timerPressedAndHoldCritical.lastPressed = model.btn_id
               visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
               timerPressedAndHoldCritical.running = true
               is_mouse_pressed = true
            }
            onReleased:
            {
               reset()
            }
            // { modified by ravikanth 22-03-13
            onCanceled:
            {
                reset()
            }
            // } modified by ravikanth 22-03-13

            onExited:
            {
                reset()
            }
         }
      }
   }

   function move_image(btn_id)
   {
      switch( btn_id )
      {
      case "up_arrow":
      {
         imageViewer.cueMove(imageViewer.moveDirections.up)
         break;
      }

      case "left_arrow":
      {
         imageViewer.cueMove(imageViewer.moveDirections.left)
         break;
      }

      case "right_arrow":
      {
         imageViewer.cueMove(imageViewer.moveDirections.right)
         break;
      }

      case "down_arrow":
      {
         imageViewer.cueMove(imageViewer.moveDirections.down)
         break;
      }
      // { modified by ravikanth 11.06.2013
      case "up_right_arrow":
      {
         imageViewer.cueMove(imageViewer.moveDirections.upright)
         break;
      }
      case "down_right_arrow":
      {
         imageViewer.cueMove(imageViewer.moveDirections.downright)
         break;
      }
      case "up_left_arrow":
      {
         imageViewer.cueMove(imageViewer.moveDirections.upleft)
         break;
      }
      case "down_left_arrow":
      {
         imageViewer.cueMove(imageViewer.moveDirections.downleft)
         break;
      }
      // } modified by ravikanth 11.06.2013
      }
   }

   Timer {
      id: timerPressedAndHoldCritical
      interval: 50
      repeat: true
      property string lastPressed: ""
      onTriggered:
      {
           visualcue_zoom.move_image(timerPressedAndHoldCritical.lastPressed)
      }
   }

   ListModel {
      id: visual_cue_zoom_model

      ListElement  { }
      ListElement
      {
         btn_id: "up_arrow"
         icon_source_n: "/app/share/images/photo/photo_visual_cue_u_n.png"
         icon_source_p: "/app/share/images/photo/photo_visual_cue_u_p.png"
         icon_source_d: "/app/share/images/photo/photo_visual_cue_u_d.png"
         icon_source_f: "/app/share/images/photo/photo_visual_cue_u_f.png"
         // removed by sangmin.seol 2014.12.23 for ITS 254979
         is_pressed: false
         //added by aettie.ji 2013.02.08
         icon_width: 85
         icon_height: 65
      }

      ListElement  { }
      ListElement
      {
         btn_id: "left_arrow"
         icon_source_n: "/app/share/images/photo/photo_visual_cue_l_n.png"
         icon_source_p: "/app/share/images/photo/photo_visual_cue_l_p.png"
         icon_source_d: "/app/share/images/photo/photo_visual_cue_l_d.png"
         icon_source_f: "/app/share/images/photo/photo_visual_cue_l_f.png"
         // removed by sangmin.seol 2014.12.23 for ITS 254979
         is_pressed: false
         //added by aettie.ji 2013.02.08
         icon_width: 65
         icon_height: 77
      }

      ListElement { }
      ListElement
      {
         btn_id: "right_arrow"
         icon_source_n: "/app/share/images/photo/photo_visual_cue_r_n.png"
         icon_source_p: "/app/share/images/photo/photo_visual_cue_r_p.png"
         icon_source_d: "/app/share/images/photo/photo_visual_cue_r_d.png"
         icon_source_f: "/app/share/images/photo/photo_visual_cue_r_f.png"
         // removed by sangmin.seol 2014.12.23 for ITS 254979
         is_pressed: false
         //added by aettie.ji 2013.02.08
         icon_width: 65
         icon_height: 77
      }

      ListElement { }
      ListElement
      {
         btn_id: "down_arrow"
         icon_source_n: "/app/share/images/photo/photo_visual_cue_d_n.png"
         icon_source_p: "/app/share/images/photo/photo_visual_cue_d_p.png"
         icon_source_d: "/app/share/images/photo/photo_visual_cue_d_d.png"
         icon_source_f: "/app/share/images/photo/photo_visual_cue_d_f.png"
         // removed by sangmin.seol 2014.12.23 for ITS 254979
         is_pressed: false
         //added by aettie.ji 2013.02.08
         icon_width: 85
         icon_height: 65
      }
      ListElement { }
   }
}
