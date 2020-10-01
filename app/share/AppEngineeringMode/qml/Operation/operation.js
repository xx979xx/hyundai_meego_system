
function setMainScreen(screenName, save){
        UIListener.printLogMessage("setMainScreen - screenName: " + screenName)
        UIListener.printLogMessage("setMainScreen - save: " + save)
        UIListener.printLogMessage("setMainScreen - idAppMain.state: " + idAppMain.state)
        UIListener.printLogMessage("setMainScreen - mainViewState: " + mainViewState)
        if(screenName==idAppMain.state){
            console.log("[QML] Operation : screenName == idAppMain.state ");
            //return;
        }
        else{
            switch(save){
                case true:
                {
                   // idMenu.source=""

                    switch(idAppMain.state)
                    {

                        case "Software":{
                            console.log("Enter Main Screen idAppMain.state : Software === CASE: TRUE");
                            idSoftwareMain.visible = false;
                            break;
                        }
                        case "FullSoftware":{
                            console.log("Enter Main Screen idAppMain.state : FullSoftware === CASE: TRUE");
                            idFullSoftwareMain.visible = false;
                            break;
                        }
                        case "Hardware":{
                            console.log("Enter Main Screen idAppMain.state : Hardware === CASE: TRUE");
                            idHardwareMain.visible = false;
                            break;
                        }
                        case "Update":{
                            idUpdateMain.visible = false;
                            break;
                        }
                        case "FullMain":{
                            idFullENGMain.visible = false;
                            break;
                        }
                        case "Variant":{
                            idVariantMain.visible = false;
                            break;
                        }
                        case "Diagnosis":{
                            console.log("Enter Main Screen idAppMain.state : Diagnosis === CASE: TRUE");
                            idDiagnosisMain.visible = false;
                            break;
                        }
                        case "Password":{
                            UIListener.printLogMessage("setMainScreen - visible:false " )
                            idPassWordMain.visible = false;
                            break;
                        }
                        case "DTCList":{
                            console.log("Enter Main Screen idAppMain.state : DTCList === CASE: TRUE");
                            idDTCListMain.visible = false;
                            break;
                        }
                        case"MostRBD":{
                            idMostRBDMain.visible = false;
                            break;
                        }
                         case "SystemConfig" : {
                             idSystemConfigMain.visible = false;
                             break;
                         }
                         case "Dynamics":{
                             idDynamicsMain.visible = false;
                             break;
                         }
                         case"DynamicKo":{
                             idDynamicsMain.visible = false;
                             break;
                         }
                         case"DynamicUS": {
                             idDynamicsMain.visible = false;
                             break;
                         }
                         case"DynamicEU": {
                             idDynamicsMain.visible = false;
                             break;
                         }
                         case"DynamicCA": {
                             idDynamicsMain.visible = false;
                             break;
                         }
                        case"DynamicGE": {
                            idDynamicsMain.visible = false;
                            break;
                        }
                        case"DynamicRUS": {
                            idDynamicsMain.visible = false;
                            break;
                        }
                        //added for Australia variant
                        case"DynamicAUS": {
                            idDynamicsMain.visible = false;
                            break;
                        }
                        case "DynamicSound": {
                            idDynamicsSoundMain.visible =false;
                            break;
                        }
                         case "AutoTest":{
                             idAutoTestMain.visible = false;
                             break;
                         }
                         case "AutoTestPage2":{
                             idAutoTestPage2Main.visible = false;
                             break;
                         }
                         case"IpConfig":{
                             idIpConfigMain.visible = false;
                             break;
                         }
                         case "VerCompare":{
                            idVerCompareMain.visible = false;
                            break;
                         }
                         case "LogSetting":{
                             idLogSettingMain.visible = false;
                             break;
                         }
                         case "RandomKeyTest":{
                             idRandomKeyTestMain.visible = false;
                             break;
                         }
                         case "TouchTest":{
                             idTouchTestMain.visible = false;
                             break;
                         }
                         //added for BGFG structure
                          case "MapCareMainEx":{
                              idMapCareMain.visible = false;
                              break;
                          }
                          case "MapCareMain":{
                              idMapCareMain.visible = false;
                              break;
                          }
                         //added for BGFG structure

                        default: {
                            console.log("[QML] Operation Error ------------");
                            break;
                        }

                    }
                    idMainView.forceActiveFocus()
                    break;
                }

                case false:
                {
                    //idMenu.source=""
                    switch(idAppMain.state){
                        case"Software":{
                            idSoftwareMain.source=' ' ;
                            break;
                        }
                        case"FullSoftware":{
                            idFullSoftwareMain.source = ' ';
                            break;
                        }
                        case "Hardware":{
                            idHardwareMain.source=' ';
                            break;
                        }
                        case "Update":{
                            idUpdateMain.source = ' ';
                            break;
                        }
                        case "FullMain":{
                            idFullENGMain.source = ' ';
                            break;
                        }
                        case "Variant":{
                            idVariantMain.source    =' ';
                            break;
                        }
                        case "Diagnosis":{
                            console.log("Enter Main Screen idAppMain.state : Diagnosis === CASE: FALSE");
                           // idDiagnosisMain.source = ' ';
                            break;
                        }
                        case "Password": {
                            UIListener.printLogMessage("setMainScreen - source:empty " )
                            idPassWordMain.source = ' ';
                            break;
                        }
                        case "Dynamics":{
                            idDynamicsMain.source = ' ';
                            break;
                        }
                        case "DynamicKo":{
                            idDynamicsMain.source = ' ';
                            break;
                        }
                        case "DynamicUS": {
                            idDynamicsMain.source = ' ';
                            break;
                        }
                        case "DynamicCA": {
                            idDynamicsMain.source = ' ';
                            break;
                        }
                        case "DynamicEU":{
                            idDynamicsMain.source = ' ';
                            break;
                        }
                        case "DynamicGE":{
                            idDynamicsMain.source = ' ';
                            break;
                        }
                        case"DynamicRUS": {
                            idDynamicsMain.source = ' ';
                            break;
                        }

                        //added for Australia variant
                        case "DynamicAUS":{
                            idDynamicsMain.source = ' ';
                            break;
                        }
                        case "DynamicSound":{
                            idDynamicsSoundMain.source = ' ';
                            break;
                        }
                        case "SystemConfig" :{
                            idSystemConfigMain.source = ' ';
                            break;
                        }
                        case "AutoTest":{
                            idAutoTestMain.source = ' ';
                            break;
                        }
                        case "AutoTestPage2":{
                            idAutoTestPage2Main.source = ' ';
                            break;
                        }
                        case"TouchTest":{
                            idTouchTestMain.source = ' ';
                            break;
                        }
                        //added for BGFG structure
                        case"MapCareMainEx":{
                            idMapCareMain.source = ' ';
                            break;
                        }
                        case"MapCareMain":{
                            idMapCareMain.source = ' ';
                            break;
                        }
                        //added for BGFG structure
                        default:{
                            break;
                        }
                        idMainView.forceActiveFocus()
                    }
                }
            }
        }
        switch(screenName){
                case "Software":{
                    idSoftwareMain.visible = true
                    idSoftwareMain.forceActiveFocus();
                    if(idSoftwareMain.status == Loader.Null)
                       // idSoftwareMain.source = "/app/share/AppEngineeringMode/qml/Software/Engineer_SoftMain.qml"
                        idSoftwareMain.source = "./Software/Engineer_SoftMain.qml"
                    break;
                }
                case "FullSoftware":{
                    idFullSoftwareMain.visible = true
                    idFullSoftwareMain.forceActiveFocus();
                    if(idFullSoftwareMain.status == Loader.Null)
                       // idSoftwareMain.source = "/app/share/AppEngineeringMode/qml/Software/Engineer_SoftMain.qml"
                        idFullSoftwareMain.source = "./Software/Engineer_SoftMain.qml"
                    break;
                }
                case "Hardware":{
                    idHardwareMain.visible = true
                    idHardwareMain.forceActiveFocus();
                    if(idHardwareMain.status == Loader.Null)
                        idHardwareMain.source =  "./Hardware/Engineer_HardMain.qml"
                    break;
                }
                case "Update":{
                    idUpdateMain.visible = true
                    idUpdateMain.forceActiveFocus();
                    if(idUpdateMain.status == Loader.Null)
                        idUpdateMain.source = "./Update/Engineer_UpdateMain.qml"
                    break;
                }
                case "FullMain":{
                    flagState = 9
                    idFullENGMain.visible = true
                    idFullENGMain.forceActiveFocus();
                    if(idFullENGMain.status == Loader.Null)
                        idFullENGMain.source = "AppEngineer_FullMain.qml"
                    break;
                }
                case "Variant":{
                    idVariantMain.visible = true
                    idVariantMain.forceActiveFocus();
                    if(idVariantMain.status == Loader.Null)
                        idVariantMain.source = "./Variant/Engineer_VariantMain.qml"
                    break;
                }
                case "Diagnosis":{
                    console.log("Enter Main Screen NAME: Diagnosis === ");
                    idDiagnosisMain.visible = true
                    idDiagnosisMain.forceActiveFocus();
                    if(idDiagnosisMain.status == Loader.Null){
                        console.log("Enter Main Screen Loader NULL: Diagnosis === ");
                        idDiagnosisMain.source = "./Diagnosis/Engineer_DiagnosisMain.qml"
                    }
                    break;
                }
                case "Password":{
                    idPassWordMain.visible = true
                    idPassWordMain.forceActiveFocus();
                    if(idPassWordMain.status == Loader.Null){
                        UIListener.printLogMessage("setMainScreen - idPassWordMain.status == Loader.Null " )
                        idPassWordMain.source = "./Password/AppEngineer_PinCodeChange.qml"

                    }
                    else{
                        UIListener.printLogMessage("setMainScreen - idPassWordMain.status != Loader.Null " )
                    }

                    break;
                }
                case "DynamicKo":{
                    idDynamicsMain.visible = true
                    idDynamicsMain.forceActiveFocus()
                    if(idDynamicsMain.status == Loader.Null)
                        idDynamicsMain.source = "./Dynamic/Engineer_DynamicMainKo.qml"
                    break;
                }
                case "DynamicUS":{
                    idDynamicsMain.visible = true
                    idDynamicsMain.forceActiveFocus()
                    if(idDynamicsMain.status == Loader.Null)
                        idDynamicsMain.source = "./Dynamic/Engineer_DynamicMainUS.qml"
                    break;
                }
                case "DynamicEU":{
                    idDynamicsMain.visible = true
                    idDynamicsMain.forceActiveFocus()
                    if(idDynamicsMain.status == Loader.Null)
                        idDynamicsMain.source = "./Dynamic/Engineer_DynamicMainEU.qml"
                    break;
                }
                case "DynamicCA":{
                    idDynamicsMain.visible = true
                    idDynamicsMain.forceActiveFocus()
                    if(idDynamicsMain.status == Loader.Null)
                        idDynamicsMain.source = "./Dynamic/Engineer_DynamicMainCA.qml"
                    break;
                }
                case "DynamicGE":{
                    idDynamicsMain.visible = true
                    idDynamicsMain.forceActiveFocus()
                    if(idDynamicsMain.status == Loader.Null)
                        idDynamicsMain.source = "./Dynamic/Engineer_DynamicMainGE.qml"
                    break;
                }
                case "DynamicRUS":{
                    idDynamicsMain.visible = true
                    idDynamicsMain.forceActiveFocus()
                    if(idDynamicsMain.status == Loader.Null)
                        idDynamicsMain.source = "./Dynamic/Engineer_DynamicMainRUS.qml"
                    break;
                }

                //added for Australia variant
                case "DynamicAUS":{
                    idDynamicsMain.visible = true
                    idDynamicsMain.forceActiveFocus()
                    if(idDynamicsMain.status == Loader.Null)
                        idDynamicsMain.source = "./Dynamic/Engineer_DynamicMainAUS.qml"
                    break;
                }
                case "DynamicSound":{
                    idDynamicsSoundMain.visible = true
                    idDynamicsSoundMain.forceActiveFocus()
                    if(idDynamicsSoundMain.status == Loader.Null)
                        idDynamicsSoundMain.source = "./Dynamic/Engineer_Dynamic_Sound.qml"
                    break;
                }
                case "DTCList":{
                     console.log("Enter Main Screen NAME: DTCList === ");

                    idDTCListMain.visible = true
                    idDTCListMain.forceActiveFocus();
                    if(idDTCListMain.status == Loader.Null){
                        console.log("Enter Main Screen Loader NULL: DTCList === ");
                        idDTCListMain.source = "./Diagnosis/Engineer_Diagnosis_DTCListMain.qml"
                    }
                    break;
                }
                case "MostRBD":{
                    idMostRBDMain.visible = true
                    idMostRBDMain.forceActiveFocus();
                    if(idMostRBDMain.status == Loader.Null){
                        idMostRBDMain.source = "./Diagnosis/Engineer_Diagnosis_MostRBD.qml"
                    }
                    break;
                }
                case "IpConfig":{
                    idIpConfigMain.visible = true
                    idIpConfigMain.forceActiveFocus()
                    if(idIpConfigMain.status == Loader.Null){
                        idIpConfigMain.source = "./IpConfig/Engineer_IpConfigMain.qml"
                    }
                    break;
                }
                case "VerCompare":{
                    idVerCompareMain.visible = true
                    idVerCompareMain.forceActiveFocus()
                    if(idVerCompareMain.status == Loader.Null){
                        idVerCompareMain.source = "./AutoTest/Engineer_VersionCompare.qml"
                    }
                    break;
                }
                case "RandomKeyTest":{
                    idRandomKeyTestMain.visible = true
                    idRandomKeyTestMain.forceActiveFocus()
                    if(idRandomKeyTestMain.status == Loader.Null){
                        idRandomKeyTestMain.source = "./AutoTest/Engineer_RandomKeyTest.qml"
                    }
                    break;
                }
                case "TouchTest":{
                    idTouchTestMain.visible = true
                    idTouchTestMain.forceActiveFocus()
                    if(idTouchTestMain.status == Loader.Null){
                        idTouchTestMain.source = "./AutoTest/Engineer_TouchTest.qml"
                    }
                    break;
                }
                case "LogSetting":{
                    idLogSettingMain.visible = true
                    idLogSettingMain.forceActiveFocus()
                    if(idLogSettingMain.status == Loader.Null){
                        idLogSettingMain.source = "./LogSetting/Engineer_LogMain.qml"
                    }
                    break;
                }
                case "SystemConfig" :{
                idSystemConfigMain.visible =true
                idSystemConfigMain.forceActiveFocus();
                    if(idSystemConfigMain.status == Loader.Null)
                        idSystemConfigMain.source = "./SystemConfig/Engineer_SystemMain.qml"
                    break;
                }
                case "AutoTest":{
                    idAutoTestMain.visible = true
                    idAutoTestMain.forceActiveFocus();
                    if(idAutoTestMain.status == Loader.Null)
                        idAutoTestMain.source = "./AutoTest/Engineer_AutoTest.qml"
                    break;
                }
                case "AutoTestPage2":{
                    idAutoTestPage2Main.visible = true
                    idAutoTestPage2Main.forceActiveFocus();
                    if(idAutoTestPage2Main.status == Loader.Null)
                        idAutoTestPage2Main.source = "./AutoTest/Engineer_AutoTest_page2.qml"
                    break;
                }
                //added for BGFG structure
                case "MapCareMainEx":{
                    idMapCareMain.visible = true
                    idMapCareMain.forceActiveFocus();
                    if(idMapCareMain.status == Loader.Null)
                        idMapCareMain.source = "MapCare_MainEx.qml"
                    break;
                }
                case "MapCareMain":{
                    idMapCareMain.visible = true
                    idMapCareMain.forceActiveFocus();
                    if(idMapCareMain.status == Loader.Null)
                        idMapCareMain.source = "MapCare_Main.qml"
                    break;
                }
                //added for BGFG structure

                case "":{
                    if(flagState == 9){

                       // idFullMainView.visible = true
                        idFullMainView.forceActiveFocus()
                    }else{
                        // idMainView.visible = true

                        idMainView.forceActiveFocus()
                    }
                    break;
                }
        }
        idAppMain.state = screenName
}

