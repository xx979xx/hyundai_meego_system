/**
 * /QML/DH/MButton.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MComponent
{
    id: container

    // PROPERTIES
    property bool active: false
    property bool buttonFocus: (true == container.activeFocus && false == systemPopupOn)

    /* bgImage: 버튼 초기 Background 이미지
     * bgImagePress: 터치나 Jog를 통하여 선택 시 표시되는 Background 이미지
     * bgImageActive: 버튼 액티브 Background 이미지
     * bgImageFocus: 버튼 포커스 Background 이미지
     * fgImage: 버튼 내부의 ICON 이미지
     */
    property string bgImage: ImagePath.imgFolderBt_phone + "ico_call_add_n.png"
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""

    // First Text Info
    property string firstText: ""
    property int    firstTextSize: 1
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor: firstTextColor
    property string firstTextFocusPressColor: firstTextPressColor
    property string firstTextFocusColor: colorInfo.brightGrey
    property string firstTextSelectedColor: firstTextColor
    property string firstDimmedTextColor: colorInfo.dimmedGrey
    property string firstTextDisableColor: colorInfo.disableGrey

    Connections {
        target: idAppMain
        onMouseAreaExit: {
            container.state = "STATE_RELEASED"
        }

        onBtnReleased: {
            container.state = "STATE_RELEASED"
        }
    }

    /* EVENT handlers */

    onSelectKeyPressed: {
        if(true == container.mEnabled) {
            container.state = "STATE_PRESSED";
        } else {
            container.state = "STATE_DISABLED"
        }
    }

    onClickOrKeySelected: {
        if(true == container.mEnabled) {
            if(true == container.active) {
                container.state = "STATE_ACTIVE"
            } else {
                container.state = "STATE_RELEASED";
            }
        } else {
            container.state = "STATE_DISABLED"
        }
    }

    onReleased: {
        if(false == container.dimmed){
        console.log("## ~ Play Beep Sound(MContactsDelegate) ~ ##")
        UIListener.ManualBeep();
        }
    }

    /* WIDGETS */
    Image {
        // Line Image는 배경보다 아래에 위치해야함 Line의 1px은 배경보다 밑에 깔려야함
        source: ImagePath.imgFolderGeneral + "line_menu_list.png"
        x: 0
        y: 80
    }

    Image {
        id: idBtnBackImage
        source: bgImage
        visible: !idBtnBackFocusImage.visible
    }

    Image {
        id: idBtnBackFocusImage
        source: bgImageFocus
        visible: buttonFocus
    }

    // First text
    Text {
        id: txtFirstText
        text: firstText
        x: 39
        anchors.verticalCenter: parent.verticalCenter
        width: 398
        height: parent.height
        font.pointSize: 40
        color: container.active ? firstTextFocusColor : firstTextColor
        font.family: {
            if (true == container.active && false == container.activeFocus) {
                stringInfo.fontFamilyBold    //"HDB"
            } else {
                if(true == systemPopupOn){
                    if (true == container.active && false == container.activeFocus) {
                        stringInfo.fontFamilyBold
                    } else {
                        stringInfo.fontFamilyRegular
                    }
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
        }

        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        visible: false == txtFocusFirstText.visible
        clip: false
    }

    // First focus text
    DDScrollTicker {
        id: txtFocusFirstText
        tickerText: firstText
        x: 39
        anchors.verticalCenter: parent.verticalCenter
        width: 398
        height: parent.height
        fontSize: 40
        color: firstTextFocusColor
        fontFamily: stringInfo.fontFamilyRegular //"HDR"

        horizontalAlignment: Text.AlignLeft

        visible: buttonFocus && parking == true

        onVisibleChanged: {
            txtFocusFirstText.setFocus(txtFocusFirstText.visible);
        }

        tickerEnable: true
    }

    /* STATES */
    states: [
        State {
            name: "STATE_PRESSED"
            when: isMousePressed()
            PropertyChanges { target: idBtnBackImage;       source: bgImagePress }
            PropertyChanges { target: txtFirstText;         color: container.activeFocus ? firstTextFocusColor : container.active ? firstTextSelectedColor : firstTextPressColor }
            PropertyChanges { target: idBtnBackFocusImage;  visible: false }
        }
        , State {
            name: "STATE_ACTIVE"
            when: true == container.active
            PropertyChanges { target: idBtnBackImage;       source: bgImageActive }
            PropertyChanges {
                target: txtFirstText;
                color: parking == true ? firstTextSelectedColor
                       : true == container.activeFocus ? firstTextFocusColor
                       : true == container.active ? firstTextSelectedColor
                       : firstTextColor
            }
        }
        , State {
            name: "STATE_FOCUS"
            when: true == container.activeFocus
            PropertyChanges { target: txtFirstText;         visible: true == parking ? false : true }
            PropertyChanges { target: txtFirstText;         color: firstTextFocusColor }
        }
        , State {
            name: "STATE_RELEASED"
            PropertyChanges { target: idBtnBackImage;
                source: true == container.active ? bgImageActive : bgImage
            }
            PropertyChanges { target: txtFirstText;
                color: true == container.activeFocus ? firstTextFocusColor
                     : true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor :firstTextColor
            }
        }
        , State {
            name: "STATE_DISABLED"
            when: !mEnabled
            PropertyChanges { target: idBtnBackImage;       source: bgImage }
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
        }
    ]
}
/* EOF */
