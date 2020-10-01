import QtQuick 1.0
import QmlSimpleItems 1.0
import com.engineer.data 1.0


import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
Item
{

    id: content_logsystem
    width: 1280
    height: 550
    //x:10
//    y:69
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
    }

    Component
    {
        id:logsystem_list

        Column
        {
            id:logsystemColumn; width:content_logsystem.width;

            Row
            {

                id:moduleName1_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:300

                    Text
                    {
                        id:qcancontroller_text
                        height:50
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("QCANController")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id:engineerMode_text
                        height:50
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Engineer Mode")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id:radio_text
                        height:50
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Radio")
                        verticalAlignment: Text.AlignVCenter

                    }
                }

            }



            Row
            {
                id: logDataRow1; height: 80 - linelist1.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist1.height
                    width:logDataRow1.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: qcancontroller_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



                    }

                    SpinControl
                    {
                        id: qcancontroller_spin
                        aSpinControlTextModel: qcancontroller_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: qcancontroller_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_QCANController)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( qcancontroller_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController )
                            }

                            else if(qcancontroller_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_QCANController )

                            }

                            else if(qcancontroller_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_QCANController )

                            }
                            else if(qcancontroller_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_QCANController )
                            }

                            else if(qcancontroller_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_QCANController )
                            }
                            else if(qcancontroller_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_QCANController )
                            }
                            else if(qcancontroller_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_QCANController )
                            }
                            else if(qcancontroller_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_QCANController )
                            }
                            else if(qcancontroller_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_QCANController )
                            }

                            else if(qcancontroller_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_QCANController )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_QCANController )

                            }

                        }
                    }




                    ListModel
                    {
                        id: engineerMode_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



                    }

                    SpinControl
                    {
                        id: engineerMode_spin
                        aSpinControlTextModel: engineerMode_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: engineerMode_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppEngineering)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( engineerMode_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppEngineering )
                            }

                            else if(engineerMode_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppEngineering )

                            }

                            else if(engineerMode_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppEngineering )

                            }
                            else if(engineerMode_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppEngineering )
                            }

                            else if(engineerMode_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppEngineering )
                            }
                            else if(engineerMode_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppEngineering )
                            }
                            else if(engineerMode_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppEngineering )
                            }
                            else if(engineerMode_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppEngineering )
                            }
                            else if(engineerMode_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppEngineering )
                            }
                            else if(engineerMode_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppEngineering )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppEngineering )
                            }

                        }
                    }

                    ListModel
                    {
                        id: radio_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10}




                    }

                    SpinControl
                    {
                        id: radio_spin
                        aSpinControlTextModel: radio_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: radio_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppRadio)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( radio_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppRadio )
                            }

                            else if(radio_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppRadio )

                            }

                            else if(radio_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppRadio )

                            }
                            else if(radio_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppRadio )
                            }

                            else if(radio_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppRadio )
                            }
                            else if(radio_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppRadio )
                            }
                            else if(radio_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppRadio )
                            }
                            else if(radio_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppRadio )
                            }
                            else if(radio_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppRadio )
                            }
                            else if(radio_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppRadio )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppRadio )
                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist1
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }






            Row
            {

                id:moduleName2_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id:uish_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("UISH")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id:fileManager_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("File Manager")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id:homeScreen_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Home Screen")
                        verticalAlignment: Text.AlignVCenter

                    }
                }

            }



            Row
            {
                id: logDataRow2; height: 80 - linelist1.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist1.height
                    width:logDataRow2.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: uish_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



                    }

                    SpinControl
                    {
                        id: uish_spin
                        aSpinControlTextModel: uish_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: uish_textModel.get( LogSettingData.LoadLogSetting(EngineerData.UISH)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( uish_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.UISH )
                            }

                            else if(uish_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.UISH )

                            }

                            else if(uish_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.UISH )

                            }
                            else if(uish_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.UISH )
                            }

                            else if(uish_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.UISH )
                            }
                            else if(uish_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.UISH )
                            }
                            else if(uish_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.UISH )
                            }
                            else if(uish_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.UISH )
                            }
                            else if(uish_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.UISH )
                            }

                            else if(uish_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.UISH )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.UISH )

                            }

                        }
                    }




                    ListModel
                    {
                        id: fileManager_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



                    }

                    SpinControl
                    {
                        id: fileManager_spin
                        aSpinControlTextModel: fileManager_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: fileManager_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppFileManager)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( fileManager_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppFileManager )
                            }

                            else if(fileManager_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_AppFileManager )

                            }

                            else if(fileManager_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_AppFileManager )

                            }
                            else if(fileManager_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_AppFileManager )
                            }

                            else if(fileManager_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_AppFileManager )
                            }
                            else if(fileManager_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_AppFileManager )
                            }
                            else if(fileManager_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_AppFileManager )
                            }
                            else if(fileManager_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_AppFileManager )
                            }
                            else if(fileManager_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_AppFileManager )
                            }
                            else if(fileManager_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_AppFileManager )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_AppFileManager )
                            }

                        }
                    }

                    ListModel
                    {
                        id: homeScreen_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10}




                    }

                    SpinControl
                    {
                        id: homeScreen_spin
                        aSpinControlTextModel: homeScreen_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: homeScreen_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppHomeScreen)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( homeScreen_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppHomeScreen )
                            }

                            else if(homeScreen_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_AppHomeScreen )

                            }

                            else if(homeScreen_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_AppHomeScreen )

                            }
                            else if(homeScreen_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_AppHomeScreen )
                            }

                            else if(homeScreen_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_AppHomeScreen )
                            }
                            else if(homeScreen_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_AppHomeScreen )
                            }
                            else if(homeScreen_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_AppHomeScreen )
                            }
                            else if(homeScreen_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_AppHomeScreen )
                            }
                            else if(homeScreen_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_AppHomeScreen )
                            }
                            else if(homeScreen_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_AppHomeScreen )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_AppHomeScreen )
                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist2
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }









            Row
            {

                id:moduleName3_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id:appNavi_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Navigation")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id:appClock_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("AppClock")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id:appPhoto_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("AppPhoto")
                        verticalAlignment: Text.AlignVCenter

                    }
                }

            }



            Row
            {
                id: logDataRow3; height: 80 - linelist1.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist1.height
                    width:logDataRow3.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: appNavi_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



                    }

                    SpinControl
                    {
                        id: appNavi_spin
                        aSpinControlTextModel: appNavi_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appNavi_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppNavi)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appNavi_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppNavi )
                            }

                            else if(appNavi_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppNavi )

                            }

                            else if(appNavi_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppNavi )

                            }
                            else if(appNavi_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppNavi )
                            }

                            else if(appNavi_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppNavi )
                            }
                            else if(appNavi_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppNavi )
                            }
                            else if(appNavi_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppNavi )
                            }
                            else if(appNavi_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppNavi )
                            }
                            else if(appNavi_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppNavi )
                            }

                            else if(appNavi_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppNavi )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppNavi )

                            }

                        }
                    }




                    ListModel
                    {
                        id: appClock_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



                    }

                    SpinControl
                    {
                        id: appClock_spin
                        aSpinControlTextModel: appClock_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appClock_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppClock)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appClock_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppClock )
                            }

                            else if(appClock_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_AppClock )

                            }

                            else if(appClock_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_AppClock )

                            }
                            else if(appClock_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_AppClock )
                            }

                            else if(appClock_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_AppClock )
                            }
                            else if(appClock_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_AppClock )
                            }
                            else if(appClock_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_AppClock )
                            }
                            else if(appClock_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_AppClock )
                            }
                            else if(appClock_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_AppClock )
                            }
                            else if(appClock_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_AppClock )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_AppClock )
                            }

                        }
                    }

                    ListModel
                    {
                        id: appPhoto_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10}




                    }

                    SpinControl
                    {
                        id: appPhoto_spin
                        aSpinControlTextModel: appPhoto_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appPhoto_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppPhoto)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appPhoto_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppPhoto )
                            }

                            else if(appPhoto_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_AppPhoto )

                            }

                            else if(appPhoto_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_AppPhoto )

                            }
                            else if(appPhoto_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_AppPhoto )
                            }

                            else if(appPhoto_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_AppPhoto )
                            }
                            else if(appPhoto_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_AppPhoto )
                            }
                            else if(appPhoto_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_AppPhoto )
                            }
                            else if(appPhoto_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_AppPhoto )
                            }
                            else if(appPhoto_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_AppPhoto )
                            }
                            else if(appPhoto_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_AppPhoto )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_AppPhoto )
                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist3
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }








            Row
            {

                id:moduleName4_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id:mostManager_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("MOST Manager")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id:settings_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Settings")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id:standby_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("StandBy")
                        verticalAlignment: Text.AlignVCenter

                    }
                }

            }



            Row
            {
                id: logDataRow4; height: 80 - linelist1.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist1.height
                    width:logDataRow4.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: mostManager_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



                    }

                    SpinControl
                    {
                        id: mostManager_spin
                        aSpinControlTextModel: mostManager_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mostManager_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_MOSTManager)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mostManager_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_MOSTManager )
                            }

                            else if(mostManager_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_MOSTManager )

                            }

                            else if(mostManager_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_MOSTManager )

                            }
                            else if(mostManager_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_MOSTManager )
                            }

                            else if(mostManager_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_MOSTManager )
                            }
                            else if(mostManager_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_MOSTManager )
                            }
                            else if(mostManager_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_MOSTManager )
                            }
                            else if(mostManager_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_MOSTManager )
                            }
                            else if(mostManager_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_MOSTManager )
                            }

                            else if(mostManager_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_MOSTManager )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_MOSTManager )

                            }

                        }
                    }




                    ListModel
                    {
                        id: appSettings_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



                    }

                    SpinControl
                    {
                        id: appSettings_spin
                        aSpinControlTextModel: appSettings_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appSettings_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppSettings)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appSettings_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppSettings )
                            }

                            else if(appSettings_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_AppSettings )

                            }

                            else if(appSettings_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_AppSettings )

                            }
                            else if(appSettings_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_AppSettings )
                            }

                            else if(appSettings_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_AppSettings )
                            }
                            else if(appSettings_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_AppSettings )
                            }
                            else if(appSettings_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_AppSettings )
                            }
                            else if(appSettings_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_AppSettings )
                            }
                            else if(appSettings_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_AppSettings )
                            }
                            else if(appSettings_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_AppSettings )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_AppSettings )
                            }

                        }
                    }

                    ListModel
                    {
                        id: appStandBy_textModel
                        property int count: 11
                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10}




                    }

                    SpinControl
                    {
                        id: appStandBy_spin
                        aSpinControlTextModel: appStandBy_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appStandBy_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppStandBy)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appStandBy_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppStandBy )
                            }

                            else if(appStandBy_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_AppStandBy )

                            }

                            else if(appStandBy_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_AppStandBy )

                            }
                            else if(appStandBy_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_AppStandBy )
                            }

                            else if(appStandBy_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_AppStandBy )
                            }
                            else if(appStandBy_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_AppStandBy )
                            }
                            else if(appStandBy_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_AppStandBy )
                            }
                            else if(appStandBy_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_AppStandBy )
                            }
                            else if(appStandBy_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_AppStandBy )
                            }
                            else if(appStandBy_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_AppStandBy )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_AppStandBy )
                            }

                        }
                    }


                }
            }


