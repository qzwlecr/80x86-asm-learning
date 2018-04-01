#!/bin/bash
mv .git /tmp/asm_git_temp
mv doc /tmp/asm_doc_temp
for f in `find .`; do mv -v "$f" "`echo $f | tr '[A-Z]' '[a-z]'`"; done
mv /tmp/asm_git_temp .git
mv /tmp/asm_doc_temp doc
