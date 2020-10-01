/**
 * /QML/DH/MSubButton.qml
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
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor : secondTextColor
    property string secondTextFocusPressColor: secondTextPressColor
    property string secondTextFocusColor: colorInfo.brightGrey
    property string secondTextSelectedColor: secondTextColor
    property string secondDimmedTextColor: colorInfo.dimmedGrey
    property string secondTextDisableColor: colorInfo.disableGrey
    property bool   secondTextFocusVisible: true
    property bool   secondTextClip: false

    property string callHistoryHeadName: ""
    property string callHistoryTailName: ""

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

    onCancel: {
        if(!container.mEnabled) return;
        container.state = "keyRelease"
    }

    //언어 변경 시 Text 변경 안되는 문제점 수정
    Connections {
        target: UIListener

        onRetranslateUi: {
            textCutting();
        }
    }

    onReleased: {
        if(false == container.dimmed){
        console.log("## ~ Play Beep Sound(MSubButton2) ~ ##")
        UIListener.ManualBeep();
        }
    }

    function textCutting() {
        oneLineText.text = firstText

        if(oneLineText.paintedWidth < 170) {
            callHistoryHeadName = firstText;
            callHistoryTailName = "";
        } else {
            // 스페이스를 포함하고 있다면 스페이스를 기준으로 앞뒤로 나눔
            var splitted_names = firstText.split(" ");
            var head_name = "";
            var tail_name = "";

            if(0 < splitted_names.length) {
                // 1개 이상의 스페이스를 포함
                var i = 0;
                for(/*var i = 0*/; i < splitted_names.length; i++) {
                    var temp = ("" == head_name) ? splitted_names[i] : (head_name + " " + splitted_names[i]);
                    oneLineText.text = temp;
                    if(oneLineText.paintedWidth > 170) {
                        break;
                    } else {
                        head_name = temp;
                    }
                }

                if("" == head_name) {
                    // 스페이스 앞이 너무 길어서 170 넘어간 경우, 붙인 이름에서 그냥 자름
                    var i = 0;
                    for(/*var i = 0*/; i < firstText.length; i++) {
                        var temp = firstText.substr(0, i + 1);
                        oneLineText.text = temp;

                        if(170 < oneLineText.paintedWidth) {
                            break;
                        }
                    }

                    callHistoryHeadName = firstText.substr(0, i);
                    callHistoryTailName = firstText.substr(i);
                } else {
                    callHistoryHeadName = head_name;

                    for(; i < splitted_names.length; i++) {
                        tail_name = ("" == tail_name) ? splitted_names[i] : (tail_name + " " + splitted_names[i]);
                    }

                    callHistoryTailName = tail_name;
                }
            } else {
                // 스페이스가 없을 경우 임의로 자름
                var i = 0;
                for(/*var i = 0*/; i < firstText.length; i++) {
                    var temp = firstText.substr(0, i + 1);
                    oneLineText.text = temp;

                    if(170 < oneLineText.paintedWidth) {
                        break;
                    }
                }

                callHistoryHeadName = firstText.substr(0, i);
                callHistoryTailName = firstText.substr(i);
            }
        }
    }

    Component.onCompleted: {
        textCutting();
    }

    onVisibleChanged: {
        if(true == container.visible) {
            textCutting();
        }
    }

    /* EVENT handlers */
    onSelectKeyPressed: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED";
        } else if(true == container.mEnabled) {
            container.state = "STATE_PRESSED";
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

    Image {
        id: idBtnBackImage
        source: bgImage
        x: bgImageX
        y: bgImageY
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

    // onLine Text
    Text {
        id: oneLineText
        text: callHistoryHeadName
        x: 15
        y: firstTextY
        width: 170
        height: firstTextHeight
        color: firstTextColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Left") {
                Text.AlignLeft
            } else {
                Text.AlignHCenter
            }
        }

        visible: ("" == callHistoryTailName) ? true : false
    }

    // TwoLine text
    Text {
        id: twoLineText1
        text: callHistoryHeadName
        x: 15
        y: 15
        width: 170
        height: firstTextHeight
        color: firstTextColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Left") {
                Text.AlignLeft
            } else {
                Text.AlignHCenter
            }
        }

        visible: ("" != callHistoryTailName) ? true : false
        clip: false
        enabled: firstTextEnabled
    }

    Text {
        id: twoLineText2
        text: callHistoryTailName
        x: 15
        y: 55
        width: 170
        height: firstTextHeight
        color: firstTextColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter

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

        visible: ("" != callHistoryTailName) ? true : false
        clip: false
        wrapMode: firstTextWrap
        enabled: firstTextEnabled
    }

    // Second text
    Text {
        id: txtSecondText
        text: secondText
        x: 15
        y: ("" != callHistoryTailName) ? 95 : firstTextY + 50
        width: secondTextWidth
        height: secondTextHeight
        color: secondTextColor
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

        visible: secondTextVisible
        clip: secondTextClip
        wrapMode: Text.Wrap
        enabled: secondTextEnabled
    }

    // onLine Text
    Text {
        id: oneLineFocusText
        text: callHistoryHeadName
        x: 15
        y: firstTextY
        width: 170
        height: firstTextHeight
        color: firstTextFocusColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Left") {
                Text.AlignLeft
            } else {
                Text.AlignHCenter
            }
        }

        visible: true == container.activeFocus && ("" == callHistoryTailName) ? true : false
    }

    // TwoLine text
    Text {
        id: twoLineFocusText1
        text: callHistoryHeadName
        x: 15
        y: 15
        width: 170
        height: firstTextHeight
        color: firstTextFocusColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Left") {
                Text.AlignLeft
            } else {
                Text.AlignHCenter
            }
        }

        visible: true == container.activeFocus && ("" != callHistoryTailName) ? true : false
        clip: false
        enabled: firstTextEnabled
    }

    Text {
        id: twoLineFocusText2
        text: callHistoryTailName
        x: 15
        y: 55
        width: 170
        height: firstTextHeight
        color: firstTextFocusColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter

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

        visible: true == container.activeFocus && ("" != callHistoryTailName) ? true : false
        clip: false
        wrapMode: firstTextWrap
        enabled: firstTextEnabled
    }

    // Second text
    Text {
        id: txtSecondFocusText
        text: secondText
        x: 15
        y: ("" != callHistoryTailName) ? 95 : firstTextY + 50
        width: secondTextWidth
        height: secondTextHeight
        color: secondTextFocusColor
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

        visible: true == container.activeFocus
        clip: secondTextClip
        wrapMode: Text.Wrap
        enabled: secondTextEnabled
    }

    /* STATES */
    states: [
        State {
            name: "STATE_PRESSED"
            when: isMousePressed()
            PropertyChanges { target: idBtnBackImage;       source: bgImagePress }
            PropertyChanges { target: oneLineText;          color: container.activeFocus ? firstTextFocusColor : container.active ? firstTextSelectedColor : firstTextPressColor }
            PropertyChanges { target: twoLineText1;         color: container.activeFocus ? firstTextFocusColor : container.active ? firstTextSelectedColor : firstTextPressColor }
            PropertyChanges { target: twoLineText2;         color: container.activeFocus ? firstTextFocusColor : container.active ? firstTextSelectedColor : firstTextPressColor }
            PropertyChanges { target: txtSecondText;        color: container.activeFocus ? firstTextFocusColor : container.active ? firstTextSelectedColor : firstTextPressColor }
            PropertyChanges { target: idBtnBackFocusImage;  visible: false }
        }
        , State {
            name: "STATE_ACTIVE"
            when: true == container.active
            PropertyChanges { target: idBtnBackImage;       source: bgImageActive }
            PropertyChanges {
                target: oneLineText;
                color: parking == true ? firstTextSelectedColor
                       : true == container.activeFocus ? firstTextFocusColor
                       : true == container.active ? firstTextSelectedColor
                       : firstTextColor
            }
            PropertyChanges {
                target: twoLineText1;
                color: parking == true ? firstTextSelectedColor
                       : true == container.activeFocus ? firstTextFocusColor
                       : true == container.active ? firstTextSelectedColor
                       : firstTextColor
            }
            PropertyChanges {
                target: twoLineText2;
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
            name: "STATE_RELEASED"
            PropertyChanges {
                target: idBtnBackImage;
                source: true == container.active ? bgImageActive : bgImage
            }
            PropertyChanges {
                target: oneLineText;
                color: true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor : firstTextColor
            }
            PropertyChanges {
                target: twoLineText1;
                color: true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor : firstTextColor
            }
            PropertyChanges {
                target: twoLineText2;
                color: true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor : firstTextColor
            }
            PropertyChanges {
                target: txtSecondText;
                color: true == container.active ? secondTextSelectedColor : dimmed ? secondTextDisableColor : secondTextColor
            }
        }
        , State {
            name: "STATE_DIMMED"
            when: container.dimmed
            PropertyChanges { target: oneLineText;          color: firstTextDisableColor }
            PropertyChanges { target: twoLineText1;         color: firstTextDisableColor }
            PropertyChanges { target: twoLineText2;         color: firstTextDisableColor }
            PropertyChanges { target: txtSecondText;        color: secondTextDisableColor }
        }
        , State {
            name: "STATE_DISABLED"
            when: !mEnabled
            PropertyChanges { target: idBtnBackImage;       source: bgImage }
            PropertyChanges { target: oneLineText;          color: firstTextDisableColor }
            PropertyChanges { target: twoLineText1;         color: firstTextDisableColor }
            PropertyChanges { target: twoLineText2;         color: firstTextDisableColor }
            PropertyChanges { target: txtSecondText;        color: secondTextDisableColor }
        }
    ]
}
/* EOF */

