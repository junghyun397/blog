+++
toc = true
author = "junghyun397"
title = "Ubuntu 20.04 LTS 설치 후 작업환경 구성하기"
date = 2020-04-25T19:00:00+09:00
description = "최근 릴리스 된 우분투 20.04 장기 지원 버전을 기준으로 설치 후 필요한 작업 환경 구성 과정을 정리해 봤습니다."
categories = ["linux"]
tags = ["ubuntu", "gnome"]
+++

``우분투 20.04 장기 지원 버전(LTS)`` 이 릴리스 되었습니다. 매번 OS를 새로 설치할 때마다 삽질하지 않도록 우분투를 처음 설치했을 때 작업 환경을 세팅하는 과정을 글로 정리해 봤습니다. ``Pop! shell`` 및 ``ifcitx-hangul`` 설정과 ``uim-byeoru`` 설정, ``oh-my-zsh`` 설정과 ``vundle`` 등의 설정을 포함합니다.

* 개인적으로 사용하기 위해 정리한 성격이 강한 글입니다.
* 최소한 ``22.04 LTS``가 나오기 전까지는 계속 업데이트 될 예정입니다.
* ``Ubuntu 20.04 LTS``, 영문 기준으로 작성되었으며, ``RYZEN 1700 + GTX1080 + NVMe SSD `` 데스크톱과 ``DELL XPS 13 9350`` 랩톱 하드웨어에서 정상 작동을 확인했습니다.

본격적으로 환경을 구성하기 전에,  여러 가지 도구들을 설치해 줘야 합니다. 취향껏 골라 설치하면 되겠습니다.

```shell
sudo apt update && sudo apt upgrade

# 빌드 도구
sudo apt install build-essential make cmake clang node-typescript libdbus-1-dev libssl-dev

# 설치 도구
sudo apt install cargo gdebi python3-pip ppa-purge

# 관리 도구
sudo apt install openssh-server git curl screen net-tools pm-utils

# 모니터링 도구
sudo apt install screenfetch htop tree

# GNOME 추가 기능
sudo apt install gnome-tweak-tool gnome-shell-extensions nitrogen

# 편집기 및 입력기
sudo apt install vim uim uim-byeoru
```

## Zsh Shell{#zsh-shell}

``zsh`` 를 설치하고 기본 쉘을 ``zsh`` 로 변경합니다.

```shell
sudo apt install zsh
chsh -s /usr/bin/zsh
```

로그아웃 이후 로그인하면 기본 쉘이 ``zsh`` 로 바뀐 것을 확인할 수 있습니다. 이제 zsh의 사용성을 개선해 줄 ``oh my zsh`` 를 설치할 수 있습니다.

```shell
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
```

**zsh-syntax-highlighting**: ``Fish shell`` 과 비슷한 방식으로 ``zsh`` 에서 타이핑한 명령어를 자동으로 하이라이팅 해 주는 플러그인입니다. ``oh-my-zsh`` 커스텀 폴더에 플러그인 저장소를 clone해줍니다.

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

이후 ``~/.zshrc``에서 ``ZSH_THEME="agnoster" ``와 ``plugins=(git zsh-syntax-highlighting)``을 설정한 뒤, ``source ~/.zshrc``를 입력해 적용합니다.

## GNOME Shell{#gnome-shell}

GNOME Shell을 완전히 설정하기 위해, ``Tweaks`` 앱에서 다음 설정들을 변경해야 합니다.

1. ``Keyboard & Mouse`` 에서 다음 설정을 변경해야 합니다.
	1. Control <-> CapsLock 위치 변경: CapsLock 키의 위치는 적폐입니다. 그리 좋은 자리가 Control이 아니라 잘 쓰지도 않는 Caps키라니요. ``tweaks`` > ``Keyboard&Mouse`` > ``Keyboard`` > ``Additional Layout Options`` > ``Ctrl position`` > ``Swap Ctrl and Cpas Lock`` 을 활성화하여 청산합니다.
	2. Compose Key 지정: 한글 키 또는 멀티 키가 포함되지 않는 키보드를 사용하고 있다면, 한글-영문 전환 키로 활용할 ``Compose Key`` 를 지정해야 합니다. 일반적으로 ``Alt_R`` 을 사용합니다.
