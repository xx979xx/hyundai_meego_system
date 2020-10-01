/**
 * FileName: RadioRdsMain.qml
 * Author: HYANG
 * Time: 2012-06
 *
 * - Initial Created by HYANG
 * - 20130130 modified by qutiguy - implement new gui for rds(based on 2012.12.14 UX)
 */

import Qt 4.7
import QtQuick 1.1 //KSW 131212 for KH
//import QtQuick 1.0 //KSW 131212 for KH

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idRadioRdsMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    property string imgFolderRadio_Rds : imageInfo.imgFolderRadio_Rds
    property string imgFolderRadio_Dab : imageInfo.imgFolderRadio_Dab
    //// 2013.10.31 added by qutiguy : ITS 196126
    property bool   interruptChannelChange       : false
    property int    interruptChangedIndex        : -1

    //KSW 140107 ITS/219032
    property bool   bIsScan : false


    property bool   bFocusIsTune : false //dg.jin 20140901 ITS 0247678 tune focus issue
    //////////////////////////////////////////////////////////
    // JSH 120306
    property string  stopSentMenu  : ""

    //////TA Info Service/////////////////////////////
    property int popUpInfoType

    //////////////////////////////////////////////////////////////////
    Connections{
        target: QmlController
        onSigRDSInfoStart:{
            console.log("[AppRadio-RDS] onSigRDSInfoStart rdsInfoType = " , rdsInfoType ,", psname = ", rdsPSName);
            switch(rdsInfoType)
            {
            case 0x00:
                popUpInfoType = 0x00; //TA
                break;
            case 0x01:
                popUpInfoType = 0x01; //News
                break;
            case 0x02:
                popUpInfoType = 0x02;  //Alarm
                break;
            }
//            idDialogConnect.visible = true;
            UIListener.sendEventInfoStart(rdsInfoType, rdsPSName);
        }
        onSigRDSInfoStop:{
            console.debug("[AppRadio-RDS] onSigRDSInfoStop rdsInfoType = ",rdsInfoType);
            switch(rdsInfoType)
            {
            case 0x00: //TA
                //QmlController.rdsonairTA = false;
                break;
            case 0x01: //News
                break;
            case 0x02: //Alarm
                break;
            }
            UIListener.sendEventInfoStop(rdsInfoType);
        }

        //KSW 140107 ITS/219032
        onChangeSearchState: {
            console.debug("[RadioRdsMain] onChangeSearchState  = ",value);
            if(idAppMain.menuScanFlag == true)
            {
                globalSelectedBand==0x01 ? idRadioRdsFmFrequencyGradation.forceActiveFocus():idRadioRdsAmFrequencyGradation.forceActiveFocus()
                bIsScan = true;
            }
            else if(bIsScan == true)
            {
                bIsScan = false;
                //dg.jin 20140918 ITS 248564 Scan All Channels after menu focus issue
                //dg.jin 20141031 ITS 251463 Preset Scan after preset list focus issue
                //if((idAppMain.state != "AppRadioRdsOptionMenu") && (idAppMain.state != "AppRadioRdsOptionMenuRegion")
                //&& (idAppMain.state != "AppRadioRdsPresetList") && (idAppMain.state != "AppRadioRdsStationList"))
                if(idAppMain.state == "AppRadioRdsMain") //dg.jin 20141104 ITS 251991 Preset Scan after refresh focus issue
                {
                    idMBand.changeFocus();
                }
            }
        }
    }
    Connections{
        target: UIListener
        onSigRDSResponse:{
            console.debug("[AppRadio-RDS] onSigRDSResponse responsetype = ",responsetype);
//// 20130529 removed by qutiguy - remove hide.
//            if(responsetype == 0x01){     //------------------------ Hide
//                if (popUpInfoType == 0x00){
//                        QmlController.rdsonairTA = true;
//                }
//            }else
            if(responsetype == 0x02){//-------------------- Cancel
                //if (popUpInfoType == 0x00)
                //    QmlController.rdsonairTA = false;
                QmlController.setRDSInforCancel(popUpInfoType)
            }else if(responsetype == 0x03){//-------------------- Off
                switch(popUpInfoType)
                {
                case 0x00:
                {
                    //QmlController.rdsonairTA  = false
                    QmlController.rdssettingsTP = false;
                    break;
                }
                case 0x01:
                    QmlController.rdssettingsNews = false;
                    break;
                case 0x02:
                    break;
                }
            } //KSW 131027 separated air cancel and user cancel
            else if(responsetype == 0x04){//----------------- air Cancel
                //if (popUpInfoType == 0x00)
                //    QmlController.rdsonairTA = false;
            }
            else if(responsetype == 0x05){//-------------------- TA cancel from mute
               // if (popUpInfoType == 0x00)
                //    QmlController.rdsonairTA = false;
                QmlController.setRDSInforCancel(0x04); //KSW 131111-5 [ITS][197334][minor] TA request
            }
        }
        //KSW 140107 ITS/219032
        onChangeViewState:{
            console.log("[RadioRdsMain] +++++++++++onChangeViewState+++++++++++++++")
            if(idAppMain.state == "AppRadioRdsMain")
            {
                if(idAppMain.menuScanFlag == true)
                {
                    if(idAppMain.bForceDefaultFocus == true)
                    {
                        idMBand.changeFocus();
                        idAppMain.bForceDefaultFocus = false;
                    }
                    else
                        globalSelectedBand==0x01 ? idRadioRdsFmFrequencyGradation.forceActiveFocus():idRadioRdsAmFrequencyGradation.forceActiveFocus()
                }
                else
                {
                    if(bFocusIsTune == true)
                    {
                        globalSelectedBand==0x01 ? idRadioRdsFmFrequencyGradation.forceActiveFocus():idRadioRdsAmFrequencyGradation.forceActiveFocus()
                    }
                } //dg.jin 20140901 ITS 0247678 tune focus issue
            } //end if
            bFocusIsTune = false; //dg.jin 20140901 ITS 0247678 tune focus issue
        }
    }
