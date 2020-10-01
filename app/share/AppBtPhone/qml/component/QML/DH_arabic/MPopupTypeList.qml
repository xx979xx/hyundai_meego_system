/**
 * MPopupTypeList.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idMPopupTypeList
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupBgImage: popupLineCnt < 4 ? ImagePath.imgFolderPopup+"bg_type_a.png" : ImagePath.imgFolderPopup+"bg_type_b.png"
    property int popupBgImageY: popupLineCnt < 4 ? 208-systemInfo.statusBarHeight : 171-systemInfo.statusBarHeight
    property int popupBgImageHeight: popupLineCnt < 4 ? 304 : 379  
    property bool black_opacity: true

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 1    //# 1 or 2
    property QtObject idListModel

    property bool checkBoxFlag: false
    property bool radioBtnFlag: false
    property bool selectedItemCheckBoxState     //# checkBox state of selectedItem (true or false)
    property int selectedItemIndex: 0           //# indexNumber of selectedItem
    property int popupLineCnt: idListView.count //# 1 ~ limit
    property int overContentCount

    property alias button1Enabled: idButton1.mEnabled

    // SIGNALS
    //DEPRECATED signal popupBgClicked();
    signal popuplistItemClicked(int selectedItemIndex);
    signal checkBoxOnToOffClicked(int selectedItemIndex, bool selectedItemCheckBoxState);
    signal checkBoxOffToOnClicked(int selectedItemIndex, bool selectedItemCheckBoxState);
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idMPopupTypeList.visible) {
            idListView.currentIndex = 0;
            idListView.forceActiveFocus();
            idButton1.mEnabled = false;
            popupBackGround = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeList.visible) {
            idListView.currentIndex = 0;
            idListView.forceActiveFocus();
            idButton1.mEnabled = false;
            popupBackGround = black_opacity
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
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        source: popupBgImage
        x: 93
        y: popupBgImageY
        width: 1093
        height: popupBgImageHeight


        FocusScope {
            id: idList
            x: 327
            y: 69
            width: 740
            height: popupLineCnt * 85
            focus: true
            KeyNavigation.left: (true == idButton1.mEnabled) ? idButton1 : idButton2

            property int checkedCount: 0

            ListView {
                id: idListView
                clip: true
                focus: true
                anchors.fill: parent
                orientation: ListView.Vertical
                boundsBehavior: Flickable.StopAtBounds
                highlightMoveSpeed: 99999
                model: idListModel
                delegate: idListDelegate

                onContentYChanged:{
                    overContentCount = contentY / (contentHeight / count)
                }
            }

            Component {
                id: idListDelegate

                MButton {
                    id: idItemDelegate
                    x: 0
                    y: 0
                    width: 740
                    height: 85
                    bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                    bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                    firstText: listFirstItem
                    firstTextX: 87
                    firstTextY: 26      //152 - 110 - 32/2
                    firstTextWidth: 610
                    firstTextHeight: 32
                    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                    firstTextSize: 32
                    firstTextAlies: "Right"
                    firstTextElide: "Left"
                    firstTextColor: colorInfo.brightGrey
                    firstDimmedTextColor: colorInfo.brightGrey
                    firstTextDisableColor: colorInfo.brightGrey

                    fgImage: ImagePath.imgFolderPopup + "list_line.png"
                    fgImageX: 10
                    fgImageY: 82
                    fgImageWidth: 732
                    fgImageHeight: 2
                    fgImageVisible: (index != popupLineCnt) ? true : false

                    onClickOrKeySelected: {
                        if(checkBoxFlag == true) {
                            selectedItemIndex = index;
                            if(selectedItemCheckBoxState == true) {
                                checkBoxOnToOffClicked(selectedItemIndex, selectedItemCheckBoxState);
                                idList.checkedCount = idList.checkedCount - 1;
                            } else {
                                checkBoxOffToOnClicked(selectedItemIndex, selectedItemCheckBoxState);
                                idList.checkedCount = idList.checkedCount + 1;
                            }

                            idCheckBox.toggle();
                        } else {
                            selectedItemIndex = index;
                            popuplistItemClicked(selectedItemIndex);
                        }

                        idItemDelegate.forceActiveFocus()
                    }

                    property alias selectedItemCheckBoxState: idCheckBox.flagToggle

                    MDimCheck {
                        id: idCheckBox
                        x: 18
                        y: 125
                        z: 1
                        width: 51
                        height: 52
                        bgImage: checkBoxFlag == true ? ImagePath.imgFolderSettings + "ico_check_n.png" : ""
                        bgImageSelected: (true == checkBoxFlag && true == idItemDelegate.mEnabled) ? ImagePath.imgFolderSettings + "ico_check_s.png" : ""
                        visible: (checkBoxFlag == true) ? true : false
                        state: (true == flagToggle) ? "on" : "off"

                        onClickOrKeySelected: {
                            if(true == idItemDelegate.mEnabled) {
                                selectedItemIndex = index;

                                if(selectedItemCheckBoxState == true) {
                                    checkBoxOffToOnClicked(selectedItemIndex, selectedItemCheckBoxState);
                                    idList.checkedCount = idList.checkedCount + 1;
                                } else {
                                    checkBoxOnToOffClicked(selectedItemIndex, selectedItemCheckBoxState);
                                    idList.checkedCount = idList.checkedCount - 1;
                                }
                            }

                            idItemDelegate.forceActiveFocus();
                        }
                    }

                    onWheelLeftKeyPressed: {
                        idItemDelegate.ListView.view.decrementCurrentIndex();
                    }

                    onWheelRightKeyPressed: {
                        idItemDelegate.ListView.view.incrementCurrentIndex();
                    }
                }
            }
        }

        MButton {
            id: idButton1
            x: 18
            y: 18
            width: 295
            height: 134
            mEnabled: false
            visible: true

            bgImage: (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_a_02_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_a_02_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 232
            fgImageY: 32
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            KeyNavigation.right: idList

            onWheelRightKeyPressed: idButton2.forceActiveFocus()

            firstText: popupFirstBtnText
            firstTextX: 26
            firstTextY:49
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupFirstBtnClicked();
            }

            onMEnabledChanged: {
                if(false == idButton1.mEnabled) {
                    if(true == idButton1.acticveFocus) {
                        idButton1.focus = false;
                        idButton2.focus = true;
                    }
                }
            }
        }

        MButton {
            id: idButton2
            x: 18
            y: 152
            width: 295
            height: 134
            visible: true

            bgImage:    (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_a_03_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_a_03_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 232
            fgImageY: 32
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton2.activeFocus

            KeyNavigation.right: idList

            onWheelLeftKeyPressed: {
                if(true == idButton1.mEnabled) {
                    idButton1.forceActiveFocus()
                } else {
                    // do nothing
                }
            }

            firstText: popupSecondBtnText
            firstTextX: 26
            firstTextY: 49
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupSecondBtnClicked();
            }
        }
    }
}
/* EOF */
