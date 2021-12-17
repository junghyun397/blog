---
author: junghyun397
title: Github Actions로 Flutter 앱 빌드하기
date: 2021-03-26T15:27:32+09:00
description: Github Actions를 이용해 Flutter 앱을 여러 플랫폼으로 빌드하는 방법을 정리해 봤습니다.
categories: [devops]
tags: [flutter, CI/CD]
---

요즘 Github Actions 가 그렇게 맛집이라고 하더군요! 그래서 해 봤습니다: Github Actions 로 Flutter 앱 빌드하기. 이 글에서는 Github Actions에서 Flutter 앱을 Android APK 또는 AppBundle 로 빌드하는 방법을 소개하며, (작동하는지는 불확실하지만,) IOS ipa로 빌드하는 방법도 함께 소개합니다.

## Secret 등록 {#upload-secret}

안드로이드 앱을 스토어에 등록하기 위해서는(=릴리스모드로 빌드하기 위해서는) ``Android Keystore`` 가 필요합니다. 

``Settings`` > ``Secrets`` > ``Actions secrets`` 에서 ``Secrets`` 들을 등록해야 합니다.

1. ``ANDROID_KEYSTORE_BASE64`` 등록: ``key.jks`` 를 ``base64`` 로 인코딩한 문자열을 등록해야 합니다. ``base64 key.jks`` 명령어로 인코딩된 문자열을 등록합니다.
2. ``ANDROID_KEYSTORE_PASSWORD`` 등록: ``key.properties`` 파일에 등록된 키스토어 비밀번호를 등록합니다.
3. ``ANDROID_KEY_ALIAS`` 등록: ``key.properties`` 파일에 등록된 키스토어 Alias 를 등록합니다.
4. ``ANDROID_KEY_PASSWORD`` 등록: ``key.properties`` 파일에 등록된 키 비밀번호를 등록합니다.

## Workflow 파일 작성 {#generate-workflows}

``Secret`` 들을 등록 했다면, ``Workflow`` 파일을 생성해 CI 스크립트를 작성해 작업을 마무리할 수 있습니다. 우선, 저장소에 ``.github`` / ``workflows`` / ``flutter.yml`` 파일을 생성해 workflow 파일을 생성합니다.

```yaml
name: Flutter CI

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]
```

 ``master`` branch 의 push와 pull request 이벤트에 실행되는 ``Flutter CI Action`` 을 정의합니다.

### Android 빌드 {#build-android}

```yaml
jobs:
  build_android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Flutter
        uses: subosito/flutter-action@v1.4.0
        with:
          channel: 'stable'
```

Flutter를 사용하기 위해, ``ubuntu-latest`` 에서 ``Flutter Actions`` 을 사용해 환경을 갖춥니다.

```yaml
      - name: Download Android keystore
        id: android_keystore
        uses: timheuer/base64-to-file@v1.0.3
        with:
          fileName: key.jks
          encodedString: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
      - name: Create key.properties
        run: |
          echo "storeFile=${{ steps.android_keystore.outputs.filePath }}" > android/key.properties
          echo "storePassword=${{ secrets.ANDROID_KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}" >> android/key.properties
```

