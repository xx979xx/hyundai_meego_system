/**
 * /QML/DH_arabic/MButtonHaveTicker.qml
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
    property bool playBeepOn: true
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
    property string firstTextColor: colorInfo.commonGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: firstTextPressColor
    property string firstTextFocusColor: colorInfo.brightGrey
    property string firstTextSelectedColor: firstTextColor
    property string firstDimmedTextColor: colorInfo.dimmedGrey
    property string firstTextDisableColor: colorInfo.disableGrey
    property string firstTextWrap: "Text.WordWrap"
    property bool   firstTextClip: true

    // Second Text Info
    property string secondText: ""
    property int    secondTextSize: 1
    property int    secondTextX: 0
    property int    secondTextY: 0
    property int    secondTextWidth: 0
    property int    secondTextHeight: secondTextSize
    property string secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    property string secondTextAlies: "Left"
    property string secondTextElide: "Right"
    property bool   secondTextVisible: true
    property bool   secondTextEnabled: true
    property string secondTextColor: colorInfo.commonGrey
    property string secondTextPressColor : colorInfo.brightGrey
    property string secondTextFocusPressColor: secondTextPressColor
    property string secondTextFocusColor: colorInfo.brightGrey
    property string secondTextSelectedColor: secondTextColor
    property string secondDimmedTextColor: colorInfo.dimmedGrey
    property string secondTextDisableColor: colorInfo.disableGrey
    property bool   secondTextFocusVisible: true
    property bool   secondTextClip: false

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

    onCancel: {
        if(!container.mEnabled) return;
        container.state = "keyRelease"
    }

    /* EVENT handlers */
    onPressed: {
    }

    onReleased: {
        if(false == container.dimmed){
        console.log("## ~ Play Beep Sound(MButtonHaveTickerDelegate) ~ ##")
        UIListener.ManualBeep();
        }
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
        height: parent.height
        color: container.activeFocus ? firstTextFocusColor : firstTextColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter

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

        visible: !txtFocusFirstText.visible//firstTextVisible && false == txtFocusFirstText.visible
        clip: false
        wrapMode: ("SettingsBtDeviceConnect" == idAppMain.state)? Text.NoWrap : firstTextWrap
        enabled: firstTextEnabled
    }

    // First focus text
    DDScrollTicker {
        id: txtFocusFirstText
        tickerText: firstText
        x: firstTextX
        //y: firstTextY - 5
        z: bgImageZ + 1
        width: firstTextWidth
        height: parent.height //(firstTextStyle == stringInfo.fontFamilyRegular && firstTextSize < 39) ? firstTextHeight + 10 : firstTextHeight + 11
        color: firstTextFocusColor
        fontFamily: firstTextStyle
        fontSize: firstTextSize
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Center") {
                Text.AlignHCenter
            } else {
                Text.AlignLeft
            }
        }

        visible: firstTextVisible && buttonFocus && parking == true
        enabled: firstTextEnabled

        onVisibleChanged: {
            txtFocusFirstText.setFocus(txtFocusFirstText.visible);
        }

        tickerEnable: container.tickerEnable
    }

    // Second text
    Text {
        id: txtSecondText
        text: secondText
        x: secondTextX
        y: secondTextY
        z: bgImageZ + 1
        width: secondTextWidth
        height: secondTextHeight
        color: container.activeFocus ? secondTextFocusColor : secondTextColor
        font.family: secondTextStyle
        font.pointSize: secondTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(secondTextAlies == "Right") {
                Text.AlignRight
            } else if(secondTextAlies == "Left") {
                Text.AlignLeft
            } else if(secondTextAlies == "Center") {
                Text.AlignHCenter
            } else {
                Text.AlignHCenter
            }
        }

        elide: {
            if(secondTextElide == "Right") {
                Text.ElideRight
            } else if(secondTextElide == "Left") {
                Text.ElideLeft
            } else if(secondTextElide == "Center") {
                Text.ElideMiddle
            } else /*if(secondTextElide=="None")*/ {
                Text.ElideNone
            }
        }

        visible: !txtFocusSecondText.visible //secondTextVisible && false == txtFocusSecondText.visible
        clip: secondTextClip
        wrapMode: Text.Wrap
        enabled: secondTextEnabled
    }

    // Second focus text
    DDScrollTicker {
        id: txtFocusSecondText
        tickerText: secondText
        x: secondTextX
        y: secondTextY - 5
        z: bgImageZ + 1
        width: secondTextWidth
        height: (secondTextStyle == stringInfo.fontFamilyRegular && secondTextSize < 39) ? secondTextHeight + 10 : secondTextHeight + 11
        color: secondTextFocusColor
        fontFamily: secondTextStyle
        fontSize: secondTextSize
        tickerDuration: txtFocusFirstText.tickerDuration
        tickerSecondText: true
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(secondTextAlies == "Right") {
                Text.AlignRight
            } else if(secondTextAlies == "Left") {
                Text.AlignLeft
            } else if(secondTextAlies == "Center") {
                Text.AlignHCenter
            } else {
                Text.AlignHCenter
            }
        }

        visible: txtFocusFirstText.visible && parking == true
        enabled: secondTextEnabled

        onVisibleChanged: {
            if(true == txtFocusSecondText.visible) {
                if(0 != txtFocusFirstText.tickerDuration) {
                    txtFocusSecondText.tickerDuration = txtFocusFirstText.tickerDuration
                }
            }

            txtFocusSecondText.setFocus(txtFocusSecondText.visible);
        }

        tickerEnable: container.tickerEnable
    }

    /* STATES */
    states: [
        State {
            name: "STATE_PRESSED"
            when: isMousePressed()
            PropertyChanges { target: idBtnBackImage;       source: bgImagePress }
            PropertyChanges { target: idBtnForeImage;       source: fgImagePress }
            PropertyChanges { target: txtFirstText;         color: firstTextPressColor }
            PropertyChanges { target: txtSecondText;        color: secondTextPressColor }
            PropertyChanges { target: idBtnBackFocusImage;  visible: false }
            PropertyChanges { target: txtFocusFirstText;    visible: false }
            PropertyChanges { target: txtFocusSecondText;   visible: false }
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
            PropertyChanges { target: txtSecondText;
                color: parking == true ? secondTextSelectedColor
                       : true == container.activeFocus ? secondTextFocusColor
                       : true == container.active ? secondTextSelectedColor
                       : secondTextColor
            }
        }
        , State {
            name: "STATE_FOCUS"
            when: true == container.activeFocus
            //PropertyChanges { target: txtFocusFirstText;    visible: true }
            //PropertyChanges { target: txtFocusSecondText;   visible: true }
            PropertyChanges { target: txtFirstText;         color: firstTextFocusColor }
            PropertyChanges { target: txtSecondText;        color: secondTextFocusColor }
        }
        , State {
            name: "STATE_RELEASED"
            PropertyChanges { target: idBtnBackImage;
                source: true == container.active ? bgImageActive : bgImage
            }
            PropertyChanges { target: idBtnForeImage; source: fgImage  }
            PropertyChanges { target: txtFirstText;
                color: true == container.activeFocus ? firstTextFocusColor : true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor :firstTextColor
            }
            PropertyChanges { target: txtSecondText;
                color: true == container.activeFocus ? secondTextFocusColor : true == container.active ? secondTextSelectedColor : dimmed ? secondTextDisableColor : secondTextColor
            }
        }
        , State {
            name: "STATE_DIMMED"
            when: container.dimmed
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
            PropertyChanges { target: txtSecondText;        color: secondTextDisableColor }
        }
        , State {
            name: "STATE_DISABLED"
            when: !mEnabled
            PropertyChanges { target: idBtnBackImage;       source: bgImage }
            PropertyChanges { target: idBtnForeImage;       source: fgImage }
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
            PropertyChanges { target: txtSecondText;        color: secondTextDisableColor }
        }
    ]
}
/* EOF */

