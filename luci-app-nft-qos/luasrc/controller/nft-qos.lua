-- Copyright 2018 Rosy Song <rosysong@rosinson.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.nft-qos", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/nft-qos") then
		return
	end

	entry({"admin", "status", "realtime", "rate"},
        template("nft-qos/rate"), _("Rate"), 5).leaf = true
	entry({"admin", "status", "realtime", "rate_status"},
        call("action_rate")).leaf = true

	entry({"admin", "services", "nft-qos"}, cbi("nft-qos/nft-qos"),
        _("Qos over Nftables"), 60)

--	entry({"admin", "services", "nft-qos", "rate-limit"},
--       cbi("rate-limit"), _("Rate Limit"), 10).leaf = true

--	entry({"admin", "services", "nft-qos", "dynamic-rate-limit"},
--        cbi("dynamic-rate-limit"), _("Dynamic Rate Limit"), 20).leaf = true

--	entry({"admin", "services", "nft-qos", "priority"},
--        cbi("priority"), _("Traffic Priority"), 30).leaf = true
end

function action_rate()
	luci.http.prepare_content("application/json")

	local bwc = io.popen("nft -j list ruleset 2>/dev/null")
	if bwc then

		while true do
			local ln = bwc:read("*l")
			if not ln then break end
			luci.http.write(ln)
		end

		bwc:close()
	end
end