//            Image
//            {
//                id: linelist4
//                source: imgFolderGeneral+"line_menu_list.png"
//                x:19; width:1240
//                //anchors.top: systemSW.bottom
//            }












//            Row
//            {

//                id:moduleName5_row; width:1280
//                x:19; height:50

//                Row
//                {

//                    height:50
//                    width:1280
//                    spacing:80

//                    Text
//                    {
//                        id:videoPlayer_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("Video Player")
//                        verticalAlignment: Text.AlignVCenter

//                    }

//                    Text
//                    {
//                        id:btPhone_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("BT Phone")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                    Text
//                    {
//                        id:info_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("INFO")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                }

//            }



//            Row
//            {
//                id: logDataRow5; height: 80 - linelist1.height
//                width: 1280; x: 19


//                Row
//                {
//                    height: 100 - linelist1.height
//                    width:logDataRow5.width - 25
//                    spacing: 80



//                    ListModel
//                    {
//                        id: appVideoPlayer_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: appVideoPlayer_spin
//                        aSpinControlTextModel: appVideoPlayer_textModel
//                        enabled: true
//                        //y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: appVideoPlayer_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppVideoPlayer)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( appVideoPlayer_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppVideoPlayer )
//                            }

//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_AppVideoPlayer )

//                            }

