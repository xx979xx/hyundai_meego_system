/**
 * /QML/DH/DDSimpleBand.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePathArab


FocusScope
{
    id: idDDSimpleBandContainer
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.titleAreaHeight
    focus: true

    // PROPERTIES
    property string titleText: ""
    property string subTitleText: ""
    property string menuBtnText: ""
    property bool menuBtnFlag: false

    // SIGNALS
    signal backBtnClicked();
    signal backBtnKeyPressed();

    /* Widgets */
    Image {
        source: ImagePath.imgFolderGeneral + "bg_title.png"
        x: 0;
        y: 0;
    }

    // 타이틀 텍스트
    Text{
        id: txtTitle
        text: titleText
        x: 45
        y: 129 - systemInfo.statusBarHeight - 40 / 2
        height: 40
        font.pointSize: 40
        font.family: stringInfo.fontFamilyBold    //"HDB"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: (20 != gLanguage) ? true : false
    }

    // 아랍 타이틀 텍스트
    Text{
        id: txtTitleArab
        text: titleText
        anchors.right: parent.right
        anchors.rightMargin: 46
        y: 129 - systemInfo.statusBarHeight - 40 / 2
        height: 40
        font.pointSize: 40
        font.family: stringInfo.fontFamilyBold    //"HDB"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: (20 == gLanguage) ? true : false
    }

    MButton {
        id: idBackBtn
        x: (20 == gLanguage) ? 3 : 1136
        y: 0
        width: 141
        height: 72
        focus: true

        bgImage: (20 == gLanguage) ? ImagePathArab.imgFolderGeneral + "btn_title_back_n.png" : ImagePath.imgFolderGeneral + "btn_title_back_n.png"
        bgImagePress: (20 == gLanguage) ? ImagePathArab.imgFolderGeneral + "btn_title_back_p.png" : ImagePath.imgFolderGeneral + "btn_title_back_p.png"
        bgImageFocus: (20 == gLanguage) ? ImagePathArab.imgFolderGeneral + "btn_title_back_f.png" : ImagePath.imgFolderGeneral + "btn_title_back_f.png"

        onClickOrKeySelected: {
            backBtnClicked();
        }

        onWheelLeftKeyPressed: {
            if(true == idMenuBtn.visible) {
                idMenuBtn.focus = true;
                idMenuBtn.forceActiveFocus();
            }
        }

        onClickMenuKey: {
            idMenu.show();
        }

        onBackKeyPressed: {
            backBtnKeyPressed();
        }
    }
}
/* EOF */