//for MapCare UI Only EU Variant
function setMapCareScreen(screenName, save){
    UIListener.printLogMessage("setMapCareScreen - screenName: " + screenName)
    UIListener.printLogMessage("setMapCareScreen - save: " + save)
    UIListener.printLogMessage("setMapCareScreen - idAppMain.state: " + idAppMain.state)
    UIListener.printLogMessage("setMapCareScreen - mainViewState: " + mainViewState)
    if(screenName==idAppMain.state){
        console.log("[QML] Operation : screenName == idAppMain.state ");
        //return;
    }
    else{
        switch(save){
            case true:
            {
               // idMenu.source=""
                switch(idAppMain.state)
                {
                     case "Dynamics":{
                         idDynamicsMainMapCare.visible = false;
                         break;
                     }

                    case "MapCareDynamicSound": {
                        idDynamicsSoundMainMapCare.visible =false;
                        break;
                    }
                    case "Software": {
                        idSoftwareMainMapCare.visible =false;
                        break;
                    }
                    case "Hardware": {
                        idHardwareMainMapCare.visible =false;
                        break;
                    }
                    case "LogSetting": {
                        idLogSettingMainMapCare.visible =false;
                        break;
                    }
                    case "Diagnosis": {
                        idDiagnosisMainMapCare.visible =false;
                        break;
                    }
                    case "Variant": {
                        idVariantMainMapCare.visible =false;
                        break;
                    }
                    case "Password":{
                        UIListener.printLogMessage("setMapCareScreen - Password visible:false")
                        idPassWordMainMapCare.visible = false;
                        break;
                    }
                    case"MostRBD":{
                        idMostRBDMainMapCare.visible = false;
                        break;
                    }
                    case "DTCList":{
                        console.log("Enter Main Screen idAppMain.state : DTCList === CASE: TRUE");
                        idDTCListMainMapCare.visible = false;
                        break;
                    }
                    default: {
                        console.log("[QML] Operation Error ------------");
                        break;
                    }
                }
                idMapCareMainView.forceActiveFocus()
                break;
            }
            case false:
            {
                //idMenu.source=""
                switch(idAppMain.state){

                    case "Dynamics":{
                        idDynamicsMainMapCare.source = ' ';
                        break;
                    }
                    case "MapCareDynamicSound":{
                        idDynamicsSoundMainMapCare.source = ' ';
                        break;
                    }

                    case "Software": {
                        idSoftwareMainMapCare.source = ' ';
                        break;
                    }
                    case "Hardware": {
                        idHardwareMainMapCare.source = ' ';
                        break;
                    }
                    case "LogSetting": {
                        idLogSettingMainMapCare.source = ' ';
                        break;
                    }
                    case "Diagnosis": {
                        idDiagnosisMainMapCare.source = ' ';
                        break;
                    }
                    case "Variant": {
                        idVariantMainMapCare.source = ' ';
                        break;
                    }
                    case "Password": {
                        UIListener.printLogMessage("setMapCareScreen - Password source: empty")
                        idPassWordMainMapCare.source = ' ';
                        break;
                    }
                    case"MostRBD":{
                        idMostRBDMainMapCare.source = ' ';
                        break;
                    }

                    default:{
                        break;
                    }
                    idMapCareMainView.forceActiveFocus()
                }
            }
        }
    }
    switch(screenName){

            case "Dynamics":{
                idDynamicsMainMapCare.visible = true
                idDynamicsMainMapCare.forceActiveFocus()
                if(variantValue == 0)
                {
                    if(idDynamicsMainMapCare.status == Loader.Null)
                        idDynamicsMainMapCare.source = "./Dynamic/Engineer_DynamicMapCareKo.qml"
                }
                else if(variantValue == 1)
                {
                    if(idDynamicsMainMapCare.status == Loader.Null)
                        idDynamicsMainMapCare.source = "./Dynamic/Engineer_DynamicMapCareUS.qml"
                }
                else if(variantValue == 5 || variantValue == 7)
                {

                    if(idDynamicsMainMapCare.status == Loader.Null)
                        idDynamicsMainMapCare.source = "./Dynamic/Engineer_DynamicMapCare.qml"
                }
                else
                {
                    if(idDynamicsMainMapCare.status == Loader.Null)
                        idDynamicsMainMapCare.source = "./Dynamic/Engineer_DynamicMapCareGE.qml"
                }

                break;
            }
            case "MapCareDynamicSound":{
                idDynamicsSoundMainMapCare.visible = true
                idDynamicsSoundMainMapCare.forceActiveFocus()
                if(idDynamicsSoundMainMapCare.status == Loader.Null)
                    idDynamicsSoundMainMapCare.source = "./Dynamic/Engineer_Dynamic_MapCareSound.qml"
                break;
            }

            case "Software":{
                idSoftwareMainMapCare.visible = true
                idSoftwareMainMapCare.forceActiveFocus();
                if(idSoftwareMainMapCare.status == Loader.Null)
                   // idSoftwareMain.source = "/app/share/AppEngineeringMode/qml/Software/Engineer_SoftMain.qml"
                    idSoftwareMainMapCare.source = "./Software/Engineer_SoftMain.qml"
                break;
            }

            case "Hardware":{
                idHardwareMainMapCare.visible = true
                idHardwareMainMapCare.forceActiveFocus();
                if(idHardwareMainMapCare.status == Loader.Null)
                    idHardwareMainMapCare.source =  "./Hardware/Engineer_HardMain.qml"
                break;
            }

            case "LogSetting":{
                idLogSettingMainMapCare.visible = true
                idLogSettingMainMapCare.forceActiveFocus()
                if(idLogSettingMainMapCare.status == Loader.Null){
                    idLogSettingMainMapCare.source = "./LogSetting/Engineer_LogMainMapCare.qml"
                }
                break;
            }

            case "Variant":{
                idVariantMainMapCare.visible = true
                idVariantMainMapCare.forceActiveFocus();
                if(idVariantMainMapCare.status == Loader.Null)
                    idVariantMainMapCare.source = "./Variant/Engineer_VariantMain.qml"
                break;
            }
            case "Diagnosis":{
                console.log("Enter Main Screen NAME: Diagnosis === ");
                idDiagnosisMainMapCare.visible = true
                idDiagnosisMainMapCare.forceActiveFocus();
                if(idDiagnosisMainMapCare.status == Loader.Null){
                    console.log("Enter Main Screen Loader NULL: Diagnosis === ");
                    idDiagnosisMainMapCare.source = "./Diagnosis/Engineer_DiagnosisMapCareMain.qml"
                }
                break;
            }
            case "Password":{
                idPassWordMainMapCare.visible = true
                idPassWordMainMapCare.forceActiveFocus();
                if(idPassWordMainMapCare.status == Loader.Null){
                    UIListener.printLogMessage("setMapCareScreen - idPassWordMainMapCare.status == Loader.Null")
                    idPassWordMainMapCare.source = "./Password/AppEngineer_PinCodeChange.qml"
                }
                else{
                    UIListener.printLogMessage("setMapCareScreen - idPassWordMainMapCare.status != Loader.Null")
                }

                break;
            }
            case "MostRBD":{
                idMostRBDMainMapCare.visible = true
                idMostRBDMainMapCare.forceActiveFocus();
                if(idMostRBDMainMapCare.status == Loader.Null){
                    idMostRBDMainMapCare.source = "./Diagnosis/Engineer_Diagnosis_MostRBD.qml"
                }
                break;
            }

            case "DTCList":{
                 console.log("Enter Main Screen NAME: DTCList === ");

                idDTCListMainMapCare.visible = true
                idDTCListMainMapCare.forceActiveFocus();
                if(idDTCListMainMapCare.status == Loader.Null){
                    console.log("Enter Main Screen Loader NULL: DTCList === ");
                    idDTCListMainMapCare.source = "./Diagnosis/Engineer_Diagnosis_DTCListMain.qml"
                }
                break;
            }

            case "":{
                    idMapCareMainView.forceActiveFocus()
                break;
            }
    }
    idAppMain.state = screenName
}

