#!/bin/sh

FILE_LIST="diff_file_names.txt"
# STATIC_CODE_CHECK_HOME="~/Downloads/"

PMD="pmd-bin-6.6.0/bin/run.sh"
PMD_LOG="pmd.log"
PMD_EXIT_CODE=0

CODE_STYLE="checkstyle-8.12-all.jar"
CODE_STYLE_LOG="code_style.log"
CODE_STYLE_ERROR_MARK="WARN"
CODE_STYLE_EXIT_CODE=0

# Only changed files will be checked
git diff --cached --name-only '*.java' > ${FILE_LIST}

FILE_LIST_COUNT=$(wc -l < ${FILE_LIST} | awk '{$1=$1};1')
if [ ${FILE_LIST_COUNT} -eq 0 ]; then
    echo 'No file change detected'
rm -f ${FILE_LIST}
    exit 0
fi

# PMD Java Static Code Check
echo "starting PMD Java Static Code Check"
$(eval echo ${STATIC_CODE_CHECK_HOME}${PMD}) pmd -l java -R category/java/bestpractices.xml -filelist ${FILE_LIST} | tee ${PMD_LOG}

PMD_LOG_COUNT=$(wc -l < ${PMD_LOG} | awk '{$1=$1};1')
if [ ${PMD_LOG_COUNT} -ne 0 ]; then
    echo 'PMD Java code static check failed, please fix the complaints first.'
    PMD_EXIT_CODE=1
fi

# # Google Java Code Style Check
# echo "starting Google Java Code Style Check"
# java -jar $(eval echo ${STATIC_CODE_CHECK_HOME}${CODE_STYLE}) -c /google_checks.xml $(cat ${FILE_LIST}) | grep ${CODE_STYLE_ERROR_MARK} | tee ${CODE_STYLE_LOG}

# CODE_STYLE_LOG_COUNT=$(wc -l < ${CODE_STYLE_LOG} | awk '{$1=$1};1')
# if [ ${CODE_STYLE_LOG_COUNT} -ne 0 ]; then
#     echo 'Code Style check failed, please fix the complaints first.'
#     CODE_STYLE_EXIT_CODE=1
# fi

# Clean up the intermediary files
echo "starting clean up the intermediary files"
# rm -f ${FILE_LIST} ${PMD_LOG} ${CODE_STYLE_LOG}
rm -f ${FILE_LIST} ${PMD_LOG}

# Quit gracefully
if [ ${CODE_STYLE_EXIT_CODE} -ne 0 -a ${PMD_EXIT_CODE} -ne 0 ]; then
    exit 1
fi


