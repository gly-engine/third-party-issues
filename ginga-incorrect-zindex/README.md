# incorrect zIndex

It is not possible to correctly apply zIndex between the application plane and the video plane

|  Correct Zindex  | Incorrect zIndex |
|  :------------:  | :--------------: |
![image](https://github.com/gly-engine/third-party-issues/raw/refs/heads/main/screenshots/ginga-correct-zindex.png)|![image](https://github.com/gly-engine/third-party-issues/raw/refs/heads/main/screenshots/ginga-incorrect-zindex.png)


### Test with Ginga

replace `sbtvd-ts://video` with any local avi/mp4 video file

```
ginga demo/main.ncl
```

### Test with TMM

```
tm-muxer tmm-ncl.xml
```

---

Segundo a **ABNT NBR 15606-2** zIndex não se aplica ao plano de media, mas deveria ser discutido para modificação da ABNT.
