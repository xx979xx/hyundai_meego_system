
import QtQuick 1.1

Item {
   id: toast
   //anchors.fill: parent
   parent: null
   visible: false

   /* Text for displayng on popUp */
   property string sText:""

   property bool dismiss: true

   //Clear message model
   //And create a new line
   Component.onCompleted:
   {
      toast_text_model.clear()
      toast_text_model.append({"msg": toast.sText})
   }
   onVisibleChanged:
   {
      toast_popUp.visible = toast.visible
      if(toast.visible === true && dismiss){
          close_timer.start();
      }
   }
   function stopTimer()
   {
         close_timer.stop();
   }
   function restartTimer()
   {
         close_timer.restart();
   }   

   //Change text value on popUp
   onSTextChanged:
   {
       toast_text_model.clear()
       toast_text_model.set(0, {"msg": toast.sText})
   }
   //PopUpDimmed
   DHAVN_Local_PopUp
   {
      id: toast_popUp
      message: toast_text_model
      visible:false

   }

   //Define message model for popUp
   ListModel
   {
      id: toast_text_model
   }

   Timer
   {
       id: close_timer
       interval: 3000
       running: false
       repeat:false
       onTriggered:
       {
           toast_popUp.visible = false
           toast.visible = false;
       }
   }
}

