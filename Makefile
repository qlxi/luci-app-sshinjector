include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-sshinjector
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=User <user@example.com>
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-sshinjector
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=SSH Injector with Payload and VPN mode
  PKGARCH:=all
  DEPENDS:=+python3 +openssh-client +sshpass +luci-compat +badvpn-tun2socks +ip-full +kmod-tun
endef

define Package/luci-app-sshinjector/description
  LuCI interface for SSH Injector. 
  Supports HTTP Payload injection and system-wide VPN routing via tun2socks.
endef

define Build/Compile
endef

define Package/luci-app-sshinjector/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/sshinjector.lua $(1)/usr/lib/lua/luci/controller/sshinjector.lua
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/sshinjector.lua $(1)/usr/lib/lua/luci/model/cbi/sshinjector.lua
	
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/ssh_payload_injector.py $(1)/usr/bin/ssh_payload_injector.py
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/sshinjector $(1)/etc/init.d/sshinjector
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/sshinjector $(1)/etc/config/sshinjector
endef

$(eval $(call BuildPackage,luci-app-sshinjector))
