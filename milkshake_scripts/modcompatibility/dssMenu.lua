---@diagnostic disable: undefined-field
-- Change this variable to match your mod. The standard is "Dead Sea Scrolls (Mod Name)"
local DSSModName = "Dead Sea Scrolls (Milkshake Vol1)"

-- Every MenuProvider function below must have its own implementation in your mod, in order to
-- handle menu save data.
local MenuProvider = {}

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "DSSMenuConfig",
    {},
    TSIL.Enums.VariablePersistenceMode.NONE
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "CustomMirrorWorldBossMusic",
    true,
    TSIL.Enums.VariablePersistenceMode.NONE
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "SharpCursorClickSound",
    true,
    TSIL.Enums.VariablePersistenceMode.NONE
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "LeviticusSprite",
    1,
    TSIL.Enums.VariablePersistenceMode.NONE
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "SharpCursorFollowMouse",
    false,
    TSIL.Enums.VariablePersistenceMode.NONE
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "EnableGlassHeads",
    true,
    TSIL.Enums.VariablePersistenceMode.NONE
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "EnableBeerHeads",
    true,
    TSIL.Enums.VariablePersistenceMode.NONE
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "EnableWineHeads",
    true,
    TSIL.Enums.VariablePersistenceMode.NONE
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "EnableFlaskHeads",
    true,
    TSIL.Enums.VariablePersistenceMode.NONE
)

function MenuProvider.SaveSaveData()
end

function MenuProvider.GetPaletteSetting()
    return TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "DSSMenuConfig").MenusPoppedUp = var
end

local dssmenucore = include("milkshake_scripts.modcompatibility.dssmenucore")

-- This function returns a table that some useful functions and defaults are stored on.
local dssmod = dssmenucore.init(DSSModName, MenuProvider)


local sanchoSprite = Sprite()
sanchoSprite:Load("gfx/ui/giantbook/sancho.anm2", true)
sanchoSprite:Play("Celestial", true)
sanchoSprite:SetLastFrame()

local function RenderSancho()
    if sanchoSprite:IsFinished() then return end

    sanchoSprite:Render(TSIL.UI.GetScreenCenterPosition())
    sanchoSprite:Update()
end

if StageAPI then
    StageAPI.AddCallback(
        MilkshakeVol1.Name,
        "POST_HUD_RENDER",
        101,
        RenderSancho
    )
else
    MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_RENDER, RenderSancho)
end


-- Adding a Menu