2. ``Workspaces`` 에서 다음 설정을 변경해야 합니다.
   1. 정적 워크스페이스 설정: ``Static workspaces`` 를 선택해 정적 워크스페이스를 활성화합니다.

### Shell Extension

GNOME Shell에 추가 기능을 설치하고 추가 기능을 구성하기 위해, ``Shell Extension`` 을 설치하고 ``Extensions`` 앱을 이용해 추가 기능을 구성할 수 있습니다.

기본으로 제공되는 추가기능들을 비활성화/활성화 하기 위해 ``Extensions`` 앱에서 추가 기능 활성화를 설정해야 합니다. 

1. 앱 메뉴를 비활성화하기 위해 ``Applications Menu`` 를 ``disable`` 로 설정합니다.
2. 바탕화면 아이콘을 비활성화하기 위해 ``Desktop-icons`` 을 ``disable`` 로 설정합니다.
3. Ubuntu Dock를 비활성화하기 위해 ``Ubuntu Dock`` 을 ``disable`` 로 설정합니다.
4. 워크스페이스 표시기를 활성화하기 위해 ``Workspace Indicator`` 를 ``enable`` 로 설정합니다.

이후, 다음 ``Shell Extension``들을 웹 페이지에서 활성화 클릭 또는 컴파일하여 설치합니다.

#### Pop! Shell

