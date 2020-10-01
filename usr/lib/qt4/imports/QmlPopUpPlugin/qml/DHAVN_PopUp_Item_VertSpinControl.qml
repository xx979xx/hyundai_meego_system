import Qt 4.7
import "DHAVN_PopUp_Item_VertSpinControl.js" as HM
//import "DHAVN_PopUp_Item_VertSpinControl_Resource.js" as RES
import "DHAVN_PopUp_Resources.js" as RES
import AppEngineQMLConstants 1.0

Item
{
   id: spin_control

   property int const_SETTINGS_SPIN_CONTROL : 0
   property int const_INFO_SPIN_CONTROL : 1
   property int const_VIDEO_PLAYER_SPIN_CONTROL : 2
   property bool bLargeSpiner:false
   property bool prev_Pressed
   property bool next_Pressed
   property bool press_Canceled:false

   /** list of text that should be shown in SpinControl*/
   property ListModel aSpinControlTextModel: ListModel{}

   /**const_SETTINGS_SPIN_CONTROL, const_INFO_SPIN_CONTROL, const_VIDEO_PLAYER_SPIN_CONTROL */
   property int iSpinCtrlType: const_VIDEO_PLAYER_SPIN_CONTROL


   /**is SpinControl text can be changed*/
   property bool bEnabled: true
   property bool _selectionMode:false

   /**Focus properties */

   property int focus_id: -1//read_only
  // property int focus_index: 0
   property bool focus_visible: false
   property bool is_focusable: true
   property bool focusOnPrev: true
   property string _fontFamily

   property string sFocusedColor: Qt.rgba( 0, 0.5, 1, 0.6 )

   signal lostFocus ( int arrow, int focusID )
   signal recheckFocus()

   property int minimum: 0
   property int maximum: 0
   property int step: 1

   property string sCurrentValue: /*( bSpinCtrlArrowType == true )*/aSpinControlTextModel.count>0 ? qsTranslate( __lang_context, aSpinControlTextModel.get(__index).text) + __emptyString
                                                               : ( spin_control.minimum ).toString()
    onSCurrentValueChanged: spin_control.spinControlValueChanged()
   /**index of current text*/
   property int __index: 0
   property string __emptyString : ""
   property string __lang_context: HM.const_SPIN_CTRL_LANGCONTEXT

   /**count of values of text*/
   property int __count: ( aSpinControlTextModel.count > 0 /*bSpinCtrlArrowType == true*/ ) ? aSpinControlTextModel.count
                                                        : ( maximum - minimum ) / step + 1
    onMaximumChanged: {
        console.log( "[SystemPopUp] onMaximumChanged to " + maximum )
        //count refresh
        __count = ( aSpinControlTextModel.count > 0 ) ? aSpinControlTextModel.count : ( maximum - minimum ) / step + 1
        console.log( "[SystemPopUp] onMaximumChanged __count changed "+__count )
        //__index refresh
        __index = __index >= __count ? __count -1 : __index
        console.log( "[SystemPopUp] onMaximumChanged index changed "+__index )
        //sCurrentValue refresh
        sCurrentValue = (aSpinControlTextModel.count > 0 ) ? aSpinControlTextModel.get( __index ).text : ( minimum + ( __index * step ) ).toString()
        console.log( "[SystemPopUp] onMaximumChanged sCurrentValue changed "+ sCurrentValue )

    }

//    onMinimumChanged:  {
//        __index = __index < __count ? __count -1 : __index
//    }

   /**resources for SpinControl*/
   property url __bg_spin_control: RES.const_POPUP_TIME_PICKER_FRAME_L_n
   property url __btn_arrow_l_n: RES.const_POPUP_TIME_PICKER_BUTTON_L_N//( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_ARROW_L_N : RES.const_URL_IMG_GENERAL_ARROW_LEFT_L_N
   property url __btn_arrow_l_p: RES.const_POPUP_TIME_PICKER_BUTTON_L_P//( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_ARROW_L_P : RES.const_URL_IMG_GENERAL_ARROW_LEFT_L_P
   property url __btn_arrow_r_n: RES.const_POPUP_TIME_PICKER_BUTTON_L_N//( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_ARROW_R_N : RES.const_URL_IMG_GENERAL_ARROW_RIGHT_R_N
   property url __btn_arrow_r_p: RES.const_POPUP_TIME_PICKER_BUTTON_L_P//( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_ARROW_R_P : RES.const_URL_IMG_GENERAL_ARROW_RIGHT_R_P
   property url __btn_plus_n: RES.const_POPUP_TIME_PICKER_BUTTON_L_N
   property url __btn_plus_p: RES.const_POPUP_TIME_PICKER_BUTTON_L_P
   property url __btn_minus_n: RES.const_POPUP_TIME_PICKER_BUTTON_L_N
   property url __btn_minus_p: RES.const_POPUP_TIME_PICKER_BUTTON_L_P

   /** Signals */
   signal spinControlValueChanged

   function retranslateUI(context)
   {
      if (context) { __lang_context = context }
      __emptyString = " "
      __emptyString = ""
   }

   function incrementValue()
   {
       console.log( "[SystemPopUp] spin_control.__increment() " )
      spin_control.__increment()
      spin_control.spinControlValueChanged()
   }

   function decrementValue()
   {
       console.log( "[SystemPopUp] spin_control.__decrement() " )
      spin_control.__decrement()
      spin_control.spinControlValueChanged()
   }

   /**used for transition to next text*/
   function __increment()
   {
       console.log( "[SystemPopUp] .__increment() " )
     if( __index < __count - 1 )
     {
       __index++;
     }
     else /*if( aSpinControlTextModel.count < 1)//spin_control.bSpinCtrlArrowType == false )
          {
            __index = __count - 1
          }
          else*/
          {
            __index = 0;
          }
     // if SpinControl with Arrows use values from model else assume value as a member of arithmetic progression
     spin_control.sCurrentValue = (aSpinControlTextModel.count > 0 /*spin_control.bSpinCtrlArrowType == true*/ ) ? aSpinControlTextModel.get( __index ).text
                                                                              : ( minimum + ( __index * step ) ).toString()
   }

   /**used for transition to previous text*/
   function __decrement()
   {
       console.log( "[SystemPopUp] .__decrement() " )
     if( __index == 0)// && aSpinControlTextModel.count > 0 /*spin_control.bSpinCtrlArrowType == true*/ )
     {
       __index = __count - 1;
     }
//     else
//     {
//       if( __index == 0 && aSpinControlTextModel.count < 1/*spin_control.bSpinCtrlArrowType == false*/ )
//       {
//         __index = 0
//       }
       else
       {
         __index--;
       }
     //}

     // if SpinControl with Arrows use values from model else assume value as a member of arithmetic progression
     spin_control.sCurrentValue = ( aSpinControlTextModel.count > 0/*spin_control.bSpinCtrlArrowType == true*/ ) ? aSpinControlTextModel.get( __index ).text
                                                                              : ( minimum + ( __index * step ) ).toString()

//     if( spin_control.bSpinCtrlTextType == false )
//     {
//        colorRectangle.color = ( aSpinControlTextModel.get( __index ) ).text
//     }
   }

   /**used for set text*/
   function setValue( v )
   {
     if(aSpinControlTextModel.count > 0/* spin_control.bSpinCtrlArrowType == true*/ )
     {
       /**find value in delegate*/
       for( var i = 0; i < __count; i++ )
       {
         if( ( aSpinControlTextModel.get( i ) ).text == v )
         {
           __index = i;
           break;
         }
       }
     }
     else
     {
       if( minimum <= v && v <= maximum )
       {
          __index = ( v - minimum ) / step
       }
     }

     // if SpinControl with Arrows use values from model else assume value as a member of arithmetic progression
     spin_control.sCurrentValue = /*( spin_control.bSpinCtrlArrowType == true )*/aSpinControlTextModel.count>0 ? aSpinControlTextModel.get( __index ).text
                                                                              : ( minimum + ( __index * step ) ).toString()

//     if( spin_control.bSpinCtrlTextType == false )
//     {
//        colorRectangle.color = ( aSpinControlTextModel.get( __index ) ).text
//     }
   }

   function showFocus() { focus_visible = true }
   function hideFocus() { focus_visible = false }
   function setDefaultFocus(arrow)
   {
      if ( bEnabled )
      {
         switch( arrow )
         {
            case UIListenerEnum.JOG_LEFT:
            {
              focusOnPrev = false
            }

            default:
            {
              focusOnPrev = true
            }
         }
         return focus_id
      }
      else
      {
         lostFocus( arrow, focus_id )
         console.log( "[SystemPopUp] [ActivitySlider]lost_focus = "+arrow )
         return -1
      }
   }

   function handleJogEvent(jogEvent) { }//empty method for Settings

   Connections
   {
      target: focus_visible && bEnabled && _selectionMode ? UIListener: null

      onSignalJogNavigation:
      {
         console.log("[SystemPopUp] [SpinControl]onSignalJogNavigation arrow=" + arrow)
         switch(status)//if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
         {
             case UIListenerEnum.KEY_STATUS_PRESSED:
             {
                    console.log("[SystemPopUp] [SpinControl]focus lost arrow: " + arrow )
                    switch( arrow )
                    {
                        case UIListenerEnum.JOG_UP:
                            prev_Pressed=true
                            incrementValue();
                            id_long_Press_timer.start();
                            break;
                       case UIListenerEnum.JOG_WHEEL_RIGHT:
                       {
                           prev_Pressed=false;
                           incrementValue();
                           break;
                       }
                       case UIListenerEnum.JOG_DOWN:
                           next_Pressed=true
                           decrementValue();
                           id_long_Press_timer.start();
                           break;
                       case UIListenerEnum.JOG_WHEEL_LEFT:
                       {
                           next_Pressed=false;
                           decrementValue();
                           break;
                       }
                       default:
                       {
                          lostFocus( arrow ,focus_id)
                          break
                       }

                    }
                    break;
             }
//             case UIListenerEnum.KEY_STATUS_PRESSED:
//             {
//                 console.log("JOG PRESSED")
//                 switch( arrow )
//                 {
//                     case UIListenerEnum.JOG_UP:
//                     case UIListenerEnum.JOG_WHEEL_RIGHT:
//                     {
//                         prev_Pressed=true
//                         id_long_Press_timer.start();
//                         break;
//                     }
//                     case UIListenerEnum.JOG_DOWN:
//                     case UIListenerEnum.JOG_WHEEL_LEFT:
//                     {
//                         next_Pressed=true
//                         id_long_Press_timer.start();
//                         break;
//                     }

//                     default:
//                         break;
//                 }
//                 break;
//             }
             case UIListenerEnum.KEY_STATUS_RELEASED:
             {
                 console.log("[SystemPopUp] JOG RELEASED")
                 switch( arrow )
                 {
                     case UIListenerEnum.JOG_UP:
                     {
                         id_long_Press_timer.stop()
                     }
                     case UIListenerEnum.JOG_WHEEL_RIGHT:
                     {
                         prev_Pressed=false
                         inc_repeater.stop()
                         break;
                     }
                     case UIListenerEnum.JOG_DOWN:
                     {
                         id_long_Press_timer.stop()
                     }
                     case UIListenerEnum.JOG_WHEEL_LEFT:
                     {
                         next_Pressed=false
                         dec_repeater.stop()
                         break;
                     }

                     default:
                         break;
                 }
                 break;
             }
             case UIListenerEnum.KEY_STATUS_CANCELED:
             {
                 console.log("[SystemPopUp] JOG CANCEL")
                 switch( arrow )
                 {
                     case UIListenerEnum.JOG_UP:
                     {
                         id_long_Press_timer.stop()
                     }
                     case UIListenerEnum.JOG_WHEEL_RIGHT:
                     {
                         prev_Pressed=false
                         inc_repeater.stop()
                         break;
                     }
                     case UIListenerEnum.JOG_DOWN:
                     {
                         id_long_Press_timer.stop()
                     }
                     case UIListenerEnum.JOG_WHEEL_LEFT:
                     {
                         next_Pressed=false
                         dec_repeater.stop()
                         break;
                     }

                     default:
                         break;
                 }
                 break;
             }
         }
      }
   }

   width: bLargeSpiner == true ? 161 : 107
   height: background_spin_control.height/*( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? HM.const_SPIN_CTRL_SETTINGS_HEIGHT
                                                            : ( ( iSpinCtrlType == const_INFO_SPIN_CONTROL ) ? HM.const_SPIN_CTRL_INFO_HEIGHT
                                                                                                             : ( ( bSpinCtrlArrowType == true) ? HM.const_SPIN_CTRL_VIDEO_HEIGHT
                                                                                                                                               : HM.const_SPIN_CTRL_VIDEO_PLUS_MINUS_HEIGHT ) )*/
   /** focus */
//   Rectangle
//   {
//      id: focus_rect
//      anchors.centerIn: spin_control
//      height: spin_control.height + 8
//      width: spin_control.width + 8
//      color: sFocusedColor
//      visible: bEnabled && spin_control.focus_visible
//      radius: 4
//      //z:1
//   }

   /**background*/
   Image
   {
     id: background_spin_control
     anchors.centerIn: spin_control
     source: bLargeSpiner == true ? (bEnabled && spin_control.focus_visible) ?  RES.const_POPUP_TIME_PICKER_FRAME_L_f : RES.const_POPUP_TIME_PICKER_FRAME_L_n :
     (bEnabled && spin_control.focus_visible) ? RES.const_POPUP_TIME_PICKER_FRAME_S_f : RES.const_POPUP_TIME_PICKER_FRAME_S_n
     //bLargeSpiner == true ? (bEnabled && spin_control.focus_visible) ? RES.const_POPUP_TIME_PICKER_FRAME_L_f : RES.const_POPUP_TIME_PICKER_FRAME_L_n : (bEnabled && spin_control.focus_visible) ? RES.const_POPUP_TIME_PICKER_FRAME_S_f : RES.const_POPUP_TIME_PICKER_FRAME_S_n
   }
   Image
   {
     id: disable_mask
     anchors.centerIn: spin_control
     z:10000
     source: bLargeSpiner == true ? "" :
                                    !bEnabled  ? RES.const_POPUP_TIME_PICKER_SPINER_DISABLE_MASK : ""
     //bLargeSpiner == true ? (bEnabled && spin_control.focus_visible) ? RES.const_POPUP_TIME_PICKER_FRAME_L_f : RES.const_POPUP_TIME_PICKER_FRAME_L_n : (bEnabled && spin_control.focus_visible) ? RES.const_POPUP_TIME_PICKER_FRAME_S_f : RES.const_POPUP_TIME_PICKER_FRAME_S_n
   }

   /**previous button*/
   Image
   {
     id: btn_prev
     anchors.top: parent.top
     anchors.horizontalCenter: parent.horizontalCenter
     source:{
         if(bLargeSpiner == true)
         {
             if(prev_Pressed == true)
                 RES.const_POPUP_TIME_PICKER_BUTTON_L_P
             else
                 (spin_control.focus_visible&&_selectionMode) ? RES.const_POPUP_TIME_PICKER_BUTTON_L_F : RES.const_POPUP_TIME_PICKER_BUTTON_L_N
         }
         else{
             if(prev_Pressed == true)
                 RES.const_POPUP_TIME_PICKER_BUTTON_s_P
             else
                 (spin_control.focus_visible&&_selectionMode) ? RES.const_POPUP_TIME_PICKER_BUTTON_s_F : RES.const_POPUP_TIME_PICKER_BUTTON_s_N
         }
     }
     z:2
     Image
     {
         source:{
             if (bEnabled == true)
                RES.const_POPUP_TIME_PICKER_ARROW_U_f
             else
                RES.const_POPUP_TIME_PICKER_ARROW_U_n
         }
         anchors.verticalCenter: btn_prev.verticalCenter
         anchors.horizontalCenter: btn_prev.horizontalCenter
     }
   }
//   Binding
//   {
//     target: btn_prev
//     property: 'source'
//     value: bLargeSpiner == true ?  RES.const_POPUP_TIME_PICKER_BUTTON_L_N : RES.const_POPUP_TIME_PICKER_BUTTON_s_N// ( spin_control.bSpinCtrlArrowType ) ? spin_control.__btn_arrow_l_n : spin_control.__btn_minus_n
//     when: (mouseArea_btn_prev.pressedButtons == false || prev_Pressed == false )
//   }

//   Binding
//   {
//     target: btn_prev
//     property: 'source'
//     value: bLargeSpiner == true ? RES.const_POPUP_TIME_PICKER_BUTTON_L_P : RES.const_POPUP_TIME_PICKER_BUTTON_s_P //( spin_control.bSpinCtrlArrowType ) ? spin_control.__btn_arrow_l_p : spin_control.__btn_minus_p
//     when: ( spin_control.bEnabled ) && (mouseArea_btn_prev.pressedButtons || prev_Pressed==true)
//   }

   MouseArea
   {
     id: mouseArea_btn_prev
     anchors.fill: btn_prev
     enabled: bEnabled
     beepEnabled: false
    onPressed:prev_Pressed=true
    onCanceled:{
        console.log( "[SystemPopUp] onCanceled " )
//        press_Canceled=true
        prev_Pressed=false;
        inc_repeater.stop();
    }
    onClicked: {
        __increment();
        spin_control.spinControlValueChanged();
    }
     onReleased:
     {
         UIListener.ManualBeep();
         prev_Pressed=false;
         if(inc_repeater.running==true)
         {
             inc_repeater.stop();
             return;
         }
//         if(press_Canceled==false)
//         {
//             if ( spin_control.bEnabled )
//             {
//                 __increment();
//                 spin_control.spinControlValueChanged();
//             }
//         }
//         else
//             press_Canceled=false
     }
     onPressAndHold:{
         inc_repeater.start();
     }
     onExited:{
         prev_Pressed=false;
//         press_Canceled=true;
         inc_repeater.stop();
     }
   }

   /**text*/
   Item
   {
     id: labelItem
     //x: btn_prev.width + 1
     width: background_spin_control.width//spin_control.width - btn_prev.width - btn_next.width
     height: background_spin_control.height

     z : 2


     Text
     {
       id: labelText
       anchors.horizontalCenter: labelItem.horizontalCenter
       anchors.verticalCenter: labelItem.verticalCenter
       text: aSpinControlTextModel.count > 0 ? qsTranslate( __lang_context, sCurrentValue ) + __emptyString
                                                         : sCurrentValue
       color: bEnabled ? HM.const_SPIN_CTRL_COLOR_TEXT_BRIGHT_GREY : HM.const_COLOR_TEXT_DIMMED_GREY
       font.pointSize: 40
       font.family: _fontFamily
       visible: true
       style: Text.Sunken

     }

//     states: [
//         State
//         {
//             name: "normal"; when: ( focus_visible == false )
//             PropertyChanges { target: background_spin_control; source: bLargeSpiner == true ? RES.const_POPUP_TIME_PICKER_FRAME_L_n : RES.const_POPUP_TIME_PICKER_FRAME_S_n }
//         },
////         State
////         {
////             name: "focused"; when: ( focus_visible == true )
////             PropertyChanges { target: background_spin_control; source: bLargeSpiner == true ? RES.const_POPUP_TIME_PICKER_FRAME_L_n : RES.const_POPUP_TIME_PICKER_FRAME_S_n }
////         },
//         State
//         {
//             name: "selected"; when: (focus_visible == true && _selectionMode  == true )
//             PropertyChanges { target: background_spin_control; source: bLargeSpiner == true ? RES.const_POPUP_TIME_PICKER_FRAME_L_f : RES.const_POPUP_TIME_PICKER_FRAME_S_f }
//         },
//         State
//         {
//             name: "unselected"; when: (focus_visible == true &&  _selectionMode  == false )
//             PropertyChanges { target: background_spin_control; source: bLargeSpiner == true ? RES.const_POPUP_TIME_PICKER_FRAME_L_n : RES.const_POPUP_TIME_PICKER_FRAME_S_n }
//         }
//     ]
//     Rectangle
//     {
//        id: colorRectangle
//        width: HM.const_SPIN_CTRL_RECTANGLE_WIDTH
//        height: HM.const_SPIN_CTRL_RECTANGLE_HEIGHT
//        x: HM.const_SPIN_CTRL_RECTANGLE_LEFT_MARGIN - btn_prev.width
//        y: HM.const_SPIN_CTRL_RECTANGLE_TOP_MARGIN
//        visible: ( spin_control.bSpinCtrlTextType ) ? false : true
//     }

//     Binding
//     {
//       target: colorRectangle
//       property: 'color'
//       value: spin_control.sCurrentValue
//       when: ( spin_control.bSpinCtrlTextType == false )
//     }
   }

   /**next button*/
   Image
   {
     id: btn_next
     anchors.bottom: parent.bottom
     anchors.horizontalCenter: parent.horizontalCenter
     source:{
         if(bLargeSpiner == true)
         {
             if(next_Pressed == true)
                 RES.const_POPUP_TIME_PICKER_BUTTON_L_P
             else
                 (spin_control.focus_visible&&_selectionMode) ? RES.const_POPUP_TIME_PICKER_BUTTON_L_F : RES.const_POPUP_TIME_PICKER_BUTTON_L_N
         }
         else{
             if(next_Pressed == true)
                 RES.const_POPUP_TIME_PICKER_BUTTON_s_P
             else
                 (spin_control.focus_visible&&_selectionMode) ? RES.const_POPUP_TIME_PICKER_BUTTON_s_F : RES.const_POPUP_TIME_PICKER_BUTTON_s_N
         }
     }

     x: btn_prev.width + labelItem.width + 1
     z:2
     Image
     {
         source: {
             if (bEnabled == true)
                RES.const_POPUP_TIME_PICKER_ARROW_D_f
             else
                RES.const_POPUP_TIME_PICKER_ARROW_D_n
         }
         anchors.verticalCenter: btn_next.verticalCenter
         anchors.horizontalCenter: btn_next.horizontalCenter
     }
   }

//   Binding
//   {
//     target: btn_next
//     property: 'source'
//     value: bLargeSpiner == true ? RES.const_POPUP_TIME_PICKER_BUTTON_L_N : RES.const_POPUP_TIME_PICKER_BUTTON_s_N
//     when: (mouseArea_btn_next.pressedButtons == false || next_Pressed == false )
//   }

//   Binding
//   {
//     target: btn_next
//     property: 'source'
//     value: bLargeSpiner == true ? RES.const_POPUP_TIME_PICKER_BUTTON_L_P : RES.const_POPUP_TIME_PICKER_BUTTON_s_P
//     when: spin_control.bEnabled && (mouseArea_btn_next.pressedButtons || next_Pressed==true)
//   }

   MouseArea
   {
     id: mouseArea_btn_next
     anchors.fill: btn_next
     enabled: bEnabled
     beepEnabled: false
    onPressed: next_Pressed=true
    onCanceled: {
        console.log( "[SystemPopUp] onCanceled " )
        next_Pressed=false;
//         press_Canceled=true;
        dec_repeater.stop();
    }
    onClicked: {
        __decrement();
        spin_control.spinControlValueChanged();
    }
     onReleased:
     {
         UIListener.ManualBeep();
         next_Pressed=false;

         if( dec_repeater.running == true )
         {
             dec_repeater.stop()
             return
         }
//         if(press_Canceled == false)
//         {
//             if (spin_control.bEnabled)
//             {
//                 __decrement();
//                 spin_control.spinControlValueChanged();
//             }
//         }else
//             press_Canceled=false
     }
     onPressAndHold:
     {
         dec_repeater.start()
     }
     onExited:{
         next_Pressed=false;
//         press_Canceled=true;
         dec_repeater.stop();
     }
   }
   Timer
   {
       id: inc_repeater
       interval: 80  
       repeat:true
       running: false
       onTriggered:
       {
           __increment();
           spin_control.spinControlValueChanged();
       }
   }
   Timer
   {
       id: dec_repeater
       interval: 80  
       repeat:true
       running: false
       onTriggered:
       {
           __decrement();
           spin_control.spinControlValueChanged();
       }
   }
   Timer
   {
       id: id_long_Press_timer
       interval: 800
       repeat:false
       running: false
       onTriggered:
       {
           UIListener.ManualBeep();
//	   controller.callBeepSound();
           if(next_Pressed == true)
               dec_repeater.start()
           else if( prev_Pressed == true)
               inc_repeater.start()
       }
   }

   onBEnabledChanged:
   {
      recheckFocus()
   }

   Component.onCompleted:
   {
     spin_control.setValue(spin_control.sCurrentValue)
   }
}
