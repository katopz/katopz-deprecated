//Maya ASCII 8.5 scene
//Name: G2.ma
//Last modified: Tue, Nov 10, 2009 08:43:30 AM
//Codeset: 874
requires maya "8.5";
requires "COLLADA" "3.05B";
requires "stereoCamera" "10.0";
currentUnit -l centimeter -a degree -t ntsc;
fileInfo "application" "maya";
fileInfo "product" "Maya Unlimited 8.5";
fileInfo "version" "8.5";
fileInfo "cutIdentifier" "200809110030-734661";
fileInfo "osv" "Microsoft Windows XP Service Pack 3 (Build 2600)\n";
createNode transform -s -n "persp";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 5.3791310680309365 10.236928557632988 43.524188946437576 ;
	setAttr ".r" -type "double3" -5.1383527304539101 1087.7999999997007 5.0160257603169905e-017 ;
createNode camera -s -n "perspShape" -p "persp";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".fl" 34.999999999999986;
	setAttr ".coi" 49.030848731975837;
	setAttr ".imn" -type "string" "persp";
	setAttr ".den" -type "string" "persp_depth";
	setAttr ".man" -type "string" "persp_mask";
	setAttr ".tp" -type "double3" -0.0086095333099365234 6.5912013419438154 -0.0017712116241455078 ;
	setAttr ".hc" -type "string" "viewSet -p %camera";
createNode transform -s -n "top";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 100.1 0 ;
	setAttr ".r" -type "double3" -89.999999999999986 0 0 ;
createNode camera -s -n "topShape" -p "top";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 100.1;
	setAttr ".ow" 26.029874903340954;
	setAttr ".imn" -type "string" "top";
	setAttr ".den" -type "string" "top_depth";
	setAttr ".man" -type "string" "top_mask";
	setAttr ".hc" -type "string" "viewSet -t %camera";
	setAttr ".o" yes;
createNode transform -s -n "front";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0.29850070322709699 5.4867365004785214 100.1 ;
createNode camera -s -n "frontShape" -p "front";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 100.1;
	setAttr ".ow" 45.684834153461154;
	setAttr ".imn" -type "string" "front";
	setAttr ".den" -type "string" "front_depth";
	setAttr ".man" -type "string" "front_mask";
	setAttr ".hc" -type "string" "viewSet -f %camera";
	setAttr ".o" yes;
createNode transform -s -n "side";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 100.1 2.5697211155378481 -0.26892430278884394 ;
	setAttr ".r" -type "double3" 0 89.999999999999986 0 ;
createNode camera -s -n "sideShape" -p "side";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 100.1;
	setAttr ".ow" 15.126131060869856;
	setAttr ".imn" -type "string" "side";
	setAttr ".den" -type "string" "side_depth";
	setAttr ".man" -type "string" "side_mask";
	setAttr ".hc" -type "string" "viewSet -s %camera";
	setAttr ".o" yes;
createNode transform -n "S_G2";
	setAttr ".ove" yes;
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" -0.00036001205444335938 6.0189894567010924 0 ;
	setAttr ".sp" -type "double3" -0.00036001205444335938 6.0189894567010924 0 ;
createNode mesh -n "S_G2Shape" -p "S_G2";
	addAttr -ci true -sn "mso" -ln "miShadingSamplesOverride" -min 0 -max 1 -at "bool";
	addAttr -ci true -sn "msh" -ln "miShadingSamples" -min 0 -smx 8 -at "float";
	addAttr -ci true -sn "mdo" -ln "miMaxDisplaceOverride" -min 0 -max 1 -at "bool";
	addAttr -ci true -sn "mmd" -ln "miMaxDisplace" -min 0 -smx 1 -at "float";
	setAttr -k off ".v";
	setAttr -s 4 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".pv" -type "double2" 0.36845225095748901 0.34146726131439209 ;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".dr" 1;
