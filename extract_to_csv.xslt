<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xslt="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>
<xsl:template match="/">
    <xsl:apply-templates select="//EstablishmentDetail" />
</xsl:template>
<xsl:template match="EstablishmentDetail">
    <xsl:value-of select="translate(normalize-space(FHRSID), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(LocalAuthorityBusinessID), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(BusinessName), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(BusinessTypeID), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(BusinessType), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(AddressLine1), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(AddressLine2), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(AddressLine3), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(translate(normalize-space(PostCode), ',', ' '), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(RatingValue), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(RatingKey), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(Geocode/Latitude), ',', ' ')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(Geocode/Longitude), ',', ' ')"/>
    <xslt:text>
</xslt:text>
</xsl:template>
</xsl:stylesheet>