//////////////////////////////////////////////

    Connections{
        target : QmlController
        onChangeScanFreq:{
            if (band != QmlController.radioBand) // band , radio band intger
                return;
            if (idAppMain.globalSelectedBand == 0x01){ // FM Band String
                var frequency = freq;
                idAppMain.globalSelectedFmFrequency = frequency
            }else{                                             // AM Band
                var frequency = freq ;
                idAppMain.globalSelectedAmFrequency = frequency //AM Freq
            }
        }
        onChangeSearchState: {
            // 20130227 added by qutiguy - to check search start point
            console.log(" [Notice] onChangeSearchState mode : " + value);
            if (value != 0)
                UIListener.sendDataToOSD(1); //STAY
            else if (value == 0)
                UIListener.sendDataToOSD(2); //STAY_TIMEOUT
            //
            if( value == 0 && stopSentMenu.length > 0 )
            {
                changeBand();
            }
            //// 2013.10.31 added by qutiguy - ITS 196126
            if( value == 0 && interruptChannelChange == true )
            {
                console.log("CHECK_NOW Index = " + interruptChangedIndex);
                interruptChannelChange = false;
                QmlController.changeChannelWhileSearch(interruptChangedIndex);
            }
        }
        //// 2013.10.31 added by qutiguy - ITS 196126
        onChannelChanged:{
            console.log(" [idRadioRdsMain] onChannelChanged mode :" + index + freq );
            if(search){
                interruptChannelChange = true;
                interruptChangedIndex  = index;
            }
        }

// 20130131 removed by qutiguy - no use because of removed bottom command
//        onChangeRDSRTOnOff:{
//              console.log("[[[[[[[[[[[[[[[[Toggle Check Icon - Info]]]]]]]]]]]]]]]] ", value);
//              idMBottomButton.toggleCheckInfo(value);

//        }
//        onChangeRDSSettingsTP:{
//                console.log("[[[[[[[[[[[[[[[[Toggle Check Icon - Ta]]]]]]]]]]]]]]]]", value);
//              idMBottomButton.toggleCheckTa(value);
//        }
//        onChangeRDSSettingsNews:{
//                console.log("[[[[[[[[[[[[[[[[Toggle Check Icon - News]]]]]]]]]]]]]]]]", value);
//        }

        onChangeVariant:{
            console.log("[[[[[[[[[[[[[[[[ onChangeVariant - Alls are ready ]]]]]]]]]]]]]]]] ");
            idAppMain.startFmFrequency = fmFirst        //# Variant frequency FM start value
            idAppMain.startAmFrequency = amFirst        //# Variant frequency AM start value
            idAppMain.endFmFrequency   = fmEnd          //# Variant frequency FM end value
            idAppMain.endAmFrequency   = amEnd          //# Variant frequency AM end value
            idAppMain.stepFmFrequency  = fmStep         //# Variant frequency FM step value
            idAppMain.stepAmFrequency  = amStep         //# Variant frequency AM step value
            idAppMain.preset_Num       = preset_Num
        }
    }

    Connections{
        target : UIListener
        onSigTuneDial:{
            bIsScan = false; //KSW 140519
            //KSW 140109 ITS/217598
            if(idAppMain.state == "AppRadioRdsOptionMenuSortBy"
                    || idAppMain.state == "AppRadioRdsOptionMenuStationList" )
            {
                console.log("returned tune ,, UIListener : RdsOptionMenuSortBy or OptionMenuStationList");
                return;
            }

            if(direction > 0)
                increasetune(direction);
            else
                decreasetune(direction);

            //dg.jin 20140901 ITS 0247678 tune focus issue
            if(idAppMain.state == "AppRadioRdsOptionMenu")
            {
                bFocusIsTune = true;
            }
            else
            {
                bFocusIsTune = false;
            }

            if(idAppMain.state == "AppRadioRdsMain" && idAppMain.systemPopupShow == false) //dg.jin 20141007 focus issue
            {
                if(idAppMain.globalSelectedBand == 0x01)
                    idRadioRdsFmFrequencyGradation.forceActiveFocus();
                else {
                    idRadioRdsAmFrequencyGradation.forceActiveFocus();
                }
            }
        }
        onSigChangeBand:{
            if (band == 1){
                setBand("FM");
                //**************************************** FM1 Band select (call freqSelect(saved value))
            }
            else if (band == 2){
                setBand("FM");
                //**************************************** FM2 Band select (call freqSelect(saved value))
            }
            else{
                setBand("AM");
                //**************************************** AM Band select (call freqSelect(saved value))
            }
        }
    }

    //maybe don't used. KSW 130731 for premium UX
