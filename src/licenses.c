// licenses.c written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <ctype.h>
#include <string.h>
#include <stdio.h>

#include "licenses.h"
#include "parser.h"

// Holds licenses and their associated details and patterns.
License license_map[] = {
  {
    LIC_ACADEMIC,
    "http://www.opensource.org/licenses/afl-3.0.php",
    "Academic Free License",
    "\\bAcademic\\s*Free\\s*License\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_ADAPTIVE,
    "http://www.opensource.org/licenses/apl1.0.php",
    "Adaptive Public License",
    "\\bAdaptive\\s*Public\\s*License\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_AFFERO,
    "http://www.affero.org/oagpl.html",
    "GNU Affero General Public License",
    "\\bGNU\\s+Affero\\s+General\\s+Public\\s+License\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_APACHE,
    "http://www.opensource.org/licenses/apachepl.php",
    "Apache Software License",
    "(\\bApache\\s*Software\\s*License(?![\\s,]*2))|(\\bapache\\s*license(?![\\s,]*2))",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_APACHE2,
    "http://www.opensource.org/licenses/apache2.0.php",
    "Apache License, 2.0",
    "\\bapache\\s+(software\\s+)?license,?\\s+(version\\s+)?2",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_APPLE_OPEN_SOURCE,
    "http://www.opensource.org/licenses/apsl-2.0.php",
    "Apple Public Source License",
    "\\bApple\\s*Public\\s*Source\\s*License\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_ARTISTIC,
    "http://www.opensource.org/licenses/artistic-license.php",
    "Artistic license",
    "\\bartistic\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_ATTRIBUTION_ASSURANCE,
    "http://www.opensource.org/licenses/attribution.php",
    "Attribution Assurance Licenses",
    "\\battribution\\s*assurance\\s*license(s)?\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_BOOST,
    "http://www.boost.org/LICENSE_1_0.txt",
    "Boost Software License - Version 1.0 - August 17th, 2003",
    "\\bboost\\s*software\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_BSD,
    "http://www.opensource.org/licenses/bsd-license.php",
    "New BSD license",
    "(\\bbsd\\s*license\\b)|(The Regents of the University of California)",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_CECILL,
    "http://www.cecill.info/licences/Licence_CeCILL_V2-en.html",
    "CeCILL license",
    "\\bcecill\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_CECILL_B,
    "http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.html",
    "CeCILL-B license",
    "\\bcecill-b\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_CECILL_C,
    "http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html",
    "CeCILL-C license",
    "\\bcecill-c\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_COMPUTER_ASSOCIATES_TRUSTED,
    "http://www.opensource.org/licenses/ca-tosl1.1.php",
    "Computer Associates Trusted Open Source License 1.1",
    "\\bcomputer\\s*associates\\s*trusted\\s*open\\s*source\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_COMMON_DEVELOPMENT_AND_DISTRIBUTION,
    "http://www.opensource.org/licenses/cddl1.php",
    "Common Development and Distribution License",
    "\\bcommon\\s*development\\s*and\\s*distribution\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_COMMON_PUBLIC,
    "http://www.opensource.org/licenses/cpl1.0.php",
    "Common Public License 1.0",
    "\\bcommon\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_CUA_OFFICE,
    "http://www.opensource.org/licenses/cuaoffice.php",
    "CUA Office Public License Version 1.0",
    "\\bCUA\\s*office\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_EU_DATAGRID,
    "http://www.opensource.org/licenses/eudatagrid.php",
    "EU DataGrid Software License",
    "\\beu\\s*datagrid\\s*software\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_ECLIPSE,
    "http://www.opensource.org/licenses/eclipse-1.0.php",
    "Eclipse Public License",
    "\\beclipse\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_EDUCATIONAL,
    "http://www.opensource.org/licenses/ecl1.php",
    "Educational Community License",
    "\\beducational\\s*community\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_EIFFEL,
    "http://www.opensource.org/licenses/eiffel.php",
    "Eiffel Forum License",
    "\\beiffel\\s*forum\\s*license(?![,V\\s]*2)\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_EIFFEL2,
    "http://www.opensource.org/licenses/ver2_eiffel.php",
    "Eiffel Forum License V2.0",
    "\\beiffel\\s*forum\\s*license [,V\\s]*2",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_ENTESSA,
    "http://www.opensource.org/licenses/entessa.php",
    "Entessa Public License",
    "\\bentessa\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_FAIR,
    "http://www.opensource.org/licenses/fair.php",
    "Fair License",
    "\\bfair\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_FRAMEWORX,
    "http://www.opensource.org/licenses/frameworx.php",
    "Frameworx License",
    "\\bframeworx\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_GPL3_OR_LATER,
    "http://www.gnu.org/licenses/gpl-3.0.html",
    "GNU General Public License 3.0",
    "\\b(GNU GENERAL PUBLIC LICENSE|GPL).{0,100}(Version)? 3.{0,50}later",
    PCRE_CASELESS | PCRE_MULTILINE,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_GPL3,
    "http://www.gnu.org/licenses/gpl-3.0.html",
    "GNU General Public License 3.0",
    "GNU (GENERAL PUBLIC LICENSE|GPL).{0,100}(Version |v)3",
    PCRE_CASELESS | PCRE_MULTILINE,
    "((at your option) any later version)|(GENERAL PUBLIC LICENSE.*GENERAL PUBLIC LICENSE)",
    PCRE_CASELESS,
    NULL, NULL
  },
  {
    LIC_LGPL3,
    "http://www.gnu.org/licenses/lgpl-3.0.html",
    "GNU Lesser General Public License 3.0",
    "((\\blgpl\\b)|(\\bgnu\\s*(library|lesser)\\s*(general\\s*)?(public\\s*)?license\\b)|(\\b(lesser|library)\\s*gpl\\b)).{0,10}(\\bas published by the free software foundation\\b)?.{0,10}(\\bversion\\b)?.{0,10}\\b3(\\.0)?\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_GPL,
    "http://www.opensource.org/licenses/gpl-license.php",
    "GNU General Public License (GPL)",
    "(\\bgpl\\b)|(\\bgplv2\\b)|(\\bgnu\\s*general\\s*public\\s*license\\b)|(\\bwww\\.gnu\\.org\\/licenses\\/gpl\\.txt\\b)",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_LGPL,
    "http://www.opensource.org/licenses/lgpl-license.php",
    "GNU Library or \"Lesser\" GPL (LGPL)",
    "(\\blgpl\\b)|(\\bgnu\\s*(library|lesser)\\s*(general\\s*)?(public\\s*)?license\\b)|(\\b(lesser|library)\\s*gpl\\b)",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_HISTORICAL,
    "http://www.opensource.org/licenses/historical.php",
    "Historical Permission Notice and Disclaimer",
    "\\bhistorical\\s*permission\\s*notice\\s*and\\s*disclaimer\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_I9,
    "http://i9os.googlecode.com/svn/trunk/Documentation/Licenses/i9_License",
    "i9 License",
    "\\bi9\\s*\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_IBM_PUBLIC,
    "http://www.opensource.org/licenses/ibmpl.php",
    "IBM Public License",
    "\\bibm\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_INTEL_OPEN_SOURCE,
    "http://www.opensource.org/licenses/intel-open-source-license.php",
    "Intel Open Source License",
    "\\bintel\\s*open\\s*source\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_JABBER_OPEN_SOURCE,
    "http://www.opensource.org/licenses/jabberpl.php",
    "Jabber Open Source License",
    "\\bjabber\\s*open\\s*source\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_LUCENT_PLAN9,
    "http://www.opensource.org/licenses/plan9.php",
    "Lucent Public License (Plan9)",
    "\\blucent\\s*public\\s*license[\\s(]*plan9",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_LUCENT_PUBLIC,
    "http://www.opensource.org/licenses/lucent1.02.php",
    "Lucent Public License Version 1.02",
    "\\blucent\\s*public\\s*license\\s*(version)?\\s+1",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_MIT,
    "http://www.opensource.org/licenses/mit-license.php",
    "MIT license",
    "(\\bmit\\s*license\\b)|(\\bMIT\\/X11\\s*licensed?\\b)",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_MITRE,
    "http://www.opensource.org/licenses/mitrepl.php",
    "MITRE Collaborative Virtual Workspace License (CVW License)",
    "\\bmitre\\s*collaborative\\s*virtual\\s*workspace\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_MOTOSOTO,
    "http://www.opensource.org/licenses/motosoto.php",
    "Motosoto License",
    "\\bmotosoto\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_MOZILLA_PUBLIC1,
    "http://www.opensource.org/licenses/mozilla1.0.php",
    "Mozilla Public License 1.0 (MPL)",
    "\\bmozilla\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_MOZILLA_PUBLIC11,
    "http://www.opensource.org/licenses/mozilla1.1.php",
    "Mozilla Public License 1.1 (MPL)",
    "\\bmozilla\\s*public\\s*license 1\\.1\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_NASA_OPEN,
    "http://www.opensource.org/licenses/nasa1.3.php",
    "NASA Open Source Agreement 1.3",
    "\\bnasa\\s*open\\s*source\\s*agreement\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_NAUMEN,
    "http://www.opensource.org/licenses/naumen.php",
    "Naumen Public License",
    "\\bnaumen\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_NETHACK,
    "http://www.opensource.org/licenses/nethack.php",
    "Nethack General Public License",
    "\\bnethack\\s*general\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_NOKIA_OPEN_SOURCE,
    "http://www.opensource.org/licenses/nokia.php",
    "Nokia Open Source License",
    "\\bnokia\\s*open\\s*source\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_OCLC_RESEARCH,
    "http://www.opensource.org/licenses/oclc2.php",
    "OCLC Research Public License 2.0",
    "\\boclc\\s*research\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_OPEN_GROUP_TEST,
    "http://www.opensource.org/licenses/opengroup.php",
    "Open Group Test Suite License",
    "\\bopen\\s*group\\s*test\\s*suite\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_OPEN_SOFTWARE,
    "http://www.opensource.org/licenses/osl-3.0.php",
    "Open Software License",
    "\\bopen\\s*software\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_PHP_LICENSE,
    "http://www.opensource.org/licenses/php.php",
    "PHP License",
    "\\bphp\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_PYTHON_LICENSE,
    "http://www.opensource.org/licenses/pythonpl.php",
    "Python license",
    "\\bpython\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_PYTHON_SOFTWARE_FOUNDATION,
    "http://www.opensource.org/licenses/PythonSoftFoundation.php",
    "Python Software Foundation License",
    "\\bpython\\s*software\\s*foundation\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_QT_PUBLIC,
    "http://www.opensource.org/licenses/qtpl.php",
    "Qt Public License (QPL)",
    "\\bqt\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_REALNETWORKS_PUBLIC_SOURCE,
    "http://www.opensource.org/licenses/real.php",
    "RealNetworks Public Source License V1.0",
    "\\brealnetworks\\s*public\\s*source\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_RECIPROCAL_PUBLIC,
    "http://www.opensource.org/licenses/rpl.php",
    "Reciprocal Public License",
    "\\breciprocal\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_RICOH_SOURCE,
    "http://www.opensource.org/licenses/ricohpl.php",
    "Ricoh Source Code Public License",
    "\\bricoh\\s*source\\s*code\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_SLEEPYCAT,
    "http://www.opensource.org/licenses/sleepycat.php",
    "Sleepycat License",
    "\\bsleepycat\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_SUGARCRM113,
    "http://www.sugarcrm.com/SPL",
    "SugarCRM Public License 1.1.3",
    "\\bsugar\\s*public\\s*license\\s*version\\s*1\\.1\\.3\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_SUN_INDUSTRY_STANDARDS,
    "http://www.opensource.org/licenses/sisslpl.php",
    "Sun Industry Standards Source License (SISSL)",
    "\\bsun\\s*industry\\s*standards\\s*source\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_SUN_PUBLIC,
    "http://www.opensource.org/licenses/sunpublic.php",
    "Sun Public License",
    "\\bsun\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_SYBASE_OPEN_WATCOM,
    "http://www.opensource.org/licenses/sybase.php",
    "Sybase Open Watcom Public License 1.0",
    "\\bsybase\\s*open\\s*watcom\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_U_OF_I_NCSA,
    "http://www.opensource.org/licenses/UoI-NCSA.php",
    "University of Illinois/NCSA Open Source License",
    "\\buniversity\\s*of\\s*illinois\\/ncsa\\s*open\\s*source\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_VOVIDA_SOFTWARE,
    "http://www.opensource.org/licenses/vovidapl.php",
    "Vovida Software License v. 1.0",
    "\\bvovida\\s*software\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_W3C,
    "http://www.opensource.org/licenses/W3C.php",
    "W3C License",
    "\\bw3c\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_WXWINDOWS,
    "http://www.opensource.org/licenses/wxwindows.php",
    "wxWindows Library License",
    "\\bwxwindows\\s*library\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_XNET,
    "http://www.opensource.org/licenses/xnet.php",
    "X.Net License",
    "\\bx\\.net\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_ZOPE,
    "http://www.opensource.org/licenses/zpl.php",
    "Zope Public License",
    "\\bzope\\s*public\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_ZLIB_LIBPNG,
    "http://www.opensource.org/licenses/zlib-license.php",
    "zlib/libpng license",
    "\\bzlib\\/libpng\\s*license\\b",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_APACHE_ISH,
    "",
    "Apache-ish License",
    "(\\bapache-style.*license\\b)|(\\bapache-like.*license\\b)",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  {
    LIC_BSD_ISH,
    "",
    "BSD-ish License",
    "Copyright\\s.{1,40}All rights reserved.{0,40}Redistribution and use in source and binary forms, with or without.{0,20}modification, are permitted provided that the following conditions.{0,20}\\sare met.{1,40}Redistributions of source code must retain the above copyright\\s.*notice, this list of conditions and the following disclaimer\\.\\s+.*Redistributions in binary form must reproduce the above.*copyright\\s+.{0,10}notice, this list of conditions and the following.*disclaimer in the\\s+.*documentation.*(The (name|names) of the (author|contributors) may not|Neither the name of the).*be used to endorse or promote\\s+.*products\\s+.*derived\\s+.*from this software without specific prior written\\s+.*permission.*HOWEVER\\s+.*CAUSED AND ON ANY.*THEORY OF LIABILITY, WHETHER IN CONTRACT",
    PCRE_MULTILINE,
    "The Regents of the University of California",
    0,
    NULL, NULL
  },
  {
    LIC_BSD_2CLAUSE_ISH,
    "",
    "BSD-ish (2 clause) License",
    "Copyright\\s.{1,60}All rights reserved.{1,40}Redistribution and use in source and binary forms, with or without.{0,20}modification, are permitted provided that the following conditions.{0,20}\\sare met.{0,20}\\s{1,20}.{0,20}Redistributions of source code must retain the above copyright\\s+.*notice, this list of conditions and the following disclaimer.\\s+.*Redistributions in binary form must reproduce the above copyright\\s+.*notice, this list of conditions and the following disclaimer in the\\s+.*documentation and\\/or other materials provided with the distribution\\.\\s+.*HOWEVER CAUSED AND ON ANY.*THEORY OF LIABILITY, WHETHER IN CONTRACT",
    PCRE_MULTILINE,
    "(The Regents of the University of California)|(used to endorse or promote\\s+.*products\\s+.*prior\\s+.*written\\s+.*permission\\.)",
    PCRE_MULTILINE,
    NULL, NULL
  },
  {
    LIC_WTFPL2,
    "",
    "WTF Public License",
    "(\\bwtfpl\\b)|(\\bwtf\\s*public\\s*license\\b)|(\\b(do\\s*)?what\\s*the\\s*\\fuck\\s*public\\s*license\\b)",
    PCRE_CASELESS,
    NULL,
    0,
    NULL, NULL
  },
  { NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL },
};
int license_map_length = 0; // will be set dynamically

/** Compiles the regular expressions defined in license_map. */
void compile_regexps() {
  if (license_map_length == 0)
    return;
  const char *err;
  int erroffset;
  int i;
  for (i = 0; i < license_map_length; i++) {
    License *l = &license_map[i];
    int flags;
    if (l->re) {
      flags = l->re_flags;
      if (flags & PCRE_MULTILINE)
        flags |= PCRE_DOTALL;
      l->regexp = pcre_compile(l->re, flags, &err, &erroffset, NULL);
    }
    if (l->exclude_re) {
      flags = l->exclude_re_flags;
      if (flags & PCRE_MULTILINE)
        flags |= PCRE_DOTALL;
      l->exclude_regexp = pcre_compile(l->exclude_re, flags, &err, &erroffset,
                                       NULL);
    }
  }
}

/**
 * Overrides a less-specific license l with a more-specific one if the latter
 * was detected.
 */
#define OVERRIDE_LICENSE(l, with) { \
  if (strcmp(license_map[i].name, l) == 0) { \
    for (j = 0; j < license_map_length; j++) \
      if (potential_licenses_s[j] > -1 && \
          strcmp(license_map[j].name, with) == 0) { \
        overridden = 1; \
        break; \
      } \
  } \
}

