#
# Macros for cmake
#
%_cmake_lib_suffix64 -DLIB_SUFFIX=64
%_cmake_skip_rpath -DCMAKE_SKIP_RPATH:BOOL=ON
%__cmake %{_bindir}/cmake

%cmake \
  CFLAGS="${CFLAGS:-%optflags}" ; export CFLAGS ; \
  CXXFLAGS="${CXXFLAGS:-%optflags}" ; export CXXFLAGS ; \
  FFLAGS="${FFLAGS:-%optflags}" ; export FFLAGS ; \
  %__cmake \\\
        -DCMAKE_VERBOSE_MAKEFILE=ON \\\
        -DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \\\
        -DCMAKE_INSTALL_LIBDIR:PATH=%{_libdir} \\\
        -DINCLUDE_INSTALL_DIR:PATH=%{_includedir} \\\
        -DLIB_INSTALL_DIR:PATH=%{_libdir} \\\
        -DSYSCONF_INSTALL_DIR:PATH=%{_sysconfdir} \\\
        -DSHARE_INSTALL_PREFIX:PATH=%{_datadir} \\\
%if "%{?_lib}" == "lib64" \
        %{?_cmake_lib_suffix64} \\\
%endif \
        %{?_cmake_skip_rpath} \\\
        -DBUILD_SHARED_LIBS:BOOL=ON
