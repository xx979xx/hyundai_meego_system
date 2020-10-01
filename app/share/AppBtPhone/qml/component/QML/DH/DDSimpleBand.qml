/**
 * /QML/DH/DDSimpleBand.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


FocusScope
{
    id: idDDSimpleBandContainer
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.titleAreaHeight


    // PROPERTIES
    property string titleText: ""
    property string subTitleText: ""
    property string menuBtnText: ""
    property bool menuBtnFlag: false

    // SIGNALS
    signal backBtnClicked();
    signal backKeyPressed();

    /* EVENT handlers */
    onMenuBtnFlagChanged: {
        /* 메뉴가 나타나면 메뉴에 포커스를 설정함(메뉴가 사라졌다 나타날때 포커스 사라짐 방지)
         */
        if(true == menuBtnFlag) {
            idMenuBtn.focus = true;
        } else {
            idBackBtn.focus = true;
        }
    }

    /* 통화 화면에서 상단 밴드로 포커스 이동 동작 수정
     */
    onActiveFocusChanged: {
        if(menuBtnFlag == true) {
            idMenuBtn.focus = true
            idBackBtn.focus = false
        } else {
            idMenuBtn.focus = false
            idBackBtn.focus = true
        }
    }

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
        visible: true
    }

    Text{
        id: subTxtTitle
        text: "(" + subTitleText + ")"
        anchors.left: txtTitle.right
        anchors.leftMargin: 15
        y: 129 - systemInfo.statusBarHeight - 30 / 2
        width: 146
        height: 30
        font.pointSize: 30
        font.family: stringInfo.fontFamilyBold    //"HDB"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.bandBlue
        visible: subTitleText != ""
    }

    MButton {
        id: idMenuBtn
        x: 998
        y: 0
        width: 141
        height: 72

        focus: menuBtnFlag
        visible: menuBtnFlag

        bgImage: ImagePath.imgFolderGeneral + "btn_title_sub_n.png"
        bgImagePress: ImagePath.imgFolderGeneral + "btn_title_sub_p.png"
        bgImageFocus: ImagePath.imgFolderGeneral + "btn_title_sub_f.png"

        onClickOrKeySelected: {
            idMenuBtn.forceActiveFocus();
            if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
                idMenu.show();
            }
        }

        firstText: menuBtnText
        firstTextX: 9
        firstTextY: 22
        firstTextWidth: 123
        firstTextSize: 30
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"

        onWheelRightKeyPressed: {
            idBackBtn.focus = true;
            idBackBtn.forceActiveFocus();
        }

        onClickMenuKey: {
            idMenu.show();
        }

        onBackKeyPressed: {
            backKeyPressed();
        }
    }

    MButton {
        id: idBackBtn
        x: 1136
        y: 0
        width: 141
        height: 72
        focus: (false == menuBtnFlag) ? true : false

        bgImage: ImagePath.imgFolderGeneral + "btn_title_back_n.png"
        bgImagePress: ImagePath.imgFolderGeneral + "btn_title_back_p.png"
        bgImageFocus: ImagePath.imgFolderGeneral + "btn_title_back_f.png"

        onClickOrKeySelected: {
            idBackBtn.forceActiveFocus();
            backBtnClicked();
        }

        onWheelLeftKeyPressed: {
            if(true == idMenuBtn.visible) {
                idMenuBtn.focus = true;
                idMenuBtn.forceActiveFocus();
            }
        }

        onClickMenuKey: {
            if(true == menuBtnFlag) {
                idMenu.show();
            }
        }

        onBackKeyPressed: {
            backKeyPressed();
        }
    }
}
/* EOF */
