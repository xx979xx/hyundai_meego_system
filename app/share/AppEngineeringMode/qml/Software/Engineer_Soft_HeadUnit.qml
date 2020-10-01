import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idHeadUnitLoader
    x:0; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166

    focus: true
    property int countryInfo: VariantSetting.GetCountryInfo();
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property int overContentCount;  // for RoundScroll
    Connections
    {
        target: reqVersion
        onResDmbVersionInfo:
        {
            if(countryInfo == 0)
            {
                headunitData.setProperty(8,"VersionInfo", resVersionInfo.dmbVer  )
            }
        }
    }
    Connections
    {
        target: SendDeckSignal
        onChangedDeckInfo:{
            headunitData.setProperty(5,"VersionInfo", deckInfo.FwVersion  )
            if(countryInfo == 1)
            {
                headunitData.setProperty(8,"VersionInfo", resVersionInfo.XMVer  )
                headunitData.setProperty(9,"VersionInfo", sw.HDRadioVer + "\n" +sw.HDRadioVer2  )
            }
            else if(countryInfo == 5)
            {
                headunitData.setProperty(8,"VersionInfo", resVersionInfo.DABVer  )
            }
        }
    }
    Connections
    {
        target:UIListener
        onClearSoftVerModel:
        {
            console.debug("[QML] Clear Software Version List Model -----------------");
            headunitData.clear();
        }
        onRefreshSoftVerInfo:
        {
            headunitData.append({"moduleName": "System SW", "VersionInfo": VariantSetting.GetSwVersion()})
            headunitData.append({"moduleName": "Kernel", "VersionInfo": SystemInfo.GetKernelVersion()})
            headunitData.append({"moduleName": "Bios", "VersionInfo": SystemInfo.GetBiosVersionFromQML()})
            headunitData.append({"moduleName": "Build Date", "VersionInfo": SystemInfo.GetBuildDate()})
            headunitData.append({"moduleName": "Micom", "VersionInfo": sw.MICOM_VER})
            headunitData.append({"moduleName": "DECK", "VersionInfo": deckInfo.FwVersion})
            if(countryInfo != 2 )
            {
                headunitData.append({"moduleName": "VR", "VersionInfo": verData.VRVer})
                headunitData.append({"moduleName": "TTS", "VersionInfo": verData.TTSVer})
            }
            if(countryInfo == 0)
            {
                headunitData.append({"moduleName": "DMB", "VersionInfo": resVersionInfo.dmbVer})
            }
            if(countryInfo == 1 || countryInfo == 6)
            {
                headunitData.append({"moduleName": "XM", "VersionInfo": resVersionInfo.XMVer})
            }
            if(countryInfo == 1)
            {
                headunitData.append({"moduleName": "HD Radio", "VersionInfo": sw.HDRadioVer + "\n" +sw.HDRadioVer2})
            }
            if(countryInfo == 5 || countryInfo == 7)
            {
                headunitData.append({"moduleName": "DAB", "VersionInfo": resVersionInfo.DABVer})
            }
            headunitData.append({"moduleName": "GPS Firmware", "VersionInfo": VariantSetting.GetGpsVersion()})
            headunitData.append({"moduleName": "Navi Map Ver", "VersionInfo": SystemInfo.GetNaviMapversion()})
            headunitData.append({"moduleName": "Navi Association", "VersionInfo": SystemInfo.GetNaviAssociationNumber()})
            headunitData.append({"moduleName": "FPGA", "VersionInfo": SystemInfo.GetFPGAVersion()})
            headunitData.append({"moduleName": "FPGA Driver", "VersionInfo": SystemInfo.GetDriverVersion()})
            headunitData.append({"moduleName": "HDD Model", "VersionInfo": hddInfo.model})
            headunitData.append({"moduleName": "HDD Firmware", "VersionInfo": hddInfo.fwrev})
            headunitData.append({"moduleName": "HDD Serial", "VersionInfo": hddInfo.serno})

            UIListener.printLogMessage("getCarHwType : " + VariantSetting.getCarHwType())
            if( VariantSetting.getCarHwType() == "DH PE" ){

                if(countryInfo == 0 || countryInfo == 1 || countryInfo == 2){

                    headunitData.append({"moduleName": "INIC Ver", "VersionInfo": sw.INICVersion})
                    headunitData.append({"moduleName": "INIC MAC Addr", "VersionInfo": sw.INICMacAddress})
                    headunitData.append({"moduleName": "INIC Node Addr", "VersionInfo": sw.INICNodeAddress})
                    headunitData.append({"moduleName": "INIC Device Mode", "VersionInfo": sw.INICDeviceMode})
                }
            }
            else{

                headunitData.append({"moduleName": "INIC Ver", "VersionInfo": sw.INICVersion})
                headunitData.append({"moduleName": "INIC MAC Addr", "VersionInfo": sw.INICMacAddress})
                headunitData.append({"moduleName": "INIC Node Addr", "VersionInfo": sw.INICNodeAddress})
                headunitData.append({"moduleName": "INIC Device Mode", "VersionInfo": sw.INICDeviceMode})
            }



            headunitData.append({"moduleName": "EEPROM", "VersionInfo": sw.EEPROM_0 +"." + sw.EEPROM_1})
            if(countryInfo == 0 || countryInfo == 1 || countryInfo == 2)
            {
                 headunitData.append({"moduleName": "iBoxSwVersion", "VersionInfo": resVersionInfo.iBoxSwVer1})
                 headunitData.append({"moduleName": "", "VersionInfo": resVersionInfo.iBoxSwVer2})
            }
        }
    }

    Component.onCompleted:{
        //        VariantSetting.reqGPSVersion();
        UIListener.autoTest_athenaSendObject();
        headunitData.append({"moduleName": "System SW", "VersionInfo": VariantSetting.GetSwVersion()})
        headunitData.append({"moduleName": "Kernel", "VersionInfo": SystemInfo.GetKernelVersion()})
        headunitData.append({"moduleName": "Bios", "VersionInfo": SystemInfo.GetBiosVersionFromQML()})
        headunitData.append({"moduleName": "Build Date", "VersionInfo": SystemInfo.GetBuildDate()})
        headunitData.append({"moduleName": "Micom", "VersionInfo": sw.MICOM_VER})
        headunitData.append({"moduleName": "DECK", "VersionInfo": deckInfo.FwVersion})
        if(countryInfo != 2 )
        {
            headunitData.append({"moduleName": "VR", "VersionInfo": verData.VRVer})
            headunitData.append({"moduleName": "TTS", "VersionInfo": verData.TTSVer})
        }
        if(countryInfo == 0)
        {
            headunitData.append({"moduleName": "DMB", "VersionInfo": resVersionInfo.dmbVer})
        }
        if(countryInfo == 1 || countryInfo == 6)
        {
            headunitData.append({"moduleName": "XM", "VersionInfo": resVersionInfo.XMVer})
        }
        if(countryInfo == 1)
        {
            headunitData.append({"moduleName": "HD Radio", "VersionInfo": sw.HDRadioVer + "\n" +sw.HDRadioVer2})
        }
        if(countryInfo == 5 || countryInfo == 7)
        {
            headunitData.append({"moduleName": "DAB", "VersionInfo": resVersionInfo.DABVer})
        }
        headunitData.append({"moduleName": "GPS Firmware", "VersionInfo": VariantSetting.GetGpsVersion()})
        headunitData.append({"moduleName": "Navi Map Ver", "VersionInfo": SystemInfo.GetNaviMapversion()})
        headunitData.append({"moduleName": "Navi Association", "VersionInfo": SystemInfo.GetNaviAssociationNumber()})
        headunitData.append({"moduleName": "FPGA", "VersionInfo": SystemInfo.GetFPGAVersion()})
        headunitData.append({"moduleName": "FPGA Driver", "VersionInfo": SystemInfo.GetDriverVersion()})
        headunitData.append({"moduleName": "HDD Model", "VersionInfo": hddInfo.model})
        headunitData.append({"moduleName": "HDD Firmware", "VersionInfo": hddInfo.fwrev})
        headunitData.append({"moduleName": "HDD Serial", "VersionInfo": hddInfo.serno})

        UIListener.printLogMessage("getCarHwType : " + VariantSetting.getCarHwType())
        if( VariantSetting.getCarHwType() == "DH PE" ){

            if(countryInfo == 0 || countryInfo == 1 || countryInfo == 2){

                headunitData.append({"moduleName": "INIC Ver", "VersionInfo": sw.INICVersion})
                headunitData.append({"moduleName": "INIC MAC Addr", "VersionInfo": sw.INICMacAddress})
                headunitData.append({"moduleName": "INIC Node Addr", "VersionInfo": sw.INICNodeAddress})
                headunitData.append({"moduleName": "INIC Device Mode", "VersionInfo": sw.INICDeviceMode})
            }
        }
        else{

            headunitData.append({"moduleName": "INIC Ver", "VersionInfo": sw.INICVersion})
            headunitData.append({"moduleName": "INIC MAC Addr", "VersionInfo": sw.INICMacAddress})
            headunitData.append({"moduleName": "INIC Node Addr", "VersionInfo": sw.INICNodeAddress})
            headunitData.append({"moduleName": "INIC Device Mode", "VersionInfo": sw.INICDeviceMode})
        }


        headunitData.append({"moduleName": "EEPROM", "VersionInfo": sw.EEPROM_0 +"." + sw.EEPROM_1})
        if(countryInfo == 0 || countryInfo == 1 || countryInfo == 2)
        {
             headunitData.append({"moduleName": "iBoxSwVersion", "VersionInfo": resVersionInfo.iBoxSwVer1})
             headunitData.append({"moduleName": "", "VersionInfo": resVersionInfo.iBoxSwVer2})
        }


    }
    ListModel
    {
        id:headunitData
    }

    //    ListModel{
    //        id:headunitData
    //        ListElement {   name:"System SW" ; gridId:0} //0
    //        ListElement {   name:"Kernel" ;   gridId:1 } //1
    //        ListElement {   name:"Bios"; gridId:2   }
    //        ListElement {   name:"Build Date" ;  gridId:3   } //2
    //        ListElement {   name:"Micom" ;  gridId:4    } //3
    //        ListElement {   name:"DECK"; gridId:5   }//4
    //        ListElement {   name:"VR"; gridId:6 }//5
    //        ListElement {   name:"TTS"; gridId:7    }//6
    //        ListElement {   name:"DMB"; gridId:8}
    //        ListElement {   name:"XM";   gridId:9}
    //        ListElement {   name:"HD Radio"; gridId:10}
    //       //ListElement {   name:"HD Radio2";  gridId:11}
    //       ListElement  { name:"DAB"; gridId:11}
    //        ListElement {   name:"GPS Firmware"; gridId:12}
    //        ListElement {   name:"Navi Map Ver"; gridId:13}
    //        ListElement {   name:"Navi Association"; gridId:14}
    //        ListElement {   name:"FPGA"; gridId:15}
    //        ListElement {   name:"FPGA Driver"; gridId:16}
    //        ListElement {   name:"HDD Model"; gridId:17}
    //        ListElement {   name:"HDD Firmware"; gridId:18}
    //        ListElement {   name:"HDD Serial"; gridId:19}
    //        ListElement {   name:"INIC Ver"; gridId:20}
    //        ListElement {   name:"INIC MAC Addr"; gridId:21}
    //        ListElement {   name:"INIC Node Addr"; gridId:22}
    //        ListElement {   name:"INIC Device Mode"; gridId:23}
    //        ListElement {   name:"EEPROM"; gridId:24}
    //        ListElement {   name:"iBoxSwVersion"; gridId:25 }
    //        ListElement { name: "iBoxSwVersion2"; girdId:26}
    //    }
    ListView{
        id:idHeadUnitView

        clip: true
        focus: true
        anchors.fill: parent;
        model: headunitData

        delegate: Engineer_Soft_HeadUnitDelegate{
                     id: idSoftwareHeadUnitDelegate
                    onWheelLeftKeyPressed:idHeadUnitView.decrementCurrentIndex()
                    onWheelRightKeyPressed:idHeadUnitView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
        highlightMoveSpeed: 99999

    }

    //--------------------- ScrollBar #
    MComp.MScroll {
        property int  scrollWidth: 14
        property int  scrollY: 5
        x:systemInfo.lcdWidth-708 -30; y:/*idTotalChList.y+*/scrollY; z:1
        scrollArea: idHeadUnitView;
        height: idHeadUnitView.height-(scrollY*2)-8; width: scrollWidth
        //        anchors.right: idHeadUnitView.right
        anchors.verticalCenter: parent.verticalCenter
        visible: true
    } //# End MScroll


}

