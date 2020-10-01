import QtQuick 1.1
import QmlHomeScreenDefPrivate 1.0
import AppEngineQMLConstants 1.0

Image {

    property bool isMainMenu: false
    property bool bCheckPopupPress: false
    property bool countryVariant: EngineListener.countryVariant

    function splitString (str) {
        var words = str.split(" ");

        var i = 0;
        iconItemText.text = "";
        iconItemText2.text = "";

        while (1) {
            iconItemText.text += words[i];

            if ((iconItemText.paintedWidth) > 210 && (i == 0)) {
                i++
                break
            }

            if (iconItemText.paintedWidth > iconItem.width) {
                iconItemText.text = "";
                for (var j = 0 ; j <= i-1 ; j ++) {
                    if ( j ==0 )
                        iconItemText.text += words[j];
                    else {
                        iconItemText.text += " ";
                        iconItemText.text += words[j];
                    }
                }
                break;
            }

            iconItemText.text += " "
            i++
        }

        while (i<words.length) {
            iconItemText2.text += words[i];
            i++;
            if (i < words.length ) iconItemText2.text += " "
        }
    }


    id: iconItem

    x: nXPos
    y: nYPos

    property string sSourceSuffix: "_n.png"
    property bool bFocused: iconsRepeater.bFocused && ( index == IconsModel.nFocusIndex )
    property bool bPressedByJog: iconItem.bFocused && ViewControll.bJogPressed
    property bool bPressed: false

    function itemClicked()
    {
        if ( nAppId == EHSDefP.APP_ID_CONNECTIVITY ) {

            if ( EngineListener.checkConnectedAAP() )
                ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_CONNECTIVITY_DISABLE );
            else
                ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_CONNECTIVITY_DISCONNECTED );
        }
        else if( bEnabled )
        {
            // CarPlay 통화 중일 경우,
            //===============>>>>>  AV Disable
            if ( EngineListener.checkCallStartCarPlay() ) {
                EngineListener.logForQML("nAppId:  " + nAppId + ", nViewId: " + nViewId );
                // able to be entered to Media
                if (/* ( nAppId == EHSDefP.APP_ID_INVALID  &&  nViewId ==  EHSDefP.VIEW_ID_MEDIA )
                    ||*/ nAppId == EHSDefP.APP_ID_RADIO
                    || nAppId == EHSDefP.APP_ID_SIRIUS_XM_FROM_HOME
                    || nAppId == EHSDefP.APP_ID_DMB ) {
                        ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_AV_CALL );
                        return;
                }
            }
            // AA VR 실행 중일 경우,
            // CarPlay Siri VR 실행 중일 경우,
            //===============>>>>>  AV Disable
            if ( EngineListener.checkVrStatusCarplaySiri() || EngineListener.checkVrStatusAA() ) {
                EngineListener.logForQML("nAppId:  " + nAppId + ", nViewId: " + nViewId );
                // able to be entered to Media
                if (/* ( nAppId == EHSDefP.APP_ID_INVALID  &&  nViewId ==  EHSDefP.VIEW_ID_MEDIA )
                    ||*/ nAppId == EHSDefP.APP_ID_RADIO
                    || nAppId == EHSDefP.APP_ID_SIRIUS_XM_FROM_HOME
                    || nAppId == EHSDefP.APP_ID_DMB ) {
                        ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_AV_VR );
                        return;
                }
            }

            // BL 통화중일 경우
            // ====>>> AAP/CP
            if ( EngineListener.checkCallStartBL() ) {
                if (  nAppId == EHSDefP.APP_ID_ANDROID_AUTO || nAppId == EHSDefP.APP_ID_CAR_PLAY  ) {
                    ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_CONNECTIVITY_BLCALL );
                    return;
                }
            }

            // BL 통화중 && CP 연결일 경우
            // ====>>> BT Disable
            if ( EngineListener.checkCallStartBLwhileCP() &&  nAppId == EHSDefP.APP_ID_BT_PHONE  ) {
                    ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_CONNECTIVITY_BLCALL );
                    return;
            }

            // BT 통화중 && CP 연결일 경우
            // ====>>> BT Disable
            if ( EngineListener.checkCallStartBTwhileCP() &&  nAppId == EHSDefP.APP_ID_BT_PHONE  ) {
                    ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_CONNECTIVITY_BTCALL );
                    return;
            }

            // BT 통화중 CarPlay Disable
            if ( EngineListener.checkCallStartBT() ) {
                if (  nAppId == EHSDefP.APP_ID_CAR_PLAY ) {
                    ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_CONNECTIVITY_BTCALL );
                    return;
                }
            }

            // BT 통화중 AA Disable
            if ( EngineListener.checkCallStartBTwhileAA() ) {
                if (  nAppId == EHSDefP.APP_ID_ANDROID_AUTO ) {
                    ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_CONNECTIVITY_BTCALL );
                    return;
                }
            }

            if ( nAppId == EHSDefP.APP_ID_ANDROID_AUTO ) {
                if ( !EngineListener.checkBtMaxAndroidAuto() )      // AAP의 경우 BT 연결 개수 확인
                    EngineListener.LaunchApplication( nAppId, nViewId, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , sText );
                else
                    ViewControll.ShowPopUp( nAppId, nViewId );
            }
            else
                EngineListener.LaunchApplication( nAppId, nViewId, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , sText );
        }
        else
        {
            ViewControll.ShowPopUp( nAppId, nViewId );
        }
    }

    source: sImage + iconItem.sSourceSuffix

    onStatusChanged: {
        if (status == Image.Error)
        {
            EngineListener.logForQML("Image.Error, [Main QML] file name = " + iconItem.source);
        }
    }

    Text {
        id: iconItemText

        text: qsTranslate( "main", sText ) + LocTrigger.empty

        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: EHSDefP.ICON_TEXT_DOUBLE_SECOND_VCM

        width: parent.width
        style: Text.Outline
        horizontalAlignment: Text.AlignHCenter
        font.family: EngineListener.getFont(false)
        font.pointSize: EHSDefP.ICON_TEXT_PIXEL_SIZE

        Component.onCompleted: {
            if (paintedWidth > iconItem.width) {
                splitString(iconItemText.text)
                iconItemText.anchors.verticalCenterOffset = EHSDefP.ICON_TEXT_DOUBLE_FIRST_VCM
                iconItemText2.visible = true
            } else {
                iconItemText.anchors.verticalCenterOffset = EHSDefP.ICON_TEXT_DOUBLE_SECOND_VCM
                iconItemText2.visible = false
            }
        }
    }

    Text {
        id: iconItemText2

        visible: false
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: EHSDefP.ICON_TEXT_DOUBLE_SECOND_VCM

        width: parent.width
        style: Text.Outline
        horizontalAlignment: Text.AlignHCenter
        font.family: EngineListener.getFont(false)
        font.pointSize: EHSDefP.ICON_TEXT_PIXEL_SIZE
    }

    MouseArea {
        id: iconItemMA
        anchors.fill: parent
        beepEnabled: false

        onPressed:  {
            //ViewControll.bFocusEnabled = false;

            if ( (mainMenuItems.opacity == 1)&& !goSubMenuAni.running && !goMainMenuAni.running)
            {
                iconItem.bPressed = true
                IconsModel.nFocusIndex = index;
                ViewControll.SetFocusIconIndex( View.nViewId, index )
            }
        }

        onExited: iconItem.bPressed = false

        onReleased:
        {
            if ((mainMenuItems.opacity == 1) && !goSubMenuAni.running && !goMainMenuAni.running && iconItem.bPressed )
            {
                EngineListener.playBeep()
                iconItem.bPressed = false
                iconItem.itemClicked()
            }

            iconItem.bPressed = false
        }

        /*
        onClicked: {
            if ((mainMenuItems.opacity == 1) && !goSubMenuAni.running && !goMainMenuAni.running)
            {
                iconItem.bPressed = false
                iconItem.itemClicked()
            }
        }
        */
    }

    states: [
        State {
            name: "NORMAL"
            when: ( !( iconItem.bPressedByJog || iconItem.bPressed ) && !iconItem.bFocused && bEnabled )
            PropertyChanges{ target: iconItemText; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_NORMAL ) }
            PropertyChanges{ target: iconItemText2; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_NORMAL ) }
            PropertyChanges{ target: iconItem; sSourceSuffix: "_n.png" }
        },

        State {
            name: "PRESSED"
            when: ( ( iconItem.bPressedByJog || iconItem.bPressed ) )
            PropertyChanges{ target: iconItemText; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_PRESSED ) }
            PropertyChanges{ target: iconItemText2; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_PRESSED ) }
            PropertyChanges{ target: iconItem; sSourceSuffix: "_p.png" }
        },

        State {
            name: "DISABLE_FOCUSED"
            when: ( !( iconItem.bPressedByJog || iconItem.bPressed ) && iconItem.bFocused && !bEnabled )
            PropertyChanges{ target: iconItemText; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_PRESSED ) }
            PropertyChanges{ target: iconItemText2; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_PRESSED ) }
            PropertyChanges{ target: iconItem; sSourceSuffix: "_f.png" }
        },

        State {
            name: "DISABLED"
            when: ( !bEnabled )
            PropertyChanges{ target: iconItemText; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_DISABLED ) }
            PropertyChanges{ target: iconItemText2; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_DISABLED ) }
            PropertyChanges{ target: iconItemText; font.bold: false }
            PropertyChanges{ target: iconItemText2; font.bold: false }
            PropertyChanges{ target: iconItem; sSourceSuffix: "_d.png" }
        },

        State {
            name: "FOCUSED"
            when: ( !( iconItem.bPressedByJog || iconItem.bPressed ) && iconItem.bFocused  )
            PropertyChanges{ target: iconItemText; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_PRESSED ) }
            PropertyChanges{ target: iconItemText2; color: InitData.GetColor( EHSDefP.ICON_TEXT_COLOR_PRESSED ) }
            PropertyChanges{ target: iconItem; sSourceSuffix: "_f.png" }
        }
    ]

    Connections {
        target: LocTrigger

        onRetrigger: {
            iconItemText.text = qsTranslate( "main", sText ) + LocTrigger.empty

            if (iconItemText.paintedWidth > iconItem.width) {
                splitString(iconItemText.text)
                iconItemText.anchors.verticalCenterOffset = EHSDefP.ICON_TEXT_DOUBLE_FIRST_VCM
                iconItemText2.visible = true
            } else {
                iconItemText.anchors.verticalCenterOffset = EHSDefP.ICON_TEXT_DOUBLE_SECOND_VCM
                iconItemText2.visible = false
            }

        }
    }

    /*
    Connections {
        target: EngineListener

        onGoSubMenu: {
            if ( screen != UIListener.getCurrentScreen() )
                return;

            iconItem.isMainMenu = false

            if (animation)
            {
                goMainMenuAni.running = false
                goSubMenuAni.running = true
            }

            else
            {
                iconItem.opacity = 0
            }
        }

        onGoMainMenu: {
            if ( screen != UIListener.getCurrentScreen() )
                return;

            if (animation)
            {
                goSubMenuAni.running = false
                goMainMenuAni.running = true
            }

            else
            {
                iconItem.opacity = 1
            }

            iconItem.isMainMenu = true
        }

        onReceiveBGEvent: {
            if(screen == UIListener.getCurrentScreen())
            {
                iconItem.isMainMenu = false
            }
        }

    }
    */

    /*
    ParallelAnimation {
        id: goSubMenuAni
        running: false

        PropertyAnimation { target: iconItem; property: "opacity"; from:1; to: 0; duration: 175/3 }
    }

    SequentialAnimation {
        id: goMainMenuAni
        running: false

        PropertyAnimation { target: iconItem; property: "opacity"; from:0; to: 0; duration: 175/3*2 }
        PropertyAnimation { target: iconItem; property: "opacity"; from:0; to: 1; duration: 175/3 }
    }
    */

    /*
    Connections {
        target: EngineListener

        onGoMainMenu: {
            if(screen == UIListener.getCurrentScreen())
            {
                iconItem.isMainMenu = true
            }
        }

        onReceiveBGEvent: {
            if(screen == UIListener.getCurrentScreen())
            {
                iconItem.isMainMenu = false
            }
        }
    }
    */

    Connections {
        target: UIListener

        onSignalJogNavigation: {

            if ( iconItem.bFocused && iconItem.opacity == 1)
            {
                if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                    bCheckPopupPress = true
                }

                else if( ( status == UIListenerEnum.KEY_STATUS_RELEASED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                    ViewControll.bJogPressed = false;

                    if ( (mainMenuItems.opacity == 1) && !goSubMenuAni.running && !goMainMenuAni.running)
                    {
                        if ( bCheckPopupPress ) iconItem.itemClicked()
                        bCheckPopupPress = false
                    }
                    return;
                }

                if( ( status == UIListenerEnum.KEY_STATUS_CANCELED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                    ViewControll.bJogPressed = false
                    bCheckPopupPress = false
                }
            }
        }
    }
}
