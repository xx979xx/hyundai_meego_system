/**
 * DDCallButton.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComp.MComponent
{
    id: container

    // PROPERTIES
    property bool active: false
    property string buttonName: ""

    property string bgImage: ImagePath.imgFolderBt_phone + "ico_call_add_n.png"
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""

    property int fgImageX: 0
    property int fgImageY: 0
    property int fgImageWidth:66
    property int fgImageHeight:66
    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage

    property string firstText: ""
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: 0
    property int firstTextHeight: firstTextSize
    property string firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    property string firstTextAlies: "Left"
    property string firstTextElide: "None"
    property bool firstTextVisible: true

    property string secendText: ""
    property bool secend_visible: false

    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: "Black"
    property string firstDimmedTextColor: colorInfo.dimmedGrey


    /* 텍스트의 넓이를 확인하는 함수
     */
    function textPaintSizeChange() {
        if(298 > container.width) {
            /* 콜화면 하단에 버튼이 3개가 존재 할 때 (버튼 최대 넓이 220)
             */
            if(hideText.paintedWidth < 210) {
                // 최대 넓이가 아닌경우 PaintedWidth를 넓이로 설정
                txtFirstText.width = hideText.paintedWidth;
            } else {
                // 최대 넓이를 벗어나는 경우 181 넓이 고정
                txtFirstText.width = 210
            }
        } else {
            /* 콜화면 하단에 버튼이 2개가 존재 할 때 (버튼 최대 넓이 335)
             */
            if(hideText.paintedWidth < 330) {
                // 최대 넓이가 아닌경우 PaintedWidth를 넓이로 설정
                txtFirstText.width = hideText.paintedWidth;
            } else {
                // 최대 넓이를 벗어나는 경우 335으로 넓이 고정
                txtFirstText.width = 330;
            }
        }
    }

    Component.onCompleted: {
        textPaintSizeChange();
    }

    onCancel: {
        if(!container.mEnabled) return;
        container.state = "keyRelease"
    }

    Connections {
        target: idAppMain
        onMouseAreaExit: {
            container.state = "keyReless"
        }

        onBtnReleased: {
            container.state = "keyReless"
        }
    }

    onReleased: {
        if(false == container.dimmed){
        console.log("## ~ Play Beep Sound(DDCallButton) ~ ##")
        UIListener.ManualBeep();
        }
    }

    Image {
        id: backGround
        source: bgImage
        anchors.fill: parent
    }

    Image {
        id: idFocusImage
        source: bgImageFocus
        visible: container.activeFocus && false == systemPopupOn
        anchors.fill: backGround
    }

    Item {
        id: textInfo

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: firstTextX + txtFirstText.width
        height: fgImageHeight

        Image {
            id: imgFgImage
            source: fgImage
            anchors.left: txtFirstText.right
            anchors.leftMargin: 10
            y: 0
            width: 68
            height: 60
        }

        Text {
            id: txtFirstText
            text: firstText
            x: 0
            y: firstTextY
            width: firstTextWidth
            height: firstTextHeight
            color: firstTextColor
            font.family: firstTextStyle
            font.pointSize: firstTextSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: firstTextVisible
            elide:  Text.ElideRight
        }

        Text {
            id: hideText
            text: firstText
            font.family: firstTextStyle
            font.pointSize: firstTextSize
            visible: false
            elide:  Text.ElideRight

            onTextChanged: {
                textPaintSizeChange();
            }
        }
    }

    onSelectKeyPressed: {
        if(container.dimmed) {
            container.state = "dimmed";
        } else if(container.mEnabled) {
            container.state = "pressed";
        } else {
            container.state = "disabled"
        }
    }

    onSelectKeyReleased: {
        if(container.dimmed) {
            container.state = "dimmed"
        } else if(container.mEnabled) {
            if(active == true) {
                container.state = "active"
            } else {
                container.state = "keyReless";
            }
        } else {
            container.state = "disabled"
        }
    }

    states: [
        State {
            name: "pressed"
            when: isMousePressed()
            PropertyChanges { target: backGround;   source: bgImagePress }
            PropertyChanges { target: imgFgImage;   source: fgImagePress }
            PropertyChanges { target: idFocusImage; visible: false; }
        }
        , State {
            name: "active"
            when: container.active
            PropertyChanges { target: backGround;   source: bgImageActive }
            PropertyChanges { target: imgFgImage;   source: fgImageActive }
            PropertyChanges { target: txtFirstText; color: firstTextSelectedColor }
        }
        , State {
            name: "keyPress"
            PropertyChanges { target: imgFgImage;   source: fgImageFocusPress }
            PropertyChanges { target: txtFirstText; color: firstTextFocusPressColor }
        }
        , State {
            name: "keyReless"
            PropertyChanges { target: backGround;
                source: true == container.active ? bgImageActive : bgImage
            }
            PropertyChanges { target: imgFgImage; source: fgImage  }
            PropertyChanges { target: txtFirstText;
                color: true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor :firstTextColor
            }
        }
        , State {
            name: "dimmed"
            when: container.dimmed
            //PropertyChanges { target: txtFirstText; color: firstDimmedTextColor }
        }
        , State {
            name: "disabled"
            when: !mEnabled
            //PropertyChanges { target: txtFirstText; color: colorInfo.disableGrey }
            PropertyChanges { target: backGround;   source: bgImage }
            PropertyChanges { target: imgFgImage;   source: fgImage }
        }
    ]
}
/* EOF */
