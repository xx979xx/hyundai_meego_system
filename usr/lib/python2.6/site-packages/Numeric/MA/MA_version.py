version_info=(12, 2, 0, 'final', 0)
_major, _minor, _miniscule, _descr, _tag = version_info
version = str(_major) + "." + str(_minor) + "." + str(_miniscule) 
if _descr != "final": 
    version = version + "-" + _descr + str(_tag)
