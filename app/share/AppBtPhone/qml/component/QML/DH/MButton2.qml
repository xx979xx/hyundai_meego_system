/**
 * /QML/DH/MButton2.qml
 *
 */
import QtQuick 1.1


MComponent
{
    id: container

    width: parent.width
    height: parent.height

    // PROPERTIES
    property bool active: false
    property string buttonName: ""
    property bool buttonFocus: (true == container.activeFocus && false == systemPopupOn)

    /* bgImage: 버튼 초기 Background 이미지
     * bgImagePress: 터치나 Jog를 통하여 선택 시 표시되는 Background 이미지
     * bgImageActive: 버튼 액티브 Background 이미지
     * bgImageFocus: 버튼 포커스 Background 이미지
     * fgImage: 버튼 내부의 ICON 이미지
     */
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property int    bgImageX: 0                     // Background X
    property int    bgImageY: 0                     // Background Y
    property int    bgImageZ: 0                     // Background Y
    property int    bgImageWidth: container.width   // Background 넓이
    property int    bgImageHeight: container.height // Background 높이

    property string lineImage: ""                   // Line Image Source
    property int    lineImageX: 0                   // Line Image X좌표
    property int    lineImageY: 0                   // Line Image Y좌표
    property bool   lineVisible: true               // Line Image Visible

    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage
    property int    fgImageX: 0
    property int    fgImageY: 0
    property int    fgImageWidth: 0
    property int    fgImageHeight: 0
    property bool   fgImageVisible: true
    property bool   fgImageFocusVisible: true

    // First Text Info
    property string firstText: ""
    property int    firstTextSize: 1
    property int    firstTextX: 0
    property int    firstTextY: 0
    property int    firstTextWidth: 0
    property int    firstTextHeight: firstTextSize
    property string firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    property string firstTextAlies: "Left"
    property string firstTextElide: "Right"
    property bool   firstTextVisible: true
    property bool   firstTextEnabled: true
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor: firstTextColor
    property string firstTextFocusPressColor: firstTextPressColor
    property string firstTextFocusColor: colorInfo.brightGrey
    property string firstTextSelectedColor: firstTextColor
    property string firstDimmedTextColor: colorInfo.dimmedGrey
    property string firstTextDisableColor: colorInfo.disableGrey
    property string firstTextWrap: "Text.WordWrap"
    property bool   firstTextClip: true
    property real   firstTextLineHeight: 1

    // opacity: mEnabled ? 1.0 : 0.5
    dimmed: !mEnabled

    /* Ticker Enable! */
    property bool tickerEnable: false

    Connections {
        target: idAppMain
        onMouseAreaExit: {
            container.state = "STATE_RELEASED"
        }

        onBtnReleased: {
            container.state = "STATE_RELEASED"
        }
    }

    onStateChanged: {
    }


    /* EVENT handlers */
    onPressed: {
    }

    onReleased: {
        if(false == container.dimmed){
        console.log("## ~ Play Beep Sound(MButton2) ~ ##")
        UIListener.ManualBeep();
        }
    }

    onCancel: {
        if(!container.mEnabled) return;
        container.state = "keyRelease"
    }

    onSelectKeyPressed: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED";
        } else if(true == container.mEnabled) {
            container.state = "STATE_PRESSED";
        } else {
            container.state = "STATE_DISABLED"
        }
    }

    onAnyKeyReleased: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED"
        } else if(true == container.mEnabled) {
            if(true == container.active) {
                container.state = "STATE_ACTIVE"
            } else {
                container.state = "STATE_RELEASED";
            }
        } else {
            container.state = "STATE_DISABLED"
        }
    }

    onClickOrKeySelected: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED"
        } else if(true == container.mEnabled) {
            if(true == container.active) {
                container.state = "STATE_ACTIVE"
            } else {
                container.state = "STATE_RELEASED";
            }
        } else {
            container.state = "STATE_DISABLED"
        }
    }


    /* WIDGETS */
    Image {
        // Line Image는 배경보다 아래에 위치해야함 Line의 1px은 배경보다 밑에 깔려야함
        source: lineImage
        x: lineImageX
        y: lineImageY
        visible: ("" == lineImage) ? false : lineVisible
    }

    Image {
        id: idBtnBackImage
        source: bgImage
        x: bgImageX
        y: bgImageY
        z: bgImageZ
        width: bgImageWidth
        height: bgImageHeight
        visible: !idBtnBackFocusImage.visible
    }

    Image {
        id: idBtnBackFocusImage
        source: bgImageFocus
        x: bgImageX
        y: bgImageY
        width: bgImageWidth
        height: bgImageHeight
        visible: buttonFocus
    }

    Image {
        id: idBtnForeImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
        enabled: mEnabled ? 1.0 : 0.5
    }

    Image {
        id: idBtnForeFocusImage
        x: fgImageX
        y: fgImageY
        z: 1
        width: fgImageWidth
        height: fgImageHeight
        source: fgImageFocus
        visible: buttonFocus && fgImageVisible && fgImageFocusVisible
        enabled: mEnabled ? 1.0 : 0.5
    }

    // First text
    Text {
        id: txtFirstText
        text: firstText
        x: firstTextX
        //y: firstTextY
        z: bgImageZ + 1
        width: firstTextWidth
        height: firstTextHeight
        color: firstTextColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -5

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Left") {
                Text.AlignLeft
            } else {
                Text.AlignHCenter
            }
        }

        elide: {
            if(firstTextElide == "Right") {
                Text.ElideRight
            } else if(firstTextElide == "Left") {
                Text.ElideLeft
            } else if(firstTextElide == "Center") {
                Text.ElideMiddle
            } else {
                Text.ElideNone
            }
        }

        visible: !txtFocusFirstText.visible //firstTextVisible && false == txtFocusFirstText.visible
        clip: false
        wrapMode: firstTextWrap
        enabled: firstTextEnabled
        lineHeight: firstTextLineHeight
    }

    // First Focus text
    Text {
        id: txtFocusFirstText
        text: firstText
        x: firstTextX
        //y: firstTextY
        z: bgImageZ + 1
        width: firstTextWidth
        height: firstTextHeight
        color: firstTextFocusColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -5

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Left") {
                Text.AlignLeft
            } else {
                Text.AlignHCenter
            }
        }

        elide: {
            if(firstTextElide == "Right") {
                Text.ElideRight
            } else if(firstTextElide == "Left") {
                Text.ElideLeft
            } else if(firstTextElide == "Center") {
                Text.ElideMiddle
            } else {
                Text.ElideNone
            }
        }

        visible: firstTextVisible && buttonFocus && parking == true
        clip: false
        wrapMode: firstTextWrap
        enabled: firstTextEnabled
        lineHeight: firstTextLineHeight
    }

    /* STATES */
    states: [
        State {
            name: "STATE_PRESSED"
            when: isMousePressed()
            PropertyChanges { target: idBtnBackImage;       source: bgImagePress }
            PropertyChanges { target: idBtnForeImage;       source: fgImagePress }
            PropertyChanges { target: txtFirstText;         color: firstTextPressColor }
            PropertyChanges { target: idBtnBackFocusImage;  visible: false }
            PropertyChanges { target: txtFocusFirstText;    visible: false }
        }
        , State {
            name: "STATE_ACTIVE"
            when: true == container.active
            PropertyChanges { target: idBtnBackImage;       source: bgImageActive }
            PropertyChanges { target: idBtnForeImage;       source: fgImageActive }
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
            //PropertyChanges { target: txtFocusFirstText;    visible: true }
            //PropertyChanges { target: txtFocusSecondText;   visible: true }
            PropertyChanges { target: txtFirstText;         color: firstTextFocusColor }
        }
        , State {
            name: "STATE_RELEASED"
            PropertyChanges { target: idBtnBackImage;
                source: true == container.active ? bgImageActive : bgImage
            }
            PropertyChanges { target: idBtnForeImage; source: fgImage  }
            PropertyChanges { target: txtFirstText;
                color: true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor :firstTextColor
            }
        }
        , State {
            name: "STATE_DIMMED"
            when: container.dimmed
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
        }
        , State {
            name: "STATE_DISABLED"
            when: !mEnabled
            PropertyChanges { target: idBtnBackImage;       source: bgImage }
            PropertyChanges { target: idBtnForeImage;       source: fgImage }
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
        }
    ]
}
/* EOF */
