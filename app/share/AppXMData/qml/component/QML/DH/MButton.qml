import Qt 4.7
import "../../system/DH" as MSystem
import "../../XMData" as XM

MComponent {
    id: container

    property string bgImage: ""
    property string bgImageButtonLine: ""
    property string bgImagePress: bgImage
    property string bgImageFocusPress: bgImage
    property string bgImageFocus: bgImageFocusPress
    property bool bgFitToSize: false

    property alias fgImageX: imgFgImage.x
    property alias fgImageY: imgFgImage.y
    property alias fgImageWidth: imgFgImage.width
    property alias fgImageHeight: imgFgImage.height
    property alias fgImage:imgFgImage.source
    property alias fgImageVisible: imgFgImage.visible

    property alias firstText: idText.text
    property alias firstTextSize: idText.fontSize
    property alias firstTextStyle: idText.fontFamily
    property alias firstTextAlies: idText.horizontalAlignment
    property color firstTextColor: colorInfo.brightGrey
    property color firstTextPressColor: colorInfo.brightGrey
    property color firstTextFocusPressColor: colorInfo.brightGrey           //not used
    property color firstTextDisableColor: colorInfo.disableGrey
    property color firstTextSelectedColor: colorInfo.brightGrey
    property int firstTextX: 7
    property int firstTextWidth: width - firstTextX - firstTextX
    property alias btnText: idText
    property bool isMuteButton: false

    property int e_UNKNOWN: 0
    property int e_NORMAL: 1
    property int e_PRESSED: 2
    property int e_FOCUSED: 3
    property int e_ACTIVED: 4
    property int e_DISABLED: 5

    property int buttonState: e_NORMAL
    property bool isMousePress: isMousePressedOnly(); // isMousePressed()
    property bool focusImageVisible: container.activeFocus //buttonState == e_FOCUSED

    onShowFocusChanged: {
        stateControl(e_UNKNOWN);
    }
//    opacity: enabled ? 1.0 : 0.5

    function stateControl(bPressed)
    {
        if(bPressed == e_UNKNOWN)
        {
            buttonState = (mEnabled == false || enabled == false) ? e_DISABLED : (activeFocus && showFocus) ? e_FOCUSED : focus ? e_ACTIVED : e_NORMAL;
        }else
        {
            buttonState = (mEnabled || enabled) ? bPressed : e_DISABLED
        }
    }

    Image{
        id: backGround
        anchors.fill: parent
        source: buttonState == e_PRESSED ? bgImagePress : buttonState == e_FOCUSED ? bgImageFocus : bgImage
        fillMode: bgFitToSize ? Image.PreserveAspectCrop : Image.Stretch
        Image{
            id: imgbgImageButtonLine
            anchors.fill: parent
            source: bgImageButtonLine
        }
        Image{
            id: imgFgImage
            x: fgImageX; y: fgImageY
            width: fgImageWidth; height: fgImageHeight
            source: fgImage
            opacity: enabled ? 1.0 : 0.5//[ITS 183254]
        }
        DDScrollTicker{
            id: idText
            x: firstTextX
            width: firstTextWidth
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:buttonState == e_DISABLED ? firstTextDisableColor : buttonState == e_PRESSED ? firstTextPressColor : buttonState == e_FOCUSED ? firstTextSelectedColor : buttonState == e_ACTIVED ? firstTextSelectedColor : firstTextColor
            tickerEnable: true
            tickerFocus: buttonState == e_FOCUSED
//            opacity: enabled ? 1.0 : 0.5//[ITS 183254]
        }
    }

    onEnabledChanged: {
        if(enabled)
            stateControl(e_UNKNOWN);
        else
            stateControl(e_DISABLED);
    }

    onActiveFocusChanged: {
        stateControl(e_UNKNOWN)
    }

    onIsMousePressChanged: {
        if(isMousePress)
            stateControl(e_PRESSED)
        else
            stateControl(e_UNKNOWN)
    }

    onSelectKeyPressed: {
        stateControl(e_PRESSED)
    }

    onSelectKeyReleased: {
        stateControl(e_UNKNOWN)
    }

    onFocusChanged: {
        stateControl(e_UNKNOWN)
    }

    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            if(playBeepOn && !isMuteButton && buttonState != e_DISABLED)
                UIListener.playAudioBeep();
        }
    }

    onPressAndHold: {
//        console.debug("------ [MButton] [onPressAndHold] ")
    }

    //[ITS 185633]
    Connections {
        target: UIListener
        onHideWhenBG:{
            //[ITS 185632, 185633]
            if(isLongKey == true)
                isLongKey = false;
            if(enterKeyPressed == true)
                enterKeyPressed = false;
            upKeyLongPressed = false;
            downKeyLongPressed = false;
            anyKeyReleased();
            selectKeyReleased();
        }
    }

    XM.XMRectangleForDebug{}
}
