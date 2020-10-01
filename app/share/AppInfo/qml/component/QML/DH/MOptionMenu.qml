/**
 * FileName: MOptionMenu.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 */
import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent { // FocusScope { // # (for "onClickMenuKey" use) by HYANG #
    id: idMOptionMenu
    x:0; y:0; z: parent.z + 1
    //width: opWidth;
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    property QtObject linkedModels
    property string menuDepth: "OneDepth" //"OneDepth" or "TwoDepth" # added by HYANG_20120228

    //--------------------- OptionMenu Info(Property) #
    property int opWidth: menuDepth=="OneDepth"? systemInfo.lcdWidth - 867 : systemInfo.lcdWidth - 892         // 413 : 388
    property int opLeftMargine: menuDepth=="OneDepth"? 69 : 63

    //--------------------- Title Info(Property) #
    property int titleY: 45
    property int titleFontSize: 34
    property string titleFontName: "HDBa1"
    property string titleText: "Menu"		//# by HYANG

    //--------------------- Delegate Info(Property) #
    property int delegateWidth: menuDepth=="OneDepth"? listLeftMargine + itemWidth : listLeftMargine + itemWidth + 12      // 26+305=331 : 312
    //--------------------- Item Text Info(Property) ##
    property int itemLeftMargin: opLeftMargine + listLeftMargine // 69+26=95
    property int itemWidth: menuDepth=="OneDepth"? 305 : 269
    property int itemHeight: 78
    property int itemItemFontSize : 32
    property string itemItemFontName: "HDBa1"

    //--------------------- Dim Info(Property) #
    property bool menu0Dimmed
    property bool menu1Dimmed
    property bool menu2Dimmed
    property bool menu3Dimmed
    property bool menu4Dimmed
    property bool menu5Dimmed
    property bool menu6Dimmed
    property bool menu7Dimmed
    property bool menu8Dimmed
    property bool menu9Dimmed
    property bool menu10Dimmed
    property bool menu11Dimmed
    property bool menu12Dimmed
    property bool menu13Dimmed
    property bool menu14Dimmed
    property bool menu15Dimmed

    //--------------------- List Info(Property) ##
    property int listAreaWidth: opWidth-opLeftMargine            // 413-69=344
    property int listLeftMargine : menuDepth=="OneDepth"? 26 : 31

    //--------------------- Line Info(Property) ##
    property int lineY: 130+38-systemInfo.statusBarHeight        // 130+38-93=75
    property int lineWidth: delegateWidth
    property int lineHeight: 2

    //--------------------- Scroll Info(Property) ##
    property int scrollWidth: listAreaWidth - delegateWidth      // 344-331=13
    property int scrollY: 5

    //--------------------- RadioSeleted Info(Property) ##
    property int selectedRadioIndex: 0

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //--------------------- Default Click Event(Signal) #
    signal menu0Click()
    signal menu1Click()
    signal menu2Click()
    signal menu3Click()
    signal menu4Click()
    signal menu5Click()
    signal menu6Click()
    signal menu7Click()
    signal menu8Click()
    signal menu9Click()
    signal menu10Click()
    signal menu11Click()
    signal menu12Click()
    signal menu13Click()
    signal menu14Click()
    signal menu15Click()

    //--------------------- Radio Click Event(Signal) #
    signal radio0Click()
    signal radio1Click()
    signal radio2Click()
    signal radio3Click()
    signal radio4Click()
    signal radio5Click()
    signal radio6Click()
    signal radio7Click()
    signal radio8Click()
    signal radio9Click()
    signal radio10Click()
    signal radio11Click()
    signal radio12Click()
    signal radio13Click()
    signal radio14Click()
    signal radio15Click()

    //--------------------- DimCheck Click Event(Signal) #
    signal dimCheck0Click()
    signal dimCheck1Click()
    signal dimCheck2Click()
    signal dimCheck3Click()
    signal dimCheck4Click()
    signal dimCheck5Click()
    signal dimCheck6Click()
    signal dimCheck7Click()
    signal dimCheck8Click()
    signal dimCheck9Click()
    signal dimCheck10Click()
    signal dimCheck11Click()
    signal dimCheck12Click()
    signal dimCheck13Click()
    signal dimCheck14Click()
    signal dimCheck15Click()

    //--------------------- DimUncheck Click Event(Signal) #
    signal dimUncheck0Click()
    signal dimUncheck1Click()
    signal dimUncheck2Click()
    signal dimUncheck3Click()
    signal dimUncheck4Click()
    signal dimUncheck5Click()
    signal dimUncheck6Click()
    signal dimUncheck7Click()
    signal dimUncheck8Click()
    signal dimUncheck9Click()
    signal dimUncheck10Click()
    signal dimUncheck11Click()
    signal dimUncheck12Click()
    signal dimUncheck13Click()
    signal dimUncheck14Click()
    signal dimUncheck15Click()

    //--------------------- Default Click Event(Function) #
    function indexEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.menu0Click(); break; } // End case
        case 1:{ idMOptionMenu.menu1Click(); break; } // End case
        case 2:{ idMOptionMenu.menu2Click(); break; } // End case
        case 3:{ idMOptionMenu.menu3Click(); break; } // End case
        case 4:{ idMOptionMenu.menu4Click(); break; } // End case
        case 5:{ idMOptionMenu.menu5Click(); break; } // End case
        case 6:{ idMOptionMenu.menu6Click(); break; } // End case
        case 7:{ idMOptionMenu.menu7Click(); break; } // End case
        case 8:{ idMOptionMenu.menu8Click(); break; } // End case
        case 9:{ idMOptionMenu.menu9Click(); break; } // End case
        case 10:{ idMOptionMenu.menu10Click(); break; } // End case
        case 11:{ idMOptionMenu.menu11Click(); break; } // End case
        case 12:{ idMOptionMenu.menu12Click(); break; } // End case
        case 13:{ idMOptionMenu.menu13Click(); break; } // End case
        case 14:{ idMOptionMenu.menu14Click(); break; } // End case
        case 15:{ idMOptionMenu.menu15Click(); break; } // End case
        } // End switch
        console.log(" [MOptionMenu] indexEvent(index) : ", index)
    } // End function

    //--------------------- Radio Click Event(Function) #
    function radioEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.radio0Click(); break; } // End case
        case 1:{ idMOptionMenu.radio1Click(); break; } // End case
        case 2:{ idMOptionMenu.radio2Click(); break; } // End case
        case 3:{ idMOptionMenu.radio3Click(); break; } // End case
        case 4:{ idMOptionMenu.radio4Click(); break; } // End case
        case 5:{ idMOptionMenu.radio5Click(); break; } // End case
        case 6:{ idMOptionMenu.radio6Click(); break; } // End case
        case 7:{ idMOptionMenu.radio7Click(); break; } // End case
        case 8:{ idMOptionMenu.radio8Click(); break; } // End case
        case 9:{ idMOptionMenu.radio9Click(); break; } // End case
        case 10:{ idMOptionMenu.radio10Click(); break; } // End case
        case 11:{ idMOptionMenu.radio11Click(); break; } // End case
        case 12:{ idMOptionMenu.radio12Click(); break; } // End case
        case 13:{ idMOptionMenu.radio13Click(); break; } // End case
        case 14:{ idMOptionMenu.radio14Click(); break; } // End case
        case 15:{ idMOptionMenu.radio15Click(); break; } // End case
        } // End switch
        console.log(" [MOptionMenu] radioEvent(index) : ", index)
    } // End function

    //--------------------- DimCheck Click Event(Function) #
    function dimCheckEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.dimCheck0Click(); break; } // End case
        case 1:{ idMOptionMenu.dimCheck1Click(); break; } // End case
        case 2:{ idMOptionMenu.dimCheck2Click(); break; } // End case
        case 3:{ idMOptionMenu.dimCheck3Click(); break; } // End case
        case 4:{ idMOptionMenu.dimCheck4Click(); break; } // End case
        case 5:{ idMOptionMenu.dimCheck5Click(); break; } // End case
        case 6:{ idMOptionMenu.dimCheck6Click(); break; } // End case
        case 7:{ idMOptionMenu.dimCheck7Click(); break; } // End case
        case 8:{ idMOptionMenu.dimCheck8Click(); break; } // End case
        case 9:{ idMOptionMenu.dimCheck9Click(); break; } // End case
        case 10:{ idMOptionMenu.dimCheck10Click(); break; } // End case
        case 11:{ idMOptionMenu.dimCheck11Click(); break; } // End case
        case 12:{ idMOptionMenu.dimCheck12Click(); break; } // End case
        case 13:{ idMOptionMenu.dimCheck13Click(); break; } // End case
        case 14:{ idMOptionMenu.dimCheck14Click(); break; } // End case
        case 15:{ idMOptionMenu.dimCheck15Click(); break; } // End case
        } // End switch
        console.log(" [MOptionMenu] dimCheckEvent(index) : ",index)
        console.log(" [MOptionMenu] check state : off => on")
    } // End function

    //--------------------- DimUncheck Click Event(Function) #
    function dimUncheckEvent(index){
        switch(index){
        case 0:{ idMOptionMenu.dimUncheck0Click(); break; } // End case
        case 1:{ idMOptionMenu.dimUncheck1Click(); break; } // End case
        case 2:{ idMOptionMenu.dimUncheck2Click(); break; } // End case
        case 3:{ idMOptionMenu.dimUncheck3Click(); break; } // End case
        case 4:{ idMOptionMenu.dimUncheck4Click(); break; } // End case
        case 5:{ idMOptionMenu.dimUncheck5Click(); break; } // End case
        case 6:{ idMOptionMenu.dimUncheck6Click(); break; } // End case
        case 7:{ idMOptionMenu.dimUncheck7Click(); break; } // End case
        case 8:{ idMOptionMenu.dimUncheck8Click(); break; } // End case
        case 9:{ idMOptionMenu.dimUncheck9Click(); break; } // End case
        case 10:{ idMOptionMenu.dimUncheck10Click(); break; } // End case
        case 11:{ idMOptionMenu.dimUncheck11Click(); break; } // End case
        case 12:{ idMOptionMenu.dimUncheck12Click(); break; } // End case
        case 13:{ idMOptionMenu.dimUncheck13Click(); break; } // End case
        case 14:{ idMOptionMenu.dimUncheck14Click(); break; } // End case
        case 15:{ idMOptionMenu.dimUncheck15Click(); break; } // End case
        } // End switch
        console.log(" [MOptionMenu] dimUncheckEvent(index) : ",index)
        console.log(" [MOptionMenu] check state : on => off")
    } // End function

    //--------------------- Visible change(Function) #
    onVisibleChanged: { if(visible) idMOptionMenu.focus = true }

    //--------------------- Focus change(Function) #
    onFocusChanged: { console.log(" [MOptionMenu] idMOptionMenu focus: "+ idMOptionMenu.focus) }

    //--------------------- Dim Background Image #
    Image {
        id: imgBgDim
        x: 0; y: systemInfo.statusBarHeight
        width: systemInfo.lcdWidth-delegateWidth
        height: parent.height-systemInfo.statusBarHeight
        source: imgFolderGeneral + "bg_optionmenu_dim.png"
        visible: menuDepth == "OneDepth"
    } // End Image

    //--------------------- Option Menu #
    Item{
        id: idOptionMenu
        anchors.right: parent.right
        width: opWidth

        //--------------------- Background Image ##
        Image{
            id: imgBg
            source: imgFolderGeneral + "bg_optionmenu.png"
        } // End Image

        //--------------------- Title Text ##
        Text{ // Time Font(HDB, 34pt)
            id: txtTitle
            text: titleText
            x: itemLeftMargin; y: titleY-(titleFontSize/2)
            width: delegateWidth; height: titleFontSize
            color: colorInfo.subTextGrey
            font.family: titleFontName
            font.pixelSize: titleFontSize
            verticalAlignment: Text.AlignVCenter
        } // End Text

        //--------------------- OptionMenu List ##
        MOptionMenuList{
            id: idMOptionMenuList
            //  focus: true // # (focus disappears problem) by HYANG #
            x: opLeftMargine; y: systemInfo.statusBarHeight
            width: listAreaWidth; height: systemInfo.subMainHeight
        } // End MOptionMenuList
    } // End Item
} // End MComponent
