findxerces2 () {
  # xerces2, which requires two jars, xercesImpl.jar and xmlParserAPIs.jar
  if [ ! "$XERCES" ]; then
    for path in "/usr/local/share/java" \
                "/usr/local/java/xerces2" \
                "/usr/local/java" \
                "/usr/share/java"; do
      if [ -d "$path" -a -f "$path/xercesImpl.jar" -a \
	 		 -f "$path/xmlParserAPIs.jar" ]; then
        XERCES="$path/xercesImpl.jar:$path/xmlParserAPIs.jar"
        break
      fi
    done
  fi
  echo $XERCES
}

findcrimson () {
  # crimson, an older Java XML parser
  if [ ! "$CRIMSON" ]; then
    for path in "/usr/local/share/java/crimson.jar" \
                "/usr/local/java/crimson.jar" \
                "/usr/share/java/crimson.jar"; do
      if [ -f "$path" -o -d "$path" ]; then
        CRIMSON="$path"
        break
      fi
    done
  fi
  echo $CRIMSON
}

findxerces1 () {
  if [ ! "$XERCES" ]; then
    for path in "/usr/local/share/java/xerces.jar" \
                "/usr/local/java/xerces1/xerces.jar" \
                "/usr/local/java/xerces.jar" \
                "/usr/share/java/xerces.jar"; do
      if [ -f "$path" -o -d "$path" ]; then
        XERCES="$path"
        break
      fi
    done
  fi
  echo $XERCES
}

findresolver () {
  # Finding CatalogXMLReader.class
  # FIXME: use saxon-catalog.jar, cz/kosek/CatalogXMLReader.class
  # FIXME: return both CatalogXMLReader.class and jarfile
  if [ ! "$RESOLVER" ]; then
    for path in "/projects/apache/xml-commons/java/build/classes" \
                "/projects/sun/resolver/.classes" \
                "/usr/local/share/java/sun-resolver.jar" \
                "/usr/local/java/sun-resolver.jar" \
                "/usr/share/java/sun-resolver.jar"; do
      if [ -f "$path" -o -d "$path" ]; then
        RESOLVER="$path"
        break
      fi
    done
  fi
  echo $RESOLVER
}

fixclasspath () {
  local cp=$1
  # get rid of ::
  cp="${cp//::/:}"
  # we need shell extended glob functions
  shopt -s extglob
  # get rid of leading ':'
  cp="${cp#+(:)}"
  # get rid of trailing ':'
  cp="${cp%%+(:)}"
  # FIXME: get rid of duplicated entries
  if [ ${CLASSPATH_DEBUG} ] && ${CLASSPATH_DEBUG}; then
    echo "D: classpath is $cp" 1>&2
  fi
  echo $cp
}
