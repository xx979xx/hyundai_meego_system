/**
 * BtFavoriteOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtRecentCallList
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    //ListModel이 바뀔때의 type을 저장하는 변수
    property int modelchangedType: 0
    //Flicking 동작 중인지 판단하는 변수
    property bool doingFlicking: false

    /* INTERNAL functions */
    /* 최근 통화 목록 텝 설정 */
    function switchCallHistory(type) {
        /** select_recent_call_type
         *  1) all: 5
         *  2) outgoing: 1
         *  3) incoming: 2
         *  4) missed: 3
         */

        modelchangedType = type

        if(false == doingFlicking) {
            recentCallList.currentIndex = 0;
        }

        if(true == recentCallType.visible) {
            if(type == select_recent_call_type) {
                // do nothing
                switch(type){
                case 1:
                /* 발신 통화 */
                    select_recent_call_type = 1;
                    recentCallList.model = OutgoingCallHistoryList;
                    recentCallType1.focus = false;
                    recentCallType2.focus = true;
                    recentCallType3.focus = false;
                    break;

                case 3:
                /* 부재 중 통화 */
                    select_recent_call_type = 3;
                    recentCallList.model = MissedCallHistoryList;
                    recentCallType1.focus = false;
                    recentCallType2.focus = false;
                    recentCallType3.focus = true;
                    break;

                case 2:
                default:
                /* 수신 통화 */
                    select_recent_call_type = 2;
                    recentCallList.model = IncomingCallHistoryList;
                    recentCallType1.focus = true;
                    recentCallType2.focus = false;
                    recentCallType3.focus = false;
                    break;
                    return;
                }
            }

            switch(type) {
            case 1:
                select_recent_call_type = 1;
                recentCallList.model = OutgoingCallHistoryList;
                recentCallType2.forceActiveFocus();
                break;

            case 3:
                select_recent_call_type = 3;
                recentCallList.model = MissedCallHistoryList;
                recentCallType3.forceActiveFocus();
                break;

            case 2:
            default:
                select_recent_call_type = 2;
                recentCallList.model = IncomingCallHistoryList;
                recentCallType1.forceActiveFocus();
                break;
            }
        } else {
            if(type == select_recent_call_type) {
                // do nothing
                switch(type) {
                case 1:
                    select_recent_call_type = 1;
                    recentCallList.model = OutgoingCallHistoryList;
                    recentCallType1_4.focus = false;
                    recentCallType3_4.focus = false;
                    recentCallType4_4.focus = false;
                    recentCallType2_4.focus = true;
                    break;

                case 2:
                    select_recent_call_type = 2;
                    recentCallList.model = IncomingCallHistoryList;
                    recentCallType1_4.focus = false;
                    recentCallType2_4.focus = false;
                    recentCallType4_4.focus = false;
                    recentCallType3_4.focus = true;
                    break;

                case 3:
                    select_recent_call_type = 3;
                    recentCallList.model = MissedCallHistoryList;
                    recentCallType1_4.focus = false;
                    recentCallType2_4.focus = false;
                    recentCallType3_4.focus = false;
                    recentCallType4_4.focus = true;
                    break;

                default:
                case 5:
                    select_recent_call_type = 5;
                    recentCallList.model = MixedCallHistoryList;
                    recentCallType2_4.focus = false;
                    recentCallType3_4.focus = false;
                    recentCallType4_4.focus = false;
                    recentCallType1_4.focus = true;
                    break;
                }
            }

            switch(type) {
            case 1: /* Dial */
                select_recent_call_type = 1;
                recentCallList.model = OutgoingCallHistoryList;
                recentCallType2_4.forceActiveFocus();
                break;

            case 2: /* Received */
                select_recent_call_type = 2;
                recentCallList.model = IncomingCallHistoryList;
                recentCallType3_4.forceActiveFocus();
                break;

            case 3: /* Missed */
                select_recent_call_type = 3;
                recentCallType4_4.forceActiveFocus();
                recentCallList.model = MissedCallHistoryList;
                break;

            case 5:
            default: /* All*/
                select_recent_call_type = 5;
                recentCallList.model = MixedCallHistoryList;
                recentCallType1_4.forceActiveFocus();
                break;
            }
        }

        // Update count
        recent_list_count = recentCallList.count;

        /* 최근통화 목록 검색 동작 */
        BtCoreCtrl.invokeTrackerGetCallHistoryNames(select_recent_call_type);
    }

    /* EVENT handlers */
    onVisibleChanged: {
        if(true == recentCallType.visible) {
            select_recent_call_type = 2
        } else {
            select_recent_call_type = 5
        }

        if(true == idBtRecentCallList.visible) {
            switchCallHistory(select_recent_call_type);

            if(true == recentCallType.visible) {
                recentCallType1.forceActiveFocus();
            } else {
                recentCallType1_4.forceActiveFocus();
            }
        } else {
            recentCallList.currentIndex = 0
            idDownScrollTimer.stop();
            idUpScrollTimer.stop();
        }
    }

    Component.onCompleted: {
        if(true == idBtRecentCallList.visible) {
            if(true == recentCallType.visible) {
                select_recent_call_type = 2
            } else {
                select_recent_call_type = 5
            }

            switchCallHistory(select_recent_call_type);

            if(true == recentCallType.visible) {
                recentCallType1.forceActiveFocus();
            } else {
                recentCallType1_4.forceActiveFocus();
            }
        }
    }

    onClickMenuKey: {
        idMenu.show();
    }

    onBackKeyPressed: {
            if(true == gContactFromCall) {
                MOp.reshowCallView(8502);

            } else {
               popScreen(8501);
            }
    }

    /* CONNECTIONS */
    Connections {
        target: idAppMain

        onDeviceChangeRecentCallReset: {
            /* 디바이스 연결 변경시 최근통화 화면 수신통화로 이동되도록 설정함 */
            if(true == recentCallType.visible) {
                switchCallHistory(2);
            } else {
                switchCallHistory(4);
            }
        }

        onResetFocusCallhistory: {
            /* 리스트 초기화 */
            recentCallList.currentIndex = 0;
        }

        onDeleteBackKeyPress: {
            /* 삭제 화면 이 후 포커스 위치 리스트로 변경 */
            if(recentCallList.count > 0) {
                recentCallList.currentIndex = 0
                recentCallList.forceActiveFocus()
            } else {
                if(true == recentCallType.visible) {
                    recentCallType1.forceActiveFocus();
                } else {
                    recentCallType1_4.forceActiveFocus();
                }
            }
        }

        onMenuOffFocus: {
            /* Menu off 동작 시 focus */
            if(true == idBtRecentCallList.visible) {
                if(recentCallList.count > 0) {
                    recentCallList.forceActiveFocus();
                } else {
                    if(true == recentCallType.visible) {
                        recentCallType1.forceActiveFocus();
                    } else {
                        recentCallType_4.forceActiveFocus();
                    }
                    switchCallHistory(select_recent_call_type);
                }
            }
        }
    }

    /* WIDGETS */
    Item {
        id: recentCallType
        x: 0
        y: 0
        width: 212
        height: 555
        focus: true
        visible: false == iqs_15My

        Image {
            anchors.fill: parent
            source: ImagePath.imgFolderBt_phone + "bg_recent_tab.png"
        }

        // Incoming
        MComp.MSubButton {
            id: recentCallType1
            x: 0
            y: 0
            width: 203
            height: 186
            active: (select_recent_call_type == 2) ? true : false;
            focus: (select_recent_call_type == 2) ? true : false;

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderBt_phone + "recent_tab_01_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "recent_tab_01_f.png"

            firstText: stringInfo.str_Receivecall
            firstTextX: 5
            firstTextY: 62
            firstTextWidth: 170
            firstTextSize: 32
            firstTextHeight: 32
            firstTextColor: colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue
            firstTextStyle: {
                if (select_recent_call_type == 2) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            firstTextAlies: "Center"

            secondText: "(" + BtCoreCtrl.m_incomingCallHistoryCount + ")"
            secondTextX: 5
            secondTextY: 112
            secondTextWidth: 170
            secondTextSize: 32
            secondTextHeight: 32
            secondTextColor: colorInfo.brightGrey
            secondTextPressColor: colorInfo.brightGrey
            secondTextSelectedColor: colorInfo.bandBlue
            secondTextStyle: {
                if (select_recent_call_type == 2) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            secondTextAlies: "Center"
            secondTextFocusVisible: (true == recentCallType1.activeFocus) ? true : false

            onClickOrKeySelected: {
                recentCallType1.focus = true;

                // Select incoming call history
                switchCallHistory(2);

                if(0 == recentCallList.count) {
                    recentCallType1.forceActiveFocus();
                } else {
                    recentCallList.forceActiveFocus();
                }
            }

            KeyNavigation.right: (0 == recentCallList.count) ? recentCallType1 : recentCallList

            /*onWheelLeftKeyPressed:   recentCallType3.forceActiveFocus();8월 16일 UX 손민지 주임 수정 사항 Looping 제거*/
            onWheelRightKeyPressed:  recentCallType2.forceActiveFocus();
        }

        // Outgoing
        MComp.MSubButton {
            id: recentCallType2
            x: 0
            y: 185
            width: 203
            height: 186
            active: (select_recent_call_type == 1) ? true : false;
            focus: (select_recent_call_type == 1) ? true : false;

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderBt_phone + "recent_tab_02_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "recent_tab_02_f.png"

            firstText: stringInfo.str_Dialcall
            firstTextX: 5
            firstTextY: 62
            firstTextWidth: 170
            firstTextSize: 32
            firstTextHeight: 32
            firstTextColor: colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue
            firstTextStyle: {
                if (select_recent_call_type == 1) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            firstTextAlies: "Center"

            secondText: "(" + BtCoreCtrl.m_outgoingCallHistoryCount + ")"
            secondTextX: 15
            secondTextY: 112    //78 - 16 + 50
            secondTextWidth: 160
            secondTextSize: 32
            secondTextHeight: 32
            secondTextColor: colorInfo.brightGrey
            secondTextPressColor: colorInfo.brightGrey
            secondTextSelectedColor: colorInfo.bandBlue
            secondTextAlies: "Center"
            secondTextStyle: {
                if (select_recent_call_type == 1) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            secondTextFocusVisible: (true == recentCallType2.activeFocus) ? true : false

            onClickOrKeySelected: {
                recentCallType2.focus = true;

                // Select outgoing call history
                switchCallHistory(1);

                if(0 == recentCallList.count) {
                    recentCallType2.forceActiveFocus();
                } else {
                    recentCallList.forceActiveFocus();
                }
            }

            KeyNavigation.right: (0 == recentCallList.count) ? recentCallType2 : recentCallList

            onWheelLeftKeyPressed:   recentCallType1.forceActiveFocus();
            onWheelRightKeyPressed:  recentCallType3.forceActiveFocus();
        }

        // Missed
        MComp.MSubButton {
            id: recentCallType3
            x: 0
            y: 370
            width: 203
            height: 186
            active: (select_recent_call_type == 3) ? true : false;
            focus: (select_recent_call_type == 3) ? true : false;

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderBt_phone + "recent_tab_03_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "recent_tab_03_f.png"

            firstText: stringInfo.str_Missedcall
            firstTextX: 5
            firstTextY: 62
            firstTextWidth: 170
            firstTextSize: 32
            firstTextHeight: 32
            firstTextColor: colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue
            firstTextStyle: {
                if (select_recent_call_type == 3) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular
                }
            }
            //stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"

            secondText: "(" + BtCoreCtrl.m_missedCallHistoryCount + ")"
            secondTextX: 15
            secondTextY: 112
            secondTextWidth: 160
            secondTextSize: 32
            secondTextHeight: 32
            secondTextColor: colorInfo.brightGrey
            secondTextPressColor: colorInfo.brightGrey
            secondTextSelectedColor: colorInfo.bandBlue
            secondTextAlies: "Center"
            secondTextStyle: {
                if (select_recent_call_type == 3) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular
                }
            }

            secondTextFocusVisible: (true == recentCallType3.activeFocus) ? true : false

            onClickOrKeySelected: {
                recentCallType3.focus = true;

                // Select missed call history
                switchCallHistory(3);

                if(0 == recentCallList.count) {
                    recentCallType3.forceActiveFocus();
                } else {
                    recentCallList.forceActiveFocus();
                }
            }

            KeyNavigation.right: (0 == recentCallList.count) ? recentCallType3 : recentCallList

            onWheelLeftKeyPressed:   recentCallType2.forceActiveFocus();
            /*onWheelRightKeyPressed:  recentCallType1.forceActiveFocus();8월 16일 UX 손민지 주임 수정 사항 Looping 제거*/
        }
    }

    Item {
        id: recentCallType_4
        x: 0
        y: 0
        width: 212
        height: 555
        focus: false
        visible: true == iqs_15My

        Image {
            anchors.fill: parent
            source: ImagePath.imgFolderBt_phone + "bg_recent_iqs_tab.png"
        }

        /* All */
        MComp.MSubButton2 {
            id: recentCallType1_4
            x: 0
            y: 0
            width: 203
            height: 142
            active: (select_recent_call_type == 5) ? true : false;
            focus: (select_recent_call_type == 5) ? true : false;

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderBt_phone + "recent_iqs_tab_01_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "recent_iqs_tab_01_f.png"

            firstText: stringInfo.str_Bt_All
            firstTextX: 5
            firstTextY: 55 - 24
            firstTextWidth: 160
            firstTextSize: 32
            firstTextHeight: 32
            firstTextColor: colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue
            firstTextStyle: {
                if (select_recent_call_type == 5) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            firstTextAlies: "Center"

            //secondText: "(" + BtCoreCtrl.m_outgoingCallHistoryCount + ")"
            secondText: "(" + BtCoreCtrl.m_mixedRecentsCount + ")"
            secondTextX: 5
            secondTextY: 112
            secondTextWidth: 160
            secondTextSize: 32
            secondTextHeight: 32
            secondTextColor: colorInfo.brightGrey
            secondTextPressColor: colorInfo.brightGrey
            secondTextSelectedColor: colorInfo.bandBlue
            secondTextStyle: {
                if (select_recent_call_type == 5) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            secondTextAlies: "Center"
            secondTextFocusVisible: (true == recentCallType1_4.activeFocus) ? true : false

            onClickOrKeySelected: {
                recentCallType1_4.focus = true;

                // Select mxied call history
                switchCallHistory(5);

                if(0 == recentCallList.count) {
                    recentCallType1_4.forceActiveFocus();
                } else {
                    recentCallList.forceActiveFocus();
                }
            }

            KeyNavigation.right: (0 == recentCallList.count) ? recentCallType1_4 : recentCallList

            /*onWheelLeftKeyPressed:   recentCallType3.forceActiveFocus();8월 16일 UX 손민지 주임 수정 사항 Looping 제거*/
            onWheelRightKeyPressed:  recentCallType2_4.forceActiveFocus();
        }

        /* Dial */
        MComp.MSubButton2 {
            id: recentCallType2_4
            x: 0
            y: 137
            width: 203
            height: 143
            active: (select_recent_call_type == 1) ? true : false;
            focus: (select_recent_call_type == 1) ? true : false;

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderBt_phone + "recent_iqs_tab_02_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "recent_iqs_tab_02_f.png"

            firstText: stringInfo.str_Dialcall
            firstTextX: 5
            firstTextY: 55 - 16
            firstTextWidth: 160
            firstTextSize: 31
            firstTextHeight: 31
            firstTextColor: colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue
            firstTextStyle: {
                if (select_recent_call_type == 1) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            firstTextAlies: "Center"

            secondText: "(" + BtCoreCtrl.m_outgoingCallHistoryCount + ")"
            secondTextX: 5
            secondTextY: 112
            secondTextWidth: 160
            secondTextSize: 32
            secondTextHeight: 32
            secondTextColor: colorInfo.brightGrey
            secondTextPressColor: colorInfo.brightGrey
            secondTextSelectedColor: colorInfo.bandBlue
            secondTextStyle: {
                if (select_recent_call_type == 1) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            secondTextAlies: "Center"
            secondTextFocusVisible: (true == recentCallType2_4.activeFocus) ? true : false

            onClickOrKeySelected: {
                recentCallType2_4.focus = true;

                // Select incoming call history
                switchCallHistory(1);

                if(0 == recentCallList.count) {
                    recentCallType2_4.forceActiveFocus();
                } else {
                    recentCallList.forceActiveFocus();
                }
            }

            KeyNavigation.right: (0 == recentCallList.count) ? recentCallType2_4 : recentCallList

            onWheelLeftKeyPressed:   recentCallType1_4.forceActiveFocus(); //8월 16일 UX 손민지 주임 수정 사항 Looping 제거
            onWheelRightKeyPressed:  recentCallType3_4.forceActiveFocus();
        }

        /* Received */
        MComp.MSubButton2 {
            id: recentCallType3_4
            x: 0
            y: 137 + 138
            width: 203
            height: 143
            active: (select_recent_call_type == 2) ? true : false;
            focus: (select_recent_call_type == 2) ? true : false;

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderBt_phone + "recent_iqs_tab_03_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "recent_iqs_tab_03_f.png"

            firstText: stringInfo.str_Receivecall
            firstTextX: 5
            firstTextY: 55 - 16
            firstTextWidth: 160
            firstTextSize: 32
            firstTextHeight: 32
            firstTextColor: colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue
            firstTextStyle: {
                if (select_recent_call_type == 2) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            firstTextAlies: "Center"

            secondText: "(" + BtCoreCtrl.m_incomingCallHistoryCount + ")"
            secondTextX: 15
            secondTextY: 112
            secondTextWidth: 160
            secondTextSize: 32
            secondTextHeight: 32
            secondTextColor: colorInfo.brightGrey
            secondTextPressColor: colorInfo.brightGrey
            secondTextSelectedColor: colorInfo.bandBlue
            secondTextAlies: "Center"
            secondTextStyle: {
                if (select_recent_call_type == 2) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular //"HDR"
                }
            }
            secondTextFocusVisible: (true == recentCallType3_4.activeFocus) ? true : false

            onClickOrKeySelected: {
                recentCallType3_4.focus = true;

                // Select outgoing call history
                switchCallHistory(2);

                if(0 == recentCallList.count) {
                    recentCallType3_4.forceActiveFocus();
                } else {
                    recentCallList.forceActiveFocus();
                }
            }

            KeyNavigation.right: (0 == recentCallList.count) ? recentCallType3_4 : recentCallList

            onWheelLeftKeyPressed:   recentCallType2_4.forceActiveFocus();
            onWheelRightKeyPressed:  recentCallType4_4.forceActiveFocus();
        }

        // Missed
        MComp.MSubButton2 {
            id: recentCallType4_4
            x: 0
            y: 137 + 138 + 138
            width: 203
            height: 143
            active: (select_recent_call_type == 3) ? true : false;
            focus: (select_recent_call_type == 3) ? true : false;

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderBt_phone + "recent_iqs_tab_04_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "recent_iqs_tab_04_f.png"

            firstText: stringInfo.str_Missedcall
            firstTextX: 5
            firstTextY: 55 - 16
            firstTextWidth: 160
            firstTextSize: 32
            firstTextHeight: 32
            firstTextColor: colorInfo.brightGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.bandBlue
            firstTextStyle: {
                if (select_recent_call_type == 3) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular
                }
            }
            //stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"

            secondText: "(" + BtCoreCtrl.m_missedCallHistoryCount + ")"
            secondTextX: 15
            secondTextY: 112
            secondTextWidth: 160
            secondTextSize: 32
            secondTextHeight: 32
            secondTextColor: colorInfo.brightGrey
            secondTextPressColor: colorInfo.brightGrey
            secondTextSelectedColor: colorInfo.bandBlue
            secondTextAlies: "Center"
            secondTextStyle: {
                if (select_recent_call_type == 3) {
                    stringInfo.fontFamilyBold    //"HDB"
                } else {
                    stringInfo.fontFamilyRegular
                }
            }

            secondTextFocusVisible: (true == recentCallType4_4.activeFocus) ? true : false

            onClickOrKeySelected: {
                recentCallType4_4.focus = true;

                // Select missed call history
                switchCallHistory(3);

                if(0 == recentCallList.count) {
                    recentCallType4_4.forceActiveFocus();
                } else {
                    recentCallList.forceActiveFocus();
                }
            }

            KeyNavigation.right: (0 == recentCallList.count) ? recentCallType4_4 : recentCallList

            onWheelLeftKeyPressed:   recentCallType3_4.forceActiveFocus();
            /*onWheelRightKeyPressed:  recentCallType1.forceActiveFocus();8월 16일 UX 손민지 주임 수정 사항 Looping 제거*/
        }
    }

    MComp.DDListView {
        id: recentCallList
        x: 212
        width: 1077
        height: 540
        //model: IncomingCallHistoryList
        model: true == recentCallType.visible ? IncomingCallHistoryList : MixedCallHistoryList

        onActiveFocusChanged: {
            if(true == recentCallList.activeFocus) {
                MOp.returnFocus();
            } else {
                recentCallList.stopScroll();
                longPressed = false;
            }
        }

        delegate: BtRecentDelegate {
            onWheelLeftKeyPressed: {
                if(false == recentCallList.flicking && false == recentCallList.moving) {
                    var startIndex = recentCallList.getStartIndex(recentCallList.contentY);

                    if(true == recentCallList.currentItem.hasInfoButton) {
                        /* 항목 내부에 상세정보 버튼이 존재 */
                        if(true == recentCallList.currentItem.focusInfoButton) {
                            /* 상세정보 버튼에 포커스가 있는 경우 */
                            recentCallList.currentItem.focusInfoButton = false
                        } else {
                            /* 왼쪽 리스트에 포커스가 있는 경우 */
                            if(index > 0) {
                                if(startIndex == recentCallList.currentIndex) {
                                    /* 페이지 변경 시 포커스 최하단으로 전달 부분 */
                                    recentCallList.positionViewAtIndex(recentCallList.currentIndex - 1, ListView.End);
                                }

                                /* [주의] 휠동작 시 CurrentIndex를 먼저 이동 시키고 내부 버튼 동작 확인 */
                                recentCallList.decrementCurrentIndex();

                                if(true == recentCallList.currentItem.hasInfoButton) {
                                    recentCallList.currentItem.focusInfoButton = true
                                } else {
                                    recentCallList.currentItem.focusInfoButton = false
                                }
                            } else {
                                if(6 < recentCallList.count) {
                                    recentCallList.currentIndex = recentCallList.count - 1;
                                    if(true == recentCallList.currentItem.hasInfoButton) {
                                        recentCallList.currentItem.focusInfoButton = true
                                    } else {
                                        recentCallList.currentItem.focusInfoButton = false
                                    }
                                }
                            }
                        }
                    } else {
                        /* 항목 내부에 상세 버튼이 없음 */
                        if(index > 0) {
                            if(startIndex == recentCallList.currentIndex) {
                                recentCallList.positionViewAtIndex(recentCallList.currentIndex - 1, ListView.End);
                            }
                            recentCallList.decrementCurrentIndex();
                            if(true == recentCallList.currentItem.hasInfoButton) {
                                recentCallList.currentItem.focusInfoButton = true
                            } else {
                                recentCallList.currentItem.focusInfoButton = false
                            }
                        } else {
                            // 리스트가 하나의 화면에 표시 되면 루핑 되지 않도록 수정(HMC)
                            if(6 < recentCallList.count) {
                                recentCallList.currentIndex = recentCallList.count - 1;

                                if(true == recentCallList.currentItem.hasInfoButton) {
                                    recentCallList.currentItem.focusInfoButton = true
                                } else {
                                    recentCallList.currentItem.focusInfoButton = false
                                }
                            } else {
                                console.log("## Stop looping recentCallList.count = " + recentCallList.count)
                            }
                        }
                    }
                }
            }

            onWheelRightKeyPressed: {
                if(false == recentCallList.flicking && false == recentCallList.moving) {
                    var endIndex = recentCallList.getEndIndex(recentCallList.contentY);

                    if(true == recentCallList.currentItem.hasInfoButton) {
                        if(true == recentCallList.currentItem.focusInfoButton) {
                            if(index < recentCallList.count - 1) {
                                recentCallList.currentItem.focusInfoButton = false

                                if(endIndex == recentCallList.currentIndex) {
                                    recentCallList.positionViewAtIndex(recentCallList.currentIndex + 1, ListView.Beginning);
                                }

                                recentCallList.incrementCurrentIndex();
                            } else {
                                if(6 < recentCallList.count) {
                                    recentCallList.currentItem.focusInfoButton = false
                                    recentCallList.currentIndex = 0;
                                } else {
                                    console.log("## Stop looping recentCallList.count = " + recentCallList.count)
                                }
                            }
                        } else {
                            recentCallList.currentItem.focusInfoButton = true
                        }
                    } else {
                        if(index < recentCallList.count - 1) {

                            if(endIndex == recentCallList.currentIndex) {
                                recentCallList.positionViewAtIndex(recentCallList.currentIndex + 1, ListView.Beginning);
                            }

                            recentCallList.incrementCurrentIndex();
                        } else {
                            // 리스트가 하나의 화면에 표시 되면 루핑 되지 않도록 수정(HMC)
                            if(6 < recentCallList.count) {
                                recentCallList.currentIndex = 0;
                            } else {
                                console.log("## Stop looping recentCallList.count = " + recentCallList.count)
                            }
                        }
                    }
                }
            }

            Keys.onPressed: {
                /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                 * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                 */
                if(Qt.Key_Down == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        recentCallList.longPressed = true;

                        if(recentCallList.currentIndex < recentCallList.count - 1) {
                            // Propagate to ListView
                            recentCallList.longPressed = true;
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때
                            event.accepted = true;
                        }
                    } else {
                        // Short pressed
                        event.accepted = true;
                    }
                } else if(Qt.Key_Up == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        recentCallList.longPressed = true;

                        if(0 < recentCallList.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때
                            event.accepted = true;
                        }
                    } else {
                        // Short pressed
                        recentCallList.longPressed = false
                        event.accepted = true;
                    }
                }
            }

            Keys.onReleased: {
                if(Qt.Key_Down == event.key) {
                    if(true == recentCallList.longPressed) {
                        if(recentCallList.currentIndex < recentCallList.count - 1) {
                            // Propagate to ListView
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            recentCallList.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "ListView"
                        recentCallList.forceActiveFocus();
                        event.accepted = true;
                    }
                } else if(Qt.Key_Up == event.key) {
                    if(true == recentCallList.longPressed) {
                        if(0 < recentCallList.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            recentCallList.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        // Set focus to "Search Button"
                        idLoaderMainBand.forceActiveFocus();
                        event.accepted = true;
                    }
                }
                recentCallList.stopScroll();
            }
        }

        onMovementStarted: {
            doingFlicking = true
        }

        onMovementEnded: {
            doingFlicking = false
        }

        onModelChanged: {
            idRecentCallListScroll.heightRatio = height / contentHeight;
            /* ITS 242552 최근 통화 목록 임의의 탭에서 Flicking 동작 중 다른 탭으로 전환 시, 포커스 사라지는 이슈
             * ListModel이 바뀌는 시점에 Flicking 중이라면 인덱스와 포커스 정리 함수 호출
             */
            if(false == doingFlicking) {
                recentCallList.currentIndex = 0;
                switchCallHistory(modelchangedType);
            }
        }

        onCountChanged: {
            if(5 == modelchangedType) {
                if(150 >= recentCallList.count) {
                    recentCallList.currentIndex = 0;
                }
            } else {
                if(50 >= recentCallList.count) {
                    recentCallList.currentIndex = 0;
                }
            }
            recent_list_count = recentCallList.count
            idRecentCallListScroll.heightRatio = height / contentHeight;
            MOp.returnFocus()
        }

        orientation: ListView.Vertical

        KeyNavigation.left : {
            if(5 == select_recent_call_type) {
                if(true == recentCallType_4.visible) {
                    recentCallType1_4
                } else {
                    recentCallType1
                }
            } else if(2 == select_recent_call_type) {
                if(true == recentCallType_4.visible) {
                    recentCallType3_4
                } else {
                    recentCallType1
                }
            } else if(1 == select_recent_call_type) {
                if(true == recentCallType_4.visible) {
                    recentCallType2_4
                } else {
                    recentCallType2
                }
            } else {
                if(true == recentCallType_4.visible) {
                    recentCallType4_4
                } else {
                    recentCallType3
                }
            }
        }
    }

    /* 최근통화목록이 없는 경우 표시되는 Text */
    Item {
        id:no_recent_call_List
        x: 212
        width: systemInfo.lcdWidth
        height: 780
        visible: (recentCallList.count == 0) ? true : false
        clip: true

        Text {
            text: {
                if(5 == select_recent_call_type) {
                    stringInfo.str_No_Callhistory_Recent
                } else if(2 == select_recent_call_type) {
                    stringInfo.str_Recent_Incoming
                } else if (1 == select_recent_call_type) {
                    stringInfo.str_Recent_Outgoing
                } else {
                    stringInfo.str_Recent_Missed
                }
            }

            y: 255
            width: systemInfo.lcdWidth - 212
            height: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            font.pointSize: 40
            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea {
            anchors.fill: parent
            beepEnabled: false
        }
    }

    /* 최근 통화 목록 Scroll
     */
    MComp.MScroll {
        id: idRecentCallListScroll
        x: 1257
        y: 199 - systemInfo.headlineHeight
        height: 476
        width: 14
        visible: (6 < recent_list_count) ? true : false;
        scrollArea: recentCallList
    }

}
    /* EOF */