LicenseList *ohcount_detect_license(SourceFile *sourcefile) {
  LicenseList *list = ohcount_license_list_new();

  // Get the size of this map and compile the REs. Only runs once.
  if (license_map_length == 0) {
    while (license_map[license_map_length].name) license_map_length++;
    compile_regexps();
  }

  ohcount_sourcefile_parse(sourcefile);

  char *p, *q;
  int i, j, k;
  int ovector[30]; // recommended by PCRE
  ParsedLanguageList *iter_language;
  iter_language = ohcount_sourcefile_get_parsed_language_list(sourcefile)->head;
  if (iter_language) {
    int potential_licenses_s[license_map_length];
    int potential_licenses_e[license_map_length];

    while (iter_language) {
      // Before looking for licenses, strip whitespace and newlines
      p = iter_language->pl->comments;
      int buffer_len = p ? strlen(p) : 0;
      char *p_max = p + buffer_len;

      char *buffer = malloc(buffer_len+1);
      if (buffer == NULL) {
        fprintf(stderr, "out of memory in ohcount_detect_license");
        exit(-1);
      }
      q = buffer;
      char *q_max = buffer + buffer_len + 1;

      while (p < p_max && q < q_max) {
        // Strip leading whitespace and punctuation.
        while (*p == ' ' || *p == '\t' || ispunct(*p)) p++;
        // Copy line contents.
        while (p < p_max && *p != '\r' && *p != '\n' && q < q_max)
          *q++ = *p++;
        // Strip newline characters.
        while (*p == '\r' || *p == '\n') p++;
        // Add a trailing space.
        if (q < q_max) *q++ = ' ';
      }
      if (q < q_max) *q = '\0';

      for (j = 0; j < license_map_length; j++) {
        potential_licenses_s[j] = -1;
        potential_licenses_e[j] = -1;
        if (pcre_exec(license_map[j].regexp, NULL, buffer, q - buffer, 0, 0,
                      ovector, 30) >= 0) {
          int m0 = ovector[0], m1 = ovector[1];
          // Exclude terms that may not exist in the license.
          if (license_map[j].exclude_re &&
              pcre_exec(license_map[j].exclude_regexp, NULL, buffer + m0, m1 - m0,
                        0, 0, ovector, 30) >= 0)
            continue;
          potential_licenses_s[j] = m0;
          potential_licenses_e[j] = m1;
          for (k = 0; k < j; k++) {
            // If this matched license is completely contained inside another one,
            // do not include it.
            if ((potential_licenses_s[k] < m0 && potential_licenses_e[k] >= m1) ||
                (potential_licenses_s[k] <= m0 && potential_licenses_e[k] > m1)) {
              potential_licenses_s[j] = -1;
              potential_licenses_e[j] = -1;
            }
            // If this matched license completely contains another one, do not
            // include the latter.
            if ((m0 < potential_licenses_s[k] && m1 >= potential_licenses_e[k]) ||
                (m0 <= potential_licenses_s[k] && m1 > potential_licenses_e[k])) {
              potential_licenses_s[k] = -1;
              potential_licenses_e[k] = -1;
            }
          }
        }
      }
      iter_language = iter_language->next;
    }

    // Create the list of licenses from potential licenses.
    for (i = 0; i < license_map_length; i++) {
      if (potential_licenses_s[i] > -1) {
        int overridden = 0;
        OVERRIDE_LICENSE(LIC_GPL, LIC_GPL3);
        OVERRIDE_LICENSE(LIC_GPL, LIC_GPL3_OR_LATER);
        OVERRIDE_LICENSE(LIC_GPL3, LIC_GPL3_OR_LATER);
        OVERRIDE_LICENSE(LIC_BSD_2CLAUSE_ISH, LIC_BSD_ISH);
        if (!overridden) {
          if (list->head == NULL) { // empty list
            list->head = list;
            list->tail = list;
            list->head->lic = &license_map[i];
            list->next = NULL;
          } else {
            LicenseList *item = ohcount_license_list_new();
            item->lic = &license_map[i];
            list->tail->next = item;
            list->tail = item;
          }
        }
      }
    }
  }

  return list;
}

LicenseList *ohcount_license_list_new() {
  LicenseList *list = malloc(sizeof(LicenseList));
  list->lic = NULL;
  list->next = NULL;
  list->head = NULL;
  list->tail = NULL;
  return list;
}

void ohcount_license_list_free(LicenseList *list) {
  if (list->head) {
    LicenseList *iter = list->head;
    while (iter) {
      LicenseList *next = iter->next;
      free(iter);
      iter = next;
    }
  } else free(list);
}