//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_AppVideoPlayer )

//                            }
//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_AppVideoPlayer )
//                            }

//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_AppVideoPlayer )
//                            }
//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_AppVideoPlayer )
//                            }
//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_AppVideoPlayer )
//                            }
//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_AppVideoPlayer )
//                            }
//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_AppVideoPlayer )
//                            }

//                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_AppVideoPlayer )
//                            }
//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_AppVideoPlayer )

//                            }

//                        }
//                    }




//                    ListModel
//                    {
//                        id: appBtPhone_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: appBtPhone_spin
//                        aSpinControlTextModel: appBtPhone_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: appBtPhone_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppBtPhone)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( appBtPhone_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppBtPhone )
//                            }

//                            else if(appBtPhone_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppBtPhone )

//                            }

//                            else if(appBtPhone_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppBtPhone )

//                            }
//                            else if(appBtPhone_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppBtPhone )
//                            }

//                            else if(appBtPhone_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppBtPhone )
//                            }
//                            else if(appBtPhone_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppBtPhone )
//                            }
//                            else if(appBtPhone_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppBtPhone )
//                            }
//                            else if(appBtPhone_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppBtPhone )
//                            }
//                            else if(appBtPhone_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppBtPhone )
//                            }
//                            else if(appBtPhone_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppBtPhone )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppBtPhone )
//                            }

