#
# This is an eclass. It should show up as type 'ebuild'.
#

EXPORT_FUNCTIONS pkg_postinst

foo_pkg_postinst() {
	einfo "Welcome to foo"
}

