---@diagnostic disable: undefined-global
require 'ISUI/ISPanel'
require 'ISUI/ISLabel'
require 'ISUI/ISTextEntryBox'
require 'ISUI/ISButton'
require 'ISUI/ISScrollingListBox'
BountyBoardUI = ISPanel:derive("BountyBoardUI")
require 'bountybulletin'

function BountyBoardUI:createChildren()
    local x, y = 10, 10
    self.rewardLabel = ISLabel:new(x, y, 20, "Reward (items):", 1, 1, 1, 1, UIFont.Small, true)
    self:addChild(self.rewardLabel)
    self.rewardEntry = ISTextEntryBox:new("", x + 120, y, 150, 20)
    self:addChild(self.rewardEntry)

    y = y + 30
    self.itemsLabel = ISLabel:new(x, y, 20, "Items (type,qty):", 1, 1, 1, 1, UIFont.Small, true)
    self:addChild(self.itemsLabel)
    self.itemsEntry = ISTextEntryBox:new("", x + 120, y, 200, 20)
    self:addChild(self.itemsEntry)

    y = y + 40
    self.addButton = ISButton:new(x, y, 100, 25, "Post", self, BountyBoardUI.onAddBounty)
    self:addChild(self.addButton)
    self.closeButton = ISButton:new(x + 120, y, 100, 25, "Close", self, BountyBoardUI.onClose)
    self:addChild(self.closeButton)
end

function BountyBoardUI:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = {r = 0.2, g = 0.2, b = 0.2, a = 0.8}
    return o
end

function BountyBoardUI:onAddBounty()
    local items = self.itemsEntry:getText()
    local reward = self.rewardEntry:getText()
    -- Store bounty for this board
    local board = self.worldObject
    BountyBulletin:addBounty(board, items, reward)
    self.player:Say("Posted bounty at board " .. board:getX() .. "," .. board:getY() .. ": " .. items .. " Reward: " .. reward)
    self:removeFromUIManager()
end

function BountyBoardUI:onClose()
    self:removeFromUIManager()
end

function BountyBoardUI:show(player)
    self.player = player
    self:initialise()
    self:addToUIManager()
end

-- Bounty list viewing UI
BountyBoardViewUI = ISPanel:derive("BountyBoardViewUI")

function BountyBoardViewUI:createChildren()
    -- Title
    local titleX = (self.width - 100) / 2
    local title = ISLabel:new(
        titleX, 10, 20,
        "View Bounties", 1,1,1,1, UIFont.Medium, true)
    self:addChild(title)
    -- Scrolling list of bounties
    local board = self.worldObject
    local list = BountyBulletin:getBounties(board)
    local listY = 35
    local listH = self.height - 75
    self.listBox = ISScrollingListBox:new(10, listY, self.width - 20, listH)
    self.listBox:initialise()
    self.listBox:setAnchorRight(true)
    self.listBox:setAnchorBottom(true)
    if #list == 0 then
        self.listBox:addItem("No bounties posted.", nil)
    else
        for i, entry in ipairs(list) do
            local text = string.format("%d) Items: %s | Reward: %s", i, entry.items, entry.reward)
            self.listBox:addItem(text, entry)
        end
    end
    self:addChild(self.listBox)
    -- Close and Remove buttons with shorter expressions
    local bx = (self.width - 100) / 2
    -- Close button
    self.closeButton = ISButton:new(
        bx + 110, self.height - 30,
        100, 25,
        "Close", self, BountyBoardViewUI.onClose)
    self:addChild(self.closeButton)
    -- Remove button
    self.removeButton = ISButton:new(
        bx - 110, self.height - 30,
        100, 25,
        "Remove", self, BountyBoardViewUI.onRemove)
    self:addChild(self.removeButton)
end
function BountyBoardViewUI:onRemove()
    local idx = self.listBox.selected
    if idx and idx > 0 then
        BountyBulletin:removeBounty(self.worldObject, idx)
        -- Refresh UI
        self:removeFromUIManager()
        local ui = BountyBoardViewUI:new(self:getX(), self:getY(), self.width, self.height)
        ui.worldObject = self.worldObject
        ui:show(self.player)
    end
end

function BountyBoardViewUI:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = {r = 0.1, g = 0.1, b = 0.1, a = 0.8}
    return o
end

function BountyBoardViewUI:onClose()
    self:removeFromUIManager()
end

function BountyBoardViewUI:show(player)
    self.player = player
    self:initialise()
    self:addToUIManager()
end