키보드 활용도를 더욱 높여주며, ``i3wm`` 과 비슷한 타일링을 가능하게 만들어 주는 Extension인 ``Pop! Shell``입니다. 자세한 설명은 [이 링크](https://github.com/pop-os/shell)를 참조해 주세요. ``Pop! Shell`` github 저장소를 클론한 뒤 컴파일 및 설치합니다. **설치 시 단축키들이 변경됨으로, 주의해서 설치해주세요.**

```sh
cd /tmp
git clone https://github.com/pop-os/shell
cd shell
make local-install
```

#### GSConnect

https://extensions.gnome.org/extension/1319/gsconnect/ 에서 활성화할 수 있습니다.

KDE의 모바일 기기 연결 서비스인 ``KDE Connect`` 의 JavaScript 구현 버전입니다. 배터리 및 알림, 클립보드 동기화와 파일시스템 마운트 기능을 지원합니다.

#### Unite

https://extensions.gnome.org/extension/1287/unite/  에서 활성화할 수 있습니다.

타이틀 바 제거, 앱 메뉴 제거, 윈도우 버튼 위치 변경 등 GNOME 의 여러 요소를 커스터마이징 할 수 있는 확장 앱입니다.

1. Activites 영역을 비활성화하기 위해 ``Hide activities button`` 을 ``always`` 로 설정합니다.
2. 타이틀 바를 숨기기 위해 ``Hide Window titlebars`` 을 ``always`` 로 설정합니다.
3. 윈도우 타이틀을 앱 메뉴에 표시하기 위해 ``Show window title in app menu`` 을 ``always`` 로 설정합니다.
4. 윈도우 버튼을 상단 바에 표시하기 위해 ``Show window buttons in top bar`` 을 ``always`` 로 설정합니다.
5. 상단 바에 표시된 윈도우 버튼의 위치를 설정하기 위해 ``Top bar window buttons position`` 을 ``First`` 로 설정합니다.
6. 상단 바에 표시된 윈도우 버튼의 테마를 설정하기 위해 ``Top bar window buttons theme`` 을 ``Prof-Gnome`` 로 설정합니다.

**Title bar 제거**: GNOME-Terminal 은 Unite 의 Title bar 제거 옵션이 먹히지 않습니다. gsetting을 이용해 수동으로 타이틀 바를 제거합니다.

```sh
gsettings set org.gnome.Terminal.Legacy.Settings headerbar false
```

#### Block-Caribou

https://extensions.gnome.org/extension/3222/block-caribou-36/ 에서 활성화할 수 있습니다.

터치스크린 환경에서 가상 키보드 비활성화 기능이 작동하지 않는 버그를 해결 해줍니다. 가상 키보드 관련 문제가 있다면 설치하면 됩니다.


## 한글 입력 {#hangul-input}

한국인 우분투 사용자의 최대 난제, 한글 입력 문제입니다. 보통 ``fcitx-hangul``, ``uim-byeory``, ``ibus-hangul`` 을 많이 사용하는데, 여기서는 현시점에서 가장 쓸만 하다고 판단되는 ``fcitx-gangul`` 과 ``uim-byeoru`` 설치법만을 소개하겠습니다.

**fcitx-hangul**: 맞습니다. 악명이 자자한 가장 유명한 한글 입력기, ``fcitx`` 입니다. 예전보다 악명은 많이 줄었지만, 아직은 **크롬에서 사용 시 심각한 수준으로 불안정**한 모습을 보여 줍니다. 영 내키지는 않아도 ``fcitx`` 를 설치해 놓을 이유는 있습니다. **snap으로 설치한 앱에서는 uim을 이용한 한글 입력이 불가능**합니다. 꼭 snap으로 설치한 앱에서 한글을 적어야 한다면, fcitx도 따로 설치해 두시기를 권장 드립니다. 우선 ``fcitx-hangul`` 을 설치합니다.

```shell
sudo apt install fcitx-hangul
```

``Setting`` > ``Region & Language`` > ``Manage installed Language`` > ``Keyboard input method system`` > ``fcitx`` 을 선택해 ``fcitx-hangul`` 을 적용한 이후 ``Region & Language`` 로 다시 돌아가, ``+`` 버튼을 눌러 ``Korean(Hangul)`` 을 찾아 적용합니다.

``Korean(Hangul)`` 을 적용했다면, 우측 상단에 보이는 ``EN`` 아이콘을 누른 뒤, ``setup`` 을 선택해 ``Hangul`` 과 ``Shift+Space`` 를 지우고 오른쪽 Alt를 눌러 ``Alt_R`` 을 인식시키면 이제 오른쪽 Alt키를 이용해 한글-영문을 전환할 수 있습니다.

**uim-byeoru**: **그나마** 안정적인 한글 입력기입니다. 한글이 아예 적히지 않는 경우가 적지 않지만, 깨져서 나온다거나 글자가 증발한다던가 하는 불안정한 동작은 확실히 ``fcitx`` 에 비해 덜합니다.

1. ``Language Support`` > ``Keyboard input method system`` > ``uim`` 을 선택해 적용합니다.
2. ``uim`` 에 진입하면 ``uim-pref-gtk`` UI 가 나옵니다. 여기서 ``Specify defuault IM`` 을 활성화한 뒤, ``Default Input Method`` 를 ``Byeoru`` 로 설정합니다.
3. 좌측 메뉴에서 ``Byeoru key binding 1`` 을 선택해 ``[Byeoru] on`` 과 ``[Byeoru] off`` 에 ``Multi_key`` 를 인식시켜야 합니다. ``Grab...`` 을 눌렀을 때, ``Alt_key`` 가 잡힌다면 4번을 거쳐야 합니다. 정상적으로 ``Multi_key`` 가 인식된다면 5번으로 넘어 갑니다.
4. ``Tweaks`` > ``Keyboard & Mouse`` > ``Compose Key`` 를 활성화해 ``Right Alt`` 를 선택해줍니다. 다시 3번으로 돌아가 오른쪽 Alt를 눌러 주면 ``Multi_key`` 로 인식이 될 것입니다.
5. ``Multi_key`` 를 인식해 ``ON/OFF`` 에 할당했다면, ``Apply`` 를 눌러 적용합니다. 적용되었다면 로그아웃 및 로그인 하여 오른쪽 아래에 uim ui가 뜨는지 확인합니다.

## Vim{#vim}

**Vundle/airline/syntastics** ``vim`` 을 위한 플러그인 관리 툴과 UI개선 플러그인, 문법 검증 플러그인입니다. 우선``~/.vim/bundle/Vundle.vim``폴더에 ``Vundle`` 을 클론 해줍니다.

```shell
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

이후 ``~/.vimrc`` 의 제일 위쪽에 아래 설정을 추가합니다. 이 설정은 미려한 Status-bar를 표시해주는 ``vim-airline`` 플러그인과 IDE와 비슷하게 문법 오류를 체크해주는 ``vim-syntastic`` 플러그인을 포함합니다.

```shell
set nocompatible
set number
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

"" vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts=1

"" vim-syntastic
Plugin 'scrooloose/syntastic'

call vundle#end()
filetype plugin indent on

"" settings-syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
```

설정을 추가했다면 ``vim`` 을 실행한 뒤, ``:PluginInstall`` 명령어를 입력해 플러그인 설치를 완료합니다.

## Github{#github}

```shell
git config --global user.name "junghyun397"
git config --global user.email "junghyun397@gmail.com"
git config --global color.ui true
git config --global core.editor vi

ssh-keygen -t rsa -C "junghyun397@gmail.com"
cat ~/.ssh/id_rsa.pub
```

출력 된 ``id_rsa.pub`` 을 https://github.com/settings/keys 에 등록해 Github에 SSH 키 등록을 마칩니다. 이제 다음 명령어를 이용해 제대로 등록이 됐는지 확인해 볼 수 있습니다.

```shell
ssh -T git@github.com
```

## SDKs

### JDK

```shell
sudo apt install default-jre openjdk-8-jdk openjdk-11-jdk
```

### SBT

```shell
sudo apt install scala
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt update && sudo apt install sbt
```

#### Android SDK

공식 홈페이지 - https://developer.android.com/studio#command-tools 에서 ``commandlinetools`` 를 다운로드 받은 뒤 설치합니다.

```shell
mkdir .android
unzip ~/Downloads/commandlinetools-linux-*.zip
mv cmdline-tools .android/
```

``.zshrc`` 아래에 다음 내용을 추가합니다.

```shell
JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
ANDROID_HOME="$HOME/.android"

export JAVA_HOME
export ANDROID_HOME

export PATH="$PATH:$HOME/.flutter/flutter/bin"
export PATH="$PATH:$JAVA_HOME/bin:$ANDROID_HOME/commandline-tools/bin:$ANDROID_HOME/platform-tools"
```

추가된 내용을 ``source .zshrc`` 명령어로 업데이트한 뒤, ``sdkmanager`` 를 이용해 안드로이드 SDK 를 다운로드 받습니다.

```shell
sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "platforms;android-29" "platforms;android-30" "build-tools;28.0.3"
sdkmanager --sdk_root=$ANDROID_HOME --licenses
```

### Flutter

```shell
mkdir .flutter
cd .flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
```

``.zshrc`` 아래에 다음 내용을 추가합니다.

```shell
export PATH="$PATH:`pwd`/flutter/bin"
```

추가된 내용을 ``source .zshrc`` 명령어로 업데이트 한 뒤, Flutter 바이너리를 다운로드 받아 ``flutter doctor`` 를 실행해 정상 설치를 확인합니다.

```shell
flutter precache
flutter doctor --android-licenses
flutter doctor
```

## Apps{#apps}

### Chrome

```shell
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main">> /etc/apt/sources.list.d/google-chrome.list'
sudo apt update && sudo apt install google-chrome-stable
```

설치 후 ``Use System title bar and boarder`` 를 활성화 하고, ``ADBlock`` 을 설치 했다면 ``Allow Acceptable Ads`` 를 비활성화 합니다.

### Jetbrains Tool box

공식 홈페이지 - https://www.jetbrains.com/ko-kr/toolbox-app/ 에서 툴박스 앱을 다운로드 받은 뒤 설치합니다.

```shell
cd Downloads
tar -xvf jetbrains-toolbox-*.tar.gz
cd jetbrains-toolbox-*
chmod 700 jetbrrains-toolbox
./jetbrains-toolbox
```
### TeXLive

```shell
sudo apt install texlive-latex-extra
```

### Typora

```shell
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt update && sudo apt install typora
```

### Discord

```shell
wget -O ~/Downloads/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo gdebi ~/Downloads/discord.deb
```

### Spotify

```shell
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update && sudo apt install spotify-client
```

### WireShark

sudo로 실행하지 않아도 패킷을 잡을 수 있도록 sudo권한을 부여합니다. 당연하겠지만 **절대 서버/공용 환경에서 따라 하시면 안 됩니다.**

```shell
sudo apt install wireshark
sudo adduser $USER wireshark
```

### VLC

```shell
sudo apt install vlc
```

### GIMP

```shell
sudo add-apt-repository ppa:ubuntuhandbook1/gimp
sudo apt update && sudo apt install gimp
```

### Blender

```shell
sudo add-apt-repository ppa:thomas-schiex/blender
sudo apt update && sudo apt install blender
```

### VirtualBox

```shell
sudo apt install virtualbox
```

### HUGO

```shell
sudo apt install hugo
```

## Windows - UTC TimeZone{#windows-utc}

Windows는 메인보드에 저장된 시간을 현지 시간으로, 리눅스는 UTC 시간으로 해석합니다.  이를 해결하기 위해서는, 윈도우가 메인보드에 저장된 시간을 UTC로 해석하도록 설정 할 필요가 있습니다. 먼저, 시작 메뉴에서 ``regedit`` 를 타이핑해 레지스트리 편집기를 실행한 뒤, 아래의 경로를 복사해 붙여 넣습니다.

```
컴퓨터\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation
```

이후 우클릭으로 새 ``32bit`` ``DWORD`` 값을 만들고, 이름을 ``RealTimeIsUniversal`` 로 고칩니다. 만든 값을 더블클릭해 값을 ``1``로 지정한 뒤 저장합니다.

## 배경화면 {#wallpaper}

큰 화면과 파랑 계열의 테마에 어울리는 ``단색기반 배경화면`` 과 작은 화면과 ``yaru`` 테마에 어울리는 ``그라이데션기반 배경화면`` 이 준비되어 있습니다. ``진정한 돌고래러`` 라면 배경화면도 돌고래입니다.

**ubuntu-orange**: 우분투 스타일의 그라이데션을 배경으로 사용한 바탕화면입니다. ``13.3인치`` 화면에 맞추어 제작되었으며, ``16:9``, ``3200x1800`` 해상도가 준비돼 있습니다. [여기](https://user-images.githubusercontent.com/32453112/80272788-77a45280-8707-11ea-95d8-f87149de8423.png)를 눌러 원본 크기로 다운로드 합니다.

![orange-resized](https://user-images.githubusercontent.com/32453112/80278299-088f2400-8730-11ea-9b51-71e286b0567a.png)

**blue**: 단색 파랑을 배경으로 사용한 바탕화면 입니다. ``29인치`` 와 ``23인치`` 화면에 맞추어 제작되었으며, ``21:9`` ``16:9``, ``37:9(합쳐짐, 듀얼모니터 전용)``, ``2560x1080``, ``1920x1080`` 해상도가 준비되어 있습니다. [이 링크(21:9)](https://user-images.githubusercontent.com/32453112/80272782-69563680-8707-11ea-952d-227e894c5e95.png) 와 [이 링크(16:9)](https://user-images.githubusercontent.com/32453112/112414184-f87b2c80-8d64-11eb-9c7b-814b3285ecf7.png), [이 링크(37:9)](https://user-images.githubusercontent.com/32453112/112414701-d635de80-8d65-11eb-8162-f4cb31516bdf.png) 를 눌러 원본 크기로 다운로드 합니다.

![blue](https://user-images.githubusercontent.com/32453112/80272782-69563680-8707-11ea-952d-227e894c5e95.png)

### 듀얼모니터

GNOME Shell은 모니터별로 배경화면을 할당하는 기능을 제공하지 않습니다. 듀얼모니터에 서로 다른 배경화면을 설정하기 위해서는 가로로 합쳐진 이미지를 배경으로 설정한 뒤, 배경 표시 옵션을 ``spanned`` 로 설정해야 합니다.

```shell
gsettings set org.gnome.desktop.background picture-options spanned
```
