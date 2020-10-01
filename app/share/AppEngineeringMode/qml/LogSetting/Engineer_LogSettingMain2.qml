import QtQuick 1.0
import QmlSimpleItems 1.0
import com.engineer.data 1.0


import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
Item
{

    id: content_logsystemList2
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
        id:logsystem_list2

        Column
        {
            id:logsystemColumn2; width:content_logsystemList2.width;


            Row
            {

                id:moduleName5_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id:videoPlayer_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Video Player")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id:btPhone_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("BT Phone")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id:info_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("INFO")
                        verticalAlignment: Text.AlignVCenter

                    }
                }

            }



            Row
            {
                id: logDataRow5; height: 80 - linelist5.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist5.height
                    width:logDataRow5.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: appVideoPlayer_textModel
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
                        id: appVideoPlayer_spin
                        aSpinControlTextModel: appVideoPlayer_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appVideoPlayer_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppVideoPlayer)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appVideoPlayer_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppVideoPlayer )
                            }

                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DHAVN_AppVideoPlayer )

                            }

                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DHAVN_AppVideoPlayer )

                            }
                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DHAVN_AppVideoPlayer )
                            }

                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DHAVN_AppVideoPlayer )
                            }
                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DHAVN_AppVideoPlayer )
                            }
                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DHAVN_AppVideoPlayer )
                            }
                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DHAVN_AppVideoPlayer )
                            }
                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DHAVN_AppVideoPlayer )
                            }

                            else if(appVideoPlayer_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DHAVN_AppVideoPlayer )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DHAVN_AppVideoPlayer )

                            }

                        }
                    }




                    ListModel
                    {
                        id: appBtPhone_textModel
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
                        id: appBtPhone_spin
                        aSpinControlTextModel: appBtPhone_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appBtPhone_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppBtPhone)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appBtPhone_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppBtPhone )
                            }

                            else if(appBtPhone_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppBtPhone )

                            }

                            else if(appBtPhone_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppBtPhone )

                            }
                            else if(appBtPhone_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppBtPhone )
                            }

                            else if(appBtPhone_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppBtPhone )
                            }
                            else if(appBtPhone_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppBtPhone )
                            }
                            else if(appBtPhone_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppBtPhone )
                            }
                            else if(appBtPhone_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppBtPhone )
                            }
                            else if(appBtPhone_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppBtPhone )
                            }
                            else if(appBtPhone_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppBtPhone )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppBtPhone )
                            }

                        }
                    }

                    ListModel
                    {
                        id: appInfo_textModel
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
                        id: appInfo_spin
                        aSpinControlTextModel: appInfo_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appInfo_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppInfo)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appInfo_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppInfo )
                            }

                            else if(appInfo_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppInfo )

                            }

                            else if(appInfo_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppInfo )

                            }
                            else if(appInfo_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppInfo )
                            }

                            else if(appInfo_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppInfo )
                            }
                            else if(appInfo_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppInfo )
                            }
                            else if(appInfo_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppInfo )
                            }
                            else if(appInfo_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppInfo )
                            }
                            else if(appInfo_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppInfo )
                            }
                            else if(appInfo_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppInfo )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppInfo )
                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist5
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }







            Row
            {

                id:moduleName6_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id:mobileTv_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Mobile TV")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id:hvac_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("HVAC")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id:vr_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("VR")
                        verticalAlignment: Text.AlignVCenter

                    }
                }

            }



            Row
            {
                id: logDataRow6; height: 80 - linelist5.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist5.height
                    width:logDataRow6.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: mobileTv_textModel
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
                        id: mobileTv_spin
                        aSpinControlTextModel: mobileTv_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mobileTv_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppMobileTv)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mobileTv_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppMobileTv )
                            }

                            else if(mobileTv_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppMobileTv )

                            }

                            else if(mobileTv_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppMobileTv )

                            }
                            else if(mobileTv_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppMobileTv )
                            }

                            else if(mobileTv_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppMobileTv )
                            }
                            else if(mobileTv_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppMobileTv )
                            }
                            else if(mobileTv_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppMobileTv )
                            }
                            else if(mobileTv_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppMobileTv )
                            }
                            else if(mobileTv_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppMobileTv )
                            }

                            else if(mobileTv_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppMobileTv )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppMobileTv )

                            }

                        }
                    }




                    ListModel
                    {
                        id: hvac_textModel
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
                        id: hvac_spin
                        aSpinControlTextModel: hvac_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: hvac_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppHvac)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( hvac_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppHvac )
                            }

                            else if(hvac_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppHvac )

                            }

                            else if(hvac_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppHvac )

                            }
                            else if(hvac_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppHvac )
                            }

                            else if(hvac_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppHvac )
                            }
                            else if(hvac_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppHvac )
                            }
                            else if(hvac_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppHvac )
                            }
                            else if(hvac_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppHvac )
                            }
                            else if(hvac_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppHvac )
                            }
                            else if(hvac_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppHvac )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppHvac )
                            }

                        }
                    }

                    ListModel
                    {
                        id: vr_textModel
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
                        id:vr_spin
                        aSpinControlTextModel: vr_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: vr_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppVR)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if(vr_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppVR )
                            }

                            else if(vr_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppVR )

                            }

                            else if(vr_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppVR )

                            }
                            else if(vr_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppVR )
                            }

                            else if(vr_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppVR )
                            }
                            else if(vr_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppVR )
                            }
                            else if(vr_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppVR )
                            }
                            else if(vr_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppVR )
                            }
                            else if(vr_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppVR )
                            }
                            else if(vr_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppVR )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppVR )
                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist6
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }



            Row
            {

                id:moduleName7_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id:settingsBt_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Settings BT")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id:ibox_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("iBox")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id:upgrade_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Upgrade")
                        verticalAlignment: Text.AlignVCenter

                    }
                }

            }



            Row
            {
                id: logDataRow7; height: 80 - linelist5.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist5.height
                    width:logDataRow7.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: settingsBt_textModel
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
                        id: settingsBt_spin
                        aSpinControlTextModel: settingsBt_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: settingsBt_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppSettingsBt)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( settingsBt_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppSettingsBt )
                            }

                            else if(settingsBt_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppSettingsBt )

                            }

                            else if(settingsBt_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppSettingsBt )

                            }
                            else if(settingsBt_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppSettingsBt )
                            }

                            else if(settingsBt_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppSettingsBt )
                            }
                            else if(settingsBt_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppSettingsBt )
                            }
                            else if(settingsBt_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppSettingsBt )
                            }
                            else if(settingsBt_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppSettingsBt )
                            }
                            else if(settingsBt_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppSettingsBt )
                            }

                            else if(settingsBt_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppSettingsBt )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppSettingsBt )

                            }

                        }
                    }




                    ListModel
                    {
                        id: ibox_textModel
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
                        id: ibox_spin
                        aSpinControlTextModel: ibox_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: ibox_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppIBOX)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( ibox_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppIBOX )
                            }

                            else if(ibox_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppIBOX )

                            }

                            else if(ibox_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppIBOX )

                            }
                            else if(ibox_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppIBOX )
                            }

                            else if(ibox_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppIBOX )
                            }
                            else if(ibox_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppIBOX )
                            }
                            else if(ibox_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppIBOX )
                            }
                            else if(ibox_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppIBOX )
                            }
                            else if(ibox_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppIBOX )
                            }
                            else if(ibox_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppIBOX )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppIBOX )
                            }

                        }
                    }

                    ListModel
                    {
                        id: upgrade_textModel
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
                        id: upgrade_spin
                        aSpinControlTextModel: upgrade_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: upgrade_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppUpgrade)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if(upgrade_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppUpgrade )
                            }

                            else if(upgrade_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppUpgrade )

                            }

                            else if(upgrade_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppUpgrade )

                            }
                            else if(upgrade_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppUpgrade )
                            }

                            else if(upgrade_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppUpgrade )
                            }
                            else if(upgrade_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppUpgrade )
                            }
                            else if(upgrade_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppUpgrade )
                            }
                            else if(upgrade_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppUpgrade )
                            }
                            else if(upgrade_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppUpgrade )
                            }
                            else if(upgrade_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppUpgrade )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppUpgrade )
                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist7
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }






            Row
            {

                id:moduleName8_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id:camera_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Camera")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id:xmAudio_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("XM Audio")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id:xmData_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("XM Data")
                        verticalAlignment: Text.AlignVCenter

                    }
                }

            }



            Row
            {
                id: logDataRow8; height: 80 - linelist5.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist5.height
                    width:logDataRow8.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: camera_textModel
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
                        id: camera_spin
                        aSpinControlTextModel: camera_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: camera_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppCamera)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( camera_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppCamera )
                            }

                            else if(camera_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppCamera )

                            }

                            else if(camera_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppCamera )

                            }
                            else if(camera_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppCamera )
                            }

                            else if(camera_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppCamera )
                            }
                            else if(camera_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppCamera )
                            }
                            else if(camera_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppCamera )
                            }
                            else if(camera_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppCamera )
                            }
                            else if(camera_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppCamera )
                            }

                            else if(camera_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppCamera )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppCamera )

                            }

                        }
                    }




                    ListModel
                    {
                        id: xmAudio_textModel
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
                        id: xmAudio_spin
                        aSpinControlTextModel: xmAudio_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: xmAudio_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppXMAudio)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( xmAudio_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppXMAudio )
                            }

                            else if(xmAudio_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppXMAudio )

                            }

                            else if(xmAudio_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppXMAudio )

                            }
                            else if(xmAudio_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppXMAudio )
                            }

                            else if(xmAudio_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppXMAudio )
                            }
                            else if(xmAudio_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppXMAudio )
                            }
                            else if(xmAudio_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppXMAudio )
                            }
                            else if(xmAudio_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppXMAudio )
                            }
                            else if(xmAudio_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppXMAudio )
                            }
                            else if(xmAudio_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppXMAudio )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppXMAudio )
                            }

                        }
                    }

                    ListModel
                    {
                        id: xmData_textModel
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
                        id: xmData_spin
                        aSpinControlTextModel: xmData_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: xmData_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppXMData)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if(xmData_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppXMData )
                            }

                            else if(xmData_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppXMData )

                            }

                            else if(xmData_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppXMData )

                            }
                            else if(xmData_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppXMData )
                            }

                            else if(xmData_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppXMData )
                            }
                            else if(xmData_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppXMData )
                            }
                            else if(xmData_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppXMData )
                            }
                            else if(xmData_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppXMData )
                            }
                            else if(xmData_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppXMData )
                            }
                            else if(xmData_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppXMData )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppXMData )
                            }

                        }
                    }
                }
            }
        }
    }


    ListView
    {
        id: listOflogSystem2
        anchors.fill: content_logsystemList2
        model: 1
        orientation: ListView.Vertical
        delegate: logsystem_list2
        clip: true
    }

}