//                        }
//                    }

//                    ListModel
//                    {
//                        id: appInfo_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10}




//                    }

//                    SpinControl
//                    {
//                        id: appInfo_spin
//                        aSpinControlTextModel: appInfo_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: appInfo_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppInfo)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( appInfo_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppInfo )
//                            }

//                            else if(appInfo_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppInfo )

//                            }

//                            else if(appInfo_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppInfo )

//                            }
//                            else if(appInfo_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppInfo )
//                            }

//                            else if(appInfo_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppInfo )
//                            }
//                            else if(appInfo_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppInfo )
//                            }
//                            else if(appInfo_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppInfo )
//                            }
//                            else if(appInfo_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppInfo )
//                            }
//                            else if(appInfo_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppInfo )
//                            }
//                            else if(appInfo_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppInfo )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppInfo )
//                            }

//                        }
//                    }


//                }
//            }


//            Image
//            {
//                id: linelist5
//                source: imgFolderGeneral+"line_menu_list.png"
//                x:19; width:1240
//                //anchors.top: systemSW.bottom
//            }







//            Row
//            {

//                id:moduleName6_row; width:1280
//                x:19; height:50

//                Row
//                {

//                    height:50
//                    width:1280
//                    spacing:80

//                    Text
//                    {
//                        id:mobileTv_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("Mobile TV")
//                        verticalAlignment: Text.AlignVCenter

//                    }

//                    Text
//                    {
//                        id:hvac_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("HVAC")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                    Text
//                    {
//                        id:vr_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("VR")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                }

//            }



//            Row
//            {
//                id: logDataRow6; height: 80 - linelist1.height
//                width: 1280; x: 19


//                Row
//                {
//                    height: 100 - linelist1.height
//                    width:logDataRow6.width - 25
//                    spacing: 80