createNode mesh -n "S_G2ShapeOrig" -p "S_G2";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 150 ".uvst[0].uvsp[0:149]" -type "float2" 0.96217608 0.35194349 
		0.97994697 0.26285061 0.929515 0.18728642 0.84042209 0.16951564 0.76485801 0.21994752 
		0.74708712 0.30904049 0.79751945 0.38460463 0.88661194 0.40237549 0.23506701 0.011913106 
		0.41273224 0.011913106 0.59041935 0.011913106 0.72368592 0.011913106 0.23520213 0.011913106 
		0.4128412 0.011913106 0.59051198 0.011913106 0.72369415 0.011913106 0.67932117 0.20488605 
		0.013210356 0.34146738 0.10182667 0.48968118 0.54593992 0.48968005 0.45727369 0.48968166 
		0.36823454 0.48968196 0.27940717 0.48968065 0.19090581 0.48968357 0.10169733 0.48968095 
		0.013204217 0.48968256 0.63455439 0.48968184 0.36820066 0.48968136 0.27951181 0.48968035 
		0.19065839 0.48968291 0.54614413 0.48968202 0.45702228 0.48968118 0.013225794 0.48967949 
		0.63487613 0.48968506 0.057528943 0.10844465 0.013220727 0.34146714 0.23506701 0.10844478 
		0.41273224 0.10844478 0.59041935 0.10844478 0.057543665 0.10844478 0.23520213 0.10844478 
		0.4128412 0.10844478 0.59051198 0.10844478 0.057543665 0.011913106 0.14622229 0.20488605 
		0.32392049 0.20488605 0.50162756 0.20488605 0.013210356 0.20488605 0.14637184 0.20488605 
		0.32395321 0.20488605 0.50169462 0.20488605 0.013220727 0.20488575 0.10183728 0.34146738 
		0.057528883 0.011913188 0.19060743 0.34146738 0.27952659 0.34146738 0.36831439 0.34146738 
		0.4571501 0.34146738 0.54610503 0.34146738 0.63473368 0.34146738 0.72368592 0.34146738 
		0.10187697 0.34146738 0.19086671 0.34146738 0.27953756 0.34146738 0.36836886 0.34146738 
		0.45731351 0.34146738 0.5460757 0.34146738 0.63494825 0.34146738 0.72369415 0.34146738 
		0.72368592 0.10844478 0.27120471 0.51635253 0.53079629 0.56866753 0.27120441 0.51635212 
		0.013162792 0.56698066 0.27120441 0.51635212 0.53079283 0.56867594 0.27120441 0.516352 
		0.013118656 0.5670048 0.27120465 0.51635242 0.53079414 0.56866735 0.27120441 0.51635212 
		0.013162792 0.56698066 0.27120441 0.516352 0.53079569 0.56867594 0.27120456 0.51635218 
		0.013162794 0.56698066 0.35964093 0.94578576 0.17305854 0.94586104 0.35945183 0.9457919 
		0.17309983 0.9458853 0.35968605 0.94580454 0.17305854 0.94586104 0.35950422 0.94578171 
		0.17308795 0.94586015 0.27129203 0.75886333 0.43748668 0.79256392 0.27129203 0.75886333 
		0.10532209 0.79151088 0.27129203 0.75886333 0.43690273 0.79264152 0.27141547 0.75924921 
		0.10523865 0.79177183 0.27130541 0.75922072 0.4374398 0.79280567 0.27129203 0.75886333 
		0.10532212 0.79151094 0.27129203 0.75886333 0.43709409 0.79233968 0.2713744 0.75883156 
		0.10535857 0.79126924 0.74536532 0.63971299 0.8522073 0.74996871 0.74135017 0.85919857 
		0.63350904 0.74817586 0.10183728 0.44662493 0.72369415 0.10844478 0.19060743 0.44662493 
		0.27952659 0.44662493 0.36831439 0.44662493 0.4571501 0.44662493 0.54610503 0.44662493 
		0.63473368 0.44662493 0.013210356 0.44662493 0.10187697 0.44662493 0.19086671 0.44662493 
		0.27953756 0.44662493 0.36836886 0.44662493 0.45731351 0.44662493 0.5460757 0.44662493 
		0.63494825 0.44662493 0.013220727 0.4466247 0.67920983 0.20488605 0.72369415 0.44662493 
		0.72368592 0.44662493 0.72369897 0.48967949 0.72367966 0.48968256 0.90919244 0.91527337 
		0.73948681 0.98653078 0.50581658 0.74656427 0.91357738 0.5869934 0.17308795 0.94586015 
		0.5805155 0.57612073 0.97812688 0.74900234 0.17308795 0.94586015 0.57555854 0.91851807 
		0.013162792 0.56698066 0.75010496 0.51334006 0.10532209 0.79151088 0.10532212 0.79151094 
		0.013162792 0.56698066;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 20 ".pt[64:83]" -type "float3"  0 0.1378784 0 0 0.1378784 
		0 0 0.1378784 0 0 0.1378784 0 0 0.1378784 0 0 0.1378784 0 0 0.1378784 0 0 0.1378784 
		0 0 0.1378784 0 0 0.1378784 0 0 0.1378784 0 0 0.1378784 0 0 0.1378784 0 0 0.1128158 
		0 0 0.1128158 0 0 0.1128158 0 -0.23013806 0.082195558 -0.11403826 -0.15818274 0.082195558 
		0.16591273 0.23013806 0.082195558 0.11403825 0.15818273 0.082195558 -0.16591273;
	setAttr -s 100 ".vt[0:99]"  2.38413 -0.0021188874 -1.5478364 0.59139907 
		-0.0021188874 -2.7800496 -1.5475599 -0.0021188874 -2.3837039 -2.7797725 -0.0021188874 
		-0.59097326 -2.3834262 -0.0021188874 1.547985 -0.59069508 -0.0021188874 2.7801979 
		1.548263 -0.0021188874 2.3838515 2.7804756 -0.0021188874 0.59112072 2.7804756 1.221987 
		0.59112072 2.38413 1.221987 -1.5478364 0.59139907 1.221987 -2.7800496 -1.5475599 
		1.221987 -2.3837039 -2.7797725 1.221987 -0.59097326 -2.3834262 1.221987 1.547985 
		-0.59069508 1.221987 2.7801979 1.548263 1.221987 2.3838515 4.0905824 2.5198612 -0.75783998 
		2.3566554 2.5198612 -3.4280815 -0.75756234 2.5198612 -4.0901566 -3.4278045 2.5198612 
		-2.3562295 -4.089879 2.5198612 0.7579881 -2.355952 2.5198612 3.428231 0.75826645 
		2.5198612 4.0903049 3.4285088 2.5198612 2.3563769 5.295085 4.4385352 0.069075704 
		4.9184599 4.4385352 -1.9634544 3.7926888 4.4385352 -3.6971402 2.089159 4.4385352 
		-4.8680415 0.06721741 4.4385352 -5.2979012 -1.9653128 4.4385352 -4.921277 -3.6989977 
		4.4385352 -3.7955041 -4.8698988 4.4385352 -2.0919743 -5.2997589 4.4385352 -0.070032448 
		-4.9231339 4.4385352 1.9624975 -3.7973609 4.4385352 3.6961808 -2.0938306 4.4385352 
		4.8670821 -0.071889184 4.4385352 5.2969418 1.9606404 4.4385352 4.9203176 3.6943243 
		4.4385352 3.7945445 4.8652253 4.4385352 2.0910139 5.034008 6.7648149 0.064440764 
		4.6754985 6.7648149 -1.8703269 3.6038768 6.7648149 -3.5206223 1.9822851 6.7648149 
		-4.6352029 0.0575995 6.7648149 -5.0443883 -1.8771673 6.7648149 -4.6858792 -3.5274639 
		6.7648149 -3.6142552 -4.642045 6.7648149 -1.9926653 -5.0512276 6.7648149 -0.067978479 
		-4.692719 6.7648149 1.866787 -3.6210947 6.7648149 3.5170822 -1.9995037 6.7648149 
		4.6316633 -0.074816734 6.7648149 5.0408463 1.8599496 6.7648149 4.6823382 3.5102439 
		6.7648149 3.6107152 4.624825 6.7648149 1.9891237 2.6799886 10.198092 -0.50346738 
		1.5364412 10.198092 -2.2645266 -0.51742572 10.198092 -2.7011752 -2.2784846 10.198092 
		-1.5576267 -2.715132 10.198092 0.49624047 -1.571584 10.198092 2.2572997 0.48228371 
		10.198092 2.6939459 2.2433419 10.198092 1.5503986 4.2927136 8.4285145 0.053152915 
		3.9863334 8.4285145 -1.6002858 3.0705314 8.4285145 -3.0106175 1.684731 8.4285145 
		-3.9631317 0.039906256 8.4285145 -4.3128185 -1.6135322 8.4285145 -4.0064387 -3.0238645 
		8.4285145 -3.090636 -3.9763784 8.4285145 -1.7048357 -4.3260632 8.4285145 -0.060010478 
		-4.0196838 8.4285145 1.5934275 -3.1038814 8.4285145 3.0037582 -1.7180804 8.4285145 
		3.9562726 -0.073255524 8.4285145 4.3059583 1.5801831 8.4541988 3.9995792 2.9905136 
		8.4541988 3.0837762 3.943028 8.4541988 1.6979754 1.2743701 10.824235 0.88438737 0.87042964 
		10.824235 -1.2955555 -1.3095131 10.824235 -0.89161545 -0.90557253 10.824235 1.2883273 
		5.5528007 6.4930964 0.071252085 5.1574078 6.4930964 -2.0625668 3.975534 6.4930964 
		-3.882648 2.1871119 6.4930964 -5.1118979 0.064410768 6.4930964 -5.5631809 -2.0694075 
		6.4930964 -5.167788 -3.8894873 6.4930964 -3.9859123 -5.1187406 6.4930964 -2.1974919 
		-5.5700197 6.4930964 -0.074788891 -5.1746264 6.4930964 2.0590281 -3.9927533 6.4930964 
		3.8791072 -2.2043302 6.4930964 5.1083593 -0.081628658 6.4930964 5.5596385 2.0521896 
		6.4930964 5.164247 3.8722684 6.4930964 3.9823735 5.1015401 6.4942174 2.1939542;
	setAttr -s 221 ".ed";
	setAttr ".ed[0:165]"  7 0 0 1 2 0 2 3 
		0 3 4 0 5 6 0 6 7 0 7 8 
		1 0 9 1 1 10 1 2 11 1 3 12 
		1 4 13 1 5 14 1 6 15 1 3 7 
		1 8 16 1 9 16 1 9 17 1 10 17 
		1 10 18 1 11 18 1 11 19 1 12 19 
		1 12 20 1 13 20 1 13 21 1 14 21 
		1 14 22 1 15 22 1 15 23 1 8 23 
		1 9 8 0 10 9 0 11 10 0 12 11 
		0 13 12 0 14 13 0 15 14 0 8 15 
		0 17 16 1 18 17 1 19 18 1 20 19 
		1 21 20 1 22 21 1 23 22 1 16 23 
		1 25 24 1 26 25 1 27 26 1 28 27 
		1 29 28 1 30 29 1 31 30 1 32 31 
		1 33 32 1 34 33 1 35 34 1 37 36 
		1 38 37 1 39 38 1 24 39 1 16 24 
		1 16 25 1 17 26 1 17 27 1 18 28 
		1 18 29 1 19 30 1 19 31 1 20 32 
		1 20 33 1 21 34 1 21 35 1 22 36 
		1 22 37 1 23 38 1 23 39 1 24 84 
		1 25 85 1 26 86 1 27 87 1 28 88 
		1 29 89 1 30 90 1 31 91 1 32 92 
		1 33 93 1 34 94 1 35 95 1 36 96 
		1 37 97 1 38 98 1 39 99 1 40 41 
		0 41 42 0 42 43 0 43 44 0 44 45 
		0 45 46 0 46 47 0 47 48 0 48 49 
		0 49 50 0 51 52 0 52 53 0 53 54 
		0 54 55 0 55 40 0 40 64 1 41 65 
		1 56 81 1 56 80 1 42 66 1 56 57 
		1 43 67 1 57 81 1 44 68 1 57 58 
		1 58 81 1 45 69 1 58 82 1 46 70 
		1 58 59 1 47 71 1 59 82 1 48 72 
		1 59 60 1 60 82 1 49 73 1 60 83 
		1 50 74 1 60 61 1 61 83 1 51 75 
		1 52 76 1 61 62 1 53 77 1 62 80 
		1 54 78 1 62 63 1 55 79 1 63 80 
		1 63 56 1 65 64 1 66 65 1 67 66 
		1 68 67 1 69 68 1 70 69 1 71 70 
		1 72 71 1 73 72 1 74 73 1 75 74 
		1 77 76 1 78 77 1 79 78 1 64 79 
		1 81 80 1 82 81 1 83 82 1 80 83 
		1 64 56 1 65 56 1 66 57 1;
	setAttr ".ed[166:220]" 67 57 1 68 58 1 69 58 
		1 70 59 1 71 59 1 72 60 1 73 60 
		1 74 61 1 75 61 1 76 62 1 77 62 
		1 78 63 1 79 63 1 7 2 1 2 0 
		1 0 1 0 3 6 1 6 4 1 4 5 
		0 84 40 1 85 41 1 86 42 1 87 43 
		1 88 44 1 89 45 1 90 46 1 91 47 
		1 92 48 1 93 49 1 94 50 1 95 51 
		1 96 52 1 97 53 1 98 54 1 99 55 
		1 85 84 1 86 85 1 87 86 1 88 87 
		1 89 88 1 90 89 1 91 90 1 92 91 
		1 93 92 1 94 93 1 95 94 1 97 96 
		1 98 97 1 99 98 1 84 99 1 50 51 
		0 62 83 1 76 75 1 96 95 1 36 35 
		1;
	setAttr -s 123 ".fc[0:122]" -type "polyFaces" 
		f 4 0 7 31 -7 
		mu 0 4 53 8 36 34 
		f 4 181 8 32 -8 
		mu 0 4 8 9 37 36 
		f 4 1 9 33 -9 
		mu 0 4 9 10 38 37 
		f 4 2 10 34 -10 
		mu 0 4 10 11 69 38 
		f 4 3 11 35 -11 
		mu 0 4 43 12 40 39 
		f 4 184 12 36 -12 
		mu 0 4 12 13 41 40 
		f 4 4 13 37 -13 
		mu 0 4 13 14 42 41 
		f 4 5 6 38 -14 
		mu 0 4 14 15 115 42 
		f 3 183 -4 182 
		mu 0 3 6 4 3 
		f 3 180 -1 179 
		mu 0 3 2 0 7 
		f 3 111 159 -113 
		mu 0 3 139 111 110 
		f 3 114 116 -112 
		mu 0 3 139 142 111 
		f 3 118 119 -117 
		mu 0 3 142 136 111 
		f 3 121 160 -120 
		mu 0 3 136 112 111 
		f 3 123 125 -122 
		mu 0 3 136 137 112 
		f 3 127 128 -126 
		mu 0 3 137 144 112 
		f 3 130 161 -129 
		mu 0 3 144 113 112 
		f 3 132 133 -131 
		mu 0 3 144 138 113 
		f 3 217 -134 136 
		mu 0 3 141 113 138 
		f 3 138 162 -218 
		mu 0 3 141 110 113 
		f 3 140 142 -139 
		mu 0 3 141 146 110 
		f 3 143 112 -143 
		mu 0 3 146 139 110 
		f 3 -32 16 -16 
		mu 0 3 34 36 44 
		f 3 17 39 -17 
		mu 0 3 36 45 44 
		f 3 -33 18 -18 
		mu 0 3 36 37 45 
		f 3 19 40 -19 
		mu 0 3 37 46 45 
		f 3 -34 20 -20 
		mu 0 3 37 38 46 
		f 3 21 41 -21 
		mu 0 3 38 131 46 
		f 3 -35 22 -22 
		mu 0 3 38 69 131 
		f 3 23 42 -23 
		mu 0 3 39 48 47 
		f 3 -36 24 -24 
		mu 0 3 39 40 48 
		f 3 25 43 -25 
		mu 0 3 40 49 48 
		f 3 -37 26 -26 
		mu 0 3 40 41 49 
		f 3 27 44 -27 
		mu 0 3 41 50 49 
		f 3 -38 28 -28 
		mu 0 3 41 42 50 
		f 3 29 45 -29 
		mu 0 3 42 16 50 
		f 3 -39 30 -30 
		mu 0 3 42 115 16 
		f 3 15 46 -31 
		mu 0 3 34 44 51 
		f 3 63 47 -63 
		mu 0 3 44 54 52 
		f 4 -40 64 48 -64 
		mu 0 4 44 45 55 54 
		f 3 65 49 -65 
		mu 0 3 45 56 55 
		f 4 -41 66 50 -66 
		mu 0 4 45 46 57 56 
		f 3 67 51 -67 
		mu 0 3 46 58 57 
		f 4 -42 68 52 -68 
		mu 0 4 46 131 59 58 
		f 3 69 53 -69 
		mu 0 3 131 60 59 
		f 4 -43 70 54 -70 
		mu 0 4 47 48 61 17 
		f 3 71 55 -71 
		mu 0 3 48 62 61 
		f 4 -44 72 56 -72 
		mu 0 4 48 49 63 62 
		f 3 -73 73 57 
		mu 0 3 63 49 64 
		f 4 -45 74 220 -74 
		mu 0 4 49 50 65 64 
		f 3 75 58 -75 
		mu 0 3 50 66 65 
		f 4 -46 76 59 -76 
		mu 0 4 50 16 67 66 
		f 3 77 60 -77 
		mu 0 3 16 68 67 
		f 4 -47 62 61 -78 
		mu 0 4 51 44 52 35 
		f 4 -48 79 201 -79 
		mu 0 4 52 54 116 114 
		f 4 -49 80 202 -80 
		mu 0 4 54 55 117 116 
		f 4 -50 81 203 -81 
		mu 0 4 55 56 118 117 
		f 4 -51 82 204 -82 
		mu 0 4 56 57 119 118 
		f 4 -52 83 205 -83 
		mu 0 4 57 58 120 119 
		f 4 -53 84 206 -84 
		mu 0 4 58 59 121 120 
		f 4 -54 85 207 -85 
		mu 0 4 59 60 133 121 
		f 4 -55 86 208 -86 
		mu 0 4 17 61 123 122 
		f 4 -56 87 209 -87 
		mu 0 4 61 62 124 123 
		f 4 -57 88 210 -88 
		mu 0 4 62 63 125 124 
		f 4 -89 -58 89 211 
		mu 0 4 125 63 64 126 
		f 4 90 219 -90 -221 
		mu 0 4 65 127 126 64 
		f 4 -59 91 212 -91 
		mu 0 4 65 66 128 127 
		f 4 -60 92 213 -92 
		mu 0 4 66 67 129 128 
		f 4 -61 93 214 -93 
		mu 0 4 67 68 132 129 
		f 4 -62 78 215 -94 
		mu 0 4 35 52 114 130 
		f 4 -95 -186 -202 186 
		mu 0 4 29 18 114 116 
		f 4 -96 -187 -203 187 
		mu 0 4 28 29 116 117 
		f 4 -97 -188 -204 188 
		mu 0 4 27 28 117 118 
		f 4 -98 -189 -205 189 
		mu 0 4 31 27 118 119 
		f 4 -99 -190 -206 190 
		mu 0 4 30 31 119 120 
		f 4 -100 -191 -207 191 
		mu 0 4 26 30 120 121 
		f 4 -101 -192 -208 192 
		mu 0 4 135 26 121 133 
		f 4 -102 -193 -209 193 
		mu 0 4 24 25 122 123 
		f 4 -103 -194 -210 194 
		mu 0 4 23 24 123 124 
		f 4 -104 -195 -211 195 
		mu 0 4 22 23 124 125 
		f 4 -196 -212 196 -217 
		mu 0 4 22 125 126 21 
		f 4 197 -105 -197 -220 
		mu 0 4 127 20 21 126 
		f 4 -106 -198 -213 198 
		mu 0 4 19 20 127 128 
		f 4 -107 -199 -214 199 
		mu 0 4 33 19 128 129 
		f 4 -108 -200 -215 200 
		mu 0 4 134 33 129 132 
		f 4 -109 -201 -216 185 
		mu 0 4 18 32 130 114 
		f 4 94 110 144 -110 
		mu 0 4 70 71 95 94 
		f 4 95 113 145 -111 
		mu 0 4 71 72 96 95 
		f 4 96 115 146 -114 
		mu 0 4 72 145 148 96 
		f 4 97 117 147 -116 
		mu 0 4 73 74 98 97 
		f 4 98 120 148 -118 
		mu 0 4 74 75 99 98 
		f 4 99 122 149 -121 
		mu 0 4 75 76 100 99 
		f 4 100 124 150 -123 
		mu 0 4 76 77 101 100 
		f 4 101 126 151 -125 
		mu 0 4 77 78 102 101 
		f 4 102 129 152 -127 
		mu 0 4 78 79 103 102 
		f 4 103 131 153 -130 
		mu 0 4 79 80 104 103 
		f 4 -132 216 134 154 
		mu 0 4 104 80 149 147 
		f 4 135 218 -135 104 
		mu 0 4 82 106 105 81 
		f 4 105 137 155 -136 
		mu 0 4 82 83 107 106 
		f 4 106 139 156 -138 
		mu 0 4 83 84 108 107 
		f 4 107 141 157 -140 
		mu 0 4 84 85 109 108 
		f 4 108 109 158 -142 
		mu 0 4 85 70 94 109 
		f 4 -163 -160 -161 -162 
		mu 0 4 113 110 111 112 
		f 3 -145 164 -164 
		mu 0 3 94 95 86 
		f 4 -146 165 -115 -165 
		mu 0 4 95 96 87 86 
		f 3 -147 166 -166 
		mu 0 3 96 148 87 
		f 4 -148 167 -119 -167 
		mu 0 4 97 98 88 140 
		f 3 -149 168 -168 
		mu 0 3 98 99 88 
		f 4 -150 169 -124 -169 
		mu 0 4 99 100 89 88 
		f 3 -151 170 -170 
		mu 0 3 100 101 89 
		f 4 -152 171 -128 -171 
		mu 0 4 101 102 90 89 
		f 3 -153 172 -172 
		mu 0 3 102 103 90 
		f 4 -154 173 -133 -173 
		mu 0 4 103 104 91 90 
		f 3 -174 -155 174 
		mu 0 3 91 104 147 
		f 4 175 -137 -175 -219 
		mu 0 4 106 92 143 105 
		f 3 -156 176 -176 
		mu 0 3 106 107 92 
		f 4 -157 177 -141 -177 
		mu 0 4 107 108 93 92 
		f 3 -158 178 -178 
		mu 0 3 108 109 93 
		f 4 -159 163 -144 -179 
		mu 0 4 109 94 86 93 
		f 3 -180 -15 -3 
		mu 0 3 2 7 3 
		f 3 -181 -2 -182 
		mu 0 3 0 2 1 
		f 3 -183 14 -6 
		mu 0 3 6 3 7 
		f 3 -184 -5 -185 
		mu 0 3 4 6 5 ;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".bw" 3;
