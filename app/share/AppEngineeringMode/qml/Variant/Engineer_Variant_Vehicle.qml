import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0

MComp.MComponent{
    id:idVehicleLoader
    x:0
    y:0
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea

    property int stateProjectCode: UIListener.LoadSystemConfig(EngineerData.DB_PROJECT_CODE);
    property int currentProjectCode: ( variant.project_data == 4 ) ? 3 : variant.project_data;
    Component.onCompleted:{
        vehicleRegionCode.forceActiveFocus()
        UIListener.autoTest_athenaSendObject();
        if(stateProjectCode > 5 || variant.project_data > 5){
            stateProjectCode = 0;
            variant.project_data = 0;
            currentProjectCode = 0;
        }

    }

    Text{
        width: 200
        height: 60
        x:0
        y:20
        text: "Project Code"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.Spinner{
        x:200; y:20
        id:vehicleRegionCode
        focus: true
        aSpinControlTextModel: vehicleRegionCode_textModel
        currentIndexVal: currentProjectCode

        KeyNavigation.up:{

                backFocus.forceActiveFocus()
                variantBand

        }
        onSpinControlValueChanged: {
            //set DH
            if(curVal   == 0){
                    UIListener.SaveSystemConfig(0 ,EngineerData.DB_PROJECT_CODE)
                    VariantSetting.SaveVariant_Data( 0 , EngineerData.DB_VEHICLE)
            }// set KH
            else if(curVal ==1){
                 UIListener.SaveSystemConfig(1 ,EngineerData.DB_PROJECT_CODE)
                 VariantSetting.SaveVariant_Data( 1 , EngineerData.DB_VEHICLE)
            }// set VI
            else if(curVal ==2){
                 UIListener.SaveSystemConfig(2 ,EngineerData.DB_PROJECT_CODE)
                 VariantSetting.SaveVariant_Data( 2 , EngineerData.DB_VEHICLE)
            }
            else if(curVal == 3){
                UIListener.SaveSystemConfig(4 ,EngineerData.DB_PROJECT_CODE)
                VariantSetting.SaveVariant_Data( 4 , EngineerData.DB_VEHICLE)
            }

        }

    }
    ListModel{
        id:vehicleRegionCode_textModel
        property int count: 4
        ListElement{name:"DH";}
        ListElement{ name: "KH"; }
        ListElement{ name: "VI"; }
        ListElement{ name: "DH PE"; }
        //ListElement{ name: "HI"; }

    }

    Image{
        x:20
        y:100
        source: imgFolderGeneral+"line_menu_list.png"
    }
}

