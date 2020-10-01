/**
 * /BT_arabic/Call/BtCallSingle.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


Item
{
    id: idBtCallSingleMain
    x: 0
    y: 0
    width: 787
    height: 195
    //__IQS_15MY__ Call End Modify
    visible: (false == callPrivateMode || (false != callPrivateMode && (21 == BtCoreCtrl.m_ncallState || 20 == BtCoreCtrl.m_ncallState)) || (true == iqs_15My && 1 == BtCoreCtrl.m_ncallState)) && (false == callShowMicVolume) && (false == callShowDTMF)

    // PROPERTIES
    property bool toggleBlink: true
    property int blinkCount: 0


    function startBlink() {
        stopBlink();
        idCallEndBlinkTimer.start();
    }

    function stopBlink() {
        if(true == idCallEndBlinkTimer.running) {
            idCallEndBlinkTimer.stop();
        }

        toggleBlink = false;
        blinkCount = 0;

        idTimeText.opacity = 1;
        imgBtCallImage.opacity = 1;
    }

    /* CONNECTIONS */
    Connections{
        target: idCallMain

        onSigBlinkingStart: {
            startBlink();
        }

        onSigBlinkingStop: {
            stopBlink();
        }
    }


    /* WIDGETS */
    Image {
        id: imgBtCallImage
        source: {
            if(21 == BtCoreCtrl.m_ncallState || 20 == BtCoreCtrl.m_ncallState) {
                ImagePath.imgFolderBt_phone + "call_state_calling_n.png"
            } else if(1 == BtCoreCtrl.m_ncallState) {
                ImagePath.imgFolderBt_phone + "call_state_end_n.png"
            } else {
                if(31 == BtCoreCtrl.m_ncallState) {
                    if(true == firstCallStateIncoming) {
                        ImagePath.imgFolderBt_phone + "call_state_receive_n.png"
                    } else {
                        ImagePath.imgFolderBt_phone + "call_state_send_n.png"
                    }
                } else {
                    ImagePath.imgFolderBt_phone + "call_state_wait_d.png"
                }
            }
        }

        x: 658
        y: 0
        width: 180
        height: 180
    }

    Text {
        id: idTimeText
        text: {
            if(21 == BtCoreCtrl.m_ncallState || 20 == BtCoreCtrl.m_ncallState) {
                stringInfo.str_Connecting
            } else {
                if(31 == BtCoreCtrl.m_ncallState){
                    BtCoreCtrl.m_strTimeStamp0
                } else {
                    if(1 == BtCoreCtrl.m_ncallState){
                        if((1 == BtCoreCtrl.m_nActivatedCallPos) && (true == BtCoreCtrl.m_n3wayCallEnded)) {
                            if("" == MOp.stringTrim(BtCoreCtrl.m_strTimeStamp1)) {
                                stringInfo.str_Bt_Call_End_Two_Btn
                            } else {
                                if("00:00" == BtCoreCtrl.m_strTimeStamp1) {
                                    stringInfo.str_Bt_Call_End_Two_Btn
                                } else {
                                    BtCoreCtrl.m_strTimeStamp1
                                }
                            }
                        } else {
                            if("" == MOp.stringTrim(BtCoreCtrl.m_strTimeStamp0)) {
                                stringInfo.str_Bt_Call_End_Two_Btn
                            } else {
                                if("00:00" == BtCoreCtrl.m_strTimeStamp0) {
                                    stringInfo.str_Bt_Call_End_Two_Btn
                                } else {
                                    BtCoreCtrl.m_strTimeStamp0
                                }
                            }
                        }
                    } else {
                        stringInfo.str_Wait
                    }
                }
            }
        }

        x: 51
        y: {
            if((1 == BtCoreCtrl.m_ncallState) && (1 == BtCoreCtrl.m_nActivatedCallPos) && (true == BtCoreCtrl.m_n3wayCallEnded)) {
                if("" != BtCoreCtrl.m_strPhoneName1) {
                    -7
                } else {
                    32
                }
            } else {
                if("" != BtCoreCtrl.m_strPhoneName0) {
                    -7
                } else {
                    32
                }
            }
        }

        width: 588
        height: 32
        font.pointSize: 32
        color: 30 == BtCoreCtrl.m_ncallState ? colorInfo.dimmedGrey : colorInfo.bandBlue
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        font.family: stringInfo.fontFamilyRegular   //"HDR"
    }

    Text {
        id: idNameText
        text: {
            if(1 == BtCoreCtrl.m_ncallState) {
                if((1 == BtCoreCtrl.m_nActivatedCallPos) && (true == BtCoreCtrl.m_n3wayCallEnded)) { 
                    MOp.getCallerId(BtCoreCtrl.m_strPhoneName1, BtCoreCtrl.m_strPhoneNumber1)
                } else {
                    MOp.getCallerId(BtCoreCtrl.m_strPhoneName0, BtCoreCtrl.m_strPhoneNumber0)
                }
            } else {
                MOp.getCallerId(BtCoreCtrl.m_strPhoneName0, BtCoreCtrl.m_strPhoneNumber0)
            }
        }
        x: 51
        y: {
            if((1 == BtCoreCtrl.m_ncallState) && (1 == BtCoreCtrl.m_nActivatedCallPos) && (true == BtCoreCtrl.m_n3wayCallEnded)) {
                if("" != BtCoreCtrl.m_strPhoneName1) {
                    41
                } else {
                    80
                }
            } else {
                if("" != BtCoreCtrl.m_strPhoneName0) {
                    41
                } else {
                    80
                }
            }
        }  
        width: 588
        height: 60

        font.pointSize: 60
        //elide: MOp.checkArab(idNameText.text) ? Text.ElideRight : Text.ElideLeft
        elide: Text.ElideRight
        color: 30 == BtCoreCtrl.m_ncallState ? colorInfo.dimmedGrey : colorInfo.brightGrey
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        //clip: true    전화번호 짤리는 문제 - ISV 78710
    }

    Text {
        id: idNumberText
        text: {
            if(1 == BtCoreCtrl.m_ncallState) {
                if((1 == BtCoreCtrl.m_nActivatedCallPos) && (true == BtCoreCtrl.m_n3wayCallEnded)) { 
                    MOp.checkPhoneNumber(BtCoreCtrl.m_strPhoneNumber1)
                } else {
                    MOp.checkPhoneNumber(BtCoreCtrl.m_strPhoneNumber0)
                }
            } else {
                MOp.checkPhoneNumber(BtCoreCtrl.m_strPhoneNumber0)
            }
        }        
        x: 51
        y: 126
        width: 588
        height: 42

        // 전화번호부에 저장되어있지 않은 번호인 경우 하단 번호출력하지 않도록 수정
        visible: {
            if((1 == BtCoreCtrl.m_ncallState) && (1 == BtCoreCtrl.m_nActivatedCallPos) && (true == BtCoreCtrl.m_n3wayCallEnded)) {
                if("" != BtCoreCtrl.m_strPhoneName1) {
                    true
                } else {
                    false
                }
            } else {
                if("" != BtCoreCtrl.m_strPhoneName0) {
                    true
                } else {
                    false
                }
            }
        } 

        clip: true
        font.pointSize: 42
        elide: Text.ElideRight
        color: 30 == BtCoreCtrl.m_ncallState ? colorInfo.dimmedGrey : colorInfo.subTextGrey
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        font.family: stringInfo.fontFamilyRegular    //"HDR"
    }


    /* TIMERS */
    Timer {
        id: idCallEndBlinkTimer
        interval: 500
        running: false
        repeat: true

        onTriggered: {
            if(true == iqs_15My) {
                toggleBlink = false;
                idTimeText.opacity = 1;
                imgBtCallImage.opacity = 1;

                blinkCount = blinkCount + 1
                qml_debug("blinkCount" + blinkCount);

                if(3 < blinkCount) {
                    stopBlink();

                    //__IQS_15MY_ Call End Modify
                    if(1 == BtCoreCtrl.m_ncallState && false == BtCoreCtrl.m_bIsCallEndViewState) {
                        // 콜 종료 타이머 후 0으로 설정함
                        BtCoreCtrl.invokeCallStateChange(0);
                    }
                }
            } else {
                if(true == toggleBlink) {
                    toggleBlink = false;
                    idTimeText.opacity = 1;
                    imgBtCallImage.opacity = 1;
                } else {
                    toggleBlink = true;
                    idTimeText.opacity = 0;
                    imgBtCallImage.opacity = 0;
                }

                blinkCount = blinkCount + 1
                qml_debug("blinkCount" + blinkCount);

                if(5 < blinkCount) {
                    stopBlink();

                    if(1 == BtCoreCtrl.m_ncallState) {
                        // 콜 종료 타이머 후 0으로 설정함
                        BtCoreCtrl.invokeCallStateChange(0);
                    }
                }
           }
        }
    }
}
/* EOF */