createNode joint -n "G2_Joint1";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -bt "lock" -min 0 -max 1 
		-at "bool";
	setAttr ".uoc" yes;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".bps" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".radi" 0.78386490141512555;
createNode joint -n "G2_Joint2" -p "G2_Joint1";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -bt "lock" -min 0 -max 1 
		-at "bool";
	setAttr ".uoc" yes;
	setAttr ".oc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".bps" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 6.4878856512006422 0 1;
	setAttr ".radi" 0.78386490141512555;
	setAttr ".liw" yes;
createNode lightLinker -n "lightLinker1";
	setAttr -s 4 ".lnk";
	setAttr -s 4 ".slnk";
createNode displayLayerManager -n "layerManager";
	setAttr ".cdl" 2;
	setAttr -s 4 ".dli[1:3]"  1 2 3;
createNode displayLayer -n "defaultLayer";
createNode renderLayerManager -n "renderLayerManager";
createNode renderLayer -n "defaultRenderLayer";
	setAttr ".g" yes;
createNode script -n "uiConfigurationScriptNode";
	setAttr ".b" -type "string" (
		"// Maya Mel UI Configuration File.\n//\n//  This script is machine generated.  Edit at your own risk.\n//\n//\n\nglobal string $gMainPane;\nif (`paneLayout -exists $gMainPane`) {\n\n\tglobal int $gUseScenePanelConfig;\n\tint    $useSceneConfig = $gUseScenePanelConfig;\n\tint    $menusOkayInPanels = `optionVar -q allowMenusInPanels`;\tint    $nVisPanes = `paneLayout -q -nvp $gMainPane`;\n\tint    $nPanes = 0;\n\tstring $editorName;\n\tstring $panelName;\n\tstring $itemFilterName;\n\tstring $panelConfig;\n\n\t//\n\t//  get current state of the UI\n\t//\n\tsceneUIReplacement -update $gMainPane;\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"Stereo\" (localizedPanelLabel(\"Stereo\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"Stereo\" -l (localizedPanelLabel(\"Stereo\")) -mbv $menusOkayInPanels `;\nstring $editorName = ($panelName+\"Editor\");\n            stereoCameraView -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n"
		+ "                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 1\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -colorResolution 4 4 \n"
		+ "                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n"
		+ "                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -shadows 0\n                -displayMode \"centerEye\" \n                -viewColor 0 0 0 1 \n                $editorName;\nstereoCameraView -e -viewSelected 0 $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Stereo\")) -mbv $menusOkayInPanels  $panelName;\nstring $editorName = ($panelName+\"Editor\");\n            stereoCameraView -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -wireframeOnShaded 0\n"
		+ "                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 1\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n"
		+ "                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n"
		+ "                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -shadows 0\n                -displayMode \"centerEye\" \n                -viewColor 0 0 0 1 \n                $editorName;\nstereoCameraView -e -viewSelected 0 $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Top View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Top View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"top\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -wireframeOnShaded 0\n"
		+ "                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 1\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n"
		+ "                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n"
		+ "                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -shadows 0\n                $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Top View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"top\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"wireframe\" \n            -activeOnly 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 1\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n"
		+ "            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 8192\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -maxConstantTransparency 1\n            -colorResolution 4 4 \n            -bumpResolution 4 4 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 0\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n"
		+ "            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -shadows 0\n            $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Side View\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Side View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"side\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 1\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n"
		+ "                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n"
		+ "                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -shadows 0\n                $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Side View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"side\" \n"
		+ "            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"wireframe\" \n            -activeOnly 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 1\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 8192\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -maxConstantTransparency 1\n            -colorResolution 4 4 \n            -bumpResolution 4 4 \n            -textureCompression 0\n"
		+ "            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 0\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n"
		+ "            -locators 1\n            -manipulators 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -shadows 0\n            $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Front View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Front View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"front\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 1\n"
		+ "                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n"
		+ "                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -dimensions 1\n                -handles 1\n"
		+ "                -pivots 1\n                -textures 1\n                -strokes 1\n                -shadows 0\n                $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Front View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"front\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"wireframe\" \n            -activeOnly 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 1\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n"
		+ "            -textureDisplay \"modulate\" \n            -textureMaxSize 8192\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -maxConstantTransparency 1\n            -colorResolution 4 4 \n            -bumpResolution 4 4 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 0\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n"
		+ "            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -shadows 0\n            $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Persp View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n"
		+ "            modelEditor -e \n                -camera \"front\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 1\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 1\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n"
		+ "                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -rendererName \"base_OpenGL_Renderer\" \n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n"
		+ "                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -shadows 0\n                $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"front\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n"
		+ "            -activeOnly 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 1\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 1\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 8192\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -maxConstantTransparency 1\n            -rendererName \"base_OpenGL_Renderer\" \n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n"
		+ "            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n"
		+ "            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -shadows 0\n            $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"outlinerPanel\" (localizedPanelLabel(\"Outliner\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `outlinerPanel -unParent -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            outlinerEditor -e \n                -showShapes 0\n                -showAttributes 0\n                -showConnected 0\n                -showAnimCurvesOnly 0\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 1\n                -showAssets 1\n                -showContainedOnly 1\n                -showPublishedAsConnected 0\n"
		+ "                -showContainerContents 1\n                -ignoreDagHierarchy 0\n                -expandConnections 0\n                -showUnitlessCurves 1\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 0\n                -highlightActive 1\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"defaultSetFilter\" \n                -showSetMembers 1\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n"
		+ "                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\toutlinerPanel -edit -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        outlinerEditor -e \n            -showShapes 0\n            -showAttributes 0\n            -showConnected 0\n            -showAnimCurvesOnly 0\n            -showMuteInfo 0\n            -organizeByLayer 1\n            -showAnimLayerWeight 1\n            -autoExpandLayers 1\n            -autoExpand 0\n            -showDagOnly 1\n            -showAssets 1\n            -showContainedOnly 1\n            -showPublishedAsConnected 0\n            -showContainerContents 1\n            -ignoreDagHierarchy 0\n            -expandConnections 0\n            -showUnitlessCurves 1\n            -showCompounds 1\n            -showLeafs 1\n            -showNumericAttrsOnly 0\n            -highlightActive 1\n            -autoSelectNewObjects 0\n"
		+ "            -doNotSelectNewObjects 0\n            -dropIsParent 1\n            -transmitFilters 0\n            -setFilter \"defaultSetFilter\" \n            -showSetMembers 1\n            -allowMultiSelection 1\n            -alwaysToggleSelect 0\n            -directSelect 0\n            -displayMode \"DAG\" \n            -expandObjects 0\n            -setsIgnoreFilters 1\n            -containersIgnoreFilters 0\n            -editAttrName 0\n            -showAttrValues 0\n            -highlightSecondary 0\n            -showUVAttrsOnly 0\n            -showTextureNodesOnly 0\n            -attrAlphaOrder \"default\" \n            -animLayerFilterOptions \"allAffecting\" \n            -sortOrder \"none\" \n            -longNames 0\n            -niceNames 1\n            -showNamespace 1\n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"graphEditor\" (localizedPanelLabel(\"Graph Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"graphEditor\" -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels `;\n"
		+ "\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n"
		+ "                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 1\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n"
		+ "                -showResults \"off\" \n                -showBufferCurves \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1.25\n                -resultScreenSamples 0\n                -resultUpdate \"delayed\" \n                -constrainDrag 0\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n"
		+ "                -expandConnections 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n"
		+ "                -niceNames 1\n                -showNamespace 1\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 1\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showResults \"off\" \n                -showBufferCurves \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1.25\n                -resultScreenSamples 0\n                -resultUpdate \"delayed\" \n                -constrainDrag 0\n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dopeSheetPanel\" (localizedPanelLabel(\"Dope Sheet\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dopeSheetPanel\" -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels `;\n"
		+ "\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n"
		+ "                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n"
		+ "                -outliner \"dopeSheetPanel1OutlineEd\" \n                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n"
		+ "                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n"
		+ "                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -outliner \"dopeSheetPanel1OutlineEd\" \n                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"clipEditorPanel\" (localizedPanelLabel(\"Trax Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"clipEditorPanel\" -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n"
		+ "            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperGraphPanel\" (localizedPanelLabel(\"Hypergraph Hierarchy\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"hyperGraphPanel\" -l (localizedPanelLabel(\"Hypergraph Hierarchy\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"HyperGraphEd\");\n            hyperGraph -e \n                -graphLayoutStyle \"hierarchicalLayout\" \n                -orientation \"horiz\" \n                -mergeConnections 0\n                -zoom 1\n                -animateTransition 0\n                -showRelationships 1\n                -showShapes 0\n                -showDeformers 0\n                -showExpressions 0\n                -showConstraints 0\n                -showUnderworld 0\n                -showInvisible 0\n                -transitionFrames 1\n                -opaqueContainers 0\n                -freeform 0\n                -imagePosition 0 0 \n                -imageScale 1\n                -imageEnabled 0\n                -graphType \"DAG\" \n                -heatMapDisplay 0\n                -updateSelection 1\n                -updateNodeAdded 1\n"
		+ "                -useDrawOverrideColor 0\n                -limitGraphTraversal -1\n                -range 0 0 \n                -iconSize \"smallIcons\" \n                -showCachedConnections 0\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypergraph Hierarchy\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"HyperGraphEd\");\n            hyperGraph -e \n                -graphLayoutStyle \"hierarchicalLayout\" \n                -orientation \"horiz\" \n                -mergeConnections 0\n                -zoom 1\n                -animateTransition 0\n                -showRelationships 1\n                -showShapes 0\n                -showDeformers 0\n                -showExpressions 0\n                -showConstraints 0\n                -showUnderworld 0\n                -showInvisible 0\n                -transitionFrames 1\n                -opaqueContainers 0\n                -freeform 0\n                -imagePosition 0 0 \n                -imageScale 1\n"
		+ "                -imageEnabled 0\n                -graphType \"DAG\" \n                -heatMapDisplay 0\n                -updateSelection 1\n                -updateNodeAdded 1\n                -useDrawOverrideColor 0\n                -limitGraphTraversal -1\n                -range 0 0 \n                -iconSize \"smallIcons\" \n                -showCachedConnections 0\n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperShadePanel\" (localizedPanelLabel(\"Hypershade\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"hyperShadePanel\" -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"visorPanel\" (localizedPanelLabel(\"Visor\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"visorPanel\" -l (localizedPanelLabel(\"Visor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Visor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"polyTexturePlacementPanel\" (localizedPanelLabel(\"UV Texture Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"polyTexturePlacementPanel\" -l (localizedPanelLabel(\"UV Texture Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"UV Texture Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"multiListerPanel\" (localizedPanelLabel(\"Multilister\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"multiListerPanel\" -l (localizedPanelLabel(\"Multilister\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Multilister\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"renderWindowPanel\" (localizedPanelLabel(\"Render View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"renderWindowPanel\" -l (localizedPanelLabel(\"Render View\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Render View\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"blendShapePanel\" (localizedPanelLabel(\"Blend Shape\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\tblendShapePanel -unParent -l (localizedPanelLabel(\"Blend Shape\")) -mbv $menusOkayInPanels ;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tblendShapePanel -edit -l (localizedPanelLabel(\"Blend Shape\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dynRelEdPanel\" (localizedPanelLabel(\"Dynamic Relationships\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dynRelEdPanel\" -l (localizedPanelLabel(\"Dynamic Relationships\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dynamic Relationships\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"devicePanel\" (localizedPanelLabel(\"Devices\")) `;\n\tif (\"\" == $panelName) {\n"
		+ "\t\tif ($useSceneConfig) {\n\t\t\tdevicePanel -unParent -l (localizedPanelLabel(\"Devices\")) -mbv $menusOkayInPanels ;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tdevicePanel -edit -l (localizedPanelLabel(\"Devices\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"relationshipPanel\" (localizedPanelLabel(\"Relationship Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"relationshipPanel\" -l (localizedPanelLabel(\"Relationship Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Relationship Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"referenceEditorPanel\" (localizedPanelLabel(\"Reference Editor\")) `;\n\tif (\"\" == $panelName) {\n"
		+ "\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"referenceEditorPanel\" -l (localizedPanelLabel(\"Reference Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Reference Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"componentEditorPanel\" (localizedPanelLabel(\"Component Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"componentEditorPanel\" -l (localizedPanelLabel(\"Component Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Component Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dynPaintScriptedPanelType\" (localizedPanelLabel(\"Paint Effects\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dynPaintScriptedPanelType\" -l (localizedPanelLabel(\"Paint Effects\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Paint Effects\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"webBrowserPanel\" (localizedPanelLabel(\"Web Browser\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"webBrowserPanel\" -l (localizedPanelLabel(\"Web Browser\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Web Browser\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"scriptEditorPanel\" (localizedPanelLabel(\"Script Editor\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"scriptEditorPanel\" -l (localizedPanelLabel(\"Script Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Script Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\tif ($useSceneConfig) {\n        string $configName = `getPanel -cwl (localizedPanelLabel(\"Current Layout\"))`;\n        if (\"\" != $configName) {\n\t\t\tpanelConfiguration -edit -label (localizedPanelLabel(\"Current Layout\")) \n\t\t\t\t-defaultImage \"\"\n\t\t\t\t-image \"\"\n\t\t\t\t-sc false\n\t\t\t\t-configString \"global string $gMainPane; paneLayout -e -cn \\\"single\\\" -ps 1 100 100 $gMainPane;\"\n\t\t\t\t-removeAllPanels\n\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Persp View\")) \n\t\t\t\t\t\"modelPanel\"\n"
		+ "\t\t\t\t\t\"$panelName = `modelPanel -unParent -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -camera \\\"front\\\" \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"smoothShaded\\\" \\n    -activeOnly 0\\n    -wireframeOnShaded 0\\n    -headsUpDisplay 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 1\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 1\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 8192\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -maxConstantTransparency 1\\n    -rendererName \\\"base_OpenGL_Renderer\\\" \\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 1\\n    -hulls 1\\n    -grid 1\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -fluids 1\\n    -hairSystems 1\\n    -follicles 1\\n    -nCloths 1\\n    -nParticles 1\\n    -nRigids 1\\n    -dynamicConstraints 1\\n    -locators 1\\n    -manipulators 1\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -shadows 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName\"\n"
		+ "\t\t\t\t\t\"modelPanel -edit -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -camera \\\"front\\\" \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"smoothShaded\\\" \\n    -activeOnly 0\\n    -wireframeOnShaded 0\\n    -headsUpDisplay 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 1\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 1\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 8192\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -maxConstantTransparency 1\\n    -rendererName \\\"base_OpenGL_Renderer\\\" \\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 1\\n    -hulls 1\\n    -grid 1\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -fluids 1\\n    -hairSystems 1\\n    -follicles 1\\n    -nCloths 1\\n    -nParticles 1\\n    -nRigids 1\\n    -dynamicConstraints 1\\n    -locators 1\\n    -manipulators 1\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -shadows 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName\"\n"
		+ "\t\t\t\t$configName;\n\n            setNamedPanelLayout (localizedPanelLabel(\"Current Layout\"));\n        }\n\n        panelHistory -e -clear mainPanelHistory;\n        setFocus `paneLayout -q -p1 $gMainPane`;\n        sceneUIReplacement -deleteRemaining;\n        sceneUIReplacement -clear;\n\t}\n\n\ngrid -spacing 5 -size 12 -divisions 5 -displayAxes yes -displayGridLines yes -displayDivisionLines yes -displayPerspectiveLabels no -displayOrthographicLabels no -displayAxesBold yes -perspectiveLabelPosition axis -orthographicLabelPosition edge;\nviewManip -drawCompass 0 -compassAngle 0 -frontParameters \"\" -homeParameters \"\" -selectionLockParameters \"\";\n}\n");
	setAttr ".st" 3;
