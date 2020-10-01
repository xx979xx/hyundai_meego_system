/**
 * FileName: RadioMain.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idRadioMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioStringInfo{ id: stringInfo }    

    property bool seekCueFlag: true //for SeekButton On/Off
    //////////////////////////////////////////////////////////
    // JSH 120306
    property string  stopSentMenu  : ""
    property string  jogFocusState : ""        //# // JSH jog focus
    property string  prevJogFocusState: ""       //# // JSH Previous jog focus // JSH 130328
    property string     prevBandJogFocusState: ""   //dg.jin 20150227 bnad down jog focus
    property string  presetAndDialBackground   : "PresetList"

//    property bool   alreadyFmSaved      : false
//    property bool   alreadyAmSaved      : false

    onActiveFocusChanged: {
        console.log("CHECK_FOCUS_12_06_idRadioMain focus changed.")
        console.log("CHECK_FOCUS_12_06 focus = " + idRadioMain.jogFocusState);
        if(!idRadioMain.activeFocus){
            console.log("CHECK_FOCUS_12_06 idRadioMain.activeFocus == false")
            QmlController.setQmlFocusState(-1); // JSH 121228
            if(idAppMain.state == "AppRadioOptionMenu"){// JSH 130627
                arrowUp     = false
                arrowDown   = false
                arrowLeft   = false
                arrowRight  = false
            }
            //// 2013.11.22 copy & modify from hd radio - set default focus as soon as option menu dispear.
            ///////////////////////////////////////////////////////////////////////
            // JSH 130903 => 130913 modify , focus default position moved
            if(idRadioMain.jogFocusState == "Band"){ //  130924 added
                if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0 && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                    idRadioMain.jogFocusState = "FrequencyDial";
                }
                else{
                    if(idRadioMain.jogFocusState != "PresetList")
                        idRadioMain.jogFocusState = "PresetList";
                }
            } // if(idRadioMain.jogFocusState == "Band")
        } // if(!idRadioMain.activeFocus){
        else{
            console.log("CHECK_FOCUS_12_06 idRadioMain.activeFocus == true")
            //idRadioMain.jogFocusState = jogFocusState;
            jogFocus(jogFocusState);
        }

        ////
    }
    //////////////////////////////////////////////////////////////////
    Connections{
        target : QmlController
        onChangeScanFreq:{
            console.log(" HJIGKS: [RadioFMMode2Main] onChangeScanFreq Occured!!!!");
            if (band != QmlController.radioBand) // band , radio band intger
                return;

//            if(QmlController.searchState == 0x00)
//                return;

            if (band < 0x03 && ("FM1" == idAppMain.globalSelectedBand || "FM2" == idAppMain.globalSelectedBand )){// FM1, FM2 Band String
                var frequency = freq;
//                idAppMain.touchFmAniStop = true; // ani running on/off
                idAppMain.globalSelectedFmFrequency = frequency
            }else{                                             // AM Band
                var frequency = freq ;
//                idAppMain.touchAmAniStop = true; // ani running on/off
                idAppMain.globalSelectedAmFrequency = frequency //AM Freq
            }

            if(QmlController.searchState != 0x00){ // JSH 121012 (alreadySaved) not used
                idAppMain.alreadySaved = true;
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
                console.log(" HJIGKS : [RadioFMBand] onChangeSearchState value: " + value);
                changeBand();
            }
            if(QmlController.searchState == 0x00) // JSH 121012 (alreadySaved) not used
                idAppMain.alreadySaved = false;
        }

        onChangeVariant:{
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
            idAppMain.initMode() // JSH 130625
            if(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled)
                return;

            idAppMain.doNotUpdate = true; // JSH 130514 added
            if(direction > 0)
                increasetune(direction);
            else
                decreasetune(direction);

            jogFocusState =  "FrequencyDial" // JSH 130514 added
            idAppMain.doNotUpdate = false; // JSH 130514 added
        }
        onSigJogDial:{ // JSH 130104
            idAppMain.initMode() // JSH 130625
            if(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled)
                return;
            idAppMain.doNotUpdate = true;

            if(direction > 0)
                increasetune(direction);
            else
                decreasetune(direction);

            idAppMain.doNotUpdate = false;
        }
        onSigChangeBand:{
            //Added by Qutiguy for HKey Event handler
            console.log(" onSigChangeBand  " + band);
//            if( requestChangeBand(band) == true )
//                return;

            /////////////////////////////////////////////////////////////
            //// Edit Preset Order Bug Modify ## JSH 130129
            if(band != QmlController.radioBand){
                if(globalSelectedBand == "FM1")
                {
                    idRadioPresetListFM1.currentIndex = idAppMain.preset_Num - 1;
                }
                else if(globalSelectedBand == "FM2")
                {
                    idRadioPresetListFM2.currentIndex = idAppMain.preset_Num - 1;
                }
                else
                {
                    idRadioPresetListAM.currentIndex = idAppMain.preset_Num - 1;
                }
                idRadioMain.jogFocusState     =  ""
                idAppMain.initMode() // JSH 130625
            }
           /////////////////////////////////////////////////////////////

            console.log(" HJIGKS : requestChangeBand(band) == false" + band);
            if (band == 1){
                console.log("------------------FM1 ");
                setBand("FM1");//**************************************** FM1 Band select (call freqSelect(saved value))
            }
            else if (band == 2){
                console.log("------------------FM2 ");
                setBand("FM2");//**************************************** FM2 Band select (call freqSelect(saved value))
            }
            else{
                console.log("------------------AM ");
                setBand("AM");//**************************************** AM Band select (call freqSelect(saved value))
            }

            //if(idAppMain.state == "AppRadioMain" && (!(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled))){ // JSH 130706 deleted [focus bug]
            if((idAppMain.state == "AppRadioMain" || (!idAppMain.globalMenuAnimation)) && (!(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled))){
                if(globalSelectedBand == "FM1")
                {
                    idRadioPresetListFM1.currentIndex  =  0; // Model Changed [Index No.1 Select]
                    idRadioPresetListFM1.changeState();
                }
                else if(globalSelectedBand == "FM2")
                {
                    idRadioPresetListFM2.currentIndex  =  0; // Model Changed [Index No.1 Select]
                    idRadioPresetListFM2.changeState();
                }
                else
                {
                    idRadioPresetListAM.currentIndex  =  0; // Model Changed [Index No.1 Select]
                    idRadioPresetListAM.changeState();
                }
            }
        }
    }
    //////////////////////////////////////////////////////////
    MComp.MBand{
        id: idMBand
        x: 0; y: 0

        //****************************** # Tab button ON #
        selectedBand: globalSelectedBand    //first selected tab setting
        tabBtnFlag: true
        tabBtnCount: 3
        tabBtnText: stringInfo.strRadioBandFm1
        tabBtnText2: stringInfo.strRadioBandFm2
        tabBtnText3: stringInfo.strRadioBandAm
        menuBtnFlag: true
        menuBtnText: stringInfo.strRadioBandMenu
        focus: true
        bandMirrorMode : idAppMain.generalMirrorMode
        onTabBtn1Clicked: {
//0905            globalSelectedBand = tabBtnText
            //QmlController.setRadioBand(0x01);
            //Request to change for FM1
            UIListener.changeBandViaExternalMenu(0x01);
            //idRadioMain.jogFocusState = "Band"; // JSH Jog focus
        }
        onTabBtn2Clicked: {
//0905            globalSelectedBand = tabBtnText2
            //QmlController.setRadioBand(0x02);
            //Request to change for FM2
            UIListener.changeBandViaExternalMenu(0x02);
            //idRadioMain.jogFocusState = "Band"; // JSH Jog focus
        }
        onTabBtn3Clicked: {
//0905            globalSelectedBand = tabBtnText3
            //QmlController.setRadioBand(0x03);
            //Request to change for AM
            UIListener.changeBandViaExternalMenu(0x03);
            //idRadioMain.jogFocusState = "Band"; // JSH Jog focus
        }
        //****************************** # button clicked or key selected #
        onMenuBtnClicked: {
            if(idAppMain.state == "AppRadioOptionMenu"){
                gotoBackScreen()
                return;
            }
            setAppMainScreen( "AppRadioOptionMenu" , true);
        }
        onBackBtnClicked: {
            console.log("### BackKey Clicked ###")
            gotoBackScreen()
            //idRadioMain.jogFocusState = "Band";
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Down) {
                // JSH 130328 Added => // JSH 130405 Modify
                if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
                    for(var i = 0; i < idMBand.children.length; i++){
                        if(idMBand.children[i].activeFocus){
                           // if(idMBand.children[i].x + idMBand.children[i].width < (idMBand.width/2)) //dg.jin 20150227 bnad down jog focus
                           if(prevBandJogFocusState == "PresetList") {   //dg.jin 20150227 bnad down jog focus
                                //jogFocusState = "PresetList"
                                if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                                        && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                                    QmlController.changeChannel(0x01);
                                }else{
                                    jogFocusState = "PresetList"
                                }
                                ////
                            }
                            else
                                jogFocusState = "FrequencyDial"

                            //if(idMBand.children[i].x + idMBand.children[i].width < (idMBand.width/2)){
                            //    if(!bandMirrorMode){
                                    //// 2013.12.07 modified by qutiguy : ITS 0215920  Focus issues.
                                    //jogFocusState = "PresetList"
                            //        if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                            //                && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                            //            QmlController.changeChannel(0x01);
                            //       }else{
                            //            jogFocusState = "PresetList"
                            //       }
                                    ////
                            //    }else{
                            //        jogFocusState = "FrequencyDial"
                            //    }
                            //}else{
                            //    if(!bandMirrorMode){
                            //            jogFocusState = "FrequencyDial"
                            //    }else{
                                    //// 2013.12.07 modified by qutiguy : ITS 0215920  Focus issues.
                                    //jogFocusState = "PresetList"
                            //        if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                            //                && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                            //            QmlController.changeChannel(0x01);
                            //        }else{
                            //            jogFocusState = "PresetList"
                            //        }
                                    ////
                            //    }
                            //}
                            break;
                        }
                    }
                }else{
                    jogFocusState = "PresetList"
                }
            }
        }
//        KeyNavigation.down: idRadioPresetList
        /////////////////////////////////////////////////////////////////
        //# focus change #JSH
        onActiveFocusChanged: { // JSH jog focus
            console.log("========================> Band onActiveFocusChanged :: ",idMBand.activeFocus,idRadioMain.jogFocusState)
            if(idRadioMain.jogFocusState == "Band" && idAppMain.state == "AppRadioMain" && (!idMBand.activeFocus))
                focus = true;

            if(idMBand.activeFocus){
                arrowUp = false
                arrowDown = true
                arrowLeft = false
                arrowRight = false
                QmlController.setQmlFocusState(2); // JSH 121228
                //if((idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)) , JSH 130801 NA ITS[0182046,0182037] delete
                //    giveForceFocus("backBtn");
            }
        }
    }
     //****************************** # Content`s background Image(120725) #
//    Image{
//        x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
//        source: imageInfo.imgFolderGeneral+"bg_menu.png"
//    }

    //****************************** # Frequency Dial View (FM) #
    RadioFmFrequencyDial{
        id: idRadioFmFrequencyDial
        x: !generalMirrorMode ? 691 : 0 ; y: systemInfo.headlineHeight-1-systemInfo.statusBarHeight
        z: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? -1 : 0
        visible: globalSelectedBand != stringInfo.strRadioBandAm

        //anchors.fill: idRadioFmFrequencyDial
        Keys.onPressed: {
            if (event.key == Qt.Key_Left) {
                if(!generalMirrorMode)
                    //// 2013.12.07 modified by qutiguy : ITS 0215920  Focus issues.
                    //jogFocusState = "PresetList"
                    if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                        QmlController.changeChannel(0x01);
                    }else{
                        jogFocusState = "PresetList"
                    }
                    ////
            }
            else if (event.key == Qt.Key_Right) {
                if(generalMirrorMode)
                    //// 2013.12.07 modified by qutiguy : ITS 0215920  Focus issues.
                    //jogFocusState = "PresetList"
                    if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                        QmlController.changeChannel(0x01);
                    }else{
                        jogFocusState = "PresetList"
                    }
                    ////
            }
            else if (event.key == Qt.Key_Up) {
                jogFocusState = "Band"      // JSH jog focus
            }
        }

//        KeyNavigation.up: idMBand
//        KeyNavigation.left: idRadioPresetList
     
    }

    //****************************** # Frequency Dial View (AM) #
    RadioAmFrequencyDial{
        id: idRadioAmFrequencyDial
        x: !generalMirrorMode ? 691 : 0 ; y: systemInfo.headlineHeight-1-systemInfo.statusBarHeight
        z: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? -1 : 0
        visible: globalSelectedBand == stringInfo.strRadioBandAm

        Keys.onPressed: {
            if (event.key == Qt.Key_Left) {
                if(!generalMirrorMode)
                    //// 2013.12.07 modified by qutiguy : ITS 0215920  Focus issues.
                    //jogFocusState = "PresetList"
                    if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                        QmlController.changeChannel(0x01);
                    }else{
                        jogFocusState = "PresetList"
                    }
                    ////
            }
            else if (event.key == Qt.Key_Right) {
                if(generalMirrorMode)
                    //// 2013.12.07 modified by qutiguy : ITS 0215920  Focus issues.
                    //jogFocusState = "PresetList"
                    if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                        QmlController.changeChannel(0x01);
                    }else{
                        jogFocusState = "PresetList"
                    }
                    ////
            }
            else if (event.key == Qt.Key_Up) {
                jogFocusState = "Band"      // JSH jog focus
            }
        }

//        KeyNavigation.up: idMBand
//        KeyNavigation.left: idRadioPresetList
    }

    //****************************** # Preset ChannelList #
    //RadioPresetList{
    //    id: idRadioPresetList
    //    x: !idAppMain.generalMirrorMode ? 0 : 662; y: 174-systemInfo.statusBarHeight
        //focus: true
        //anchors.fill: idRadioPresetList
        /////////////////////////////////////////////////////////////////
        //******* JSH 130130 delete *********
        //        Keys.onPressed: {
        //            if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
        //                return;
        //            if (event.key == Qt.Key_Right) {
        //                jogFocusState = "FrequencyDial" // JSH jog focus
        //                //event.accepted = true;
        //                idAppMain.rightKeyPressed = true;
        //            }
        //            else if (event.key == Qt.Key_Up) {
        //                jogFocusState = "Band"      // JSH jog focus
        //                //event.accepted = true;
        //                idAppMain.upKeyPressed    = true;
        //            }
        //        }
        //        Keys.onReleased:{
        //            idAppMain.upKeyPressed    = false;
        //            idAppMain.downKeyPressed  = false;
        //            idAppMain.rightKeyPressed = false;
        //            idAppMain.leftKeyPressed  = false;
        //        }
        //        KeyNavigation.up: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? idRadioPresetList : idMBand
        //        KeyNavigation.right: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? idRadioPresetList : globalSelectedBand == stringInfo.strRadioBandAm? idRadioAmFrequencyDial : idRadioFmFrequencyDial
    //}
    
    RadioPresetListFM1{
        id: idRadioPresetListFM1
        x: !idAppMain.generalMirrorMode ? 0 : 662; y: 174-systemInfo.statusBarHeight
        //visible: globalSelectedBand == "FM1"
    }

    RadioPresetListFM2{
        id: idRadioPresetListFM2
        x: !idAppMain.generalMirrorMode ? 0 : 662; y: 174-systemInfo.statusBarHeight
        //visible: globalSelectedBand == "FM2"
    }
    
    RadioPresetListAM{
        id: idRadioPresetListAM
        x: !idAppMain.generalMirrorMode ? 0 : 662; y: 174-systemInfo.statusBarHeight
        //visible: globalSelectedBand == "AM"
    }
    
    ////////////////////////////////////////////////////////////////////////
    //****************************** # Preset Save & EDIT , Dim Background Image #
    //    Image {
    //        id: imgSaveBgDim
    //        x: !generalMirrorMode ? idRadioPresetList.x : 0 ; y: idRadioPresetList.y
    //        width: !generalMirrorMode ? systemInfo.lcdWidth : 744 - 45
    //        height: idRadioPresetList.height
    //        source: !generalMirrorMode ? imageInfo.imgFolderRadio + "bg_dim.png" : imageInfo.imgFolderGeneral+"bg_ch_r_n.png"
    //        //opacity: 0.6
    //        visible: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
    //        MouseArea{anchors.fill:parent; onPressed:{return;}}
    //    }
    Image {
        id: imgSaveBgDim
        //x: !idAppMain.generalMirrorMode ? idRadioPresetList.x : 0 ; 
        x: 0
        y: systemInfo.titleAreaHeight ;z:-1
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        ////////////////////////////////////////////////////////////////////////////////////
        // JSH 130813 Modify
        //source: !generalMirrorMode ? imageInfo.imgFolderRadio + "bg_dim.png" : imageInfo.imgFolderGeneral+"bg_ch_r_n.png"
        source:imageInfo.imgFolderGeneral + "bg_main.png"
        ////////////////////////////////////////////////////////////////////////////////////
        opacity: 0.6
        visible: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
        MouseArea{anchors.fill: parent;onPressed: {return;}}
    }
    //****************************** # Menu Open (Clicked I, L, Slash key) #
    onClickMenuKey: {
       if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
           return;

       if(idAppMain.state == "AppRadioOptionMenu"){
           gotoBackScreen()
           return;
       }else if(idAppMain.state == "PopupRadioDimAcquiring"){ // JSH 130828
           gotoBackScreen();
       }
        setAppMainScreen( "AppRadioOptionMenu" , true);
    }

    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed: gotoBackScreen()

    //////////////////////////////////////////////////////////////////////////////
    // idRadioMain Functions


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
                if(idAppMain.globalSelectedBand == "AM"){
                    if(globalSelectedAmFrequency <= startAmFrequency)
                        globalSelectedAmFrequency = endAmFrequency//startAmFrequency
                    else    globalSelectedAmFrequency = globalSelectedAmFrequency-stepAmFrequency

                    frequency = globalSelectedAmFrequency
                }
                else{   //FM
                    if(globalSelectedFmFrequency.toFixed(1) <= startFmFrequency) //compare it to first decimal point.
                        globalSelectedFmFrequency = endFmFrequency//startFmFrequency
                    else    globalSelectedFmFrequency = globalSelectedFmFrequency-stepFmFrequency//0.1

                    frequency = globalSelectedFmFrequency.toFixed(1)
                    globalSelectedFmFrequency = frequency;
                }
            }
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
            if(idAppMain.globalSelectedBand == "AM"){
                if(globalSelectedAmFrequency >= endAmFrequency)
                    globalSelectedAmFrequency = startAmFrequency//endAmFrequency
                else    globalSelectedAmFrequency = globalSelectedAmFrequency+stepAmFrequency

                frequency = globalSelectedAmFrequency
            }
            else{   //FM
                if(globalSelectedFmFrequency.toFixed(1) >= endFmFrequency) //compare it to first decimal point.
                    globalSelectedFmFrequency = startFmFrequency//startFmFrequency
                else    globalSelectedFmFrequency = globalSelectedFmFrequency+stepFmFrequency//0.01

                frequency = globalSelectedFmFrequency.toFixed(1)
                globalSelectedFmFrequency = frequency;
            }
        }
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
            QmlController.seekstop(1);
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
        switch(bandNumber)
        {
        case "FM1":
            idMBand.selectedBand = stringInfo.strRadioBandFm1
            UIListener.setSignalSetModelData(0x01);
            idAppMain.globalSelectedBand = "FM1" //select BGImage Change
            QmlController.setRadioBand(0x01);
            var freq ;
            if(QmlController.radioFreq == "")
                freq = idAppMain.startFmFrequency; //0;
            else
                freq = parseFloat(QmlController.radioFreq);

//            idAppMain.globalSelectedBand = "FM1" //select BGImage Change
            idAppMain.globalSelectedFmFrequency = freq;
            console.log("#########RADIO BAND FM1 #########",QmlController.radioFreq,idAppMain.globalSelectedFmFrequency)
            break;
        case "FM2":
            var freq ;
            idMBand.selectedBand = stringInfo.strRadioBandFm2
            UIListener.setSignalSetModelData(0x02);
            idAppMain.globalSelectedBand = "FM2" //select BGImage Change
            QmlController.setRadioBand(0x02);
            if(QmlController.radioFreq == "")
                freq = idAppMain.startFmFrequency; //0;
            else
                freq = parseFloat(QmlController.radioFreq);

//            idAppMain.globalSelectedBand = "FM2" //select BGImage Change
            idAppMain.globalSelectedFmFrequency = freq
            console.log("#########RADIO BAND FM2 #########",QmlController.radioFreq,idAppMain.globalSelectedFmFrequency)
            break;
        case "AM":
            var freq ;
            idMBand.selectedBand = stringInfo.strRadioBandAm
            UIListener.setSignalSetModelData(0x03);
            idAppMain.globalSelectedBand = "AM" //select BGImage Change
            QmlController.setRadioBand(0x03);
            if(QmlController.radioFreq == "")
                freq = idAppMain.startAmFrequency; //0;
            else
                freq = parseInt(QmlController.radioFreq);

//            idAppMain.globalSelectedBand = "AM" //select BGImage Change
            idAppMain.globalSelectedAmFrequency = freq
            console.log("#########RADIO BAND AM #########",QmlController.radioFreq,idAppMain.globalSelectedAmFrequency)
            break;
        }
    }

    function changeBand() {
        console.log(" HJIGKS : stopSentMenu = " + stopSentMenu );
        if( stopSentMenu.length > 0 )
        {
            console.log("1. HJIGKS : stopSentMenu.length = " + stopSentMenu.length );
            setBand(stopSentMenu);
            stopSentMenu = '';
        }
    }
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    onJogFocusStateChanged: { // JSH Jog state
        console.log("++++++++++++++++++++++++++[onJogFocusStateChanged]++++++++++++++++++++ " + " jogFocusState = " + jogFocusState);
        jogFocus(jogFocusState);
    } // function End

    function jogFocus(jog){
        console.log("++++++++++++++++++++++++++[jogFocus]++++++++++++++++++++ " + " jogFocus = " + jog);
    
        if((idAppMain.state != "AppRadioMain") && (idAppMain.state != "PopupRadioDimAcquiring")){
            console.log("onJogFocusStateChanged Return :: ",jog)
            return;
        }

        if(jog != "Band") {
            prevBandJogFocusState = "";   //dg.jin 20150227 bnad down jog focus
        }

        switch(jog){
        case "PresetList"    :{
            if(globalSelectedBand == "FM1")
            {
                if(!idRadioPresetListFM1.activeFocus){
                    idRadioPresetListFM1.forceActiveFocus();
                    //////////////////////////////////////////////////////
                    // JSH 140123
                    if(!((idRadioPresetListFM1.currentIndex >= idRadioPresetListFM1.overContentCount)
                            && (idRadioPresetListFM1.currentIndex < idRadioPresetListFM1.overContentCount+6)))
                    {
                        if(idRadioPresetListFM1.currentIndex < idRadioPresetListFM1.overContentCount)
                            idRadioPresetListFM1.children[3].positionViewAtIndex((idRadioPresetListFM1.currentIndex - (idRadioPresetListFM1.currentIndex%6)), ListView.Beginning);
                        else
                        {
                            idRadioPresetListFM1.children[3].positionViewAtIndex((idRadioPresetListFM1.currentIndex - (idRadioPresetListFM1.currentIndex-idRadioPresetListFM1.overContentCount)%6), ListView.Beginning);
                        }
                    }
                    //////////////////////////////////////////////////////
                }
            }
            else if(globalSelectedBand == "FM2")
            {
                if(!idRadioPresetListFM2.activeFocus){
                    idRadioPresetListFM2.forceActiveFocus();
                    //////////////////////////////////////////////////////
                    // JSH 140123
                    if(!((idRadioPresetListFM2.currentIndex >= idRadioPresetListFM2.overContentCount)
                            && (idRadioPresetListFM2.currentIndex < idRadioPresetListFM2.overContentCount+6)))
                    {
                        if(idRadioPresetListFM2.currentIndex < idRadioPresetListFM2.overContentCount)
                            idRadioPresetListFM2.children[3].positionViewAtIndex((idRadioPresetListFM2.currentIndex - (idRadioPresetListFM2.currentIndex%6)), ListView.Beginning);
                        else
                        {
                            idRadioPresetListFM2.children[3].positionViewAtIndex((idRadioPresetListFM2.currentIndex - (idRadioPresetListFM2.currentIndex-idRadioPresetListFM2.overContentCount)%6), ListView.Beginning);
                        }
                    }
                    //////////////////////////////////////////////////////
                }
            }
            else
            {
                if(!idRadioPresetListAM.activeFocus){
                    idRadioPresetListAM.forceActiveFocus();
                    //////////////////////////////////////////////////////
                    // JSH 140123
                    if(!((idRadioPresetListAM.currentIndex >= idRadioPresetListAM.overContentCount)
                            && (idRadioPresetListAM.currentIndex < idRadioPresetListAM.overContentCount+6)))
                    {
                        if(idRadioPresetListAM.currentIndex < idRadioPresetListAM.overContentCount)
                            idRadioPresetListAM.children[3].positionViewAtIndex((idRadioPresetListAM.currentIndex - (idRadioPresetListAM.currentIndex%6)), ListView.Beginning);
                        else
                        {
                            idRadioPresetListAM.children[3].positionViewAtIndex((idRadioPresetListAM.currentIndex - (idRadioPresetListAM.currentIndex-idRadioPresetListAM.overContentCount)%6), ListView.Beginning);
                        }
                    }
                    //////////////////////////////////////////////////////
                }
            }        

            // Preset Focus or Tune No.1
            if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                    && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
//// 2013.12.07 modified by qutiguy : skip when preset scan starting.
                //QmlController.changeChannel(0x01);
                if(QmlController.searchState != 0x07 )
                    QmlController.changeChannel(0x01);
////
            }
            presetAndDialBackground = jogFocusState;
            break;
        }
        case "FrequencyDial" :{
            if(globalSelectedBand == stringInfo.strRadioBandAm){
                //// 2013.12.08 modified by qutiguy ITS  0213492 Focus lost issues.
                if(!idRadioAmFrequencyDial.activeFocus)
                {
                    fmFrequencyDialFocusBand = globalSelectedBand;
                    idRadioAmFrequencyDial.focus = true;
                    idRadioAmFrequencyDial.forceActiveFocus();
                }
                ////
            }
            else{
                //// 2013.12.08 modified by qutiguy ITS  0213492 Focus lost issues.
                if(!idRadioFmFrequencyDial.activeFocus || globalSelectedBand != fmFrequencyDialFocusBand)
                {
                    fmFrequencyDialFocusBand = globalSelectedBand;
                    idRadioFmFrequencyDial.focus = true;
                    idRadioFmFrequencyDial.forceActiveFocus();
                }
                ////
            }
            presetAndDialBackground = jogFocusState;
            break;
        }
        case "Band"    :{
            if(!idMBand.activeFocus)
                /////////////////////////////////////////////////////////////
                // JSH 130328
                //idMBand.focus = true;
                //if(prevJogFocusState == "PresetList"){ idMBand.giveForceFocus(QmlController.radioBand);}
                if(prevJogFocusState == "PresetList"){ // JSH 130801 ITS[0182046,0182037]
                    if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
                        idMBand.giveForceFocus("backBtn");
                    else
                        idMBand.giveForceFocus(QmlController.radioBand);

                    prevBandJogFocusState = "PresetList";   //dg.jin 20150227 bnad down jog focus
                }
                else if(prevJogFocusState != "Band") { 
                    idMBand.giveForceFocus("menuBtn");
                    prevBandJogFocusState = "";   //dg.jin 20150227 bnad down jog focus
                }
                /////////////////////////////////////////////////////////////
                idMBand.forceActiveFocus();
            break;
        }
        }
        prevJogFocusState = jog; // JSH 130328
    } // function End  
}
