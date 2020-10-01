import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButton {

    id: idMenuDelegate
    width: 537
    height:89

    MSystem.ImageInfo { id: imageInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    bgImagePress: imgFolderGeneral+"bg_menu_tab_l_p.png"
    //bgImageActive: imgFolderGeneral+"bg_menu_tab_l_s.png"
    bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"

    active: index==selectedItem
    firstText : name
    firstTextX : 9+23
    firstTextY : 30/*89-43-5*/
    firstTextColor: colorInfo.brightGrey
    firstTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF"  //RGB(124, 189, 255)
    firstTextFocusColor: colorInfo.brightGrey
    firstTextSize: 32
    firstTextStyle:"HDB"
    firstTextWidth: 490
    KeyNavigation.up:{
        //if(index == 0){
            backFocus.forceActiveFocus()
            diagnosisBand
        //}
    }
    onClickOrKeySelected: {
        selectedItem = index
        setRightMenuScreen(index, true)
        isLeftBgArrow = false
        idDiagnosisRightList.focus = true
        idDiagnosisRightList.forceActiveFocus()
        //rightBg.visible = false
        //rightBg.visible = true
        //setRightMenuScreen(2, true)
        // setAppMain(selectedItem+2,false)
        idMenuDelegate.ListView.view.currentIndex=index
        // idMenuDelegate.forceActiveFocus()
        console.log("checkBoxActive : "+index)
        //upDate()
    }




    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

