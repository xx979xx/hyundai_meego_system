import QtQuick 1.0
import "../../QML/DH" as MComp

Item {
    id:idEngRestrictionDriving
    x:0; y:0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb: imageInfo.imgFolderDmb
    property bool isEnglishText: ( (idAppMain.languageType != 2) && (idAppMain.drivingRestriction == true) && (idDmbENGModeMain.state == "ENGOn") ) ? true : false

//    idDmbENGModeMain.state == "ENGOn"
//    idDmbENGModeMain.state == "ENGOff"

    function changeLanguage()
    {
        if(idAppMain.languageType != 2 && idDmbENGModeMain.state == "ENGOn")
        {
            isEnglishText = true
        }
        else
        {
            isEnglishText = false
        }

    }

    //--------------------- Bg Image #
    Image {
        id: mainbackgroundEng
        height: parent.height
        //y: 0 - systemInfo.statusBarHeight
        //height: systemInfo.lcdHeight_VEXT
        source: imgFolderGeneral + "bg_main.png"
    } // End Image

    //--------------------- Image #
    Image {
        id: imgBlockEng
        x: (idDmbENGModeMain.state == "ENGOff")?100+462:535+277
        y: 299-systemInfo.statusBarHeight
        width:162; height:161
        source: imgFolderGeneral + "ico_block.png";
    } // End Image

    //--------------------- First Text #
    MComp.MText {
        id: idFirstTextEng
        mTextX: (idDmbENGModeMain.state == "ENGOff") ? 0 : 535
        mTextY: imgBlockEng.y+178
        mTextWidth: (idDmbENGModeMain.state == "ENGOff") ? systemInfo.lcdWidth : 277+453
        mText: stringInfo.strChSignal_Restriction_Driving1
        mTextColor:colorInfo.grey//colorInfo.brightGrey
        mTextStyle: idAppMain.fontsR
        mTextSize: 32
        mTextHorizontalAlies: "Center"
        mTextVisible: (isEnglishText == false)
    } // End MText

    //--------------------- Second Text #
    MComp.MText {
        id: idSecondTextEng
        mTextX: (idDmbENGModeMain.state == "ENGOff") ? 0 : 535
        mTextY: idFirstTextEng.mTextY+50
        mTextWidth: (idDmbENGModeMain.state == "ENGOff") ? systemInfo.lcdWidth : 277+453+15
        mText: stringInfo.strChSignal_Restriction_Driving2
        mTextColor: colorInfo.grey//colorInfo.brightGrey
        mTextStyle: idAppMain.fontsR
        mTextSize: 32
        mTextHorizontalAlies: "Center"
        mTextVisible: (isEnglishText == false)
    } // End MText

    //--------------------- EnglishText , Driving Text #
    MComp.MText {
        id: idEnglishText
        mTextX: 535/*+50*/
        mTextY: imgBlockEng.y+178
        mTextWidth: /*systemInfo.lcdWidth-(535+10+(50*2))*/277+453+15
        mText: stringInfo.strChSignal_Restriction_Driving1 + " " + stringInfo.strChSignal_Restriction_Driving2
        mTextColor: colorInfo.grey//colorInfo.brightGrey
        mTextStyle: idAppMain.fontsR
        mTextSize: 32
        mTextHorizontalAlies: "Center"
        mTextWrapMode: "WordWrap"
        mTextVisible: (isEnglishText == true)
    } // End MText

    Connections{
        target: EngineListener
        onRetranslateUi:{ changeLanguage() }
    }

//    Connections{
//        target: CommParser
//        onIsFullScreenChanged:{ changeLanguage() }
//    }

    Connections{
        target: EngineListener
        onModeDRSChanged:{ changeLanguage() }
    }

    Component.onCompleted: { changeLanguage() }
    onVisibleChanged: { changeLanguage() }

} // End Item
