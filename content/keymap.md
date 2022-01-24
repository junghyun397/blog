---
author: junghyun397
title: 단축키 페이지 
date: 2021-12-28:06:40+09:00
description: 자주 사용하는 Vim/Bash/Sed 명령어들을 Mnemonic 과 함께 모았습니다.
comments: true
ShowToc: true
math: false
searchHidden: true
---

# Sed

# Vim

## Operator
``d``: ``D``elete 

``y``: ``Y``ank 

``%``: whole

## Navigation

### Word
``w``: for``W``ard ``→``

``e``: ``E``nd ``→``

``b``: ``B``ackward ``←``

### Line
``0``: same as ``Zero`` ``←``

``^``: ``^0`` ``←``

``$``: /some/path``$`` ``→``

### Screen
``C-u``: ``U``p ``↑``

``C-d``: ``D``own ``↓``

``gg``: ``G``o top ``↑``

``G``: ``G``o Bottom ``↓``

### Document

``N-G``: ``G```o N line

``gi``: ``G``o ``I``nteraction

## Edit 

### Insert
``a``: ``A``head ``→`` ``^->->``

``i``: ``I``nternal ``←`` ``^<-<-``

``o``: ``O``pen ``↓`` ``^↑``

``c``: ``C``lear

### Command
``x``: same as ``Delete`` ``→`` ``^←`` 

``p``: ``P``ast ``↓``

``u``: ``U``ndo ``←`` 

``C-r``: ``R``edo ``→``

### Clipboard
``yy``: ``Y``ank line

``dd``: ``D``uplicate ``D``elete line

``p``: ``P``aste ``↓`` ``^↑``

### Etc
``C-o``: ``O``peration

``C-r``: calculaor``R``

``iw``: ``I``n ``W``ord

``aw``: ``A``round ``W``ord

# Bash/ZSH

```
 ^A %B ^B ^F %F   ^E
  <--<--<-->-->---->
  |  |  |  |  |    |
$ cp monfichier dir/
  <--<-------->---->
 ^U ^W       %D   ^K
```

``C-a``: ``A``head ``<-<-``

``C-e``: ``E``nd ``->->``

``C-f``: ``F``orward character ``->``

``C-b``: ``B``ackward character ``<-``

``A-f``: ``F``orward word ``->``

``A-b``: ``B``ackward word ``<-``

``C-k``: Clear to end of line ``->->``

``C-u``: Clear to beginning of line ``<-<-``
