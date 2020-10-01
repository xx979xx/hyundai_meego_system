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

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent{
    id: idMPopupTypeList
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string imgFolderSettings: imageInfo.imgFolderSettings

    property string popupBgImage: popupLineCnt < 4 ? imgFolderPopup+"bg_type_a.png" : imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: popupLineCnt < 4 ? 208-systemInfo.statusBarHeight : 171-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: popupLineCnt < 4 ? 304 : 379  

    property int popupTopMargin: 18
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 1    //# 1 or 2
    property QtObject idListModel

    property bool checkBoxFlag: false
    property bool radioBtnFlag: false
    property bool selectedItemCheckBoxState     //# checkBox state of selectedItem (true or false)
    property int selectedItemIndex: 0           //# indexNumber of selectedItem
    property int popupLineCnt: idListView.count //# 1 ~ use input
    property int overContentCount

    signal popupClicked();
    signal popupBgClicked();
    signal popuplistItemClicked(int selectedItemIndex);
    signal checkBoxOnToOffClicked(int selectedItemIndex, bool selectedItemCheckBoxState);
    signal checkBoxOffToOnClicked(int selectedItemIndex, bool selectedItemCheckBoxState);
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask click #
    onClickOrKeySelected: {
        popupBgClicked()
    }

    //****************************** # StatusBar Dim #
    Rectangle{
        x: 0; y: -systemInfo.statusBarHeight
        height: systemInfo.statusBarHeight;
        width: systemInfo.lcdWidth
        color: colorInfo.black
        opacity: 0.6
        MouseArea{
            anchors.fill: parent;
        }
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }  

    //****************************** # Popup image click #
    //    MButton{
    //        x: popupBgImageX; y: popupBgImageY
    //        width: popupBgImageWidth; height: popupBgImageHeight
    //        bgImage: popupBgImage
    //        bgImagePress: popupBgImage
    //        onClickOrKeySelected: popupClicked();
    //    }
    Image{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    //****************************** # List #
    FocusScope{
        id: idList
        x: popupBgImageX + 26; y: popupLineCnt == 1 ? popupBgImageY + 110 : popupLineCnt == 2 ? popupBgImageY + 69 : popupLineCnt == 3 ? popupBgImageY + 28 : popupBgImageY + 24
        width: 740; height: popupLineCnt < 4 ? (popupLineCnt * 82) : 4 * 82
        focus: true
        KeyNavigation.right: idButton1

        MListView{
            id: idListView
            clip: true
            focus: true
            anchors.fill: parent
            orientation: ListView.Vertical
            boundsBehavior: (popupLineCnt < 4) ? Flickable.StopAtBounds : Flickable.DragAndOvershootBounds
            highlightMoveSpeed: 99999
            model: idListModel
            delegate: idListDelegate
            onContentYChanged:{
                overContentCount = contentY/(contentHeight/count)
            }
            Keys.onPressed: {
                if(event.key == Qt.Key_Up)
                {
                    event.accepted = true;
                    return;
                }
                else if(event.key == Qt.Key_Down)
                {
                    event.accepted = true;
                    return;
                }
            }
            onMovementEnded: {
                if(idMPopupTypeList.visible == true){
                    idList.focus = true
                }
            }
        }

        //****************************** # Scroll #
        MComp.MRoundScroll{
            x: 760 - 26; y: 35 - popupTopMargin
            scrollWidth: 39; scrollHeight: 306
            scrollBgImage: idListView.count > 4 ? imgFolderPopup + "scroll_bg.png" : ""
            scrollBarImage: idListView.count > 4 ? imgFolderPopup + "scroll.png" : ""
            listCountOfScreen: 4
            moveBarPosition: idListView.height/idListView.count*overContentCount
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

                firstText: listFirstItem
                firstTextX: 69 - 26
                firstTextY: 152 - 110
                firstTextWidth: 677
                //firstTextHeight: 32
                firstTextStyle: idAppMain.fonts_HDR
                firstTextSize: 32
                firstTextAlies: "Left"
                firstTextColor: colorInfo.subTextGrey

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
                    x: 69 + 610 + popupTopMargin- 26; y: 125; z: 1
                    width: 51; height: 52
                    bgImage: checkBoxFlag == true ? imgFolderSettings+"ico_check_n.png" : ""
                    bgImageSelected: checkBoxFlag == true ? imgFolderSettings+"ico_check_s.png" : ""
                    visible: checkBoxFlag == true
                    state: flagToggle == true ? "on" : "off"

                    onClickOrKeySelected: {
                        selectedItemIndex = index
                        if(selectedItemCheckBoxState == true) checkBoxOffToOnClicked(selectedItemIndex, selectedItemCheckBoxState);
                        else checkBoxOnToOffClicked(selectedItemIndex, selectedItemCheckBoxState);
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
                        idItemDelegate.ListView.view.positionViewAtIndex(idItemDelegate.ListView.view.count-1, idItemDelegate.ListView.view.Visible);
                        idItemDelegate.ListView.view.currentIndex = idItemDelegate.ListView.view.count-1;
                    }
                }
                onWheelRightKeyPressed: {
                    if( idItemDelegate.ListView.view.count-1 != idItemDelegate.ListView.view.currentIndex ){
                        idItemDelegate.ListView.view.incrementCurrentIndex();
                    }
                    else{
                        idItemDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                        idItemDelegate.ListView.view.currentIndex = 0;
                    }
                }
            }
        }
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + popupTopMargin
        width: 288;
        height: popupLineCnt < 4 ? popupBtnCnt == 1 ? 268 : 134 : popupBtnCnt == 1 ? 329 : 171
        // bgImage: popupLineCnt < 4 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_02_n.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
        bgImagePress: popupLineCnt < 4 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_p.png" : imgFolderPopup+"btn_type_b_02_p.png"
        bgImageFocus: popupLineCnt < 4 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_f.png" : imgFolderPopup+"btn_type_b_02_f.png"
        bgImageTop:  popupLineCnt < 4 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_02_n.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
        visible: popupBtnCnt == 1 || popupBtnCnt == 2

        fgImageX: popupLineCnt < 4 ? popupBtnCnt == 1 ? 778 - 780 : 767 - 780 : popupBtnCnt == 1 ? 778 - 780 : 773 - 780
        fgImageY: popupLineCnt < 4 ? popupBtnCnt == 1 ? 117 - popupTopMargin : 50 - popupTopMargin : popupBtnCnt == 1 ? 154 - popupTopMargin : 72 - popupTopMargin

        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: idButton1.activeFocus == true;
        KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
        KeyNavigation.left: idList
        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupLineCnt < 4 ? popupBtnCnt == 1 ? 152 - popupTopMargin : 85 - popupTopMargin : popupBtnCnt == 1 ? 189 - popupTopMargin : 107 - popupTopMargin
        firstTextWidth: 210
        firstTextSize: idButton1.firstTextPaintedHeight < 72 ? 36 : 32
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextWrapMode: true

        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupLineCnt < 4 ? popupBgImageY + popupTopMargin + 134 : popupBgImageY + popupTopMargin + 171
        width: 288;
        height: popupLineCnt < 4 ? 134 : 171
        // bgImage: popupLineCnt < 4 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
        bgImagePress: popupLineCnt < 4 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_p.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_p.png" : ""
        bgImageFocus: popupLineCnt < 4 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_f.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_f.png" : ""
        bgImageTop: popupLineCnt < 4 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
        visible: popupBtnCnt == 2

        fgImageX: popupLineCnt < 4 ? 767 - 780 : 773 - 780
        fgImageY: popupLineCnt < 4 ? 50 + 134 - popupTopMargin - 134 : 72 + 164 - popupTopMargin - 171

        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: popupBtnCnt == 2 ? imgFolderPopup+"light.png" : ""
        fgImageVisible: idButton2.activeFocus == true;
        KeyNavigation.up: idButton1
        KeyNavigation.left: idList
        onWheelLeftKeyPressed: idButton1.focus = true
        onWheelRightKeyPressed: idButton1.focus = true

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupLineCnt < 4 ? 85 + 134 - popupTopMargin - 134 : 107 + 171 - popupTopMargin - 171
        firstTextWidth: 210
        firstTextSize: idButton2.firstTextPaintedHeight < 72 ? 36 : 32
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey    
        firstTextWrapMode: true

        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }


    onVisibleChanged: {
        if(visible){
            idList.focus = true;
        }
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }

    //************************ Function ***//
    function giveFocus(focusPosition){
        if(focusPosition == 1) idButton1.focus = true
        else if(focusPosition == 2) idButton2.focus = true
        else if(focusPosition == "contents") idList.focus = true
    }
}
