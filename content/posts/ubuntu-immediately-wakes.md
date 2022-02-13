---
author: junghyun397
title: Ubuntu 절전(Suspend)모드 풀림 해결 방법
date: 2022-02-14T04:53:20+09:00
description: 절전(Suspend)모드에 진입한 직후 알 수 없는 이유로 USB wake 신호를 받는 문제를 해결해 봅시다.
categories: [linux]
tags: [system, ubuntu]
comments: true
ShowToc: true
math: false
searchHidden: false
---

**빠른 해답: 문제가 발생하는 USB 기기의 wakeup설정을 disable로 전환하면 됩니다.**

마우스와 키보드로 절전모드(Suspend)를 해제하는 기능이 달려 있는 OS를 사용할 경우, 절전모드에 진입한 직후 알 수 없는 이유로 USB wakeup신호를 받아 PC가 다시 켜지는 문제가 발생할 수 있습니다. 이 경우, 잘못된 wakeup신호를 보내는 USB기기로부터의 wakeup신호 수신을 비활성화해 문제를 해결할 수 있습니다.

## 1. wakeup이 활성화된 USB 기기 목록 확인

문제를 해결하기 위해서는 우선 어떤 usb기기가 wakeup신호를 보내고 있는지 확인해야 합니다. 다음 명령어로 wakeup신호를 보낸 USB기기 목록을 확인합니다.

```shell
cat /sys/bus/usb/devices/*/power/wakeup
```

여기서 ``enabled``이 표시되는 위치를 기억해 둡시다. — 파일 목록과 대조해야 합니다.

```shell
ll /sys/bus/usb/devices/*/power/wakeup
```

![](https://user-images.githubusercontent.com/32453112/153777209-dfda3a00-5ace-4aa5-9f43-c14f6aee645d.png)

제 경우 3번째와 4번째 디바이스가 wakeup신호를 보내고 있었으므로, ``1-5``와 ``1-6``을 차례로 비활성화 후 경과를 확인해야 합니다. 만약 단 하나의 USB 기기만이 wakeup 신호를 보내고 있었다면, 바로 3번으로 넘어가 문제해결을 끝마칩니다.


## 2. USB 기기 식별

이대로라면 최악의 경우, 1번에서 활성화된 기기 수만큼 각각의 기기를 비활성화한 뒤 확인하는 작업을 반복해야 할 수 있습니다! 이때 우리는 Vendor ID 와 Product ID를 확인해 신호를 보내는 기기가 어떤 기기인지, *어딘가 이게 문제일 거 같은 기기*가 맞는지 확인해 작업 시간을 단축할 수 있습니다.

```shell
cat /sys/bus/usb/devices/1-5/idVendor
cat /sys/bus/usb/devices/1-5/idProduct
```

![](https://user-images.githubusercontent.com/32453112/153777247-379ccd71-fef6-439b-9031-c4d45a973705.png)

16진수 Vendor ID 와 Product ID를 확인했다면, [https://the-sz.com/products/usbid/index.php](https://the-sz.com/products/usbid/index.php)에 두 값을 넣어 제조사와 모델명을 확인합니다.

찾아보니 Vendor ID 0x046d는 Logitech이었습니다. 제 경우, 아무래도 최근에 교체한 Logitech G Pro X Superlight가 문제를 일으키는 모양입니다. ``1-5``를 먼저 비활성화해 봐야겠습니다.

## 3. wakeup 비활성화

문제가 생기는 USB 기기를 발견했다면, 문제가 생기는 USB 기기의 wakeup 설정을 disable로 바꿔 해결할 수 있습니다. root가 소유권을 가지고 있는 파일이므로 echo 와 tee를 적절히 활용해 ``disabled``를 덮어써 주면 됩니다.

```shell
echo "disabled" | sudo tee /sys/bus/usb/devices/1-5/power/wakeup
```

![](https://user-images.githubusercontent.com/32453112/153777266-1ed54c11-8bba-445e-bf6e-6a9d0c2fd2ca.png)

이제 절전모드를 켠 뒤 문제가 다시 발생하는지 확인하기만 하면 됩니다! 문제가 해결되지 않았다면, 다음 복구 명령어와 함께 1번으로 돌아가 다른 USB 기기를 비활성화시키는 과정을 반복하면 됩니다.

```shell
echo "enabled" | sudo tee /sys/bus/usb/devices/1-5/power/wakeup
```

