import Qt 4.7
import "../Component" as MComp
import "../System" as MSystem
import com.engineer.data 1.0

MComp.MComponent {
    id:idVersionCompareListView
    width: parent.width
    height: parent.height
    focus: true
    property int countryInfo: VariantSetting.GetCountryInfo();
    Connections
    {
        target:SystemInfo
        onUpdateHDVersion:
        {
            if(countryInfo == 1)
            {
                SystemInfo.CompareVersion();
                idverCompareModel.clear();
                console.debug("[QML] Update HD Version  -----------------");
                idverCompareModel.setProperty(4, "releaseVersion2", SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleHDRADIO))
                idverCompareModel.setProperty(4, "readVersion2", SystemInfo.GetReadModuleVersion(EngineerData.ModuleHDRADIO))
                idverCompareModel.setProperty(4, "result2", SystemInfo.GetCompareResult(EngineerData.ModuleHDRADIO))
                idverCompareModel.setProperty(4, "resultColor2", SystemInfo.GetFontColor(EngineerData.ModuleHDRADIO))

            }
        }
    }

    Connections
    {
        target: UIListener
        onClearVersionModel:
        {
            console.debug("[QML] Clear Version List Model -----------------");
            idverCompareModel.clear();
        }

        onRefreshVerCompareInfo:
        {
            //idverCompareModel.clear()

            idverCompareModel.append({"moduleName":"Module", "releaseVersion":"ReleaseVersion", "readVersion":"Read Version","result":"Result","resultColor": Qt.rgba(158/255, 158/255, 158/255, 1),
                                     "moduleName2": "Module", "releaseVersion2":"ReleaseVersion", "readVersion2": "Read Version", "result2": "Result", "resultColor2": Qt.rgba(158/255, 158/255, 158/255, 1)});
            if(countryInfo == 0){
                //Bios, DMB
                idverCompareModel.append({"moduleName":"Bios", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleBios),
                                         "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleBios),"result":SystemInfo.GetCompareResult(EngineerData.ModuleBios),
                                         "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleBios),
                                         "moduleName2": "DMB", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleDMB),
                                         "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleDMB),
                                         "result2": SystemInfo.GetCompareResult(EngineerData.ModuleDMB), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleDMB)});
            }
            else{
                //Bios, DMB
                idverCompareModel.append({"moduleName":"Bios", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleBios),
                                         "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleBios),"result":SystemInfo.GetCompareResult(EngineerData.ModuleBios),
                                         "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleBios),
                                         "moduleName2": "", "releaseVersion2":"",
                                         "readVersion2": "",
                                         "result2": "", "resultColor2" : ""});
            }


            //ssd, partition Info
            idverCompareModel.append({"moduleName":"SSD", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleSSD),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleSSD),"result":SystemInfo.GetCompareResult(EngineerData.ModuleSSD),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleSSD),
                                     "moduleName2": "Partition Info", "releaseVersion2":"",
                                     "readVersion2": SystemInfo.GetPartitionVersionFromQML(),
                                     "result2": "", "resultColor2" : "grey"});
            //micom, Deck
            idverCompareModel.append({"moduleName":"Micom", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleMicom),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleMicom),"result":SystemInfo.GetCompareResult(EngineerData.ModuleMicom),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleMicom),
                                     "moduleName2": "Deck", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleDECK),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleDECK),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleDECK), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleDECK)});

            //variant : USA
            if(countryInfo == 1){
               // if vairnat info == N.A : xm, hd radio
               idverCompareModel.append({"moduleName":"XM", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleXM),
                                        "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleXM),"result":SystemInfo.GetCompareResult(EngineerData.ModuleXM),
                                        "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleXM),
                                        "moduleName2": "HD Radio", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleHDRADIO),
                                        "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleHDRADIO),
                                        "result2": SystemInfo.GetCompareResult(EngineerData.ModuleHDRADIO), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleHDRADIO)});
           } //variant : CANADA
            else if(countryInfo == 6){
                idverCompareModel.append({"moduleName":"XM", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleXM),
                                         "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleXM),"result":SystemInfo.GetCompareResult(EngineerData.ModuleXM),
                                         "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleXM),
                                         "moduleName2": "", "releaseVersion2":"",
                                         "readVersion2": "",
                                         "result2": "", "resultColor2" : ""});
            }

            //front monitor, rear monitor
            idverCompareModel.append({"moduleName":"FrontMonitor", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleFrontMonitor),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleFrontMonitor),"result":SystemInfo.GetCompareResult(EngineerData.ModuleFrontMonitor),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleFrontMonitor),
                                     "moduleName2": "RearMonitor", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleRearMonitor),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleRearMonitor),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleRearMonitor), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleRearMonitor)});

            if(countryInfo != 2){
            //vocon, tts
            idverCompareModel.append({"moduleName":"Vocon", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleVRVocon),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleVRVocon),"result":SystemInfo.GetCompareResult(EngineerData.ModuleVRVocon),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleVRVocon),
                                     "moduleName2": "TTS", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleTTSVocalizer),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleTTSVocalizer),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleTTSVocalizer), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleTTSVocalizer)});
            }

            UIListener.printLogMessage("VersionCompare: getCarHwType : " + VariantSetting.getCarHwType())
            if( VariantSetting.getCarHwType() == "DH PE" ){

                if(countryInfo == 0 || countryInfo == 1 || countryInfo == 2){
                    //inic, fpga fw
                    idverCompareModel.append({"moduleName":"INIC", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleINIC),
                                             "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleINIC),"result":SystemInfo.GetCompareResult(EngineerData.ModuleINIC),
                                             "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleINIC),
                                             "moduleName2": "FPGA Fw", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleFPGAFw),
                                             "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleFPGAFw),
                                             "result2": SystemInfo.GetCompareResult(EngineerData.ModuleFPGAFw), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleFPGAFw)});

                }
                else{

                    //inic, fpga fw
                    idverCompareModel.append({"moduleName":"", "releaseVersion":"",
                                             "readVersion":"","result":"",
                                             "resultColor": "",
                                             "moduleName2": "FPGA Fw", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleFPGAFw),
                                             "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleFPGAFw),
                                             "result2": SystemInfo.GetCompareResult(EngineerData.ModuleFPGAFw), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleFPGAFw)});
                }
            }
            else{
                //inic, fpga fw
                idverCompareModel.append({"moduleName":"INIC", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleINIC),
                                         "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleINIC),"result":SystemInfo.GetCompareResult(EngineerData.ModuleINIC),
                                         "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleINIC),
                                         "moduleName2": "FPGA Fw", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleFPGAFw),
                                         "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleFPGAFw),
                                         "result2": SystemInfo.GetCompareResult(EngineerData.ModuleFPGAFw), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleFPGAFw)});

            }



            //ccp, rrc
            idverCompareModel.append({"moduleName":"CCP", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleCCP),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleCCP),"result":SystemInfo.GetCompareResult(EngineerData.ModuleCCP),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleCCP),
                                     "moduleName2": "RRC", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleRRC),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleRRC),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleRRC), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleRRC)});
            //variant : KOR, USA, CHN
            if(countryInfo == 0 || countryInfo == 1 || countryInfo == 2){
            //bluetooth, ibox
            idverCompareModel.append({"moduleName":"Bluetooth", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleBluetooth),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleBluetooth),"result":SystemInfo.GetCompareResult(EngineerData.ModuleBluetooth),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleBluetooth),
                                     "moduleName2": "IBOX", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleIBOX),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleIBOX),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleIBOX), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleIBOX)});
            }
            else{
                //bluetooth, delete: ibox
                idverCompareModel.append({"moduleName":"Bluetooth", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleBluetooth),
                                         "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleBluetooth),"result":SystemInfo.GetCompareResult(EngineerData.ModuleBluetooth),
                                         "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleBluetooth),
                                         "moduleName2": "", "releaseVersion2":"",
                                         "readVersion2": "",
                                         "result2": "", "resultColor2" : ""});
            }

            //gps, amp
            idverCompareModel.append({"moduleName":"GPS", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleGPS),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleGPS),"result":SystemInfo.GetCompareResult(EngineerData.ModuleGPS),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleGPS),
                                     "moduleName2": "AMP", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleAMP),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleAMP),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleAMP), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleAMP)});


            //Navi(korea, US)
            idverCompareModel.append({"moduleName":"NAVI", "releaseVersion": "",
                                     "readVersion": SystemInfo.GetNaviAssociationNumber() ,"result": "",
                                     "resultColor": "",
                                     "moduleName2": "", "releaseVersion2": "",
                                     "readVersion2": "",
                                     "result2": "", "resultColor2" : ""});


