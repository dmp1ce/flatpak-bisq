#flatpak-bisq

A small tool to automatially bundle Bisq as a flatpak.

## Usage

You will need the `flathub` repository, if you don't already have it you can install it with:
```
make install-sdk-repo
```

To build `bisq.flatpak`:
```
make
```

To install it:
```
make install
```

To uninstall it:
```
make uninstall
```
