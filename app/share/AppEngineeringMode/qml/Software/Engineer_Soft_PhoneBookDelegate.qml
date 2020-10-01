import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0

MComp.MButton {
    id: idRightPhoneBookPatternLoader
    width: 537
    height:89

    //property int normalValue: Connect.Normal
    //property int advanceValue: Connect.Advance
    //property int currentindex

    Component.onCompleted:{

    }

    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    firstText: name
    firstTextSize: 23
    firstTextX: 20
    firstTextY: 43
    firstTextWidth: 450//230

    secondText: ""
    secondTextSize: 18
    secondTextX: 370
    secondTextY:43
    secondTextWidth: 403
    secondTextHeight: secondTextSize

    bgImagePress: imgFolderGeneral+"bg_menu_tab_l_p.png"
    bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"


    fgImage: (isCheckedState) ? (imgFolderGeneral + "btn_radio_s.png") : (imgFolderGeneral + "btn_radio_n.png")
    fgImageActive: ""
    fgImageX: 473/*370*/
    fgImageY: 20
    fgImageWidth:51
    fgImageHeight:52



    KeyNavigation.up:{
        if(index == 0){
            backFocus.forceActiveFocus()
            softwareBand
        }
    }

    onClickOrKeySelected: {

        if(index == 0){
            setCheckedStateTrue(0)
            setCheckedStatefalse(1)
            UIListener.NotifyApplication( 73 ,1 , "4 Pattern", 0)
            UIListener.voicePhoneBookPattern = 1
            UIListener.SaveSystemConfig(1, EngineerData.DB_PHONEBOOK_PATTERN);

            //setPhoneBookPatternValue(1);
            //VariantSetting.SaveVariant_Data(1, EngineerData.DB_PHONEBOOK );
            //VariantSetting.Send_Variant_Data();

        }
        if(index == 1){


            setCheckedStateTrue(1)
            setCheckedStatefalse(0)
            UIListener.NotifyApplication( 73 ,0 , "2 Pattern", 0)
            UIListener.voicePhoneBookPattern = 0
            UIListener.SaveSystemConfig(0, EngineerData.DB_PHONEBOOK_PATTERN);

            //setPhoneBookPatternValue(0);
            //VariantSetting.SaveVariant_Data(0, EngineerData.DB_PHONEBOOK );
            //VariantSetting.Send_Variant_Data();
        }

        idRightPhoneBookPatternLoader.ListView.view.currentIndex = index
        idRightPhoneBookPatternLoader.forceActiveFocus()



    }


    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
}

