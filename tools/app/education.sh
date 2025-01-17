#!/usr/bin/env bash
############################################
tmoe_mathematics_menu() {
	RETURN_TO_WHERE='tmoe_mathematics_menu'
	
	DEPENDENCY_01=''
	TMOE_APP=$(whiptail --title "mathematics" --menu \
		"Which software do you want to install？" 0 50 0 \
		"1" "geogebra(结合了“几何”、“代数”与“微积分”)" \
		"2" "octave(GNU Octave语言,用于数值计算)" \
		"3" "scilab(用于数值计算的科学软件包)" \
		"4" "freemat(科学计算软件,类似于Matlab)" \
		"5" "maxima(数学软件,类似于Mathematica)" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_education_app_menu ;;
	1) DEPENDENCY_02='geogebra' ;;
	2) DEPENDENCY_02='octave' ;;
	3)
		DEPENDENCY_01='scilab-minimal-bin'
		DEPENDENCY_02='scilab'
		;;
	4)
		DEPENDENCY_01='freemat'
		DEPENDENCY_02='freemat-help'
		;;
	5)
		DEPENDENCY_01='maxima'
		DEPENDENCY_02='wxmaxima'
		;;
	esac
	##########################
	beta_features_quick_install
	press_enter_to_return
	tmoe_mathematics_menu
}
####################
tmoe_chemistry_menu() {
	RETURN_TO_WHERE='tmoe_chemistry_menu'
	
	DEPENDENCY_01=''
	TMOE_APP=$(whiptail --title "chemistry" --menu \
		"化学是研究物质的组成、结构、性质及其变化规律的一门自然学科\nWhich software do you want to install？" 0 50 0 \
		"1" "kalzium(元素周期表)" \
		"2" "nwchem(运行在高性能工作站集群上的计算化学软件)" \
		"3" "avogadro(阿伏伽德罗-分子编辑器)" \
		"4" "pymol(分子三维结构显示软件)" \
		"5" "Psi4(量子化学程序集)" \
		"6" "gromacs(分子动力学模拟器)" \
		"7" "CP2K(第一性原理材料计算和模拟软件)" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_education_app_menu ;;
	1) DEPENDENCY_02='kalzium' ;;
	2) DEPENDENCY_02='nwchem' ;;
	3) DEPENDENCY_02='avogadro' ;;
	4) DEPENDENCY_02='pymol' ;;
	5) DEPENDENCY_02='psi4' ;;
	6) DEPENDENCY_02='gromacs' ;;
	7) DEPENDENCY_02='cp2k' ;;
	esac
	##########################
	beta_features_quick_install
	press_enter_to_return
	tmoe_chemistry_menu
}
####################
tmoe_physics_menu() {
	RETURN_TO_WHERE='tmoe_physics_menu'
	
	DEPENDENCY_01=''
	TMOE_APP=$(whiptail --title "physics" --menu \
		"物理学是一门研究自然现象背后的物质和能量法则的自然科学。\nWARNING！本功能仍处于内测阶段,可能无法正常运行。\nAlpha features may not work properly." 0 50 0 \
		"1" "Step(交互式物理模拟器,归属于KDE教育项目)" \
		"2" "OpenFOAM 简化偏微分方程的数值解法" \
		"3" "Geant321 物质间离子流动的仿真工具包" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_education_app_menu ;;
	1)
		cat <<-'EOF'
			        先放入物体，再添加一些力（地心引力或者弹簧），最后点击“ 模拟（Simulate）”按钮。
					这款软件就会为你模拟这个物体在真实世界的物理定律影响下的运动状态。
					你可以在模拟过程中改变物体或力的属性，然后观察不同属性下产生的现象。
					Step 可以让你从体验中学习物理,并从中感受到物理的乐趣。
		EOF
		DEPENDENCY_02='step'
		;;
	2) DEPENDENCY_02='openfoam' ;;
	3) DEPENDENCY_02='geant321' ;;
	esac
	##########################
	beta_features_quick_install
	press_enter_to_return
	tmoe_physics_menu
}
####################
tips_of_dict() {
	cat <<-'EOF'
		    因存在版权问题，故本功能不会开放。
	EOF
}
###########
install_golden_dict() {
	DEPENDENCY_01="goldendict"
	DEPENDENCY_02="goldendict-wordnet"
	
	beta_features_quick_install
}
############
tmoe_golden_dict_menu() {
	RETURN_TO_WHERE='tmoe_golden_dict_menu'
	TMOE_APP=$(whiptail --title "GOLDEN DICT金典" --menu \
		"开源、跨平台，支持屏幕取词，支持mdx/mdd, dsl, bgl 等十余种词典格式" 0 50 0 \
		"1" "install/remove(安装/卸载)" \
		"2" "词库(朗文,柯林斯,韦氏,剑桥,牛津)" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_english_menu ;;
	1) install_golden_dict ;;
	2) tips_of_dict ;;
	esac
	##########################
	press_enter_to_return
	tmoe_golden_dict_menu
}
#############
check_tmoe_study_materials() {
	if [ "${WINDOWS_DISTRO}" = 'WSL' ]; then
		DOWNLOAD_FOLDER='/mnt/c/Users/Public/Documents'
	else
		DOWNLOAD_FOLDER="${HOME}/sd/Download/Documents"
	fi

	if [ ! -d "${DOWNLOAD_FOLDER}" ]; then
		mkdir -p ${DOWNLOAD_FOLDER}
	fi
	cd ${DOWNLOAD_FOLDER}
	if [ -e ${DOWNLOAD_FILE_NAME} ]; then
		if (whiptail --title "检测到压缩包已下载,请选择您需要执行的操作！" --yes-button '解压uncompress' --no-button '重下DL again' --yesno "Detected that the file has been downloaded.\nDo you want to unzip it, or download it again?\n您想要直接解压还是重新下载？" 0 0); then
			unzip_tmoe_study_file
		else
			git_clone_tmoe_study_file
		fi
	else
		git_clone_tmoe_study_file
	fi
}
###############
unzip_tmoe_study_file() {
	tar -Jxvf ${DOWNLOAD_FILE_NAME}
	printf "%s\n" "文件已保存至${BLUE}${DOWNLOAD_FOLDER}${RESET}"
	if [ "${WINDOWS_DISTRO}" = 'WSL' ]; then
		printf "%s\n" "您可以使用windows10资源管理器打开${BLUE}C:\Users\Public\Documents${RESET}"
	fi
}
##############
git_clone_tmoe_study_file() {
	cd /tmp
	TMOE_TRUE_TEMP_FOLDER='.TMOE_STUDY_MATERIALS_TEMP_FOLDER'
	mkdir -p ${TMOE_TRUE_TEMP_FOLDER}
	cd ${TMOE_TRUE_TEMP_FOLDER}

	TMOE_TEMP_FOLDER=".${DOWNLOAD_FILE_NAME}_TEMP_FOLDER_01"
	git clone --depth=1 -b ${BRANCH_NAME} ${TMOE_LINUX_STUDY_REPO_01} ${TMOE_TEMP_FOLDER}
	cd ${TMOE_TEMP_FOLDER}
	mv .study_* ..
	cd ..
	cat .study_* >${DOWNLOAD_FILE_NAME}
	mv -f ${DOWNLOAD_FILE_NAME} ${DOWNLOAD_FOLDER}
	cd ../
	rm -rvf ${TMOE_TRUE_TEMP_FOLDER}
	cd ${DOWNLOAD_FOLDER}
	unzip_tmoe_study_file
}
#########################
download_2013_to_2019_cet4_and_6_exam_paper() {
	TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/cet.git'
	BRANCH_NAME='2019'
	DOWNLOAD_FILE_NAME='cet.tar.xz'
	check_tmoe_study_materials
}
############
download_english_masterpieces() {
	TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/masterpieces.git'
	BRANCH_NAME='2018'
	DOWNLOAD_FILE_NAME='英文原著.tar.xz'
	check_tmoe_study_materials
}
############
cet4_and_6_exam_paper() {
	RETURN_TO_WHERE='cet4_and_6_exam_paper'
	TMOE_APP=$(whiptail --title "cet4_and_6_exam_paper" --menu \
		"CET4 and CET6真题" 0 50 0 \
		"1" "2013-2019(6.7MiB)" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_english_menu ;;
	1) download_2013_to_2019_cet4_and_6_exam_paper ;;
	esac
	##########################
	press_enter_to_return
	cet4_and_6_exam_paper
}
##############
tmoe_english_menu() {
	RETURN_TO_WHERE='tmoe_english_menu'
	TMOE_APP=$(whiptail --title "English" --menu \
		"Learning English" 0 50 0 \
		"1" "goldendict(多功能字典查询程序)" \
		"2" "四六级真题(不含听力音频)" \
		"3" "Masterpieces名著(提高阅读能力,222.8MiB)" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_education_app_menu ;;
	1) tmoe_golden_dict_menu ;;
	2) cet4_and_6_exam_paper ;;
	3) download_english_masterpieces ;;
	esac
	##########################
	press_enter_to_return
	tmoe_english_menu
}
####################
college_entrance_examination_paper() {
	RETURN_TO_WHERE='college_entrance_examination_paper'
	TMOE_APP=$(whiptail --title "college_entrance_examination_paper" --menu \
		"高考真题" 0 50 0 \
		"1" "2020(大小79.9MiB)" \
		"2" "2008-2019(不含听力及口语听说,392.2MiB)" \
		"3" "2013-2018理科版(146.3MiB)" \
		"4" "2008-2018(仅英语听力音频,244.9MiB)" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_college_entrance_examination ;;
	1)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/gaokao_paper_2020'
		BRANCH_NAME='2020'
		DOWNLOAD_FILE_NAME='2020年高考真题.tar.xz'
		;;
	2)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/gaokao_paper_2019'
		BRANCH_NAME='2019'
		DOWNLOAD_FILE_NAME='2008-2019高考真题.tar.xz'
		;;
	3)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/gaokao_paper_2013_to_2018'
		BRANCH_NAME='2018'
		DOWNLOAD_FILE_NAME='2013-2018高考真题.tar.xz'
		;;
	4)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/gaokao_english_listening'
		BRANCH_NAME='2018'
		DOWNLOAD_FILE_NAME='2008-2018高考英语听力.tar.xz'
		;;
	esac
	##########################
	check_tmoe_study_materials
	press_enter_to_return
	college_entrance_examination_paper
}
##############
college_entrance_examination_notes() {
	RETURN_TO_WHERE='college_entrance_examination_notes'
	TMOE_APP=$(whiptail --title "NOTES" --menu \
		"笔记" 0 50 0 \
		"1" "生物(大小131.8MiB)" \
		"2" "英语(5.4MiB)" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_college_entrance_examination ;;
	1)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/biology_note'
		BRANCH_NAME='2019'
		DOWNLOAD_FILE_NAME='生物笔记.tar.xz'
		;;
	2)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/english_note'
		BRANCH_NAME='2020'
		DOWNLOAD_FILE_NAME='英语终极笔记.tar.xz'
		;;
	esac
	##########################
	check_tmoe_study_materials
	press_enter_to_return
	college_entrance_examination_notes
}
##############
tmoe_college_entrance_examination() {
	RETURN_TO_WHERE='tmoe_college_entrance_examination'
	TMOE_APP=$(whiptail --title "college_entrance_examination" --menu \
		"高考" 0 50 0 \
		"1" "真题" \
		"2" "学习笔记" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_education_app_menu ;;
	1) college_entrance_examination_paper ;;
	2) college_entrance_examination_notes ;;
	esac
	##########################
	press_enter_to_return
	tmoe_college_entrance_examination
}
#############
tmoe_postgraduate_entrance_examination() {
	RETURN_TO_WHERE='tmoe_postgraduate_entrance_examination'
	TMOE_APP=$(whiptail --title "postgraduate_entrance_examination" --menu \
		"考研" 0 50 0 \
		"1" "2003-2019政治(6.2MiB)" \
		"2" "2001-2019英语(7.7MiB)" \
		"3" "1987-2020数学真题(含解析,15.5MiB)" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") tmoe_education_app_menu ;;
	1)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/postgraduate_politics'
		BRANCH_NAME='2019'
		DOWNLOAD_FILE_NAME='2003-2019政治真题.tar.xz'
		;;
	2)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/postgraduate_english'
		BRANCH_NAME='2019'
		DOWNLOAD_FILE_NAME='2001-2019英语真题.tar.xz'
		;;
	3)
		TMOE_LINUX_STUDY_REPO_01='https://gitee.com/ak2/postgraduate_math'
		BRANCH_NAME='2020'
		DOWNLOAD_FILE_NAME='1987-2020数学真题.tar.xz'
		;;
	esac
	##########################
	check_tmoe_study_materials
	press_enter_to_return
	tmoe_postgraduate_entrance_examination
}
#############
tmoe_education_app_menu() {
	RETURN_TO_WHERE='tmoe_education_app_menu'
	
	DEPENDENCY_01=''
	TMOE_APP=$(whiptail --title "education" --menu \
		"Play玩Linux X\nStudy学习  ✓" 0 50 0 \
		"1" "高考(培养学科核心素养,提高综合能力)" \
		"2" "考研(全国硕士研究生统一招生考试)" \
		"3" "mathematics数学" \
		"4" "English英语(词典,四六级,名著)" \
		"5" "physics物理" \
		"6" "chemistry化学" \
		"0" "🌚 Return to previous menu 返回上级菜单" \
		3>&1 1>&2 2>&3)
	##########################
	case "${TMOE_APP}" in
	0 | "") beta_features ;;
	1) tmoe_college_entrance_examination ;;
	2) tmoe_postgraduate_entrance_examination ;;
	3) tmoe_mathematics_menu ;;
	4) tmoe_english_menu ;;
	5) tmoe_physics_menu ;;
	6) tmoe_chemistry_menu ;;
	esac
	##########################
	press_enter_to_return
	tmoe_education_app_menu
}
####################
tmoe_education_app_menu
