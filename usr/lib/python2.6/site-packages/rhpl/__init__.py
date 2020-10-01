# dummy __init__ so that things work

def getArch ():
    import os
    arch = os.uname ()[4]
    if (len (arch) == 4 and arch[0] == 'i' and
        arch[2:4] == "86"):
        arch = "i386"

    if arch == "sparc64":
        arch = "sparc"

    if arch == "ppc64":
        arch = "ppc"

    if arch == "s390x":
        arch = "s390"

    return arch

# return the ppc machine variety type
def getPPCMachine():
    machine = None
    # ppc machine hash
    ppcType = { 'Mac'      : 'PMac',
                'Book'     : 'PMac',
                'CHRP IBM' : 'pSeries',
                'Pegasos'  : 'Pegasos',
                'Efika'    : 'Efika',
                'iSeries'  : 'iSeries',
                'pSeries'  : 'pSeries',
                'PReP'     : 'PReP',
                'CHRP'     : 'pSeries',
                'Amiga'    : 'APUS',
                'Gemini'   : 'Gemini',
                'Shiner'   : 'ANS',
                'BRIQ'     : 'BRIQ',
                'Teron'    : 'Teron',
                'AmigaOne' : 'Teron',
		'Maple'    : 'pSeries',
		'Cell'     : 'pSeries',
		'Momentum' : 'pSeries',
                'PS3'      : 'PS3'
                }

    if getArch() != "ppc":
        return 0

    f = open('/proc/cpuinfo', 'r')
    lines = f.readlines()
    f.close()
    for line in lines:
        if line.find('machine') != -1:
            machine = line.split(':')[1]
        elif line.find('platform') != -1:
            platform = line.split(':')[1]

    if machine is not None:
        for type in ppcType.items():
            if machine.find(type[0]) != -1:
                return type[1]

    if platform is not None:
        for type in ppcType.items():
            if platform.find(type[0]) != -1:
                return type[1]

    return None