//Full ENG Main Screen Operation
function setFullMainScreen(screenName, save){

}
//Menu Screen Operation
function setRightMain(index, save)
{
    switch(save)
    {
        case true:
            idHeadUnitLoader.visible = false;
            idPeripheralsLoader.visible=false;
            idBluetoothLoader.visible = false;
            idCANDBLoader.visible = false;
            idPhoneBookPatternLoader.visible = false; //added for PhoneBook Pattern Setting
            idASDLoader.visible = false;

            break;
        case false:
            idHeadUnitLoader.source = ' ';
            idPeripheralsLoader.source=' ';
            idBluetoothLoader.source = ' ';
            idCANDBLoader.source = ' ';
            idPhoneBookPatternLoader.source = ' '; //added for PhoneBook Pattern Setting
            idASDLoader.source = '';
            break;

    }
    switch(index)
    {
        //Case Software Index
        //Case head Unit
        case 0:
            if(idHeadUnitLoader.status == Loader.Null){
                idHeadUnitLoader.source = "Engineer_Soft_HeadUnit.qml"
            }
                idHeadUnitLoader.visible = true
                idHeadUnitLoader.focus = true
                 idHeadUnitLoader.forceActiveFocus()
            break;
         //Case Peripherals
        case 1:
            if(idPeripheralsLoader.status == Loader.Null){
                idPeripheralsLoader.source = "Engineer_Soft_Peripherals.qml"
            }
                idPeripheralsLoader.visible = true
                idPeripheralsLoader.focus = true
            break;
        //Case Bluetooth
        case 2:
            if(idBluetoothLoader.status == Loader.Null){
                idBluetoothLoader.source = "Engineer_Soft_Bluetooth.qml"
            }
                idBluetoothLoader.visible = true
                idBluetoothLoader.focus = true
            break;
        //Case CANDB
        case 3:
            if(idCANDBLoader.status == Loader.Null){
                idCANDBLoader.source = "Engineer_Soft_CANDB.qml"
            }
                idCANDBLoader.visible = true
                idCANDBLoader.focus = true
            break;
        //added for PhoneBook Pattern Setting
        //Case PhoneBook
        case 4:
            if(idPhoneBookPatternLoader.status == Loader.Null){
                idPhoneBookPatternLoader.source = "Engineer_Soft_PhoneBookPattern.qml"
            }
            idPhoneBookPatternLoader.visible = true
            idPhoneBookPatternLoader.focus = true

            break;

        case 5:
            if(idASDLoader.status == Loader.Null){
                idASDLoader.source = "Engineer_Soft_ASD.qml"
            }
            idASDLoader.visible = true
            idASDLoader.focus = true

            break;

    }
    idSoftwareMain.state = index
}
//Update Right Menu Operation
function setRightUpdateMain(index, save)
{
    switch(save)
    {
        case true:
           idUpdateUSBLoader.visible = false;
           idUpdateiBoxLoader.visible = false
            break;
        case false:
            idUpdateUSBLoader.source = ' ';
            idUpdateiBoxLoader.source = ' ';

            break;

    }
    switch(index)
    {
        //Case Update Index
        //Case Update From USB
        case 0:
            if(idUpdateUSBLoader.status == Loader.Null){
                idUpdateUSBLoader.source = "Engineer_Update_FromUSB.qml"
            }
                idUpdateUSBLoader.visible = true
                idUpdateUSBLoader.focus = true
            break;
         //Case Update From iBox
        case 1:
            if(idUpdateiBoxLoader.status == Loader.Null){
                idUpdateiBoxLoader.source = "Engineer_Update_FromiBox.qml"
            }
                idUpdateiBoxLoader.visible = true
                idUpdateiBoxLoader.focus = true
            break;



    }
   // idSoftwareMain.state = index
}


