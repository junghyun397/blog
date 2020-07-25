+++
toc = true
author = "junghyun397"
title = "Ubuntu 20.04 LTS 설치 후 작업환경 구성하기"
date = 2020-04-25T19:00:00+09:00
description = "최근 릴리스 된 우분투 20.04 장기 지원 버전을 기준으로 설치 후 필요한 작업 환경 구성 과정을 정리해 봤습니다."
categories = ["linux"]
tags = ["ubuntu", "gnome"]
+++

``우분투 20.04 장기 지원 버전(LTS)`` 이 릴리스 되었습니다. 매번 OS를 새로 설치할 때마다 삽질하지 않도록 우분투를 처음 설치했을 때 작업 환경을 세팅하는 과정을 글로 정리해 봤습니다. ``ifcitx-hangul`` 설정과 ``uim-byeoru`` 설정, ``oh-my-zsh`` 설정과 ``vundle`` 등의 설정을 포함합니다.

* 개인적으로 사용하기 위해 정리한 성격이 강한 글입니다.
* 최소한 ``22.04 LTS``가 나오기 전까지는 계속 업데이트될 예정입니다.
* ``Ubuntu 20.04 LTS``, 영문 기준으로 작성되었으며, ``RYZEN 1700 + GTX1080 + NVMe SSD `` 데스크톱과 ``DELL XPS 13 9350`` 랩톱 하드웨어에서 정상 작동을 확인했습니다.

본격적으로 환경을 구성하기 전에, 저장소 업데이트 및 ``git``, ``curl``, ``vim``, ``build-essential``, ``cmake``, ``clang`` 을 설치해 줘야 합니다.

```shell
sudo apt update
sudo apt install git vim curl
sudo apt install build-essential cmake clang
```


## Shell Extension {#shell-extension}

**GNOME Tweaks/Extension**: 심각할 정도로 부실하기 짝이 없는 GNOME의 Settings를 *그나마 덜* 심각하게 바꿔줄 앱입니다.

```shell
sudo apt install gnome-tweak-tool
sudo apt install gnome-shell-extensions
```

**Remap Control <-> CapsLock**: CapsLock 키의 위치는 적폐입니다. 그리 좋은 자리가 Control이 아니라 잘 쓰지도 않는 Caps키라니요. ``tweaks`` > ``Keyboard&Mouse`` > ``Keyboard`` > ``Additional Layout Options`` > ``Ctrl position`` > ``Swap Ctrl and Cpas Lock`` 을 활성화하여 청산합니다.

**Dash-to-dock**: 왼쪽으로 정렬되는 Ubuntu Dock를 Dash 스타일로 바꿔주는 Extension입니다. 

```shell
mkdir /tmp/dash-to-dock
cd /tmp/dash-to-dock
git clone https://github.com/micheleg/dash-to-dock.git
make
make install
```

설치 이후 ``Shrink the dash`` 활성화, ``Dock size limit``  ``90%`` , ``Icon size limit`` 를 ``40px`` 로 설정합니다.

**KDE Connect**: KDE 에서 제공하는 모바일-PC 연결 기능인 ``KDE Connect`` 를 GNOME 에서도 사용할 수 있게 해줍니다.

## Keyboard Input - 한글 {#keyboard-input-hangul}

한국인 우분투 사용자의 최대 난제, 한글 입력 문제입니다. 보통 ``fcitx-hangul``, ``uim-byeory``, ``ibus-hangul`` 을 많이 사용하는데, 여기서는 현시점에서 가장 쓸만 하다고 판단되는 ``fcitx-gangul`` 과 ``uim-byeoru`` 설치법만을 소개하겠습니다.

**fcitx-hangul**: 맞습니다. 악명이 자자한 가장 유명한 한글 입력기, ``fcitx`` 입니다. 예전보다 악명은 많이 줄었지만, 아직은 **크롬에서 사용 시 심각한 수준으로 불안정**한 모습을 보여 줍니다. 영 내키지는 않아도 ``fcitx`` 를 설치해 놓을 이유는 있습니다. **snap로 설치한 앱에서는 uim을 이용한 한글 입력이 불가능**합니다. 꼭 snap으로 설치한 앱에서 한글을 적어야 한다면, fcitx도 따로 설치해 두시기를 권장 드립니다. 우선 ``fcitx-hangul`` 을 설치합니다.

```shell
sudo apt install fcitx-hangul
```

``Setting`` > ``Region & Language`` > ``Manage installed Language`` > ``Keyboard input method system`` > ``fcitx`` 을 선택해 ``fcitx-hangul`` 을 적용한 이후 ``Region & Language`` 로 다시 돌아가, ``+`` 버튼을 눌러 ``Korean(Hangul)`` 을 찾아 적용합니다.

