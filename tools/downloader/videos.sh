#!/usr/bin/env bash
#####################
download_videos() {
    VIDEOTOOL=$(
        whiptail --title "DOWNLOAD VIDEOS" --menu "你想要使用哪个工具来下载视频呢" 0 50 0 \
            "1" "🍻 Annie" \
            "2" "🍷 You-get" \
            "3" "🍾 Youtube-dl" \
            "4" "🍹 cookie说明" \
            "5" "🍺 upgrade更新下载工具" \
            "0" "🌚 Back to the main menu 返回主菜单" \
            3>&1 1>&2 2>&3
    )
    ##########################
    case "${VIDEOTOOL}" in
    0 | "") tmoe_linux_tool_menu ;;
    1) golang_annie ;;
    2) python_you_get ;;
    3) python_youtube_dl ;;
    4) cookies_readme ;;
    5) upgrade_video_download_tool ;;
    esac
    ##########################
    press_enter_to_return
    tmoe_linux_tool_menu
}
###########
golang_annie() {
    if [ ! -e "/usr/local/bin/annie" ]; then
        printf "%s\n" "检测到您尚未安装annie，将为您跳转至更新管理中心"
        upgrade_video_download_tool
        exit 0
    fi

    if [ ! -e "${HOME}/sd/Download/Videos" ]; then
        mkdir -p ${HOME}/sd/Download/Videos
    fi

    cd ${HOME}/sd/Download/Videos

    AnnieVideoURL=$(whiptail --inputbox "Please enter a url.请输入视频链接,例如https://www.bilibili.com/video/av号,或者直接输入avxxx(av号或BV号)。您可以在url前加-f参数来指定清晰度，-p来下载整个播放列表。Press Enter after the input is completed." 12 50 --title "请在地址栏内输入 视频链接" 3>&1 1>&2 2>&3)

    # printf "%s\n" "${AnnieVideoURL}" >> ${HOME}/.video_history
    if [ "$(printf '%s\n' "${AnnieVideoURL}" | grep 'b23.tv')" ]; then
        AnnieVideoURL="$(printf '%s\n' "${AnnieVideoURL}" | sed 's@b23.tv@www.bilibili.com/video@')"
    elif [ "$(printf '%s\n' "${AnnieVideoURL}" | grep '^BV')" ]; then
        AnnieVideoURL="$(printf '%s\n' "${AnnieVideoURL}" | sed 's@^BV@https://www.bilibili.com/video/&@')"
    fi
    #当未添加http时，将自动修复。
    if [ "$(printf '%s\n' "${AnnieVideoURL}" | egrep 'www|com')" ] && [ ! "$(printf '%s\n' "${AnnieVideoURL}" | grep 'http')" ]; then
        ls
        AnnieVideoURL=$(printf '%s\n' "${AnnieVideoURL}" | sed 's@www@http://&@')
    fi
    printf "%s\n" "${AnnieVideoURL}"
    printf "%s\n" "正在解析中..."
    printf "%s\n" "Parsing ..."
    #if [ ! $(printf '%s\n' "${AnnieVideoURL}" | egrep '^BV|^av|^http') ]; then
    #	AnnieVideoURL=$(printf '%s\n' "${AnnieVideoURL}" | sed 's@^@http://&@')
    #fi

    annie -i ${AnnieVideoURL}
    if [ -e "${HOME}/.config/tmoe-linux/videos.cookiepath" ]; then
        VideoCookies=$(sed -n p ${HOME}/.config/tmoe-linux/videos.cookiepath | head -n 1)
        annie -c ${VideoCookies} -d ${AnnieVideoURL}
    else
        annie -d ${AnnieVideoURL}
    fi
    ls -lAth ./ | head -n 3
    printf "%s\n" "视频文件默认下载至$(pwd)"
    printf "%s\n" "Press ${GREEN}enter${RESET} to ${BLUE}return.${RESET}"
    printf "%s\n" "按${GREEN}回车键${RESET}${BLUE}返回${RESET}"
    read
    download_videos
}
###########
python_you_get() {
    if [ ! $(command -v you-get) ]; then
        printf "%s\n" "检测到您尚未安装you-get,将为您跳转至更新管理中心"
        upgrade_video_download_tool
        exit 0
    fi

    if [ ! -e "${HOME}/sd/Download/Videos" ]; then
        mkdir -p ${HOME}/sd/Download/Videos
    fi

    cd ${HOME}/sd/Download/Videos

    AnnieVideoURL=$(whiptail --inputbox "Please enter a url.请输入视频链接,例如https://www.bilibili.com/video/av号,您可以在url前加--format参数来指定清晰度，-l来下载整个播放列表。Press Enter after the input is completed." 12 50 --title "请在地址栏内输入 视频链接" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        download_videos
    fi
    printf "%s\n" "${AnnieVideoURL}"
    printf "%s\n" "正在解析中..."
    printf "%s\n" "Parsing ..."
    you-get -i ${AnnieVideoURL}
    if [ -e "${HOME}/.config/tmoe-linux/videos.cookiepath" ]; then
        VideoCookies=$(sed -n p ${HOME}/.config/tmoe-linux/videos.cookiepath | head -n 1)
        you-get -c ${VideoCookies} -d ${AnnieVideoURL}
    else
        you-get -d ${AnnieVideoURL}
    fi
    ls -lAth ./ | head -n 3
    printf "%s\n" "视频文件默认下载至$(pwd)"
    printf "%s\n" "Press ${GREEN}enter${RESET} to ${BLUE}return.${RESET}"
    printf "%s\n" "按${GREEN}回车键${RESET}${BLUE}返回${RESET}"
    read
    download_videos
}
############
python_youtube_dl() {
    if [ ! $(command -v youtube-dl) ]; then
        printf "%s\n" "检测到您尚未安装youtube-dl,将为您跳转至更新管理中心"
        upgrade_video_download_tool
        exit 0
    fi

    if [ ! -e "${HOME}/sd/Download/Videos" ]; then
        mkdir -p ${HOME}/sd/Download/Videos
    fi

    cd ${HOME}/sd/Download/Videos

    AnnieVideoURL=$(whiptail --inputbox "Please enter a url.请输入视频链接,例如https://www.bilibili.com/video/av号,您可以在url前加--yes-playlist来下载整个播放列表。Press Enter after the input is completed." 12 50 --title "请在地址栏内输入 视频链接" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        download_videos
    fi
    printf "%s\n" "${AnnieVideoURL}"
    printf "%s\n" "正在解析中..."
    printf "%s\n" "Parsing ..."
    youtube-dl -e --get-description --get-duration ${AnnieVideoURL}
    if [ -e "${HOME}/.config/tmoe-linux/videos.cookiepath" ]; then
        VideoCookies=$(sed -n p ${HOME}/.config/tmoe-linux/videos.cookiepath | head -n 1)
        youtube-dl --merge-output-format mp4 --all-subs --cookies ${VideoCookies} -v ${AnnieVideoURL}
    else
        youtube-dl --merge-output-format mp4 --all-subs -v ${AnnieVideoURL}
    fi
    ls -lAth ./ | head -n 3
    printf "%s\n" "视频文件默认下载至$(pwd)"
    printf "%s\n" "Press ${GREEN}enter${RESET} to ${BLUE}return.${RESET}"
    printf "%s\n" "按${GREEN}回车键${RESET}${BLUE}返回${RESET}"
    read
    download_videos
}
#############
###################################
cookies_readme() {
    cat <<-'EndOFcookies'
		若您需要下载大会员视频，则需要指定cookie文件路径。
		加载cookie后，即使您不是大会员，也能提高部分网站的下载速度。
		cookie文件包含了会员身份认证凭据，请勿将该文件泄露出去！
		一个cookie文件可以包含多个网站的cookies，您只需要手动将包含cookie数据的纯文本复制至cookies.txt文件即可。
		您需要安装浏览器扩展插件来导出cookie，部分插件还需手动配置导出格式为Netscape，并将后缀名修改为txt
		对于不同平台(windows、linux和macos)导出的cookie文件，如需跨平台加载，则需要转换为相应系统的换行符。
		浏览器商店中包含多个相关扩展插件，但不同插件导出的cookie文件可能存在兼容性的差异。
		例如火狐扩展cookies-txt（适用于you-get v0.4.1432，不适用于annie v0.9.8）
		https://addons.mozilla.org/zh-CN/firefox/addon/cookies-txt/
		再次提醒，cookie非常重要!
		希望您能仔细甄别，堤防恶意插件。
		同时希望您能够了解，将cookie文件泄露出去等同于将账号泄密！
		请妥善保管好该文件及相关数据！
	EndOFcookies
    if [ -e "${HOME}/.config/tmoe-linux/videos.cookiepath" ]; then
        printf "%s\n" "您当前的cookie路径为$(sed -n p ${HOME}/.config/tmoe-linux/videos.cookiepath | head -n 1)"
    fi
    RETURN_TO_WHERE='download_videos'
    do_you_want_to_continue
    if [ -e "${HOME}/.config/tmoe-linux/videos.cookiepath" ]; then
        COOKIESTATUS="检测到您已启用加载cookie功能"
        CURRENT_COOKIE_PATH=$(sed -n p ${HOME}/.config/tmoe-linux/videos.cookiepath | head -n 1)
        CurrentCOOKIESpath="您当前的cookie路径为${CURRENT_COOKIE_PATH}"
    else
        COOKIESTATUS="检测到cookie处于禁用状态"
        CurrentCOOKIESpath="${COOKIESTATUS}"
    fi

    mkdir -p "${HOME}/.config/tmoe-linux"
    if (whiptail --title "modify cookie path and status" --yes-button '指定cookie file' --no-button 'disable禁用cookie' --yesno "您想要修改哪些配置信息？${COOKIESTATUS} Which configuration do you want to modify?" 9 50); then
        IMPORTANT_TIPS="${CurrentCOOKIESpath}"
        CURRENT_QEMU_ISO="${CURRENT_COOKIE_PATH}"
        FILE_EXT_01='txt'
        FILE_EXT_02='sqlite'
        where_is_tmoe_file_dir
        if [ -z ${SELECTION} ]; then
            printf "%s\n" "没有指定${YELLOW}有效${RESET}的${BLUE}文件${GREEN}，请${GREEN}重新${RESET}选择"
        else
            printf "%s\n" "${TMOE_FILE_ABSOLUTE_PATH}" >"${HOME}/.config/tmoe-linux/videos.cookiepath"
            printf "%s\n" "您当前的cookie文件路径为${TMOE_FILE_ABSOLUTE_PATH}"
            ls -lah ${TMOE_FILE_ABSOLUTE_PATH}
        fi
    else
        rm -f "${HOME}/.config/tmoe-linux/videos.cookiepath"
        printf "%s\n" "已禁用加载cookie功能"
    fi
    press_enter_to_return
    download_videos
}
#########
check_latest_video_download_tool_version() {
    printf "%s\n" "正在${YELLOW}检测${RESET}${GREEN}版本信息${RESET}..."
    cat <<-ENDofnote
		如需${YELLOW}卸载${RESET}${BLUE}annie${RESET},请输${GREEN}rm /usr/local/bin/annie${RESET}
		如需${YELLOW}卸载${RESET}${BLUE}you-get${RESET},请输${GREEN}pip3 uninstall you-get${RESET}
		如需${YELLOW}卸载${RESET}${BLUE}youtube-dl${RESET},请输${GREEN}pip3 uninstall youtube-dl${RESET}
	ENDofnote

    LATEST_ANNIE_VERSION=$(curl -LfsS https://gitee.com/mo2/annie/raw/linux_amd64/annie_version.txt | head -n 1)

    ####################
    if [ $(command -v you-get) ]; then
        YouGetVersion=$(you-get -V 2>&1 | head -n 1 | cut -d ':' -f 2 | cut -d ',' -f 1 | awk -F ' ' '$0=$NF')
    else
        YouGetVersion='您尚未安装you-get'
    fi
    #LATEST_YOU_GET_VERSION=$(curl -LfsS https://github.com/soimort/you-get/releases | grep 'muted-link css-truncate' | head -n 1 | cut -d '=' -f 2 | cut -d '"' -f 2 | cut -d '/' -f 5)

    #######################
    if [ $(command -v youtube-dl) ]; then
        YOTUBEdlVersion=$(youtube-dl --version 2>&1 | head -n 1)
    else
        YOTUBEdlVersion='您尚未安装youtube-dl'
    fi
    #LATEST_YOUTUBE_DL_VERSION=$(curl -LfsS https://github.com/ytdl-org/youtube-dl/releases | grep 'muted-link css-truncate' | head -n 1 | cut -d '=' -f 2 | cut -d '"' -f 2 | cut -d '/' -f 5)
    LATEST_YOUTUBE_DL_VERSION=$(curl -LfsS https://mirrors.bfsu.edu.cn/pypi/web/simple/youtube-dl/ | grep .whl | tail -n 1 | cut -d '=' -f 3 | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -d '-' -f 2)
    ##################
    cat <<-ENDofTable
		╔═══╦══════════╦═══════════════════╦════════════════════
		║   ║          ║                   ║                    
		║   ║ software ║ 最新版本          ║   本地版本 🎪
		║   ║          ║latest version✨   ║  Local version     
		║---║----------║-------------------║--------------------
		║ 1 ║   annie  ║                   ║ ${AnnieVersion}
		║   ║          ║${LATEST_ANNIE_VERSION}
		║---║----------║-------------------║--------------------
		║   ║          ║                   ║ ${YouGetVersion}                   
		║ 2 ║ you-get  ║                   ║  
		║---║----------║-------------------║--------------------
		║   ║          ║                   ║ ${YOTUBEdlVersion}                  
		║ 3 ║youtube-dl║${LATEST_YOUTUBE_DL_VERSION}           ║  

		annie: github.com/iawia002/annie
		you-get : github.com/soimort/you-get
		youtube-dl：github.com/ytdl-org/youtube-dl
	ENDofTable
    #对原开发者iawia002的代码进行自动编译
    printf "%s\n" "为避免加载超时，故${RED}隐藏${RESET}了部分软件的${GREEN}版本信息。${RESET}"
    printf "%s\n" "annie将于每月1号凌晨4点自动编译并发布最新版"
    printf "%s\n" "您可以按${GREEN}回车键${RESET}来${BLUE}获取更新${RESET}，亦可前往原开发者的仓库来${GREEN}手动下载${RESET}新版"
}
##################
upgrade_video_download_tool() {
    cat <<-'ENDofTable'
		╔═══╦════════════╦════════╦════════╦═════════╦
		║   ║ 💻 type    ║    🎬  ║   🌁   ║   📚    ║
		║   ║----------- ║ Videos ║ Images ║Playlist ║
		║   ║ website    ║        ║        ║         ║
		║---║------------║--------║--------║---------║
		║ 1 ║  bilibili  ║  ✓     ║        ║   ✓     ║
		║   ║            ║        ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║ 2 ║  tiktok    ║  ✓     ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║ 3 ║ youku      ║  ✓     ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║ 4 ║ youtube    ║  ✓     ║        ║   ✓     ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║ 5 ║ iqiyi      ║  ✓     ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║ 6 ║  weibo     ║  ✓     ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║ netease    ║        ║        ║         ║
		║ 7 ║ 163music   ║  ✓     ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║ tencent    ║        ║        ║         ║
		║ 8 ║ video      ║  ✓     ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║ 9 ║ instagram  ║  ✓     ║  ✓     ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║10 ║  twitter   ║  ✓     ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║11 ║ douyu      ║  ✓     ║        ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║12 ║pixivision  ║        ║  ✓     ║         ║
		║---║------------║--------║--------║---------║
		║   ║            ║        ║        ║         ║
		║13 ║ pornhub    ║  ✓     ║        ║         ║

	ENDofTable

    if [ -e "/usr/local/bin/annie" ]; then
        #AnnieVersion=$(annie -v | cut -d ':' -f 2 | cut -d ',' -f 1 | awk -F ' ' '$0=$NF')
        AnnieVersion=$(cat ~/.config/tmoe-linux/annie_version.txt | head -n 1)
        check_latest_video_download_tool_version

    else
        AnnieVersion='您尚未安装annie'
        printf "%s\n" "检测到您${RED}尚未安装${RESET}annie，跳过${GREEN}版本检测！${RESET}"
    fi

    printf "%s\n" "按${GREEN}回车键${RESET}将同时更新${YELLOW}annie、you-get和youtube-dl${RESET}"
    printf '%s\n' 'Press Enter to update'
    RETURN_TO_WHERE='download_videos'
    do_you_want_to_continue
    DEPENDENCY_01=""
    DEPENDENCY_02=""

    if [ ! $(command -v python3) ]; then
        DEPENDENCY_01="${DEPENDENCY_01} python3"
    fi

    if [ ! $(command -v ffmpeg) ]; then
        case "${ARCH_TYPE}" in
        "amd64" | "arm64")
            cd /tmp
            rm -rf .FFMPEGTEMPFOLDER
            git clone -b linux_$(uname -m) --depth=1 https://gitee.com/mo2/ffmpeg.git ./.FFMPEGTEMPFOLDER
            cd /usr/local/bin
            tar -Jxvf /tmp/.FFMPEGTEMPFOLDER/ffmpeg.tar.xz ffmpeg
            chmod +x ffmpeg
            rm -rf /tmp/.FFMPEGTEMPFOLDER
            ;;
        *) DEPENDENCY_01="${DEPENDENCY_01} ffmpeg" ;;
        esac
    fi
    #检测两次
    if [ ! $(command -v ffmpeg) ]; then
        case "${ARCH_TYPE}" in
        "amd64" | "arm64") DEPENDENCY_01="${DEPENDENCY_01} ffmpeg" ;;
        esac
    fi

    if [ ! $(command -v pip3) ]; then
        if [ "${LINUX_DISTRO}" = 'debian' ]; then
            apt update 2>/dev/null
            apt install -y python3 python3-distutils 2>/dev/null
        else
            ${TMOE_INSTALLATION_COMMAND} ${DEPENDENCY_01} ${DEPENDENCY_02}
        fi
        cd /tmp
        curl -LO https://gitee.com/mo2/get-pip/raw/master/.get-pip.tar.gz.00
        curl -LO https://gitee.com/mo2/get-pip/raw/master/.get-pip.tar.gz.01
        cat .get-pip.tar.gz.* >.get-pip.tar.gz
        tar -zxvf .get-pip.tar.gz
        python3 get-pip.py -i https://mirrors.bfsu.edu.cn/pypi/web/simple
        rm -f .get-pip.tar.gz* get-pip.py
    fi
    #检测两次
    if [ ! $(command -v pip3) ]; then
        if [ "${LINUX_DISTRO}" = 'debian' ]; then
            DEPENDENCY_02="${DEPENDENCY_02} python3-pip"
        else
            DEPENDENCY_02="${DEPENDENCY_02} python-pip"
        fi
    fi

    if [ ! -z "${DEPENDENCY_01}" ] && [ ! -z "${DEPENDENCY_02}" ]; then
        beta_features_quick_install
    fi

    cd /tmp
    if [ ! $(command -v pip3) ]; then
        curl -LO https://gitee.com/mo2/get-pip/raw/master/.get-pip.tar.gz.00
        curl -LO https://gitee.com/mo2/get-pip/raw/master/.get-pip.tar.gz.01
        cat .get-pip.tar.gz.* >.get-pip.tar.gz
        tar -zxvf .get-pip.tar.gz
        if [ -f "get-pip.py" ]; then
            rm -f .get-pip.tar.gz*
        else
            curl -LO https://bootstrap.pypa.io/get-pip.py
        fi
        python3 get-pip.py -i https://mirrors.bfsu.edu.cn/pypi/web/simple
        rm -f get-pip.py
    fi

    rm -rf ./.ANNIETEMPFOLDER
    git clone -b linux_${ARCH_TYPE} --depth=1 https://gitee.com/mo2/annie ./.ANNIETEMPFOLDER
    cd ./.ANNIETEMPFOLDER
    tar -Jxvf annie.tar.xz
    chmod +x annie
    mkdir -p ~/.config/tmoe-linux/
    mv -f annie_version.txt ~/.config/tmoe-linux/
    mv -f annie /usr/local/bin/
    annie -v
    cd ..
    rm -rf ./.ANNIETEMPFOLDER
    #mkdir -p ${HOME}/.config
    #pip3 config set global.index-url https://mirrors.bfsu.edu.cn/pypi/web/simple
    pip3 install pip -U -i https://mirrors.bfsu.edu.cn/pypi/web/simple 2>/dev/null
    pip3 install you-get -U -i https://mirrors.bfsu.edu.cn/pypi/web/simple
    you-get -V
    pip3 install youtube-dl -U -i https://mirrors.bfsu.edu.cn/pypi/web/simple
    youtube-dl -v 2>&1 | grep version
    printf "%s\n" "更新完毕，如需${YELLOW}卸载${RESET}annie,请输${YELLOW}rm /usr/local/bin/annie${RESET}"
    printf "%s\n" "如需卸载you-get,请输${YELLOW}pip3 uninstall you-get${RESET}"
    printf "%s\n" "如需卸载youtube-dl,请输${YELLOW}pip3 uninstall youtube-dl${RESET}"
    printf "%s\n" "请问您是否需要将pip源切换为BFSU源[Y/n]?"
    printf "%s\n" "If you are not living in the People's Republic of China, then please type ${YELLOW}n${RESET} .${PURPLE}[Y/n]${RESET}"
    RETURN_TO_WHERE='download_videos'
    do_you_want_to_continue
    pip3 config set global.index-url https://mirrors.bfsu.edu.cn/pypi/web/simple

    printf '%s\n' 'Press Enter to start annie'
    printf "%s\n" "${YELLOW}按回车键启动annie。${RESET}"
    read
    golang_annie
}
##################
download_videos
