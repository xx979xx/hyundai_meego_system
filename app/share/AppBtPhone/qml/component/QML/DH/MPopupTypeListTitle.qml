/**
 * MPopupTypeListTitle.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MComponent
{
    id: idMPopupTypeListTitle
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupName

    property string popupBgImage: (popupLineCnt < 4) ? ImagePath.imgFolderPopup+"bg_type_d.png" :  ImagePath.imgFolderPopup+"bg_type_e.png"
    property int popupBgImageX: 93
    property int popupBgImageY: (popupLineCnt < 4) ? 168 - systemInfo.statusBarHeight : 131 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: (popupLineCnt < 4) ? 384 : 459

    property string popupTitleText: ""
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 2    //# 1 or 2
    property QtObject idListModel
    property string listFirstItem

    property int selectedItemIndex: 0           //# indexNumber of selectedItem
    property int popupLineCnt: idListView.count //# 1 ~ use input
    property int overContentCount

    // SIGNALS
    signal popupClicked();
    signal popupBgClicked();
    signal popuplistItemClicked(int selectedItemIndex);
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    onClickOrKeySelected: {
        popupBgClicked()
    }

    Component.onCompleted: {
        if(idMPopupTypeListTitle.visible) {
            idListView.forceActiveFocus()
            idListView.currentIndex = 0
            popupBackGroundBlack = true
        }
    }

    onVisibleChanged: {
        if(idMPopupTypeListTitle.visible) {
            idListView.forceActiveFocus()
            idListView.currentIndex = 0
            popupBackGroundBlack = true
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }


    /* WIDGETS */
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    Image {
        source: popupBgImage
        x: popupBgImageX
        y: popupBgImageY
        width: popupBgImageWidth
        height: popupBgImageHeight
    }

    Text{
        id: idTitle
        text: popupTitleText
        x: popupBgImageX + 55
        y: popupBgImageY + 59 - 44 / 2
        width: 983; height: 44
        font.pointSize: 44
        font.family: stringInfo.fontFamilyBold    //"HDB"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        elide: Text.ElideRight
    }

    FocusScope {
        id: idList
        x: popupBgImageX + 26;
        y: popupLineCnt == 1 ? popupBgImageY + 190 : popupLineCnt == 2 ? popupBgImageY + 149 : popupLineCnt == 3 ? popupBgImageY + 108 : popupBgImageY + 104
        width: 740; height: popupLineCnt < 4 ? (popupLineCnt * 82) : 4 * 82
        focus: true
        KeyNavigation.right: idButton1

        ListView{
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
                overContentCount = contentY/(contentHeight/count)
            }
        }

        MRoundScroll {
            x: 776 - 26;
            y: 37 - 24
            scrollWidth: 39;
            scrollHeight: 306
            scrollBgImage: idListView.count > 4 ? ImagePath.imgFolderPopup + "scroll_bg.png" : ""
            scrollBarImage: idListView.count > 4 ? ImagePath.imgFolderPopup + "scroll.png" : ""
            listCountOfScreen: 4
            moveBarPosition: idListView.height/idListView.count*overContentCount
            listCount: idListView.count
            visible: (idListView.count > 4)
        }

        Component{
            id: idListDelegate
            MButton{
                id: idItemDelegate
                x: 0; y: 0
                width: 740; height: 82
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: listFirstItem
                firstTextX: 69 - 26
                firstTextY: 152 - 110 - 16
                firstTextWidth: 677 //654 가이드 상의 넓이 임의의 넓이 677
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextAlies: "Left"
                firstTextColor: colorInfo.subTextGrey

                fgImage: ImagePath.imgFolderPopup + "list_line.png"
                fgImageX: 36 - 26
                fgImageY: 82
                fgImageWidth: 732
                fgImageHeight: 2
                fgImageVisible: index != popupLineCnt

                onClickOrKeySelected: {        
                    selectedItemIndex = index
                    popuplistItemClicked(selectedItemIndex);
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

    MButton {
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 105
        width: 288;
        height: popupLineCnt < 4 ? popupBtnCnt == 1 ? 254 : 127 : popupBtnCnt == 1 ? 329 : 164
        bgImage: popupLineCnt < 4 ? popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png" : popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_b_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_01_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_02_n.png"
        bgImagePress: popupLineCnt < 4 ? popupBtnCnt == 1 ? ImagePath.imgFolderPopup+"btn_type_a_01_p.png" : ImagePath.imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 1 ? ImagePath.imgFolderPopup+"btn_type_b_01_p.png" : ImagePath.imgFolderPopup+"btn_type_b_02_p.png"
        bgImageFocus: popupLineCnt < 4 ? popupBtnCnt == 1 ? ImagePath.imgFolderPopup+"btn_type_a_01_f.png" : ImagePath.imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 1 ? ImagePath.imgFolderPopup+"btn_type_b_01_f.png" : ImagePath.imgFolderPopup+"btn_type_b_02_f.png"
        visible: popupBtnCnt == 1 || popupBtnCnt == 2

        fgImageX: popupLineCnt < 4 ? popupBtnCnt == 1 ? 773 - 780 : 767 - 780 : popupBtnCnt == 1 ? 778 - 780 : 773 - 780
        fgImageY: popupLineCnt < 4 ? popupBtnCnt == 1 ? 117 - 25 : 50 - 25 : popupBtnCnt == 1 ? 154 - 25 : 72 - 25
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: ImagePath.imgFolderPopup+"light.png"
        fgImageVisible: true == idButton1.activeFocus

        KeyNavigation.left: idList

        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupLineCnt < 4 ? popupBtnCnt == 1 ? 152 - 25 - 36/2 : 85 - 25 - 36/2 : popupBtnCnt == 2 ? 189 - 25 - 36 : 107 - 25
        firstTextWidth: 210
        firstTextHeight: 36
        firstTextSize: 36
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupLineCnt < 4 ? popupBgImageY + 105 + 127 : popupBgImageY + 105 + 164
        width: 288;
        height: popupLineCnt < 4 ? 127 : 164
        bgImage: popupLineCnt < 4 ? popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup+"btn_type_a_03_n.png" : "" : popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_0_nf.png" : (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_03_n.png" : ""
        bgImagePress: popupLineCnt < 4 ? popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_03_p.png" : "" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_b_03_p.png" : ""
        bgImageFocus: popupLineCnt < 4 ? popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_03_f.png" : "" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_b_03_f.png" : ""
        visible: popupBtnCnt == 2

        fgImageX: popupLineCnt < 4 ? 767 - 780 : 773 - 780
        fgImageY: popupLineCnt < 4 ? 50 + 134 - 25 - 127 : 72 + 164 - 25 - 164
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "light.png" : ""
        fgImageVisible: true == idButton2.activeFocus

        KeyNavigation.left: idList

        onWheelLeftKeyPressed: idButton1.focus = true
        onWheelRightKeyPressed: idButton1.focus = true

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupLineCnt < 4 ? 85 + 134 - 25 - 127 - 36 / 2 : 107 + 164 - 25 - 164 - 36 / 2
        firstTextWidth: 210
        firstTextHeight: 36
        firstTextSize: 36
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }
}
/* EOF */
