# updating app icons

- add this to pubspec.yaml

```
flutter_launcher_icons:
  android: true
  ios: true
  adaptive_icon_background: "#FFF5F5"
  adaptive_icon_foreground: assets/icon/app_icon.png

  web:
    generate: true
    image_path: assets/icon/app_icon.png
    background_color: "#FFF5F5"
    theme_color: "#FFF5F5"

  windows:
    generate: true
    image_path: assets/icon/app_icon.png
    icon_size: 48

  macos:
    generate: true
    image_path: assets/icon/app_icon.png
```

- run this cmd in root directory of project:

`dart run flutter_launcher_icons`

# Using Img Assets in ui

paste your media to use in assets folder, then edit pubspec.yaml and add this under flutter:

```
flutter:
  assets:
    # whole folder
    - assets/img/extra/
    #perticular media
    - assets/img/extra/Placeholder.jpg
```