//                    ListModel
//                    {
//                        id: mobileTv_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: mobileTv_spin
//                        aSpinControlTextModel: mobileTv_textModel
//                        enabled: true
//                        //y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: mobileTv_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppMobileTv)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( mobileTv_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppMobileTv )
//                            }

//                            else if(mobileTv_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppMobileTv )

//                            }

//                            else if(mobileTv_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppMobileTv )

//                            }
//                            else if(mobileTv_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppMobileTv )
//                            }

//                            else if(mobileTv_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppMobileTv )
//                            }
//                            else if(mobileTv_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppMobileTv )
//                            }
//                            else if(mobileTv_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppMobileTv )
//                            }
//                            else if(mobileTv_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppMobileTv )
//                            }
//                            else if(mobileTv_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppMobileTv )
//                            }

//                            else if(mobileTv_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppMobileTv )
//                            }
//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppMobileTv )

//                            }

//                        }
//                    }




//                    ListModel
//                    {
//                        id: hvac_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: hvac_spin
//                        aSpinControlTextModel: hvac_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: hvac_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppHvac)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( hvac_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppHvac )
//                            }

//                            else if(hvac_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppHvac )

//                            }

//                            else if(hvac_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppHvac )

//                            }
//                            else if(hvac_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppHvac )
//                            }

//                            else if(hvac_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppHvac )
//                            }
//                            else if(hvac_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppHvac )
//                            }
//                            else if(hvac_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppHvac )
//                            }
//                            else if(hvac_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppHvac )
//                            }
//                            else if(hvac_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppHvac )
//                            }
//                            else if(hvac_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppHvac )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppHvac )
//                            }

//                        }
//                    }

//                    ListModel
//                    {
//                        id: vr_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10}




//                    }

//                    SpinControl
//                    {
//                        id:vr_spin
//                        aSpinControlTextModel: vr_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: vr_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppVR)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if(vr_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppVR )
//                            }

//                            else if(vr_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppVR )

//                            }

//                            else if(vr_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppVR )

//                            }
//                            else if(vr_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppVR )
//                            }

//                            else if(vr_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppVR )
//                            }
//                            else if(vr_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppVR )
//                            }
//                            else if(vr_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppVR )
//                            }
//                            else if(vr_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppVR )
//                            }
//                            else if(vr_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppVR )
//                            }
//                            else if(vr_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppVR )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppVR )
//                            }

//                        }
//                    }


//                }
//            }


//            Image
//            {
//                id: linelist6
//                source: imgFolderGeneral+"line_menu_list.png"
//                x:19; width:1240
//                //anchors.top: systemSW.bottom
//            }



//            Row
//            {

//                id:moduleName7_row; width:1280
//                x:19; height:50

//                Row
//                {

//                    height:50
//                    width:1280
//                    spacing:80

//                    Text
//                    {
//                        id:settingsBt_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("Settings BT")
//                        verticalAlignment: Text.AlignVCenter

//                    }

//                    Text
//                    {
//                        id:ibox_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("iBox")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                    Text
//                    {
//                        id:upgrade_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("Upgrade")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                }

//            }



//            Row
//            {
//                id: logDataRow7; height: 80 - linelist1.height
//                width: 1280; x: 19


//                Row
//                {
//                    height: 100 - linelist1.height
//                    width:logDataRow7.width - 25
//                    spacing: 80



//                    ListModel
//                    {
//                        id: settingsBt_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: settingsBt_spin
//                        aSpinControlTextModel: settingsBt_textModel
//                        enabled: true
//                        //y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: settingsBt_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppSettingsBt)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( settingsBt_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppSettingsBt )
//                            }

//                            else if(settingsBt_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppSettingsBt )

//                            }

//                            else if(settingsBt_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppSettingsBt )

//                            }
//                            else if(settingsBt_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppSettingsBt )
//                            }

