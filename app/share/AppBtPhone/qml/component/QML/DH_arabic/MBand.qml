/**
 * /QML/DH_arabic/MBand.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


FocusScope
{
    id: idMBand
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.titleAreaHeight


    // PROPERTIES
    property string tabBtnText: ""
    property string tabBtnText2: ""
    property string tabBtnText3: ""
    property string tabBtnText4: ""
    //DEPRECATED property string tabBtnText5: ""

    property string titleText: ""
    property string subTitleText: ""
    property string subBtnText: ""
    property string menuBtnText: ""
    property string signalText: ""
    property string reserveBtnText: ""

    property int tabBtnCount: 0
    property int listNumberCurrent: 0
    property int listNumberTotal: 0

    property bool tabBtnFlag: false
    property bool titleFavoriteImg: false
    property bool menuBtnFlag: false

    //DEPRECATED property bool tabBtnTextVisible1: true
    //DEPRECATED property bool tabBtnTextVisible2: true
    //DEPRECATED property bool tabBtnTextVisible3: true
    //DEPRECATED property bool tabBtnTextVisible4: true
    //DEPRECATED property bool tabBtnTextVisible5: true

//    property string tabBtnSelected1: ImagePath.imgFolderGeneral + "btn_title_normal_s.png"
//    property string tabBtnSelected2: ImagePath.imgFolderGeneral + "btn_title_normal_s.png"
//    property string tabBtnSelected3: ImagePath.imgFolderGeneral + "btn_title_normal_s.png"
//    property string tabBtnSelected4: ImagePath.imgFolderGeneral + "btn_title_normal_s.png"

    property string tabBtnNormal: ImagePath.imgFolderGeneral + "btn_title_normal_n.png"
    property string tabBtnPress: ImagePath.imgFolderGeneral + "btn_title_normal_p.png"
    property string tabBtnFocus: ImagePath.imgFolderGeneral + "btn_title_normal_f.png"
    property string tabBtnActive: ImagePath.imgFolderGeneral + "btn_title_normal_s.png"

    property string tabFgImage1: ((true == iqs_15My) ? (1 > BtCoreCtrl.m_ncallState || (false == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) : (2 > BtCoreCtrl.m_ncallState)) ? ImagePath.imgFolderGeneral + "ico_title_bt_dial.png" : ImagePath.imgFolderGeneral + "ico_title_bt_dial_d.png"
    property string tabFgImage2: ImagePath.imgFolderGeneral + "ico_title_bt_recent.png"
    property string tabFgImage3: ImagePath.imgFolderGeneral + "ico_title_bt_contact.png"
    property string tabFgImage4: ImagePath.imgFolderGeneral + "ico_title_bt_fav.png"

    // SIGNALS
    signal menuBtnClicked();
    signal backBtnClicked();

    signal tabBtn1Clicked();
    signal tabBtn2Clicked();
    signal tabBtn3Clicked();
    signal tabBtn4Clicked();

    // Function
    function focusSelected() {

    var top_screen = UIListener.invokeTopScreen();

    console.log("## [function]focusSelected top_screen : " + top_screen);
        switch(top_screen) {
            case "BtDialMain":          idLoaderDial.setFocus();            break;
            case "BtRecentCall":        idLoaderRecents.setFocus();         break;
            case "BtRecentDelete":      idLoaderRecentsDelete.setFocus();   break;
            case "BtContactMain":       idLoaderContacts.setFocus();        break;
            case "BtContactSearchMain": idLoaderContactsSearch.setFocus();  break;
            case "BtFavoriteMain":      idLoaderFavorite.setFocus();        break;

            case "BtInfoView": {
                if(false == gInfoViewFocus) {
                    idLoaderMainBand.forceActiveFocus();
                } else {
                    idLoaderInfoView.setFocus();
                }
                break;
            }

            default:
                console.log("# invalid focusSelected = " + top_screen);
                break;
        }
    }


    onMenuBtnFlagChanged: {
        /* 메뉴가 나타나면 메뉴에 포커스를 설정함(메뉴가 사라졌다 나타날때 포커스 사라짐 방지)
         */
        if(false == tabBtnFlag) {
            if(true == menuBtnFlag) {
                idMenuBtn.focus = true;
            } else {
                idBackBtn.focus = true;
            }
        }
    }

    Connections {
        target: idAppMain

        onSigSetSelectedBand: {
            if(selectedBand == tabBtnText) {
                idTabBtn1.focus = true
                idTabBtn2.focus = false
                idTabBtn3.focus = false
                idTabBtn4.focus = false
            } else if(selectedBand == tabBtnText2) {
                idTabBtn1.focus = false
                idTabBtn2.focus = true
                idTabBtn3.focus = false
                idTabBtn4.focus = false
            } else if(selectedBand == tabBtnText3) {
                idTabBtn1.focus = false
                idTabBtn2.focus = false
                idTabBtn3.focus = true
                idTabBtn4.focus = false
            } else if(selectedBand == tabBtnText4) {
                idTabBtn1.focus = false
                idTabBtn2.focus = false
                idTabBtn3.focus = false
                idTabBtn4.focus = true
            }
        }

        onClickedContactsCallView: {
            selectedBand = tabBtnText3
        }

//            if(selectedBand == tabBtnText) {
//                idTabBtn1.focus = true
//                idTabBtn2.focus = false
//                idTabBtn3.focus = false
//                idTabBtn4.focus = false
//            } else if(selectedBand == tabBtnText2) {
//                idTabBtn1.focus = false
//                idTabBtn2.focus = true
//                idTabBtn3.focus = false
//                idTabBtn4.focus = false
//            } else if(selectedBand == tabBtnText3) {
//                idTabBtn1.focus = false
//                idTabBtn2.focus = false
//                idTabBtn3.focus = true
//                idTabBtn4.focus = false
//            } else if(selectedBand == tabBtnText4) {
//                idTabBtn1.focus = false
//                idTabBtn2.focus = false
//                idTabBtn3.focus = false
//                idTabBtn4.focus = true
//            }
//        }
    }

    Component.onCompleted: {
        /*if(idTabBtn1.activeFocus) {
            idTabBtn1.bgImagePress = ""
            idTabBtn1.focus = true;
        } else if(idTabBtn2.activeFocus) {
            idTabBtn2.bgImagePress = ""
            idTabBtn2.focus = true;
        } else if(idTabBtn3.activeFocus) {
            idTabBtn3.bgImagePress = ""
            idTabBtn3.focus = true;
        } else if(idTabBtn4.activeFocus) {
            idTabBtn4.bgImagePress = ""
            idTabBtn4.focus = true;
        }*/
    }

    onVisibleChanged: {
//        if(true == idMBand.visible) {
//            if(selectedBand == tabBtnText) {
//                idTabBtn1.focus = true
//                idTabBtn2.focus = false
//                idTabBtn3.focus = false
//                idTabBtn4.focus = false
//            } else if(selectedBand == tabBtnText2) {
//                idTabBtn1.focus = false
//                idTabBtn2.focus = true
//                idTabBtn3.focus = false
//                idTabBtn4.focus = false
//            } else if(selectedBand == tabBtnText3) {
//                idTabBtn1.focus = false
//                idTabBtn2.focus = false
//                idTabBtn3.focus = true
//                idTabBtn4.focus = false
//            } else if(selectedBand == tabBtnText4) {
//                idTabBtn1.focus = false
//                idTabBtn2.focus = false
//                idTabBtn3.focus = false
//                idTabBtn4.focus = true
//            }
//        }
    }

    /* 밴드 배경 이미지 부분
     */
    Image {
        source: ImagePath.imgFolderGeneral + "bg_title.png"
        x: 0;
        y: 0;
        z: 0;
        Image { source: ImagePath.imgFolderGeneral + "line_title.png"; x:  594; visible: idTabBtn1.visible }
        Image { source: ImagePath.imgFolderGeneral + "line_title.png"; x:  764; visible: idTabBtn2.visible }
        Image { source: ImagePath.imgFolderGeneral + "line_title.png"; x:  934; visible: idTabBtn3.visible }
        Image { source: ImagePath.imgFolderGeneral + "line_title.png"; x: 1104; visible: idTabBtn4.visible }
    }

    /* 밴드 선택 이미지
     */
