findxerces () {
  if [ ! "$XERCES" ]; then
    for path in "/projects/apache/xml-xerces/java/build/classes" \
                "/usr/local/share/java/xerces.jar" \
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

findjaxp () {
  if [ ! "$JAXP" ]; then
    for path in "/usr/local/share/java/jaxp.jar" \
                "/usr/local/java/jaxp.jar" \
                "/usr/local/jaxp-1.1/jaxp.jar" \
                "/usr/local/share/java/jaxp-1.1/jaxp.jar" \
                "/usr/share/java/jaxp.jar" \
                "/usr/share/java/xercesImpl.jar"; do
      if [ -f "$path" -o -d "$path" ]; then
        JAXP="$path"
        break
      fi
    done
  fi
  echo $JAXP
}

findresolver () {
  if [ ! "$RESOLVER" ]; then
    for path in "/projects/apache/xml-commons/java/build/classes" \
                "/projects/sun/resolver/.classes" \
                "/usr/share/java/sun-resolver.jar"; do
      if [ -f "$path" -o -d "$path" ]; then
        RESOLVER="$path"
        echo found $path 1>&2
        break
      fi
    done
  fi
  echo $RESOLVER
}
