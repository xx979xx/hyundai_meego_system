/**
 * /QML/DH/MSlider.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MComponent
{
    id: idMSlider
    //width: 795
    //height: 82

    // PROPERTIES
    property int sliderX: 89
    property int sliderY: 27

    property int pointValue : BtCoreCtrl.m_handsfreeMicVolume - 1     //sliderDivision / 2
    property int sliderDivision: 5
    property int sliderWidth: 609
    property int pointGap: sliderWidth / (sliderDivision - 1)
    property int pressedX: 0
    property int sliderMin: 0
    property int sliderMax: 4
    property int adjustMargin: 20
    property int adjustGap: pointGap / 3

    property bool dimmed : BtCoreCtrl.m_handsfreeMicMute
    property string direction: ""

    // SIGNALS
    signal sliderRecelesed();

    mEnabled: dimmed


    /* INTERNAL functions */
    function decrease() {
        if(false == dimmed) {
            direction = "LEFT";
            pointValue = (pointValue > sliderMin) ? pointValue - 1 : sliderMin;
        }
    }

    function increase() {
        if(false == dimmed) {
            direction = "RIGHT"
            pointValue = (pointValue < sliderMax) ? pointValue + 1 : sliderMax;
        }
    }


    /* EVENT handlers */
    onPointValueChanged: {
        BtCoreCtrl.invokeHandsfreeSetMicVolume(pointValue + 1);
    }

    onWheelLeftKeyPressed: {
        decrease();
    }

    onWheelRightKeyPressed: {
        increase();
    }

    onVisibleChanged: {
        if(true == idMSlider.visible) {
            pointValue = BtCoreCtrl.m_handsfreeMicVolume - 1;
        }
    }


    /* WIDGETS */
    Image  {
        source: ImagePath.imgFolderBt_phone + "bg_call_vol_f.png"
        visible: true == idMSlider.activeFocus
    }

    Image {
        id: sliderBgImage
        source: ImagePath.imgFolderBt_phone + "slider_call_vol_bg.png"
        x: 39
        y: 32
        width: 669
        height: 18

        MouseArea {
            anchors.left: sliderBgImage.left
            anchors.right: sliderBgImage.right
            y: -25
            height: 60

            onPositionChanged: {
                if(mouseX > 0 && mouseY > 0) {
                    if(false == dimmed) {
                        if(mouseX < sliderBgImage.x + adjustMargin) {
                            pointValue = sliderMin
                            pressedX = mouseX
                            direction = "LEFT"
                        } else if(mouseX >= sliderBgImage.x + sliderBgImage.width - adjustMargin) {
                            pointValue = sliderMax
                            pressedX = mouseX
                            direction = "RIGHT"
                        } else if(mouseX < pressedX) {
                            if(pressedX - mouseX > pointGap) { //adjustGap) {
                                pointValue = (pointValue > sliderMin) ? pointValue - 1 : sliderMin
                                pressedX = mouseX
                                //pressedX += pointGap
                                direction = "LEFT"

                                qml_debug("1. mouseX = " + mouseX + ", pressedX = " + pressedX)
                                qml_debug(direction);
                            }
                        } else if(mouseX >= pressedX) {
                            if(mouseX - pressedX > pointGap) { //adjustGap) {
                                pointValue = (pointValue < sliderMax) ? pointValue + 1 : sliderMax
                                pressedX = mouseX
                                //pressedX += pointGap
                                direction = "RIGHT"

                                qml_debug("2. mouseX = " + mouseX + ", pressedX = " + pressedX)
                                qml_debug(direction);
                            }
                        } else {
                            // ?
                        }
                    } else {
                        qml_debug("Dimmed Scroll");
                    }
                }
            }

            onPressed: {
                if(false == dimmed) {
                    pressedX = mouseX
                    direction = "";
                    idMSlider.forceActiveFocus();
                }
            }

            onReleased: {
                /* Dim 처리 된 경우 동작 하지 않도록 수정
                 */
                if(false == dimmed) {
                    if("RIGHT" == direction) {
                        pointValue = (pointValue < sliderMax) ? pointValue + 1 : sliderMax;
                    } else if("LEFT" == direction) {
                        pointValue = (pointValue > sliderMin) ? pointValue - 1 : sliderMin;
                    }

                    //direction = "RIGHT"
                    //pointValue = (pointValue < sliderMax) ? pointValue + 1 : sliderMax;

                    if("" == direction) {
                        /* Touch한 경우
                         * (좌우로 Drag한 경우 direction이 LEFT/RIGHT로 변경되므로 NULL string인 상태를 Touch로 간주함)
                         */
                        console.log("## pointGap = " + pointGap);
                        console.log("## pressedX = " + pressedX);
                        console.log("## Math.round(pressedX / pointGap) = " + Math.round(pressedX / pointGap));

                        pointValue = Math.round(pressedX / pointGap);
                    } else {
                        // Touch and drag 한 경우
                        //DEPRECATED BtCoreCtrl.HandleSetMicVolume(pointValue)
                    }
                }
            }
        }

        Item {
            id: idSliderFgImage
            height: 18
            anchors.left: sliderBgImage.left
            anchors.right: idSliderPointImage.horizontalCenter
            clip: true

            Image {
                source: idMSlider.activeFocus ? ImagePath.imgFolderBt_phone + "slider_call_vol_f.png" : ImagePath.imgFolderBt_phone + "slider_call_vol_n.png"
                width: 669
                height: 18
            }
        }

        Image {
            id: idSliderPointImage
            source: idMSlider.activeFocus ? ImagePath.imgFolderSettings + "screen_slider_pointer_f.png" : ImagePath.imgFolderSettings + "screen_slider_pointer_n.png"
            x: pointGap * pointValue - ((0 == pointValue) ? 15 : -15)
            y: -21
        }
    }

    Text {
        y: 10
        text : BtCoreCtrl.m_handsfreeMicVolume
        width: 73
        font.pointSize: 36
        horizontalAlignment: "AlignHCenter"
        color: colorInfo.brightGrey
        anchors.left: sliderBgImage.right
        anchors.leftMargin:5
        font.family: stringInfo.fontFamilyBold    //"HDB"
    }
}
/* EOF */
