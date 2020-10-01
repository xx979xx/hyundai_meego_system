/**
 * FileName: MPopupTypeList.qml
 * Author: HYANG
 * Time: 2012-12
 *
 * - 2012-12-04 Initial Created by HYANG
 * - 2012-12-06 Add CheckBox, RadioButton by HYANG
 * - 2012-12-10 Add Wheel in List by HYANG
 * - 2012-12-12 Add Text 2 Line in Button
 */

import QtQuick 1.1
import "../../QML/DH" as MComp

MComponent{
    id: idMPopupTypeList
    x: 0; y: -systemInfo.statusBarHeight
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
    focus: true

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string imgFolderSettings: imageInfo.imgFolderSettings

    property string popupBgImage: popupLineCnt < 4 ? imgFolderPopup+"bg_type_a.png" : imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: popupLineCnt < 4 ? 208 : 171//popupLineCnt < 4 ? 208-systemInfo.statusBarHeight : 171-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: popupLineCnt < 4 ? 304 : 379

    property int popupTopMargin: 18
    property string popupFirstBtnText: ""
    property string popupFirstBtnText2Line: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnText2Line: ""

    property int popupBtnCnt: 1    //# 1 or 2
    property QtObject idListModel

    property bool checkBoxFlag: false
    property bool radioBtnFlag: false
    property bool selectedItemCheckBoxState     //# checkBox state of selectedItem (true or false)
    property int selectedItemIndex: 0           //# indexNumber of selectedItem
    property int popupLineCnt: idListView.count //# 1 ~ use input
    property int overPoppupListContentCount

    signal popuplistItemClicked(int selectedItemIndex);
    signal checkBoxOnToOffClicked(int selectedItemIndex, bool selectedItemCheckBoxState);
    signal checkBoxOffToOnClicked(int selectedItemIndex, bool selectedItemCheckBoxState);
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //****************************** # Popup image click #
    MButton{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        bgImage: popupBgImage
        bgImagePress: popupBgImage
    }

    //****************************** # List #
    FocusScope{
        id: idList
        x: popupBgImageX + 26; y: popupLineCnt == 1 ? popupBgImageY + 110 : popupLineCnt == 2 ? popupBgImageY + 69 : popupLineCnt == 3 ? popupBgImageY + 28 : popupBgImageY + 24
        width: 740; height: popupLineCnt < 4 ? (popupLineCnt * 82) : 4 * 82
        focus: true
        KeyNavigation.right: idButton1

        MComp.MListView{
            id: idListView
            clip: true
            focus: true
            anchors.fill: parent
            orientation: ListView.Vertical
            boundsBehavior: Flickable.StopAtBounds
            highlightMoveSpeed: 99999
            model: idListModel
            delegate: idListDelegate
            optionMenuNoBand: true

            onContentYChanged: { overPoppupListContentCount = contentY/(contentHeight/count) }
        }

        //****************************** # Scroll #
        MComp.MRoundScroll{
            x: 760 - popupTopMargin; y: 35 - popupTopMargin
            scrollWidth: 39; scrollHeight: 306
            scrollBgImage: idListView.count > 4 ? imgFolderPopup + "scroll_bg.png" : ""
            scrollBarImage: idListView.count > 4 ? imgFolderPopup + "scroll.png" : ""
            listCountOfScreen: 4
            moveBarPosition: idListView.height/idListView.count*overPoppupListContentCount
            listCount: idListView.count
            visible: (idListView.count > 4)
        }

        Component{
            id: idListDelegate

            MComp.MButton{
                id: idItemDelegate
                x: 0; y: 0
                width: 740; height: 82
                bgImagePress: imgFolderPopup + "list_p.png"
                bgImageFocus: imgFolderPopup + "list_f.png"
                focus: true

                firstText: listFirstItem
                firstTextX: 69 - 26
                firstTextY: 152 - 110
                firstTextWidth: 677
                firstTextStyle: systemInfo.font_NewHDR
                firstTextSize: 32
                firstTextAlies: "Left"
                firstTextColor: colorInfo.subTextGrey
		firstTextFocusColor: colorInfo.brightGrey
                firstTextPressColor: colorInfo.brightGrey

                fgImage: imgFolderPopup + "list_line.png"
                fgImageX: 36 - 26
                fgImageY: 82
                fgImageWidth: 732
                fgImageHeight: 2
                fgImageVisible: index != popupLineCnt

                onClickOrKeySelected: {
                    if(checkBoxFlag == true){
                        selectedItemIndex = index
                        selectedItemCheckBoxState = !selectedItemCheckBoxState
                        if(selectedItemCheckBoxState == true) checkBoxOffToOnClicked(selectedItemIndex, selectedItemCheckBoxState);
                        else checkBoxOnToOffClicked(selectedItemIndex, selectedItemCheckBoxState);
                    }
                    else{
                        selectedItemIndex = index
                        popuplistItemClicked(selectedItemIndex);
                    }
                }

                //****************************** # CheckBox in List #
                property alias selectedItemCheckBoxState: idCheckBox.flagToggle
                MComp.MDimCheck{
                    id: idCheckBox
//                    x: 69 + 610 + popupTopMargin- 26; y: 125; z: 1
//                    width: 51; height: 52
//                    bgImage: checkBoxFlag == true ? imgFolderSettings+"ico_check_n.png" : ""
//                    bgImageSelected: checkBoxFlag == true ? imgFolderSettings+"ico_check_s.png" : ""
                    visible: checkBoxFlag == true
                    state: flagToggle == true ? "on" : "off"

                    onClickOrKeySelected: {
                        selectedItemIndex = index
                        if(selectedItemCheckBoxState == true) checkBoxOffToOnClicked(selectedItemIndex, selectedItemCheckBoxState);
                        else checkBoxOnToOffClicked(selectedItemIndex, selectedItemCheckBoxState);
                    }

                    Item {
                        id: idCheckBoxImage
                        x: 69 + 610 + popupTopMargin- 26; y: 125
                        width: 45; height: 45
                        visible: checkBoxFlag == true
                        Image {
                            id: imgDimCheckOff
                            source: imageInfo.imgFolderGeneral+"ico_check_n.png"
                            visible: !selectedItemCheckBoxState
                        }
                        Image {
                            id: imgDimCheckOn
                            source: imageInfo.imgFolderGeneral+"ico_check_s.png"
                            visible: selectedItemCheckBoxState
                        }
                    }
                }

                //****************************** # RadioButton in List #
                MComp.MRadioButton{
                    id: idRadioBtn
                    x: 69 + 610 + popupTopMargin - 26; y: popupTopMargin
                    width: 51; height: 52
                    bgImage: radioBtnFlag == true ? imgFolderSettings+"btn_radio_n.png" : ""
                    bgImageSelected: radioBtnFlag == true ? imgFolderSettings+"btn_radio_s.png" : ""
                    visible: radioBtnFlag == true
                    active: index == selectedItemIndex

                    onClickOrKeySelected: {
                        selectedItemIndex = index
                        popuplistItemClicked(selectedItemIndex);
                    }
                }

                onWheelLeftKeyPressed: {
                    if( idItemDelegate.ListView.view.currentIndex ){
                        idItemDelegate.ListView.view.decrementCurrentIndex();
                    }
                    else{
                        if(ListView.view.count < 4)
                            return;
                        idItemDelegate.ListView.view.positionViewAtIndex(idItemDelegate.ListView.view.count-1, idItemDelegate.ListView.view.Visible);
                        idItemDelegate.ListView.view.currentIndex = idItemDelegate.ListView.view.count-1;
                    }
                }
                onWheelRightKeyPressed: {
                    if( idItemDelegate.ListView.view.count-1 != idItemDelegate.ListView.view.currentIndex ){
                        idItemDelegate.ListView.view.incrementCurrentIndex();
                    }
                    else{
                        if(ListView.view.count < 4)
                            return;
                        idItemDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                        idItemDelegate.ListView.view.currentIndex = 0;
                    }
                }
            }
        }

        onVisibleChanged: {
            if (visible == true)
            {
                idList.focus = true;
                idListView.currentIndex = 0;
            }
        }
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + popupTopMargin
        width: 288
        height: popupLineCnt < 4 ? popupBtnCnt == 1 ? 268 : 134 : popupBtnCnt == 1 ? 329 : 171
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: popupLineCnt < 4 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_02_n.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
        bgImagePress: popupLineCnt < 4 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_p.png" : imgFolderPopup+"btn_type_b_02_p.png"
        bgImageFocus: popupLineCnt < 4 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_f.png" : imgFolderPopup+"btn_type_b_02_f.png"
        visible: popupBtnCnt == 1 || popupBtnCnt == 2

        fgImageX: popupLineCnt < 4 ? popupBtnCnt == 1 ? 778 - 780 : 767 - 780 : popupBtnCnt == 1 ? 778 - 780 : 773 - 780
        fgImageY: popupLineCnt < 4 ? popupBtnCnt == 1 ? 117 - popupTopMargin : 50 - 25 : popupBtnCnt == 1 ? 154 - 25 : 72 - 25
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupFirstBtnText2Line != "" ? 133 - 16 : 152 - 18
        firstTextZ: 3
        firstTextWidth: 210
        firstTextSize: popupFirstBtnText2Line != "" ? 32 : 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        secondText: popupFirstBtnText2Line
        secondTextX: 832 - 780
        secondTextY: popupLineCnt < 4 ? popupBtnCnt == 1 ? 133 + 40 - 25 : 66 + 40 - 25 : popupBtnCnt == 1 ? 170 + 40 - 25 : 88 + 40 - 25
        secondTextWidth: 210
        secondTextSize: 32
        secondTextStyle: systemInfo.font_NewHDB
        secondTextAlies: "Center"
        secondTextColor: colorInfo.brightGrey
        secondTextVisible: popupFirstBtnText2Line != ""

        KeyNavigation.left: idList
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupLineCnt < 4 ? popupBgImageY + popupTopMargin + 134 : popupBgImageY + popupTopMargin + 171
        width: 288
        height: popupLineCnt < 4 ? 134 : 171
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: popupLineCnt < 4 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
        bgImagePress: popupLineCnt < 4 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_p.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_p.png" : ""
        bgImageFocus: popupLineCnt < 4 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_f.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_f.png" : ""
        visible: popupBtnCnt == 2

        fgImageX: popupLineCnt < 4 ? 767 - 780 : 773 - 780
        fgImageY: popupLineCnt < 4 ? 50 + 134 - popupTopMargin - 134 : 72 + 164 - popupTopMargin - 171
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: popupBtnCnt == 2 ? imgFolderPopup+"light.png" : ""
        fgImageVisible: focusImageVisible

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupLineCnt < 4 ? popupSecondBtnText2Line != "" ? 66 + 40 + 94 - popupTopMargin - 134 : 85 + 134 - popupTopMargin - 134 : popupSecondBtnText2Line != "" ? 88 + 40 + 124 - popupTopMargin - 171 : 107 + 171 - popupTopMargin - 171
        firstTextZ: 3
        firstTextWidth: 210
        firstTextSize: popupSecondBtnText2Line != "" ? 32 : 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        secondText: popupSecondBtnText2Line
        secondTextX: 832 - 780
        secondTextY: popupLineCnt < 4 ? 66 + 40 + 94 + 40 - popupTopMargin - 134 : 88 + 40 + 124 + 40 - popupTopMargin - 171
        secondTextWidth: 210
        secondTextSize: 32
        secondTextStyle: systemInfo.font_NewHDB
        secondTextAlies: "Center"
        secondTextColor: colorInfo.brightGrey
        secondTextVisible: popupSecondBtnText2Line != ""

        KeyNavigation.left: idList
        onWheelLeftKeyPressed: idButton1.focus = true
        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
