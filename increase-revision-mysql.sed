/[ \t]*#.*/bx
/revision/ s/^(.*)set([ \t]+)revision_client([ \t]+)([0-9]+)(.*)$/echo '\1set\2revision_client\3'$(( \4 + 1 ))'\5'/ge
:x
