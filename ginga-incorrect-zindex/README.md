# incorrect zIndex

It is not possible to correctly apply zIndex between the application plane and the video plane

|  Correct Zindex  | Incorrect zIndex |
|  :------------:  | :--------------: |
![image](https://github.com/gly-engine/third-party-issues/raw/refs/heads/main/screenshots/ginga-correct-zindex.png)|![image](https://github.com/gly-engine/third-party-issues/raw/refs/heads/main/screenshots/ginga-incorrect-zindex.png)


### Test with Ginga

```
gingagui ginga-incorrect-zIndex/demo/main.ncl
```

### Test with TMM

```
tm-muxer tmm.xml
```