createNode script -n "sceneConfigurationScriptNode";
	setAttr ".b" -type "string" "playbackOptions -min 1 -max 60 -ast 1 -aet 60 ";
	setAttr ".st" 6;
createNode objectSet -n "modelPanel4ViewSelectedSet";
	setAttr ".ihi" 0;
createNode lambert -n "M_G2";
createNode shadingEngine -n "lambert4SG";
	setAttr ".ihi" 0;
	setAttr ".ro" yes;
createNode materialInfo -n "materialInfo7";
createNode file -n "file4";
	setAttr ".ftn" -type "string" "C:/Documents and Settings/BOBO/Desktop/Oishi_Project/Item/G2/G2.png";
createNode place2dTexture -n "place2dTexture5";
createNode skinCluster -n "skinCluster1";
	setAttr -s 100 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr -s 2 ".wl[16].w[0:1]"  0.9 0.099999999999999978;
	setAttr -s 2 ".wl[17].w[0:1]"  0.9 0.099999999999999978;
	setAttr -s 2 ".wl[18].w[0:1]"  0.9 0.099999999999999978;
	setAttr -s 2 ".wl[19].w[0:1]"  0.9 0.099999999999999978;
	setAttr -s 2 ".wl[20].w[0:1]"  0.9 0.099999999999999978;
	setAttr -s 2 ".wl[21].w[0:1]"  0.9 0.099999999999999978;
	setAttr -s 2 ".wl[22].w[0:1]"  0.9 0.099999999999999978;
	setAttr -s 2 ".wl[23].w[0:1]"  0.9 0.099999999999999978;
	setAttr -s 2 ".wl[24].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[25].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[26].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[27].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[28].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[29].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[30].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[31].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[32].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[33].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[34].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[35].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[36].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[37].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[38].w[0:1]"  0.8 0.19999999999999996;
	setAttr -s 2 ".wl[39].w[0:1]"  0.56932948683808471 0.43067051316191529;
	setAttr -s 2 ".wl[40].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[41].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[42].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[43].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[44].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[45].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[46].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[47].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[48].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[49].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[50].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[51].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[52].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[53].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[54].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[55].w[0:1]"  0.5 0.5;
	setAttr ".wl[56].w[1]"  1;
	setAttr ".wl[57].w[1]"  1;
	setAttr ".wl[58].w[1]"  1;
	setAttr ".wl[59].w[1]"  1;
	setAttr ".wl[60].w[1]"  1;
	setAttr ".wl[61].w[1]"  1;
	setAttr ".wl[62].w[1]"  1;
	setAttr ".wl[63].w[1]"  1;
	setAttr -s 2 ".wl[64].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[65].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[66].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[67].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[68].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[69].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[70].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[71].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[72].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[73].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[74].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[75].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[76].w[0:1]"  0.1 0.9;
	setAttr -s 2 ".wl[77].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[78].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[79].w[0:1]"  0.5 0.5;
	setAttr ".wl[80].w[1]"  1;
	setAttr ".wl[81].w[1]"  1;
	setAttr ".wl[82].w[1]"  1;
	setAttr ".wl[83].w[1]"  1;
	setAttr -s 2 ".wl[84].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[85].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[86].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[87].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[88].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[89].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[90].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[91].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[92].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[93].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[94].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[95].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[96].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[97].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[98].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".wl[99].w[0:1]"  0.5 0.5;
	setAttr -s 2 ".pm";
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".pm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 -6.4878856512006422 0 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr -s 2 ".ma";
	setAttr -s 2 ".dpf[0:1]"  4 4;
	setAttr -s 2 ".lw";
	setAttr -s 2 ".lw";
	setAttr ".mmi" yes;
	setAttr ".mi" 5;
	setAttr ".ucm" yes;
