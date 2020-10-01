import Qt 4.7
import "DhAvnSimpleItemsSpinControl.js" as HM
import "DhAvnSimpleItemsResources.js" as RES
import AppEngineQMLConstants 1.0

Item
{
   id: spin_control

   property int const_SETTINGS_SPIN_CONTROL : 0
   property int const_INFO_SPIN_CONTROL : 1
   property int const_VIDEO_PLAYER_SPIN_CONTROL : 2

   /** list of text that should be shown in SpinControl*/
   property ListModel aSpinControlTextModel: ListModel{}

   /**const_SETTINGS_SPIN_CONTROL, const_INFO_SPIN_CONTROL, const_VIDEO_PLAYER_SPIN_CONTROL */
   property int iSpinCtrlType: const_SETTINGS_SPIN_CONTROL

   /**0 - color type, 1 - text type*/
   property bool bSpinCtrlTextType: true

   /**0 - +/- type, 1 - arrow type*/
   property bool bSpinCtrlArrowType: true

   /**is SpinControl text can be changed*/
   property bool bEnabled: true

   /**Focus properties */

   property int focus_id: -1//read_only
  // property int focus_index: 0
   property bool focus_visible: false
   property bool is_focusable: true
   property bool focusOnPrev: true

   property string sFocusedColor: RES.const_FOCUSED_ITEM_COLOR

   signal lostFocus ( int arrow, int focusID )
   signal recheckFocus()

   property int minimum: 0
   property int maximum: 0
   property int step: 1

   property string sCurrentValue: ( bSpinCtrlArrowType == true ) ? qsTranslate( __lang_context, aSpinControlTextModel.get(__index).text) + __emptyString
                                                               : ( spin_control.minimum ).toString()

   /**index of current text*/
   property int __index: 0
   property string __emptyString : ""
   property string __lang_context: HM.const_SPIN_CTRL_LANGCONTEXT

   /**count of values of text*/
   property int __count: ( bSpinCtrlArrowType == true ) ? aSpinControlTextModel.count
                                                        : ( maximum - minimum ) / step + 1

   /**resources for SpinControl*/
   property url __bg_spin_control: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_SPIN_CTRL
                                                                                    : ( ( iSpinCtrlType == const_INFO_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_SPIN_CTRL_BG
                                                                                                                                     : RES.const_URL_IMG_GENERAL_SPIN_CTRL_L )
   property url __btn_arrow_l_n: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_ARROW_L_N : RES.const_URL_IMG_GENERAL_ARROW_LEFT_L_N
   property url __btn_arrow_l_p: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_ARROW_L_P : RES.const_URL_IMG_GENERAL_ARROW_LEFT_L_P
   property url __btn_arrow_r_n: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_ARROW_R_N : RES.const_URL_IMG_GENERAL_ARROW_RIGHT_R_N
   property url __btn_arrow_r_p: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? RES.const_URL_IMG_GENERAL_ARROW_R_P : RES.const_URL_IMG_GENERAL_ARROW_RIGHT_R_P
   property url __btn_plus_n: RES.const_URL_IMG_GENERAL_PLUS_N
   property url __btn_plus_p: RES.const_URL_IMG_GENERAL_PLUS_P
   property url __btn_minus_n: RES.const_URL_IMG_GENERAL_MINUS_N
   property url __btn_minus_p: RES.const_URL_IMG_GENERAL_MINUS_P

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
      spin_control.__increment()
      spin_control.spinControlValueChanged()
   }

   function decrementValue()
   {
      spin_control.__decrement()
      spin_control.spinControlValueChanged()
   }

   /**used for transition to next text*/
   function __increment()
   {
     if( __index < __count - 1 )
     {
       __index++;
     }
     else if( spin_control.bSpinCtrlArrowType == false )
          {
            __index = __count - 1
          }
          else
          {
            __index = 0;
          }
     // if SpinControl with Arrows use values from model else assume value as a member of arithmetic progression
     spin_control.sCurrentValue = ( spin_control.bSpinCtrlArrowType == true ) ? aSpinControlTextModel.get( __index ).text
                                                                              : ( minimum + ( __index * step ) ).toString()

     if( spin_control.bSpinCtrlTextType == false)
     {
        colorRectangle.color = ( aSpinControlTextModel.get( __index ) ).text
     }
   }

   /**used for transition to previous text*/
   function __decrement()
   {
     if( __index == 0 && spin_control.bSpinCtrlArrowType == true )
     {
       __index = __count - 1;
     }
     else
     {
       if( __index == 0 && spin_control.bSpinCtrlArrowType == false )
       {
         __index = 0
       }
       else
       {
         __index--;
       }
     }

     // if SpinControl with Arrows use values from model else assume value as a member of arithmetic progression
     spin_control.sCurrentValue = ( spin_control.bSpinCtrlArrowType == true ) ? aSpinControlTextModel.get( __index ).text
                                                                              : ( minimum + ( __index * step ) ).toString()

     if( spin_control.bSpinCtrlTextType == false )
     {
        colorRectangle.color = ( aSpinControlTextModel.get( __index ) ).text
     }
   }

   /**used for set text*/
   function setValue( v )
   {
     if( spin_control.bSpinCtrlArrowType == true )
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
     spin_control.sCurrentValue = ( spin_control.bSpinCtrlArrowType == true ) ? aSpinControlTextModel.get( __index ).text
                                                                              : ( minimum + ( __index * step ) ).toString()

     if( spin_control.bSpinCtrlTextType == false )
     {
        colorRectangle.color = ( aSpinControlTextModel.get( __index ) ).text
     }
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
         console.log( "[ActivitySlider]lost_focus = "+arrow )
         return -1
      }
   }

   function handleJogEvent(jogEvent) { }//empty method for Settings

   Connections
   {
      target: focus_visible && bEnabled ? UIListener: null

      onSignalJogNavigation:
      {
         console.log("[SpinControl]onSignalJogNavigation arrow=" + arrow)
//modified by aettie.ji 2013.04.30 for Click event deletion (for Focus ->Pressed / for Action -> Released)            
//         if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
         if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
         {
            console.log("[SpinControl]focus lost arrow: " + arrow )
            switch( arrow )
            {
               case UIListenerEnum.JOG_WHEEL_LEFT:
               {
                   decrementValue()
               }
               case UIListenerEnum.JOG_WHEEL_RIGHT:
               {
                   incrementValue()
               }

               default:
               {
                  lostFocus( arrow ,focus_id)
                  break
               }

            }
         }
      }
   }

   width: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? HM.const_SPIN_CTRL_SETTINGS_WIDTH
                                                           : ( ( iSpinCtrlType == const_INFO_SPIN_CONTROL ) ? HM.const_SPIN_CTRL_INFO_WIDTH
                                                                                                            : HM.const_SPIN_CTRL_VIDEO_WIDTH )
   height: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? HM.const_SPIN_CTRL_SETTINGS_HEIGHT
                                                            : ( ( iSpinCtrlType == const_INFO_SPIN_CONTROL ) ? HM.const_SPIN_CTRL_INFO_HEIGHT
                                                                                                             : ( ( bSpinCtrlArrowType == true) ? HM.const_SPIN_CTRL_VIDEO_HEIGHT
                                                                                                                                               : HM.const_SPIN_CTRL_VIDEO_PLUS_MINUS_HEIGHT ) )
   /** focus */
   Rectangle
   {
      id: focus_rect
      anchors.centerIn: spin_control
      height: spin_control.height + 8
      width: spin_control.width + 8
      color: sFocusedColor
      visible: bEnabled && spin_control.focus_visible
      radius: 4
      z:1
   }

   /**background*/
   Image
   {
     id: background_spin_control
     anchors.centerIn: spin_control
   }

   Binding
   {
     target: background_spin_control
     property: 'source'
     value: spin_control.__bg_spin_control
   }

   /**previous button*/
   Image
   {
     id: btn_prev
     width: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? HM.const_SPIN_CTRL_BTN_PREV_WIDTH
                                                             : ( ( bSpinCtrlArrowType == true ) ? HM.const_SPIN_CTRL_BTN_PREV_WIDTH_L
                                                                                                : HM.const_SPIN_CTRL_BTN_PREV_PLUS_MINUS_WIDTH )
     height: spin_control.height
     z:2
   }

   Binding
   {
     target: btn_prev
     property: 'source'
     value: ( spin_control.bSpinCtrlArrowType ) ? spin_control.__btn_arrow_l_n : spin_control.__btn_minus_n
     when: mouseArea_btn_prev.pressedButtons == false
   }

   Binding
   {
     target: btn_prev
     property: 'source'
     value: ( spin_control.bSpinCtrlArrowType ) ? spin_control.__btn_arrow_l_p : spin_control.__btn_minus_p
     when: ( spin_control.bEnabled ) && mouseArea_btn_prev.pressedButtons
   }

   MouseArea
   {
     id: mouseArea_btn_prev
     anchors.fill: btn_prev

     onReleased:
     {
       if ( spin_control.bEnabled )
       {
         __decrement();
         spin_control.spinControlValueChanged();
       }
     }
   }

   /**text*/
   Item
   {
     id: labelItem
     x: btn_prev.width + 1
     width: spin_control.width - btn_prev.width - btn_next.width
     height: spin_control.height
     z : 2


     Text
     {
       id: labelText
       anchors.horizontalCenter: labelItem.horizontalCenter
       anchors.verticalCenter: labelItem.verticalCenter
       text: spin_control.bSpinCtrlTextType ? qsTranslate( __lang_context, sCurrentValue ) + __emptyString
                                                         : sCurrentValue
       color: bEnabled ? HM.const_SPIN_CTRL_COLOR_TEXT_BRIGHT_GREY : HM.const_COLOR_TEXT_DIMMED_GREY
       font.pixelSize: HM.const_SPIN_CTRL_FONT_SIZE_TEXT_36PT
       //font.family: HM.const_SPIN_CTRL_FONT_FAMILY_HDR
       font.family: HM.const_SPIN_CTRL_FONT_FAMILY_NEW_HDR
       visible: ( spin_control.bSpinCtrlTextType ) ? true : false
       style: Text.Sunken

     }

     Rectangle
     {
        id: colorRectangle
        width: HM.const_SPIN_CTRL_RECTANGLE_WIDTH
        height: HM.const_SPIN_CTRL_RECTANGLE_HEIGHT
        x: HM.const_SPIN_CTRL_RECTANGLE_LEFT_MARGIN - btn_prev.width
        y: HM.const_SPIN_CTRL_RECTANGLE_TOP_MARGIN
        visible: ( spin_control.bSpinCtrlTextType ) ? false : true
     }

     Binding
     {
       target: colorRectangle
       property: 'color'
       value: spin_control.sCurrentValue
       when: ( spin_control.bSpinCtrlTextType == false )
     }
   }

   /**next button*/
   Image
   {
     id: btn_next
     width: ( iSpinCtrlType == const_SETTINGS_SPIN_CONTROL ) ? HM.const_SPIN_CTRL_BTN_NEXT_WIDTH
                                                             : ( ( bSpinCtrlArrowType == true ) ? HM.const_SPIN_CTRL_BTN_NEXT_WIDTH_L
                                                                                                : HM.const_SPIN_CTRL_BTN_NEXT_PLUS_MINUS_WIDTH )
     height: spin_control.height
     x: btn_prev.width + labelItem.width + 1
     z:2
   }

   Binding
   {
     target: btn_next
     property: 'source'
     value: ( spin_control.bSpinCtrlArrowType ) ? spin_control.__btn_arrow_r_n : spin_control.__btn_plus_n
     when: mouseArea_btn_next.pressedButtons == false
   }

   Binding
   {
     target: btn_next
     property: 'source'
     value: ( spin_control.bSpinCtrlArrowType ) ? spin_control.__btn_arrow_r_p : spin_control.__btn_plus_p
     when: spin_control.bEnabled && mouseArea_btn_next.pressedButtons
   }

   MouseArea
   {
     id: mouseArea_btn_next
     anchors.fill: btn_next

     onReleased:
     {
       if (spin_control.bEnabled)
       {
         __increment();
         spin_control.spinControlValueChanged();
       }
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
