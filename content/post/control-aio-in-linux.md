+++
author = "junghyun397"
title = "리눅스에서 liquidctl로 수냉쿨러 컨트롤 하기"
date = 2020-08-13T12:21:07+09:00
description = "리눅스에서 수냉쿨러를 컨트롤 하는 방법을 알아봅니다."
categories = ["linux"]
tags = ["system", "hardware"]

+++

우선 전 Corsair 사의 일체형 쿨러인 ``H100i v2``를 4년간 사용하고 있었습니다. 우분투 18.04를 사용할 때는 윈도우에서 작동하는 CorsairLink에서 설정한 값이 잘 유지가 되었었지만, 어째 20.04로 넘어오니 부팅할 때 마다 수냉쿨러 설정값이 초기화 되더군요. 극저소음 빌드를 지향했기에 펌프와 팬 두 개가 웅웅대는 소음이 여간 거슬리는 게 아니었습니다. 물론 이를 해결할 수 있는 CorsairLink는 당연하게도(...) 리눅스를 지원하지 않았습니다.

CorsairLink에서 수냉쿨러에 USB로 어떤 패킷을 보내는지 덤프라도 떠 봐야 하나 싶었지만, 이미 [liquidctl](https://github.com/liquidctl/liquidctl)이라는 훌륭한 해결책이 존재했습니다. 직접 확인 해본건 아니지만, NEXT Kraken 제품군에도 먹힌다는걸 보면 ``Asetek OEM`` 펌프는 대부분 호환되지 않을까 싶습니다.

## liquidctl 설치 {#install-liquidctl}

* 당연하지만 ``liquidctl``를 사용하기 위해서는 수냉쿨러가 메인보드와 USB로 연결되어 있어야 합니다.

``liquidctl`` 은 pip를 이용해 배포됩니다. pip3 를 이용해 ``liquidctl`` 을 설치합니다.

```shell
sudo pip3 install liquidctl
```

이제 ``liquidctl`` 명령어를 이용해서 수냉쿨러를 컨트롤 할 수 있습니다! 우선, 아래 명령어를 이용해 ``liquidctl``이 지원하는 수냉쿨러를 사용하고 있는지 확인합니다.

```shell
liquidctl list
```

``Device ID 0: Corsair H100i Pro XT (experimental)`` 과 같은 장치가 보인다면 ``liquidctl`` 을 사용할 수 있는 상태입니다. [liquidctl README.md](https://github.com/liquidctl/liquidctl#supported-devices) 에서 사용하고 있는 장치에서 사용할 수 있는 명령어를 확인 할 수 있습니다.

## 명령어 {#commands}

* 기기마다 사용 가능한 명령어들이 모두 다릅니다! [liquidctl README.md](https://github.com/liquidctl/liquidctl#supported-devices) 에서 자신이 사용하고 있는 기기 페이지에 들어가 사용 가능한 명령어 조합을 확인해 주세요. 아래 명령어들은 제가 사용 중인 ``Corsair H100i Pro XT`` 에서 작동하는 몇 가지 명령어들에 대한 소개입니다.

**``liquidctl initialize --pump-mode <mode>``** : 수냉쿨러를 초기화 하면서 펌프 모드를 설정할 수 있는 명령어입니다. ``quiet``, ``balanced``, ``extreme`` 로 펌프 모드를 설정할 수 있습니다. ex) ``liquidctl initialize --pump-mode quiet`` 명령어로 수냉쿨러를 조용한 모드로 초기화 할 수 있습니다.

**``liquidctl set <fan> speed <temperature> <duty> <temperature1> <duty1> ...``** : 수냉쿨러에 연결된 팬 속도를 온도에 따라 조정할 수 있는 명령어입니다. 온도는 수냉쿨러 냉각수 온도를, 속도는 백분율 단위로 작성되어야 합니다. ex) ``liquidctl set fan speed 40 10 65 40`` 명령어로 수온이 40도일 때 팬을 10% 로, 수온이 65도일 때 팬을 40% 속도로 돌리도록 설정할 수 있습니다.

**``liquidctl set led color <mode> <colors>``** : 수냉쿨러의 자켓에 달린 LED 색을 설정할 수 있는 명령어입니다. ex) ``liquidctl set led color super-fixed 2000ff 2000ff 2000ff 2000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff --unsafe=pro_xt_lighting`` 명령어로 자켓에 달린 개별 LED 를 각각 HTML 색상 코드로 항상 켜져있도록 설정할 수 있습니다.

