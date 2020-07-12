--- === JSON Menu ===
---
--- Add menus to macOS menubar based on provided JSON content.

local obj={}
obj.__index = obj

-- Metadata
obj.name = "JSONMenu"
obj.version = "0.1"
obj.author = "Sven Wilhelm <refnode@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.spoonPath = hs.spoons.scriptPath()
obj.title = "JSONMenu"
obj.tooltip = "JSONMenu Tooltip"
obj.config_file = nil
obj.menubar = nil
obj.system_menubar = true
obj.logger = hs.logger.new('JSONMenu')

function obj:init()
    self.menubar = hs.menubar.new(self.system_menubar)
    return self
end

--- JsonMenu.menuItemCallback(url)
--- Method
--- Return callback function to dispatch url with Spoon URLDispatcher.
---
--- Parameters:
---  * url - A string containing the URL
local function menuItemCallback(url)
    -- self.logger.df("Dispatching url: '%s'", url)
    -- https://www.hammerspoon.org/docs/hs.http.html#urlParts
    local parts = hs.http.urlParts(url)
    return function()
        spoon.URLDispatcher:dispatchURL(parts.scheme, parts.host, {}, parts.absoluteString)
        return
    end
end

function obj:start()
    local menu_items = {}
    for k, v in pairs(self.config_file) do
        title = v.title
        fn = nil
        image = nil
        if v.url ~= "" and v.url ~= nil then
            fn = menuItemCallback(v.url)
        end
        if v.image ~= "" and v.image ~= nil then
            image = v.image
        end
        table.insert(
            menu_items, {
                title = v.title,
                fn = fn,
                image = image,
        })
    end
    self.menubar:setMenu(menu_items)
    self.menubar:setTitle(self.title)
    self.menubar:setTooltip(self.tooltip)
    return self
end

return obj
