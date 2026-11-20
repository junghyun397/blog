+++
title = "Proxmox 에서의 Nvidia GPU 절전 방법"
date = 2026-11-19
draft = true
+++

Proxmox 에서 GPU 를 패스스루로 VM 에 넘겨주면 패스스루된 GPU 를 VM 이 완전히 소유하게 되기 때문에 P8 상태에 진입해 1-2W 수준의 전력으로 대기할 수 있습니다.

문제는 GPU 는 DMA 를 사용하기 때문에 메모리 전체에 대한 접근 권한을 가져야 한다는 것 입니다. 즉, 아이들 상태가 많은 VM의 최소 메모리를 512 MB 로 정해 두고 24 GB 정도를 벌루닝으로 할당해 메모리를 절약하는 운영은 원천 봉쇄됩니다.

이 문제로 GPU 를 할당한 VM 

GPU 를 어디에도 할당하지 않았을 때 바인딩되는 VFIO 는 절전을 기대할 수 없습니다. 벽전력 기준 10W 를 꾸준히 뽑아먹게 되기 때문입니다.

## Debian 설치
## 메모리 절약 설정

## Script Hook 구성
Proxmox Script Hook 을 사용하면 GPU 를 할당시킬 VM 이 켜지거나 꺼질 때 Holder VM 을 켜고 끌 수 있습니다.

```shell
```

