// { added by Sergey for CR#16565
import QtQuick 1.0
//import QmlPopUpPlugin 1.0
//import PopUpConstants 1.0 remove by edo.lee 2013.01.26
import "video/popUp/DHAVN_MP_PopUp_Constants.js" as EPopUp //added by edo.lee 2013.01.26
import "video/popUp"

Item
{
    signal buttonClicked(string btnId)

    function setText(aText)
    {
        textModel.set(0, {"msg": qsTranslate("main",aText) + LocTrigger.empty })
    }

    function setButtons(btn1, btn2)
    {
        buttonModel.clear()
        if(btn1 != "")
            buttonModel.append({"msg": QT_TR_NOOP(btn1), "btn_id": "Id_0"});
        if(btn2 != "")
            buttonModel.append({"msg": QT_TR_NOOP(btn2), "btn_id": "Id_1"});
    }

	DHAVN_MP_PopUp_Text
    //PopUpText
    {
        id: popup
        buttons: buttonModel
        message: textModel
        //title: qsTr("")
        //icon_title: EPopUp.WARNING_ICON //deleted by aettie 2031.04.01 ISV 78226

        onBtnClicked:
        {
        	if(!popup.visible) return;//added by edo.lee 01.19
            buttonClicked(btnId)
        }
    }
    ListModel { id: textModel }
    ListModel { id: buttonModel }
}
// } added by Sergey for CR#16565
