import QtQuick 1.0
//import QmlPopUpPlugin 1.0
import "../DHAVN_VP_CONSTANTS.js" as CONST

Item {
   id: toast
   anchors.fill: parent

   /* Text for displayng on popUp */
   property string sText: video_model.sText

   //Clear message model
   //And create a new line
   Component.onCompleted:
   {
      toast_text_model.clear()
      toast_text_model.append({"msg": toast.sText}) // modified by Sergey for CR#11607
   }
   onVisibleChanged:
   {
      toast_popUp.visible = toast.visible
   }

   //Change text value on popUp
   onSTextChanged:
   {
       toast_text_model.clear() // added by wspark 2012.10.30 for invalid popup location.
       toast_text_model.set(0, {"msg": toast.sText}) // modified by Sergey for CR#11607
   }

   // { modified by Sergey for CR#11607
   //PopUpDimmed
   DHAVN_MP_PopUp_Dimmed
   {
      id: toast_popUp
      bHideByTimer: false 
      message: toast_text_model
   }
   // } modified by Sergey for CR#11607

   //Define message model for popUp
   ListModel
   {
      id: toast_text_model
   }
}
