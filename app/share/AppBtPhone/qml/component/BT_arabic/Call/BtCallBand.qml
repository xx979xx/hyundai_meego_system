/**
 * BtCallBand.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp


MComp.DDSimpleBand
{
     id: idCallMainBand

     titleText: stringInfo.str_Call_Title
     focus: true


     /* EVENT handlers */
     onBackKeyPressed: {
         idCallMain.backKeyHandler();
     }

     onBackBtnClicked: {
         idCallMain.backKeyHandler();
     }
}
/* EOF */