createNode tweak -n "tweak1";
createNode objectSet -n "skinCluster1Set";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster1GroupId";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster1GroupParts";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet1";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId2";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts2";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose2";
	setAttr -s 2 ".wm";
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 6.4878856512006422 0 0
		 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr ".bp" yes;
createNode animCurveTU -n "G2_Joint1_scaleX";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 14 ".ktv[0:13]"  1 1 4 1 6 1 10 1 14 1 20 1 27 1 30 1 36 
		1 40 1 44 1 48 1 55 1 60 1;
createNode animCurveTU -n "G2_Joint1_scaleY";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 14 ".ktv[0:13]"  1 1 4 0.7164901231358326 6 0.7164901231358326 
		10 1.1214004326070013 14 1 20 1 27 1.0400920820766664 30 0.78046997684810948 36 1.0795655826920485 
		40 0.936903325216909 44 1.0606667145909578 48 1.0134103524813654 55 1.0624725858770725 
		60 1.0357033461119385;
	setAttr -s 14 ".kit[8:13]"  1 10 10 10 10 10;
	setAttr -s 14 ".kot[8:13]"  1 10 10 10 10 10;
	setAttr -s 14 ".kix[8:13]"  0.95182669162750244 0.99749809503555298 
		1 1 1 1;
	setAttr -s 14 ".kiy[8:13]"  0.30663648247718811 -0.070693448185920715 
		0 0 0 0;
	setAttr -s 14 ".kox[8:13]"  0.95182675123214722 0.99749809503555298 
		1 1 1 1;
	setAttr -s 14 ".koy[8:13]"  0.3066365122795105 -0.070693448185920715 
		0 0 0 0;
