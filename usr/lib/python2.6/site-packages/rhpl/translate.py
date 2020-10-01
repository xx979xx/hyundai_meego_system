#
# translate.py - persistent global gettext service for python programs
# needing transparent access to multiple textdomains
#
# adapted from translate.py originally in anaconda
#
# Matt Wilson <msw@redhat.com>
# Jeremy Katz <katzj@redhat.com>
#
# Copyright 2002 Red Hat, Inc.
#
# This software may be freely redistributed under the terms of the GNU
# library public license.
#
# You should have received a copy of the GNU Library Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

import gettext
import iconv
import os, sys, string
import gzip
import locale
import _translate
import codecs

def _expandLang(str):
    langs = [str]
    # remove charset ...
    if '.' in str:
            langs.append(string.split(str, '.')[0])
    # also add 2 character language code ...
    if len(str) > 2:
            langs.append(str[:2])
    return langs

def getDefaultLangs():
    lang = []
    for env in 'LANGUAGE', 'LC_ALL', 'LC_MESSAGES', 'LANG':
        if os.environ.has_key(env):
            lang = string.split(os.environ[env], ':')
            lang = map(_expandLang, lang)
            lang = reduce(lambda a, b: a + b, lang)
            break
    if 'C' not in lang:
        lang.append('C')
    return lang

class i18n:
    def __init__(self, langs=None, conversion=0, domain=None, paths=None):
        # FIXME: legacy method names
        self.utf8 = self.convert
        self.setunicode = self.setconversion
        self.getunicode = self.getconversion

        # do we convert to codeset or not?
        self.conversion = conversion
        # codeset to convert to
        self.codeset = 'utf-8'

        # dictionary of catalogs.  keyed by domain, val is (cat, iconv)
        self.cats = {}
        # list of domains in search order.  setting textdomain adds
        # to the front of the list
        self.domains = []
        
        if langs:
            self.langs = langs
        else:
            try:
                self.langs = getDefaultLangs()
            except:
                self.langs = ['C']

        if paths is None:
            self.paths = [ "/usr/share/locale" ]
        else:
            self.paths = paths
        
        self.setDomain(domain)

    # add a dir to our search path for po files
    def addPoPath(self, path):
        if path not in self.paths:
            self.paths.insert(0, path)
            self.updateCachedCatPaths()

    def setDomain(self, domain):
        # add domain to the front of our domain list
        if type(domain) == type([]):
            domain.reverse()
            for dom in domain:
                if dom in self.domains:
                    self.domains.pop(self.domains.index(dom))
                self.domains.insert(0, dom)
        else:
            if domain in self.domains:
                self.domains.pop(self.domains.index(domain))
            self.domains.insert(0, domain)

        # let's pop None out of the list if its there and special case it
        if None in self.domains:
            self.domains.pop(self.domains.index(None))

        self.updateCachedCatPaths()

    def updateCachedCatPaths(self):
        # should we recreate this each time?
        self.cats = {}
        self.iconv = None

        for domain in self.domains + [ None ]:
          for mypath in self.paths:
            if not domain:
                path = 'po/%s.mo'
            else:
                path = '%s/%s/LC_MESSAGES/%s.mo' % (mypath, '%s', domain,)                

            mofile = None
            for lang in self.langs:
                try:
                    file_path = path %(lang,)
                    f = open(file_path)
                    buf = f.read(2)
                    f.close()

                    if buf == "\037\213":
                        mofile = gzip.open(file_path)
                    else:
                        mofile = open(file_path)
		except IOError:
                    pass
                if mofile:
                    break

            if mofile is None:
                continue

            catalog = gettext.GNUTranslations(mofile)
            try:
                theiconv = iconv.open(self.codeset, catalog.charset())
            except Exception, e:
                sys.stderr.write('unable to translate from %s to utf-8: %s\n' %(catalog.charset(), e))
                theiconv = iconv.open(self.codeset, 'UTF-8')
            
            self.cats[domain] = (catalog, theiconv)
            if self.iconv is None:
                self.iconv = theiconv
            break

        # now let's put None at the beginning of the list as it corresponds
        # to the "current" local po files for testing
        self.domains.insert(0, None)
                    
        if len(self.cats) == 0:
            encoding = locale.nl_langinfo (locale.CODESET)
#            sys.stderr.write("WARNING: Unable to find catalog, using %s for codeset, %s for encoding\n" %(self.codeset, encoding))
            try:
                self.iconv = iconv.open(self.codeset, encoding)
            except:
                sys.stderr.write("FAILED to create iconv with codeset %s and encoding %s\n" %(self.codeset, encoding));
            return


    def setDomainCodeset(self, domain, codeset):
        self.codeset = codeset
        self.conversion = 1
        self.setDomain (domain)

    def setCodeset(self, codeset):
        self.codeset = codeset
        self.conversion = 1

    def setconversion(self, value):
        self.conversion = value

    def getconversion(self, value):
        return self.conversion

    def getlangs(self):
	return self.langs
        
    def setlangs(self, langs):
        self.__init__(langs, self.conversion, self.domains, self.paths)

    def convert(self, string):
        try:
            return self.iconv.iconv(string)
        except:
            return string

    def gettext(self, string):
        if len(self.cats) == 0:
            return string

        translation = None
        for domain in self.domains:
            if not self.cats.has_key(domain):
                continue
            (cat, iconv) = self.cats[domain]
            translation = cat._catalog.get(string)
            if translation is not None:
                if self.conversion:
                    return iconv.iconv(translation)
                else:
                    return translation.encode("UTF-8")

        return string

def N_(str):
    return str

def textdomain_codeset(domain, codeset):
    global cat
    cat.setDomainCodeset(domain, codeset)

def textdomain(domain):
    global cat
    cat.setDomain(domain)

def addPoPath(path):
    global cat
    cat.addPoPath(path)

def py_bind_textdomain_codeset(domain, codeset):
    _translate.bind_textdomain_codeset(domain, codeset)

cat = i18n()
_ = cat.gettext
utf8 = cat.convert
convert = cat.convert

