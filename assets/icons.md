## icons
The launcher icon and the store assets are generated from SVG sources:

```
inkscape assets/icon/tanga_icon.svg \
  --export-type=png --export-filename=assets/icon/icon-512.png \
  --export-width=512 --export-height=512
```

The Android launcher icons live in `android/app/src/main/res/mipmap-*`.