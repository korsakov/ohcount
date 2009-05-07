require File.dirname(__FILE__) + '/license'
require 'singleton'

module Ohcount
  module LicenseSniffer
    class LicenseMap
      include Singleton

      attr_reader :map, :licenses, :license_overrides

      def initialize()
        @map = {}
        @licenses = []

        [
          SoftwareLicense.new(:academic,
      "http://www.opensource.org/licenses/afl-3.0.php",
      "Academic Free License",
      /\bAcademic\s*Free\s*License\b/i ),

      SoftwareLicense.new(:adaptive,
      "http://www.opensource.org/licenses/apl1.0.php",
      "Adaptive Public License",
      /\bAdaptive\s*Public\s*License\b/i ),

      SoftwareLicense.new(:affero,
      "http://www.affero.org/oagpl.html",
      "GNU Affero General Public License",
      /\bGNU\s+Affero\s+General\s+Public\s+License\b/i ),

      SoftwareLicense.new(:apache,
      "http://www.opensource.org/licenses/apachepl.php",
      "Apache Software License",
      /(\bApache\s*Software\s*License(?![\s,]*2))|(\bapache\s*license(?![\s,]*2))/i ),

      SoftwareLicense.new(:apache_2,
      "http://www.opensource.org/licenses/apache2.0.php",
      "Apache License, 2.0",
      /\bapache\s+(software\s+)?license,?\s+(version\s+)?2/i ),

      SoftwareLicense.new(:apple_open_source,
      "http://www.opensource.org/licenses/apsl-2.0.php",
      "Apple Public Source License",
      /\bApple\s*Public\s*Source\s*License\b/i ),

      SoftwareLicense.new(:artistic,
      "http://www.opensource.org/licenses/artistic-license.php",
      "Artistic license",
      /\bartistic\s*license\b/i ),

      SoftwareLicense.new(:attribution_assurance,
      "http://www.opensource.org/licenses/attribution.php",
      "Attribution Assurance Licenses",
      /\battribution\s*assurance\s*license(s)?\b/i ),

      SoftwareLicense.new(:bsd,
      "http://www.opensource.org/licenses/bsd-license.php",
      "New BSD license",
      /(\bbsd\s*license\b)|(The Regents of the University of California)/i ),

      SoftwareLicense.new(:cecill,
      "http://www.cecill.info/licences/Licence_CeCILL_V2-en.html",
      "CeCILL license",
      /\bcecill\b/i ),

      SoftwareLicense.new(:cecill_b,
      "http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.html",
      "CeCILL-B license",
      /\bcecill-b\b/i ),

      SoftwareLicense.new(:cecill_c,
      "http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html",
      "CeCILL-C license",
      /\bcecill-c\b/i ),

      SoftwareLicense.new(:computer_associates_trusted,
      "http://www.opensource.org/licenses/ca-tosl1.1.php",
      "Computer Associates Trusted Open Source License 1.1",
      /\bcomputer\s*associates\s*trusted\s*open\s*source\s*license\b/i ),

      SoftwareLicense.new(:common_development_and_distribution,
      "http://www.opensource.org/licenses/cddl1.php",
      "Common Development and Distribution License",
      /\bcommon\s*development\s*and\s*distribution\s*license\b/i ),

      SoftwareLicense.new(:common_public,
      "http://www.opensource.org/licenses/cpl1.0.php",
      "Common Public License 1.0",
      /\bcommon\s*public\s*license\b/i ),

      SoftwareLicense.new(:cua_office,
      "http://www.opensource.org/licenses/cuaoffice.php",
      "CUA Office Public License Version 1.0",
      /\bCUA\s*office\s*public\s*license\b/i ),

      SoftwareLicense.new(:eu_datagrid,
      "http://www.opensource.org/licenses/eudatagrid.php",
      "EU DataGrid Software License",
      /\beu\s*datagrid\s*software\s*license\b/i ),

      SoftwareLicense.new(:eclipse,
      "http://www.opensource.org/licenses/eclipse-1.0.php",
      "Eclipse Public License",
      /\beclipse\s*public\s*license\b/i ),

      SoftwareLicense.new(:educational,
      "http://www.opensource.org/licenses/ecl1.php",
      "Educational Community License",
      /\beducational\s*community\s*license\b/i ),

      SoftwareLicense.new(:eiffel,
      "http://www.opensource.org/licenses/eiffel.php",
      "Eiffel Forum License",
      /\beiffel\s*forum\s*license(?![,V\s]*2)\b/i ),

      SoftwareLicense.new(:eiffel_2,
      "http://www.opensource.org/licenses/ver2_eiffel.php",
      "Eiffel Forum License V2.0",
      /\beiffel\s*forum\s*license [,V\s]*2/i ),

      SoftwareLicense.new(:entessa,
      "http://www.opensource.org/licenses/entessa.php",
      "Entessa Public License",
      /\bentessa\s*public\s*license\b/i ),

      SoftwareLicense.new(:fair,
      "http://www.opensource.org/licenses/fair.php",
      "Fair License",
      /\bfair\s*license\b/i ),

      SoftwareLicense.new(:frameworx,
      "http://www.opensource.org/licenses/frameworx.php",
      "Frameworx License",
      /\bframeworx\s*license\b/i ),

      SoftwareLicense.new(:gpl3_or_later,
      "http://www.gnu.org/licenses/gpl-3.0.html",
      "GNU General Public License 3.0",
      /\b(GNU GENERAL PUBLIC LICENSE|GPL).{0,100}(Version)? 3.{0,50}later/im),

      SoftwareLicense.new(:gpl3,
      "http://www.gnu.org/licenses/gpl-3.0.html",
      "GNU General Public License 3.0",
      /GNU (GENERAL PUBLIC LICENSE|GPL).{0,100}(Version |v)3/im,
      /((at your option) any later version)|(GENERAL PUBLIC LICENSE.*GENERAL PUBLIC LICENSE)/i),

      SoftwareLicense.new(:lgpl3,
      "http://www.gnu.org/licenses/lgpl-3.0.html",
      "GNU Lesser General Public License 3.0",
      /((\blgpl\b)|(\bgnu\s*(library|lesser)\s*(general\s*)?(public\s*)?license\b)|(\b(lesser|library)\s*gpl\b)).{0,10}(\bas published by the free software foundation\b)?.{0,10}(\bversion\b)?.{0,10}\b3(\.0)?\b/i ),

      SoftwareLicense.new(:gpl,
      "http://www.opensource.org/licenses/gpl-license.php",
      "GNU General Public License (GPL)",
      /(\bgpl\b)|(\bgplv2\b)|(\bgnu\s*general\s*public\s*license\b)|(\bwww\.gnu\.org\/licenses\/gpl\.txt\b)/i ),

      SoftwareLicense.new(:lgpl,
      "http://www.opensource.org/licenses/lgpl-license.php",
      "GNU Library or \"Lesser\" GPL (LGPL)",
      /(\blgpl\b)|(\bgnu\s*(library|lesser)\s*(general\s*)?(public\s*)?license\b)|(\b(lesser|library)\s*gpl\b)/i ),

      SoftwareLicense.new(:historical,
      "http://www.opensource.org/licenses/historical.php",
      "Historical Permission Notice and Disclaimer",
      /\bhistorical\s*permission\s*notice\s*and\s*disclaimer\b/i ),

      SoftwareLicense.new(:i9_license,
      "http://i9os.googlecode.com/svn/trunk/Documentation/Licenses/i9_License",
      "i9 License",
      /\bi9\s*\s*license\b/i  ),

      SoftwareLicense.new(:ibm_public,
      "http://www.opensource.org/licenses/ibmpl.php",
      "IBM Public License",
      /\bibm\s*public\s*license\b/i  ),

      SoftwareLicense.new(:intel_open_source,
      "http://www.opensource.org/licenses/intel-open-source-license.php",
      "Intel Open Source License",
      /\bintel\s*open\s*source\s*license\b/i ),

      SoftwareLicense.new(:jabber_open_source,
      "http://www.opensource.org/licenses/jabberpl.php",
      "Jabber Open Source License",
      /\bjabber\s*open\s*source\s*license\b/i ),

      SoftwareLicense.new(:lucent_plan9,
      "http://www.opensource.org/licenses/plan9.php",
      "Lucent Public License (Plan9)",
      /\blucent\s*public\s*license[\s(]*plan9/i ),

      SoftwareLicense.new(:lucent_public,
      "http://www.opensource.org/licenses/lucent1.02.php",
      "Lucent Public License Version 1.02",
      /\blucent\s*public\s*license\s*(version)?\s+1/i ),

      SoftwareLicense.new(:mit,
      "http://www.opensource.org/licenses/mit-license.php",
      "MIT license",
      /(\bmit\s*license\b)|(\bMIT\/X11\s*license\b)/i ),

      SoftwareLicense.new(:mitre,
      "http://www.opensource.org/licenses/mitrepl.php",
      "MITRE Collaborative Virtual Workspace License (CVW License)",
      /\bmitre\s*collaborative\s*virtual\s*workspace\s*license\b/i ),

      SoftwareLicense.new(:motosoto,
      "http://www.opensource.org/licenses/motosoto.php",
      "Motosoto License",
      /\bmotosoto\s*license\b/i ),

      SoftwareLicense.new(:mozilla_public_1,
      "http://www.opensource.org/licenses/mozilla1.0.php",
      "Mozilla Public License 1.0 (MPL)",
      /\bmozilla\s*public\s*license\b/i ),

      SoftwareLicense.new(:mozilla_public_1_1,
      "http://www.opensource.org/licenses/mozilla1.1.php",
      "Mozilla Public License 1.1 (MPL)",
      /\bmozilla\s*public\s*license 1\.1\b/i ),

      SoftwareLicense.new(:nasa_open,
      "http://www.opensource.org/licenses/nasa1.3.php",
      "NASA Open Source Agreement 1.3",
      /\bnasa\s*open\s*source\s*agreement\b/i ),

      SoftwareLicense.new(:naumen,
      "http://www.opensource.org/licenses/naumen.php",
      "Naumen Public License",
      /\bnaumen\s*public\s*license\b/i ),

      SoftwareLicense.new(:nethack,
      "http://www.opensource.org/licenses/nethack.php",
      "Nethack General Public License",
      /\bnethack\s*general\s*public\s*license\b/i ),

      SoftwareLicense.new(:nokia_open_source,
      "http://www.opensource.org/licenses/nokia.php",
      "Nokia Open Source License",
      /\bnokia\s*open\s*source\s*license\b/i ),

      SoftwareLicense.new(:oclc_research,
      "http://www.opensource.org/licenses/oclc2.php",
      "OCLC Research Public License 2.0",
      /\boclc\s*research\s*public\s*license\b/i ),

      SoftwareLicense.new(:open_group_test,
      "http://www.opensource.org/licenses/opengroup.php",
      "Open Group Test Suite License",
      /\bopen\s*group\s*test\s*suite\s*license\b/i ),

      SoftwareLicense.new(:open_software,
      "http://www.opensource.org/licenses/osl-3.0.php",
      "Open Software License",
      /\bopen\s*software\s*license\b/i ),

      SoftwareLicense.new(:php_license,
      "http://www.opensource.org/licenses/php.php",
      "PHP License",
      /\bphp\s*license\b/i ),

      SoftwareLicense.new(:python_license,
      "http://www.opensource.org/licenses/pythonpl.php",
      "Python license",
      /\bpython\s*license\b/i ),

      SoftwareLicense.new(:python_software_foundation,
      "http://www.opensource.org/licenses/PythonSoftFoundation.php",
      "Python Software Foundation License",
      /\bpython\s*software\s*foundation\s*license\b/i ),

      SoftwareLicense.new(:qt_public,
      "http://www.opensource.org/licenses/qtpl.php",
      "Qt Public License (QPL)",
      /\bqt\s*public\s*license\b/i ),

      SoftwareLicense.new(:realnetworks_public_source,
      "http://www.opensource.org/licenses/real.php",
      "RealNetworks Public Source License V1.0",
      /\brealnetworks\s*public\s*source\s*license\b/i ),

      SoftwareLicense.new(:reciprocal_public,
      "http://www.opensource.org/licenses/rpl.php",
      "Reciprocal Public License",
      /\breciprocal\s*public\s*license\b/i ),

      SoftwareLicense.new(:ricoh_source,
      "http://www.opensource.org/licenses/ricohpl.php",
      "Ricoh Source Code Public License",
      /\bricoh\s*source\s*code\s*public\s*license\b/i ),

      SoftwareLicense.new(:sleepycat,
      "http://www.opensource.org/licenses/sleepycat.php",
      "Sleepycat License",
      /\bsleepycat\s*license\b/i ),

      SoftwareLicense.new(:sugarcrm_1_1_3,
      "http://www.sugarcrm.com/SPL",
      "SugarCRM Public License 1.1.3",
      /\bsugar\s*public\s*license\s*version\s*1\.1\.3\b/i ),

      SoftwareLicense.new(:sun_industry_standards,
      "http://www.opensource.org/licenses/sisslpl.php",
      "Sun Industry Standards Source License (SISSL)",
      /\bsun\s*industry\s*standards\s*source\s*license\b/i ),

      SoftwareLicense.new(:sun_public,
      "http://www.opensource.org/licenses/sunpublic.php",
      "Sun Public License",
      /\bsun\s*public\s*license\b/i ),

      SoftwareLicense.new(:sybase_open_watcom,
      "http://www.opensource.org/licenses/sybase.php",
      "Sybase Open Watcom Public License 1.0",
      /\bsybase\s*open\s*watcom\s*public\s*license\b/i ),

      SoftwareLicense.new(:u_of_i_ncsa,
      "http://www.opensource.org/licenses/UoI-NCSA.php",
      "University of Illinois/NCSA Open Source License",
      /\buniversity\s*of\s*illinois\/ncsa\s*open\s*source\s*license\b/i ),

      SoftwareLicense.new(:vovida_software,
      "http://www.opensource.org/licenses/vovidapl.php",
      "Vovida Software License v. 1.0",
      /\bvovida\s*software\s*license\b/i ),

      SoftwareLicense.new(:w3c,
      "http://www.opensource.org/licenses/W3C.php",
      "W3C License",
      /\bw3c\s*license\b/i ),

      SoftwareLicense.new(:wx_windows,
      "http://www.opensource.org/licenses/wxwindows.php",
      "wxWindows Library License",
      /\bwxwindows\s*library\s*license\b/i ),

      SoftwareLicense.new(:x_net,
      "http://www.opensource.org/licenses/xnet.php",
      "X.Net License",
      /\bx\.net\s*license\b/i ),

      SoftwareLicense.new(:zope,
      "http://www.opensource.org/licenses/zpl.php",
      "Zope Public License",
      /\bzope\s*public\s*license\b/i ),

      SoftwareLicense.new(:zlib_libpng,
      "http://www.opensource.org/licenses/zlib-license.php",
      "zlib/libpng license",
      /\bzlib\/libpng\s*license\b/i ),

      SoftwareLicense.new(:apache_ish,
      "",
      "Apache-ish License",
      /(\bapache-style.*license\b)|(\bapache-like.*license\b)/i ),

      SoftwareLicense.new(:bsd_ish,
      "",
      "BSD-ish License",
      /Copyright\s.{1,40}All rights reserved.{0,40}Redistribution and use in source and binary forms, with or without.{0,20}modification, are permitted provided that the following conditions.{0,20}\sare met.{1,40}Redistributions of source code must retain the above copyright\s.*notice, this list of conditions and the following disclaimer\.\s+.*Redistributions in binary form must reproduce the above.*copyright\s+.{0,10}notice, this list of conditions and the following.*disclaimer in the\s+.*documentation.*(The (name|names) of the (author|contributors) may not|Neither the name of the).*be used to endorse or promote\s+.*products\s+.*derived\s+.*from this software without specific prior written\s+.*permission.*HOWEVER\s+.*CAUSED AND ON ANY.*THEORY OF LIABILITY, WHETHER IN CONTRACT/m,
      /The Regents of the University of California/),

      SoftwareLicense.new(:bsd_2clause_ish,
      "",
      "BSD-ish (2 clause) License",
      /Copyright\s.{1,60}All rights reserved.{1,40}Redistribution and use in source and binary forms, with or without.{0,20}modification, are permitted provided that the following conditions.{0,20}\sare met.{0,20}\s{1,20}.{0,20}Redistributions of source code must retain the above copyright\s+.*notice, this list of conditions and the following disclaimer.\s+.*Redistributions in binary form must reproduce the above copyright\s+.*notice, this list of conditions and the following disclaimer in the\s+.*documentation and\/or other materials provided with the distribution\.\s+.*HOWEVER CAUSED AND ON ANY.*THEORY OF LIABILITY, WHETHER IN CONTRACT/m,
      /(The Regents of the University of California)|(used to endorse or promote\s+.*products\s+.*prior\s+.*written\s+.*permission\.)/m),

			SoftwareLicense.new(:boost,
			"http://www.boost.org/LICENSE_1_0.txt",
			"Boost Software License - Version 1.0 - August 17th, 2003",
			/\bboost\s*software\s*license\b/i )

      ].each do |l|
        @licenses << l
        @map[l.symbol] = l
      end
      # gpl3 is more specific than gpl, so only include gpl3.  Be careful -- we don't want to miss cases that are conflicts
      @license_overrides = {
        :gpl => [ :gpl3, :gpl3_or_later],
        :gpl3 => [ :gpl3_or_later],
        :bsd_2clause_ish => [:bsd_ish]
      }
    end
  end
end
end
