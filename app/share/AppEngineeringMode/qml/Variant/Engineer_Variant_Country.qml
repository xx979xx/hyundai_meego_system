import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0

MComp.MComponent{
    id:idCountryLoader
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
    Component.onCompleted:{
        countryRegionCode.forceActiveFocus()
        UIListener.autoTest_athenaSendObject();

    }
    //added for AUS Variant 05/12
    //modify for DH AUS variant set Booting Issue 07/30
    /*
    function currentVariant()
    {

        if(VariantSetting.variantInfo == 0xA0)
        {
            return 8;
        }
        else
        {
            return VariantSetting.variantInfo;
        }   

    }
    */


    Text{
        width: 200
        height: 60
        x:0
        y:20
        text: "Country Code"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.Spinner{
        x:200; y:20
        id:countryRegionCode
        focus: true
        aSpinControlTextModel: countryRegionCode_textModel
        currentIndexVal:VariantSetting.variantInfo//currentVariant()//modify for DH AUS variant set Booting Issue 07/30
        KeyNavigation.up:{

                backFocus.forceActiveFocus()
                variantBand

        }


        onSpinControlValueChanged: {
            //modify for DH AUS variant set Booting Issue 07/30
            if(curVal   == 0){
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_COUNTRY );
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_KOREAN);
            }
            else if(curVal == 1){
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_COUNTRY );
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_US)
            }
            else if(curVal == 2){
                VariantSetting.SaveVariant_Data( 2, EngineerData.DB_COUNTRY );
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_CHINA);
            }
            else if(curVal == 3){
                VariantSetting.SaveVariant_Data( 3, EngineerData.DB_COUNTRY );
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_GENERAL);
            }
            else if(curVal == 4){
                VariantSetting.SaveVariant_Data( 4, EngineerData.DB_COUNTRY );
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_ME);
            }
            else if(curVal == 5){
                VariantSetting.SaveVariant_Data(5, EngineerData.DB_COUNTRY);
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_EUROPE);
            }
            else if(curVal == 6){
                VariantSetting.SaveVariant_Data(6, EngineerData.DB_COUNTRY);
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_CANADA);
            }
            else if(curVal == 7){
                VariantSetting.SaveVariant_Data(7, EngineerData.DB_COUNTRY);
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_RUSSIA);
            }
            //modify for DH AUS variant set Booting Issue 07/30
            /*
            //added for AUS Variant 05/12
            else if(curVal == 8){
                VariantSetting.SaveVariant_Data(0xA0, EngineerData.DB_COUNTRY);
                VariantSetting.setDefaultValue(EngineerData.DB_COUNTRY_AUS);
            }
            */
        }

    }
    ListModel{
        id:countryRegionCode_textModel
        property int count: 8 //modify for DH AUS variant set Booting Issue 07/30
        ListElement{name:"00 Korea";}
        ListElement{name:"01 U.S";}
        ListElement{name:"02 China";}
        ListElement{name:"03 General";}
        ListElement{name:"04 M.E";}
        ListElement{name:"05 Europe";}
        ListElement{name:"06 Canada";}
        ListElement{name:"07 Russia"; }
        //ListElement{name:"08 AUS"; }

    }

    Image{
        x:20
        y:100
        source: imgFolderGeneral+"line_menu_list.png"
    }
}




