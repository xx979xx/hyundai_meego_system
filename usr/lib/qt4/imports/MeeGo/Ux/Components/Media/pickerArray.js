/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*
 * This file manages lists to store selected item properties for the pickers.
 */

var ids = []
var titles = []
var types = []
var uris = []
var thumbUris = []

//puts an URN at the end of a list
function push( value, list ) {
    if( list == "ids" ){
        ids.push( value )
    }else if( list == "titles" ) {
        titles.push( value )
    }else if( list == "types" ) {
        types.push( value )
    }else if( list == "uris" ) {
        uris.push( value )
    }else if( list == "thumbUris" ) {
        thumbUris.push( value )
    }else {
        console.log( "list " + list + " unknown." )
    }
}

//removes the last entry of a list
function pop( list ) {
    if( list == "ids" && ids.length > 0 ){
        ids.pop()
    }else if( list == "titles" && titles.length > 0 ) {
        titles.pop()
    }else if( list == "types" && types.length > 0 ) {
        types.pop()
    }else if( list == "uris" && uris.length > 0 ) {
        uris.pop()
    }else if( list == "thumbUris" && thumbUris.length > 0 ) {
        thumbUris.pop()
    }else {
        console.log( "list " + list + " unknown." )
    }
}

//removes all entries of all list
function clear() {
    while( ids.length > 0 ) {
        ids.pop();
    }
    while( titles.length > 0 ) {
        titles.pop();
    }
    while( types.length > 0 ) {
        types.pop();
    }
    while( uris.length > 0 ) {
        uris.pop();
    }
    while( thumbUris.length > 0 ) {
        thumbUris.pop();
    }
}

//returns the size of a list
function getLength( list ) {
    if( list == "ids" ){
        return ids.length
    }else if( list == "titles" ) {
        return titles.length
    }else if( list == "types" ) {
        return types.length
    }else if( list == "uris" ) {
        return uris.length
    }else if( list == "thumbUris" ) {
        return thumbUris.length
    }else {
        console.log( "list " + list + " unknown." )
        return -1
    }
}

//removes a specific entry from a list and shifts the rest to close the gap
function remove( value, list ) {
    if( list == "ids" ) {
        var found = false;
        for( var i = 0; i < ids.length; i++ ) {
            if( found == false ){
                if( ids[i] == value ) {
                    found = true;
                    if( i + 1 < ids.length ) {
                        ids[i] = ids[ i + 1 ];
                    }else {
                        ids.pop();
                    }
                }
            }else {
                if( i + 1 < ids.length ) {
                    ids[i] = ids[ i + 1 ];
                }else {
                    ids.pop();
                }
            }
        }
    }else if( list == "titles" ) {
        var found = false;
        for( var i = 0; i < titles.length; i++ ) {
            if( found == false ){
                if( titles[i] == value ) {
                    found = true;
                    if( i + 1 < titles.length ) {
                        titles[i] = titles[ i + 1 ];
                    }else {
                        titles.pop();
                    }
                }
            }else {
                if( i + 1 < titles.length ) {
                    titles[i] = titles[ i + 1 ];
                }else {
                    titles.pop();
                }
            }
        }
    }else if( list == "types" ) {
        var found = false;
        for( var i = 0; i < types.length; i++ ) {
            if( found == false ){
                if( types[i] == value ) {
                    found = true;
                    if( i + 1 < types.length ) {
                        types[i] = types[ i + 1 ];
                    }else {
                        types.pop();
                    }
                }
            }else {
                if( i + 1 < types.length ) {
                    types[i] = types[ i + 1 ];
                }else {
                    types.pop();
                }
            }
        }
    }else if( list == "uris" ) {
        var found = false;
        for( var i = 0; i < uris.length; i++ ) {
            if( found == false ){
                if( uris[i] == value ) {
                    found = true;
                    if( i + 1 < uris.length ) {
                        uris[i] = uris[ i + 1 ];
                    }else {
                        uris.pop();
                    }
                }
            }else {
                if( i + 1 < uris.length ) {
                    uris[i] = uris[ i + 1 ];
                }else {
                    uris.pop();
                }
            }
        }
    }else if( list == "thumbUris" ) {
        var found = false;
        for( var i = 0; i < thumbUris.length; i++ ) {
            if( found == false ){
                if( thumbUris[i] == value ) {
                    found = true;
                    if( i + 1 < thumbUris.length ) {
                        thumbUris[i] = thumbUris[ i + 1 ];
                    }else {
                        thumbUris.pop();
                    }
                }
            }else {
                if( i + 1 < thumbUris.length ) {
                    thumbUris[i] = thumbUris[ i + 1 ];
                }else {
                    thumbUris.pop();
                }
            }
        }
    }
}
