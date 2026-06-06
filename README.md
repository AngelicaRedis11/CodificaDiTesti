# Codifica di Testi

Il progetto contenuto in questo repository è stato realizzato per l'esame di Codifica di Testi del Corso di Laurea Triennale in Informatica Umanistica con il professor Angelo Mario Del Grosso da Angelica Redis e Martina Pascarelli.


### Comando per la trasformazione 
Saxon: 12.4 HE

```
java -Djdk.xml.entityExpansionLimit=100000 -cp validazione/saxon-he-12.4.jar:validazione/xmlresolver.jar \
  net.sf.saxon.Transform \
  -s:Progetto_redis_pascarelli.xml \
  -xsl:stile_redis_pascarelli.xslt \
  -o:output.html
```

### Comando per la validazione 
Xerces: 2.12.2

```
java -cp "validazione/xml-apis.jar:validazione/xercesImpl.jar:validazione/xercesSamples.jar" \
  dom.Counter -v Progetto_redis_pascarelli.xml
```

Risultato: Progetto_redis_pascarelli.xml: 121;19;0 ms (2966 elems, 11970 attrs, 31858 spaces, 95564 chars)


