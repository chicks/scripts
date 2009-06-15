naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 100 3_3_0 3_3_1 3_3_2 3_3_3 3_3_4 2_4_0 2_4_1 2_4_2 2_4_3 2_4_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 110 3_3_5 3_3_6 3_3_7 3_3_8 3_3_9 2_4_5 2_4_6 2_4_7 2_4_8 2_4_9 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 120 1_3_0 1_3_1 1_3_2 1_3_3 1_3_4 0_4_0 0_4_1 0_4_2 0_4_3 0_4_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 130 1_3_5 1_3_6 1_3_7 1_3_8 1_3_9 1_3_10 1_3_11 0_4_5 0_4_6 0_4_7 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 140 3_3_10 3_3_11 3_3_12 3_3_13 2_4_10 2_4_11 2_4_12 2_4_13 1_3_12 1_3_13 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 26 0_3_10 0_3_11 0_3_12 0_3_13 2_3_10 2_3_11 2_3_12 2_3_13 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 260 -rg 26 -rc 1 -wc 1 -aa 0 -cap 700 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 261 -rg 26 -rc 1 -wc 1 -aa 0 -cap 700 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 27 1_0_10 1_0_11 1_0_12 1_0_13 2_0_10 2_0_11 2_0_12 2_0_13 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 270 -rg 27 -rc 1 -wc 1 -aa 0 -cap 700 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 271 -rg 27 -rc 1 -wc 1 -aa 0 -cap 200 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 28 2_1_10 2_1_11 2_1_12 2_1_13 3_1_10 3_1_11 3_1_12 3_1_13 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 280 -rg 28 -rc 1 -wc 1 -aa 0 -cap 200 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 281 -rg 28 -rc 1 -wc 1 -aa 0 -cap 500 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 29 0_2_10 0_2_11 0_2_12 0_2_13 1_2_10 1_2_11 1_2_12 1_2_13 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 290 -rg 29 -rc 1 -wc 1 -aa 0 -cap 200 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 10 0_1_0 0_1_1 0_1_2 0_1_3 0_1_4 1_1_0 1_1_1 1_1_2 1_1_3 1_1_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 107 -rg 10 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 108 -rg 10 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 11 0_1_5 0_1_6 0_1_7 0_1_8 0_1_9 1_1_5 1_1_6 1_1_7 1_1_8 1_1_9 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 109 -rg 11 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 117 -rg 11 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 12 0_1_10 0_1_11 0_1_12 0_1_13 0_2_14 1_1_10 1_1_11 1_1_12 1_1_13 1_2_14 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 118 -rg 12 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 119 -rg 12 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 13 0_2_0 0_2_1 0_2_2 0_2_3 0_2_4 1_2_0 1_2_1 1_2_2 1_2_3 1_2_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 127 -rg 13 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 128 -rg 13 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 14 0_2_5 0_2_6 0_2_7 0_2_8 0_2_9 1_2_5 1_2_6 1_2_7 1_2_8 1_2_9 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 129 -rg 14 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 137 -rg 14 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 createrg 15 1_0_0 1_0_1 1_0_2 1_0_3 1_0_4 2_0_0 2_0_1 2_0_2 2_0_3 2_0_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 138 -rg 15 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 139 -rg 15 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 16 1_0_5 1_0_6 1_0_7 1_0_8 1_0_9 2_0_5 2_0_6 2_0_7 2_0_8 2_0_9 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 147 -rg 16 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 148 -rg 16 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 17 2_1_0 2_1_1 2_1_2 2_1_3 2_1_4 3_1_0 3_1_1 3_1_2 3_1_3 3_1_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 149 -rg 17 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 150 -rg 17 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 18 2_1_5 2_1_6 2_1_7 2_1_8 2_1_9 3_1_5 3_1_6 3_1_7 3_1_8 3_1_9 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 151 -rg 18 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 152 -rg 18 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 19 2_2_0 2_2_1 2_2_2 2_2_3 2_2_4 3_2_0 3_2_1 3_2_2 3_2_3 3_2_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 153 -rg 19 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 154 -rg 19 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 20 2_2_5 2_2_6 2_2_7 2_2_8 2_2_9 3_2_5 3_2_6 3_2_7 3_2_8 3_2_9 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 155 -rg 20 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 156 -rg 20 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 21 2_2_10 2_2_11 2_2_12 2_2_13 2_2_14 3_2_10 3_2_11 3_2_12 3_2_13 3_2_14 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 157 -rg 21 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 158 -rg 21 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 22 3_0_0 3_0_1 3_0_2 3_0_3 3_0_4 0_3_0 0_3_1 0_3_2 0_3_3 0_3_4 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 159 -rg 22 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 160 -rg 22 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 23 3_0_5 3_0_6 3_0_7 3_0_8 3_0_9 0_3_5 0_3_6 0_3_7 0_3_8 0_3_9 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 161 -rg 23 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 162 -rg 23 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 24 2_3_5 2_3_6 2_3_7 2_3_8 2_3_9 0_0_5 0_0_6 0_0_7 0_0_8 0_0_9 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 163 -rg 24 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 164 -rg 24 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 createrg 25 3_0_10 3_0_11 3_0_12 3_0_13 2_3_0 2_3_1 2_3_2 2_3_3 2_3_4 2_3_14 -rm no
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.114 bind r1_0 165 -rg 25 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp b -elsz 128
naviseccli -User emc -Password emc -Scope 0 -h 10.40.7.113 bind r1_0 166 -rg 25 -rc 1 -wc 1 -aa 0 -cap 916 -sq gb -r Medium -v Low -sp a -elsz 128
