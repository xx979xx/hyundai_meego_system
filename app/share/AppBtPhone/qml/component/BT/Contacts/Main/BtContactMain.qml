/**
 * /BT/Contacts/Main/BtContactMain.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent {
    id: idBtContactMainScreen
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    /* PROPERTIES */
    property int fontSize : 50


    /* SIGNALS */
    signal scrollIndexChange(int popupIndex);
    signal dragQuickScroll();


    /* INTERNAL functions */
    function backKeyHandler() {
        /* [주의] 유사한 코드가 MainBand, Contact에 존재함
         */
        if("" == favoriteAdd) {
            /* 전화번호부로 진입 된 상태 Back 동작 */
            console.log("# non-favrotite mode");

            if(true == gContactFromCall) {
                MOp.reshowCallView(8003);
            } else {
                popScreen(267);
            }
        } else {
            /* 즐겨찾기 모드에서 진입 된 상태 Back 동작 */
            console.log("# favorite mode");
            selectedBand = "BAND_FAVORITE"
            popScreen(202);
        }

        // Reset
        favoriteAdd = "";
    }

    function leftFocus() {
        /* 왼쪽 배경 화면*/
        leftFocusImage.visible = true
        rightFocusImage.visible = false
    }

    function rightFocus() {
        /* 오른쪽 배경 화면*/
        leftFocusImage.visible = false
        rightFocusImage.visible = true
    }

    Connections {
        target: idAppMain
        onMenuOffFocus: {
            /* Menu off 동작 시 focus */
            if(true == idBtContactMainScreen.visible) {
                idBtContactList.forceActiveFocus();
            }
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        idBtContactList.forceActiveFocus();
    }

    Component.onDestruction: {
    }

    onVisibleChanged: {
        if(true == idBtContactMainScreen.visible) {
            idBtContactList.forceActiveFocus();
        }
        if(true == idBtContactMainScreen.visible && "FROM_SEARCH" == favoriteAdd){
            favoriteAdd = "FROM_CONTACT"
        }
    }

    onBackKeyPressed: {
        idBtContactMainScreen.backKeyHandler();
    }

    onClickMenuKey: {
        idMenu.show();
    }


    /* WIDGETS */
    MouseArea {
        anchors.fill: parent
        beepEnabled: false
    }

    /* 배경 왼쪽 이미지 */
    Image {
        id: leftFocusImage
        source: ImagePath.imgFolderGeneral + "bg_menu_l.png"
        y: 1
        visible: true

        Image {
            source: ImagePath.imgFolderGeneral + "bg_menu_l_s.png"
        }
    }

    /* 배경 오른쪽 이미지 */
    Image {
        id: rightFocusImage
        source: ImagePath.imgFolderGeneral + "bg_menu_r.png"
        y: 1
        visible: false

        Image {
            x: 589
            source: ImagePath.imgFolderGeneral + "bg_menu_r_s.png"
        }
    }

    /* 상단 Band (즐겨찾기 추가에서 나타나는 밴드)*/
    MComp.DDSimpleBand {
        id: contactsAddtoFavoriteBand
        y: -systemInfo.titleAreaHeight
        titleText: stringInfo.str_Bt_Menu_Add_Favorite
        visible: ("" == favoriteAdd) ? false : true

        onBackBtnClicked: {
            // 통화 중 Hard Key back 입력 시 화면 겹치는 현상 수정
            idBtContactMainScreen.backKeyHandler();
        }

        onActiveFocusChanged: {
            if(true == activeFocus) {
                idVisualCue.setVisualCue(false, false, true, false);
            }
        }

        KeyNavigation.down: idBtContactInfoLeft
    }

    /* 왼쪽 리스트 화면 */
    FocusScope {
        id: idBtContactInfoLeft
        x: 0
        width: 578      //113 + 465
        height: systemInfo.lcdHeight - 73
        focus: true

        onActiveFocusChanged: {
            leftFocus();
            if(true == idBtContactInfoLeft.activeFocus) {
                visualCueDownActive = true
            } else {
                visualCueDownActive = false
            }
        }

        /* 검색 버튼 */
        MComp.MButtonHaveTicker  {
            id: imgBtContactInfoLeftSearch
            x: 43
            y: 15
            width: 527
            height: 85

            bgImage:        ImagePath.imgFolderBt_phone + "contacts_inputbox_n.png"
            bgImagePress:   ImagePath.imgFolderBt_phone + "contacts_inputbox_p.png"
            bgImageFocus:   ImagePath.imgFolderBt_phone + "contacts_inputbox_f.png"

            fgImage:        ImagePath.imgFolderBt_phone + "ico_contacts_search_n.png"
            fgImagePress:   ImagePath.imgFolderBt_phone + "ico_contacts_search_p.png"
            fgImageFocus:   ImagePath.imgFolderBt_phone + "ico_contacts_search_f.png"

            fgImageWidth: 34
            fgImageHeight: 34
            fgImageX: 12
            fgImageY: 25
            fgImageFocusVisible: true == imgBtContactInfoLeftSearch.activeFocus

            firstText: stringInfo.str_Search_Phonebook_Text
            firstTextX: 63
            firstTextY: 25
            firstTextSize: 38
            firstTextWidth: 447
            firstTextColor: colorInfo.dimmedGrey
            firstTextPressColor: colorInfo.dimmedGrey
            firstTextFocusColor: colorInfo.brightGrey
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextAlies: "Left"
            firstTextElide: "Right"

            onClickOrKeySelected: {
                // 검색 화면 진입 이후 다시 돌아왔을때 검색화면 진입버튼에 포커스가 유지되는 문제점 수정 부분
                imgBtContactInfoLeftSearch.focus = false
                idBtContactList.focus = true

                if(false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                    /* 주행 규제 팝업 출력부분으로 북미 향지만 적용
                     * (UIListener.invokeGetCountryVariant = 1 미국, UIListener.invokeGetCountryVariant = 6 캐나다)
                     */
                    MOp.showPopup("popup_search_while_driving");
                } else {
                    /* 검색 화면 상단 입력창 내부 Text 초기화*/
                    contactSearchInput = ""

                    keypadChange()
                    pushScreen("BtContactSearchMain", 504);

                    // 전화번호부 화면의 상태가 즐겨찾기 등록 상태인경우 화면전환 시 즐겨찾기 등록 상태를 유지해야함
                    if("" != favoriteAdd) {
                        favoriteAdd = "FROM_SEARCH";
                    }
                }
            }

            onActiveFocusChanged: {
                if(true == imgBtContactInfoLeftSearch.activeFocus) {
                    idVisualCue.setVisualCue(true, true, true, false);
                }
            }

            KeyNavigation.up: ("" == favoriteAdd) ? idLoaderMainBand : contactsAddtoFavoriteBand
            KeyNavigation.down: idBtContactList
        }

        /* 전화번호부 리스트 */
        BtContactListView {
            id:idBtContactList
            x: 21
            y: 104
            width: 580
            height: 428
            focus: true
        }

        /* Quick Scroll 팝업 */
        BtContactMiniPopup {
            id: idContactMiniPopup
            x: 197
            y: 231
        }

        /* Quic scroll */
        BtContactScroll {
            id: idContactQuickScroll
            x: 527
            y: 104

            /* Quick Scroll 터치 영역 터치영역 확대 기존 영역 보다 넓게 적용
             */
            MouseArea {
                id: idMouseAreaQuickScroll
                z: 10
                anchors.left: parent.left
                anchors.leftMargin: -20
                anchors.top: parent.top
                anchors.topMargin: -30

                width: 100
                height: 432 + 50   // 영역 확대


                property bool delayedScroll: false
                property string prevLetter: ""


                function quickScroll(mouseY) {
                    if(true == delayedScroll) {
                        return;
                    }

                    var letter = idContactQuickScroll.getScrollLetter(mouseY - 15);

                    if(prevLetter == letter) {
                        // do nothing
                    } else {
                        delayedScroll = true;
                        idQuickScrollDelayTimer.restart();

                        // 전화번호부 검색 부분
                        BtCoreCtrl.invokeQuickScroll(letter) // 터치된 좌표의 Hide Model Letter값을 검색하는 동작
                        prevLetter = letter;

                        // Mini 팝업 표시 부분
                        if(2 == gLanguage) {
                            // Korea
                            if("#" == letter || "ㄱ" == letter ||
                                    "ㅁ" == letter || "ㅈ" == letter ||
                                    "ㅍ" == letter || "A" == letter ||
                                    "F" == letter || "K" == letter ||
                                    "P" == letter || "U" == letter) {
                                idContactMiniPopup.show(letter);
                            }
                        } else if(20 == gLanguage) {
                            // Arab
                            if("#" == letter || "ا" == letter ||
                                    "خ" == letter || "ش" == letter ||
                                    "غ" == letter || "ن" == letter ||
                                    "A" == letter || "F" == letter ||
                                    "K" == letter || "P" == letter ||
                                    "U" == letter) {
                                idContactMiniPopup.show(letter);
                            }
                        } else {
                            // Other
                            if("#" == letter || "A" == letter ||
                                    "D" == letter || "G" == letter ||
                                    "J" == letter || "M" == letter ||
                                    "P" == letter || "S" == letter ||
                                    "V" == letter ) {
                                idContactMiniPopup.show(letter);
                            }
                        }
                    }
                }

                onPressed: {
                    idBtContactList.forceActiveFocus();
                    quickScroll(mouseY);
                }

                onPositionChanged: {
                    /* Quick Scroll을 움직이면 미니 팝업을 없애기 위한 타이머 종료
                     */
                    quickScroll(mouseY);
                }

                onReleased: {
                    /* FastScroll에서 손을 뗐을때 미니 팝업을 없애기 위한 타이머 시작(1초뒤 사라짐)
                     */
                    idContactMiniPopup.start();
                    prevLetter = "";
                }
            }

            Timer {
                id: idQuickScrollDelayTimer
                interval: 50
                repeat: false
                running: false

                onTriggered: {
                    idMouseAreaQuickScroll.delayedScroll = false;
                }
            }
        }

        KeyNavigation.right: idBtContactRightView
    }

    /* 오른쪽 리스트 화면 */
    Item {
        id: idBtContactInfoRight
        x: 707 - 18
        width: 601
        height: systemInfo.lcdHeight - 73

        /* 문구가 길지 않을때 표시되는 우측 1줄 표시 부분 */
        Text {
            id: idHeadName_One_line
            text: headName
            x: 716 - 707 - 18
            y: 95
            height: 60
            width: 537
            visible: ("" == tailName) ? true : false

            font {
                family: stringInfo.fontFamilyRegular    //"HDR"
                pointSize: 60
            }

            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        /* 문구가 길지 않을때 표시되는 우측 2줄 표시 부분 > Head*/
        Text {
            id: idHeadName_Two_line
            text: headName
            x: 716 - 707 - 18
            y: 62
            height: fontSize
            width: 537
            visible: ("" != tailName) ? true : false

            font {
                family: stringInfo.fontFamilyRegular    //"HDR"
                pointSize: fontSize
            }

            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        /* 문구가 길지 않을때 표시되는 우측 2줄 표시 부분 > Tail*/
        Text {
            id:idTailName_Two_line
            text: tailName
            x: 716 - 707 - 18
            y: 126
            height: fontSize
            width: 537
            visible: ("" != tailName) ? true : false
            elide: Text.ElideRight

            font {
                family: stringInfo.fontFamilyRegular    //"HDR"
                pointSize: fontSize
            }

            color: colorInfo.brightGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        /* 전화번호부 우측 하단 전화번호 출력 부분*/
        BtContactRightInfo {
            id: idBtContactRightView
            x: 0
            y: {
                if(delegate_count <= 3) {
                   368 - systemInfo.headlineHeight
               } else if(delegate_count == 4) {
                   365 - systemInfo.headlineHeight
               } else {
                   365 - systemInfo.headlineHeight
               }
            }

            onActiveFocusChanged: {
                rightFocus();
            }

            width: 535
            height: 305     //61 * 5

            KeyNavigation.up : (true == contactsAddtoFavoriteBand.visible) ? contactsAddtoFavoriteBand : idLoaderMainBand
            KeyNavigation.left: idBtContactInfoLeft
        }
    }
}
/* EOF */
