import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
//FocusScope {

MComp.MButton {
    id: idRightRecepDelegate
    width: 537
    height:89
    property int amosValue : 0/*UIListener.LoadSystemConfig(EngineerData.DB_AMOS)*/

    Component.onCompleted:{
           if(index == 0){
               console.log("Received amosValue :"+ amosValue);
               if(amosValue == 0){

                   idRightRecepDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (amosValue == 1){
                   idRightRecepDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

            }
           else if(index == 1){


           }
          else if(index == 2){


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
    //playBeepOn: false
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
    firstTextWidth: 490


   // firstTextStyle: "HDB"
   // secondText: ""
    secondTextX: 220
    secondTextY: 43
    secondTextSize:20
    secondTextColor: "#447CAD"
    //secondTextSelectedColor: colorInfo.dimmedGrey
    secondTextStyle: "HDB"
    secondTextWidth: 403

//    KeyNavigation.down:idKernel
    KeyNavigation.up:{
//        if(index == 0){
                amosOffButton
//        }
    }
    fgImage:""
    fgImageActive:""
    fgImageX: 400
    fgImageY: 25
    fgImageWidth:45
    fgImageHeight:45

    onClickOrKeySelected: {
        if(index == 0){

                UIListener.executeAMOS();
//                case False -> True
                if(amosValue == 0){
                    amosValue = 1
                    UIListener.SaveSystemConfig(1 ,EngineerData.DB_AMOS)
                    idRightRecepDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
//                    UIListener.executeAMOS();
                }
                //case True->False
                else if (amosValue == 1){
                    amosValue =0
                    UIListener.SaveSystemConfig(0 ,EngineerData.DB_AMOS)
                    idRightRecepDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                }
            }
            idRightRecepDelegate.ListView.view.currentIndex=index
            idRightRecepDelegate.forceActiveFocus()
        }




    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope






