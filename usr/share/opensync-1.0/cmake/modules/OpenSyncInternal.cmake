# This file got automatiaclly generated by the OpenSync CMake Build Environment
# Don't touch this generated file it!

INCLUDE( OpenSyncTesting )
INCLUDE( OpenSyncPackaging )
INCLUDE( OpenSyncPlugin )
INCLUDE( OpenSyncPlatforms )
INCLUDE( MacroEnsureOutOfSourceBuild )

MACRO_ENSURE_OUT_OF_SOURCE_BUILD("${CMAKE_PROJECT_NAME} doesn't allow to build within the source directory. Please, create a seperate build directory and run 'cmake ${PROJECT_SOURCE_DIR} [options]'!")


SET( OPENSYNC_PLUGINDIR "/usr/lib/opensync-1.0/plugins" )
SET( OPENSYNC_FORMATSDIR "/usr/lib/opensync-1.0/formats" )
SET( OPENSYNC_PYTHON_PLUGINDIR "/usr/lib/opensync-1.0/python-plugins" )

SET( OPENSYNC_CAPABILITIESDIR "/usr/share/opensync-1.0/capabilities" )
SET( OPENSYNC_CONFIGDIR "/usr/share/opensync-1.0/defaults" )
SET( OPENSYNC_DESCRIPTIONSDIR "/usr/share/opensync-1.0/descriptions" )
SET( OPENSYNC_SCHEMASDIR "/usr/share/opensync-1.0/schemas" )
SET( OPENSYNC_DATA_DIR "/usr/share/opensync-1.0" )

SET( OPENSYNC_INCLUDE_DIR "/usr/include/opensync-1.0" )
SET( OPENSYNC_LIBRARIES_DIR "/usr/lib" )
SET( OPENSYNC_LIBEXEC_DIR "/usr/libexec" )

SET( CMAKE_BUILD_TYPE "RelWithDebInfo" )