이외에도 더 많은 명령어들이 있습니다!

## 서비스 등록 {#register-service}

시스템 부팅과 함께 ``liquidctl`` 이 시작될 수 있도록, ``liquidctl`` 을 서비스로 등록해야 합니다. ``liquidcfg.service`` 파일을 만들어 서비스를 생성합니다.

```shell
sudo vi /etc/systemd/system/liquidcfg.service
```

``liquidcfg.service`` 에 아래 스크립트를 붙여놓고 저장합니다. 아래 스크립트는 ``Corsair H100i Pro XT`` 를 기준으로 작성된 스크립트로, 펌프를 ``quiet`` 모드로, 팬 속도를 ``사용자 지정 곡선``으로, LED를 ``파란색``과 ``보라색``으로 설정하는 코드를 ``시스템 부팅``시 ``10초 뒤`` 실행하는 코드입니다.

```shell
[Unit]
Description=AIO initialize service

[Service]
Type=oneshot
ExecStart=sleep 10
ExecStart=liquidctl initialize --pump-mode quiet
ExecStart=liquidctl set fan speed 40 10 50 20 60 30 65 40
ExecStart=liquidctl set fan1 speed 40 10 50 20 60 30 65 40
ExecStart=liquidctl set led color super-fixed 2000ff 2000ff 2000ff 2000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff 0000ff --unsafe=pro_xt_lighting

[Install]
WantedBy=default.target
```

이제 등록된 ``liquidcfg.service`` 서비스를 아래 명령어로 활성화 할 수 있습니다.

```shell
sudo systemctl enable liquidcfg
sudo systemctl start liquidcfg
```

좋습니다! 이제 부팅과 함께 ``liquidcfg`` 서비스가 실행될 것 입니다. 하지만 여기 한 가지 문제가 남았습니다: 시스템이 ``sleep mode`` 에 들어갔다 다시 부팅됐을 때, 수냉쿨러를 다시 초기화 할 방법이 없습니다. 이를 위해서는 시스템이 ``sleep mode`` 에서 부팅될 때 수냉쿨러를 초기화 할 스크립트를 추가로 작성할 필요가 있습니다.

## Sleep-mode 스크립트 등록 {#register-sleep-mode-script}

``liquidcfg.sh`` 파일을 만들어 스크립트를 생성합니다.

```shell
sudo vi /lib/systemd/system-sleep/liquidcfg.sh
```

``liquidcfg.sh`` 에 앞서 등록한 서비스를 실행시키는 아래 스크립트를 붙여넣고 저장합니다.

```shell
#!/bin/bash
sudo systemctl start liquidcfg
```

작성된 스크립트가 실행될 수 있도록 권한을 설정하면 끝입니다!

```shell
sudo chmod a+x /lib/systemd/system-sleep/liquidcfg.sh
```

## OpenCorsairLink {#OpenCorsairLink}

* 만약 ``liquidctl`` 이 먹히지 않는다면, 아래 ``OpenCorsairLink`` 앱을 이용하는 방법을 참조 해주세요. ``liquidctl`` 이 나오기 전까지 사용하던 방법이자, 무려 이 글의 본문이었던 글 입니다.

설치를 위해 우선 ``OpenCorsairLink`` 저장소를 클론한 뒤 빌드합니다.

```sh
git clone https://github.com/audiohacked/OpenCorsairLink.git
cd OpenCorsairLink
make
```

빌드를 마쳤다면 OpenCorsairLink가 ``OpenCorsairLink.elf`` 로 출력된걸 확인할 수 있습니다.

```sh
sudo ./OpenCorsairLink.elf --version
```

