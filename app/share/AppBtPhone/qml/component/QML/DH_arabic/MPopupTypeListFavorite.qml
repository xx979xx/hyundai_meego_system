/**
 * /QML/DH_arabic/MPopupTypeListFavorite.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MComponent
{
    id: idMPopupTypeList
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupName
    property string popupBgImage: ImagePath.imgFolderPopup + "bg_type_e.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 131 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 459

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 1    //# 1 or 2
    property QtObject idListModel
    property string listFirstItem
    property string popupTitleText

    property int popupLineCnt: idListView.count    //# 1 ~ limit
    property int overContentCount

    // SIGNALS
    signal popupClicked();
    //DEPRECATED signal popupBgClicked();
    signal popuplistItemClicked(int currentIndex);
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    function setTypeImage(type) {
        if(1 == type) {
            return ImagePath.imgFolderPopup + "ico_bt_phone.png"
        } else if(2 == type) {
            return ImagePath.imgFolderPopup + "ico_bt_home.png"
        } else if(3 == type) {
            return ImagePath.imgFolderPopup + "ico_bt_office.png"
        } else {
            return ImagePath.imgFolderPopup + "ico_bt_other.png"
        }
    }

    function buildListModel() {
        if(true == idMPopupTypeList.visible) {
            idFavoriteList.model.get(4).faviriteIconType = contact_type_5
            idFavoriteList.model.get(3).faviriteIconType = contact_type_4
            idFavoriteList.model.get(2).faviriteIconType = contact_type_3
            idFavoriteList.model.get(1).faviriteIconType = contact_type_2
            idFavoriteList.model.get(0).faviriteIconType = contact_type_1

            idFavoriteList.model.get(4).favoriteNumber = other2Num
            idFavoriteList.model.get(3).favoriteNumber = otherNum
            idFavoriteList.model.get(2).favoriteNumber = officeNum
            idFavoriteList.model.get(1).favoriteNumber = homeNum
            idFavoriteList.model.get(0).favoriteNumber = phoneNum
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        buildListModel();
        popupBackGroundBlack = true
    }

    onClickOrKeySelected: {
        //DEPRECATED popupBgClicked()
    }

    onVisibleChanged: {
        buildListModel();
        popupBackGroundBlack = true

        /* 팝업은 4~5개만 나타나는 팝업인데, 현재 화면이 4개짜리면 4개짜리 첫 번째 포커스 가도록 하며,
         * 5개인 경우에는 5개를 나타내는 리스트에 포커스 가도록 하는 코드
         */
        if(4 == delegate_count) {
            btn_list_04_01.forceActiveFocus();
        } else {
            idFavoriteList.forceActiveFocus();
            idFavoriteList.currentIndex = 0;
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    Image {
        source: popupBgImage
        x: popupBgImageX
        y: popupBgImageY
        width: popupBgImageWidth
        height: popupBgImageHeight
        focus: true

        Text {
            id: idTitle
            text: popupTitleText
            x: 55
            y: 37
            width: 983
            height: 44
            font.pointSize: 44
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideLeft
        }

        FocusScope {
            id: idList_4Line
            x: 327
            visible: 4 == delegate_count
            focus: 4 == delegate_count

            MButton {
                id: btn_list_04_01
                y: 104
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                focus: true

                firstText: MOp.checkPhoneNumber(phoneNum)
                firstTextX: 80
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"

                Image {
                    source: setTypeImage(contact_type_1)
                    x: 660
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_1, phoneNum)
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    //visible: "" != favoriteAdd
                }

                Image {
                    source: ImagePath.imgFolderPopup + "list_line.png"
                    x: 36
                    y: 82
                }

                onWheelLeftKeyPressed: btn_list_04_02.forceActiveFocus()
            }


            MButton {
                id: btn_list_04_02
                y: 104 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(homeNum)
                firstTextX: 80
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"

                Image {
                    source: setTypeImage(contact_type_2)
                    x: 660
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_2, homeNum)
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    //visible: "" != favoriteAdd
                }

                Image {
                    source: ImagePath.imgFolderPopup + "list_line.png"
                    x: 36
                    y: 82
                }
                onWheelRightKeyPressed: btn_list_04_01.forceActiveFocus()
                onWheelLeftKeyPressed: btn_list_04_03.forceActiveFocus()
            }


            MButton {
                id: btn_list_04_03
                y: 104 + 82 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(officeNum)
                firstTextX: 80
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"

                Image {
                    source: setTypeImage(contact_type_3)
                    x: 660
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_3, officeNum)
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    //visible: "" != favoriteAdd
                }

                Image {
                    source: ImagePath.imgFolderPopup + "list_line.png"
                    x: 36
                    y: 82
                }

                onWheelRightKeyPressed: btn_list_04_02.forceActiveFocus()
                onWheelLeftKeyPressed: btn_list_04_04.forceActiveFocus()
            }


            MButton {
                id: btn_list_04_04
                y: 104 + 82 + 82 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(otherNum)
                firstTextX: 80
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"

                Image {
                    source: setTypeImage(contact_type_4)
                    x: 660
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_4, otherNum)
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    //visible: "" != favoriteAdd
                }

                Image {
                    source: ImagePath.imgFolderPopup + "list_line.png"
                    x: 36
                    y: 82
                }

                onWheelRightKeyPressed: btn_list_04_03.forceActiveFocus()
            }

            KeyNavigation.left: idButton1
        }

        FocusScope {
            id: idList_5Line
            x: 327
            y: 104
            visible: 5 == delegate_count
            focus: 5 == delegate_count

            DDListView {
                id: idFavoriteList
                width: 740
                height: 82 * 4
                focus: true
                model: favoriteModel
                clip: true
                highlightMoveSpeed: 9999999

                delegate: favoriote_btn

                onContentYChanged:{
                    overContentCount = contentY / (contentHeight / count)
                }

                function getStartIndex(posY) {
                    var startIndex = -1;
                    for(var i = 1; i < 10; i++) {
                        startIndex = indexAt(100, posY + 50 * i);
                        if(-1 < startIndex) {
                            break;
                        }
                    }

                    return startIndex;
                }

                onMovementStarted: {
                }

                onMovementEnded: {
                    if(false == idMPopupTypeList.visible) {
                        return;
                    }

                    if("" == popupState && menuOn == false) {
                        idFavoriteList.forceActiveFocus();
                    }

                    var flickingIndex = getStartIndex(contentY);
                    if(-1 != flickingIndex) {
                        positionViewAtIndex(flickingIndex, ListView.Beginning);
                        currentIndex = flickingIndex;
                    }
                }
            }

            ListModel{
                id:favoriteModel
                ListElement {faviriteIconType: "";  favoriteNumber: "" }
                ListElement {faviriteIconType: "";  favoriteNumber: "" }
                ListElement {faviriteIconType: "";  favoriteNumber: "" }
                ListElement {faviriteIconType: "";  favoriteNumber: "" }
                ListElement {faviriteIconType: "";  favoriteNumber: "" }
            }

            Component {
                id: favoriote_btn

                MButton {
                    width: 740
                    height: 82
                    bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                    bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                    focus: idFavoriteList.currentIndex == index

                    firstText: MOp.checkPhoneNumber(favoriteNumber)
                    firstTextX: 80
                    firstTextY: 82 - 39 - 16
                    firstTextWidth: 567
                    firstTextHeight: 32
                    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                    firstTextSize: 32
                    firstTextColor: colorInfo.brightGrey
                    firstTextAlies: "Right"

                    Image {
                        source: setTypeImage(faviriteIconType)
                        x: 660
                        y: 82 - 39 - 24
                        width: 50
                        height: 50
                    }

                    onWheelRightKeyPressed: {
                        if(0 == index ){
                            idFavoriteList.currentIndex = idFavoriteList.count - 1
                        } else {
                            idFavoriteList.decrementCurrentIndex()
                        }
                    }

                    onWheelLeftKeyPressed: {
                        if(idFavoriteList.count == index + 1){
                            idFavoriteList.currentIndex = 0
                        } else {
                            idFavoriteList.incrementCurrentIndex()
                        }
                    }

                    onClickOrKeySelected: {
                        if(0 == index) {
                            BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_1, phoneNum)
                        } else if(1 == index) {
                            BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_2, homeNum)
                        } else if(2 == index) {
                            BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_3, officeNum)
                        } else if(3 == index) {
                            BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_4, otherNum)
                        } else {
                            BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_5, other2Num)
                        }
                    }

                    Image {
                        source: ImagePath.imgFolderPopup + "list_line.png"
                        x: 36
                        y: 82
                    }
                        Image {
                            source: ImagePath.imgFolderPopup + "ico_add.png"
                            x: 22
                            y: 82 - 39 - 24
                            width: 45
                            height: 46
                            //visible: "" != favoriteAdd
                        }

                    KeyNavigation.left: idButton1
                }
            }

            MRoundScroll {
                x: 292 - 327
                y: 117 - 104
                scrollWidth: 39
                scrollHeight: 306
                scrollBgImage: idFavoriteList.count > 4 ? ImagePath.imgFolderPopup + "scroll_bg.png" : ""
                scrollBarImage: idFavoriteList.count > 4 ? ImagePath.imgFolderPopup + "scroll.png" : ""
                listCountOfScreen: 4
                moveBarPosition: idFavoriteList.height / idFavoriteList.count * overContentCount
                listCount: idFavoriteList.count
            }
        }

        MButton {
            id: idButton1
            x: 18
            y: 98
            width: 295
            height: 343
            bgImage: (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_a_01_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_a_01_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 226
            fgImageY: 136
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton1.activeFocus == true

            firstText: popupFirstBtnText
            firstTextX: 26
            firstTextY: 153
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            KeyNavigation.right: 4 == delegate_count ? idList_4Line : idList_5Line

            onWheelLeftKeyPressed: idButton2.forceActiveFocus()

            onClickOrKeySelected: {
                MOp.hidePopup();
            }
        }
    }
}
/* EOF */