//            //Navi(korea, US)
//            idverCompareModel.append({"moduleName":"NAVI(Korea)", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIKo),
//                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIKo),"result":SystemInfo.GetCompareResult(EngineerData.ModuleNAVIKo),
//                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleNAVIKo),
//                                     "moduleName2": "NAVI(US)", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIUs),
//                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIUs),
//                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleNAVIUs), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleNAVIUs)});

//            //Navi(China, M.E)
//            idverCompareModel.append({"moduleName":"NAVI(China)", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIChn),
//                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIChn),"result":SystemInfo.GetCompareResult(EngineerData.ModuleNAVIChn),
//                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleNAVIChn),
//                                     "moduleName2": "NAVI(MES)", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIMes),
//                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIMes),
//                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleNAVIMes), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleNAVIMes)});

//            //Navi(Europe, Canada)
//            idverCompareModel.append({"moduleName":"NAVI(Europe)", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIEU),
//                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIEU),"result":SystemInfo.GetCompareResult(EngineerData.ModuleNAVIEU),
//                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleNAVIEU),
//                                     "moduleName2": "NAVI(Canada)", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVICanada),
//                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVICanada),
//                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleNAVICanada), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleNAVICanada)});

//            //navi(Russia, Australia)
//            idverCompareModel.append({"moduleName":"NAVI(Russia)", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIRu),
//                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIRu),"result":SystemInfo.GetCompareResult(EngineerData.ModuleNAVIRu),
//                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleNAVIRu),
//                                     "moduleName2": "NAVI(Australia)", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIAUS),
//                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIAUS),
//                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleNAVIAUS), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleNAVIAUS)});




            //variant : EU, RUSSIA
            if(countryInfo == 5 || countryInfo == 7 ){
                idverCompareModel.append({"moduleName":"DAB", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleDAB),
                                         "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleDAB),"result":SystemInfo.GetCompareResult(EngineerData.ModuleDAB),
                                         "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleDAB),
                                         "moduleName2": "", "releaseVersion2":"",
                                         "readVersion2": "",
                                         "result2": "", "resultColor2" : ""});
            }
        }
    }

    Component.onCompleted:
    {
        idverCompareModel.append({"moduleName":"Module", "releaseVersion":"ReleaseVersion", "readVersion":"Read Version","result":"Result","resultColor": Qt.rgba(158/255, 158/255, 158/255, 1),
                                 "moduleName2": "Module", "releaseVersion2":"ReleaseVersion", "readVersion2": "Read Version", "result2": "Result", "resultColor2": Qt.rgba(158/255, 158/255, 158/255, 1)});
        if(countryInfo == 0){
            //Bios, DMB
            idverCompareModel.append({"moduleName":"Bios", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleBios),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleBios),"result":SystemInfo.GetCompareResult(EngineerData.ModuleBios),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleBios),
                                     "moduleName2": "DMB", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleDMB),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleDMB),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleDMB), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleDMB)});
        }
        else{
            //Bios, DMB
            idverCompareModel.append({"moduleName":"Bios", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleBios),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleBios),"result":SystemInfo.GetCompareResult(EngineerData.ModuleBios),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleBios),
                                     "moduleName2": "", "releaseVersion2":"",
                                     "readVersion2": "",
                                     "result2": "", "resultColor2" : ""});
        }
        //ssd, partition Info
        idverCompareModel.append({"moduleName":"SSD", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleSSD),
                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleSSD),"result":SystemInfo.GetCompareResult(EngineerData.ModuleSSD),
                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleSSD),
                                 "moduleName2": "Partition Info", "releaseVersion2":"",
                                 "readVersion2": SystemInfo.GetPartitionVersionFromQML(),
                                 "result2": "", "resultColor2" : "grey"});
        //micom, Deck
        idverCompareModel.append({"moduleName":"Micom", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleMicom),
                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleMicom),"result":SystemInfo.GetCompareResult(EngineerData.ModuleMicom),
                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleMicom),
                                 "moduleName2": "Deck", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleDECK),
                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleDECK),
                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleDECK), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleDECK)});


         if(countryInfo == 1){
            // if vairnat info == N.A : xm, hd radio
            idverCompareModel.append({"moduleName":"XM", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleXM),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleXM),"result":SystemInfo.GetCompareResult(EngineerData.ModuleXM),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleXM),
                                     "moduleName2": "HD Radio", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleHDRADIO),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleHDRADIO),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleHDRADIO), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleHDRADIO)});
        }
         else if(countryInfo == 6){
             idverCompareModel.append({"moduleName":"XM", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleXM),
                                      "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleXM),"result":SystemInfo.GetCompareResult(EngineerData.ModuleXM),
                                      "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleXM),
                                      "moduleName2": "", "releaseVersion2":"",
                                      "readVersion2": "",
                                      "result2": "", "resultColor2" : ""});
         }


        //front monitor, rear monitor
        idverCompareModel.append({"moduleName":"FrontMonitor", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleFrontMonitor),
                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleFrontMonitor),"result":SystemInfo.GetCompareResult(EngineerData.ModuleFrontMonitor),
                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleFrontMonitor),
                                 "moduleName2": "RearMonitor", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleRearMonitor),
                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleRearMonitor),
                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleRearMonitor), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleRearMonitor)});

        if(countryInfo != 2){
        //vocon, tts
        idverCompareModel.append({"moduleName":"Vocon", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleVRVocon),
                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleVRVocon),"result":SystemInfo.GetCompareResult(EngineerData.ModuleVRVocon),
                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleVRVocon),
                                 "moduleName2": "TTS", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleTTSVocalizer),
                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleTTSVocalizer),
                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleTTSVocalizer), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleTTSVocalizer)});
        }

        UIListener.printLogMessage("VersionCompare: getCarHwType : " + VariantSetting.getCarHwType())
        if( VariantSetting.getCarHwType() == "DH PE" ){

            if(countryInfo == 0 || countryInfo == 1 || countryInfo == 2){
                //inic, fpga fw
                idverCompareModel.append({"moduleName":"INIC", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleINIC),
                                         "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleINIC),"result":SystemInfo.GetCompareResult(EngineerData.ModuleINIC),
                                         "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleINIC),
                                         "moduleName2": "FPGA Fw", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleFPGAFw),
                                         "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleFPGAFw),
                                         "result2": SystemInfo.GetCompareResult(EngineerData.ModuleFPGAFw), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleFPGAFw)});

            }
            else{

                //inic, fpga fw
                idverCompareModel.append({"moduleName":"", "releaseVersion":"",
                                         "readVersion":"","result":"",
                                         "resultColor": "",
                                         "moduleName2": "FPGA Fw", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleFPGAFw),
                                         "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleFPGAFw),
                                         "result2": SystemInfo.GetCompareResult(EngineerData.ModuleFPGAFw), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleFPGAFw)});
            }
        }
        else{
            //inic, fpga fw
            idverCompareModel.append({"moduleName":"INIC", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleINIC),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleINIC),"result":SystemInfo.GetCompareResult(EngineerData.ModuleINIC),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleINIC),
                                     "moduleName2": "FPGA Fw", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleFPGAFw),
                                     "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleFPGAFw),
                                     "result2": SystemInfo.GetCompareResult(EngineerData.ModuleFPGAFw), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleFPGAFw)});

        }

        //ccp, rrc
        idverCompareModel.append({"moduleName":"CCP", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleCCP),
                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleCCP),"result":SystemInfo.GetCompareResult(EngineerData.ModuleCCP),
                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleCCP),
                                 "moduleName2": "RRC", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleRRC),
                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleRRC),
                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleRRC), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleRRC)});

        if(countryInfo == 0 || countryInfo == 1 || countryInfo == 2){
        //bluetooth, ibox
        idverCompareModel.append({"moduleName":"Bluetooth", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleBluetooth),
                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleBluetooth),"result":SystemInfo.GetCompareResult(EngineerData.ModuleBluetooth),
                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleBluetooth),
                                 "moduleName2": "IBOX", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleIBOX),
                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleIBOX),
                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleIBOX), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleIBOX)});
        }
        else{
            //bluetooth, ibox
            idverCompareModel.append({"moduleName":"Bluetooth", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleBluetooth),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleBluetooth),"result":SystemInfo.GetCompareResult(EngineerData.ModuleBluetooth),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleBluetooth),
                                     "moduleName2": "", "releaseVersion2":"",
                                     "readVersion2": "",
                                     "result2": "", "resultColor2" : ""});
        }
        //gps, amp
        idverCompareModel.append({"moduleName":"GPS", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleGPS),
                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleGPS),"result":SystemInfo.GetCompareResult(EngineerData.ModuleGPS),
                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleGPS),
                                 "moduleName2": "AMP", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleAMP),
                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleAMP),
                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleAMP), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleAMP)});

        //Navi(korea, US)
        idverCompareModel.append({"moduleName":"NAVI", "releaseVersion": "",
                                 "readVersion": SystemInfo.GetNaviAssociationNumber() ,"result": "",
                                 "resultColor": "",
                                 "moduleName2": "", "releaseVersion2": "",
                                 "readVersion2": "",
                                 "result2": "", "resultColor2" : ""});


