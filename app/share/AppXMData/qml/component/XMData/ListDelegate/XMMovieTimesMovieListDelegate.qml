import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit

//XMDataSmallTypeListDelegate
MComp.MComponent{
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width-35;
    height:92

//    property alias nextButton: idEditButton
    property bool focusInfoBtn: false

    Image {
        x: 0; y: parent.height
        source: imageInfo.imgFolderMusic + "tab_list_line.png"
    }

    MComp.MButton{
        id: idBtnText
        x: 0; y:0
        width: 850; height: 97
        bgImage: ""
        bgImageFocus: imageInfo.imgFolderXMData + "xm_list_f.png"
        bgImagePress: imageInfo.imgFolderXMData + "xm_list_p.png"
        focus: !focusInfoBtn

        onClickOrKeySelected: {
            idListItem.ListView.view.currentIndex = index;
            idListItem.ListView.view.currentItem.focusInfoBtn = false;
            selectMovie(movieID, movieName);
        }

        //Movie Titile
        MComp.DDScrollTicker{
            id: idText
            x: 47; y: 0//44 - font.pixelSize/2;
            width: 425
            height: parent.height
            text: movieName
            fontFamily : systemInfo.font_NewHDR
            fontSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
        }
        Image {
            x: 490; y: 1
            //source: imageInfo.imgFolderBt_phone + "line_list.png"
            source: imageInfo.imgFolderXMData + "movie_divider.png"
        }
        //Movie Grade BG Image
        Image{
            id:idGradeBg
            x:47+425+44; //y:22
            anchors.verticalCenter: idGrade.verticalCenter;
            source:getGradeBgImage();//imageInfo.imgFolderXMData + "ico_grade_r.png";
        }

        Text {
            id: idGrade
            x: 47+425+44; y: 0//42 - font.pixelSize/2;
            width: 108; height: parent.height;
            text: grade
            font.family: systemInfo.font_NewHDB
            font.pixelSize: (grade === "Unrated") ? 22 : 28
            color: colorInfo.brightGrey

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            clip: true
        }

        Text {
            id: idRunTime
            x: 47+425+44+143; y: 0//42 - font.pixelSize/2;
            width: 203; height: parent.height;
            text: runningTime
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 32
            color: colorInfo.brightGrey
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft//Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            clip: true
        }
    }

    //Movie Info Button(i)
    MComp.MButton{
        id:idEditButton
        x:47+425+44+143+203; y:16
        width:62
        height:62
        bgImage:            imageInfo.imgFolderXMData + "btn_info_n.png"
        bgImagePress:       imageInfo.imgFolderXMData + "btn_info_p.png"
        bgImageFocus:       imageInfo.imgFolderXMData + "btn_info_f.png"
        focus: focusInfoBtn

//        bgImageFocusPress:  imageInfo.imgFolderXMData + "btn_info_fp.png"

        onClickOrKeySelected: {
            idListItem.ListView.view.currentIndex = index;
            idListItem.ListView.view.currentItem.focusInfoBtn = true;
            popupMovieInfo(movieName, grade, runningTime, actors, synopsis, rating);
        }
    }

    function getBgImageOfDelegate()
    {
        if((index == ListView.view.selectedIndex) && !isMousePressed()){
            return ""//imageInfo.imgFolderGeneral + "list_s.png"
        }/*else if((idListItem.activeFocus) && isMousePressed()){
            return imageInfo.imgFolderGeneral + "list_fp.png"
        }*/ else if(/*(index != ListView.view.selectedIndex) &&*/ isMousePressed()){
            return imageInfo.imgFolderGeneral + "list_p.png"
        }else{
            return "";
        }
    }
    function getGradeBgImage()
    {
        if(grade === "NC-17"){
            return imageInfo.imgFolderXMData + "ico_grade_r.png";
        }else if(grade === "R"){
            return imageInfo.imgFolderXMData + "ico_grade_b.png";
        }else if(grade === "G" || grade === "PG-13" || grade === "PG"){
            return imageInfo.imgFolderXMData + "ico_grade_g.png";
        }
        else if(grade === "Unrated"){
            return imageInfo.imgFolderXMData + "ico_grade_grey.png";
        }

        return imageInfo.imgFolderXMData + "ico_grade_g.png";
    }


    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        if(focusInfoBtn == false)
        {
            focusInfoBtn = true;
        }
        else
        {
            ListView.view.moveOnPageByPage(rowPerPage, true);
            if(index != ListView.view.currentIndex)
                ListView.view.currentItem.focusInfoBtn = false
        }
    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        if(focusInfoBtn)
        {
            focusInfoBtn = false;
        }
        else
        {
            ListView.view.moveOnPageByPage(rowPerPage, false);
            if(index != ListView.view.currentIndex)
                ListView.view.currentItem.focusInfoBtn = true;
        }
    }

    Rectangle{
        x:25
        y:15
        visible:isDebugMode();
        Column{
            Row{
                Text{
                    color : "red";
                    text: "[movieName]" + movieName + " [grade]" + grade + " [runningTime]" + runningTime + " [actors]" + actors +  " [rating]" + rating
                }
            }
            Row{
                Text{
                    color : "red";
                    text: "[synopsis]" + synopsis
                }
            }
        }
    }
}
