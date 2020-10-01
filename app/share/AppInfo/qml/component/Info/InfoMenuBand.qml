import QtQuick 1.0

//import "../QML/DH" as MComp

//MComp.MBand{
//    id: idInfoMenuBand
//    x: 0; y: 0
//    focus : true

//    tabBtnFlag: false
//    subBtnFlag: false
//    titleText: stringInfo.strAutoCare

//    onBackKeyClicked: {
//        console.log(" # [InfoMenuBand] Back")
//        gotoBackScreen()
//    }
//} // End MBand


import "../Info" as MInfo

MInfo.InfoTypeABand{
    id: idInfoMenuBand
    x: 0; y:0
    focus : true

    titleText: stringInfo.strAutoCare

    //onClickOrKeySelected: { gotoBackScreen() }
//    onBackKeyClicked: {
//        console.log(" # [InfoMenuBand11] Back")
//        gotoBackScreen()
//    }
} // End InfoTypeABand
