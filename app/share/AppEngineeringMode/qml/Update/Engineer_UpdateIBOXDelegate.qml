import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButton {
    id: idRightMenuIBOXDelegate
    width: 537
    height:89
    z:300

    property color grey:            Qt.rgba(193/255, 193/255, 193/255, 1)
    property color dimmedGrey:      Qt.rgba(158/255, 158/255, 158/255, 1)
    property color bandBlue:        Qt.rgba( 124/255, 189/255, 225/255, 1)
    Component.onCompleted:{
            //Navi Program
           if(index == 0){
                     idRightMenuIBOXDelegate.secondText ="";
                   //  idRightMenuIBOXDelegate.firstTextColor = bandBlue
           }//Navi Map
           else if(index == 1){
                      idRightMenuIBOXDelegate.secondText ="";
           }//Update iBox
          else if(index == 2){
                    // idRightMenuIBOXDelegate.firstTextColor = grey
                   //  idRightMenuIBOXDelegate.secondTextColor = dimmedGrey
                   idRightMenuIBOXDelegate.secondText ="";
           }



    }

    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    //bgImagePress: imgFolderGeneral+"bg_menu_tab_l_p.png"
    //bgImageActive: imgFolderGeneral+"bg_menu_tab_l_s.png"
    bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"

  //. active: index==selectedItem
    firstText : name
    firstTextX: 20
    firstTextY: 43
    firstTextColor: colorInfo.brightGrey
    firstTextSelectedColor: colorInfo.brightGrey
    firstTextSize: 25
    firstTextStyle:"HDB"
    firstTextWidth: 230

    secondTextX: 250
    secondTextY: 43
    secondTextSize:20
    secondTextColor: "#447CAD"
    secondTextStyle: "HDB"
    secondTextWidth: 403
    KeyNavigation.up:{
        if(index == 0){
            backFocus.forceActiveFocus()
            updateBand
        }
    }
    onClickOrKeySelected: {

        idRightMenuIBOXDelegate.ListView.view.currentIndex=index
        idRightMenuIBOXDelegate.forceActiveFocus()

    }

    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope


