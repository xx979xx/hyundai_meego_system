import QtQuick 1.0
import QmlSimpleItems 1.0
import com.engineer.data 1.0


import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
Item
{

    id: content_logsystemList3
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
        id:logsystem_list3

        Column
        {
            id:logsystemColumn3; width:content_logsystemList3.width;


            Row
            {

                id:moduleName9_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id: appDAB_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("DAB")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id: appMicomUser_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("MMUS")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id: appNone_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("APP_NONE")
                        verticalAlignment: Text.AlignVCenter

                    }

                }

            }



            Row
            {
                id: logDataRow9; height: 80 - linelist9.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist9.height
                    width:logDataRow9.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: dab_textModel
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
                        id: dab_spin
                        aSpinControlTextModel: dab_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: dab_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppDAB)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( dab_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppDAB )
                            }

                            else if(dab_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppDAB )

                            }

                            else if(dab_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppDAB )

                            }
                            else if(dab_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppDAB )
                            }

                            else if(dab_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppDAB )
                            }
                            else if(dab_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppDAB )
                            }
                            else if(dab_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppDAB )
                            }
                            else if(dab_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppDAB )
                            }
                            else if(dab_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppDAB )
                            }

                            else if(dab_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppDAB )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppDAB )

                            }

                        }
                    }




                    ListModel
                    {
                        id: mmus_textModel
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
                        id: mmus_spin
                        aSpinControlTextModel: mmus_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mmus_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DaemonMMus)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mmus_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DaemonMMus )
                            }

                            else if(mmus_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DaemonMMus )

                            }

                            else if(mmus_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DaemonMMus )

                            }
                            else if(mmus_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DaemonMMus )
                            }

                            else if(mmus_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DaemonMMus )
                            }
                            else if(mmus_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DaemonMMus )
                            }
                            else if(mmus_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DaemonMMus )
                            }
                            else if(mmus_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DaemonMMus )
                            }
                            else if(mmus_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DaemonMMus )
                            }
                            else if(mmus_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DaemonMMus )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DaemonMMus )
                            }

                        }
                    }

                    ListModel
                    {
                        id: appNone_textModel
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
                        id: appNone_spin
                        aSpinControlTextModel: appNone_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: appNone_textModel.get( LogSettingData.LoadLogSetting(EngineerData.App_NONE)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( appNone_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.App_NONE )
                            }

                            else if(appNone_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.App_NONE )

                            }

                            else if(appNone_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.App_NONE )

                            }
                            else if(appNone_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.App_NONE )
                            }

                            else if(appNone_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.App_NONE )
                            }
                            else if(appNone_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.App_NONE )
                            }
                            else if(appNone_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.App_NONE )
                            }
                            else if(appNone_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.App_NONE )
                            }
                            else if(appNone_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.App_NONE )
                            }

                            else if(appNone_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.App_NONE )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.App_NONE )

                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist9
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }

            Row
            {

                id:moduleName10_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id: appPandora_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Pandora")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id: daemonXM_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("DaemonXm")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id: mediaPlayerEngine_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Media_PlayerEngine")
                        verticalAlignment: Text.AlignVCenter

                    }

                }

            }



            Row
            {
                id: logDataRow10; height: 80 - linelist9.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist9.height
                    width:logDataRow10.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: pandora_textModel
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
                        id: pandora_spin
                        aSpinControlTextModel: pandora_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: pandora_textModel.get( LogSettingData.LoadLogSetting(EngineerData.AppPANDORA)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( pandora_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.AppPANDORA )
                            }

                            else if(pandora_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.AppPANDORA )

                            }

                            else if(pandora_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.AppPANDORA )

                            }
                            else if(pandora_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.AppPANDORA )
                            }

                            else if(pandora_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.AppPANDORA )
                            }
                            else if(pandora_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.AppPANDORA )
                            }
                            else if(pandora_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.AppPANDORA )
                            }
                            else if(pandora_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.AppPANDORA )
                            }
                            else if(pandora_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.AppPANDORA )
                            }

                            else if(pandora_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.AppPANDORA )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.AppPANDORA )

                            }

                        }
                    }




                    ListModel
                    {
                        id: daemonXm_textModel
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
                        id: daemonXm_spin
                        aSpinControlTextModel: daemonXm_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: daemonXm_textModel.get( LogSettingData.LoadLogSetting(EngineerData.DaemonXM)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( daemonXm_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.DaemonXM )
                            }

                            else if(daemonXm_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.DaemonXM )

                            }

                            else if(daemonXm_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.DaemonXM )

                            }
                            else if(daemonXm_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.DaemonXM )
                            }

                            else if(daemonXm_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.DaemonXM )
                            }
                            else if(daemonXm_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.DaemonXM )
                            }
                            else if(daemonXm_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.DaemonXM )
                            }
                            else if(daemonXm_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.DaemonXM )
                            }
                            else if(daemonXm_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.DaemonXM )
                            }
                            else if(daemonXm_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.DaemonXM )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.DaemonXM )
                            }

                        }
                    }

                    ListModel
                    {
                        id: mediaPlayerEngine_textModel
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
                        id: mediaPlayerEngine_spin
                        aSpinControlTextModel: mediaPlayerEngine_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mediaPlayerEngine_textModel.get( LogSettingData.LoadLogSetting(EngineerData.Media_PlayerEngine)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mediaPlayerEngine_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.Media_PlayerEngine )
                            }

                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.Media_PlayerEngine )

                            }

                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.Media_PlayerEngine )

                            }
                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.Media_PlayerEngine )
                            }

                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.Media_PlayerEngine )
                            }
                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.Media_PlayerEngine )
                            }
                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.Media_PlayerEngine )
                            }
                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.Media_PlayerEngine )
                            }
                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.Media_PlayerEngine )
                            }

                            else if(mediaPlayerEngine_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.Media_PlayerEngine )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.Media_PlayerEngine )

                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist10
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }

            Row
            {

                id:moduleName11_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id: mediaGracenote_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Media_GraceNotePlugin")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id: mediaIPodController_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Media_IPodController")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id: mediaIPodController1_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Media_IPodController:1")
                        verticalAlignment: Text.AlignVCenter

                    }

                }

            }



            Row
            {
                id: logDataRow11; height: 80 - linelist9.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist9.height
                    width:logDataRow11.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: gracenote_textModel
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
                        id: gracenote_spin
                        aSpinControlTextModel: gracenote_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: gracenote_textModel.get( LogSettingData.LoadLogSetting(EngineerData.Media_GracenotePluginProcess)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( gracenote_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.Media_GracenotePluginProcess )
                            }

                            else if(gracenote_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.Media_GracenotePluginProcess )

                            }

                            else if(gracenote_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.Media_GracenotePluginProcess )

                            }
                            else if(gracenote_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.Media_GracenotePluginProcess )
                            }

                            else if(gracenote_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.Media_GracenotePluginProcess )
                            }
                            else if(gracenote_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.Media_GracenotePluginProcess )
                            }
                            else if(gracenote_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.Media_GracenotePluginProcess )
                            }
                            else if(gracenote_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.Media_GracenotePluginProcess )
                            }
                            else if(gracenote_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.Media_GracenotePluginProcess )
                            }

                            else if(gracenote_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.Media_GracenotePluginProcess )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.Media_GracenotePluginProcess )

                            }

                        }
                    }




                    ListModel
                    {
                        id: mediaIPod_textModel
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
                        id:mediaIPod_spin
                        aSpinControlTextModel: mediaIPod_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mediaIPod_textModel.get( LogSettingData.LoadLogSetting(EngineerData.Media_IPodController)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mediaIPod_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.Media_IPodController )
                            }

                            else if(mediaIPod_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.Media_IPodController )

                            }

                            else if(mediaIPod_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.Media_IPodController )

                            }
                            else if(mediaIPod_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.Media_IPodController )
                            }

                            else if(mediaIPod_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.Media_IPodController )
                            }
                            else if(mediaIPod_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.Media_IPodController )
                            }
                            else if(mediaIPod_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.Media_IPodController )
                            }
                            else if(mediaIPod_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.Media_IPodController )
                            }
                            else if(mediaIPod_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.Media_IPodController )
                            }
                            else if(mediaIPod_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.Media_IPodController )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.Media_IPodController )
                            }

                        }
                    }

                    ListModel
                    {
                        id: mediaIPod1_textModel
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
                        id: mediaIPod1_spin
                        aSpinControlTextModel: mediaIPod1_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mediaIPod1_textModel.get( LogSettingData.LoadLogSetting(EngineerData.Media_IPodController1)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mediaIPod1_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.Media_IPodController1 )
                            }

                            else if(mediaIPod1_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.Media_IPodController1 )

                            }

                            else if(mediaIPod1_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.Media_IPodController1 )

                            }
                            else if(mediaIPod1_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.Media_IPodController1 )
                            }

                            else if(mediaIPod1_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.Media_IPodController1 )
                            }
                            else if(mediaIPod1_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.Media_IPodController1 )
                            }
                            else if(mediaIPod1_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.Media_IPodController1 )
                            }
                            else if(mediaIPod1_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.Media_IPodController1 )
                            }
                            else if(mediaIPod1_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.Media_IPodController1 )
                            }

                            else if(mediaIPod1_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.Media_IPodController1 )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.Media_IPodController1 )

                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist11
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }

            Row
            {

                id:moduleName12_row; width:1280
                x:19; height:50

                Row
                {

                    height:50
                    width:1280
                    spacing:80

                    Text
                    {
                        id: mediaIPod2_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Media_IPodController:2")
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text
                    {
                        id: mediaTrackerAbstractor_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Media_TrackerAbstractor")
                        verticalAlignment: Text.AlignVCenter

                    }
                    Text
                    {
                        id: mediaTrackerExtractor_text
                        height:50
                        width: 360
                        font.family: UIListener.getFont(false) //"Calibri"
                        font.pixelSize: 20
                        color:"#447CAD"
                        text: qsTr("Media_TrackerExtractor")
                        verticalAlignment: Text.AlignVCenter

                    }

                }

            }



            Row
            {
                id: logDataRow12; height: 80 - linelist9.height
                width: 1280; x: 19


                Row
                {
                    height: 100 - linelist9.height
                    width:logDataRow12.width - 25
                    spacing: 80



                    ListModel
                    {
                        id: mediaIPod2_textModel
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
                        id: mediaIPod2_spin
                        aSpinControlTextModel: mediaIPod2_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mediaIPod2_textModel.get( LogSettingData.LoadLogSetting(EngineerData.Media_IPodController2)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mediaIPod2_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.Media_IPodController2 )
                            }

                            else if(mediaIPod2_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.Media_IPodController2 )

                            }

                            else if(mediaIPod2_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.Media_IPodController2 )

                            }
                            else if(mediaIPod2_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.Media_IPodController2 )
                            }

                            else if(mediaIPod2_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.Media_IPodController2 )
                            }
                            else if(mediaIPod2_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.Media_IPodController2 )
                            }
                            else if(mediaIPod2_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.Media_IPodController2 )
                            }
                            else if(mediaIPod2_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.Media_IPodController2 )
                            }
                            else if(mediaIPod2_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.Media_IPodController2 )
                            }

                            else if(mediaIPod2_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.Media_IPodController2 )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.Media_IPodController2 )

                            }

                        }
                    }




                    ListModel
                    {
                        id: mediaTrackerAbstractor_textModel
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
                        id:mediaTrackerAbstractor_spin
                        aSpinControlTextModel: mediaTrackerAbstractor_textModel
                        enabled: true
                        // y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mediaTrackerAbstractor_textModel.get( LogSettingData.LoadLogSetting(EngineerData.Media_TrackerAbstractor)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mediaTrackerAbstractor_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.Media_TrackerAbstractor )
                            }

                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.Media_TrackerAbstractor )

                            }

                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.Media_TrackerAbstractor )

                            }
                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.Media_TrackerAbstractor )
                            }

                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.Media_TrackerAbstractor )
                            }
                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.Media_TrackerAbstractor )
                            }
                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.Media_TrackerAbstractor )
                            }
                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.Media_TrackerAbstractor )
                            }
                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.Media_TrackerAbstractor )
                            }
                            else if(mediaTrackerAbstractor_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.Media_TrackerAbstractor )
                            }

                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.Media_TrackerAbstractor )
                            }

                        }
                    }

                    ListModel
                    {
                        id: mediaTrackerExtractor_textModel
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
                        id: mediaTrackerExtractor_spin
                        aSpinControlTextModel: mediaTrackerExtractor_textModel
                        enabled: true
                        //y: 187
                        // x:130
                        iSpinCtrlType: 1
                        width:360

                        //y: (booting_data.height - booting_spin.height) / 2

                        sCurrentValue: mediaTrackerExtractor_textModel.get( LogSettingData.LoadLogSetting(EngineerData.Media_TrackerExtractor)).text//EngineerData.DHAVN_QCANController)).text

                        onSpinControlValueChanged:
                        {
                            if( mediaTrackerExtractor_spin.sCurrentValue == qsTr("ASSERT") )
                            {
                                LogSettingData.SaveLogSetting(0, EngineerData.Media_TrackerExtractor )
                            }

                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("LOW"))
                            {
                                LogSettingData.SaveLogSetting(1,EngineerData.Media_TrackerExtractor )

                            }

                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("TRACE"))
                            {
                                LogSettingData.SaveLogSetting(2,EngineerData.Media_TrackerExtractor )

                            }
                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("MEDIUM"))
                            {
                                LogSettingData.SaveLogSetting(3 ,EngineerData.Media_TrackerExtractor )
                            }

                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("INFO"))
                            {
                                LogSettingData.SaveLogSetting(4,EngineerData.Media_TrackerExtractor )
                            }
                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("HIGH")){

                                LogSettingData.SaveLogSetting(5 ,EngineerData.Media_TrackerExtractor )
                            }
                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("SIGNAL")){

                                LogSettingData.SaveLogSetting(6 ,EngineerData.Media_TrackerExtractor )
                            }
                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("SLOT")){

                                LogSettingData.SaveLogSetting(7 ,EngineerData.Media_TrackerExtractor )
                            }
                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("TRANSITION")){

                                LogSettingData.SaveLogSetting(8 ,EngineerData.Media_TrackerExtractor )
                            }

                            else if(mediaTrackerExtractor_spin.sCurrentValue == qsTr("CRITICAL")){

                                LogSettingData.SaveLogSetting(9 ,EngineerData.Media_TrackerExtractor )
                            }
                            else{

                                LogSettingData.SaveLogSetting(10 ,EngineerData.Media_TrackerExtractor )

                            }

                        }
                    }


                }
            }


            Image
            {
                id: linelist12
                source: imgFolderGeneral+"line_menu_list.png"
                x:19; width:1240
                //anchors.top: systemSW.bottom
            }

        }
    }


    ListView
    {
        id: listOflogSystem3
        anchors.fill: content_logsystemList3
        model: 1
        orientation: ListView.Vertical
        delegate: logsystem_list3
        clip: true
    }

}