//    Image{
//        x: 0; y: 120
//        width: systemInfo.lcdWidth;
//        //source: imgFolderGeneral+"bg_type_b.png"
//        source: imgFolderGeneral+"bg_main.png"
//    }

    MComp.MBand{
        id: idMBand
        x: 0; y: 0
        selectedBand: globalSelectedBand==0x01?"FM":"AM"
        //****************************** # Tab button ON #        
        tabBtnFlag: true        //bandTab button On/Off
        tabBtnCount: 3
        tabBtnText : stringInfo.strRDSBandFm
        tabBtnText2: stringInfo.strRDSBandMw
        tabBtnText3: stringInfo.strRDSBandDab
//20130131 added by qutiguy - preset button.
        reserveBtnFlag: true
//        reserveBtnText: stringInfo.strRDSLabelPreset //KSW 130731 for premium UX
        reserveBtnFgImage: imgFolderRadio_Rds+"ico_list.png"
        reserveBtnFgImagePress: imgFolderRadio_Rds+"ico_list.png"
        reserveBtnFgImageFocusPress: imgFolderRadio_Rds+"ico_list.png"
//
        subBtnFlag: true
//        subBtnText: stringInfo.strRDSMenuList
        //KSW 130731 for premium UX
//        subBtnFgImage: imgFolderRadio_Rds+"ico_list.png"
//        subBtnFgImagePress: imgFolderRadio_Rds+"ico_list.png"
//        subBtnFgImageFocusPress: imgFolderRadio_Rds+"ico_list.png"
        subBtnText: stringInfo.strRDSMenuList;

        menuBtnFlag: true
        menuBtnText: stringInfo.strRDSMenuMenu

//20130109 added by qutiguy - inititialize focus to band tab after loading qml
        focus : true;
        onTabBtn1Clicked: {
            if(globalSelectedBand == 0x01){
                giveForceFocus(1);  //FM Focus
                return;
            }
            //Request to change for FM1
            UIListener.changeBandViaExternalMenu(0x01);
        }
        onTabBtn2Clicked: {
            if(globalSelectedBand == 0x03){
                giveForceFocus(2);  //AM Focus
                return;
            }
            //Request to change for AM
            UIListener.changeBandViaExternalMenu(0x03);
        }

        onTabBtn3Clicked: {
            //Request to change for DAB
            UIListener.launchDAB(0x01);
        }

        onReserveBtnClicked: {
            QmlController.setClearSearchStart(false);//KSW 131108 [ITS][207609][minor]

            //dg.jin 20150630 Seek stop When enter preset list
            if(requestStopSearchforPresetList == true)
            {
                return;
            }
            if(QmlController.searchState != 0){
                requestStopSearchforPresetList = true;
                QmlController.setIsTpSearching(false);
                QmlController.seekstop();
                return;
            }
            requestStopSearchforPresetList = false;

            setAppMainScreen( "AppRadioRdsPresetList" , true);
        }

        onSubBtnClicked: {
//            launchStationList();
//            setAppMainScreen( "AppRadioRdsStationList" , true);
            QmlController.setClearSearchStart(false); //KSW 131108 [ITS][207609][minor] search cancel
            //20141013 dg.jin changed station list store
            if(globalSelectedBand == 0x01)
            {
                QmlController.loadStationlists(); //KSW 140205-1
                //KSW 140210
                if(QmlController.fileCheck("/app/data/AppRadio/","RDS_StationList.ini") == true)
                {
                    QmlController.setIsStoreStationLists(true); //KSW 140211
                    QmlController.command_system("rm -rf /app/data/AppRadio/RDS_StationList.ini");
                }
            }
            else
            {
                QmlController.loadStationlistsAM(); //KSW 140205-1
                //KSW 140210
                if(QmlController.fileCheck("/app/data/AppRadio/","RDS_StationListAM.ini") == true)
                {
                    QmlController.setIsStoreStationLists(true); //KSW 140211
                    QmlController.command_system("rm -rf /app/data/AppRadio/RDS_StationListAM.ini");
                }
            }
            sigLaunchStation("from_main");
        }

        onMenuBtnClicked: {
            //KSW 140107 ITS/219032
            idMBand.changeFocus();
            setAppMainScreen( "AppRadioRdsOptionMenu" , true);
        }

        //****************************** # button clicked or key selected #
        onBackBtnClicked: {
            gotoBackScreen()
        }
        KeyNavigation.down:globalSelectedBand==0x01?idRadioRdsFmFrequencyGradation:idRadioRdsAmFrequencyGradation
    }
    RadioRdsFmFrequencyGradation{
        id: idRadioRdsFmFrequencyGradation
        x: 0; y: systemInfo.titleAreaHeight
        visible : globalSelectedBand == 0x01
        //2013.09.10 removed by qutiguy - change focus actions
        //onVisibleChanged: if (idRadioRdsAmFrequencyGradation.focus && visible) forceActiveFocus();

        //dg.jin 20150227 CCP UP Focus Change
        Keys.onPressed:{
            if (event.key == Qt.Key_Up) {
                idMBand.giveForceFocus(1);
                idMBand.forceActiveFocus();
            }
        }

        // KeyNavigation.up: idMBand
//        KeyNavigation.down: idMBottomButton
    }
    RadioRdsAmFrequencyGradation{
        id: idRadioRdsAmFrequencyGradation
        x: 0; y: systemInfo.titleAreaHeight
        visible : globalSelectedBand == 0x03
        //2013.09.10 removed by qutiguy - change focus actions
        //onVisibleChanged: if (idRadioRdsFmFrequencyGradation.focus && visible) forceActiveFocus();

        //dg.jin 20150227 CCP UP Focus Change
        Keys.onPressed:{
            if (event.key == Qt.Key_Up) {
                idMBand.giveForceFocus(2);
                idMBand.forceActiveFocus();
            }
        }

       //  KeyNavigation.up: idMBand
//        KeyNavigation.down: idMBottomButton
    }

    RadioRdsFrequencyInfo{
//        x: 0; y: 309-systemInfo.statusBarHeight
//        width: systemInfo.lcdWidth; height: 297
        band : currentBand ;
        strFmFrequency : globalSelectedFmFrequency.toFixed(2);
        strAmFrequency : globalSelectedAmFrequency;
        strPsname : currentPSName;
        nPresetIndex : currentPresetIndex;
        nPtytype : currentPTYType;
        rtShowOnOff : idRtInfo.visible
        bPresetNumberVisiable : QmlController.visiablePresetNumber //KSW 130907 [EU][ISV][C] Missing deletion of the preset number
    }

    //****************************** # Scan Image #
    Image{
        id: scanIcon
        property bool bShowIcon : true ;
        x: 1203/*1128*/ ; y: 333 /*328*/ - systemInfo.statusBarHeight //KSW 130731 for premium UX
        width: 57; height: 57
        source: imgFolderRadio+"ico_radio_scan.png"
        visible: (menuScanFlag && bShowIcon)
        opacity: 1
        Timer{
            id : scanIconTimer
            interval : 500
            running : menuScanFlag
            repeat : true
            onTriggered : {scanIcon.bShowIcon = !scanIcon.bShowIcon;}
        }
    }// # End Image

    //****************************** # Region #
    Connections{
        target : QmlController
        onChangeRDSSettingsRegion:{
            console.log("Region Change value = ", value);
            if(value)
                menuRegionFlag = true;
            else
                menuRegionFlag = false;
        }
    }