-- Creating a menu like any other DSS menu is a simple process. You need a "Directory", which
-- defines all of the pages ("items") that can be accessed on your menu, and a "DirectoryKey", which
-- defines the state of the menu.
local exampledirectory = {
    main = {
        title = 'milkshake vol1!',
        buttons = {
            { str = 'resume game', action = 'resume' },
            { str = 'settings',    dest = 'settings' },
            dssmod.changelogsButton,
        },
        tooltip = dssmod.menuOpenToolTip
    },

    settings = {
        title = 'settings',
        buttons = {
            -- DEFAULT DSS SETTINGS
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
            dssmod.menuHintButton,
            dssmod.menuBuzzerButton,

            -- CUSTOM MIRROR WORLD BOSS MUSIC
            {
                str = 'mirror world boss music',
                fsize = 2,
                choices = { 'enabled', 'disabled' },
                setting = 1,
                variable = 'CustomMirrorWorldBossMusic',
                load = function()
                    local playMusic = TSIL.SaveManager.GetPersistentVariable(
                        MilkshakeVol1,
                        "CustomMirrorWorldBossMusic"
                    )
                    if playMusic then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    TSIL.SaveManager.SetPersistentVariable(
                        MilkshakeVol1,
                        "CustomMirrorWorldBossMusic",
                        var == 1
                    )
                end,
                tooltip = { strset = { 'play custom', 'boss music in', 'mirror world' } }
            },
            { str = "", fsize = 1, nosel = true },

            -- SHARP CURSOR CLICK SOUND
            {
                str = 'sharp cursor click sound',
                fsize = 2,
                choices = { 'enabled', 'muted' },
                setting = 1,
                variable = 'SharpCursorClickSound',
                load = function()
                    local playMusic = TSIL.SaveManager.GetPersistentVariable(
                        MilkshakeVol1,
                        "SharpCursorClickSound"
                    )
                    if playMusic then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    TSIL.SaveManager.SetPersistentVariable(
                        MilkshakeVol1,
                        "SharpCursorClickSound",
                        var == 1
                    )
                end,
                tooltip = { strset = { 'disable sharp', 'cursor\'s click', 'sound effect' } }
            },

            -- SHARP CURSOR FOLLOW MOUSE
            {
                str = 'sharp cursor mode',
                fsize = 2,
                choices = { 'follow mouse', 'auto target' },
                setting = 1,
                variable = 'SharpCursorFollowMouse',
                load = function()
                    local followMouse = TSIL.SaveManager.GetPersistentVariable(
                        MilkshakeVol1,
                        "SharpCursorFollowMouse"
                    )
                    if followMouse then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    TSIL.SaveManager.SetPersistentVariable(
                        MilkshakeVol1,
                        "SharpCursorFollowMouse",
                        var == 1
                    )
                end,
                tooltip = { strset = { 'follow mouse', 'only applies if', 'mouse control', 'is enabled', 'in options.ini'} }
            },

            -- LEVITICUS SPRITE
            {
                str = 'leviticus sprite style',
                fsize = 2,
                choices = { 'vanilla', 'aladar', 'fancy' },
                setting = 1,
                variable = 'LeviticusSprite',
                load = function()
                    return TSIL.SaveManager.GetPersistentVariable(
                        MilkshakeVol1,
                        "LeviticusSprite"
                    )
                end,
                store = function(var)
                    TSIL.SaveManager.SetPersistentVariable(
                        MilkshakeVol1,
                        "LeviticusSprite",
                        var
                    )
                end,
                tooltip = { strset = { 'what sprite', 'leviticus', 'will use' } }
            },

            { str = "", nosel = true },

            -- -- ENEMY SETTINGS DEST
            -- { str = 'enemy settings',    dest = 'enemy_settings' },

            -- SPECIAL SETTINGS DEST
            { str = 'extra settings',    dest = 'special_settings' },
        }
    },

    enemy_settings = {
        title = "new enemies",
        buttons = {
            -- GLASS HEADS
            {
                str = 'glass heads',
                choices = { 'enable', 'disable' },
                setting = 1,
                variable = 'EnableGlassHeads',
                load = function()
                    local playMusic = TSIL.SaveManager.GetPersistentVariable(
                        MilkshakeVol1,
                        "EnableGlassHeads"
                    )
                    if playMusic then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    TSIL.SaveManager.SetPersistentVariable(
                        MilkshakeVol1,
                        "EnableGlassHeads",
                        var == 1
                    )
                end,
            },

            -- BEER HEADS
            {
                str = 'beer heads',
                choices = { 'enable', 'disable' },
                setting = 1,
                variable = 'EnableBeerHeads',
                load = function()
                    local playMusic = TSIL.SaveManager.GetPersistentVariable(
                        MilkshakeVol1,
                        "EnableBeerHeads"
                    )
                    if playMusic then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    TSIL.SaveManager.SetPersistentVariable(
                        MilkshakeVol1,
                        "EnableBeerHeads",
                        var == 1
                    )
                end,
            },

            -- WINE HEADS
            {
                str = 'wine heads',
                choices = { 'enable', 'disable' },
                setting = 1,
                variable = 'EnableWineHeads',
                load = function()
                    local playMusic = TSIL.SaveManager.GetPersistentVariable(
                        MilkshakeVol1,
                        "EnableWineHeads"
                    )
                    if playMusic then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    TSIL.SaveManager.SetPersistentVariable(
                        MilkshakeVol1,
                        "EnableWineHeads",
                        var == 1
                    )
                end,
            },

            -- FLASK HEADS
            {
                str = 'flask heads',
                choices = { 'enable', 'disable' },
                setting = 1,
                variable = 'EnableFlaskHeads',
                load = function()
                    local playMusic = TSIL.SaveManager.GetPersistentVariable(
                        MilkshakeVol1,
                        "EnableFlaskHeads"
                    )
                    if playMusic then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    TSIL.SaveManager.SetPersistentVariable(
                        MilkshakeVol1,
                        "EnableFlaskHeads",
                        var == 1
                    )
                end,
            },
        }
    },

    special_settings = {
        title = "extra settings",
        buttons = {
            -- SANCHO MODE
            {
                str = 'sancho mode',
                setting = 1,
                variable = 'SanchoMode',
                choices = { 'on', 'off' },
                tooltip = { strset = { 'whether sancho', 'mode should', 'be active' } },
                changefunc = function (button)
                    if button.setting == 1 then
                        if sanchoSprite:GetAnimation() == "Celestial" then return end
                        SFXManager():Play(SoundEffect.SOUND_HOLY)
                        sanchoSprite:Play("Celestial", true)
                    else
                        if sanchoSprite:GetAnimation() == "Evil" then return end
                        SFXManager():Play(SoundEffect.SOUND_UNHOLY)
                        sanchoSprite:Play("Evil", true)
                    end
                end
            },
            { str = "", fsize = 1, nosel = true },

            -- EMEKE
            {
                str = 'emeke?',
            },
            { str = "", fsize = 1, nosel = true },

            -- IM SORYYYYYYYY
            {
                str = 'hello',

                setting = 1,
                variable = 'HelloEverynyan',
                choices = {
                    'hello', 'everynyan',
                    'how', 'are', 'you?',
                    'fine', 'sank', 'you',
                    'oh', 'my', 'gah!'
                },
            },
            { str = "", fsize = 1, nosel = true },

            -- IM SORY BUTTON
            {
                str = 'im sory',
                func = function ()
                    local sfx = Isaac.GetSoundIdByName("Im sory")
                    SFXManager():Play(sfx, 4)
                end,
                tooltip = { strset = { 'prime minister' } }
            },
            { str = "", fsize = 1, nosel = true },

            --BEST DEVELOPER
            {
                str = "best developer",
                setting = 1,
                variable = 'BestDeveloper',
                choices = {
                    "kattack",
                    "eucalyptus",
                    "thicco catto",
                    "nineline",
                    "monwil",
                    "decrioden",
                    "brenden person",
                    "kerkel",
                    "esty",
                    "bardia",
                    "muffintae",
                    "bagman64",
                    "xxlucia07xx",
                    "chupeta",
                    "dpower12",
                    "izzysakoi",
                    "visi",
                    "steve2552",
                    "westrvn",
                    "nelly",
                    "nihil",
                    "shanepatsmith",
                    "foiled again",
                    "notspooky",
                    "susukethereal",
                    "catinsurance",
                    "skykittenpuppy"
                },
                tooltip = { strset = { 'this info', 'will be sent', 'to the devs' } }
            },
            { str = "", fsize = 1, nosel = true },

            --BRENDA'S NAME
            {str = "brenda the spirit", fsize = 2, nosel = true},
            {str = "kiln was here", fsize = 2, nosel = true}
        }
    },
}

