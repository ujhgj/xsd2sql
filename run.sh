#!/bin/sh

FILES=xsd/*.xsd
for FILE in $FILES
do
    echo "Processing $FILE file..."
    FILENAME=$(basename "$FILE")
    TABLENAME="${FILENAME%.*}"
    echo "\tthat will be $TABLENAME table"
    java -jar saxon9ee.jar -s:$FILE -xsl:xsd2db.xslt -o:sql/$TABLENAME.sql
done