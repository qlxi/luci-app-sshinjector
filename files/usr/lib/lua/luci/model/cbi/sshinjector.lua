local m, s, o

m = Map("sshinjector", "SSH Injector", "SSH туннель с поддержкой Payload и перенаправлением трафика.")

s = m:section(TypedSection, "general", "Основные настройки")
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enabled", "Включить")
o.rmempty = false

-- --- VPN Section ---
o = s:option(Flag, "vpn_mode", "VPN Mode (Весь трафик)", "Если включено, весь трафик устройства пойдет через SSH туннель (требуется badvpn-tun2socks).")
o.rmempty = false

o = s:option(Value, "tun_dev", "Имя интерфейса TUN")
o.default = "tun0"
o:depends("vpn_mode", "1")

o = s:option(Value, "tun_net", "Подсеть TUN")
o.default = "10.255.0.2"
o.description = "Локальный IP для виртуального интерфейса"
o:depends("vpn_mode", "1")

-- --- SSH Connection ---
o = s:option(Value, "remote_host", "IP/Хост сервера")
o.datatype = "host"
o.rmempty = false

o = s:option(Value, "remote_port", "Порт SSH")
o.datatype = "port"
o.default = "22"
o.rmempty = false

o = s:option(Value, "username", "Имя пользователя")
o.rmempty = false

o = s:option(Value, "password", "Пароль")
o.password = true
o.rmempty = true

-- --- Payload ---
o = s:option(TextValue, "payload", "Payload (HTTP)")
o.rows = 5
o.description = "Пример: GET / HTTP/1.1[crlf]Host: domain.com[crlf][crlf]"
o.rmempty = false

-- --- Advanced ---
o = s:option(Value, "local_port", "Локальный SOCKS порт")
o.datatype = "port"
o.default = "1080"

o = s:option(Value, "proxy_ip", "Remote Proxy IP (опционально)")
o.datatype = "host"

o = s:option(Value, "proxy_port", "Remote Proxy Port")
o.datatype = "port"
o:depends("proxy_ip", "") 

return m
