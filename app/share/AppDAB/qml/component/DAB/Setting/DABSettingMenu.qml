/**
 * FileName: DABSettingMenu.qml
 * Author: HYANG
 * Time: 2013-01-15
 *
 * - 2013-01-15 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent {
    id : idDabSettingsMenu

    property int        selectedIndex                   : 0
    property bool       checkSlideShowActive            : false
    property bool       checkServiceFollowingActive     : false
    property int        m_iServiceFollowing             : DABListener.m_iServiceFollowing
    property string     inputMode                       : idAppMain.inputMode

    Component.onCompleted: {
        console.log("[QML] DABSettingMenu.qml :  Component.onCompleted")
        stringNameSetting();
        settingInitailize();
    }

    ListModel {
        id : idSettingMenuModel
    }

    MComp.MListView {
        id: idSettingMenuList
        x: 34; y: 6 ;
        width : 547
        height : 89 * 6
        focus : true
        clip: true;
        //boundsBehavior : Flickable.StopAtBounds  //Flickable.DragAndOvershootBounds
        model : idSettingMenuModel
        delegate : idSettingMenuDelegateComponent
        highlightMoveSpeed : 9999999
        onUpKeyLongRunning: {
            screenChangedListMove()
        }
        onDownKeyLongRunning: {
            screenChangedListMove()
        }

        onMovementEnded: {
            idDabSettingBand.focus = false;
            idDabSettingContents.focus = false;
            idDabSettingsMenu.focus = true;
        }
    }   

    //#****************************** List Delegate
    Component{
        id : idSettingMenuDelegateComponent
        MComp.MButton {
            id : idSettingMenuDelegate
            width : 547
            height : 89
            bgImagePress : imageInfo.imgBgMenu_Tab_L_P
            bgImageFocus : imageInfo.imgBgMenu_Tab_L_F

            active : (index == selectedIndex)? true : false
            firstText : name
            firstTextX : 23
            firstTextY : 47
            firstTextWidth :  (index == 0 || index == 1) ? 435 : 479
            firstTextSize : 40
            firstTextStyle : ((index == selectedIndex) && (idSettingMenuDelegate.activeFocus == false)) ? idAppMain.fonts_HDB : idAppMain.fonts_HDR; //(index == selectedIndex)? focusImageVisible? idAppMain.fonts_HDR : idAppMain.fonts_HDB : idAppMain.fonts_HDR
            firstTextAlies: "Left"
            firstTextColor : colorInfo.brightGrey
            firstTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF" //# RGB(124, 189, 255)
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusColor: colorInfo.brightGrey
            firstTextScrollEnable: (m_bIsDrivingRegulation == false) && (idSettingMenuDelegate.activeFocus) ? true : false     
            lineImage: imageInfo.imgLineMenuList
            lineImageX: 9
            lineImageY: 90

            onClickOrKeySelected : {
                idSettingMenuList.currentIndex = index
                idDabSettingsMenu.focus = true
                idSettingMenuList.focus = true
                idSettingMenuDelegate.focus = true

                if(index == 0)
                {
                    if(checkSlideShowActive == false)
                    {
                        console.log("Slide Show Check is On");
                        idSettingMenuList.model.get(0).isChecked = "on"
                        checkSlideShowActive = true;
                        MDabOperation.CmdSettingSlideShow(true);
                    }
                    else
                    {
                        console.log("Slide Show Check is Off");
                        idSettingMenuList.model.get(0).isChecked = "off"
                        checkSlideShowActive = false;
                        MDabOperation.CmdSettingSlideShow(false)
                    }
                    MDabOperation.setSettingScreenChanges("DabSetting_SlideShow");
                }
                else if(index == 1)
                {
                    if(checkServiceFollowingActive == false)
                    {
                        console.log("Service Following is On");
                        idSettingMenuList.model.get(1).isChecked = "on"
                        checkServiceFollowingActive = true;
                        selectServiceFollowing(3);
                    }
                    else
                    {
                        console.log("Service Following is Off");
                        idSettingMenuList.model.get(1).isChecked = "off"
                        checkServiceFollowingActive = false;
                        selectServiceFollowing(0);
                    }
                    MDabOperation.setSettingScreenChanges("DabSetting_ServiceFollowing");
                }
                selectedIndex = index;
            }             

            Image {
                id : idUnchecked
                x : 478
                y : 22
                source : imageInfo.imgIcoCheck_N
                visible : (index == 0 || index == 1) ? true : false
            }

            Image {
                id : idChecked
                anchors.fill : idUnchecked
                source : imageInfo.imgIcoCheck_S
                visible : (idSettingMenuList.model.get(index).isChecked == "on") ? true : false
            }

            onWheelLeftKeyPressed:{
                console.log("[QML] DABSettingMenu.qml : onWheelLeftKeyPressed : currentIndex = " + idSettingMenuDelegate.ListView.view.currentIndex + " count = " + idSettingMenuDelegate.ListView.view.count);
                if( idSettingMenuDelegate.ListView.view.currentIndex )
                {
                    idSettingMenuDelegate.ListView.view.decrementCurrentIndex();
                }

                //#****************************** Changed right screen when listItem moved
                screenChangedListMove()
            }

            onWheelRightKeyPressed: {
                console.log("[QML] DABSettingMenu.qml : onWheelRightKeyPressed : currentIndex = " + idSettingMenuDelegate.ListView.view.currentIndex + "  count = " + idSettingMenuDelegate.ListView.view.count);
                if( idSettingMenuDelegate.ListView.view.count-1 != idSettingMenuDelegate.ListView.view.currentIndex)
                {
                    idSettingMenuDelegate.ListView.view.incrementCurrentIndex();
                }

                //#****************************** Changed right screen when listItem moved
                screenChangedListMove()
            }

            //#****************************** Focus move to band when upkey pressed
            Keys.onUpPressed: { // Set focus for Band
                event.accepted = true;
                return;
            } // End onUpPressed
            Keys.onDownPressed:{ // No Movement
                event.accepted = true;
                return;
            } // End onDownPressed

            onUpKeyReleased: {
                if(idAppMain.upKeyReleased == true){
                    idDabSettingBand.focus = true
                }
                idAppMain.upKeyReleased  = false;
            }
        }
    }

    onVisibleChanged: {
        if(idDabSettingsMenu.visible){
            idDabSettingsMenu.focus = true;
            idDabSettingsMenu.selectedIndex = 0
            idSettingMenuList.currentIndex = 0
            MDabOperation.setSettingScreenChanges("DabSetting_SlideShow")
        }
    }

    //******************************# Connections
    Connections {
        target: UIListener
        onRetranslateUi:
        {
            console.log("[QML] DABSettingMenu.qml : onRetranslateUi");
            stringNameSetting();
            settingInitailize();
        }
    }

    // mseok.lee
    Connections {
        target : AppComUIListener
        onRetranslateUi: {
            console.log("[QML] DABSettingMenu.qml : AppComUIListener::onRetranslateUi");
            stringNameSetting();
            settingInitailize();
        }
    }

    //#****************************** Changed right screen when listItem moved
    function screenChangedListMove(){
        selectedIndex = idSettingMenuList.currentIndex
        if(idSettingMenuList.currentIndex == 0) MDabOperation.setSettingScreenChanges("DabSetting_SlideShow");
        else if(idSettingMenuList.currentIndex == 1) MDabOperation.setSettingScreenChanges("DabSetting_ServiceFollowing");
    }
    //******************************# Funciton        
    function selectServiceFollowing(value)
    {
        console.log("[QML] DABSettingMenu.qml : selectServiceFollowing() : value = " + value + " m_iServiceFollowing = " + m_iServiceFollowing);
        m_iServiceFollowing = value;
        MDabOperation.CmdSettingServiceFollowing(value);
    }

    function stringNameSetting()
    {
        var data1 = {"name" : stringInfo.strSetting_SlideShow, "isChecked":"Off"};
        var data2 = {"name" : stringInfo.strSetting_ServiceFollowing, "isChecked":"Off"};

        idSettingMenuModel.clear();
        idSettingMenuModel.append(data1);
        idSettingMenuModel.append(data2);
    }

    function settingInitailize()
    {
        console.log("[QML] DABSettingMenu.qml :  settingInitailize : m_bSLSOn = " + m_bSLSOn + "  m_iServiceFollowing = " + m_iServiceFollowing);

        if(m_bSLSOn == true)
        {
            checkSlideShowActive = true;
            idSettingMenuList.model.get(0).isChecked = "on"
        }
        else
        {
            checkSlideShowActive = false;
            idSettingMenuList.model.get(0).isChecked = "off"
        }

        if(m_iServiceFollowing == 3)
        {
            idSettingMenuList.model.get(1).isChecked = "on"
            checkServiceFollowingActive = true;
        }
        else
        {
            idSettingMenuList.model.get(1).isChecked = "off"
            checkServiceFollowingActive = false;
        }
    }
}