//                            else if(settingsBt_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppSettingsBt )
//                            }
//                            else if(settingsBt_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppSettingsBt )
//                            }
//                            else if(settingsBt_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppSettingsBt )
//                            }
//                            else if(settingsBt_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppSettingsBt )
//                            }
//                            else if(settingsBt_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppSettingsBt )
//                            }

//                            else if(settingsBt_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppSettingsBt )
//                            }
//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppSettingsBt )

//                            }

//                        }
//                    }




//                    ListModel
//                    {
//                        id: ibox_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: ibox_spin
//                        aSpinControlTextModel: ibox_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: ibox_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppIBOX)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( ibox_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppIBOX )
//                            }

//                            else if(ibox_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppIBOX )

//                            }

//                            else if(ibox_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppIBOX )

//                            }
//                            else if(ibox_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppIBOX )
//                            }

//                            else if(ibox_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppIBOX )
//                            }
//                            else if(ibox_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppIBOX )
//                            }
//                            else if(ibox_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppIBOX )
//                            }
//                            else if(ibox_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppIBOX )
//                            }
//                            else if(ibox_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppIBOX )
//                            }
//                            else if(ibox_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppIBOX )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppIBOX )
//                            }

//                        }
//                    }

//                    ListModel
//                    {
//                        id: upgrade_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10}




//                    }

//                    SpinControl
//                    {
//                        id: upgrade_spin
//                        aSpinControlTextModel: upgrade_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: upgrade_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppUpgrade)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if(upgrade_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppUpgrade )
//                            }

//                            else if(upgrade_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppUpgrade )

//                            }

//                            else if(upgrade_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppUpgrade )

//                            }
//                            else if(upgrade_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppUpgrade )
//                            }

//                            else if(upgrade_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppUpgrade )
//                            }
//                            else if(upgrade_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppUpgrade )
//                            }
//                            else if(upgrade_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppUpgrade )
//                            }
//                            else if(upgrade_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppUpgrade )
//                            }
//                            else if(upgrade_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppUpgrade )
//                            }
//                            else if(upgrade_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppUpgrade )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppUpgrade )
//                            }

//                        }
//                    }


//                }
//            }


//            Image
//            {
//                id: linelist7
//                source: imgFolderGeneral+"line_menu_list.png"
//                x:19; width:1240
//                //anchors.top: systemSW.bottom
//            }






//            Row
//            {

//                id:moduleName8_row; width:1280
//                x:19; height:50

//                Row
//                {

//                    height:50
//                    width:1280
//                    spacing:80

//                    Text
//                    {
//                        id:camera_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("Camera")
//                        verticalAlignment: Text.AlignVCenter

//                    }

//                    Text
//                    {
//                        id:xmAudio_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("XM Audio")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                    Text
//                    {
//                        id:xmData_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("XM Data")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                }

//            }



//            Row
//            {
//                id: logDataRow8; height: 80 - linelist1.height
//                width: 1280; x: 19


//                Row
//                {
//                    height: 100 - linelist1.height
//                    width:logDataRow8.width - 25
//                    spacing: 80



//                    ListModel
//                    {
//                        id: camera_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: camera_spin
//                        aSpinControlTextModel: camera_textModel
//                        enabled: true
//                        //y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: camera_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppCamera)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( camera_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppCamera )
//                            }

//                            else if(camera_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppCamera )

//                            }

//                            else if(camera_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppCamera )

//                            }
//                            else if(camera_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppCamera )
//                            }

//                            else if(camera_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppCamera )
//                            }
//                            else if(camera_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppCamera )
//                            }
//                            else if(camera_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppCamera )
//                            }
//                            else if(camera_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppCamera )
//                            }
//                            else if(camera_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppCamera )
//                            }

//                            else if(camera_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppCamera )
//                            }
//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppCamera )

//                            }

//                        }
//                    }




//                    ListModel
//                    {
//                        id: xmAudio_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: xmAudio_spin
//                        aSpinControlTextModel: xmAudio_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: xmAudio_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppXMAudio)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( xmAudio_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppXMAudio )
//                            }

