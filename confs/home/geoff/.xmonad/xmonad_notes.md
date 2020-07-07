## XMonad Notes:

Like lightdm, XMonad seems to be looking at /usr/share/icons/default/index.theme
for cursor theme. In addition to the root window, gtk-2.0 apps like pcmanfm
seemed to not be following the gtk-2.0 configurations. Set the correct theme like so:
```
[Icon Theme]
Inherits=Bibata_Classic
```
