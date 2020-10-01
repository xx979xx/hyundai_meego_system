import os

# TODO: Check against other Unix's
def get_proc_from_pid(pid):
    procpath = '/proc/' + str(pid) + '/cmdline'
    fullpath = ''

    try:
        f = open(procpath, 'r')
        fullpath = f.readline().split('\0')
        f.close()
    except:
        pass

    return fullpath

# TODO: figure out more robust way to do this
def get_ui_dir():
    try:
        ui_dir = os.environ['DFEET_DATA_PATH']
    except:
        ui_dir = "../ui"

    return ui_dir 

def print_method(m):
    def decorator(*args):
        print "call:", m,args
        r = m(*args)
        print "return:", r
        return r
    return decorator
