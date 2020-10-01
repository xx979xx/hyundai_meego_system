import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
//FocusScope {

MComp.MButton {
    id: idRightSysConSysDelegate
    width: 537
    height:89

    // property int checkActive
    property int memValue : UIListener.LoadSystemConfig(EngineerData.DB_MEMORY_WINDOW)
    property int drivingValue : UIListener.LoadSystemConfig(EngineerData.DB_DRIVING_RESTRICTION)
    //property int amosValue :UIListener.LoadSystemConfig(EngineerData.DB_AMOS)
    property int cameraValue : 1/*UIListener.LoadSystemConfig(EngineerData.DB_REAR_CAMERA_SIGNAL)*/
    property int parkingValue :UIListener.LoadSystemConfig(EngineerData.DB_PARKING_GUIDLINE)
    property int batteryValue :UIListener.LoadSystemConfig(EngineerData.DB_BATTERY_WARNING)


    Component.onCompleted:{

        //memory
        if(index == 0){
            //            console.log("Received memory Value1 :"+ memValue);

            //            UIListener.SaveSystemConfig(1 ,EngineerData.DB_MEMORY_WINDOW)

            //             console.log("Received memory Value 2:"+ memValue);
            if(memValue == 0){

                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
            else if (memValue == 1){
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }



        }    //driving
        /*else if(index == 1){
            console.log("Received driving Value :"+ drivingValue);
            if(drivingValue == 0){

                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
            else if (drivingValue == 1){
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
        }*/        //amos
        /*else if(index == 2){
            console.log("Received amosValue :"+ amosValue);
            if(amosValue == 0){

                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
            else if (amosValue == 1){
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
        }    */    //camera
        else if(index == 1){
            console.log("Received cameraValue:"+ cameraValue);
            if(cameraValue == 0){

                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
            else if (cameraValue == 1){
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
        }        //parking
        else if(index == 2){
            console.log("Received parkingValue :"+ parkingValue);
            if(parkingValue == 0){

                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
            else if (parkingValue == 1){
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
        }        //battery
        else if(index == 3){
            console.log("Received batteryValue :"+ batteryValue);
            if(batteryValue == 0){

                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
            else if (batteryValue == 1){
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
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
            if(memValue == 0){
                memValue = 1
                UIListener.SaveSystemConfig(1 ,EngineerData.DB_MEMORY_WINDOW)
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (memValue == 1){
                memValue =0
                UIListener.SaveSystemConfig(0 ,EngineerData.DB_MEMORY_WINDOW)
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }

        }
//        if(index == 1){
//            //case False -> True
//            if(drivingValue == 0){
//                drivingValue = 1
//                UIListener.SaveSystemConfig(1 ,EngineerData.DB_DRIVING_RESTRICTION)
//                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
//            }
//            //case True->False
//            else if (drivingValue == 1){
//                drivingValue =0
//                UIListener.SaveSystemConfig(0 ,EngineerData.DB_DRIVING_RESTRICTION)
//                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
//            }
//        }
//        if(index == 2){
//            //case False -> True
//            if(amosValue == 0){
//                amosValue = 1
//                UIListener.SaveSystemConfig(1 ,EngineerData.DB_AMOS)
//                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
//                UIListener.executeAMOS();
//            }
//            //case True->False
//            else if (amosValue == 1){
//                amosValue =0
//                UIListener.SaveSystemConfig(0 ,EngineerData.DB_AMOS)
//                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
//            }
//        }
        if(index == 1){
            //case False -> True
            if(cameraValue == 0){
                cameraValue = 1
                reqVersion.sendRearCameraSignalOnOff(0)
                UIListener.SaveSystemConfig(1 ,EngineerData.DB_REAR_CAMERA_SIGNAL)
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (cameraValue == 1){
                cameraValue = 0
                reqVersion.sendRearCameraSignalOnOff(1)
                UIListener.SaveSystemConfig(0 ,EngineerData.DB_REAR_CAMERA_SIGNAL)
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
        if(index == 2){
            //case False -> True
            if(parkingValue == 0){
                parkingValue = 1
                UIListener.SaveSystemConfig(1 ,EngineerData.DB_PARKING_GUIDLINE)
                reqVersion.sendParkGuideLineOnOff(1)

                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (parkingValue == 1){
                parkingValue =0
                UIListener.SaveSystemConfig(0 ,EngineerData.DB_PARKING_GUIDLINE)
                reqVersion.sendParkGuideLineOnOff(0)
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
        if(index == 3){
            //case False -> True
            if(batteryValue == 0){
                batteryValue = 1
                UIListener.SaveSystemConfig(1,EngineerData.DB_BATTERY_WARNING)
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (batteryValue == 1){
                batteryValue =0
                UIListener.SaveSystemConfig(0,EngineerData.DB_BATTERY_WARNING)
                idRightSysConSysDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
        idRightSysConSysDelegate.ListView.view.currentIndex=index
        idRightSysConSysDelegate.forceActiveFocus()


    }


    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

