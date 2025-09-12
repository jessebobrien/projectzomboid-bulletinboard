-- luacheck: globals describe setup it assert
package.path = package.path .. ";media/lua/?.lua"
package.preload["bountybulletin_ui"] = function() return {} end
local BountyBulletin = require "bountybulletin"

-- Mock board object with modData storage
local function newMockBoard()
    local md = {}
    return {
        getModData = function() return md end,
        transmitModData = function() end,
        getX = function() return 1 end,
        getY = function() return 2 end,
        getZ = function() return 0 end,
    }
end

describe("BountyBulletin storage API", function()
    local board

    setup(function()
        board = newMockBoard()
    end)

    it("starts with no bounties", function()
        local list = BountyBulletin:getBounties(board)
        assert.are.same({}, list)
    end)

    it("adds a bounty", function()
        BountyBulletin:addBounty(board, "apple,2", "gold,5")
        local list = BountyBulletin:getBounties(board)
        assert.is.equal(1, #list)
        assert.are.same({items="apple,2", reward="gold,5"}, list[1])
    end)

    it("removes a bounty by index", function()
        BountyBulletin:addBounty(board, "banana,3", "silver,10")
        -- Now two bounties
        assert.are.equal(2, #BountyBulletin:getBounties(board))
        -- Remove first
        BountyBulletin:removeBounty(board, 1)
        local list = BountyBulletin:getBounties(board)
        assert.are.equal(1, #list)
        assert.are.same({items="banana,3", reward="silver,10"}, list[1])
    end)
end)