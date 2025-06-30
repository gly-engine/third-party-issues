# Class TCP Incomplete Chunks

Some NCL ginga implementations do not receive all chunks of an HTTP request.

| Complete Chunks | Incomplete Chunks |
| :-------------: | :---------------: |
![](https://github.com/gly-engine/third-party-issues/raw/refs/heads/main/screenshots/ginga-class-tcp-complete-chunks.png) | ![](https://github.com/gly-engine/third-party-issues/raw/refs/heads/main/screenshots/ginga-class-tcp-incomplete-chunks.png)

### Test with Ginga

```
ginga demo/main/ncl
```

### Test with TMM

```
tm-muxer tmm.xml
```
