NULL=

ID=org.bisq.Bisq
BUNDLE=bisq.flatpak

RUNTIME=org.gnome.Platform
SDK=org.gnome.Sdk
SDK_VERSION=3.28
OPENJDK_EXTENSION=org.freedesktop.Sdk.Extension.openjdk10
OPENJDK_VERSION=1.6

SDK_REPO=flathub
SDK_LOCATION=https://flathub.org/repo/flathub.flatpakrepo

USER=--user
MANIFEST=$(ID).json
BUILD_DIR=tmp
REPO=repo
INSTALL_REPO=bisq-repo

BUILD_DEPS= \
	$(MANIFEST) \
	jre-Makefile \
	bisq-Makefile \
	$(NULL)

define GITIGNORE_CONTENT :=
.gitignore
.flatpak-builder
$(BUNDLE)
$(BUILD_DIR)
$(REPO)
endef

all: .gitignore $(BUNDLE)

.gitignore:
	$(file > $(@),$(GITIGNORE_CONTENT))

install-sdk-repo:
	flatpak $(USER) remote-add $(SDK_REPO) $(SDK_LOCATION)

# Depends on 'install-sdk-repo'
install-runtime:
	flatpak $(USER) install flathub $(RUNTIME) $(SDK_VERSION) || flatpak $(USER) update $(RUNTIME) $(SDK_VERSION)

# Depends on 'install-sdk-repo'
install-sdk:
	flatpak $(USER) install flathub $(SDK) $(SDK_VERSION) || flatpak $(USER) update $(SDK) $(SDK_VERSION)

# Depends on 'install-sdk-repo'
install-openjdk-extension:
	flatpak $(USER) install flathub $(OPENJDK_EXTENSION) $(OPENJDK_VERSION) || flatpak $(USER) update $(OPENJDK_EXTENSION) $(OPENJDK_VERSION)

build: $(BUILD_DEPS) install-runtime install-sdk install-openjdk-extension
	flatpak-builder --force-clean --repo=$(REPO) $(BUILD_DIR) $(MANIFEST)

$(BUNDLE): build
	flatpak build-bundle $(REPO) $(BUNDLE) $(ID)

prepare-install:
	flatpak $(USER) remote-add --no-gpg-verify $(INSTALL_REPO) $(REPO)

install:
	flatpak $(USER) install --bundle $(BUNDLE)

uninstall:
	flatpak $(USER) uninstall $(ID)

run:
	flatpak run $(ID)

clean-build:
	rm -Rf $(BUILD_DIR)

clean:
	rm -Rf .gitignore $(BUNDLE) $(BUILD_DIR) $(REPO)

.PHONY: all install-sdk-repo install-runtime install-sdk build prepare-install install uninstall run clean-build clean .gitignore
