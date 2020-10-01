import Qt 4.7

import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MButton {
    id: idDmbDisasterTabDelegate
    x: 0; y: 0
    width: 276/*-13*/; height: 184
    buttonWidth: 276; buttonHeight: 184

    // # Function #
    function getFgImageNormal(){
        switch(index){
        case 0: return imgFolderDmb+"ico_time_n.png";
        case 1: return imgFolderDmb+"ico_local_n.png";
        case 2: return imgFolderDmb+"ico_urgent_n.png";
        default: console.debug("getFgImageNormal ================ index error!! [index]"+index)
        }
    }
    function getFgImagePress(){
        switch(index){
        case 0: return imgFolderDmb+"ico_time_p.png";
        case 1: return imgFolderDmb+"ico_local_p.png";
        case 2: return imgFolderDmb+"ico_urgent_p.png";
        default: console.debug("getFgImagePress ================ index error!! [index]"+index)
        }
    }
    function getFgImageFocus(){
        switch(index){
        case 0: return imgFolderDmb+"ico_time_f.png";
        case 1: return imgFolderDmb+"ico_local_f.png";
        case 2: return imgFolderDmb+"ico_urgent_f.png";
        default: console.getFgImageFocus("getFgImageFocus ================ index error!! [index]"+index)
        }
    }
    function getFgImageSelected(){
        switch(index){
        case 0: return imgFolderDmb+"ico_time_s.png";
        case 1: return imgFolderDmb+"ico_local_s.png";
        case 2: return imgFolderDmb+"ico_urgent_s.png";
        default: console.debug("getFgImageSelected ================ index error!! [index]"+index)
        }
    }

    // # Button Info
    bgImagePress: imgFolderDmb+"urgent_tab_0"+(index+1)+"_p.png"
    bgImageFocus: imgFolderDmb+"urgent_tab_0"+(index+1)+"_f.png"

    // # Image Info
    fgImageX: 47+45
    fgImageY: 198-systemInfo.headlineHeight
    fgImageWidth: 73
    fgImageHeight: 73
//    fgImage: (dmbDisasterSortType == firstText && idDmbDisasterTabDelegate.activeFocus == false) ? getFgImageSelected() : (dmbDisasterSortType == firstText && idDmbDisasterTabDelegate.activeFocus == true) ? getFgImageFocus() : getFgImageFocus()
    fgImage: (dmbDisasterSortTypeindex == index && idDmbDisasterTabDelegate.activeFocus == false) ? getFgImageSelected() : (dmbDisasterSortTypeindex == index && idDmbDisasterTabDelegate.activeFocus == true) ? getFgImageFocus() : getFgImageFocus()
    fgImagePress: (dmbDisasterSortTypeindex == index && idDmbDisasterTabDelegate.activeFocus == false) ? getFgImageSelected() : getFgImagePress()
//    fgImageFocus: (dmbDisasterSortType == firstText) ? getFgImageFocus() : getFgImageFocus()
    fgImageFocus: (dmbDisasterSortTypeindex == index) ? getFgImageFocus() : getFgImageFocus()
    fgImageActive: (idDmbDisasterTabDelegate.activeFocus == false) ? getFgImageSelected() : fgImageFocus

    // # Text Info # by WSH
    firstText: name
    firstTextX: 42
    firstTextY: 198-systemInfo.headlineHeight+96//-(firstTextSize/2)
    firstTextWidth: 45+118+10
    firstTextHeight: 32+(firstTextSize/8-firstTextSize/4)
    firstTextSize: 32
//    firstTextStyle: (dmbDisasterSortType == firstText) ? idAppMain.fontsB : idAppMain.fontsR
    firstTextStyle: (dmbDisasterSortTypeindex == index) ? idAppMain.fontsB : idAppMain.fontsR
    firstTextHorizontalAlies: "Center"
    firstTextElide: "Right"
//    firstTextColor: (dmbDisasterSortType == firstText && idDmbDisasterTabDelegate.activeFocus == false) ? colorInfo.selectedBlue : (dmbDisasterSortType == firstText && idDmbDisasterTabDelegate.activeFocus == true) ? colorInfo.brightGrey :  colorInfo.brightGrey
    firstTextColor: (dmbDisasterSortTypeindex == index && idDmbDisasterTabDelegate.activeFocus == false) ? colorInfo.selectedBlue : (dmbDisasterSortTypeindex == index && idDmbDisasterTabDelegate.activeFocus == true) ? colorInfo.brightGrey :  colorInfo.brightGrey
    firstTextPressColor: colorInfo.brightGrey
//    firstTextFocusColor: (dmbDisasterSortType == firstText) ? colorInfo.brightGrey :  colorInfo.brightGrey
    firstTextFocusColor: (dmbDisasterSortTypeindex == index) ? colorInfo.brightGrey :  colorInfo.brightGrey
    firstTextSelectedColor: (idDmbDisasterTabDelegate.activeFocus == false) ? colorInfo.selectedBlue : firstTextFocusColor
    firstTextScrollEnable: ( (idDmbDisasterTabDelegate.firstTextOverPaintedWidth == true) &&  (idDmbDisasterTabDelegate.activeFocus == true)
                              && (idAppMain.drivingRestriction == false) ) ? true : false

    //active: (dmbDisasterSortType == firstText)

    // # Line Image #
    Image{
        y: parent.height
        width: 262
        source: imgFolderXMData+"line_left_list_m.png"
    }

    onClickOrKeySelected: {
        if(pressAndHoldFlag == true) return;

        EngineListener.selectDisasterSortTab(index, firstText);

//        //Disaster List Sort by name
//        if(index == 0/*firstText=="By time"*/)
//        { //By time
//            console.log("[DmbDisasterTabDelegate]: By time")
//            MDmbOperation.CmdReqAMASMessageSort("time")
//        }
//        else if(index == 1/*firstText=="By area"*/)
//        { //By area
//            console.log("[DmbDisasterTabDelegate]: By Area")
//            MDmbOperation.CmdReqAMASMessageSort("area")
//        }
//        else
//        { //By priority
//            console.log("[DmbDisasterTabDelegate]: By priority")
//            MDmbOperation.CmdReqAMASMessageSort("priority")
//        }
    }

    onClickReleased: {
        if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
    }

    Keys.onUpPressed: {
        idDmbDisasterBand.focus = true;
        event.accepted = true;
    }

    Keys.onDownPressed: {
        event.accepted = true;
    }

    Connections{
        target:EngineListener
        onSetSorttDisasterMenu:{

            if(idAppMain.state == "AppDmbDisasterOptionMenu"){
                idAppMain.signalHideOptionMenu();
            }
            idDmbDisasterTabDelegate.ListView.view.currentIndex = index
            idDmbDisasterMain.dmbDisasterSortTypeindex = index
            idDmbDisasterMain.dmbDisasterSortType = firstText
            idDmbDisasterTabDelegate.ListView.view.focus = true
            idDmbDisasterTabDelegate.ListView.view.forceActiveFocus()

            if(idDmbDisasterList.disInfoView.count > 0)
            {
                //Disaster List Sort by name
                if(index == 0/*firstText=="By time"*/)
                { //By time
                    MDmbOperation.CmdReqAMASMessageSort("time")
                }
                else if(index == 1/*firstText=="By area"*/)
                { //By area
                    MDmbOperation.CmdReqAMASMessageSort("area")
                }
                else
                { //By priority
                    MDmbOperation.CmdReqAMASMessageSort("priority")
                }

                idDmbDisasterList.disInfoView.currentIndex = 0;
                idDmbDisasterList.disInfoView.focus = true
                idDmbDisasterList.disInfoView.forceActiveFocus()
            }
        }

        onRetranslateUi:{
            firstText = name
            idDmbDisasterTabDelegate.setPaintedWidth();
        }
    }
}
