import Qt 4.7
import "DHAVN_MP_PopUp_Resources.js" as RES
import "DHAVN_MP_PopUp_Constants.js" as CONST
//import PopUpConstants 1.0  remove by edo.lee 2013.01.26
import "DHAVN_MP_PopUp_Constants.js" as EPopUp //added by edo.lee 2013.01.26

// modified by Dmitry 09.10.13 for ITS0193956
Item
{
   id: wrapper
   width: CONST.const_DISPLAY_WIDHT
   height: CONST.const_DISPLAY_HEIGTH

   MouseArea
   {
      anchors.fill: parent

      // modified for ITS 0194515
      onClicked:
      {
         close_timer.stop()
         wrapper.closed()
      }
   }

   property bool bHideByTimer: true
   property int offset_y: 0
   property ListModel message: ListModel {}

   property int typePopup: CONST.const_DIMMED_DEFAULT_TYPE
   property int icon: EPopUp.NONE_ICON
   property int max_text_width: 0

   signal closed()

   onVisibleChanged:
   {
      if (visible && bHideByTimer)
         popup.close_timer.start()
   }

   Image
   {
       id: popup

       source: RES.const_POPUP_TYPE_C;

       //anchors.centerIn: parent
       x: CONST.const_POPUP_DIMMED_X_OFFSET
       y: CONST.const_POPUP_DIMMED_Y_OFFSET + wrapper.offset_y

       /** --- Child object --- */

//       MouseArea
//       {
//          anchors.fill: parent

//          onClicked:
//          {
//             close_timer.stop()
//             root.closePopup()
//          }
//       }

       Column
       {
           id: col
           anchors.verticalCenter: parent.verticalCenter
           anchors.horizontalCenter: parent.horizontalCenter
           spacing: CONST.const_DIMMED_TEXT_SPACING

           Repeater
           {
               model: wrapper.message

               Text
               {
                   id: dimmed_text
                   text: popup.argstext(index) //( msg.substring(0, 4) == "STR_" ) ? qsTranslate( __lang_context, msg) + LocTrigger.empty : msg // modified by ravikanth 22-04-13
                   width: CONST.const_TOAST_TEXTAREA_WIDTH  //addad by hyejin.noh 20140427 for String Overflow
                   color: CONST.const_TEXT_COLOR;
                   font.pixelSize: CONST.const_DIMMED_TEXT_PT
                   verticalAlignment: Text.AlignVCenter
                   wrapMode: Text.WordWrap
                   horizontalAlignment: Text.AlignHCenter
                   style : Text.Sunken
               }
           }
       }

       Timer
       {
           id: close_timer
           interval: 3000
           onTriggered:
           {
              root.closePopup();
           }
       }

       // { modified by ravikanth 22-04-13
       function argstext(index)
       {
           if (wrapper.message.get(index).msg.substring(0, 4) != "STR_" )
           {
               return wrapper.message.get(index).msg
           }
           if(wrapper.message.get(index).arguments != undefined)
           {
                   var translation = qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, wrapper.message.get(index).msg )
                   for (var i = 0; i < wrapper.message.get(index).arguments.count; i++)
                   {
                           translation = translation.arg(wrapper.message.get(index).arguments.get(i).arg1)
                   }
                   return translation
           }

           return (wrapper.message.get(index).arg1 == undefined) ? qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, wrapper.message.get(index).msg ):
                   (qsTranslate(LocTrigger.empty + CONST.const_LANGCONTEXT, wrapper.message.get(index).msg)).arg(wrapper.message.get(index).arg1)

       }
       // } modified by ravikanth 22-04-13
   }
}
// modified by Dmitry 09.10.13 for ITS0193956

