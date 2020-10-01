import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButton {
    id: idRightMenuUSBDelegate
    width: 537
    height:89
    z:300


    property color grey:            Qt.rgba(193/255, 193/255, 193/255, 1)
    property color dimmedGrey:      Qt.rgba(158/255, 158/255, 158/255, 1)
    property color bandBlue:        Qt.rgba( 124/255, 189/255, 225/255, 1)
    Component.onCompleted:{
            //Kernel
           if(index == 0){
                     idRightMenuUSBDelegate.secondText ="";
                     idRightMenuUSBDelegate.firstTextColor = bandBlue
           }//Kernel Current Version
           else if(index == 1){
                      idRightMenuUSBDelegate.secondText =SystemInfo.GetKernelVersion();
           }//Kernel Update Version
          else if(index == 2){
                     idRightMenuUSBDelegate.firstTextColor = grey
                     idRightMenuUSBDelegate.secondTextColor = dimmedGrey
                     idRightMenuUSBDelegate.secondText =UpgradeVerString.ker_ver;
           }//Platform
           else if(index == 3){
                       idRightMenuUSBDelegate.firstTextColor = bandBlue
                       idRightMenuUSBDelegate.secondText ="";
           } //Platform Current Version
           else if(index == 4){
               idRightMenuUSBDelegate.secondText = SystemInfo.GetPlatformVersion();
           }//Platform Update Version
           else if(index == 5){
               idRightMenuUSBDelegate.firstTextColor = grey
               idRightMenuUSBDelegate.secondTextColor = dimmedGrey
               idRightMenuUSBDelegate.secondText = SystemInfo.updatePlatVerPresent();
           }//Software
           else if(index == 6){
                idRightMenuUSBDelegate.firstTextColor = bandBlue
                idRightMenuUSBDelegate.secondText ="";
           }//Software Current Version
           else if(index == 7){
               idRightMenuUSBDelegate.secondText =SystemInfo.GetSoftWareVersion();
           }//Software Update Version
           else if(index == 8){
               idRightMenuUSBDelegate.firstTextColor = grey
               idRightMenuUSBDelegate.secondTextColor = dimmedGrey
               idRightMenuUSBDelegate.secondText =UpgradeVerString.sw_ver;
           }//MICOM
           else if(index == 9){
               idRightMenuUSBDelegate.firstTextColor = bandBlue
               idRightMenuUSBDelegate.secondText ="";
           }//MICOM Current Version
           else if(index == 10){
               idRightMenuUSBDelegate.secondText =sw.MICOM_0 +"." + sw.MICOM_1 + "." + sw.MICOM_2;
           }//MICOM Update Version
           else if(index == 11){
               idRightMenuUSBDelegate.firstTextColor = grey
               idRightMenuUSBDelegate.secondTextColor = dimmedGrey
               idRightMenuUSBDelegate.secondText =UpgradeVerString.micom_ver;
           }//


    }

    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    //bgImagePress: imgFolderGeneral+"bg_menu_tab_l_p.png"
    //bgImageActive: imgFolderGeneral+"bg_menu_tab_l_s.png"
    bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"

  //. active: index==selectedItem
    firstText : name
    firstTextX: 20
    firstTextY: 43
    firstTextColor: colorInfo.brightGrey
    firstTextSelectedColor: colorInfo.brightGrey
    firstTextSize: 25
    firstTextStyle:"HDB"
    firstTextWidth: 230

    secondTextX: 250
    secondTextY: 43
    secondTextSize:20
    secondTextColor: colorInfo.dimmedGrey
    secondTextSelectedColor: focusImageVisible?  colorInfo.brightGrey : "#7CBDFF" //RGB(124, 189, 255)
    secondTextFocusColor: colorInfo.brightGrey
    secondTextStyle: "HDB"
    secondTextWidth: 403

    KeyNavigation.up:{
        if(index == 0){
            backFocus.forceActiveFocus()
            updateBand
        }
    }
    onClickOrKeySelected: {

        idRightMenuUSBDelegate.ListView.view.currentIndex=index
        idRightMenuUSBDelegate.forceActiveFocus()

    }
    Connections{
        target:UpgradeVerInfo
        onUpdateVersionInfo:{
            //Kernel
           if(index == 0){
                     idRightMenuUSBDelegate.secondText ="";
                     idRightMenuUSBDelegate.firstTextColor = bandBlue
           }//Kernel Current Version
           else if(index == 1){
                      idRightMenuUSBDelegate.secondText =SystemInfo.GetKernelVersion();
           }//Kernel Update Version
          else if(index == 2){
                     idRightMenuUSBDelegate.firstTextColor = grey
                     idRightMenuUSBDelegate.secondTextColor = dimmedGrey
                     idRightMenuUSBDelegate.secondText =UpgradeVerString.ker_ver;
           }//Platform
           else if(index == 3){
                       idRightMenuUSBDelegate.firstTextColor = bandBlue
                       idRightMenuUSBDelegate.secondText ="";
           } //Platform Current Version
           else if(index == 4){
               idRightMenuUSBDelegate.secondText = SystemInfo.GetPlatformVersion();
           }//Platform Update Version
           else if(index == 5){
               idRightMenuUSBDelegate.firstTextColor = grey
               idRightMenuUSBDelegate.secondTextColor = dimmedGrey
               idRightMenuUSBDelegate.secondText = SystemInfo.updatePlatVerPresent();
           }//Software
           else if(index == 6){
                idRightMenuUSBDelegate.firstTextColor = bandBlue
                idRightMenuUSBDelegate.secondText ="";
           }//Software Current Version
           else if(index == 7){
               idRightMenuUSBDelegate.secondText =SystemInfo.GetSoftWareVersion();
           }//Software Update Version
           else if(index == 8){
               idRightMenuUSBDelegate.firstTextColor = grey
               idRightMenuUSBDelegate.secondTextColor = dimmedGrey
               idRightMenuUSBDelegate.secondText =UpgradeVerString.sw_ver;
           }//MICOM
           else if(index == 9){
               idRightMenuUSBDelegate.firstTextColor = bandBlue
               idRightMenuUSBDelegate.secondText ="";
           }//MICOM Current Version
           else if(index == 10){
               idRightMenuUSBDelegate.secondText =sw.MICOM_0 +"." + sw.MICOM_1 + "." + sw.MICOM_2;
           }//MICOM Update Version
           else if(index == 11){
               idRightMenuUSBDelegate.firstTextColor = grey
               idRightMenuUSBDelegate.secondTextColor = dimmedGrey
               idRightMenuUSBDelegate.secondText =UpgradeVerString.micom_ver;
           }//
        }
    }

    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