local exampledirectorykey = {
    -- This is the initial item of the menu, generally you want to set it to your main item
    Item = exampledirectory.main,
    -- The main item of the menu is the item that gets opened first when opening your mod's menu.
    Main = 'main',
    -- These are default state variables for the menu; they're important to have in here, but you
    -- don't need to change them at all.
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Milkshake Vol1", {
    -- The Run, Close, and Open functions define the core loop of your menu. Once your menu is
    -- opened, all the work is shifted off to your mod running these functions, so each mod can have
    -- its own independently functioning menu. The `init` function returns a table with defaults
    -- defined for each function, as "runMenu", "openMenu", and "closeMenu". Using these defaults
    -- will get you the same menu you see in Bertran and most other mods that use DSS. But, if you
    -- did want a completely custom menu, this would be the way to do it!

    -- This function runs every render frame while your menu is open, it handles everything!
    -- Drawing, inputs, etc.
    Run = dssmod.runMenu,
    -- This function runs when the menu is opened, and generally initializes the menu.
    Open = dssmod.openMenu,
    -- This function runs when the menu is closed, and generally handles storing of save data /
    -- general shut down.
    Close = dssmod.closeMenu,
    -- If UseSubMenu is set to true, when other mods with UseSubMenu set to false / nil are enabled,
    -- your menu will be hidden behind an "Other Mods" button.
    -- A good idea to use to help keep menus clean if you don't expect players to use your menu very
    -- often!
    UseSubMenu = false,
    Directory = exampledirectory,
    DirectoryKey = exampledirectorykey
})

-- There are a lot more features that DSS supports not covered here, like sprite insertion and
-- scroller menus, that you'll have to look at other mods for reference to use. But, this should be
-- everything you need to create a simple menu for configuration or other simple use cases!