//function Hardware Right Menu Change
function setHardwareRightMain(index, save)
{
    switch(save)
    {
        case true:

            idVersionLoader.visible = false;
            idConnectivityLoader.visible = false;
            idDeckLoader.visible = false;

            break;
        case false:

            idVersionLoader.source= ' ';
            idConnectivityLoader.source = ' ';
            idDeckLoader.source = ' ';
            break;

    }
    switch(index)
    {
        case 0:
            if(idVersionLoader.status == Loader.Null){
                idVersionLoader.source = "Engineer_Hard_Version.qml"
            }
                idVersionLoader.visible = true
                idVersionLoader.focus = true
            break;
        case 1:
            if(idConnectivityLoader.status == Loader.Null){
                idConnectivityLoader.source = "Engineer_Hard_Connect.qml"
            }
                idConnectivityLoader.visible = true
                idConnectivityLoader.focus = true
            break;
        case 2:
            if(idDeckLoader.status == Loader.Null){
                idDeckLoader.source = "Engineer_Hard_Deck.qml"
            }
                idDeckLoader.visible = true
                idDeckLoader.focus = true
            break;


    }

    idHardwareMain.state = index
}
//function Hardware Right Menu Change
function setVariantRightMain(index, save)
{
    switch(save)
    {
        case true:

            idVehicleLoader.visible = false;
            idCountryLoader.visible = false;
            idVariantSystemLoader.visible = false;
            idDVDRegionLoader.visible = false;

            break;
        case false:

            idVehicleLoader.source = ' ';
            idCountryLoader.source = ' ';
            idVariantSystemLoader.source = ' ';
            idDVDRegionLoader.source = ' ';
            break;

    }
    switch(index)
    {
        case 0:
            if(idVehicleLoader.status == Loader.Null){
                idVehicleLoader.source = "Engineer_Variant_Vehicle.qml"
            }
                idVehicleLoader.visible = true
                idVehicleLoader.focus = true
            break;
        case 1:
            if(idCountryLoader.status == Loader.Null){
                idCountryLoader.source = "Engineer_Variant_Country.qml"
            }
                idCountryLoader.visible = true
                idCountryLoader.focus = true
            break;
        case 2:
            if(idVariantSystemLoader.status == Loader.Null){
                idVariantSystemLoader.source = "Engineer_Variant_System.qml"
            }
                idVariantSystemLoader.visible = true
                idVariantSystemLoader.focus = true
            break;

        case 3:
            if(idDVDRegionLoader.status == Loader.Null){
                idDVDRegionLoader.source = "Engineer_Variant_DVDRegion.qml"
            }
            idDVDRegionLoader.visible = true
            idDVDRegionLoader.focus = true
            break;


    }

    idVariantMain.state = index
}

