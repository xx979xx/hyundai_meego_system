import os.path

def get_numeric_include():
    """Return the directory where the Numeric header files are installed
    New in Numeric 24.2. This works when installed as an egg, too.

    Add the below to your setup.py:

    from Numeric_headers import get_numeric_include
    setup(...
        include_dirs = [..., get_numeric_include() ],
    )

    and use #include "Numeric/arrayobject.h" in your extension code.

    For supporting Numeric < 24.2, do
    try:
        from Numeric_headers import get_numeric_include
    except ImportError:
        def get_numeric_include():
            return ''

    """
    return os.path.dirname(__file__)