//        //Navi(korea, US)
//        idverCompareModel.append({"moduleName":"NAVI(Korea)", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIKo),
//                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIKo),"result":SystemInfo.GetCompareResult(EngineerData.ModuleNAVIKo),
//                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleNAVIKo),
//                                 "moduleName2": "NAVI(US)", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIUs),
//                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIUs),
//                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleNAVIUs), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleNAVIUs)});

//        //Navi(China, M.E)
//        idverCompareModel.append({"moduleName":"NAVI(China)", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIChn),
//                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIChn),"result":SystemInfo.GetCompareResult(EngineerData.ModuleNAVIChn),
//                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleNAVIChn),
//                                 "moduleName2": "NAVI(MES)", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIMes),
//                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIMes),
//                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleNAVIMes), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleNAVIMes)});

//        //Navi(Europe, Canada)
//        idverCompareModel.append({"moduleName":"NAVI(Europe)", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIEU),
//                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIEU),"result":SystemInfo.GetCompareResult(EngineerData.ModuleNAVIEU),
//                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleNAVIEU),
//                                 "moduleName2": "NAVI(Canada)", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVICanada),
//                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVICanada),
//                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleNAVICanada), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleNAVICanada)});

//        //navi(Russia, Australia)
//        idverCompareModel.append({"moduleName":"NAVI(Russia)", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIRu),
//                                 "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIRu),"result":SystemInfo.GetCompareResult(EngineerData.ModuleNAVIRu),
//                                 "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleNAVIRu),
//                                 "moduleName2": "NAVI(Australia)", "releaseVersion2":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleNAVIAUS),
//                                 "readVersion2": SystemInfo.GetReadModuleVersion(EngineerData.ModuleNAVIAUS),
//                                 "result2": SystemInfo.GetCompareResult(EngineerData.ModuleNAVIAUS), "resultColor2" : SystemInfo.GetFontColor(EngineerData.ModuleNAVIAUS)});

        if(countryInfo == 5 || countryInfo == 7){
            idverCompareModel.append({"moduleName":"DAB", "releaseVersion":SystemInfo.GetReleaseModuleVersion(EngineerData.ModuleDAB),
                                     "readVersion":SystemInfo.GetReadModuleVersion(EngineerData.ModuleDAB),"result":SystemInfo.GetCompareResult(EngineerData.ModuleDAB),
                                     "resultColor": SystemInfo.GetFontColor(EngineerData.ModuleDAB),
                                     "moduleName2": "", "releaseVersion2":"",
                                     "readVersion2": "",
                                     "result2": "", "resultColor2" : ""});
        }
    }

    ListView{
        id: idVersionCompareList
        y: 150
        opacity:  1
        clip:  true
        anchors.fill: parent;
        model: idverCompareModel
        delegate: Engineer_VersionCompareDelegate{}
        focus: true
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
    }
    ListModel
    {
        id: idverCompareModel
    }

    /*********************Vertical scrollbar***********************/
    MComp.MScroll {
        x: 1240/*1185*/; y: 5; z:1
        scrollArea: idVersionCompareList;
        height: idVersionCompareList.height; width: 13
        visible: idverCompareModel.count > 13 ? true:false

    } // End MOptionScroll

}

