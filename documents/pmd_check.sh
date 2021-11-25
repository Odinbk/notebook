# echo ${PMD_RESULT}

set -x

PMD_RESULT="pmd.txt"
WORKSPACE=~

writeDefaultPMDResult(){
    cat > ${WORKSPACE}/pmd.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<pmd xmlns="http://pmd.sourceforge.net/report/2.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://pmd.sourceforge.net/report/2.0.0 http://pmd.sourceforge.net/report_2_0_0.xsd"
    version="6.6.0" timestamp="2018-09-13T15:44:03.457">
</pmd>
EOF
}

if ls ${PMD_RESULT} 1> /dev/null 2>&1; then
    grep "Mandatory arguments" ${PMD_RESULT}

    if [ $? -ne 0 ]; then
        cat ${PMD_RESULT} > ${WORKSPACE}/pmd.xml
    else
        writeDefaultPMDResult
    fi
else
    echo "pmd.xml file does not exist, create an empty one"
    writeDefaultPMDResult
fi

cat ${WORKSPACE}/pmd.xml