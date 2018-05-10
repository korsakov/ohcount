import os, collections
from abc import abstractmethod
import ohcount

class _OhcountBase(object):

    def __init__(self, base):
        self._base = base

    def __getattr__(self, name):
        if name == '_base':
            return object.__getattr__(self, name)
        raise AttributeError

    def __setattr__(self, name, value):
        if name == '_base':
            return object.__setattr__(self, name, value)
        raise AttributeError

class _OhcountDict(_OhcountBase, collections.Mapping, collections.KeysView):

    def __init__(self, base, mapping):
        _OhcountBase.__init__(self, base)
        collections.KeysView.__init__(self, mapping)

    def __getattr__(self, name):
        if name == '_mapping':
            return collections.KeysView.__getattr__(self, name)
        try:
            return _OhcountBase.__getattr__(self, name)
        except AttributeError:
            try:
                return self.__getitem__(name)
            except KeyError:
                raise AttributeError
        except:
            raise

    def __setattr__(self, name, value):
        if name == '_mapping':
            return collections.KeysView.__setattr__(self, name, value)
        try:
            return _OhcountBase.__setattr__(self, name, value)
        except AttributeError:
            try:
                return self.__setitem__(name, value)
            except KeyError:
                raise AttributeError
        except:
            raise

    def keys(self):
        return self._mapping

    def __setitem__(self, key, item):
        raise KeyError

    def __delitem__(self, key):
        raise KeyError

    def __str__(self):
        return dict([(key, self[key]) for key in self.keys()]).__str__()

    def iterkeys(self):
        return iter(self.keys())

    def itervalues(self):
        for key in self.keys():
            yield self[key]

    def iteritems(self):
        for key in self.keys():
            yield (key, self[key])

    def items(self):
        return [(key, self[key]) for key in self.keys()]

    def values(self):
        return [self[key] for key in self.keys()]

class _OhcountList(_OhcountBase):

    @abstractmethod
    def _get_value(self, inner):
        raise NotImplementedError

    def __len__(self):
        count = 0
        for e in self:
            count += 1
        return count

    def __iter__(self):
        return self.next()

    def next(self):
        iter = self._base.head
        while iter is not None:
            yield self._get_value(iter)
            iter = iter.next

    def __str__(self):
        return [v for v in self].__str__()

class License(_OhcountDict):

    def __init__(self, base):
        _OhcountDict.__init__(self, base,
            ['name','url','nice_name'])

    def __getitem__(self, key):
        if key == 'name':
            return self._base.name
        if key == 'url':
            return self._base.url
        if key == 'nice_name':
            return self._base.nice_name
        raise KeyError

class Loc(_OhcountDict):

    def __init__(self, base):
        _OhcountDict.__init__(self, base,
            ['lang','code','comments','blanks','filecount','total'])

    def __getitem__(self, key):
        if key == 'lang' or key == 'language':
            return self._base.language
        if key == 'code':
            return self._base.code
        if key == 'comments':
            return self._base.comments
        if key == 'blanks':
            return self._base.blanks
        if key == 'filecount':
            return self._base.filecount
        if key == 'total':
            return self._base.total()
        raise KeyError

class LocList(_OhcountDict, _OhcountList):

    def __init__(self, base):
        _OhcountDict.__init__(self, base,
            ['code','comments','blanks','filecount','total'])

    def _get_value(self, inner):
        return Loc(inner.loc)

    def __getitem__(self, key):
        if key == 'code':
            return self._base.code()
        if key == 'comments':
            return self._base.comments()
        if key == 'blanks':
            return self._base.blanks()
        if key == 'filecount':
            return self._base.filecount()
        if key == 'total':
            return self._base.total()
        raise KeyError

    def __str__(self):
        return _OhcountDict.__str__(self)

    def compact(self):
        return LocList(self._base.compact())

class SourceFile(_OhcountDict):

    def __init__(self, base):
        _OhcountDict.__init__(self, base,
            ['filepath','filename','ext','contents','size','language',
                'licenses','locs'])

    def _get_licenses(self):
        result = []
        list = self._base.get_license_list()
        if list is not None:
            iter = list.head
            while iter is not None:
                result.append(License(iter.lic))
                iter = iter.next
        return result

    def _get_locs(self):
        return LocList(self._base.get_loc_list())

    def __getitem__(self, key):
        if key == 'filepath':
           return self._base.filepath
        if key == 'filename':
           return self._base.filename
        if key == 'ext':
           return self._base.ext
        if key == 'contents':
           return self._base.get_contents()
        if key == 'size':
           return self._base.contents_size()
        if key == 'language':
           return self._base.get_language()
        if key == 'licenses':
           return self._get_licenses()
        if key == 'locs':
            return self._get_locs()
        raise AttributeError

    def annotate(self):
        return self._base.annotate()

    def raw_entities(self):
        return self._base.raw_entities()

class SourceFileList(_OhcountList):

    def __init__(self, **kwargs):
        _OhcountList.__init__(self, ohcount.SourceFileList(kwargs))

    def _get_value(self, inner):
        return SourceFile(inner.sf)

    def analyze_languages(self):
        return LocList( self._base.analyze_languages() )

    def add_directory(self, path):
        if not os.path.isdir(path):
            raise SyntaxError('Input path is not a directory: %s' % path)
        self._base.add_directory(path)

    def add_file(self, filepath):
        if not os.path.isfile(filepath):
            raise SyntaxError('Input path is not a file: %s' % filepath)
        self._base.add_file(filepath)