createNode animCurveTU -n "G2_Joint1_scaleZ";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 14 ".ktv[0:13]"  1 1 4 1 6 1 10 1 14 1 20 1 27 1 30 1 36 
		1 40 1 44 1 48 1 55 1 60 1;
createNode animCurveTL -n "G2_Joint1_translateX";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 14 ".ktv[0:13]"  1 0 4 0 6 0 10 0 14 0 20 0 27 0 30 0 36 
		0 40 0 44 0 48 0 55 0 60 0;
createNode animCurveTL -n "G2_Joint1_translateY";
	setAttr ".tan" 10;
	setAttr -s 14 ".ktv[0:13]"  1 0 4 0.0018934744177523351 6 0.0018934744177523351 
		10 0 14 11.529305624200147 20 15.737216768273347 27 12.553827337378605 30 0 36 0 
		40 0 44 0 48 0 55 0 60 0;
	setAttr -s 14 ".kit[0:13]"  1 10 10 1 9 9 9 16 
		10 10 10 10 10 10;
	setAttr -s 14 ".kot[0:13]"  1 10 10 1 9 9 9 16 
		10 10 10 10 10 10;
	setAttr -s 14 ".kix[0:13]"  0.6000102162361145 0.10000000894069672 
		0.066666662693023682 0.0051947981119155884 0.13333332538604736 0.20000001788139343 
		0.2333332896232605 0.10000002384185791 0.20000004768371582 0.13333332538604736 0.13333332538604736 
		0.13333332538604736 0.23333334922790527 0.16666662693023682;
	setAttr -s 14 ".kiy[0:13]"  0 0 0 0 6.2948861122131348 0.47285625338554382 
		-11.016050338745117 0 0 0 0 0 0 0;
	setAttr -s 14 ".kox[0:13]"  0.00044750704546459019 0.066666662693023682 
		0.13333334028720856 0.015040240250527859 0.20000001788139343 0.2333332896232605 0.10000002384185791 
		0.20000004768371582 0.13333332538604736 0.13333332538604736 0.13333332538604736 0.23333334922790527 
		0.16666662693023682 0.16666662693023682;
	setAttr -s 14 ".koy[0:13]"  0.013028793036937714 0 0 0 9.4423303604125977 
		0.55166548490524292 -4.7211666107177734 0 0 0 0 0 0 0;
