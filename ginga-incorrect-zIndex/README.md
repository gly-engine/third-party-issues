# incorrect zIndex

It is not possible to correctly apply zIndex between the application plane and the video plane

|  Correct Zindex  | Incorrect zIndex |
|  :------------:  | :--------------: |
![image](https://github.com/user-attachments/assets/221dc790-0878-4d90-b406-656a2e468142)|![image](https://github.com/user-attachments/assets/d3883b6d-6d81-4613-ae94-954e585fa0a5)


### Test with Ginga

```
gingagui ginga-incorrect-zIndex/demo/main.ncl
```

### Test with TMM

```
tm-muxer tmm.xml
```