//                            else if(xmAudio_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppXMAudio )

//                            }

//                            else if(xmAudio_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppXMAudio )

//                            }
//                            else if(xmAudio_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppXMAudio )
//                            }

//                            else if(xmAudio_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppXMAudio )
//                            }
//                            else if(xmAudio_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppXMAudio )
//                            }
//                            else if(xmAudio_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppXMAudio )
//                            }
//                            else if(xmAudio_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppXMAudio )
//                            }
//                            else if(xmAudio_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppXMAudio )
//                            }
//                            else if(xmAudio_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppXMAudio )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppXMAudio )
//                            }

//                        }
//                    }

//                    ListModel
//                    {
//                        id: xmData_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10}




//                    }

//                    SpinControl
//                    {
//                        id: xmData_spin
//                        aSpinControlTextModel: xmData_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: xmData_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppXMData)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if(xmData_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppXMData )
//                            }

//                            else if(xmData_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppXMData )

//                            }

//                            else if(xmData_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppXMData )

//                            }
//                            else if(xmData_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppXMData )
//                            }

//                            else if(xmData_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppXMData )
//                            }
//                            else if(xmData_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppXMData )
//                            }
//                            else if(xmData_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppXMData )
//                            }
//                            else if(xmData_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppXMData )
//                            }
//                            else if(xmData_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppXMData )
//                            }
//                            else if(xmData_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppXMData )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppXMData )
//                            }

//                        }
//                    }


//                }
//            }


//            Image
//            {
//                id: linelist8
//                source: imgFolderGeneral+"line_menu_list.png"
//                x:19; width:1240
//                //anchors.top: systemSW.bottom
//            }









//            Row
//            {

//                id:moduleName9_row; width:1280
//                x:19; height:50

//                Row
//                {

//                    height:50
//                    width:1280
//                    spacing:80

//                    Text
//                    {
//                        id: appDAB_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("DAB")
//                        verticalAlignment: Text.AlignVCenter

//                    }

//                    Text
//                    {
//                        id: appMicomUser_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("MMUS")
//                        verticalAlignment: Text.AlignVCenter

//                    }
//                    Text
//                    {
//                        id: appNone_text
//                        height:50
//                        width: 360
//                        font.family: UIListener.getFont(false) //"Calibri"
//                        font.pixelSize: 20
//                        color:"#447CAD"
//                        text: qsTr("APP_NONE")
//                        verticalAlignment: Text.AlignVCenter

//                    }

//                }

//            }



//            Row
//            {
//                id: logDataRow9; height: 80 - linelist1.height
//                width: 1280; x: 19


//                Row
//                {
//                    height: 100 - linelist1.height
//                    width:logDataRow9.width - 25
//                    spacing: 80



//                    ListModel
//                    {
//                        id: dab_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: dab_spin
//                        aSpinControlTextModel: dab_textModel
//                        enabled: true
//                        //y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: dab_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppDAB)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( dab_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppDAB )
//                            }

//                            else if(dab_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppDAB )

//                            }

//                            else if(dab_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppDAB )

//                            }
//                            else if(dab_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppDAB )
//                            }

//                            else if(dab_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppDAB )
//                            }
//                            else if(dab_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppDAB )
//                            }
//                            else if(dab_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppDAB )
//                            }
//                            else if(dab_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppDAB )
//                            }
//                            else if(dab_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppDAB )
//                            }

//                            else if(dab_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppDAB )
//                            }
//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppDAB )

//                            }

//                        }
//                    }




//                    ListModel
//                    {
//                        id: mmus_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: mmus_spin
//                        aSpinControlTextModel: mmus_textModel
//                        enabled: true
//                        // y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: mmus_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DaemonMMus)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( mmus_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.DaemonMMus )
//                            }

//                            else if(mmus_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.DaemonMMus )

//                            }

//                            else if(mmus_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.DaemonMMus )

//                            }
//                            else if(mmus_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.DaemonMMus )
//                            }

