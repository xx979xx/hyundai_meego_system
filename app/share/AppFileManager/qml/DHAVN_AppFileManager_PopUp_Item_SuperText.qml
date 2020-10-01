import Qt 4.7
import "DHAVN_AppFileManager_PopUp_Constants.js" as CONST
import "DHAVN_AppFileManager_PopUp_Resources.js" as RES

/** Text message */

Column
{
    id: super_text
    /** --- Input parameters --- */
    property ListModel txtModel: ListModel {}
    property bool txtOnly: false
    property bool use_icon: false
    property int alignment

    function retranslateUI( context )
    {
       if (context) { __lang_context = context }
       __emptyString = " "
       __emptyString = ""
    }

    property string __lang_context: CONST.const_LANGCONTEXT
    property string __emptyString: ""

    /** --- Child object --- */
    anchors.left: parent.left
    //anchors.top: parent.top
    anchors.verticalCenter: parent.verticalCenter

    Repeater
    {
        model: txtModel

        delegate: Component
        {

        Text
            {
                id: id_text
                text: argstext(index)
                height: 44
                width:710
                anchors.left:parent.left
                anchors.leftMargin: 0 //57 //modified by lssanh 2013.02.05 ISV72350
                horizontalAlignment: alignment//use_icon == false ? Text.AlignLeft : Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:  CONST.const_TEXT_COLOR
                font.pointSize:   CONST.const_TEXT_PT
          //      font.family: CONST.const_TEXT_FONT_FAMILY
                //font.family: CONST.const_TEXT_FONT_FAMILY_NEW //removed by Michael.Kim for 2013.12.18 for ITS 216142
                font.family: const_TIME_PICKER_FONT_FAMILY_NEW_HDR //modified by Michael.Kim for 2013.12.18 for ITS 216142
                wrapMode: Text.WordWrap
                style : Text.Sunken
            }//text

        }//delegate
    }//repeater


    function argstext(index)
    {
	//modified by aettie.ji 2013.02.06 for language setting 
    	if (txtModel.get(index).msg.substring(0, 4) != "STR_" )
	{
            return txtModel.get(index).msg
	}
    	if(txtModel.get(index).arguments != undefined)
    	{
    		var translation = qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, txtModel.get(index).msg )
		for (var i = 0; i < txtModel.get(index).arguments.count; i++)
		{
           	 	translation = translation.arg(txtModel.get(index).arguments.get(i).arg1)
           	}
           	return translation
    	}

     	return (txtModel.get(index).arg1 == undefined) ? qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, txtModel.get(index).msg ):
     		(qsTranslate(LocTrigger.empty + CONST.const_LANGCONTEXT, txtModel.get(index).msg)).arg(txtModel.get(index).arg1)
    }
}

