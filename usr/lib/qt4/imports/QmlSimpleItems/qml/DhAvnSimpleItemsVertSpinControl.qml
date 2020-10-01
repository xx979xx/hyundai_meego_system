import Qt 4.7
import "DhAvnSimpleItemsVertSpinControl.js" as HM
import "DhAvnSimpleItemsResources.js" as RES
import AppEngineQMLConstants 1.0

Item
{
   id: spin_control
   width: background_spin_control.width
   height: background_spin_control.height
   /** Focus Color */
   property string sFocusedColor: RES.const_FOCUSED_ITEM_COLOR

   property alias _width : background_spin_control.width

   /** list of text that should be shown in SpinControl*/
   property ListModel aSpinControlTextModel

   /** true - value can be changed around, false - value can not be changed around */
   property bool bSpinCtrlTypeRound: false

   /** true - wide spin control, false - normal spin control */
   property bool bSpinCtrlType: false

   /**0 - color type, 1 - text type*/
   property bool bSpinCtrlTextType: true

   /**is SpinControl text can be changed*/
   property bool bEnabled: true

   /** Focus interface */
    property bool focus_visible: false
    property int focus_id: -1
    property bool is_focusable: true

    /** Focus interface functions */
    function hideFocus() { focus_visible = false }
    function showFocus() { focus_visible = true }
    function handleJogEvent( arrow, status ) {}
    function setDefaultFocus( arrow )
    {
        var res = -1
        if ( bEnabled )
        {
           res = focus_id
           focus_index = 0
           if ( arrow == UIListenerEnum.JOG_UP )
               focus_index = 1
           else
              focus_index = 0
        }

        return res
    }

   property int minimum: 0
   property int maximum: 0
   property int step: 1
   property int value_index: aSpinControlTextModel ? 0 : minimum

   property variant sCurrentValue: labelText.text

   /**index of current text*/
   property int __index: 0
   property string __emptyString : ""
   property string __lang_context: HM.const_SPIN_CTRL_LANGCONTEXT

   /**resources for SpinControl*/
   property url ico_up_n: aSpinControlTextModel ? "/app/share/images/settings/ico_arrow_u_n.png" : "/app/share/images/settings/ico_+_n.png"
   property url ico_down_n: aSpinControlTextModel ? "/app/share/images/settings/ico_arrow_d_n.png" : "/app/share/images/settings/ico_-_n.png"
   property url ico_up_p: aSpinControlTextModel ? "/app/share/images/settings/ico_arrow_u_p.png" : "/app/share/images/settings/ico_+_p.png"
   property url ico_down_p: aSpinControlTextModel ? "/app/share/images/settings/ico_arrow_d_p.png" : "/app/share/images/settings/ico_-_p.png"

   /** Signals */
   signal spinControlValueChanged()
   signal lostFocus( int arrow, int focusID )

/** ----- Private implementation ---------- */

   property bool changing: false
   property int focus_index: -1
   property bool bPressed: false

   onFocus_visibleChanged:
   {
      if (!focus_visible)
      {
          focus_index = -1
      }
      changing = false
   }

   Connections
   {
      target: focus_visible ? UIListener : null
      onSignalJogCenterPressed: bPressed = true
      onSignalJogCenterReleased: bPressed = false
      onSignalJogNavigation:
      {
//modified by aettie.ji 2013.04.30 for Click event deletion (for Focus ->Pressed / for Action -> Released)         
//          if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
          if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
          {
              switch ( arrow )
              {
                  case UIListenerEnum.JOG_WHEEL_LEFT:
                      decrementValue()
                      break;

                  case UIListenerEnum.JOG_WHEEL_RIGHT:
                      incrementValue()
                      break;
                  default:
                      lostFocus( arrow, focus_id )
                }
            }
        }
    }

   function retranslateUI(context)
   {
      if (context) { __lang_context = context }
      __emptyString = " "
      __emptyString = ""
   }

   function incrementValue()
   {
      if ( aSpinControlTextModel )
      {
         if ( value_index < aSpinControlTextModel.count - 1 )
         {
            value_index++
            spinControlValueChanged()
         }
         else if (bSpinCtrlTypeRound)
         {
             value_index = 0
             spinControlValueChanged()
         }
      }
      else if ( value_index < maximum )
      {
         value_index += step
         spinControlValueChanged()
      }
   }

   function decrementValue()
   {
      if ( aSpinControlTextModel )
      {
         if ( value_index > 0 )
         {
            value_index--
            spinControlValueChanged()
         }
         else if (bSpinCtrlTypeRound)
         {
             value_index = aSpinControlTextModel.count - 1
             spinControlValueChanged()
         }
      }
      else if ( value_index > minimum )
      {
         value_index -= step
         spinControlValueChanged()
      }
   }

   /** used for set text */
   function setValue( v )
   {
      if ( aSpinControlTextModel )
      {
         /**find value in delegate*/
         for( var i = 0; i < aSpinControlTextModel.count; i++ )
         {
            if( ( aSpinControlTextModel.get( i ) ).text == v )
            {
               value_index = i;
               break;
            }
         }
      }
      else if ( minimum <= v && v <= maximum )
      {
         value_index = v
      }
   }




   /**background*/
   Image
   {
       id: background_spin_control
       source: (bSpinCtrlType == true) ? "/app/share/images/settings/bg_spin_ctrl_l.png"
                                        : "/app/share/images/settings/bg_spin_ctrl_s.png"
       anchors.left: spin_control.left
       anchors.top: spin_control.top

       /**top button*/
       Image
       {
           id: up_spin_control
           anchors.top: parent.top
           anchors.left: parent.left
           source: (bSpinCtrlType == true) ? "/app/share/images/settings/btn_spin_ctrl_l_n.png"
                                            : "/app/share/images/settings/btn_spin_ctrl_s_n.png"
           z : 2

		 width: parent.width
           MouseArea
           {
               id: mouseArea_btn_up
               enabled: bEnabled
               anchors.fill: parent
               onPressed:
               {
                  if (bSpinCtrlType == true)
                  {
                     up_spin_control.source = "/app/share/images/settings/btn_spin_ctrl_l_p.png"
                  }
                  else
                  {
                     up_spin_control.source = "/app/share/images/settings/btn_spin_ctrl_s_p.png"
                  }
               }

               onReleased:
               {
                  if (bSpinCtrlType == true)
                  {
                     up_spin_control.source = "/app/share/images/settings/btn_spin_ctrl_l_n.png"
                  }
                  else
                  {
                     up_spin_control.source = "/app/share/images/settings/btn_spin_ctrl_s_n.png"
                  }
               }
               onClicked: incrementValue()
           }

           Image
           {
               id: plus_up_spin_control
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
               source: mouseArea_btn_up.pressed ? ico_up_p : ico_up_n
           }

        }

       /**text*/
       Text
       {
           id: labelText
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.verticalCenter: parent.verticalCenter
           text: aSpinControlTextModel ? qsTranslate( __lang_context, aSpinControlTextModel.get( value_index ).text ) + __emptyString : value_index
           color: "#FAFAFA"
           font.pixelSize: 28
           //font.family: "HDB"
           font.family : HM.const_SPIN_CTRL_FONT_FAMILY_NEW_HDB
           z :2
       }

       /**bottom button*/
       Image
       {
           id: down_spin_control
           anchors.bottom: parent.bottom
           anchors.left: parent.left
           source: (bSpinCtrlType == true) ? "/app/share/images/settings/btn_spin_ctrl_l_n.png"
                                            : "/app/share/images/settings/btn_spin_ctrl_s_n.png"
           z : 2
		   width : parent.width

           MouseArea
           {
               id: mouseArea_btn_down
               enabled: bEnabled
               anchors.fill: parent
               onPressed:
               {
                  if (bSpinCtrlType == true)
                  {
                     down_spin_control.source = "/app/share/images/settings/btn_spin_ctrl_l_p.png"
                  }
                  else
                  {
                     down_spin_control.source = "/app/share/images/settings/btn_spin_ctrl_s_p.png"
                  }
               }

               onReleased:
               {
                  if (bSpinCtrlType == true)
                  {
                     down_spin_control.source = "/app/share/images/settings/btn_spin_ctrl_l_n.png"
                  }
                  else
                  {
                     down_spin_control.source = "/app/share/images/settings/btn_spin_ctrl_s_n.png"
                  }
               }
               onClicked: decrementValue()
           }

           Image
           {
               id: minus_down_spin_control
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
               source: mouseArea_btn_down.pressed ? ico_down_p : ico_down_n
           }
       }

       Rectangle
       {
          id: focus_rect
          anchors.centerIn : parent
          height: parent.height + 8
          width: (bSpinCtrlType == true) ? (parent.width + 8)
                                         : (parent.width + 7)
          color: sFocusedColor
          visible: focus_visible && (( focus_index == 1 )|| ( focus_index == 0 ))
          z:1
          radius : 4
       }
   }

   Component.onCompleted:
   {
      setValue( sCurrentValue )
   }

   onMaximumChanged:
   {
      if ( value_index > maximum )
      {
         setValue( maximum )
      }
   }
   onMinimumChanged:
   {
      if ( value_index < minimum )
      {
         setValue( minimum )
      }
   }
}
