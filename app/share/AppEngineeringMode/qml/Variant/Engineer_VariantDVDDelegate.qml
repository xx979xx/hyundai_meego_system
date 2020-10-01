import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
import QmlSimpleItems 1.0

MComp.MButton {
    id: idRightVariantSystemDelegate
    width: 537
    height:89



    property int dvdRegionValue: variant.DvdRegion_data
    property int menuLanguageValue: variant.DvdMenu_data
    property alias enableDVDSpin: dvdRegion_spin.enabled
    MComp.Spinner{
        id:dvdMenuLanguage
        visible: false
        //focus:true
        aSpinControlTextModel: dvdMenuLang_textModel
    }
    ListModel{
        id:dvdMenuLang_textModel
        property int count: 3
        ListElement{name:"a";}
        ListElement{name:"b";}
        ListElement{name:"c";}
    }

    ListModel
    {
        id: dvd_region_textModel
        property int count: 5

        ListElement {text: QT_TR_NOOP("0x01"); elementId: 0 }
        ListElement {text: QT_TR_NOOP("0x02"); elementId: 1 }
        ListElement {text: QT_TR_NOOP("0x03");  elementId: 2 }
        ListElement {text: QT_TR_NOOP("0x06");  elementId: 3 }
        ListElement{text:QT_TR_NOOP("0x00"); elementId:4}
        ListElement{text:QT_TR_NOOP("0x05"); elementId:4}

        // ListElement {text: QT_TR_NOOP("0x00 Region Free"); elementId:4}



    }

    SpinControl
    {
        id: dvdRegion_spin
        aSpinControlTextModel: dvd_region_textModel
        enabled: false
        visible: false
        y:10; x:200

        sCurrentValue: variant.DvdRegion_data
        width:330

        onSpinControlValueChanged:
        {
            if( dvdRegion_spin.sCurrentValue == qsTr("0x01") )
            {
                //SystemInfo.SetDVDRegionCode(1)
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_DVD_REGION );
            }

            else if(dvdRegion_spin.sCurrentValue == qsTr("0x02"))
            {
                //SystemInfo.SetDVDRegionCode(2)
                VariantSetting.SaveVariant_Data(2, EngineerData.DB_DVD_REGION);

            }

            else if(dvdRegion_spin.sCurrentValue == qsTr("0x03"))
            {
                //SystemInfo.SetDVDRegionCode(3)
                VariantSetting.SaveVariant_Data(3, EngineerData.DB_DVD_REGION);

            }
            else if(dvdRegion_spin.sCurrentValue == qsTr("0x06"))
            {
                //SystemInfo.SetDVDRegionCode(6)
                VariantSetting.SaveVariant_Data(6, EngineerData.DB_DVD_REGION);
            }

           else if(dvdRegion_spin.sCurrentValue == qsTr("0x00"))
           {
                VariantSetting.SaveVariant_Data(0, EngineerData.DB_DVD_REGION);
              // SystemInfo.SetDVDRegionCode(0)

           }
            else if(dvdRegion_spin.sCurrentValue == qsTr("0x05"))
            {
                 VariantSetting.SaveVariant_Data(5, EngineerData.DB_DVD_REGION);
               // SystemInfo.SetDVDRegionCode(0)

            }

        }
    }



    Component.onCompleted:{
        if(index == 0){
            enableDVDSpin = true
            dvdRegion_spin.visible = true
        }
        else if(index == 1){
            dvdMenuLanguage.visible = true
        }


    }


    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    //bgImagePress: imgFolderGeneral+"bg_menu_tab_l_p.png"
    //bgImageActive: imgFolderGeneral+"bg_menu_tab_l_s.png"
    bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"
    fgImage: ""
    fgImageActive: ""
    fgImageX: 280
    fgImageY: 20
    fgImageWidth:45
    fgImageHeight:45

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

   // firstTextStyle: "HDB"
   // secondText: ""
    secondTextX: 280
    secondTextY: 43
    secondTextSize:20
    secondTextColor: "#447CAD"
    //secondTextSelectedColor: colorInfo.dimmedGrey
    secondTextStyle: "HDB"
    secondTextWidth: 403

//    KeyNavigation.down:idKernel
//    KeyNavigation.up:


//    firstTextX : 9+23
//    firstTextY : 89-43-5

    KeyNavigation.up:{
        if(index == 0){
            backFocus.forceActiveFocus()
            variantBand
        }
    }


    onClickOrKeySelected: {
//        selectedItem = index
//        setRightMenuScreen(index, true)

        if(index == 0){
            idRightVariantSystemDelegate.forceActiveFocus()
        }
        if(index == 1){
            showFocus = false
            idRightVariantSystemDelegate.focus = false
            dvdMenuLanguage.forceActiveFocus()
           //dvdMenuLanguage.focusMode.forceActiveFocus()
        }

//        //setRightMenuScreen(2, true)
//       // setAppMain(selectedItem+2,false)
        idRightVariantSystemDelegate.ListView.view.currentIndex=index

//        console.log("checkBoxActive : "+index)
//        //upDate()
    }




    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope


