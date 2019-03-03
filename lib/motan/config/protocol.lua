-- Copyright (C) idevz (idevz.org)

local consts = require "motan.consts"
local null = ngx.null
local setmetatable = setmetatable
local tab_concat = table.concat
local tab_insert = table.insert

local _M = {
    _VERSION = "0.1.0"
}

local mt = {__index = _M}

function _M.new(self, opts)
    local url = {}
    local opt_type = type(opts)
    if opt_type == "table" then
        url = {
            protocol = opts.protocol or "",
            host = opts.host or "",
            port = opts.port or 0,
            path = opts.path or "",
            group = opts.group or "",
            params = opts.params or {}
        }
    elseif opt_type == "string" then -- luacheck:ignore
    -- @TODO
    end
    return setmetatable(url, mt)
end

function _M.get_identity(self)
    local url_info = self:get_urlinfo()
    return tab_concat(url_info)
end

function _M.get_urlinfo(self, with_params_str)
    local url_info = {
        self.protocol,
        consts.PROTOCOL_SEPARATOR,
        self.host,
        consts.COLON_SEPARATOR,
        self.port,
        consts.PATH_SEPARATOR,
        self.path,
        consts.QMARK_SEPARATOR,
        "group=",
        self.group
    }
    if with_params_str then
        local params_arr = {}
        if self.params ~= null then
            for k, v in pairs(self.params) do
                tab_insert(params_arr, consts.QUERY_PARAM_SEPARATOR)
                tab_insert(params_arr, k)
                tab_insert(params_arr, consts.EQUAL_SIGN_SEPERATOR)
                tab_insert(params_arr, v)
            end
        end
        tab_insert(url_info, tab_concat(params_arr))
    end
    return url_info
end

function _M.to_extinfo(self)
    return tab_concat(self:get_urlinfo(true))
end

return _M
