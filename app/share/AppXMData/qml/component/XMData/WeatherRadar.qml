import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./Menu" as MMenu

MComp.MComponent {
    id: idWeatherRadarMain
    focus: true;
    y: -(systemInfo.statusBarHeight)
    property bool statusBarFlag: true;

    onVisibleChanged: {
        if(visible == false)
        {
            idToggleFullScreen.stop();
            checkIsUserLocation();
        }
    }

    XMDataMap
    {
        id: idWeatherMap
        focus: true;

        onClickOrKeySelected: {
            if(zoomLevel == 1)
                openForRadar();
        }
    }

    //****************************** # Menu button #
    FocusScope{
        id: idMenuFocus
//        KeyNavigation.down: idZoomFocus
        visible: false;
        property bool show: false

        onVisibleChanged: {
            if(idShowTime.running)
                idShowTime.stop()
        }

        Timer{
            id: idShowTime
            interval: 500
            repeat: false
            running: false
            onTriggered: {
                idMenuFocus.visible = true;
            }
        }


        MComp.MButton{
            id: idMenuBtn
            x: 860+138; y: systemInfo.statusBarHeight
            width: 141; height: 72
            focus: true
            bgImage: imageInfo.imgFolderXMDataWeather+"btn_title_sub_n.png"
            bgImagePress: imageInfo.imgFolderXMDataWeather+"btn_title_sub_p.png"
            bgImageFocusPress: imageInfo.imgFolderXMDataWeather+"btn_title_sub_p.png"
            bgImageFocus: imageInfo.imgFolderXMDataWeather+"btn_title_sub_f.png"
            onClickOrKeySelected: {
                onOptionOnOff();
            }

            firstText: stringInfo.sSTR_XMDATA_MENU
            firstTextX: 9 + 10; //firstTextY: 37
            firstTextSize: 30
            firstTextStyle: systemInfo.font_NewHDB
            firstTextColor: colorInfo.brightGrey

            onWheelRightKeyPressed: {
                //[ITS 190379]
                idToggleFullScreen.restart();
                idBackBtn.forceActiveFocus();
            } //# End onWheelRightKeyPressed

            onActiveFocusChanged: {
                if(activeFocus == false)
                    var iiii = 0;
            }
        } //# End MButton(idMenuBtn)

        //****************************** # BackKey button #
        MComp.MButton{
            id: idBackBtn
            x: 860+138+138; y: systemInfo.statusBarHeight
            width: 141; height: 72
            bgImage: imageInfo.imgFolderXMDataWeather+"btn_title_back_n.png"
            bgImagePress: imageInfo.imgFolderXMDataWeather+"btn_title_back_p.png"
            bgImageFocusPress: imageInfo.imgFolderXMDataWeather+"btn_title_back_p.png"
            bgImageFocus: imageInfo.imgFolderXMDataWeather+"btn_title_back_f.png"

            onClickOrKeySelected: {
                gotoBackScreen(false);
            }

            onPressAndHold: {
                idMenuBar.printAllItems(idMenuBar.parent)
            }

            onWheelLeftKeyPressed: {
                //[ITS 190379]
                idToggleFullScreen.restart();
                idMenuBtn.forceActiveFocus();
            } //# End onWheelLeftkeyPressed
        } //# End MButton(idBackBtn)
    }

    Loader{id:idOptionMenu; z: parent.z+1}
    Component{
        id:idOptionMenuForRadar

        MMenu.WeatherRadarOptionMenuForType
        {
            y: systemInfo.statusBarHeight//bFullMode? systemInfo.statusBarHeight : 0
            z: parent.z+1
            tileSupport: idWeatherMap.tileSupport
            onMenuHided: {
                statusBarFlag = true;
                openForRadar();
            }

            onOptionMenuForFullScreen:
            {
                openForRadar();
                focus = false;
                idWeatherMap.forceActiveFocus();
            }

            onOptionMenuForFront: {
                remoteSelectForUpdate(3);
            }
            onOptionMenuForIsobar: {
                remoteSelectForUpdate(4);
            }
            onOptinoMenuForPressureCenter: {
                remoteSelectForUpdate(5);
            }
    //        onOptionMenuForStormAttributes: {
    //            remoteSelectForUpdate(6);
    //        }
    //        onOptionMenuForStormPosition: {
    //            remoteSelectForUpdate(7);
    //        }
    //        onOptionMenuForWindRadiiField: {  // no use
    //            remoteSelectForUpdate(8);
    //        }
            onOptionMenuForNowRad: {
                remoteSelectForUpdate(0);
            }
        }
    }

    FocusScope{
        id: idZoomFocus

        Image {
            id: idZoomBtnBG
            x: 5; y: 280
            width: 115; height: 259;
            source: imageInfo.imgFolderXMDataWeather+"bg_zoom.png";

            MComp.MButton{
                id: idZoomInBtn
                x: 0; y: 0
                width: 115; height: 93
                visible: true
                focus: true
                bgImage: imageInfo.imgFolderXMDataWeather+"btn_zoom_n.png"
                bgImagePress: enabled ? imageInfo.imgFolderXMDataWeather+"btn_zoom_p.png" : imageInfo.imgFolderXMDataWeather+"btn_zoom_d.png"
                bgImageFocus: enabled ? imageInfo.imgFolderXMDataWeather+"btn_zoom_f.png" : imageInfo.imgFolderXMDataWeather+"btn_zoom_d.png"
                bgImageFocusPress: enabled ? imageInfo.imgFolderXMDataWeather+"btn_zoom_p.png" : imageInfo.imgFolderXMDataWeather+"btn_zoom_d.png"

                fgImageX: (width/2) - (fgImageWidth/2)
                fgImageY: (height/2) - (fgImageHeight/2)
                fgImageWidth: 89
                fgImageHeight: 73
                fgImageVisible: true;
                fgImage: imageInfo.imgFolderXMDataWeather+"icon_zoom_in_n.png"

                enabled: idWeatherMap.zoomLevel < 8

                onEnabledChanged: {
                    if(enabled == false && focus)
                        idZoomOutBtn.focus = true;
                }

                onClickOrKeySelected: {
                    if(!statusBarFlag)
                        openForRadar();

                    idWeatherMap.mapCoordinate(idWeatherMap.zoomLevel == 8 ? 8 : idWeatherMap.zoomLevel*2);
                    idWeatherMap.agwCoordinateForUpdate();
                }
                onWheelLeftKeyPressed: {
                    if(idZoomOutBtn.enabled)
                        idZoomOutBtn.forceActiveFocus();
                } //# End onWheelLeftkeyPressed
                onWheelRightKeyPressed: {
                    if(idZoomOutBtn.enabled)
                        idZoomOutBtn.forceActiveFocus();
                } //# End onWheelRightKeyPressed

            }//# End MButton(idZoomInBtn)

            Item {
                id: idDispZoomLev
                x: 5; y: 97
                width: 115; height: 93
                visible: true

                Text {
                    id: idDispZoomLevTxt
                    x: 24; y: 0
                    text: idWeatherMap.zoomLevel + "X"
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 40
                    color: colorInfo.brightGrey
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MComp.MButton{
                id: idZoomOutBtn
                x: 0; y: 166
                width: 115; height: 93
                visible: true
                bgImage: imageInfo.imgFolderXMDataWeather+"btn_zoom_n.png"
                bgImagePress: enabled ? imageInfo.imgFolderXMDataWeather+"btn_zoom_p.png" : imageInfo.imgFolderXMDataWeather+"btn_zoom_d.png"
                bgImageFocus: enabled ? imageInfo.imgFolderXMDataWeather+"btn_zoom_f.png" : imageInfo.imgFolderXMDataWeather+"btn_zoom_d.png"
                bgImageFocusPress: enabled ? imageInfo.imgFolderXMDataWeather+"btn_zoom_p.png" : imageInfo.imgFolderXMDataWeather+"btn_zoom_d.png"

                fgImageX: (width/2) - (fgImageWidth/2)
                fgImageY: (height/2) - (fgImageHeight/2)
                fgImageWidth: 89
                fgImageHeight: 73
                fgImageVisible: true;
                fgImage: imageInfo.imgFolderXMDataWeather+"icon_zoom_out_n.png"

                enabled: idWeatherMap.zoomLevel > 1

                onEnabledChanged: {
                    if(enabled == false && focus)
                        idZoomInBtn.focus = true;
                }

                onClickOrKeySelected: {
                    if(!statusBarFlag)
                        openForRadar();

                    idWeatherMap.mapCoordinate(idWeatherMap.zoomLevel == 1 ? 1 : idWeatherMap.zoomLevel/2)
                    idWeatherMap.agwCoordinateForUpdate();
                }
                onWheelLeftKeyPressed: {
                    if(idZoomInBtn.enabled)
                        idZoomInBtn.forceActiveFocus();
                } //# End onWheelLeftkeyPressed
                onWheelRightKeyPressed: {
                    if(idZoomInBtn.enabled)
                        idZoomInBtn.forceActiveFocus();
                } //# End onWheelRightKeyPressed

            }//# End MButton(idZoomOutBtn)
        }
    }

    function onMenu()
    {
        if(statusBarFlag)
            openForRadarForOptionMenu();

        idOptionMenu.sourceComponent = idOptionMenuForRadar;
        idOptionMenu.item.showMenu();
        idWeatherMap.focus = false;
        idOptionMenu.focus = true;
        idToggleFullScreen.stop();
    }

    function openForRadar()
    {
        if(statusBarFlag)
        {
            idAppMain.isFullScreen = 2;
            idWeatherMap.focus = false;
            idMenuFocus.visible = true;
            idMenuFocus.focus = true;
            idMenuBtn.focus = true;
            idMenuFocus.forceActiveFocus();
            statusBarFlag = false;
            idToggleFullScreen.restart();
        }
        else
        {
            if(idWeatherRadarMain.visible == true){
                idAppMain.isFullScreen = 3;
                idWeatherMap.focus = true;
                idWeatherMap.forceActiveFocus();
                statusBarFlag = true;
            }
            idMenuFocus.visible = false;
            idMenuFocus.focus = false;
            idToggleFullScreen.stop();
        }
    }

    function openForRadarForOptionMenu()
    {
        if(statusBarFlag)
        {
            idAppMain.isFullScreen = 2;
            idWeatherMap.focus = false;
            idShowTime.start();
            statusBarFlag = false;
            idToggleFullScreen.restart();
        }
    }


    Timer{
        id: idToggleFullScreen
        repeat: false
        interval: 5000
        onTriggered: {
            openForRadar();
        }

    }

    Connections {
        target: weatherAGWDataManager
        onUpdateAllAGWData: {
            console.log("===================================start update agw data!!!")
            idWeatherMap.agwCoordinateForUpdate();
        }
    }
}
