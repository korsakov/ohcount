<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--sample template-->
  <xsl:template match="sample-tag">				       
    <html>
      <head>
	<title>sample webpage </title>
      </head>
      <style><![CDATA[sample style]]></style>
      <body>
	<!-- comment -->
	<xsl:comment> comment in HTML</xsl:comment>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