//                            else if(mmus_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.DaemonMMus )
//                            }
//                            else if(mmus_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.DaemonMMus )
//                            }
//                            else if(mmus_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.DaemonMMus )
//                            }
//                            else if(mmus_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.DaemonMMus )
//                            }
//                            else if(mmus_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.DaemonMMus )
//                            }
//                            else if(mmus_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.DaemonMMus )
//                            }

//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.DaemonMMus )
//                            }

//                        }
//                    }

//                    ListModel
//                    {
//                        id: appNone_textModel
//                        property int count: 11
//                        ListElement {text: QT_TR_NOOP("ASSERT"); elementId: 0 }
//                        ListElement {text: QT_TR_NOOP("LOW"); elementId: 1 }
//                        ListElement {text: QT_TR_NOOP("TRACE");  elementId: 2 }
//                        ListElement {text: QT_TR_NOOP("MEDIUM");  elementId: 3 }
//                        ListElement {text: QT_TR_NOOP("INFO");  elementId: 4 }
//                        ListElement {text: QT_TR_NOOP("HIGH");  elementId: 5 }
//                        ListElement {text: QT_TR_NOOP("SIGNAL"); elementId: 6 }
//                        ListElement {text: QT_TR_NOOP("SLOT"); elementId: 7 }
//                        ListElement {text: QT_TR_NOOP("TRANSITION"); elementId: 8 }
//                        ListElement {text: QT_TR_NOOP("CRITICAL");  elementId: 9 }
//                        ListElement {text: QT_TR_NOOP("Disable");  elementId: 10 }



//                    }

//                    SpinControl
//                    {
//                        id: appNone_spin
//                        aSpinControlTextModel: appNone_textModel
//                        enabled: true
//                        //y: 187
//                        // x:130
//                        iSpinCtrlType: 1
//                        width:360

//                        //y: (booting_data.height - booting_spin.height) / 2

//                        sCurrentValue: appNone_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppDAB)).text//EngineerData.DHAVN_QCANController)).text

//                        onSpinControlValueChanged:
//                        {
//                            if( appNone_spin.sCurrentValue == qsTr("ASSERT") )
//                            {
//                                LogSettingData.SaveLogSetting(0, EngineerData.AppDAB )
//                            }

//                            else if(appNone_spin.sCurrentValue == qsTr("LOW"))
//                            {
//                                LogSettingData.SaveLogSetting(1,EngineerData.AppDAB )

//                            }

//                            else if(appNone_spin.sCurrentValue == qsTr("TRACE"))
//                            {
//                                LogSettingData.SaveLogSetting(2,EngineerData.AppDAB )

//                            }
//                            else if(appNone_spin.sCurrentValue == qsTr("MEDIUM"))
//                            {
//                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppDAB )
//                            }

//                            else if(appNone_spin.sCurrentValue == qsTr("INFO"))
//                            {
//                                LogSettingData.SaveLogSetting(4,EngineerData.AppDAB )
//                            }
//                            else if(appNone_spin.sCurrentValue == qsTr("HIGH")){

//                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppDAB )
//                            }
//                            else if(appNone_spin.sCurrentValue == qsTr("SIGNAL")){

//                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppDAB )
//                            }
//                            else if(appNone_spin.sCurrentValue == qsTr("SLOT")){

//                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppDAB )
//                            }
//                            else if(appNone_spin.sCurrentValue == qsTr("TRANSITION")){

//                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppDAB )
//                            }

//                            else if(appNone_spin.sCurrentValue == qsTr("CRITICAL")){

//                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppDAB )
//                            }
//                            else{

//                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppDAB )

//                            }

//                        }
//                    }


//                }
//            }


//            Image
//            {
//                id: linelist9
//                source: imgFolderGeneral+"line_menu_list.png"
//                x:19; width:1240
//                //anchors.top: systemSW.bottom
//            }



        }
    }


    ListView
    {
        id: listOflogSystem
        anchors.fill: content_logsystem
        model: 1
        orientation: ListView.Vertical
        delegate: logsystem_list
        clip: true
    }

}
