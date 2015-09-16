// licenses.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#ifndef OHCOUNT_LICENSES_H
#define OHCOUNT_LICENSES_H

/**
 * @page license_doc License Documentation
 * @author Mitchell Foral
 *
 * @section license How to Add a New License
 *
 * @li Add your license to 'src/licenses.h' and 'src/licenses.c'. Don't forget
 *   that two '\\'s are required to represent one '\\' in a C string.
 * @li Add your tests to the 'test/src_licenses/' and 'test/expected_licenses/'
 *   directories. Note that multiple licenses must be separated by newlines and
 *   be in the order they appear in the input file.
 * @li Run the test suite (a rebuild is not necessary; your added tests are
 *   detected and run automatically) to verify your licenses are correctly
 *   detected.
 * @li Rebuild Ohcount.
 */

#include "sourcefile.h"

#define LIC_ACADEMIC "academic"
#define LIC_ADAPTIVE "adaptive"
#define LIC_AFFERO "affero"
#define LIC_APACHE "apache"
#define LIC_APACHE2 "apache_2"
#define LIC_APPLE_OPEN_SOURCE "apple_open_source"
#define LIC_ARTISTIC "artistic"
#define LIC_ATTRIBUTION_ASSURANCE "attribution_assurance"
#define LIC_BOOST "boost"
#define LIC_BSD "bsd"
#define LIC_CECILL "cecill"
#define LIC_CECILL_B "cecill_b"
#define LIC_CECILL_C "cecill_c"
#define LIC_COMPUTER_ASSOCIATES_TRUSTED "computer_associates_trusted"
#define LIC_COMMON_DEVELOPMENT_AND_DISTRIBUTION \
  "common_development_and_distribution"
#define LIC_COMMON_PUBLIC "common_public"
#define LIC_CUA_OFFICE "cua_office"
#define LIC_EU_DATAGRID "eu_datagrid"
#define LIC_ECLIPSE "eclipse"
#define LIC_EDUCATIONAL "educational"
#define LIC_EIFFEL "eiffel"
#define LIC_EIFFEL2 "eiffel_2"
#define LIC_ENTESSA "entessa"
#define LIC_FAIR "fair"
#define LIC_FRAMEWORX "frameworx"
#define LIC_GPL3_OR_LATER "gpl3_or_later"
#define LIC_GPL3 "gpl3"
#define LIC_LGPL3 "lgpl3"
#define LIC_GPL "gpl"
#define LIC_LGPL "lgpl"
#define LIC_HISTORICAL "historical"
#define LIC_I9 "i9_license"
#define LIC_IBM_PUBLIC "ibm_public"
#define LIC_INTEL_OPEN_SOURCE "intel_open_source"
#define LIC_JABBER_OPEN_SOURCE "jabber_open_source"
#define LIC_LUCENT_PLAN9 "lucent_plan9"
#define LIC_LUCENT_PUBLIC "lucent_public"
#define LIC_MIT "mit"
#define LIC_MITRE "mitre"
#define LIC_MOTOSOTO "motosoto"
#define LIC_MOZILLA_PUBLIC1 "mozilla_public_1"
#define LIC_MOZILLA_PUBLIC11 "mozilla_public_1_1"
#define LIC_NASA_OPEN "nasa_open"
#define LIC_NAUMEN "naumen"
#define LIC_NETHACK "nethack"
#define LIC_NOKIA_OPEN_SOURCE "nokia_open_source"
#define LIC_OCLC_RESEARCH "oclc_research"
#define LIC_OPEN_GROUP_TEST "open_group_test"
#define LIC_OPEN_SOFTWARE "open_software"
#define LIC_PHP_LICENSE "php_license"
#define LIC_PYTHON_LICENSE "python_license"
#define LIC_PYTHON_SOFTWARE_FOUNDATION "python_software_foundation"
#define LIC_QT_PUBLIC "qt_public"
#define LIC_REALNETWORKS_PUBLIC_SOURCE "realnetworks_public_source"
#define LIC_RECIPROCAL_PUBLIC "reciprocal_public"
#define LIC_RICOH_SOURCE "ricoh_source"
#define LIC_SLEEPYCAT "sleepycat"
#define LIC_SUGARCRM113 "sugarcrm_1_1_3"
#define LIC_SUN_INDUSTRY_STANDARDS "sun_industry_standards"
#define LIC_SUN_PUBLIC "sun_public"
#define LIC_SYBASE_OPEN_WATCOM "sybase_open_watcom"
#define LIC_U_OF_I_NCSA "u_of_i_ncsa"
#define LIC_VOVIDA_SOFTWARE "vovida_software"
#define LIC_W3C "w3c"
#define LIC_WXWINDOWS "wx_windows"
#define LIC_XNET "x_net"
#define LIC_ZOPE "zope"
#define LIC_ZLIB_LIBPNG "zlib_libpng"
#define LIC_APACHE_ISH "apache_ish"
#define LIC_BSD_ISH "bsd_ish"
#define LIC_BSD_2CLAUSE_ISH "bsd_2clause_ish"
#define LIC_WTFPL2 "wtfpl_2"

/**
 * Attempts to detect the source code licenses for a given file.
 * It searches comment text in source files for any mention of known licenses,
 * but unfortunately catches things like: "I find the GNU Public License dumb".
 * @param sourcefile A SourceFile created by ohcount_sourcefile_new().
 * @return LicenseList
 */
LicenseList *ohcount_detect_license(SourceFile *sourcefile);

/**
 * Creates a new LicenseList that is initially empty.
 * @return LicenseList
 */
LicenseList *ohcount_license_list_new();

/**
 * Frees the memory allocated for the given LicenseList.
 * @param list A LicenseList created from ohcount_license_list_new().
 */
void ohcount_license_list_free(LicenseList *list);

#endif
