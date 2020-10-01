/**
 * FileName: MListPopup.qml
 * Author: jyjeon
 * Time: 2012-02-22
 *
 * - 2012-02-22 Initial Crated by jyjeon
 */
import QtQuick 1.0

MComponent {
    id: idListPopup
    x: 0; y: systemInfo.statusBarHeight
    width: parent.width; height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    //--------------------- List Click Event #
    signal listClicked(int listIndex)

    //--------------------- Button Click Event #
    signal btn0Click()
    signal btn1Click()
    signal btn2Click()
    signal btn3Click()

    //--------------------- Model Info #
    property QtObject btnModel
    property QtObject listModel

    //--------------------- Popup Info #
    property int popupX: 204
    property int popupY: 190-systemInfo.statusBarHeight // 97
    property int popupWidth: 875
    property int popupHeight: titleAreaHeight + msgAreaHeight  + btnAreaHeight + 5
    property int popupBottomMargin: 15

    //--------------------- Title Area Info #
    property int titleLineNum: 2 // (2 or 1)
    property int titleAreaWdith: popupWidth
    property int titleAreaHeight: (titleLineNum == 2) ? (2*47-47/2) + 56 : 2*(35+20) //setTitleAreaHeight()

    //--------------------- Title Text Info(General) #
    property int titleTextX: 32
    property int titleTextY: 47
    property int titleTextWdith: popupWidth-(45*2)
    property int titleTextHeight:  titleTextSize * titleLineNum
    property int titleTextSize: (titleLineNum == 2) ? 36 : 44
    property string titleTextName: systemInfo.hdb
    property string titleTextAlies: "Left"
    property string titleTextColor : colorInfo.brightGrey //"#B6C9FF" //RGB(182,201,255)
    //--------------------- Title Text Info(1) ##
    property string titleText1: ""
    property int titleText1Y: (titleLineNum == 2) ? 47-(titleTextSize/2) : 47+47-(titleTextSize/2)
    //--------------------- Title Text Info(2) ##
    property string titleText2: ""
    property int titleText2Y: (titleLineNum == 2) ? 47*2-(titleTextSize/2) : 0

    //--------------------- Message Area Info #
    //property int msgAreaX: popupX
    //property int msgAreaY: titleAreaHeight
    property int msgAreaWidth: popupWidth //783
    property int msgAreaHeight: 88*3//84*(listModel.count) + 2*(listModel.count-1)
    //--------------------- Message Text Info ##
    property int msgTextX: 0  // 42
    property int msgTextY: (titleLineNum == 2) ? titleAreaHeight : titleAreaHeight + popupBottomMargin
    property int msgTextSize: 21
    property string msgTextName: systemInfo.hdb
    property string msgTextAlies: "Center"

    //--------------------- Button Area Info #
    property int btnAreaX: 0                                  // Set function
    property int btnAreaY: (titleLineNum == 2) ? titleAreaHeight + msgAreaHeight : titleAreaHeight + msgAreaHeight + popupBottomMargin
    property int btnAreaWidth: popupWidth                              // Set function
    property int btnAreaHeight: (titleLineNum == 2) ? 113*(!(btnModel.count==0)) - popupBottomMargin : 113*(!(btnModel.count==0))
    //--------------------- Button Image Info ##
    property int btnWidth: 206
    property int btnHeight: 70
    //--------------------- Button Text Info ##
    property int btnTextX: 0
    property int btnTextY: 36
    property int btnTextSize: 30
    property string btnTextName: systemInfo.hdb
    property string btnTextAlies: "Center"

    //--------------------- Scroll Info #
    property int scrollWidth: 13
    property int scrollY: 16

    //--------------------- Image Path Info #
    property string imgFolderPopup : imageInfo.imgFolderPopup

    //--------------------- Dim Info(Property) #
    property bool menu0Dimmed: false
    property bool menu1Dimmed: false
    property bool menu2Dimmed: false
    property bool menu3Dimmed: false
    property bool menu4Dimmed: false
    property bool menu5Dimmed: false
    property bool menu6Dimmed: false
    property bool menu7Dimmed: false
    property bool menu8Dimmed: false
    property bool menu9Dimmed: false
    property bool menu10Dimmed: false

    //--------------------- Set action of Button
    function btnClickEvent(index){
        switch(index){
        case 0:{ idListPopup.btn0Click(); break; } // End case
        case 1:{ idListPopup.btn1Click(); break; } // End case
        case 2:{ idListPopup.btn2Click(); break; } // End case
        case 3:{ idListPopup.btn3Click(); break; } // End case
        default:{ console.log(" # Can't have ClickEvent !"); break; } // End default
        } // End switch
    } // End function

    //--------------------- Set Wdith of button area
    function setBtnAreaWidth(){
        btnAreaWidth = btnWidth*listBtnPopup.count
        //console.log(" # Exec function setBtnAreaWidth(), btnAreaWidth : ",btnAreaWidth)
        setBtnAreaX(btnAreaWidth)
    } // End function

    //--------------------- Set X of button area
    function setBtnAreaX(btnAreaWidth){
        btnAreaX = (popupWidth-btnAreaWidth)/2
        //console.log(" # Exec function setBtnAreaX(), btnAreaX : ",btnAreaX)
    } // End function

    //--------------------- Under Screen Disable
    MouseArea{ anchors.fill: parent }
    //--------------------- Background Black 70%
    Rectangle{
        id:bgDim
        x: 0; y: parent.y
        width: systemInfo.lcdWidth
        height: parent.height
        color: colorInfo.black
        opacity: 0.6
    } // End Rectangle

    //--------------------- visible/focus change #
    onVisibleChanged: { if(visible) idListPopup.focus = true }
    onFocusChanged: { console.log(" ==>idListPopup focus: "+ idListPopup.focus) }

    //--------------------- MsgPopup #
    Item {
        id: idPopup
        x: popupX; y: popupY; z:1
        width: popupWidth; height: popupHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        //--------------------- Background Image ##
        Image{
            id: imgBg
            width: popupWidth ; height: popupHeight
            source: (listModel.count < 3)? imgFolderPopup + "popup_c_01_bg.png" : imgFolderPopup + "popup_c_02_bg.png"
        } // End Image

        //--------------------- # Title Text Line1 ##
        Text{
            id: idTitleText1
            text: titleText1
            x: titleTextX; y: titleText1Y-(titleTextSize/2)
            width: titleTextWdith; height: titleTextHeight
            color: titleTextColor
            font.family: titleTextName
            font.pixelSize: titleTextSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: {
                if(titleTextAlies=="Right"){Text.AlignRight}
                else if(titleTextAlies=="Left"){Text.AlignLeft}
                else if(titleTextAlies=="Center"){Text.AlignHCenter}
                else {Text.AlignHCenter}
            }
        } // End Text
        //--------------------- # Title Text Line2 ##
        Text{
            id: idTitleText2
            text: (titleLineNum == 2) ? titleText2 : ""
            x: titleTextX; y: titleText2Y-(titleTextSize/2)
            width: titleTextWdith; height: titleTextHeight
            color: titleTextColor
            font.family: titleTextName
	    font.pixelSize: titleTextSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: {
                if(titleTextAlies=="Right"){Text.AlignRight}
                else if(titleTextAlies=="Left"){Text.AlignLeft}
                else if(titleTextAlies=="Center"){Text.AlignHCenter}
                else {Text.AlignHCenter}
            }
        } // End Text

        //--------------------- Message ListView ##
        FocusScope{
            id: idListMsgPopup
            x: msgTextX; y: msgTextY
            width: msgAreaWidth-scrollWidth; height: msgAreaHeight
            focus: true
            KeyNavigation.down : idBtnPopup

            ListView {
                id: listMsgPopup
                height: 84*3
                width: msgAreaWidth;
                //anchors.fill: parent;
                clip: true
                focus: true
                model: listModel
                delegate: MListPopupListDelegate{}
                orientation : ListView.Vertical
                snapMode: ListView.SnapToItem
                boundsBehavior: Flickable.StopAtBounds
                anchors.verticalCenter: parent.verticalCenter
            } // End ListView

            //--------------------- ScrollBar #
            MScroll {
                id: idListMsgPopupScroll
                x: 850
                scrollArea: listMsgPopup;
                height: listMsgPopup.height-(scrollY*2); width: scrollWidth
                visible: (listModel.count > 3)
                selectedScrollImage: imgFolderPopup+"scroll_bell_bg.png"
                anchors.verticalCenter: parent.verticalCenter
            } // End MScroll
        } // End Item

        //--------------------- Button ListView ##
        FocusScope{
            id: idBtnPopup
            x: btnAreaX; y: btnAreaY
            width: btnAreaWidth; height: btnAreaHeight
            KeyNavigation.up : idListMsgPopup

            ListView {
                id: listBtnPopup
                width: btnWidth ; height: btnAreaHeight
                focus: true
                anchors.fill: parent;
                model: btnModel
                delegate: MMsgPopupBtnDelegate{}
                orientation : ListView.Horizontal
                snapMode: ListView.SnapToItem
                boundsBehavior: Flickable.StopAtBounds

                Component.onCompleted: {
                    setBtnAreaWidth()
                    //console.log(" # listBtnPopup.count : "+listBtnPopup.count)
                }
            } // End ListView
        } // End FocusScope
    } // End Item
} // End FocusScope