//function Diagnosis Right Menu Change
function setDiagnosisRightMain(index, save)
{
    switch(save)
    {
        case true:

            idDTCLoader.visible = false;
            idMOSTLoader.visible = false;
            idCommandLoader.visible = false;
            idHULoader.visible = false;
            idModuleResetLoader.visible = false;
//            idDTCResponseLoader.visible = false;

            break;
        case false:

            idDTCLoader.source = ' ';
            idMOSTLoader.source = ' ';
            idCommandLoader.source = ' ';
            idHULoader.source = ' ';
            idModuleResetLoader.source = ' ';
//            idDTCResponseLoader.source = ' ';
            break;

    }
    switch(index)
    {
        case 0:
            if(idDTCLoader.status == Loader.Null){
                idDTCLoader.source = "Engineer_Diagnosis_DTC.qml"
            }
                idDTCLoader.visible = true
                idDTCLoader.focus = true
            break;
        case 1:
            if(idMOSTLoader.status == Loader.Null){
                idMOSTLoader.source = "Engineer_Diagnosis_MOST.qml"
            }
                idMOSTLoader.visible = true
                idMOSTLoader.focus = true
            break;
        case 2:
            if(idCommandLoader.status == Loader.Null){
                idCommandLoader.source = "Engineer_Diagnosis_Command.qml"
            }
                idCommandLoader.visible = true
                idCommandLoader.focus = true
            break;

        case 3:
            if(idHULoader.status == Loader.Null){
                idHULoader.source = "Engineer_Diagnosis_HU.qml"
            }
            idHULoader.visible = true
            idHULoader.focus = true
            break;

        case 4:
            if(idModuleResetLoader.status == Loader.Null){
                idModuleResetLoader.source = "Engineer_Diagnosis_ModuleReset.qml"
            }
            idModuleResetLoader.visible = true
            idModuleResetLoader.focus = true
            break;

            //DTC List View Case
//        case 11:
//            if(idDTCResponseLoader.status == Loader.Null){
//                idDTCResponseLoader.source = "Engineer_Diagnosis_DTCListMain.qml"
//            }
//            idDTCResponseLoader.visible = true
//            idDTCResponseLoader.focus = true
//            break;

    }

    idDiagnosisMainMenu.state = index
}