createNode animCurveTL -n "G2_Joint1_translateZ";
	setAttr ".tan" 16;
	setAttr ".wgt" no;
	setAttr -s 14 ".ktv[0:13]"  1 -22.053 4 -22.053 6 -22.053 10 -22.053 
		14 -19.519769761250174 20 -10.286745341635097 27 0 30 0 36 0 40 0 44 0 48 0 55 0 
		60 0;
	setAttr -s 14 ".kit[0:13]"  10 10 10 10 10 1 16 16 
		16 16 16 16 16 16;
	setAttr -s 14 ".kot[0:13]"  10 10 10 10 10 1 16 16 
		16 16 16 16 16 16;
	setAttr -s 14 ".kix[5:13]"  0.019890489056706429 1 1 1 1 1 1 1 1;
	setAttr -s 14 ".kiy[5:13]"  0.99980223178863525 0 0 0 0 0 0 0 0;
	setAttr -s 14 ".kox[5:13]"  0.019890490919351578 1 1 1 1 1 1 1 1;
	setAttr -s 14 ".koy[5:13]"  0.99980217218399048 0 0 0 0 0 0 0 0;
createNode animCurveTA -n "G2_Joint1_rotateX";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 10 ".ktv[0:9]"  1 0 4 0 6 0 10 0 14 34.185558573626658 
		20 179.99999396502974 27 332.96666487874336 30 360 55 360 60 360;
	setAttr -s 10 ".kit[0:9]"  3 10 10 10 10 1 10 10 
		10 10;
	setAttr -s 10 ".kot[0:9]"  3 10 10 10 10 1 10 10 
		10 10;
	setAttr -s 10 ".kix[5:9]"  0.062721185386180878 0.10551103204488754 
		1 1 1;
	setAttr -s 10 ".kiy[5:9]"  0.99803107976913452 0.99441814422607422 
		0 0 0;
	setAttr -s 10 ".kox[5:9]"  0.062721163034439087 0.10551103204488754 
		1 1 1;
	setAttr -s 10 ".koy[5:9]"  0.9980311393737793 0.99441814422607422 
		0 0 0;
createNode animCurveTA -n "G2_Joint1_rotateY";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 4 0 6 0 10 0 48 -180.9273495825432 
		55 -191.24317762855119 60 -191.62611002762421;
	setAttr -s 7 ".kit[4:6]"  16 10 16;
	setAttr -s 7 ".kot[4:6]"  16 10 16;
createNode animCurveTA -n "G2_Joint1_rotateZ";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 14 ".ktv[0:13]"  1 0 4 0 6 0 10 0 14 0 20 0 27 0 30 0 36 
		0 40 0 44 0 48 0 55 0 60 0;
createNode animCurveTU -n "G2_Joint1_visibility";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 14 ".ktv[0:13]"  1 1 4 1 6 1 10 1 14 1 20 1 27 1 30 1 36 
		1 40 1 44 1 48 1 55 1 60 1;
	setAttr -s 14 ".kot[0:13]"  5 5 5 5 5 5 5 5 
		5 5 5 5 5 5;
createNode animCurveTL -n "G2_Joint2_translateX";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 17 ".ktv[0:16]"  1 0 4 0 6 0 10 0 14 0 20 0 27 0 30 0 32 
		0 36 0 40 0 42 0 44 0 46 0 48 0 55 0 60 0;
createNode animCurveTL -n "G2_Joint2_translateY";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  48 6.0187524577652338 55 6.0187524577652338;
createNode animCurveTL -n "G2_Joint2_translateZ";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  48 0 55 0;
createNode animCurveTU -n "G2_Joint2_scaleY";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 17 ".ktv[0:16]"  1 1.1091025363606501 4 0.70924690465142737 
		6 0.5559098529152342 10 1.2908567213826272 14 1.1091025363606501 20 1.1091025363606501 
		27 1.0153496235932886 30 1.1139412460380695 32 0.82723080441233288 36 1.1091025363606501 
		40 1.1091025363606501 42 0.98802037802222376 44 1.0631904865229722 46 1.099162435766575 
		48 1.0123906567587899 55 1.121796136026453 60 1.1036410355131823;
	setAttr -s 17 ".kit[9:16]"  3 3 10 1 1 10 10 10;
	setAttr -s 17 ".kot[9:16]"  3 3 10 1 1 10 10 10;
	setAttr -s 17 ".kix[12:16]"  0.63962006568908691 0.99322736263275146 
		0.99716609716415405 1 1;
	setAttr -s 17 ".kiy[12:16]"  0.76869124174118042 -0.11618722975254059 
		0.075231850147247314 0 0;
	setAttr -s 17 ".kox[12:16]"  0.63962000608444214 0.99322736263275146 
		0.99716609716415405 1 1;
	setAttr -s 17 ".koy[12:16]"  0.76869124174118042 -0.11618721485137939 
		0.075231850147247314 0 0;
createNode animCurveTU -n "G2_Joint2_scaleX";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  48 1 55 1;
createNode animCurveTU -n "G2_Joint2_scaleZ";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  48 1 55 1;
createNode animCurveTU -n "G2_Joint2_visibility";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  48 1 55 1;
	setAttr -s 2 ".kot[0:1]"  5 5;
createNode animCurveTA -n "G2_Joint2_rotateX";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  48 0 55 0;
createNode animCurveTA -n "G2_Joint2_rotateY";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  48 0 55 0;
createNode animCurveTA -n "G2_Joint2_rotateZ";
	setAttr ".tan" 10;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  48 0 55 0;
createNode materialInfo -n "materialInfo9";
createNode shadingEngine -n "lambert6SG";
	setAttr ".ihi" 0;
	setAttr ".ro" yes;
createNode lambert -n "lambert6";
createNode colladaDocument -n "colladaDocuments";
	setAttr ".doc[0].fn" -type "string" "";
select -ne :time1;
	setAttr ".o" 60;
select -ne :renderPartition;
	setAttr -s 4 ".st";
select -ne :renderGlobalsList1;
select -ne :defaultShaderList1;
	setAttr -s 4 ".s";
select -ne :postProcessList1;
	setAttr -s 2 ".p";
select -ne :defaultRenderUtilityList1;
select -ne :lightList1;
select -ne :defaultTextureList1;
select -ne :lambert1;
	setAttr ".dc" 1;
select -ne :initialShadingGroup;
	setAttr ".ro" yes;
select -ne :initialParticleSE;
	setAttr ".ro" yes;
select -ne :defaultRenderGlobals;
	setAttr ".mcfr" 30;
	setAttr ".outf" 23;
	setAttr ".an" yes;
	setAttr ".ef" 60;
select -ne :defaultRenderQuality;
	setAttr ".rfl" 10;
	setAttr ".rfr" 10;
	setAttr ".sl" 10;
	setAttr ".eaa" 0;
	setAttr ".ufil" yes;
	setAttr ".ss" 2;
select -ne :defaultResolution;
	setAttr ".pa" 1;
select -ne :hardwareRenderGlobals;
	setAttr ".ctrs" 256;
	setAttr ".btrs" 512;
	setAttr ".hwfr" 30;