//// 20130531 removed by qutiguy - spec : only display in statusbar
//    Item{
//        id : regIcon
//        x: 1128 + 70; y: 328 - systemInfo.statusBarHeight
//        width: 57; height: 57
//        Image {
//            source: imgFolderRadio_Rds+"bg_ta_n.png"
//        }
//        Text {
//            text: "REG"
//            anchors.fill: parent
//            font.family: systemInfo.hdb
//            font.pixelSize: 19
//            horizontalAlignment: "AlignHCenter"
//            verticalAlignment: "AlignVCenter"
//            color: colorInfo.dimmedGrey
//        }
//        visible: menuRegionFlag
//    }// # End Item

    //****************************** # RT Info Text Box #
    Text{
        id: idRtInfo
        text: QmlController.rdsrt
        x: 460//309
//        anchors.verticalCenter: idRadioRdsFmFrequencyGradation.verticalCenter
        y: 581 - systemInfo.statusBarHeight //599 - (36/2)[font size / 2] - systemInfo.statusBarHeight //KSW 130806 Fixed it, problem do not update rt text.
        width: 600; //780 ;
        height: 46 * 2
        font.pixelSize: 32
        font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.04 for New UX
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        color: colorInfo.brightGrey
        wrapMode: Text.Wrap
        visible: globalSelectedBand == 0x01 && menuInfoFlag
        lineHeight : 0.8 //KSW 131212 for KH
    } // # End Text

    //****************************** # Menu Open when clicked I, L, Slash key #
    onClickMenuKey:
    {
        idMBand.changeFocus() //KSW 131105 [ITS][0206267][minor]
        setAppMainScreen( "AppRadioRdsOptionMenu" , true);
    }

    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed: gotoBackScreen()

    //****************************** # Function of Wheel #