``Korean(Hangul)`` 을 적용했다면, 우측 상단에 보이는 ``EN`` 아이콘을 누른 뒤, ``setup`` 을 선택해 ``Hangul`` 과 ``Shift+Space`` 를 지우고 오른쪽 Alt를 눌러 ``Alt_R`` 을 인식시키면 이제 오른쪽 Alt키를 이용해 한글-영문을 전환할 수 있습니다.

**uim-byeoru**: **그나마** 안정적인 한글 입력기입니다. 한글이 아예 적히지 않는 경우가 적지 않지만, 깨져서 나온다거나 글자가 증발한다던가 하는 불안정한 동작은 확실히 ``fcitx`` 에 비해 덜합니다. 우선 ``uim`` 과 ``uim-byeoru`` 를 설치합니다.

```shell
sudo apt install uim uim-byeoru
```

1. 설치가 완료되었다면 ``Language Support`` > ``Keyboard input method system`` > ``uim`` 을 선택해 적용합니다.
2. ``uim`` 에 진입하면 ``uim-pref-gtk`` UI 가 나옵니다. 여기서 ``Specify defuault IM`` 을 활성화한 뒤, ``Default Input Method`` 를 ``Byeoru`` 로 설정합니다.
3. 좌측 메뉴에서 ``Byeoru key binding 1`` 을 선택해 ``[Byeoru] on`` 과 ``[Byeoru] off`` 에 ``Multi_key`` 를 인식시켜야 합니다. ``Grab...`` 을 눌렀을 때, ``Alt_key`` 가 잡힌다면 4번을 거쳐야 합니다. 정상적으로 ``Multi_key`` 가 인식된다면 5번으로 넘어 갑니다.
4. ``Tweaks`` > ``Keyboard & Mouse`` > ``Compose Key`` 를 활성화해 ``Right Alt`` 를 선택해줍니다. 다시 3번으로 돌아가 오른쪽 Alt를 눌러 주면 ``Multi_key`` 로 인식이 될 것입니다.
5. ``Multi_key`` 를 인식해 ``ON/OFF`` 에 할당했다면, ``Apply`` 를 눌러 적용합니다. 적용되었다면 재부팅 하여 오른쪽 아래에 uim ui가 뜨는지 확인합니다.


## Terminal Theme {#terminal-theme}

**Solarized**: 눈에 부담이 덜 가는 무채색 계열 테마입니다.

```shell
git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git /tmp/solarized
/tmp/solarized/install.sh
```

``1, 1, YES`` 를 차례로 선택합니다. 터미널의 텍스트 컬러를 ``#A3B4B6``, 배경 컬러를 ``#292929`` 로 설정, 배경 투명 효과를 ``3%`` 정도를 줘서 마무리합니다.

## Terminal Extension {#terminal-extension}

**fonts-powerline**: ``powerline`` 문자를 지원하게 해주는 폰트입니다.

```shell
sudo apt install fonts-powerline
```

**oh my zsh**: z쉘의 사용성을 개선해주는 툴입니다. 우선 ``zsh`` 를 설치하고 기본 쉘을 ``zsh`` 로 바꿔줘야 합니다.

```shell
sudo apt install zsh
chsh -s /usr/bin/zsh
```

이후 재부팅 해보면 기본 쉘이 ``zsh`` 로 바뀐 것을 확인할 수 있습니다. 이제 ``oh my zsh`` 를 설치하면 됩니다.

```shell
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
```

**zsh-syntax-highlighting**: ``Fish shell`` 과 비슷한 방식으로 ``zsh`` 에서 타이핑한 명령어를 자동으로 HighLighting해주는 플러그인입니다. ``oh-my-zsh`` 커스텀 폴더에 플러그인 저장소를 clone해줍니다.

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

이후 ``~/.zshrc``에서 ``plugins=(git zsh-syntax-highlighting)``을 설정한 뒤, ``source ~/.zshrc``를 입력해 적용합니다.

**agnoster theme**:  ``powerline`` 폰트를 이용해 터미널을 미려하게 꾸며주는 ``agnoster`` 테마입니다. ``~/.zshrc``에서 ``THEME="agnoster"``를 설정한 뒤, ``source ~/.zshrc``를 입력해 적용합니다.

**Vundle/airline/syntastics** ``vim`` 을 위한 플러그인 관리 툴과 UI개선 플러그인, 문법 체크 플러그인입니다. 우선``~/.vim/bundle/Vundle.vim``폴더에 ``Vundle`` 을 클론 해줍니다.

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

## SDK/API {#sdk-and-api}

**Anaconda**: Python 가상 환경을 쉽게 관리하기 위한 툴입니다. 요즘은 Docker를 더 쓴다고는 하지만... 공식 홈페이지 - https://www.anaconda.com/distribution/#linux 에서 다운로드받아 설치합니다.

**Apache2 / PHP7**: 간단한 시스템 정보를 서비스하기 위해 사용합니다.

