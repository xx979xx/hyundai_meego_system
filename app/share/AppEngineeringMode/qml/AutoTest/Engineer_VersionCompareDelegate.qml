import Qt 4.7
import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import com.engineer.data 1.0


Item{
    id:delegate
//    x:0; y:0
    width:1280 ; height: 40/*50*/;
    property int countryInfo: VariantSetting.GetCountryInfo();
    //    Component.onCompleted:{
    //        if(countryInfo == 1)
    //        {
    //            if(index == 4 )
    //            {
    //                delegate.secondFontSize = 11
    //            }
    //        }
    //    }

    property int mButtonX : 0
    property int mButtonY : 0
    property int mBtnFullNum  : 0

    property int mTextInputX : 0
    property int mTextInputY : 0
    property int mTextInputFullNum : 0
    property int secondFontSize: 15
    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id : colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    Row{
                //First Line /Module/Release Version/ Read Version/ Comp Rst
                Rectangle
                {
                    id: idModuleIndex
                    x:10/*40*/; /*y: 70*/
                    width:100; height:40
                    color:colorInfo.transparent
                    border.color : colorInfo.buttonGrey
                    border.width : 5
                    MComp.Label{
                        id: idModuleIndexTxt
                        anchors.fill: parent
//                        x: 20
                        text: moduleName/*"Module"*/
                        fontColor: colorInfo.dimmedGrey
                        fontSize: 15
                       txtAlign: "Center"
                        fontName: "HDR"
                    }
                }
                Rectangle
                {
                    id: idReleaseVerIndex
                    x:110/*140*/;/* y: 70*/
                    width:225; height:40/*50*/
                    color:colorInfo.transparent
                    border.color : colorInfo.buttonGrey
                    border.width : 5
                    MComp.Label{
                        id:idReleaseVerIndexTxt
                        anchors.fill: parent
//                        x: 20
                        text: releaseVersion/*"Release Version"*/
                        fontColor: colorInfo.dimmedGrey
                        fontSize: 15
                       txtAlign: "Center"
                        fontName: "HDR"
                    }
                }
                Rectangle
                {
                    id: idReadVerIndex
                    x:335/*340*/; /*y: 70*/
                    width:225; height:40/*50*/
                    color:colorInfo.transparent
                    border.color : colorInfo.buttonGrey
                    border.width : 5
                    MComp.Label{
                        id: idReadVerIndexTxt
                        anchors.fill: parent
//                        x: 20
                        text: readVersion/*"Read Version"*/
                        fontColor: colorInfo.dimmedGrey
                        fontSize: 15
                       txtAlign: "Center"
                        fontName: "HDR"
                    }
                }
                Rectangle
                {
                    id: idCompResult
                    x: 560/*540*/; /*y: 70*/
                    width:50; height:40/*50*/
                    color:colorInfo.transparent
                    border.color : colorInfo.buttonGrey
                    border.width : 5
                    MComp.Label{
                        id: idCompResultTxt
                        anchors.fill: parent
                        //x: 20
                        text: result/*"Result"*/
                        fontColor: resultColor/*colorInfo.dimmedGrey*/
                        fontSize: 15
                        txtAlign: "Center"
                        fontName: "HDR"
                    }
                }

                Rectangle
                {
                    id: idSecondModuleIndex
                    x:650/*640*/; /*y: 70*/
                    width:100; height:40/*50*/
                    color:colorInfo.transparent
                    border.color : colorInfo.buttonGrey
                    border.width : 5
                    MComp.Label{
                        id: idSecondModuleIndexTxt
                        anchors.fill: parent
//                        x: 20
                        text: moduleName2/*"Module"*/
                        fontColor: colorInfo.dimmedGrey
                        fontSize: 15
                       txtAlign: "Center"
                        fontName: "HDR"
                    }
                }
                Rectangle
                {
                    id: idSecondReleaseVerIndex
                    x:750/*740*/; /*y: 70*/
                    width:225/*200*/; height:40/*50*/
                    color:colorInfo.transparent
                    border.color : colorInfo.buttonGrey
                    border.width : 5
                    MComp.Label{
                        id:idSecondReleaseVerIndexTxt
                        anchors.fill: parent
//                        x: 20
                        text: releaseVersion2 /*"Release Version"*/
                        fontColor: colorInfo.dimmedGrey
                        fontSize: secondFontSize/*15*/
                       txtAlign: "Center"
                        fontName: "HDR"
                    }
                }
                Rectangle
                {
                    id: idSecondReadVerIndex
                    x:975/*940*/; /*y: 70*/
                    width:250/*200*/; height:40/*50*/
                    color:colorInfo.transparent
                    border.color : colorInfo.buttonGrey
                    border.width : 5
                    MComp.Label{
                        id: idSecondReadVerIndexTxt
                        anchors.fill: parent
//                        x: 20
                        text: readVersion2/*"Read Version"*/
                        fontColor: colorInfo.dimmedGrey
                        fontSize: secondFontSize/*15*/
                       txtAlign: "Center"
                        fontName: "HDR"
                    }
                }
                Rectangle
                {
                    id: idSecondCompResult
                    x:1225/*1140*/; /*y: 70*/
                    width:50; height:40/*50*/
                    color:colorInfo.transparent
                    border.color : colorInfo.buttonGrey
                    border.width : 5
                    MComp.Label{
                        id: idSecondCompResultTxt
                        anchors.fill: parent
                        //x: 20
                        text: result2/*"Result"*/
                        fontColor: resultColor2/*colorInfo.dimmedGrey*/
                        fontSize: 15
                        txtAlign: "Center"
                        fontName: "HDR"
                    }
                }
        }

}
