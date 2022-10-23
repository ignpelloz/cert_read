#!/bin/bash

full=0
fullWCert=0
onlyCert=0
url=""
json=0

# Options
while [[ "$1" != "" ]]; do

  if [[ "$1" == '--url' ]]; then
    url=$2
    shift
    shift

  elif [[ "$1" == '--full' ]]; then # 'openssl x509 -text -noout' 
    full=1
    shift

  elif [[ "$1" == '--fullWCert' ]]; then # 'openssl x509 -text' 
    fullWCert=1
    shift

  elif [[ "$1" == '--onlyCert' ]]; then # 'openssl x509' 
    onlyCert=1
    shift

  elif [[ "$1" == '--json' ]]; then # prints the details using jq-ready sintax
    json=1
    shift

  else
    echo "Usage: bash cert_read.sh --url URL_HERE"
    exit
  fi
done

# Check that a URL was provided and sanitize it
if [[ "$url" == "" ]]; then
    echo "The option --url is required" 
    exit
fi
url=$(echo $url | sed -e 's/https*:\/\///' -e 's/\/*$//g')

# Read cert without processing output, if requested
if [[ $full -eq 1 ]]; then
    : | openssl s_client -connect $url:443 | openssl x509 -in /dev/stdin -text -noout
    exit
fi
if [[ $fullWCert -eq 1 ]]; then
    : | openssl s_client -connect $url:443 | openssl x509 -in /dev/stdin -text
    exit
fi
if [[ $onlyCert -eq 1 ]]; then
    : | openssl s_client -connect $url:443 2>/dev/null | openssl x509 -in /dev/stdin
    exit
fi

# Read cert processing output
opensslOut=$(: | openssl s_client -connect $url:443 2>/dev/null | openssl x509 -in /dev/stdin -issuer -subject -dates -fingerprint -noout) # -purpose -serial

# Print the obtained output with some changes:
#  - Change some of the field names (i.e notBefore and notAfter with ValidFrom and ValidUntil respectively)
#  - Ignore purposes set to 'No'
echo "Requested URL: "$url
echo "$opensslOut" | sed -e 's/notBefore=/Valid From: /' -e 's/notAfter=/Valid Until: /' -e 's/issuer=/Issued By: /' -e 's/subject=/Issued To: /'  -e 's/SHA1 Fingerprint=/Fingerprint (SHA1): /' | grep -v No

