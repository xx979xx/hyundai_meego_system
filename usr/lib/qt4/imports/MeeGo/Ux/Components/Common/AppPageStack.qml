/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*! 
    \qmlclass AppPageStack
    \title AppPageStack
    \section1 AppPageStack
    \qmlcm this is an AppPageStack which is responsible to push and pop pages from the stack. This
    way books can be implemented in order to be able to navigate to an Apps Content.FFF

    \section2 API Properties

    \qmlproperty int witdh
    \qmlcm width of the AppPageStack

    \qmlproperty int height
    \qmlcm height of the AppPageStack

    \qmlproperty int depth
    \qmlcm depth of the stack

    \qmlproperty Item currentPage
    \qmlcm current page, showed by the stack

    \qmlproperty Item toolBar
    \qmlcm current toolbar of current page

    \qmlproperty bool busy
    \qmlcm shows if AppPageStack is busy right now

    \section2 Signals

    \qmlproperty [signal] onVisibleChanged
    \qmlcm Signals if the visibility of an AppPage changed

    \section2 Functions

    \qmlfn push
    \qmlcm pushes a page to the stack
      \param Item pageStack
      \qmlpcm the AppPage to push \endparam

    \qmlfn pop
    \qmlcm pushes a page to the stack
      \param int deep: default 1
      \qmlpcm  \endparam

    \qmlfn replace
    \qmlcm replace the current stack
      \param Item pageStack
      \qmlpcm the AppPage to replace \endparam

    \qmlfn clear
    \qmlcm clears the stack

    \section2 Example
    \qmlnone
*/

import Qt 4.7