안드로이드 앱 빌드를 위해,  앞서 업로드 했던 Android Keystore를 다운로드하고 배치합니다. ``key.jks`` 파일을 배치하고, 앞서 업로드한 ``ANDROID_KEYSTORE_PASSWORD`` , ``ANDROID_KEY_PASSWORD`` , ``ANDROID_KEY_ALIAS`` 를 ``key.properties`` 파일에 작성합니다. 이 부분의 출처는 [Albert221의 flutter-release.yml 스크립트](https://gist.github.com/Albert221/ede4eab3cade98070f37bfa0f646fd19#file-flutter-release-yml)입니다.

```yaml
      - name: Install dependencies
        run: flutter pub get
      - name: Build APK
        run: flutter build apk --release
```

의존 패키지들을 설치하고, 릴리즈 모드로 apk 파일을 빌드합니다. ``apk`` 대신 ``appbundle`` 을 사용하면 ``appbundle`` 을 빌드할 수 있습니다.

```yaml
      - name: Rename APK
        run: mv build/app/outputs/flutter-apk/app-release.apk ./ExampleApp-SNAPSHOT.apk
      - name: Archive APK
        uses: actions/upload-artifact@v1
        with:
          name: android-build
          path: ./ExampleApp-SNAPSHOT.apk
```

빌드된 apk 파일의 이름을 바꾸고, ``artifact`` 로 업로드 합니다. 이 부분을 플레이 스토어에 publish 하는 기능으로 바꿔 Continuous Delivery를 구현할 수도 있습니다!

### IOS 빌드 {#build-ios}

IOS 빌드를 원한다면, 이 코드를 추가로 삽입하면 됩니다. 이 코드는 ``ipa`` 추출 전 단계의 폴더를 압축해 ``artifact``에 업로드하는 코드입니다. 하지만 안타깝게도 전 ``Apple Developer Program`` 이 없기에, ``ipa`` 빌드는 실험 해볼 수 없었습니다. 언제가 될지는 모르겠지만, ``99 USD / Year`` 의 ``Apple Developer Program`` 을 얻게 된다면 글을 업데이트 하도록 하겠습니다!

```yaml
  build_ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Flutter
        uses: subosito/flutter-action@v1.4.0
        with:
          channel: 'stable'
      - name: Install dependencies
        run: flutter pub get
      - name: Build IOS
        run: flutter build ios --release --no-codesign

#      - name: Export IPA
#        run: |
#          cd ios
#          xcodebuild -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath $PWD/build/Runner.xcarchive
#          xcodebuild -exportArchive -archivePath $PWD/build/Runner.xcarchive -exportOptionsPlist ExportOptions.plist -exportPath $PWD/build/Runner.ipa
#      - name: Rename IPA
#        run: mv ios/build/Runner.ipa/Runner.ipa ./ExampleApp-SNAPSHOT.ipa
#      - name: Archive IPA
#        uses: actions/upload-artifact@v1
#        with:
#          name: ios-build
#          path: ./ExampleApp-SNAPSHOT.ipa

      - name: Archive IOS
        uses: actions/upload-artifact@v1
        with:
          name: ios-build
          path: build/ios/iphoneos
```

### Flutter.yml {#flutter-yml}

완성된 ``Flutter.yml`` 은 다음과 같습니다:

```yml
name: Flutter CI

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]
jobs:
  build_android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Flutter
        uses: subosito/flutter-action@v1.4.0
        with:
          channel: 'stable'
      - name: Download Android keystore
        id: android_keystore
        uses: timheuer/base64-to-file@v1.0.3
        with:
          fileName: key.jks
          encodedString: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
      - name: Create key.properties
        run: |
          echo "storeFile=${{ steps.android_keystore.outputs.filePath }}" > android/key.properties
          echo "storePassword=${{ secrets.ANDROID_KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}" >> android/key.properties
      - name: Install dependencies
        run: flutter pub get
      - name: Build APK
        run: flutter build apk --release
      - name: Rename APK
        run: mv build/app/outputs/flutter-apk/app-release.apk ./ExampleApp-SNAPSHOT.apk
      - name: Archive APK
        uses: actions/upload-artifact@v1
        with:
          name: android-build
          path: ./ExampleApp-SNAPSHOT.apk
  build_ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Flutter
        uses: subosito/flutter-action@v1.4.0
        with:
          channel: 'stable'
      - name: Install dependencies
        run: flutter pub get
      - name: Build IOS
        run: flutter build ios --release --no-codesign

#      - name: Export IPA
#        run: |
#          cd ios
#          xcodebuild -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath $PWD/build/Runner.xcarchive
#          xcodebuild -exportArchive -archivePath $PWD/build/Runner.xcarchive -exportOptionsPlist ExportOptions.plist -exportPath $PWD/build/Runner.ipa
#      - name: Rename IPA
#        run: mv ios/build/Runner.ipa/Runner.ipa ./ExampleApp-SNAPSHOT.ipa
#      - name: Archive IPA
#        uses: actions/upload-artifact@v1
#        with:
#          name: ios-build
#          path: ./ExampleApp-SNAPSHOT.ipa

      - name: Archive IOS
        uses: actions/upload-artifact@v1
        with:
          name: ios-build
          path: build/ios/iphoneos
```

이게 끝입니다! 이제 무료로 (빌드) 해주는 Github Actions을 즐겨 봅시다. :)