``Dev=0, CorsairLink Device Found: H100i Pro!`` 와 같이 프로그램의 버전과 USB로 연결된 수냉쿨러의 디바이스 번호를 알아낼 수 있습니다. 여기서 ``Dev=0``만 기억하면 됩니다. 이제 OpenCorsairLink 바이너리를 이용해 수냉쿨러를 컨트롤 할 수 있습니다!

```sh
./OpenCorsairLink.elf --help  # 번역할 필요가 있을까 싶지만 반만 번역해 봤습니다.
Options:
	--help				:이 메시지를 프린트 합니다.
	--version			:버전을 표시 합니다.
	--debug				:디버그 메시지를 표시 합니다.
	--dump				:--debug를 의미합니다. 디바이스에서 받은 raw데이터를 덤프합니다.
	--machine			:쿨러의 상태를 읽을 수 있는 포맷으로 표시해 줍니다.
	--device <Device Number>	:장치를 선택합니다.

	LED:
	--led channel=N,mode=N,colors=HHHHHH:HHHHHH:HHHHHH,temps=TEMP:TEMP:TEMP
		Channel: <led number> :설정할 LED채널을 선택합니다. 1 또는 2를 적으세요.
		Mode:
			 0 - 정적
			 1 - 깜빡임 (커맨더 프로 또는 아세텍 프로와 호혼)
			 2 - 색 박동 (커맨더 프로 또는 아세텍 프로와 호혼)
			 3 - 색 변화 (커맨더 프로 또는 아세텍 프로와 호혼)
			 4 - 무지개 (커맨더 프로 또는 아세텍 프로와 호혼)
			 5 - 온도 (커맨더 프로 또는 아세텍, 아세텍 프로와 호혼)
		Colors: <HTML Color Code>			:Define Color for LED.
		Warn: <HTML Color Code>		:Define Color for Warning Temp.
		Temps: <Temperature in Celsius>	:Define Warning Temperatures.

	Fan:
	--fan channel=N,mode=N,pwm=PWM,rpm=RPM,temps=TEMP:TEMP:TEMP,speeds=SPEED:SPEED:SPEED
		Channel: <fan number> :Selects a fan to setup. Accepted values are 1, 2, 3 or 4.
		Modes:
			 0 - 고정 PWM (PWM 지정 필요)
			 1 - 고정 RPM (RPM 지정 필요)
			 2 - 기본
			 3 - 정죽
			 4 - 균형
			 5 - 퍼포먼스
			 6 - 커스텀 커브
		PWM <PWM Percent> 	:The desired PWM for the selected fan. NOTE: it only works when fan mode is set to Fixed PWM
		RPM <fan RPM> 	:The desired RPM for the selected fan. NOTE: it works only when fan mode is set to Fixed RPM
		For Custom Curves:
			Temps <C>	:Define Celsius Temperatures for Fan.
			Speeds <Percentage>	:Define Values of RPM Percentage for Fan.

	Pump:
	--pump mode=<mode>
		Modes:
			 3 - 정숙
			 4 - 균형
			 5 - 퍼포먼스
```

아래는 디바이스 0에 해당하는 수냉쿨러에 대해, LED 채널 1에 대해 정적 모드로 ``#1500ff`` 를 표시하며, 쿨링팬 채널 1에 대해 ``정숙모드``를 설정하고 펌프를 ``균형 모드``로 설정하는 명령어 입니다.

```sh
sudo ./OpenCorsairLink.elf --device 0 --led channel=1,mode=0,colors=1500ff --fan channel=1,mode=3 --pump mode=4
```

적당히 쉘 스크립트로 만들어서 ``crontab`` 에 등록 하거나 해서 활용 하면 되겠습니다. ``Corsair H100i v2``와 ``Corsair H100i PRO RGB``에서 정상 작동을 확인 했습니다.

```sh
@reboot YOUR-PATH/ConfigureAIO.sh
```

- ``crontab``에 ``@reboot``로 등록한  task는 ``suspend``와 같은 ``stand-by-mode``상태 이후에 자동으로 실행되지 않습니다. ``.bashrc``나 ``.zshrc``에 PATH를 등록해서 수동으로 스크립트를 실행해 줘야 합니다.

```sh
export PATH="$PATH:YOUR-PATH"
```



