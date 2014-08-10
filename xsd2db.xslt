<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8" indent="no"/>
 
<xsl:template match="/">
<xsl:variable name="filename" select="lower-case(tokenize(tokenize(base-uri(.), '/')[last()],'\.')[1])" />
 
DROP TABLE IF EXISTS <xsl:value-of select="$filename"/>;
CREATE TABLE <xsl:value-of select="$filename"/> (
<xsl:for-each select="/xs:schema/xs:element[1]/xs:complexType[1]/xs:sequence[1]/xs:element[1]/xs:complexType[1]/xs:attribute" >
    <xsl:text>  </xsl:text><xsl:value-of select="@name"/><xsl:text> </xsl:text>
	<xsl:choose>
		<!-- тип данных -->
		<xsl:when test="xs:simpleType/xs:restriction/@base='xs:integer'">integer</xsl:when>
		<xsl:when test="xs:simpleType/xs:restriction/@base='xs:byte'">integer</xsl:when>
		<xsl:when test="xs:simpleType/xs:restriction/@base='xs:string'">text</xsl:when>
		<xsl:when test="@type='xs:date'">date</xsl:when>
	</xsl:choose>
	<xsl:if test="@use='required'"> NOT NULL</xsl:if>
	<xsl:if test="position()!=last()">,&#xa;</xsl:if>
</xsl:for-each>
);
 
<xsl:for-each select="/xs:schema/xs:element[1]/xs:complexType[1]/xs:sequence[1]/xs:element[1]/xs:complexType[1]/xs:attribute" >
	<a>COMMENT ON COLUMN <xsl:value-of select="$filename"/>.<xsl:value-of select="@name" /> IS </a>
	<xsl:choose>
    		<!-- Часть комментариев слишком длинная, обрезаем лишние строки -->
		<xsl:when test="contains(xs:annotation/xs:documentation,'&#xa;')">
			<a>'<xsl:value-of select="substring-before(xs:annotation/xs:documentation,'&#xa;')"/>'</a>
		</xsl:when>
		<xsl:otherwise>'<xsl:value-of select="xs:annotation/xs:documentation"/>'</xsl:otherwise>
	</xsl:choose>
	<xsl:text>;&#xa;</xsl:text>
</xsl:for-each>
 
</xsl:template>
</xsl:stylesheet>