import Qt 4.7
import QtQuick 1.0
import "../DHAVN_AppPhoto_Constants.js" as CONST
import AppEngineQMLConstants 1.0

Item
{
   id: visualcue_rotation

   /** Properties */
   property bool is_focused: root.photo_focus_visible&&( root.photo_focus_index == root.focusEnum.cue )

   signal lostFocus(variant arrow) // added by Dmitry 18.05.13
   /** Signals */
   function left_clicked()
   {
      imageViewer.rotate(imageViewer.rotateDirections.left)
      //popup_screen.show( CONST.const_POPUP_ID_ROTATE_ANGLE ) //removed by eunhye 2012.11.17 for SANITY_CM_AK450
   }
   function right_clicked()
   {
      imageViewer.rotate(imageViewer.rotateDirections.right)
      //popup_screen.show( CONST.const_POPUP_ID_ROTATE_ANGLE ) //removed by eunhye 2012.11.17 for SANITY_CM_AK450
   }

   function ok_button_clicked()
   {
      imageViewer.save()
      popup_screen.show( CONST.const_POPUP_ID_VALUE_SAVED )
      root.state = "normal"
   }

   function lostFocus( arrow )
   {
      if( arrow == UIListenerEnum.JOG_UP )
      {
         photo_focus_index = mode_area.setDefaultFocus( arrow )
      }
   }

   // reset properties
   function reset()
   {
      visualcue_rotation_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_focused", false )
      visualcue_rotation_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_focused", false )
      visualcue_rotation_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", false )
      visualcue_rotation_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", false )
   }

   function handleJogEvent( arrow, status )
   {
      EngineListenerMain.qmlLog( "[MP_Photo] handleRotationJogEvents" )
      switch( arrow )
      {
         case UIListenerEnum.JOG_UP:
         case UIListenerEnum.JOG_DOWN:
         {
            if( status == UIListenerEnum.KEY_STATUS_CLICKED )
               visualcue_rotation.lostFocus( arrow )
            break
         }

         case UIListenerEnum.JOG_CENTER:
         {
            //if( status == UIListenerEnum.KEY_STATUS_CLICKED )
            if( status == UIListenerEnum.KEY_STATUS_PRESSED ) //modify by eunhye 2012.11.19 for No CR
            {
               imageViewer.save()
               popup_screen.show( CONST.const_POPUP_ID_VALUE_SAVED )
               root.state = "normal"
            }
            break
         }

         case UIListenerEnum.JOG_WHEEL_LEFT:
         {
            if( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               visualcue_rotation_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_focused", true )
            }
            else if( status == UIListenerEnum.KEY_STATUS_CLICKED )
            {
               EngineListenerMain.qmlLog( "[MP_Photo] Rotate to the left" )
               visualcue_rotation_model.setProperty( CONST.const_REW_BTN_NUMBER, "is_pressed", true )
               imageViewer.rotate(imageViewer.rotateDirections.left)
               //popup_screen.show( CONST.const_POPUP_ID_ROTATE_ANGLE ) //removed by eunhye 2012.11.17 for SANITY_CM_AK450
            }
            break
         }

         case UIListenerEnum.JOG_WHEEL_RIGHT:
         {
            if( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               visualcue_rotation_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_focused", true )
            }
            else if( status == UIListenerEnum.KEY_STATUS_CLICKED )
            {
               EngineListenerMain.qmlLog( "[MP_Photo] Rotate to the right" )
               visualcue_rotation_model.setProperty( CONST.const_FOR_BTN_NUMBER, "is_pressed", true )
               imageViewer.rotate(imageViewer.rotateDirections.right)
               //popup_screen.show( CONST.const_POPUP_ID_ROTATE_ANGLE ) //removed by eunhye 2012.11.17 for SANITY_CM_AK450
            }
            break
         }
      }
   }

   Row
   {
       id: bottomElements
       spacing: CONST.const_VISUAL_CUE_ELEMENTS_SPACING
       Repeater
       {
           model: visualcue_rotation_model
           delegate: btnDelegate
       }
   }

   Component
   {
       id: btnDelegate

       Image
       {
           id: rotation_image
           anchors.verticalCenter: parent.verticalCenter
           width: btn_width
           height: btn_height
           source: rotation_image.is_dimmed ? ( model.icon_d || "" ) :
                   ( mouseArea.pressed || rotation_image.is_pressed ? ( model.icon_p || "" ) :
                   ( rotation_image.is_focused ? ( model.icon_f || "") : ( model.icon_n || "" ) ) )

           property bool is_dimmed: model.is_dimmed || false
           property bool is_focused: model.is_focused || false
           property bool is_pressed: model.is_pressed || false

           /** Focus image */
           Image
           {
              id: focus_image
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              source: visualcue_rotation.is_focused && btn_id == "OK_Button"? icon_f : icon_n || ""
           }

           /** Icon image */
           Image
           {
               id: ok_icon
               anchors.horizontalCenter: parent.horizontalCenter
               anchors.top: parent.top
               anchors.topMargin: CONST.const_ROTATION_OK_BUTTON_TOP_MARGIN
           }

           /** Button text */
           Text
           {
               id: text_loader
               anchors.centerIn: parent
               color: is_dimmed ? CONST.const_COLOR_ROTATION_BTN_TEXT_DIMMED :
                                  CONST.const_COLOR_ROTATION_BTN_TEXT
               font.pointSize: CONST.const_ROTATION_BTN_TEXT_SIZE
               text: model.text || ""
           }

           MouseArea
           {
              id: mouseArea
              anchors.fill: parent
              enabled: !is_dimmed

              onClicked:
              {
                 switch( model.btn_id )
                 {
                    case "RotateLeft":
                    {
                       EngineListenerMain.qmlLog( "[MP_Photo] Rotate Left clicked" )
                       visualcue_rotation.left_clicked()
                       break;
                    }
                    case "RotateRight":
                    {
                       EngineListenerMain.qmlLog( "[MP_Photo] Rotate Right clicked" )
                       visualcue_rotation.right_clicked()
                       break;
                    }
                    case "OK_Button":
                    {
                       EngineListenerMain.qmlLog( "[MP_Photo] OK_Button clicked" )
                       visualcue_rotation.ok_button_clicked()
                       break;
                    }
                 }
              }
           }
       }
   }

   ListModel
   {
      id: visualcue_rotation_model

      ListElement
      {
         btn_id: "RotateLeft"

         // Rotation left button
         icon_p: "/app/share/images/photo/rotate_l_p.png"
         icon_n: "/app/share/images/photo/rotate_l_n.png"
         icon_d: "/app/share/images/photo/rotate_l_d.png"
         icon_f: "/app/share/images/photo/rotate_l_f.png"

         btn_width: 90
         btn_height: 96
         is_dimmed: false
         is_focused: false
         is_pressed: false
      }

      ListElement
      {
         btn_id: "OK_Button"

         icon_n: "/app/share/images/general/media_visual_cue_n.png"
         icon_d: "/app/share/images/general/media_visual_cue_d.png"
         icon_f: "/app/share/images/general/media_visual_cue_f.png"

         text: "OK"
//modified by aettie 20130625 for New GUI
         btn_width: 148
         btn_height: 157
         is_dimmed: false
         is_focused: false
         is_pressed: false
      }

      ListElement
      {
         btn_id: "RotateRight"

         // Rotation right button
         icon_p: "/app/share/images/photo/rotate_r_p.png"
         icon_n: "/app/share/images/photo/rotate_r_n.png"
         icon_d: "/app/share/images/photo/rotate_r_d.png"
         icon_f: "/app/share/images/photo/rotate_r_f.png"

         btn_width: 90
         btn_height: 96
         is_dimmed: false
         is_focused: false
         is_pressed: false
      }
   }
}
