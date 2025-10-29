# Fade in TVs

Comandos para gerar imagens:

```bash
convert -size 79x79 xc:none \
  -fill 'rgba(255,0,0,0.5)' -draw 'rectangle 0,0 78,39' \
  -fill 'rgba(0,0,255,0.5)' -draw 'rectangle 0,39 78,78' \
  out.png

convert -size 79x79 xc:none \
  -fill 'rgba(255,0,0,0.5)' -draw 'rectangle 0,0 39,78' \
  -fill 'rgba(0,0,255,0.5)' -draw 'rectangle 39,0 78,78' \
  out1.png

convert ginga-blend-modules/demo/assets/out.png -define png:compression-level=2 ginga-blend-modules/demo/assets/out_compressed_2.png
convert ginga-blend-modules/demo/assets/out1.png -define png:compression-level=2 ginga-blend-modules/demo/assets/out1_compressed_2.png
convert ginga-blend-modules/demo/assets/out.png -define png:compression-level=3 ginga-blend-modules/demo/assets/out_compressed_3.png
convert ginga-blend-modules/demo/assets/out1.png -define png:compression-level=3 ginga-blend-modules/demo/assets/out1_compressed_3.png
convert ginga-blend-modules/demo/assets/out.png -define png:compression-level=4 ginga-blend-modules/demo/assets/out_compressed_4.png
convert ginga-blend-modules/demo/assets/out1.png -define png:compression-level=4 ginga-blend-modules/demo/assets/out1_compressed_4.png
convert ginga-blend-modules/demo/assets/out.png -define png:compression-level=5 ginga-blend-modules/demo/assets/out_compressed_5.png
convert ginga-blend-modules/demo/assets/out1.png -define png:compression-level=5 ginga-blend-modules/demo/assets/out1_compressed_5.png
convert ginga-blend-modules/demo/assets/out.png -define png:compression-level=6 ginga-blend-modules/demo/assets/out_compressed_6.png
convert ginga-blend-modules/demo/assets/out1.png -define png:compression-level=6 ginga-blend-modules/demo/assets/out1_compressed_6.png
convert ginga-blend-modules/demo/assets/out.png -define png:compression-level=7 ginga-blend-modules/demo/assets/out_compressed_7.png
convert ginga-blend-modules/demo/assets/out1.png -define png:compression-level=7 ginga-blend-modules/demo/assets/out1_compressed_7.png
convert ginga-blend-modules/demo/assets/out.png -define png:compression-level=8 ginga-blend-modules/demo/assets/out_compressed_8.png
convert ginga-blend-modules/demo/assets/out1.png -define png:compression-level=8 ginga-blend-modules/demo/assets/out1_compressed_8.png
convert ginga-blend-modules/demo/assets/out.png -define png:compression-level=9 ginga-blend-modules/demo/assets/out_compressed_9.png
convert ginga-blend-modules/demo/assets/out1.png -define png:compression-level=9 ginga-blend-modules/demo/assets/out1_compressed_9.png
```
