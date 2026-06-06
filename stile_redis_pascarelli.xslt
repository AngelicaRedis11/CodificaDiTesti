<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="2.0"
    exclude-result-prefixes="tei">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    
    <!-- TEMPLATE PRINCIPALE - radice del documento -->
    <xsl:template match="/">
        <html>
            <head>
                <title>La Rassegna Settimanale - Edizione Digitale </title>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <link rel="stylesheet" type="text/css" href="styles.css"/>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="script.js"></script>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&amp;family=Merriweather:ital,wght@0,300;0,400;0,700;1,300;1,400&amp;display=swap" rel="stylesheet"/>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
            </head>
            <body>
                
                <!-- HEADER - MENU NAVIGAZIONE -->
                <header class="top-header">
                    <nav class="section-chips">
                        <a href="#info-section" class="chip section-link chip-active">Informazioni</a>
                        <xsl:for-each select="/tei:teiCorpus/tei:TEI">
                            <a class="chip section-link">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('#', @xml:id)"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:title[@level='a']">
                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:title[@level='a']"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </a>
                        </xsl:for-each>
                    </nav>
                </header>
                
                <!-- CONTENUTO PRINCIPALE -->
                <main class="main-content">
                    
                    <!-- SEZIONE INFORMAZIONI GENERALI -->
                    <section id="info-section" class="general-info visible-section">
                        <div class="main-logo-container">
                            <p class="site-title">La rassegna settimanale</p>
                        </div>
                        
                        <div id="document-info" class="document-info">
                            <h2>Informazioni sulla codifica</h2>
                            <div class="info-container">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader"/>
                            </div>
                        </div>
                        
                        <div id="people-section" class="people-section">
                            <h2>Persone menzionate</h2>
                            <div class="entity-list">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listPerson[not(@type='characters')]/tei:person"/>
                            </div>
                        </div>

                        <xsl:if test="/tei:teiCorpus/tei:standOff/tei:listPerson[@type='characters']/tei:person">
                            <div id="characters-section" class="people-section">
                                <h2>Personaggi dell'opera</h2>
                                <div class="entity-list">
                                    <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listPerson[@type='characters']/tei:person" mode="character"/>
                                </div>
                            </div>
                        </xsl:if>
                        
                        <div id="places-section" class="places-section">
                            <h2>Luoghi menzionati</h2>
                            <div class="entity-list">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listPlace/tei:place"/>
                            </div>
                        </div>
                        
                        <xsl:if test="/tei:teiCorpus/tei:standOff/tei:listOrg/tei:org">
                            <div id="org-section" class="org-section">
                                <h2>Organizzazioni menzionate</h2>
                                <div class="entity-list">
                                    <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listOrg/tei:org"/>
                                </div>
                            </div>
                        </xsl:if>
                        
                        <xsl:if test="/tei:teiCorpus/tei:standOff/tei:listEvent/tei:event">
                            <div id="event-section" class="event-section">
                                <h2>Eventi citati</h2>
                                <div class="entity-list">
                                    <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listEvent/tei:event"/>
                                </div>
                            </div>
                        </xsl:if>
                        
                        <xsl:if test="/tei:teiCorpus/tei:standOff/tei:listBibl/tei:bibl">
                            <div id="bibl-section" class="bibl-section">
                                <h2>Opere citate</h2>
                                <div class="entity-list">
                                    <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listBibl/tei:bibl"/>
                                </div>
                            </div>
                        </xsl:if>
                    </section>
                    
                    <!-- SEZIONI ARTICOLI - una per ogni TEI del corpus -->
                    <xsl:for-each select="/tei:teiCorpus/tei:TEI">
                        <xsl:variable name="biblStruct" select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
                        <section class="article-section hidden-section">
                            <xsl:attribute name="id">
                                <xsl:value-of select="concat(@xml:id, '-section')"/>
                            </xsl:attribute>
                            <article class="document">
                                
                                <header class="document-header">
                                    <h2>
                                        <xsl:choose>
                                            <xsl:when test="$biblStruct/tei:analytic/tei:title[@level='a']">
                                                <xsl:value-of select="$biblStruct/tei:analytic/tei:title[@level='a']"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </h2>
                                    
                                    <div class="article-metadata">
                                        <div class="publication-info">
                                            
                                            <div class="publication-info-line">
                                                <strong>Pubblicazione:</strong>
                                                <xsl:value-of select="$biblStruct/tei:monogr/tei:title"/>
                                            </div>
                                            
                                            <xsl:if test="$biblStruct/tei:monogr/tei:imprint/tei:date">
                                                <div class="publication-info-line">
                                                    <strong>Data:</strong>
                                                    <xsl:value-of select="$biblStruct/tei:monogr/tei:imprint/tei:date"/>
                                                </div>
                                            </xsl:if>
                                            
                                            <xsl:if test="$biblStruct/tei:monogr/tei:biblScope[@unit='volume']">
                                                <div class="publication-info-line">
                                                    <strong>Volume:</strong>
                                                    <xsl:value-of select="$biblStruct/tei:monogr/tei:biblScope[@unit='volume']"/>
                                                </div>
                                            </xsl:if>
                                            
                                            <xsl:if test="$biblStruct/tei:monogr/tei:biblScope[@unit='issue']">
                                                <div class="publication-info-line">
                                                    <strong>Fascicolo:</strong>
                                                    <xsl:value-of select="$biblStruct/tei:monogr/tei:biblScope[@unit='issue']"/>
                                                </div>
                                            </xsl:if>
                                            
                                            <xsl:if test="$biblStruct/tei:monogr/tei:biblScope[@unit='page']">
                                                <div class="publication-info-line">
                                                    <strong>Pagine:</strong>
                                                    <xsl:value-of select="$biblStruct/tei:monogr/tei:biblScope[@unit='page']"/>
                                                </div>
                                            </xsl:if>
                                            
                                            <xsl:if test="$biblStruct/tei:monogr/tei:imprint/tei:publisher">
                                                <div class="publication-info-line">
                                                    <strong>Editore:</strong>
                                                    <xsl:value-of select="$biblStruct/tei:monogr/tei:imprint/tei:publisher"/>
                                                </div>
                                            </xsl:if>
                                            
                                            <xsl:if test="$biblStruct/tei:monogr/tei:imprint/tei:pubPlace">
                                                <div class="publication-info-line">
                                                    <strong>Luogo:</strong>
                                                    <xsl:value-of select="$biblStruct/tei:monogr/tei:imprint/tei:pubPlace"/>
                                                </div>
                                            </xsl:if>
                                            
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:notesStmt/tei:note">
                                                <div class="publication-info-line">
                                                    <strong>Note:</strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:notesStmt/tei:note"/>
                                                </div>
                                            </xsl:if>
                                            
                                        </div>
                                    </div>
                                </header>
                                
                                <div class="document-content">
                                    <div class="facsimile-column">
                                        <xsl:apply-templates select="tei:facsimile"/>
                                    </div>
                                    <div class="text-column">
                                        <xsl:apply-templates select="tei:text"/>
                                    </div>
                                </div>
                                
                            </article>
                        </section>
                    </xsl:for-each>
                    
                </main>
                
                <!-- BARRA INFERIORE EVIDENZIAZIONI -->
                <div class="bottom-header hidden">
                    <div class="annotation-tools">
                        <button class="tool-btn persName-btn" data-type="persName"><i class="fa-solid fa-user"/> Persone</button>
                        <button class="tool-btn character-btn" data-type="character"><i class="fa-solid fa-masks-theater"/> Personaggi</button>
                        <button class="tool-btn placeName-btn" data-type="placeName"><i class="fa-solid fa-location-dot"/> Luoghi</button>
                        <button class="tool-btn date-btn" data-type="date"><i class="fa-solid fa-calendar-days"/> Date</button>
                        <button class="tool-btn term-btn" data-type="term"><i class="fa-solid fa-book"/> Termini</button>
                        <button class="tool-btn orgName-btn" data-type="orgName"><i class="fa-solid fa-building-columns"/> Istituzioni</button>
                        <button class="tool-btn tipografia-btn" data-type="tipografia"><i class="fa-solid fa-print"/> Tipografie</button>
                        <button class="tool-btn casa-editrice-btn" data-type="casa-editrice"><i class="fa-solid fa-book-open"/> Case editrici</button>
                        <button class="tool-btn title-btn" data-type="tei-title"> <i class="fa-solid fa-book"/> Opere  </button>
                        <button class="tool-btn foreign-btn" data-type="foreign"><i class="fa-solid fa-globe"/> Parole straniere</button>
                        <button class="tool-btn choice-btn" data-type="choice"><i class="fa-solid fa-pen-to-square"/> Correzioni</button>
                        <button class="tool-btn quote-btn" data-type="quote"><i class="fa-solid fa-quote-left"/> Citazioni</button>
                        <button class="tool-btn roleName-btn" data-type="roleName"><i class="fa-solid fa-crown"/> Ruoli</button>
                        <button class="tool-btn measure-btn" data-type="measure"><i class="fa-solid fa-scale-balanced"/> Misure</button>
                        <button class="tool-btn damage-btn" data-type="damage"><i class="fa-solid fa-triangle-exclamation"/> Testo danneggiato </button>
                    </div>
                </div>
                
            </body>
        </html>
    </xsl:template>
    
    
    <!-- TEMPLATE CORPUS TEIHEADER -->
    <xsl:template match="/tei:teiCorpus/tei:teiHeader">
        <div class="document-metadata">
            <div class="metadata-column">
                <h3>
                    <xsl:value-of select="normalize-space(tei:fileDesc/tei:editionStmt/tei:edition)"/>
                </h3>
                <div class="edition-info">
                    <div class="respStmt-container">
                        <xsl:for-each select="tei:fileDesc/tei:editionStmt/tei:respStmt">
                            <div class="respStmt">
                                <p class="resp">
                                    <xsl:value-of select="tei:resp"/>
                                </p>
                                <ul class="resp-persons">
                                    <xsl:for-each select="tei:persName">
                                        <li>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </div>
                        </xsl:for-each>
                    </div>
                </div>
            </div>
            
            <div class="metadata-column">
                <h3>Pubblicazione originale</h3>
                <ul class="info-list">
                    <li><strong>Testata:</strong> <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title"/></li>
                    <li><strong>Editore:</strong> <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:publisher"/></li>
                    <li><strong>Luogo:</strong> <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:pubPlace"/></li>
                    <li><strong>Anno:</strong> <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date"/></li>
                    <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:editor[@role]">
                        <li>
                            <strong>Direzione:</strong>
                            <xsl:for-each select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:editor[@role]">
                                <xsl:value-of select="."/> (<xsl:value-of select="@role"/>)
                                <xsl:if test="position() != last()">; </xsl:if>
                            </xsl:for-each>
                        </li>
                    </xsl:if>
                    <xsl:if test="tei:profileDesc/tei:langUsage/tei:language">
                        <li><strong>Lingua:</strong> <xsl:value-of select="tei:profileDesc/tei:langUsage/tei:language"/></li>
                    </xsl:if>
                    <xsl:if test="tei:profileDesc/tei:creation/tei:date">
                        <li><strong>Periodo:</strong> <xsl:value-of select="tei:profileDesc/tei:creation/tei:date"/></li>
                    </xsl:if>
                </ul>
            </div>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE PERSON -->
    <xsl:template match="tei:person">
        <div class="entity-item">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <h3>
                <xsl:value-of select="normalize-space(tei:persName[1])"/>
            </h3>
            <div class="person-details">
                <xsl:if test="tei:occupation">
                    <p><strong>Occupazione:</strong> <xsl:value-of select="tei:occupation"/></p>
                </xsl:if>
                <xsl:if test="tei:note">
                    <p><strong>Nota:</strong> <xsl:value-of select="tei:note"/></p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <!-- TEMPLATE PERSONAGGI -->
    <xsl:template match="tei:person" mode="character">
        <div class="entity-item">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <h3>
                <xsl:value-of select="normalize-space(tei:persName[1])"/>
            </h3>
            <div class="person-details">
                <xsl:if test="tei:note">
                    <p><xsl:value-of select="tei:note"/></p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE PLACE -->
    <xsl:template match="tei:place">
        <div class="entity-item">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <h3>
                <xsl:value-of select="normalize-space(tei:placeName[1])"/>
            </h3>
            <div class="person-details">
                <xsl:if test="tei:location/tei:country">
                    <p><strong>Paese:</strong> <xsl:value-of select="tei:location/tei:country"/></p>
                </xsl:if>
                <xsl:if test="tei:note">
                    <p><strong>Nota:</strong> <xsl:value-of select="tei:note"/></p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE ORG -->
    <xsl:template match="tei:org">
        <div class="entity-item">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <h3>
                <xsl:value-of select="normalize-space(tei:orgName)"/>
            </h3>
            <div class="person-details">
                <xsl:if test="@type">
                    <p><strong>Tipo:</strong> <xsl:value-of select="@type"/></p>
                </xsl:if>
                <xsl:if test="tei:note">
                    <p><strong>Nota:</strong> <xsl:value-of select="tei:note"/></p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE FACSIMILE -->
    <xsl:template match="tei:facsimile">
        <div class="facsimile-container">
            <xsl:for-each select="tei:surface">
                <div class="page-facsimile">
                    <xsl:attribute name="id">
                        <xsl:value-of select="concat('facsimile-', @xml:id)"/>
                    </xsl:attribute>
                    <img alt="Facsimile page" class="facsimile-image">
                        <xsl:attribute name="src">
                            <xsl:value-of select="tei:graphic/@url"/>
                        </xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="substring-before(tei:graphic/@width, 'px')"/>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="substring-before(tei:graphic/@height, 'px')"/>
                        </xsl:attribute>
                    </img>
                    <svg class="overlay" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none">
                        <xsl:attribute name="viewBox">
                            <xsl:value-of select="concat('0,0,', substring-before(tei:graphic/@width, 'px'), ',', substring-before(tei:graphic/@height, 'px'))"/>
                        </xsl:attribute>
                        <xsl:for-each select="tei:zone[@corresp]">
                            <rect>
                                <xsl:attribute name="x"><xsl:value-of select="@ulx"/></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="@uly"/></xsl:attribute>
                                <xsl:attribute name="width"><xsl:value-of select="@lrx - @ulx"/></xsl:attribute>
                                <xsl:attribute name="height"><xsl:value-of select="@lry - @uly"/></xsl:attribute>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="translate(@corresp, '#', '')"/>
                                </xsl:attribute>
                            </rect>
                        </xsl:for-each>
                    </svg>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE TEXT -->
    <xsl:template match="tei:text">
        <div class="text-container">
            <xsl:apply-templates select="tei:body"/>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE BODY -->
    <xsl:template match="tei:body">
        <div class="article-body">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE DIV -->
    <xsl:template match="tei:div">
        <div class="text-div no-column">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@type">
                <xsl:attribute name="data-type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@n">
                <xsl:attribute name="data-n">
                    <xsl:value-of select="@n"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE HEAD -->
    <xsl:template match="tei:head">
        <h3 class="article-title">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    
    
    <!-- TEMPLATE P -->
    <xsl:template match="tei:p">
        <p class="text-paragraph">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <!-- TEMPLATE LB -->
    <xsl:template match="tei:lb">
        <span class="line-break" data-line-break="true">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@break='no'">
                <xsl:attribute name="data-break">no</xsl:attribute>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:lg//tei:lb"/>
    
    
    <!-- TEMPLATE PB -->
    <xsl:template match="tei:pb">
        <div class="page-break">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <span class="page-number">Pagina <xsl:value-of select="@n"/></span>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE CB -->
    <xsl:template match="tei:cb">
        <div class="column-break">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <span class="column-number">Fine colonna</span>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE PERSNAME (Persone e Personaggi)-->
    <xsl:template match="tei:persName">
        <xsl:variable name="isCharacter" select="starts-with(substring-after(@ref, '#'), 'c_')"/>
        <span>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$isCharacter">entity persName character</xsl:when>
                    <xsl:otherwise>entity persName</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ref">
                    <a class="entity-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="@ref"/>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    
    <!-- TEMPLATE PLACENAME -->
    <xsl:template match="tei:placeName">
        <span class="entity placeName">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ref">
                    <a class="entity-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="@ref"/>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    

    <!-- TEMPLATE DATE -->
    <xsl:template match="tei:date">
        <span class="entity date">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@when">
                <xsl:attribute name="data-when">
                    <xsl:value-of select="@when"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- TEMPLATE EVENT -->
    <xsl:template match="tei:event">
        <div class="entity-item">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <h3>
                <xsl:choose>
                    <xsl:when test="tei:label">
                        <xsl:value-of select="normalize-space(tei:label)"/>
                    </xsl:when>
                    <xsl:when test="@type">
                        <xsl:value-of select="@type"/>
                    </xsl:when>
                    <xsl:otherwise>Evento</xsl:otherwise>
                </xsl:choose>
            </h3>
            <div class="person-details">
                <xsl:if test="tei:date or @when">
                    <p>
                        <strong>Data:</strong>
                        <xsl:choose>
                            <xsl:when test="tei:date/@when">
                                <xsl:value-of select="tei:date/@when"/>
                            </xsl:when>
                            <xsl:when test="tei:date">
                                <xsl:value-of select="tei:date"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@when"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </p>
                </xsl:if>
                <xsl:if test="tei:desc/tei:placeName">
                    <p><strong>Luogo:</strong> <xsl:value-of select="tei:desc/tei:placeName[1]"/></p>
                </xsl:if>
                <xsl:if test="tei:desc">
                    <p><strong>Descrizione:</strong> <xsl:value-of select="tei:desc"/></p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE LISTBIBL / OPERE - homepage e popup -->
    <xsl:template match="tei:standOff/tei:listBibl/tei:bibl">
        <div class="entity-item">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <h3><xsl:value-of select="normalize-space(tei:title[1])"/></h3>
            <div class="person-details">
                <xsl:if test="tei:author">
                    <p><strong>Autore:</strong>
                        <xsl:apply-templates select="tei:author"/>
                    </p>
                </xsl:if>
                <xsl:if test="tei:pubPlace">
                    <p><strong>Luogo:</strong>
                        <xsl:value-of select="tei:pubPlace"/>
                    </p>
                </xsl:if>
                <xsl:if test="tei:publisher or tei:orgName">
                    <p><strong>Editore:</strong>
                        <xsl:value-of select="tei:publisher | tei:orgName"/>
                    </p>
                </xsl:if>
                <xsl:if test="tei:date">
                    <p><strong>Anno:</strong>
                        <xsl:value-of select="tei:date"/>
                    </p>
                </xsl:if>
                <xsl:if test="tei:note">
                    <p><strong>Nota:</strong>
                        <xsl:value-of select="tei:note"/>
                    </p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
 
    
    <!-- TEMPLATE OPERE nel corpo del testo - evidenziabile e cliccabile -->
    <xsl:template match="tei:text//tei:title">
        <span class="entity tei-title">
            <xsl:if test="@xml:lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ref">
                    <a class="entity-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="@ref"/>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <!-- TEMPLATE TERM -->
    <xsl:template match="tei:term">
        <span class="entity term">
            <xsl:if test="@gloss">
                <xsl:attribute name="title">
                    <xsl:value-of select="concat('Significato: ', @gloss)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="@gloss">
                <span class="term-gloss">
                    <xsl:value-of select="@gloss"/>
                </span>
            </xsl:if>
        </span>
    </xsl:template>
    
    
    <!-- TEMPLATE ORGNAME -->
    <xsl:template match="tei:orgName">
        <xsl:variable name="refId" select="substring-after(@ref, '#')"/>
        <xsl:variable name="orgType" select="/tei:teiCorpus/tei:standOff/tei:listOrg/tei:org[@xml:id=$refId]/@type"/>
        <span>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$orgType='tipografia'">entity orgName tipografia</xsl:when>
                    <xsl:when test="$orgType='casa editrice'">entity orgName casa-editrice</xsl:when>
                    <xsl:otherwise>entity orgName</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ref">
                    <a class="entity-link">
                        <xsl:attribute name="href"><xsl:value-of select="@ref"/></xsl:attribute>
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
 
    <!-- TEMPLATE FOREIGN - include traduzione solo se immediatamente adiacente -->
    <xsl:template match="tei:foreign">
        <xsl:variable name="eid" select="generate-id()"/>
        <span class="entity foreign">
            <xsl:attribute name="data-entity-id">
                <xsl:value-of select="$eid"/>
            </xsl:attribute>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
        <!-- Traduzione solo se la note[@type='translation'] è il fratello immediatamente successivo -->
        <xsl:variable name="nextSibling" select="following-sibling::node()[not(self::text()[normalize-space()=''])][1]"/>
        <xsl:if test="$nextSibling/self::tei:note[@type='translation']">
            <span class="foreign-translation">
                <xsl:attribute name="data-entity-id">
                    <xsl:value-of select="$eid"/>
                </xsl:attribute>
                <xsl:value-of select="$nextSibling"/>
            </span>
        </xsl:if>
    </xsl:template>
    
    
    <!-- TEMPLATE HI -->
    <xsl:template match="tei:hi">
        <span>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:value-of select="concat('hi ', @rend)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <!-- TEMPLATE RS -->
    <xsl:template match="tei:rs">
        <span class="entity rs">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@type">
                <xsl:attribute name="data-type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ref">
                    <a class="entity-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="@ref"/>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    
    <!-- TEMPLATE CHOICE -->
    <xsl:template match="tei:choice">
        <span class="entity choice">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <!-- originale del testo -->
                <xsl:when test="tei:reg and tei:orig">
                    <span class="form-orig">
                        <xsl:attribute name="title">
                            <xsl:value-of select="concat('Forma moderna: ', tei:reg)"/>
                        </xsl:attribute>
                        <xsl:value-of select="tei:orig"/>
                    </span>
                    <span class="form-norm">
                        <xsl:attribute name="title">
                            <xsl:value-of select="concat('Forma originale: ', tei:orig)"/>
                        </xsl:attribute>
                        <xsl:value-of select="tei:reg"/>
                    </span>
                </xsl:when>
                <!-- espansione -->
                <xsl:when test="tei:abbr and tei:expan">
                    <span class="form-orig">
                        <xsl:attribute name="title">
                            <xsl:value-of select="concat('Espansione: ', tei:expan)"/>
                        </xsl:attribute>
                        <xsl:value-of select="tei:abbr"/>
                    </span>
                    <span class="form-norm">
                        <xsl:attribute name="title">
                            <xsl:value-of select="concat('Abbreviazione: ', tei:abbr)"/>
                        </xsl:attribute>
                        <xsl:value-of select="tei:expan"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <!-- TEMPLATE DAMAGE -->
    <xsl:template match="tei:damage">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:damage/tei:supplied">
        <span class="entity damage supplied">
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="@reason='ink blot'">Testo danneggiato: macchia d'inchiostro</xsl:when>
                    <xsl:otherwise>Testo danneggiato: integrazione editoriale</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <span class="supplied-placeholder">●</span>
            <span class="supplied-hidden">
                <xsl:text>[</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>] </xsl:text>
                <span class="supplied-reason">
                    <xsl:choose>
                        <xsl:when test="@reason='ink blot'">(macchia d'inchiostro)</xsl:when>
                        <xsl:otherwise>(<xsl:value-of select="@reason"/>)</xsl:otherwise>
                    </xsl:choose>
                </span>
            </span>
        </span>
    </xsl:template>
    
    <!-- TEMPLATE UNCLEAR -->
    <xsl:template match="tei:unclear">
        <span class="entity unclear">
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="@reason='illegible'">Testo non chiaro </xsl:when>
                    <xsl:otherwise>Testo illeggibile</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <span class="supplied-placeholder">●</span>
            <span class="supplied-hidden">
                <xsl:text>[</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>] </xsl:text>
                <span class="supplied-reason">
                    <xsl:choose>
                        <xsl:when test="@reason='illegible'">(testo non chiaro)</xsl:when>
                        <xsl:otherwise>(<xsl:value-of select="@reason"/>)</xsl:otherwise>
                    </xsl:choose>
                </span>
            </span>
        </span>
    </xsl:template>
    
    <!-- TEMPLATE QUOTE -->
    <xsl:template match="tei:quote">
        <xsl:choose>
            <xsl:when test="tei:lg or tei:l or tei:p or tei:ab or tei:seg">
                <div class="quote quote-block">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@xml:lang">
                        <xsl:attribute name="lang">
                            <xsl:value-of select="@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <span class="quote">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@xml:lang">
                        <xsl:attribute name="lang">
                            <xsl:value-of select="@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- TEMPLATE QUOTE TRANSLATION -->
    <xsl:template match="tei:quote[@type='translation']">
        <div class="quote-translation">
            <xsl:if test="@xml:lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <span class="translation-label">[Trad.: </span>
            <xsl:apply-templates/>
            <span class="translation-label">]</span>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE CIT -->
    <xsl:template match="tei:cit">
        <div class="cit">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE Q -->
    <xsl:template match="tei:q">
        <xsl:choose>
            <xsl:when test="tei:l or tei:lg">
                <div class="verse-block">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <span class="tei-q">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- TEMPLATE LG -->
    <xsl:template match="tei:lg">
        <div class="line-group">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@type">
                <xsl:attribute name="data-type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE L -->
    <xsl:template match="tei:l">
        <span class="verse-line">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@n">
                <xsl:attribute name="data-n">
                    <xsl:value-of select="@n"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <!-- TEMPLATE TRAILER -->
    <xsl:template match="tei:trailer">
        <div class="trailer">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- TEMPLATE FW -->
    <xsl:template match="tei:fw">
        <div class="fw">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@place">
                <xsl:attribute name="data-place">
                    <xsl:value-of select="@place"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <!-- TEMPLATE MILESTONE -->
    <xsl:template match="tei:milestone[@rend]">
        <hr>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:value-of select="concat('milestone ', translate(@unit, ' ', '-'))"/>
            </xsl:attribute>
        </hr>
    </xsl:template>
    
    
    <!-- TEMPLATE SEG -->
    <xsl:template match="tei:seg">
        <span class="seg">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rend">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('seg hi ', @rend)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <!-- TEMPLATE NOTE -->
    <!-- Note di traduzione: soppresse qui perché gestite dal template foreign -->
    <xsl:template match="tei:note[@type='translation']"/>
    
    <!-- Note di glossa -->
    <xsl:template match="tei:note[@type='gloss']">
        <span class="note-gloss">(<xsl:apply-templates/>)</span>
    </xsl:template>
    
    <!-- Note generiche inline -->
    <xsl:template match="tei:note">
        <sup class="footnote-ref"><xsl:apply-templates/></sup>
    </xsl:template>
    
    
    <!-- TEMPLATE ROLENAME -->
    <xsl:template match="tei:roleName">
        <span class="entity roleName">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <!-- TEMPLATE NUM -->
    <xsl:template match="tei:num">
        <span class="num">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <!-- TEMPLATE MEASURE -->
    <xsl:template match="tei:measure">
        <span class="entity measure">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@type">
                <xsl:attribute name="data-type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <!-- Sopprime listPerson/listOrg dentro gli eventi -->
    <xsl:template match="tei:event/tei:listPerson | tei:event/tei:listOrg"/>
    
    
    <!-- TEMPLATE ABBR - abbreviazione standalone -->
    <xsl:template match="tei:abbr[not(parent::tei:choice)]">
        <abbr>
            <xsl:apply-templates/>
        </abbr>
    </xsl:template>
    
    
</xsl:stylesheet>