```shell
sudo apt install apache2

sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php7.4
```

**HUGO**: 블로그 포스트를 작성하고 확인하기 위해 사용합니다.

```shell
sudo apt install hugo
```

## Programming {#programming}

**Jetbrains Toolbox**: Jetbrains의 IDE를 관리해 주는 앱입니다. ``InetlliJ IDEA``, ``PyChram``, ``CLion`` 을 설치합니다. 공식 홈페이지 - https://www.jetbrains.com/ko-kr/toolbox-app/ 에서 다운로드받습니다.

## Internet {#internet}

**Chrome**: 적절한 웹 브라우저 입니다. 공식 홈페이지 - https://www.google.com/intl/en/chrome/ 에서 다운로드 받아 설치합니다.

**FileZilla**: 사실 기본 내장된 ``nautilus`` 에서도 sftp와 ftp를 지원하지만, 아무튼 설치합니다.

```shell
sudo apt install filezilla
```

**WireShark**: 패킷을 잡아서 보여주는 앱입니다. ``WireShark`` 만큼 최적화가 잘 된 앱을 본 적이 없습니다. ``WireShark`` 를 설치하고 sudo로 실행하지 않아도 패킷을 잡을 수 있도록 sudo권한을 부여합니다. 당연하겠지만 **절대 서버/공용 환경에서 따라 하시면 안 됩니다.**

```shell
sudo apt install wireshark
sudo adduser $USER wireshark
```

## Graphics {#graphics}

**GIMP**: 포토샵에 대응하는 적절한 오픈소스 이미지 편집 프로그램 입니다.

```shell
sudo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo apt update
sudo apt install gimp
```

**Blender**: 적절한 3D 그래픽 툴 입니다.

```shell
sudo add-apt-repository ppa:thomas-schiex/blender
sudo apt update
sudo apt install blender
```

## Office {#office}

**Typora**: 깔끔한 Markdown Editor입니다. 

```shell
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt update
sudo apt install typora
```

**HUGO**: 정적 블로그 생성 툴 입니다.

```shellell
sudo apt install hugo
```

## Sound/Video {#sound-and-video}

**VLC Player**: 적절한 오픈소스 미디어 플레이어 입니다.

```shell
sudo snap install vlc
```

## Etc {#etc}

```shell
sudo apt install screenfetch # 시스템 정보와 적절한 로고를 터미널에 띄워 줍니다.
sudo ubuntu-drivers autoinstall # 하드웨어 드라이버를 업데이트 합니다.
```

## Shell Theme {#shell-theme}

우선 ``~/.themes`` 폴더와 ``~/.icons`` 폴더를 생성해야 합니다.

```shell
mkdir ~/.themes
mkdir ~/.icons
```

**Sierra-dark-solid**: OSX Sierra의 디자인을 어느 정도 채용한 GTK3 테마입니다. https://www.gnome-look.org/p/1013714/ 에서 다운로드 후 ``~/.themes`` 폴더에 압축 해제해 설치 합니다.

**Flat-Remix-Blue-Dark**: 기본 아이콘들을 Flat하게 재해석한 아이콘 팩입니다. 기본 제공 아이콘 외에도 여러가지 자주 쓰는 앱들의 아이콘도 준비돼 있습니다. https://www.gnome-look.org/p/1012430/ 에서 다운로드 후 ``~/.icons`` 폴더에 압축 해제해 설치합니다.


## Dolphin Background Image {#dolphin-background}

큰 화면과 파랑 계열의 테마에 어울리는 ``단색기반 배경화면`` 과 작은 화면과 ``yaru`` 테마에 어울리는 ``그라이데션기반 배경화면`` 이 준비되어 있습니다. ``진정한 돌고래러`` 라면 배경화면도 돌고래입니다.

**ubuntu-orange**: 우분투 스타일의 그라이데션을 배경으로 사용한 바탕화면입니다. ``13.3인치`` 화면에 맞추어 제작되었으며, ``16:9``, ``3200x1800`` 해상도가 준비돼 있습니다. [여기](https://user-images.githubusercontent.com/32453112/80272788-77a45280-8707-11ea-95d8-f87149de8423.png)를 눌러 원본 크기로 다운로드 합니다.

![orange-resized](https://user-images.githubusercontent.com/32453112/80278299-088f2400-8730-11ea-9b51-71e286b0567a.png)

**blue**: 단색 파랑을 배경으로 사용한 바탕화면 입니다. ``29인치`` 화면에 맞추어 제작되었으며, ``21:9``, ``2560x1080`` 해상도가 준비돼 있습니다. [여기](https://user-images.githubusercontent.com/32453112/80272782-69563680-8707-11ea-952d-227e894c5e95.png)를 눌러 원본 크기로 다운로드 합니다.

![blue](https://user-images.githubusercontent.com/32453112/80272782-69563680-8707-11ea-952d-227e894c5e95.png)