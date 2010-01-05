import unittest
import ohcount

class TestSourceFileList(unittest.TestCase):

    def setUp(self):
        # must not raise
        self.sf_list = ohcount.SourceFileList(paths=['../../gestalt_files'])

    def assertStrOp(self, obj, not_equals):
        s = str(obj)
        if not_equals:
            for v in not_equals:
                self.assertTrue(s is not v)

    def assertHasAttr(self, obj, name, not_equals=None):
        self.assertTrue(hasattr(obj, name))
        if not_equals:
            val = getattr(obj, name)
            for v in not_equals:
                self.assertTrue(val is not v)

    def assertHasItem(self, obj, name, not_equals=None):
        self.assertTrue(name in obj)
        if not_equals:
            val = obj[name]
            for v in not_equals:
                self.assertTrue(val is not v)

    def assertHasItemAttr(self, obj, name, not_equals=None):
        self.assertHasAttr(obj, name, not_equals)
        self.assertHasItem(obj, name, not_equals)

    def assertHasKeys(self, obj, keylist):
        for k in keylist:
            self.assertTrue(k in obj)

    def assertListIsInstance(self, list, type):
        for o in list:
            self.assertTrue(isinstance(o, type))

    def assertHasItemAttrs(self, obj, list, not_equals=None):
        for name in list:
            self.assertHasItemAttr(obj, name, not_equals)

    def testList(self):
        self.assertTrue(len(self.sf_list) > 0)
        self.assertListIsInstance(self.sf_list, ohcount.SourceFile)

    def testStr(self):
        self.assertStrOp(self.sf_list, [None, ""])

    def testAnalyzeLanguages(self):
        locs = self.sf_list.analyze_languages()
        self.assertTrue(isinstance(locs, ohcount.LocList))
        names = ['code','comments','blanks','filecount','total']
        self.assertHasKeys(locs, names)
        self.assertHasItemAttrs(locs, names, [None, 0])
        self.assertListIsInstance(locs, ohcount.Loc)

    def testAddDirectory(self):
        self.sf_list.add_directory('../../detect_files') # must not raise

    def testAddFile(self):
        self.sf_list.add_file('../../src_licenses/academic_t1.c') # must not raise

if __name__ == '__main__':
    unittest.main()