//function Diagnosis Right Menu Change
function setDiagnosisMapCareRightMain(index, save)
{
    switch(save)
    {
        case true:

            idMOSTMapCareLoader.visible = false;
            idDTCMapCareLoader.visible = false;
            idCommandMapCareLoader.visible = false;
            break;
        case false:

            idMOSTMapCareLoader.source = ' ';
            idDTCMapCareLoader.source = ' ';
            idCommandMapCareLoader.source = ' ';
            break;

    }
    switch(index)
    {

        case 0:
            if(idMOSTMapCareLoader.status == Loader.Null){
                idMOSTMapCareLoader.source = "Engineer_Diagnosis_MOST.qml"
            }
            idMOSTMapCareLoader.visible = true
            idMOSTMapCareLoader.focus = true
            break;
        case 1:
            if(idDTCMapCareLoader.status == Loader.Null){
                idDTCMapCareLoader.source = "Engineer_Diagnosis_DTC.qml"
            }
                idDTCMapCareLoader.visible = true
                idDTCMapCareLoader.focus = true
            break;

        case 2:
            if(idCommandMapCareLoader.status == Loader.Null){
                idCommandMapCareLoader.source = "Engineer_Diagnosis_CommandMapcare.qml"
            }
                idCommandMapCareLoader.visible = true
                idCommandMapCareLoader.focus = true
            break;
    }

    idDiagnosisMainMenu.state = index
}

