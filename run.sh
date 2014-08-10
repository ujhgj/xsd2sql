#!/bin/sh

# Saxon EE license check
if [ ! -f saxon-license.lic ]; then
    echo 'You need Saxon-EE license to launch this script. See more at http://saxonica.com/download/download.xml'
    exit 1
fi

# get Saxon EE
if [ ! -f saxon9ee.jar ]; then
    wget http://www.saxonica.com/download/SaxonEE9-4-0-9J.zip
    unzip SaxonEE9-4-0-9J.zip
    rm SaxonEE9-4-0-9J.zip
fi

# transform xsd files
FILES=xsd/*.xsd
for FILE in $FILES
do
    echo "Processing $FILE file..."
    FILENAME=$(basename "$FILE")
    TABLENAME="${FILENAME%.*}"
    echo "\tthat will be $TABLENAME table"
    java -jar saxon9ee.jar -s:$FILE -xsl:xsd2db.xslt -o:sql/$TABLENAME.sql
done