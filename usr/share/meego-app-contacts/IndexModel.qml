import Qt 4.7

ListModel {
    id: indexModel

    function appendLetters()
    {
        var list = localeUtils.getIndexBarChars();
        for(var i=0 ; i < list.length; i++)
        {
            append({"dletter": list[i]});
        }
    }

    Component.onCompleted: {
        appendLetters();
    }
}
