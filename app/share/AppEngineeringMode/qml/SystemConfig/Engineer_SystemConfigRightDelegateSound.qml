import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
//FocusScope {

MComp.MButton {
    id: idRightSysConSoundDelegate
    width: 537
    height:89

    // property int checkActive
    property int sdvValue : UIListener.LoadSystemConfig(EngineerData.DB_SDVC)
    property int bassValue : UIListener.LoadSystemConfig(EngineerData.DB_POWER_BASS)



    Component.onCompleted:{
        console.log("@@@@@@@@@@@@@@@@@@@ :"+ sdvValue);
        if(index == 0){

            if(sdvValue == 0){

                idRightSysConSoundDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
            else/* if (sdvValue == 1)*/{

                idRightSysConSoundDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }



        }
        else if(index == 1){

            if(bassValue == 0){

                idRightSysConSoundDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
            else if (bassValue == 1){
                idRightSysConSoundDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
        }



    }


    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    //bgImagePress: imgFolderGeneral+"bg_menu_tab_l_p.png"
    //bgImageActive: imgFolderGeneral+"bg_menu_tab_l_s.png"
     bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
    bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"


    //        fgImage :"/app/share/images/general/plan_b/ico_check_n.png";
    //        fgImageActive :"/app/share/images/general/plan_b/ico_check_s.png";
    fgImage: ""
    fgImageActive: ""
    fgImageX: 400
    fgImageY: 25
    fgImageWidth:45
    fgImageHeight:45
    //focus:true


    //    bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
    //    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"
    // playBeepOn: false
    //. active: index==selectedItem
    firstText : name
    firstTextX: 20
    firstTextY: 43
    firstTextColor: colorInfo.brightGrey
    firstTextSelectedColor: colorInfo.brightGrey
    firstTextSize: 25
    // firstTextColor: colorInfo.brightGrey
    // firstTextSize: 32
    firstTextStyle:"HDB"
    firstTextWidth: 260
    //active: a1 == 1

    // firstTextStyle: "HDB"
    // secondText: ""
    secondTextX: 280
    secondTextY: 43
    secondTextSize:20
    secondTextColor: "#447CAD"
    //secondTextSelectedColor: colorInfo.dimmedGrey
    secondTextStyle: "HDB"
    secondTextWidth: 403
    KeyNavigation.up:{
//        if(index == 0){
//            softwareBand.forceActiveFocus()
            backFocus.forceActiveFocus()
            systemConfigBand
//        }
    }
    //    KeyNavigation.down:idKernel
    //    KeyNavigation.up:

    //    firstTextX : 9+23
    //    firstTextY : 89-43-5


    onClickOrKeySelected: {

        if(index == 0){

            //case False -> True
            if(sdvValue == 0){
                sdvValue = 4
                UIListener.SaveSystemConfig(1 ,EngineerData.DB_SDVC)
                idRightSysConSoundDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
           /* else if (sdvValue == 1)*/else{
                sdvValue =0
                UIListener.SaveSystemConfig(0 ,EngineerData.DB_SDVC)
                idRightSysConSoundDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }


        }
        if(index == 1){
            //case False -> True
            if(bassValue == 0){
                bassValue = 1
                UIListener.SaveSystemConfig(1,EngineerData.DB_POWER_BASS)
                idRightSysConSoundDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (bassValue == 1){
                bassValue =0
                UIListener.SaveSystemConfig(0,EngineerData.DB_POWER_BASS)
                idRightSysConSoundDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
        idRightSysConSoundDelegate.ListView.view.currentIndex=index
        idRightSysConSoundDelegate.forceActiveFocus()



    }




    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