//function SystemConfig Right Menu Change
function setSystemConfigRightMain(index, save)
{

    switch(save)
    {
        case true:

            idSystemLoader.visible = false;
            idLogDataLoader.visible = false;
            idSoundLoader.visible = false;

            break;
        case false:

            idSystemLoader.source= ' ';
            idLogDataLoader.source = ' ';
            idSoundLoader.source = ' ';
            break;

    }
    switch(index)
    {
        case 0:
            if(idSystemLoader.status == Loader.Null){
                idSystemLoader.source = "Engineer_System_System.qml"
            }
                idSystemLoader.visible = true
                idSystemLoader.focus = true
            break;
        case 1:
            if(idLogDataLoader.status == Loader.Null){
                idLogDataLoader.source = "Engineer_System_Reception.qml"
            }
                idLogDataLoader.visible = true
                idLogDataLoader.focus = true
            break;
        case 2:
            if(idSoundLoader.status == Loader.Null){
                idSoundLoader.source = "Engineer_System_Sound.qml"
            }
                idSoundLoader.visible = true
                idSoundLoader.focus = true
            break;


    }

    idSystemConfigMain.state = index

}
function setDiagnosisPopUp(index, save)
{
    switch(save)
    {
            case true:
                idDeletePopUp.visible = false;
                idMostRBDPopUp.visible = false;
                idDeleteNaviPopUp.visible = false;
                break;

            case false:
                idDeletePopUp.source = ' ';
                idMostRBDPopUp.source = ' ';
                idDeleteNaviPopUp.source = ' ';
                break;

    }
    switch(index)
    {
        case 0:
            if(idDeletePopUp.status == Loader.Null){
                idDeletePopUp.source = "Engineer_DeleteDTC_PopUp.qml"
            }
            idDeletePopUp.visible = true
            idDeletePopUp.focus = true
            break;

        case 1:
            if(idMostRBDPopUp.status == Loader.Null){
                idMostRBDPopUp.source = "Engineer_Diagnosis_MostResetPopUp.qml"
            }
            idMostRBDPopUp.visible = true
            idMostRBDPopUp.focus = true
            break;

        case 2:
            if(idDeleteNaviPopUp.status == Loader.Null){
                idDeleteNaviPopUp.source = "Engineer_Diagnosis_DeleteNaviPopUp.qml"
            }
            idDeleteNaviPopUp.visible = true
            idDeleteNaviPopUp.focus = true
            break;

    }

}

