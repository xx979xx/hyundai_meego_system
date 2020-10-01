import QtQuick 1.0

//import "../../QML/DH" as MComp

//MComp.MBand{
//    id: idInfoCarSettingBand
//    x: 0; y: 0
//    focus : true

//    tabBtnFlag: false
//    subBtnFlag: false
//    titleText: stringInfo.strCarSettingSetting

//    onBackKeyClicked: {
//        console.log(" # InfoCarSettingMain Back")
//        gotoBackScreen()
//    }
//} // End MBand


import "../../Info" as MInfo

MInfo.InfoTypeABand{
    id: idInfoDrivingBand
    x: 0; y:0
    focus : true

    titleText: stringInfo.strCarSettingSetting

    onBackKeyClicked: {
        console.log(" # InfoCarSettingMain Back")
        gotoBackScreen()
    }
} // End InfoTypeABand
