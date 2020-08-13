+++
author = "junghyun397"
title = "리눅스에서 Corsair 수냉쿨러 컨트롤 하기"
date = 2020-08-13T12:21:07+09:00
description = "리눅스에서 Asetek사의 펌프가 포함된 수냉쿨러를 컨트롤 하는 방법을 알아봅니다."
categories = ["linux"]
tags = ["cooling", "system"]

+++

우선 전 Corsair 사의 일체형 쿨러인 ``H100i v2``를 4년간 사용하고 있었습니다. 우분투 18.04를 사용할 때는 윈도우에서 작동하는 CorsairLink에서 설정한 값이 잘 유지가 되었었지만, 어째 20.04로 넘어오니 부팅할 때 마다 수냉쿨러 설정값이 초기화 되더군요. 극저소음 빌드를 지향했기에 펌프와 팬 두 개가 웅웅대는 소음이 여간 거슬리는 게 아니었습니다. 물론 이를 해결할 수 있는 CorsairLink는 당연하게도(...) 리눅스를 지원하지 않았습니다. 

CorsairLink에서 수냉쿨러에 USB로 어떤 패킷을 보내는지 덤프라도 떠 봐야 하나 싶었지만, 이미 [OpenCorsairLink](https://github.com/audiohacked/OpenCorsairLink)라는 훌륭한 해결책이 존재했습니다. 직접 확인 해본건 아니지만, NEXT Kraken 제품군에도 먹힌다는걸 보면 ``Asetek OEM`` 펌프는 대부분 호환되지 않을까 싶습니다.

* 당연하지만 ``OpenCorsairLink``를 사용하기 위해서는 수냉쿨러가 메인보드와 USB로 연결되어 있어야 합니다.

설치를 위해 우선 ``OpenCorsairLink`` 저장소를 클론한 뒤 빌드합니다.

```sh
git clone https://github.com/audiohacked/OpenCorsairLink.git
cd OpenCorsairLink
make
```

빌드를 마쳤다면 OpenCorsairLink가 ``OpenCorsairLink.elf`` 로 출력된걸 확인할 수 있습니다.

```sh
sudo ./OpenCorsairLink --version
```

``Dev=0, CorsairLink Device Found: H100i Pro!`` 와 같이 프로그램의 버전과 USB로 연결된 수냉쿨러의 디바이스 번호를 알아낼 수 있습니다. 여기서 ``Dev=0``만 기억하면 됩니다.

```sh
./OpenCorsairLink --help  # 번역할 필요가 있을까 싶지만 반만 번역해 봤습니다.
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
			 1 - 깜빡임 (Only Commander Pro and Asetek Pro)
			 2 - 색 박동 (Only Commander Pro and Asetek Pro)
			 3 - 색 변화 (Only Commander Pro and Asetek Pro)
			 4 - 무지개 (Only Commander Pro and Asetek Pro)
			 5 - 온도 (Only Commander Pro, Asetek, and Asetek Pro)
		Colors: <HTML Color Code>			:Define Color for LED.
		Warn: <HTML Color Code>		:Define Color for Warning Temp.
		Temps: <Temperature in Celsius>	:Define Warning Temperatures.

	Fan:
	--fan channel=N,mode=N,pwm=PWM,rpm=RPM,temps=TEMP:TEMP:TEMP,speeds=SPEED:SPEED:SPEED
		Channel: <fan number> :Selects a fan to setup. Accepted values are 1, 2, 3 or 4.
		Modes:
			 0 - 고정 PWM (requires to specify the PWM)
			 1 - 고정 RPM (requires to specify the RPM)
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