//Menu Screen Operation
function setLogMain(index, save)
{
    switch(save)
    {
        case true:
            idAppList1Loader.visible = false;
            idAppList2Loader.visible=false;
            idAppList3Loader.visible = false;
            idAppList4Loader.visible = false;
            idAppList5Loader.visible = false;
            idAppList6Loader.visible = false;
            idAppList7Loader.visible = false;
            idAppList8Loader.visible = false;
            idAppListStartLoader.visible = false;
            break;
        case false:
            idAppList1Loader.source = ' ';
            idAppList2Loader.source=' ';
            idAppList3Loader.source = ' ';
            idAppList4Loader.source = ' ';
            idAppList5Loader.source = ' ';
            idAppList6Loader.source = ' ';
             idAppList7Loader.source = ' ';
            idAppList8Loader.source = ' ';
            idAppListStartLoader.source = ' ';
            break;

    }
    switch(index)
    {
        //Case Log Page Index
        //Case App List 1
        case 0:
            if(idAppList1Loader.status == Loader.Null){
                idAppList1Loader.source = "Engineer_LogList1.qml"
            }
                idAppList1Loader.visible = true
                idAppList1Loader.focus = true
                 idAppList1Loader.forceActiveFocus()
            break;
         //Case App List 2
        case 1:
            if(idAppList2Loader.status == Loader.Null){
                idAppList2Loader.source = "Engineer_LogList2.qml"
            }
                idAppList2Loader.visible = true
                idAppList2Loader.focus = true
            break;
        //Case App List 3
        case 2:
            if(idAppList3Loader.status == Loader.Null){
                idAppList3Loader.source = "Engineer_LogList3.qml"
            }
                idAppList3Loader.visible = true
                idAppList3Loader.focus = true
            break;
        //Case App List 4
        case 3:
            if(idAppList4Loader.status == Loader.Null){
                idAppList4Loader.source = "Engineer_LogList4.qml"
            }
                idAppList4Loader.visible = true
                idAppList4Loader.focus = true
            break;
        //Case App List 5
        case 4:
            if(idAppList5Loader.status == Loader.Null){
                idAppList5Loader.source = "Engineer_LogList5.qml"
            }
                idAppList5Loader.visible = true
                idAppList5Loader.focus = true
            break;
        //Case App List 6
        case 5:
            if(idAppList6Loader.status == Loader.Null){
                idAppList6Loader.source = "Engineer_LogList6.qml"
            }
                idAppList6Loader.visible = true
                idAppList6Loader.focus = true
            break;

        case 6:
        {
            if(idAppList7Loader.status == Loader.Null){
                idAppList7Loader.source = "Engineer_LogList7.qml"
            }
                idAppList7Loader.visible = true
                idAppList7Loader.focus = true
            break;
        }

        case 7:
        {
            if(idAppList8Loader.status == Loader.Null){
                idAppList8Loader.source = "Engineer_LogList8.qml"
            }
                idAppList8Loader.visible = true
                idAppList8Loader.focus = true
            break;
        }

        case 8:
        {
            if(idAppListStartLoader.status == Loader.Null){
                idAppListStartLoader.source = "Engineer_LogListStart.qml"
            }
                idAppListStartLoader.visible = true
                idAppListStartLoader.focus = true
            break;
        }

    }
    idLogmain.state = index
}
function getVerticalAlignment(textVAlignment)
{
    switch(textVAlignment)
    {
        case "Top" : { return Text.AlignTop; break; }
        case "Bottom" : { return Text.AlignBottom; break; }
        case "Center" : { return Text.AlignVCenter; break; }
        default:
        {
            console.log(" MButton_funtion getVerticalAlignment()::textVAlignment Error ========================>> ")
            break;
        }
    }
}

function getHorizontalAlignment(textHAlignment)
{
    switch(textHAlignment)
    {
        case "Right" : { return Text.AlignRight; break; }
        case "Left" : { return Text.AlignLeft; break; }
        case "Center" : { return Text.AlignHCenter; break; }
        default:
        {
            console.log(" MButton_funtion getHorizontalAlignment()::textHAlignment Error ========================>> ")
            return Text.AlignHCenter;
            break;
        }
    }
}
