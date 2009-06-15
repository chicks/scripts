naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 removerg 0 
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 createrg 1 0_0_1 0_0_2 0_0_3 0_0_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r1_0 300 -rg 1 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 76 -alu 300

naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r1_0 301 -rg 29 -rc 1 -wc 1 -aa 1 -cap 650 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r1_0 302 -rg 29 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r1_0 303 -rg 28 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r1_0 304 -rg 27 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128

naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 77 -alu 301
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 78 -alu 302
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 79 -alu 303
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 80 -alu 304

naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r6 400 -rg 100 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r6 401 -rg 110 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r6 402 -rg 120 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r6 403 -rg 130 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 bind r6 404 -rg 140 -rc 1 -wc 1 -aa 1 -sq gb -r Medium -v Low -elsz 128

naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 81 -alu 400
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 82 -alu 401
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 83 -alu 402
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 84 -alu 403
naviseccli -User emc -Password emc -Scope 0 -h 10.40.15.114 storagegroup -addhlu -gname "PLADWS002SM" -hlu 85 -alu 404
