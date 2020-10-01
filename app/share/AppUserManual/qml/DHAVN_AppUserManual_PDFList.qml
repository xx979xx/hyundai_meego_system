import Qt 4.7
import AppEngineQMLConstants 1.0

import "DHAVN_AppUserManual_Dimensions.js" as Dimensions
import "DHAVN_AppUserManual_Images.js" as Images

Item
{
    id: appUserManualPDFList

    z: Dimensions.const_AppUserManual_Z_1

    width: Dimensions.const_AppUserManual_MainScreenWidth
    height: Dimensions.const_AppUserManual_MainScreenHeight

    function activateMenuPane( activeView )
    {
        console.log("PDFList.qml ::  activateMenuPane() activeView : ", activeView)
        if( activeView )
        {
            if( !menuLS.visible || appUserManual.focusIndex == Dimensions.const_AppUserManual_ModeArea_FocusIndex )
            {
                console.log("PDFList.qml ::  activateMenuPane() activeView  - !menuLS.visible ")
                menuLS.visible = true
                menuRS.visible = false
                appUserManual.setFocus( true )
            }
        }
        else
        {
            if( !menuRS.visible )
            {
                menuRS.visible = true
                menuLS.visible = false
                appUserManual.setFocus( false )
            }
        }
    }

    function setChapterListPane()
    {
        console.log("PDFList.qml ::  setChapterListPane() ")
        menuRS.visible = true
        menuLS.visible = false
    }

    function getActivePane()
    {
        console.log("PDFList.qml ::  getActivePane() ")
        if( menuLS.visible )
            return Dimensions.const_AppUserManual_LeftMenu_Pane
        else if( menuRS.visible )
            return Dimensions.const_AppUserManual_RightMenu_Pane
    }

    function resetVisualCue()
    {
        console.log("PDFList.qml ::  resetVisualCue() ")
        visualCue.x = Dimensions.const_AppUserManual_Cue_X
        visualCue.y = Dimensions.const_AppUserManual_Cue_Y
        topCue.source = Images.const_AppUserManual_Cue_U_N
        bottomCue.source = Images.const_AppUserManual_Cue_D_D
        if ( appUserManual.langId == 20 ) { //countryVariant == 4 ) {
            rightCue.source = Images.const_AppUserManual_Cue_R_D
            leftCue.source = Images.const_AppUserManual_Cue_L_N
        }
        else {
            rightCue.source = Images.const_AppUserManual_Cue_R_N
            leftCue.source = Images.const_AppUserManual_Cue_L_D
        }
    }

    function setOpionMenuVisible( visible )
    {
        console.log("PDFList.qml ::  setOpionMenuVisible() - visible : ", visible )
        if ( visible ) {
            rightCue.source = Images.const_AppUserManual_Cue_R_D
            leftCue.source = Images.const_AppUserManual_Cue_L_D
            topCue.source = Images.const_AppUserManual_Cue_U_D
            bottomCue.source = Images.const_AppUserManual_Cue_D_D
        }
        else {
            if ( appUserManual.langId == 20 ) {
                if ( focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex ) {
                    leftCue.source = Images.const_AppUserManual_Cue_L_N
                    topCue.source = Images.const_AppUserManual_Cue_U_N
                }
                else if ( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex ){
                    rightCue.source = Images.const_AppUserManual_Cue_R_N
                    topCue.source = Images.const_AppUserManual_Cue_U_N
                }
                else {
                    bottomCue.source = Images.const_AppUserManual_Cue_D_N
                }
            }
            else {
                if ( focusIndex == Dimensions.const_AppUserManual_TitleList_FocusIndex ) {
                    rightCue.source = Images.const_AppUserManual_Cue_R_N
                    topCue.source = Images.const_AppUserManual_Cue_U_N
                }
                else if ( focusIndex == Dimensions.const_AppUserManual_PageNumList_FocusIndex ){
                    leftCue.source = Images.const_AppUserManual_Cue_L_N
                    topCue.source = Images.const_AppUserManual_Cue_U_N
                }
                else {
                    bottomCue.source = Images.const_AppUserManual_Cue_D_N
                }
            }
        }
    }

    function updownSetVisualCue(  up , press , focusChange )
    {
        console.log("PDFList.qml ::  updownSetVisualCue() up : ", up, " , press : ",  press )
        switch ( up )
        {
            case true:
            {
                if ( press ) {
                    visualCue.y = Dimensions.const_AppUserManual_Cue_Y - 3
                    topCue.source = Images.const_AppUserManual_Cue_U_S
                }
                else  {
                    visualCue.y = Dimensions.const_AppUserManual_Cue_Y
                    if ( focusChange ) {
                        topCue.source = Images.const_AppUserManual_Cue_U_D
                        bottomCue.source = Images.const_AppUserManual_Cue_D_N
                        rightCue.source = Images.const_AppUserManual_Cue_R_D
                        leftCue.source = Images.const_AppUserManual_Cue_L_D
                    }
                    else {
                        topCue.source = Images.const_AppUserManual_Cue_U_N
                    }
                }
            }
            break;
            case false:
            {
                if ( press ) {
                    visualCue.y = Dimensions.const_AppUserManual_Cue_Y + 3
                    bottomCue.source = Images.const_AppUserManual_Cue_D_S
                }
                else  {
                    visualCue.y = Dimensions.const_AppUserManual_Cue_Y
                    bottomCue.source = Images.const_AppUserManual_Cue_D_D
                    topCue.source = Images.const_AppUserManual_Cue_U_N
                    if ( menuLS.visible )
                    {
                        rightCue.source = appUserManual.langId == 20 ? Images.const_AppUserManual_Cue_R_D :  Images.const_AppUserManual_Cue_R_N
                        leftCue.source = appUserManual.langId == 20 ?  Images.const_AppUserManual_Cue_L_N :  Images.const_AppUserManual_Cue_L_D
                    }
                    else
                    {
                        rightCue.source = appUserManual.langId == 20 ? Images.const_AppUserManual_Cue_R_N :  Images.const_AppUserManual_Cue_R_D
                        leftCue.source = appUserManual.langId == 20 ?  Images.const_AppUserManual_Cue_L_D :  Images.const_AppUserManual_Cue_L_N
                    }
                }
            }
            break;
        }
    }

    function setVisualCue( left, press )
    {
        console.log("PDFList.qml ::  setVisualCue()  left: ", left, ", press : ", press )
        switch ( left )
        {
            case true:
            {
                if( press )
                {
                    leftCue.source = Images.const_AppUserManual_Cue_L_S
                    visualCue.x = Dimensions.const_AppUserManual_Cue_X - 3
                }
                else
                {
                    leftCue.source = Images.const_AppUserManual_Cue_L_D
                    rightCue.source = Images.const_AppUserManual_Cue_R_N
                    visualCue.x = Dimensions.const_AppUserManual_Cue_X
                }
            }
            break;
            case false:
            {
                if ( press )
                {
                    rightCue.source = Images.const_AppUserManual_Cue_R_S
                    visualCue.x = Dimensions.const_AppUserManual_Cue_X + 3
                }
                else
                {
                    rightCue.source = Images.const_AppUserManual_Cue_R_D
                    leftCue.source = Images.const_AppUserManual_Cue_L_N
                    visualCue.x = Dimensions.const_AppUserManual_Cue_X
                }
            }
        }
        bottomCue.source = Images.const_AppUserManual_Cue_D_D
        topCue.source = Images.const_AppUserManual_Cue_U_N
    }


    Image
    {
            id: menuLS
            smooth: true
            source: appUserManual.langId == 20 ? Images.const_AppUserManual_BG_Menu_LS_ME :  Images.const_AppUserManual_BG_Menu_LS
            x: appUserManual.langId == 20 ? 618 : 0
            visible: true
    }

    Image
    {
            id: menuRS
            smooth: true
            source: appUserManual.langId == 20 ? Images.const_AppUserManual_BG_Menu_RS_ME : Images.const_AppUserManual_BG_Menu_RS
            x: appUserManual.langId == 20 ? 0: 589
            visible: false
    }

    Image
    {
            id: visualCue
            x: Dimensions.const_AppUserManual_Cue_X
            y: Dimensions.const_AppUserManual_Cue_Y
            z: Dimensions.const_AppUserManual_Z_2
            smooth: true
            source: "/app/share/images/AppSettings/general/menu_visual_cue_bg.png" //Images.const_AppUserManual_Cue

            Image
            {
                    id: rightCue
                    anchors.left: parent.left
                    anchors.leftMargin: Dimensions.const_AppUserManual_Cue_Right_Margin_X
                    anchors.top: parent.top
                    anchors.topMargin: Dimensions.const_AppUserManual_Cue_LeftRight_Margin_Y
                    smooth: true
                    source:  appUserManual.langId == 20 ?  Images.const_AppUserManual_Cue_R_D :  appUserManual.optionMenu.visible ? Images.const_AppUserManual_Cue_R_D : Images.const_AppUserManual_Cue_R_N
                    z: Dimensions.const_AppUserManual_Z_2
            }

            Image
            {
                    id: leftCue
                    anchors.left: parent.left
                    anchors.leftMargin: Dimensions.const_AppUserManual_Cue_Left_Margin_X
                    anchors.top: parent.top
                    anchors.topMargin: Dimensions.const_AppUserManual_Cue_LeftRight_Margin_Y
                    smooth: true
                    source: appUserManual.langId == 20 ? Images.const_AppUserManual_Cue_L_N : Images.const_AppUserManual_Cue_L_D
                    z: Dimensions.const_AppUserManual_Z_2
            }

            Image
            {
                    id: topCue
                    anchors.left: parent.left
                    anchors.leftMargin: Dimensions.const_AppUserManual_Cue_TopBottom_Margin_X
                    anchors.top: parent.top
                    anchors.topMargin: Dimensions.const_AppUserManual_Cue_Top_Margin_Y
                    smooth: true
                    source:  Images.const_AppUserManual_Cue_U_N
                    z: Dimensions.const_AppUserManual_Z_2
            }

            Image
            {
                    id: bottomCue
                    anchors.left: parent.left
                    anchors.leftMargin: Dimensions.const_AppUserManual_Cue_TopBottom_Margin_X
                    anchors.top: parent.top
                    anchors.topMargin: Dimensions.const_AppUserManual_Cue_Bottom_Margin_Y
                    smooth: true
                    source:  Images.const_AppUserManual_Cue_D_D
                    z: Dimensions.const_AppUserManual_Z_2
            }
    }

    Component.onCompleted:
    {
    }
}
