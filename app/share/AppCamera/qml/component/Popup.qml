import QtQuick 1.1
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import "../system" as MSystem

MComponent {
    id: idPopupMain
    enableClick: false;
    focus: true

    signal backFromPopup();

    MSystem.SystemInfo {id:systemInfo}
    MSystem.ColorInfo {id:colorInfo}
    MSystem.StringInfo {id:stringInfo}

    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight

    POPUPWIDGET.PopUpToast
    {
        id: toast_popup
        listmodel: toast_text_model
        z: 1000
        visible: false
    }

    ListModel
    {
        id: toast_text_model
        ListElement { msg: QT_TR_NOOP("STR_CAMERA_ABEND1") }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: UIListener.PlayAudioBeep();
        onClicked: backFromPopup();
    }

    Component.onCompleted:  {
        toast_text_model.setProperty(0, "msg", qsTranslate("StringInfo", "STR_CAMERA_ABEND1")+QT_TR_NOOP("<br>")+qsTranslate("StringInfo", "STR_CAMERA_ABEND2"));
        toast_popup.visible = true;
        //For AutoTest
        UIListener.SendAutoTestSignal()
    }


}