Item {
    id: appPageStack

    property int depth: stack.getDepth()
    property Item currentPage: null
    property Item toolBar: null

    property bool busy: ( currentPage != null && currentPage.parent != null && currentPage.parent.busy )

    function push(page) {
        return stack.push(page);
    }

    function pop(page) {
        return stack.pop(page);
    }
    
    function replace(page) {
        return stack.replace(page);
    }
    function clear() {
        return stack.clear();
    }

    width: parent ? parent.width : 0
    height: parent ? parent.height : 0
    
    onVisibleChanged: {
        if (currentPage) {
            if ( appPageStack.visible ) {
                stack.emitPageStateChange( currentPage, "activating" );
                stack.emitPageStateChange( currentPage, "activated" );
            } else {
                stack.emitPageStateChange( currentPage, "deactivating" );
                stack.emitPageStateChange( currentPage, "deactivated" );
            }
        }
    }
    
   
    Component {  // Component for page slots.
        id: slotComponent

        Item {
            id: slot

            property Item page: null
            property Item owner: null

            property int transitionDuration: 350
            property bool busy: false

            width: parent ? parent.width : 0
            height: parent ? parent.height : 0

            state: "hidden"

            function pushEnter(replace, immediate) {
                if (!immediate) {
                    state = replace ? "front" : "right";
                }
                state = "";
                page.visible = true;
                if ( appPageStack.visible && immediate ) {
                     stack.emitPageStateChange( page, "activating" );
                     stack.emitPageStateChange( page, "activated" );
                }
            }

            function pushExit( replace, immediate ) {
                state = immediate ? "hidden" : ( replace ? "back" : "left" );
                if ( appPageStack.visible && immediate ) {
                     stack.emitPageStateChange( page, "deactivating" );
                     stack.emitPageStateChange( page, "deactivated" );
                }
                if (replace) {
                    slot.destroy( immediate ? 0 : transitionDuration + 100 );
                }
            }

            function popEnter( immediate ) {
                if ( !immediate ) {
                    state = "left";
                }
                state = "";
                page.visible = true;
                if ( appPageStack.visible && immediate ) {
                     stack.emitPageStateChange( page, "activating" );
                     stack.emitPageStateChange( page, "activated" );
                }
            }

            function popExit( immediate ) {
                state = immediate ? "hidden" : "right";
                if ( appPageStack.visible && immediate ) {
                     stack.emitPageStateChange( page, "deactivating" );
                     stack.emitPageStateChange( page, "deactivated" );
                }
                slot.destroy( immediate ? 0 : transitionDuration + 100 );
            }
            
            function transitionStarted() {
                busy = true;
                if ( appPageStack.visible ) {
                     stack.emitPageStateChange( page, state == "" ? "activating" : "deactivating" );
                }
            }
            
            function transitionEnded() {
                busy = false;
                if ( appPageStack.visible ) {
                     stack.emitPageStateChange( page, state == "" ? "activated" : "deactivated" );
                }
                if ( state == "left" || state == "right" || state == "back" ) {
                    state = "hidden";
                }
            }

            function cleanup() {
                if ( page != null ) {
                    if ( state == "" ) {
                        // the page is active - deactivate it
                        if ( appPageStack.visible ) {
                             stack.emitPageStateChange( page, "deactivating" );
                             stack.emitPageStateChange( page, "deactivated" );
                        }
                    }
                    if ( owner != slot ) {
                        // slot is not the owner of the page - re-parent back to original owner
                        page.visible = false;
                        page.parent = owner;
                    }
                    page = null;
                }
            }
  
            states: [
          
                State { // Start state for pop entry, end state for push exit.
                    name: "left"
                    PropertyChanges { target: slot; x: -width }
                },                
                State { // Start state for push entry, end state for pop exit.
                    name: "right"
                    PropertyChanges { target: slot; x: width }
                },                
                State { // Start state for replace entry.
                    name: "front"
                    PropertyChanges { target: slot; scale: 1.5; opacity: 0.0 }
                },                
                State {	// End state for replace exit.
                    name: "back"
                    PropertyChanges { target: slot; scale: 0.5; opacity: 0.0 }
                },                
                State { // Inactive state.
                    name: "hidden"
                    PropertyChanges { target: slot; visible: false }
                }
            ]

            transitions: [
                
                Transition { // Pop entry and push exit transition.
                    from: ""; to: "left"; reversible: true
                    SequentialAnimation {
                        ScriptAction { script: if ( state == "left" ) { transitionStarted(); } else { transitionEnded(); } }
                        PropertyAnimation { properties: "x"; easing.type: Easing.InOutExpo; duration: transitionDuration }
                        ScriptAction { script: if ( state == "left" ) { transitionEnded(); } else { transitionStarted(); } }
                    }
                },                
                Transition { // Push entry and pop exit transition.
                    from: ""; to: "right"; reversible: true
                    SequentialAnimation {
                        ScriptAction { script: if ( state == "right" ) { transitionStarted(); } else { transitionEnded(); } }
                        PropertyAnimation { properties: "x"; easing.type: Easing.InOutExpo; duration: transitionDuration }
                        ScriptAction { script: if ( state == "right" ) { transitionEnded(); } else { transitionStarted(); } }
                    }
                },                
                Transition { // Replace entry transition.
                    from: "front"; to: "";
                    SequentialAnimation {
                        ScriptAction { script: transitionStarted(); }
                        PropertyAnimation { properties: "scale,opacity"; easing.type: Easing.InOutExpo; duration: transitionDuration }
                        ScriptAction { script: transitionEnded(); }
                    }
                },                
                Transition { // Replace exit transition.
                    from: ""; to: "back";
                    SequentialAnimation {
                        ScriptAction { script: transitionStarted(); }
                        PropertyAnimation { properties: "scale,opacity"; easing.type: Easing.InOutExpo; duration: transitionDuration }
                        ScriptAction { script: transitionEnded(); }
                   }
                }
            ]
        }
	Component.onDestruction: {
	  cleanup();
	}      
    }

    Item {
      id: stack

      property variant pageStack: undefined

      function getDepth() {
	  return pageStack.length;
      }
            
      function emitPageStateChange( page, signal ) {
          if ( page[signal] ) {
	      page[signal]();
	  }
      }
      
      function push( page, replace, immediate ) {
	  var pages;
          if ( page instanceof Array ) {
	      pages = page;
	      page = pages.pop();
	  }

          var oldSlot = pageStack[ pageStack.length - 1 ];

          if ( oldSlot && replace ) {
	      pageStack.pop();
	  }

	  if (pages) {
	      var i;
              for ( i = 0; i < pages.length; i++ ) {
                  pageStack.push( createSlot( pages[i] ) );
	      }
	  }

	  var slot = createSlot(page);

	  pageStack.push(slot);

	  depth = pageStack.length;
	  currentPage = slot.page;

	  immediate = immediate || !oldSlot;
	  if (oldSlot) {
              oldSlot.pushExit( replace, immediate );
	  }
          slot.pushEnter( replace, immediate );

	  var tools = slot.page.tools || null;
          if ( toolBar ) {
              toolBar.setTools( tools, immediate ? "set" : replace ? "replace" : "push" );
	  }

	  return slot.page;
      }

      function createSlot(page) {
          var slot = slotComponent.createObject( appPageStack );
          if ( page.createObject ) {
	      page = page.createObject(slot);
	      slot.page = page;
	      slot.owner = slot;
	  } else {
	      slot.page = page;
	      slot.owner = page.parent;
	      page.parent = slot;
	  }
	  return slot;
      }

      function popPages( pages, immediate ) {

          if ( pageStack.length > pages ) {

              var oldSlot = pageStack.pop();
              var slot = pageStack[pageStack.length - 1];
              if (page) {
                  while ( slot.page != page && pageStack.length > 1 ) {
                      slot.cleanup();
                      slot.destroy();
                      pageStack.pop();
                      slot = pageStack[ pageStack.length - 1 ];
                  }
              }

              depth = pageStack.length;
              currentPage = slot.page;

              oldSlot.popExit(immediate);
              slot.popEnter(immediate);

              var tools = slot.page.tools || null;
              if (toolBar) {
                  toolBar.setTools( tools, immediate ? "set" : "pop" );
              }

              return oldSlot.page;
          } else {
              return null;
          }
      }

      function pop(page, immediate) {
            if ( pageStack.length > 1 ) {
		var oldSlot = pageStack.pop();
		var slot = pageStack[pageStack.length - 1];
		if (page) {
                    while ( slot.page != page && pageStack.length > 1 ) {
			slot.cleanup();
			slot.destroy();
			pageStack.pop();
                        slot = pageStack[ pageStack.length - 1 ];
		    }
		}

		depth = pageStack.length;
		currentPage = slot.page;

		oldSlot.popExit(immediate);
		slot.popEnter(immediate);

		var tools = slot.page.tools || null;
		if (toolBar) {
                    toolBar.setTools( tools, immediate ? "set" : "pop" );
		}

		return oldSlot.page;
	    } else {
		return null;
	    }
	}

	function clear() {
	    var slot;
            while ( slot = pageStack.pop() ) {
		slot.cleanup();
		slot.destroy();
	    }
	}
    }
}