select -ne :defaultHardwareRenderGlobals;
	setAttr ".fn" -type "string" "im";
	setAttr ".res" -type "string" "ntsc_4d 646 485 1.333";
connectAttr "skinCluster1GroupId.id" "S_G2Shape.iog.og[18].gid";
connectAttr "skinCluster1Set.mwc" "S_G2Shape.iog.og[18].gco";
connectAttr "groupId2.id" "S_G2Shape.iog.og[19].gid";
connectAttr "tweakSet1.mwc" "S_G2Shape.iog.og[19].gco";
connectAttr "skinCluster1.og[0]" "S_G2Shape.i";
connectAttr "tweak1.vl[0].vt[0]" "S_G2Shape.twl";
connectAttr "G2_Joint1_rotateX.o" "G2_Joint1.rx";
connectAttr "G2_Joint1_rotateY.o" "G2_Joint1.ry";
connectAttr "G2_Joint1_rotateZ.o" "G2_Joint1.rz";
connectAttr "G2_Joint1_scaleX.o" "G2_Joint1.sx";
connectAttr "G2_Joint1_scaleZ.o" "G2_Joint1.sz";
connectAttr "G2_Joint1_scaleY.o" "G2_Joint1.sy";
connectAttr "G2_Joint1_translateX.o" "G2_Joint1.tx";
connectAttr "G2_Joint1_translateY.o" "G2_Joint1.ty";
connectAttr "G2_Joint1_translateZ.o" "G2_Joint1.tz";
connectAttr "G2_Joint1_visibility.o" "G2_Joint1.v";
connectAttr "G2_Joint1.s" "G2_Joint2.is";
connectAttr "G2_Joint2_translateX.o" "G2_Joint2.tx";
connectAttr "G2_Joint2_translateY.o" "G2_Joint2.ty";
connectAttr "G2_Joint2_translateZ.o" "G2_Joint2.tz";
connectAttr "G2_Joint2_scaleY.o" "G2_Joint2.sy";
connectAttr "G2_Joint2_scaleX.o" "G2_Joint2.sx";
connectAttr "G2_Joint2_scaleZ.o" "G2_Joint2.sz";
connectAttr "G2_Joint2_visibility.o" "G2_Joint2.v";
connectAttr "G2_Joint2_rotateX.o" "G2_Joint2.rx";
connectAttr "G2_Joint2_rotateY.o" "G2_Joint2.ry";
connectAttr "G2_Joint2_rotateZ.o" "G2_Joint2.rz";
connectAttr ":defaultLightSet.msg" "lightLinker1.lnk[0].llnk";
connectAttr ":initialShadingGroup.msg" "lightLinker1.lnk[0].olnk";
connectAttr ":defaultLightSet.msg" "lightLinker1.lnk[1].llnk";
connectAttr ":initialParticleSE.msg" "lightLinker1.lnk[1].olnk";
connectAttr ":defaultLightSet.msg" "lightLinker1.lnk[2].llnk";
connectAttr "lambert6SG.msg" "lightLinker1.lnk[2].olnk";
connectAttr ":defaultLightSet.msg" "lightLinker1.lnk[11].llnk";
connectAttr "lambert4SG.msg" "lightLinker1.lnk[11].olnk";
connectAttr ":defaultLightSet.msg" "lightLinker1.slnk[0].sllk";
connectAttr ":initialShadingGroup.msg" "lightLinker1.slnk[0].solk";
connectAttr ":defaultLightSet.msg" "lightLinker1.slnk[1].sllk";
connectAttr ":initialParticleSE.msg" "lightLinker1.slnk[1].solk";
connectAttr ":defaultLightSet.msg" "lightLinker1.slnk[4].sllk";
connectAttr "lambert6SG.msg" "lightLinker1.slnk[4].solk";
connectAttr ":defaultLightSet.msg" "lightLinker1.slnk[6].sllk";
connectAttr "lambert4SG.msg" "lightLinker1.slnk[6].solk";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr "S_G2.iog" "modelPanel4ViewSelectedSet.dsm" -na;
connectAttr "file4.oc" "M_G2.c";
connectAttr "M_G2.oc" "lambert4SG.ss";
connectAttr "S_G2Shape.iog" "lambert4SG.dsm" -na;
connectAttr "lambert4SG.msg" "materialInfo7.sg";
connectAttr "M_G2.msg" "materialInfo7.m";
connectAttr "file4.msg" "materialInfo7.t" -na;
connectAttr "place2dTexture5.c" "file4.c";
connectAttr "place2dTexture5.tf" "file4.tf";
connectAttr "place2dTexture5.rf" "file4.rf";
connectAttr "place2dTexture5.mu" "file4.mu";
connectAttr "place2dTexture5.mv" "file4.mv";
connectAttr "place2dTexture5.s" "file4.s";
connectAttr "place2dTexture5.wu" "file4.wu";
connectAttr "place2dTexture5.wv" "file4.wv";
connectAttr "place2dTexture5.re" "file4.re";
connectAttr "place2dTexture5.of" "file4.of";
connectAttr "place2dTexture5.r" "file4.ro";
connectAttr "place2dTexture5.n" "file4.n";
connectAttr "place2dTexture5.vt1" "file4.vt1";
connectAttr "place2dTexture5.vt2" "file4.vt2";
connectAttr "place2dTexture5.vt3" "file4.vt3";
connectAttr "place2dTexture5.vc1" "file4.vc1";
connectAttr "place2dTexture5.o" "file4.uv";
connectAttr "place2dTexture5.ofs" "file4.fs";
connectAttr "skinCluster1GroupParts.og" "skinCluster1.ip[0].ig";
connectAttr "skinCluster1GroupId.id" "skinCluster1.ip[0].gi";
connectAttr "bindPose2.msg" "skinCluster1.bp";
connectAttr "G2_Joint1.wm" "skinCluster1.ma[0]";
connectAttr "G2_Joint2.wm" "skinCluster1.ma[1]";
connectAttr "G2_Joint1.liw" "skinCluster1.lw[0]";
connectAttr "G2_Joint2.liw" "skinCluster1.lw[1]";
connectAttr "groupParts2.og" "tweak1.ip[0].ig";
connectAttr "groupId2.id" "tweak1.ip[0].gi";
connectAttr "skinCluster1GroupId.msg" "skinCluster1Set.gn" -na;
connectAttr "S_G2Shape.iog.og[18]" "skinCluster1Set.dsm" -na;
connectAttr "skinCluster1.msg" "skinCluster1Set.ub[0]";
connectAttr "tweak1.og[0]" "skinCluster1GroupParts.ig";
connectAttr "skinCluster1GroupId.id" "skinCluster1GroupParts.gi";
connectAttr "groupId2.msg" "tweakSet1.gn" -na;
connectAttr "S_G2Shape.iog.og[19]" "tweakSet1.dsm" -na;
connectAttr "tweak1.msg" "tweakSet1.ub[0]";
connectAttr "S_G2ShapeOrig.w" "groupParts2.ig";
connectAttr "groupId2.id" "groupParts2.gi";
connectAttr "G2_Joint1.msg" "bindPose2.m[0]";
connectAttr "G2_Joint2.msg" "bindPose2.m[1]";
connectAttr "bindPose2.w" "bindPose2.p[0]";
connectAttr "bindPose2.m[0]" "bindPose2.p[1]";
connectAttr "G2_Joint1.bps" "bindPose2.wm[0]";
connectAttr "G2_Joint2.bps" "bindPose2.wm[1]";
connectAttr "lambert6SG.msg" "materialInfo9.sg";
connectAttr "lambert6.msg" "materialInfo9.m";
connectAttr "lambert6.oc" "lambert6SG.ss";
connectAttr "lambert4SG.pa" ":renderPartition.st" -na;
connectAttr "lambert6SG.pa" ":renderPartition.st" -na;
connectAttr "M_G2.msg" ":defaultShaderList1.s" -na;
connectAttr "lambert6.msg" ":defaultShaderList1.s" -na;
connectAttr "place2dTexture5.msg" ":defaultRenderUtilityList1.u" -na;
connectAttr "lightLinker1.msg" ":lightList1.ln" -na;
connectAttr "file4.msg" ":defaultTextureList1.tx" -na;
// End of G2.ma