//20121129 modified by qutiguy - fixed in/decreased dial tune bugs - exeeded variant frequency value(ex 108.05)
    function decreasetune(value){
        var frequency = 0;
        if((value > -5) && (value < -2))
            value = value*2;
        else if( value <= -5)
            value = value*3;

        for (var i = value; i < 0; i++)
        {
            if(idAppMain.globalSelectedBand == 0x03){
                if(globalSelectedAmFrequency <= startAmFrequency) globalSelectedAmFrequency = endAmFrequency//startAmFrequency
                else    globalSelectedAmFrequency = globalSelectedAmFrequency-stepAmFrequency

                frequency = globalSelectedAmFrequency
            }
            else{   //FM
                globalSelectedFmFrequency = globalSelectedFmFrequency.toFixed(2);
                console.log("globalSelectedFmFrequency = ", globalSelectedFmFrequency);
                if(globalSelectedFmFrequency.toFixed(2) <= startFmFrequency) globalSelectedFmFrequency = endFmFrequency//startFmFrequency
                else    globalSelectedFmFrequency = globalSelectedFmFrequency-stepFmFrequency//0.1

                frequency = globalSelectedFmFrequency.toFixed(2);
            }
        }
        console.log("frequency = ", frequency);
        QmlController.setRadioFreq(frequency);
    }

    function increasetune(value){
        var frequency = 0;
        if((value > 2) && (value < 5))
            value = value*2;
        else if(value >= 5)
            value = value*3;
        for (var i = 0; i < value; i++)
        {
            if(idAppMain.globalSelectedBand == 0x03){
                if(globalSelectedAmFrequency >= endAmFrequency) globalSelectedAmFrequency = startAmFrequency//endAmFrequency
                else    globalSelectedAmFrequency = globalSelectedAmFrequency+stepAmFrequency

                frequency = globalSelectedAmFrequency
            }
            else{   //FM
                if(globalSelectedFmFrequency.toFixed(2) >= endFmFrequency) globalSelectedFmFrequency = startFmFrequency//endFmFrequency
                else    globalSelectedFmFrequency = globalSelectedFmFrequency+stepFmFrequency//0.1

                frequency = globalSelectedFmFrequency.toFixed(2);
            }
        }
        console.log("frequency = ", frequency);
        QmlController.setRadioFreq(frequency);
    }

    function requestChangeBand(bandNumber) {
        console.log(" HJIGKS : requestChangeBand(bandNumber) " + bandNumber + stopSentMenu);

        if( stopSentMenu.length > 0 )
        {
            switch( bandNumber )
            {
            case 1: stopSentMenu = "FM1"; break;
            case 2: stopSentMenu = "FM2"; break;
            case 3: stopSentMenu = "AM"; break;
            }
            return true;
        }

        if(QmlController.searchState)
        {
            switch( bandNumber )
            {
            case 1: stopSentMenu = "FM1"; break;
            case 2: stopSentMenu = "FM2"; break;
            case 3: stopSentMenu = "AM"; break;
            }
            QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
            QmlController.seekstop();
            return true;
        }
        if(QmlController.radioBand == bandNumber )
        {
            stopSentMenu = '';
            return true;
        }
        return false;
    }

    function setBand(bandNumber){
//20130107 added by qutiguy - init main state.
        if (idAppMain.state != "AppRadioRdsMain" && idAppMain.state != "AppRadioRdsENGMode"){ //KSW 140519-1
            initRadioScreen();
        }

        switch(bandNumber)
        {
        case "FM":
//    //20130108 added by qutiguy - init tab menu focus when changing from DAB.
//                if (idMBand.focus)
            //KSW 140107 ITS/219032
            if(idAppMain.menuScanFlag == true)
                idRadioRdsFmFrequencyGradation.forceActiveFocus()
            else
            {
                //20141014 engmode band change focus issue
                if(idAppMain.state != "AppRadioRdsENGMode")
                {
                    idMBand.changeFocus("RDS_FM");
                }
            }
//    //
            idMBand.selectedBand = stringInfo.strRDSBandFm
            QmlController.setRadioBand(0x01);
            var freq ;
            if(QmlController.radioFreq == "")
                freq = idAppMain.startFmFrequency; //0;
            else
                freq = parseFloat(QmlController.radioFreq);

            globalSelectedBand = 0x01 //select BGImage Change
            idAppMain.globalSelectedFmFrequency = freq;
            break;
        case "AM":
////20130108 added by qutiguy - init tab menu focus when changing from DAB.
//            if (idMBand.focus)
            //KSW 140107 ITS/219032
            if(idAppMain.menuScanFlag == true)
                idRadioRdsAmFrequencyGradation.forceActiveFocus()
            else
            {
                //20141014 engmode band change focus issue
                if(idAppMain.state != "AppRadioRdsENGMode") 
                {
                    idMBand.changeFocus("RDS_AM");
                }
            }
////
            var freq ;
            idMBand.selectedBand = stringInfo.strRDSBandMw
            QmlController.setRadioBand(0x03);
            if(QmlController.radioFreq == "")
                freq = idAppMain.startAmFrequency; //0;
            else
                freq = parseInt(QmlController.radioFreq);

            globalSelectedBand = 0x03 //select BGImage Change
            idAppMain.globalSelectedAmFrequency = freq
            break;
        }
    }

    function changeBand() {
        if( stopSentMenu.length > 0 )
        {
            setBand(stopSentMenu);
            stopSentMenu = '';
        }
    }
}