//    Image {
//        id: idTabCover
//        x: 0
//        y: 0;
//        width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight
//        source: idTabBtn1.active? tabBtnSelected1 : idTabBtn2.active? tabBtnSelected2 : idTabBtn3.active? tabBtnSelected3 : tabBtnSelected4
//        visible: tabBtnFlag
//    }

    /* 1번 버튼
     */
    MButton {
        id: idTabBtn1
        x: 1106
        y: 0
        buttonName: tabBtnText
        width: 170;
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnActive
        visible: (true == tabBtnFlag) && (1 == tabBtnCount || 2 == tabBtnCount || 3 == tabBtnCount || 4 == tabBtnCount)
        active: buttonName == selectedBand
        focus: buttonName == selectedBand//idTabBtn1.focus //(true == tabBtnFlag) && (selectedBand == tabBtnText) ? true : false
        mEnabled: ((true == iqs_15My) ? (1 > BtCoreCtrl.m_ncallState || (false == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) : (2 > BtCoreCtrl.m_ncallState)) ? true : false

        fgImage: tabFgImage1
        fgImageActive: tabFgImage1
        fgImageX: 50
        fgImageY: 105 - systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        onClickOrKeySelected: {
            if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
                if(buttonName == selectedBand) {
                    focusSelected();
                } else {
                    selectedBand = buttonName;
                    idMBand.forceActiveFocus();
                    tabBtn1Clicked();
                }
            }
        }

        onActiveFocusChanged: {
        }

        onWheelLeftKeyPressed: {
            if(tabBtnCount > 1) {
                idTabBtn2.focus = true;
                idTabBtn2.forceActiveFocus();
            } else {
                if(true == idMenuBtn.visible) {
                    idMenuBtn.focus = true;
                    idMenuBtn.forceActiveFocus();
                } else {
                    idBackBtn.focus = true;
                    idBackBtn.forceActiveFocus();
                }
            }
        }

        onBackKeyPressed: { backKeyHandler(); }
        onClickMenuKey: { idMenu.show(); }
    }

    /* 2번 버튼
     */
    MButton{
        id: idTabBtn2
        x: 936
        y: 0
        buttonName: tabBtnText2
        width: 170
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnActive
        visible: (true == tabBtnFlag) && (2 == tabBtnCount || 3 == tabBtnCount || 4 == tabBtnCount)
        active: buttonName == selectedBand
        focus: buttonName == selectedBand //idTabBtn2.focus //(true == tabBtnFlag) && (selectedBand == tabBtnText2) ? true : false

        fgImage: tabFgImage2
        fgImageActive: tabFgImage2
        fgImageX: 50
        fgImageY: 105 - systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        onClickOrKeySelected: {
            if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
                if(buttonName == selectedBand) {
                    focusSelected();
                } else {
                    selectedBand = buttonName
                    idMBand.forceActiveFocus();
                    tabBtn2Clicked();
                }
            }
        }
        onActiveFocusChanged: {
        }

        onWheelRightKeyPressed: {
            if(false == idTabBtn1.mEnabled) {
                idTabBtn2.focus = true
                idTabBtn2.forceActiveFocus();
            } else {
                idTabBtn1.focus = true
                idTabBtn1.forceActiveFocus();
            }
        }
        onWheelLeftKeyPressed: {
            if(tabBtnCount > 2) {
                idTabBtn3.focus = true;
                idTabBtn3.forceActiveFocus();
            } else {
                if(true == idMenuBtn.visible) {
                    idMenuBtn.focus = true;
                    idMenuBtn.forceActiveFocus();
                } else {
                    idBackBtn.focus = true;
                    idBackBtn.forceActiveFocus();
                }
            }
        }

        onBackKeyPressed: { backKeyHandler(); }
        onClickMenuKey: { idMenu.show(); }
    }

    /* 3번 버튼
     */
    MButton{
        id: idTabBtn3
        x: 766
        y: 0
        buttonName: tabBtnText3
        width: 170
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnActive
        visible: (true == tabBtnFlag) && (3 == tabBtnCount || 4 == tabBtnCount)
        active: buttonName == selectedBand
        focus: buttonName == selectedBand //idTabBtn3.focus //(true == tabBtnFlag) && (selectedBand == tabBtnText3) ? true : false

        fgImage: tabFgImage3
        fgImageActive: tabFgImage3
        fgImageX: 50
        fgImageY: 105 - systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        onClickOrKeySelected: {
            if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
                if(buttonName == selectedBand) {
                    focusSelected();
                } else {
                    selectedBand = buttonName;
                    idMBand.forceActiveFocus();
                    tabBtn3Clicked();
                }
            }
        }

        onActiveFocusChanged: {
        }

        onWheelRightKeyPressed: {
            idTabBtn2.focus = true;
            idTabBtn2.forceActiveFocus();
        }

        onWheelLeftKeyPressed: {
            if(tabBtnCount > 3) {
                idTabBtn4.focus = true;
                idTabBtn4.forceActiveFocus();
            } else {
                if(true == idMenuBtn.visible) {
                    idMenuBtn.focus = true;
                    idMenuBtn.forceActiveFocus();
                } else {
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus();
                }
            }
        }

        onBackKeyPressed: { backKeyHandler(); }
        onClickMenuKey: { idMenu.show(); }
    }

    /* 4번 버튼
     */
    MButton{
        id: idTabBtn4
        x: 596
        y: 0
        buttonName: tabBtnText4
        width: 170;
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnActive
        visible: (true == tabBtnFlag) && 4 == tabBtnCount
        active: buttonName == selectedBand
        focus: buttonName == selectedBand //idTabBtn4.focus //(true == tabBtnFlag) && (selectedBand == tabBtnText4) ? true : false

        fgImage: tabFgImage4
        fgImageActive: tabFgImage4
        fgImageX: 50
        fgImageY: 105 - systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        onClickOrKeySelected: {
            if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
                if(buttonName == selectedBand) {
                    focusSelected();
                } else {
                    selectedBand = buttonName;
                    idMBand.forceActiveFocus();
                    tabBtn4Clicked();
                }
            }
        }

        onActiveFocusChanged: {
        }

        onWheelRightKeyPressed: {
            idTabBtn3.focus = true;
            idTabBtn3.forceActiveFocus();
        }

        onWheelLeftKeyPressed: {
            if(true == idMenuBtn.visible) {
                idMenuBtn.focus = true;
                idMenuBtn.forceActiveFocus();
            } else {
                idBackBtn.focus = true;
                idBackBtn.forceActiveFocus();
            }
        }

        onBackKeyPressed: { backKeyHandler(); }
        onClickMenuKey: { idMenu.show(); }
    }

    /* 타이틀 텍스트
     */
    Text{
        id: txtTitle
        text: titleText
        x: 464
        y: 129 - systemInfo.statusBarHeight - 40 / 2
        width: 770
        height: 40
        font.pointSize: 40
        font.family: stringInfo.fontFamilyBold    //"HDB"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: (false == tabBtnFlag) ? true : false
    }

    /* 메뉴 옆에 있는 아이콘과 숫자 표시 부분
     */
    Item {
        x: idMenuBtn.visible == true ? 292 : 161
        y: 13
        width: 310
        height: 30
        visible: (titleFavoriteImg == true)

        Text {
            y: 8
            id: txtSignal
            text: signalText
            height: 30
            font.pointSize: 30
            font.family: stringInfo.fontFamilyBold    //"HDB"
            anchors.left: parent.left
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color:  colorInfo.brightGrey
        }

        Image {
            source: {
                if(true == titleFavoriteImg) {
                    if("BAND_FAVORITE" == selectedBand || "BAND_RECENT" == selectedBand) {
                        ImagePath.imgFolderBt_phone + "ico_call.png"
                    } else {
                        ImagePath.imgFolderBt_phone + "ico_menu.png"
                    }
                } else {
                    ""
                }
            }

            y: 0
            width: 44
            height: 42
            visible: (titleFavoriteImg == true)
            anchors.left: txtSignal.right
            anchors.rightMargin: 1
        }
    }

    MButton {
        id: idMenuBtn
        x: 141
        y: 0
        width: 141
        height: 72

        focus: (tabBtnFlag == false) && (menuBtnFlag == true) ? true : false
        visible: (menuBtnFlag == true) ? true : false

        bgImage: ImagePath.imgFolderGeneral + "btn_title_sub_n.png"
        bgImagePress: ImagePath.imgFolderGeneral + "btn_title_sub_p.png"
        bgImageFocus: ImagePath.imgFolderGeneral + "btn_title_sub_f.png"

        onClickOrKeySelected: {
            if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
                menuBtnClicked();
                if("" == selectedBand) {
                    idMenuBtn.focus = true
                } else {
                    /*if(selectedBand == tabBtnText) {
                        idTabBtn1.focus = true
                    } else if(selectedBand == tabBtnText2) {
                        idTabBtn2.focus = true
                    } else if(selectedBand == tabBtnText3) {
                        idTabBtn3.focus = true
                    } else if(selectedBand == tabBtnText4) {
                        idTabBtn4.focus = true
                    }*/
                }
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
            if(0 == tabBtnCount) {
                idBackBtn.focus = true;
                idBackBtn.forceActiveFocus();
            } else if(1 == tabBtnCount) {
                idTabBtn1.focus = true;
                idTabBtn1.forceActiveFocus();
            } else if(2 == tabBtnCount) {
                idTabBtn2.focus = true;
                idTabBtn2.forceActiveFocus();
            } else if(3 == tabBtnCount) {
                idTabBtn3.focus = true;
                idTabBtn3.forceActiveFocus();
            } else if(4 == tabBtnCount) {
                idTabBtn4.focus = true;
                idTabBtn4.forceActiveFocus();
            }
        }

        onWheelLeftKeyPressed: {
            idBackBtn.focus = true;
            idBackBtn.forceActiveFocus();
        }

        onBackKeyPressed: { backKeyHandler(); }
        onClickMenuKey: { idMenu.show(); }
    }

    DDImageButton {
        id: idBackBtn
        x: 3
        y: 0
        width: 141
        height: 72
        focus: (false == tabBtnFlag) && (false == menuBtnFlag) ? true : false

        bgImage: ImagePath.imgFolderGeneral + "btn_title_back_n.png"
        bgImagePress: ImagePath.imgFolderGeneral + "btn_title_back_p.png"
        bgImageFocus: ImagePath.imgFolderGeneral + "btn_title_back_f.png"

        onClickOrKeySelected: {
            if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
                backBtnClicked();
            }
        }

        onWheelRightKeyPressed: {
            if(idMenuBtn.visible) {
                idMenuBtn.focus = true;
                idMenuBtn.forceActiveFocus();
            } else {
                if(4 == tabBtnCount) {
                    idTabBtn4.focus = true;
                    idTabBtn4.forceActiveFocus();
                } else if(2 == tabBtnCount) {
                    idTabBtn2.focus = true
                    idTabBtn2.forceActiveFocus();
                } else if(3 == tabBtnCount) {
                    idTabBtn3.focus = true;
                    idTabBtn3.forceActiveFocus();
                } else if(1 == tabBtnCount) {
                    idTabBtn1.focus = true;
                    idTabBtn1.forceActiveFocus();
                }
            }
        }

        onWheelLeftKeyPressed: {
            /*if(true == idTabBtn1.visible) {
                if(false == idTabBtn1.mEnabled) {
                    idTabBtn2.focus = true;
                    idTabBtn2.forceActiveFocus();
                } else {
                    idTabBtn1.focus = true;
                    idTabBtn1.forceActiveFocus();
                }
            } else if(true == idMenuBtn.visible) {
                idMenuBtn.focus = true;
                idMenuBtn.forceActiveFocus();
            } else {
                idBackBtn.focus = true;
                idBackBtn.forceActiveFocus();
            }8월 16일 UX 손민지 주임 수정 사항 Looping 제거*/
        }

        onBackKeyPressed: { backKeyHandler(); }
        onClickMenuKey: { idMenu.show(); }
    }

    Image { source: ImagePath.imgFolderGeneral + "line_tab_01_s.png"; z: 1; visible: selectedBand == tabBtnText}//idTabBtn1.visible }
    Image { source: ImagePath.imgFolderGeneral + "line_tab_02_s.png"; z: 1; visible: selectedBand == tabBtnText2}//idTabBtn2.visible }
    Image { source: ImagePath.imgFolderGeneral + "line_tab_03_s.png"; z: 1; visible: selectedBand == tabBtnText3}//idTabBtn3.visible }
    Image { source: ImagePath.imgFolderGeneral + "line_tab_04_s.png"; z: 1; visible: selectedBand == tabBtnText4}//idTabBtn4.visible }
}
/* EOF */
