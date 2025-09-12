-- Bounty Bulletin interaction script
-- UI integration (optional)
pcall(require, 'bountybulletin_ui')
local BountyBulletin = {}
-- Use object modData for storage (persistent and sync)


--- Retrieve list of bounties for a board
function BountyBulletin:getBounties(board)
    local md = board:getModData()
    return md.bounties or {}
end

--- Add a bounty to storage
function BountyBulletin:addBounty(board, items, reward)
    local md = board:getModData()
    md.bounties = md.bounties or {}
    table.insert(md.bounties, {items = items, reward = reward})
    board:transmitModData()
end

--- Remove a bounty by index
function BountyBulletin:removeBounty(board, index)
    local md = board:getModData()
    if not md.bounties then return end
    table.remove(md.bounties, index)
    board:transmitModData()
end


-- Check if the world object is our bulletin board
local function isBulletinBoard(worldObject)
    -- Extend the built-in Cork Noteboard
    local name = worldObject:getName()
    return type(name) == 'string' and name:find("Noteboard") ~= nil
end

-- Stub: open post bounty dialog
local function openPostBounty(player, worldObject)
    -- Open bounty posting UI
    local ui = BountyBoardUI:new(50, 50, 350, 200)
    ui.worldObject = worldObject
    ui:show(player)
end

-- Stub: open view bounties dialog
-- Open view bounties dialog
local function openViewBounties(player, worldObject)
    -- Show UI listing bounties for this board
    local ui = BountyBoardViewUI:new(50, 50, 400, 300)
    ui.worldObject = worldObject
    ui:show(player)
end

-- Add context menu entries
local function onFillWorldObjectContextMenu(player, context, worldObjects)
    for _, worldObject in ipairs(worldObjects) do
        if isBulletinBoard(worldObject) then
            context:addOption("Post Bounty", worldObjects, openPostBounty, player, worldObject)
            context:addOption("View Bounties", worldObjects, openViewBounties, player, worldObject)
            break
        end
    end
end

-- Register event if available
---@diagnostic disable-next-line: undefined-global
if Events and Events.OnFillWorldObjectContextMenu and Events.OnFillWorldObjectContextMenu.Add then
    Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
end

-- luacheck: globals Events

return BountyBulletin