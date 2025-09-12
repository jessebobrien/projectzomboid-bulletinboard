-- Luacheck configuration for Bounty Bulletin mod

max_line_length = 200
globals = {
    "Events",
    "BountyBoardUI",
    "BountyBoardViewUI",
    "BountyBulletin",
    "ISPanel",
    "ISLabel",
    "ISTextEntryBox",
    "ISButton",
    "ISScrollingListBox",
    "UIFont",
    -- Busted test framework globals
    "describe",
    "it",
    "setup",
    "teardown",
    "before_each",
    "after_each",
    "assert",
}

ignore = {
    "self",
}