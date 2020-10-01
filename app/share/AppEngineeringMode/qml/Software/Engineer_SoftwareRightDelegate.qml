import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButton {
    id: idRightMenuDelegate
    width: 537
    height:89
    property int  lastMousePositionY: 0
    property bool isDragItem: false
    property bool isJogItem: false
    property bool isMoveUpScroll: true

    signal changeRow(int fromIndex, int toIndex);
    Connections {
            target: idHeadUnitView
            onItemInitWidth: {
                isDragItem = false;
                if(height*index > 0)
                    y = height*index;
                else y = 0;
           }
            onItemMoved: {
                if(index < idRightMenuDelegate.ListView.view.insertedIndex && index < idRightMenuDelegate.ListView.view.curIndex)
                {
                    y = height*index;
                }else if(index > idRightMenuDelegate.ListView.view.insertedIndex && index > idRightMenuDelegate.ListView.view.curIndex)
                {
                    y = height*index;
                }else if(index > idRightMenuDelegate.ListView.view.insertedIndex && index <= idRightMenuDelegate.ListView.view.curIndex)
                {
                    y = height*index - height;
                }else if(index < idRightMenuDelegate.ListView.view.insertedIndex && index >= idRightMenuDelegate.ListView.view.curIndex)
                {
                    y = height*index + height;
                }else if(index == idRightMenuDelegate.ListView.view.insertedIndex)
                {
                    y = height*idRightMenuDelegate.ListView.view.curIndex
                }
            }
        }

    function checkOnScrollMoved(){
        if((idRightMenuDelegate.ListView.view.contentY + lastMousePositionY)/height != idRightMenuDelegate.ListView.view.curIndex)
        {
            if((idRightMenuDelegate.ListView.view.contentY + lastMousePositionY)/height >= 0 && (idRightMenuDelegate.ListView.view.contentY + lastMousePositionY)/height < (idRightMenuDelegate.ListView.view.count-1))
            {
                idRightMenuDelegate.ListView.view.curIndex = (idRightMenuDelegate.ListView.view.contentY + lastMousePositionY)/height;
                idRightMenuDelegate.ListView.view.itemMoved(0,0);
            }
        }
    } // End function
    function move()
    {
        var contentHeight = idRightMenuDelegate.ListView.view.count * height;
        if(isMoveUpScroll)
        {
            if(idRightMenuDelegate.ListView.view.contentY <= (89/2))
            {
                idRightMenuDelegate.ListView.view.contentY = 0;
                moveTimer.running =false;
            }
            else
                idRightMenuDelegate.ListView.view.contentY -= (89/2);
            checkOnScrollMoved();
        }else
        {
            if(idRightMenuDelegate.ListView.view.contentY >= contentHeight - idRightMenuDelegate.ListView.view.height - (89/2))
            {
                idRightMenuDelegate.ListView.view.contentY = contentHeight - idRightMenuDelegate.ListView.view.height;
                moveTimer.running = false;
            }
            else
                idRightMenuDelegate.ListView.view.contentY += (89/2);
            checkOnScrollMoved();
        }
    } // End function


    Component.onCompleted:{

            //System SW
           if(index == 0){
           //idRightMenuDelegate.firstText="System SW" ;
           idRightMenuDelegate.secondText =VariantSetting.GetSwVersion()
           }//Kernel
           else if(index == 1){

           idRightMenuDelegate.secondText =SystemInfo.GetKernelVersion();
           }//Bios Version
           else if(index == 2){

           idRightMenuDelegate.secondText =SystemInfo.GetBiosVersionFromQML();
           }//Build Date
          else if(index == 3){

           idRightMenuDelegate.secondText =SystemInfo.GetBuildDate();
           }//Micom
           else if(index == 4){

           idRightMenuDelegate.secondText ="" + sw.MICOM_0 +"." + sw.MICOM_1 + "." + sw.MICOM_2;
           } //DECK
           else if(index == 5){
                     idRightMenuDelegate.secondText = ""+deckInfo.FwVersion;    

           }//VR
           else if(index == 6){
               if(verData.VRVer == ""){
                   idRightMenuDelegate.secondText = "Not.Received";
               }else{

                    idRightMenuDelegate.secondText = ""+verData.VRVer;
               }


           }//TTS
           else if(index == 7){
               if(verData.TTSVer == ""){
                   idRightMenuDelegate.secondText = "Not.Received"
               }else{
                   idRightMenuDelegate.secondText = ""+verData.TTSVer;
               }




           }//DMB
           else if(index == 8){
               idRightMenuDelegate.secondText = ""+resVersionInfo.dmbVer;


           }//XM
           else if(index == 9){
               idRightMenuDelegate.secondText = ""+resVersionInfo.XMVer;


           }//HD Radio1
           else if(index == 10){
               idRightMenuDelegate.secondText = ""+sw.HDRadioVer
//               idRightMenuDelegate.firstTextWidth = 150
//               idRightMenuDelegate.secondTextX = 170

           }//HD Radio2
           else if(index == 11){
               idRightMenuDelegate.firstText = ""
//               idRightMenuDelegate.firstTextWidth = 150
//               idRightMenuDelegate.secondTextX = 170

               idRightMenuDelegate.secondText = ""+ sw.HDRadioVer2


           }//DAB
           else if(index == 12){
               idRightMenuDelegate.secondText = "" + resVersionInfo.DABVer;
           }

           //GPS Firmware
           else if(index == 13){

               if(sw.gpsFirmVer1== "0"){
                   idRightMenuDelegate.secondText = "Not.Received";
               }else{
                  idRightMenuDelegate.secondText = ""+sw.gpsFirmVer1+"." +sw.gpsFirmVer2;
               }
//               idRightMenuDelegate.secondText = ""+resVersionInfo.GPSVer;

           }//Navi Map Ver
           else if(index == 14){
               if(SystemInfo.GetNaviMapversion() == ""){
                    idRightMenuDelegate.secondText = "Not.Received";
               }else{
                    idRightMenuDelegate.secondText = SystemInfo.GetNaviMapversion();
               }

           }//Navi Association
           else if(index == 15){
               if(SystemInfo.GetNaviAssociationNumber()==""){
                     idRightMenuDelegate.secondText = "Not.Received";
               }else{
                    idRightMenuDelegate.secondText = SystemInfo.GetNaviAssociationNumber();
               }

           }//FPGA
           else if(index == 16){
               idRightMenuDelegate.secondText = SystemInfo.GetFPGAVersion();


           }//FPGA Driver
           else if(index == 17){
                idRightMenuDelegate.secondText = SystemInfo.GetDriverVersion();


           }//HDD Model
           else if(index == 18){
               idRightMenuDelegate.secondText = hddInfo.model;


           }//HDD Firmware
           else if(index == 19){
                  idRightMenuDelegate.secondText = hddInfo.fwrev;


           }//HDD Serial
           else if(index == 20){
                idRightMenuDelegate.secondText = hddInfo.serno;


           }//INIC VER
           else if(index == 21){
                idRightMenuDelegate.secondText = ""+sw.INICVersion;


           }//INIC MAC Address
           else if(index == 22){
                idRightMenuDelegate.secondText = ""+sw.INICMacAddress;


           }//INIC Node Address
           else if(index == 23){
                idRightMenuDelegate.secondText = ""+ sw.INICNodeAddress;


           }//INIC Device Mode
           else if(index == 24){

                idRightMenuDelegate.secondText = ""+sw.INICDeviceMode;
           }//EEPROM
           else if(index == 25){
                idRightMenuDelegate.secondText = "" + sw.EEPROM_0 +"." + sw.EEPROM_1;

           }//iBoxSwVersion
           else if(index == 26) {
                idRightMenuDelegate.secondText = resVersionInfo.iBoxSwVer1;
           }//iBoxSwVersion2
           else if(index == 27){
               idRightMenuDelegate.firstText = ""
               idRightMenuDelegate.secondText = ""+ resVersionInfo.iBoxSwVer2;

           }

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
//    firstTextPressColor:colorInfo.dimmedGrey
//    firstTextFocusPressColor: colorInfo.brightGrey
    firstTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF"  //RGB(124, 189, 255)
    firstTextFocusColor: colorInfo.brightGrey
    firstTextSize: 25
   // firstTextColor: colorInfo.brightGrey
   // firstTextSize: 32
    firstTextStyle:"HDB"
    firstTextWidth: 230

   // firstTextStyle: "HDB"
//    secondText: versionValue
    secondTextX: 250
    secondTextY: 43
    secondTextSize:20
    secondTextColor: colorInfo.dimmedGrey
//    secondTextPressColor:  colorInfo.brightGrey;
//    secondTextFocusPressColor:  colorInfo.brightGrey;
    secondTextSelectedColor: focusImageVisible?  colorInfo.brightGrey : "#7CBDFF" //RGB(124, 189, 255)
    secondTextFocusColor: colorInfo.brightGrey
    //secondTextSelectedColor: colorInfo.dimmedGrey
    secondTextStyle: "HDB"
    secondTextWidth: 403

//    KeyNavigation.down:idKernel
//    KeyNavigation.up:


//    firstTextX : 9+23
//    firstTextY : 89-43-5

//    KeyNavigation.up:{
//        if(index == 0){
//            backFocus.forceActiveFocus()
//            softwareBand
//        }
//    }

    onClickOrKeySelected: {
//        selectedItem = index
//        setRightMenuScreen(index, true)

//        //setRightMenuScreen(2, true)
//       // setAppMain(selectedItem+2,false)
        idRightMenuDelegate.ListView.view.currentIndex=index
        idRightMenuDelegate.forceActiveFocus()
//        console.log("checkBoxActive : "+index)
//        //upDate()
    }
    Connections{
        target: reqVersion
        onResDmbVersionInfo:{
            if(index == 8){
                idRightMenuDelegate.secondText = ""+resVersionInfo.dmbVer;
            }
        }

    }

    Connections{
        target: SendDeckSignal
        onChangedDeckInfo:{
            if(index == 5){
                idRightMenuDelegate.secondText = ""+deckInfo.FwVersion;
            }

        }
    }

    Connections{
        target: VariantSetting
        onGpsVerReceived:{
            if(index == 13){

                   if(sw.gpsFirmVer1== "0"){
                       idRightMenuDelegate.secondText = "Not.Received";
                   }else{
                      idRightMenuDelegate.secondText = ""+sw.gpsFirmVer1+"." +sw.gpsFirmVer2;
                   }
            //               idRightMenuDelegate.secondText = ""+resVersionInfo.GPSVer;

            }
        }

    }


    Image{
        x:43-23
        y:89
        source: /*index == 9 ? "":*/ imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

