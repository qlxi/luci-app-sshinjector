module("luci.controller.sshinjector", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/sshinjector") then
        return
    end

    local page
    page = entry({"admin", "services", "sshinjector"}, cbi("sshinjector"), _("SSH Injector"), 100)
    page.dependent = true
end
