MACRO( OPENSYNC_PACKAGE _name _version ) 

  SET( CPACK_GENERATOR "TGZ;TBZ2" ) # This line is need for a CMake (Version 2.4.7) Bug - Fixed in CVS 
  SET( CPACK_SOURCE_GENERATOR "TGZ;TBZ2") 
  SET( CPACK_SOURCE_PACKAGE_FILE_NAME "${_name}-${_version}" ) 
  INCLUDE( CPack ) 

ENDMACRO( OPENSYNC_PACKAGE )
