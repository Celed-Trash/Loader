local players = game:GetService("Players")
local plr = players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mag
local attackremote = ReplicatedStorage.ReplicatedPackage.Remotes.action
local mobs = {
	"Bandit",
	"Lowly Goblin",
	"Mage Apprentice",
	"Ogre",
	"Shadow Hand Goon",
	"Seasoned Mercenary",
	"Alpha Wolf",
	"Vennum",
	"Wind Monk",
	"Wolf",
	"Wolf Hunter",
	"Yetti",
}
local bossTable = {
	"Grasslands Warlord",
	"Aetherstone Golem",
	"Bandit Leader",
	"Riddlebones",
	"Wolf Hunter Craftsman",
}

local questTable = {}

local flowersTable = {
	"Fire Lily",
	"Grass",
	"Blue Lily",
	"Mana Flower",
	"Frozen Lily",
}

local Settings = {
	Autofarm = {
		Toggle = false,
		Position = 10,
		Mob = "",
	},
	Autocollect = {
		Toggle = false,
		Flowers = false,
		Item = "Grass",
	},
	Players = {
		Toggle = false,
		Position = 10,
	},
	Notifier = true,
	Autoquest = {
		Toggle = false,
		Position = 10,
		Quest = "",
	},
	Bossfarm = {
		Toggle = false,
		Position = 10,
		Boss = "",
	},
}

local function angle(number)
	if number >= 0 then
		return -90
	else
		return 90
	end
end
local FillerNpcs = {}
local Quests = {}
local interactions = {}
local events = {}

task.spawn(function()
	if game.PlaceId == 14839995292 then
		for i, v in next, workspace.Entities.Interactions.FillerNpcs:GetChildren() do
			table.insert(FillerNpcs, v.Name)
		end

		for i, v in next, workspace.Entities.Interactions.Quests:GetChildren() do
			table.insert(Quests, v.Name)
		end

		for i, v in next, workspace.Entities.Interactions["Special Interactions"]:GetChildren() do
			table.insert(interactions, v.Name)
		end

		for i, v in next, workspace.Entities.Interactions.SpecialEvents:GetChildren() do
			table.insert(events, v.Name)
		end
	else
		return
	end
end)

local function checker(object, location, type)
	if type == "mob" then
		if location[object.Name] == true and object.Humanoid.Health > 0 then
			return true
		else
			return false
		end
	elseif type =="flower" then
		if location[object:FindFirstChildOfClass("Model").Name] == true then
			return true
		else
			return false
		end
	elseif type == "boss" then
		if location[object.Name] == true then
			return true
		else
			return false
		end
	end
end


local function mobfarm()
	if not Settings.Autofarm.Toggle then
		return
	end
	for i, v in next, workspace.Entities.Enemies:GetChildren() do
		if checker(v, Settings.Autofarm.Mob, "mob") then
			plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
				* CFrame.new(0, Settings.Autofarm.Position, 0)
				* CFrame.Angles(math.rad(angle(Settings.Autofarm.Position)), 0, 0)
			attackremote:FireServer("M1")
		end
	end
end

local function godmode()
	ReplicatedStorage.ReplicatedPackage.Remotes.Distance:FireServer(0 / 0, 0 / 0, "High")
end

local function autocollect()
	if not Settings.Autocollect.Toggle then
		return
	end
	for i, v in next, workspace.Entities.Interactions.Collectibles.OreSpawn:GetDescendants() do
		if v.Name == "OreSpawn" and v:FindFirstChildOfClass("ProximityPrompt") then
			plr.Character:PivotTo(v:GetPivot())
			mag = (v.Position - plr.Character.HumanoidRootPart.Position).magnitude
			if mag < 15 then
				plr.Character:PivotTo(v:GetPivot())
				v.ProximityPrompt.HoldDuration = 0
				fireproximityprompt(v.ProximityPrompt)
			end
			break
		end
	end
end

local function flowers()
	if not Settings.Autocollect.Flowers then
		return
	end
	for i, v in next, workspace.Entities.Interactions.Collectibles.Flowers:GetDescendants() do
		if v:FindFirstChildOfClass("ProximityPrompt") and checker(v, Settings.Autocollect.Item, "flower") then
			plr.Character:PivotTo(v:GetPivot())
			mag = (v.Position - plr.Character.HumanoidRootPart.Position).magnitude
			if mag < 15 then
				plr.Character:PivotTo(v:GetPivot())
				v.ProximityPrompt.HoldDuration = 0
				fireproximityprompt(v.ProximityPrompt)
			end
			break
		end
	end
end

local function farmplayers()
	if not Settings.Players.Toggle then
		return
	end
	for i, v in next, players:GetChildren() do
		if v ~= plr and v.Character and v.Character.Humanoid.Health > 0 then
			plr.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
				* CFrame.new(0, Settings.Players.Position, 0)
				* CFrame.Angles(math.rad(angle(Settings.Players.Position)), 0, 0)
			attackremote:FireServer("M1")
		end
	end
end

local function bossnotifier()
	if not Settings.Notifier then
		return
	end
	for i, v in pairs(workspace.Entities.Enemies:GetChildren()) do
		if bossTable[v.Name] then
			game.StarterGui:SetCore("SendNotification", {
				Title = string.format("Boss Spawned: %s", v.Name), -- the title (ofc)
				Text = "", -- what the text says (ofc)
				Icon = "", -- the image if u want.
				Duration = 25, -- how long the notification should in secounds
			})
		end
	end
end

local function autoquest()
	if not Settings.Autoquest.Toggle then
		return
	end
end

local function chestfinder(boss)
	for i,v in pairs(workspace.Entities.Events[boss.Name].Chests:GetDescendants()) do
		if v:IsA("Model") and v.Name == "Chest"  and v:FindFirstChildOfClass("ProximityPrompt") then
			plr.Character:PivotTo(v:GetPivot())
			v.ProximityPrompt.HoldDuration = 0
			fireproximityprompt(v.ProximityPrompt)
		end
	end
end

local function bossfarm()
	if not Settings.Bossfarm.Toggle then
		return
	end
	for i, v in pairs(workspace.Entities.Enemies:GetChildren()) do
		if checker(v, Settings.Bossfarm.Boss, "boss") then
			if v.Humanoid.Health > 0 then
				plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
					* CFrame.new(0, Settings.Autofarm.Position, 0)
					* CFrame.Angles(math.rad(angle(Settings.Autofarm.Position)), 0, 0)
				attackremote:FireServer("M1")
			else
				chestfinder(v)
			end
		end
	end
end

local function autospin()
	if not  Settings.Autoquest.Toggle then return end;
	


end



local repo = "https://raw.githubusercontent.com/HTDBarsi/LinoriaLib/main/"
local Library = (loadstring(game:HttpGet(repo .. "Library.lua")))()
local ThemeManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/SoftworkLHC/Linoria-Library/main/LinoriaLib-main/addons/ThemeManager.lua")))()
local SaveManager = (loadstring(game:HttpGet(repo .. "addons/SaveManager.lua")))()
local Window = Library:CreateWindow({
	Title = "Clover Retribution Paid",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0,
})
local Tabs = {
	Main = Window:AddTab("Main"),
	["Configuration"] = Window:AddTab("Configuration"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Farms")
LeftGroupBox:AddToggle("Autofarm", {
	Text = "Mob Farm toggle",
	Default = false,
	Tooltip = "",
	Callback = function(Value)
		Settings.Autofarm.Toggle = Value
	end,
})

LeftGroupBox:AddDropdown("MyDropdown", {
	Values = mobs,
	Default = 1, -- number index of the value / string
	Multi = true, -- true / false, allows multiple choices to be selected

	Text = "Mobs",
	Tooltip = "", -- Information shown when you hover over the dropdown

	Callback = function(Value)
		Settings.Autofarm.Mob = Value
	end,
})

LeftGroupBox:AddSlider("MySlider", {
	Text = "Position",
	Default = 10,
	Min = -15,
	Max = 15,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		Settings.Autofarm.Position = Value
	end,
})

LeftGroupBox:AddToggle("Autofarm", {
	Text = "Boss Farm toggle",
	Default = false,
	Tooltip = "",
	Callback = function(Value)
		Settings.Bossfarm.Toggle = Value
	end,
})

LeftGroupBox:AddDropdown("MyDropdown", {
	Values = bossTable,
	Default = 1, -- number index of the value / string
	Multi = true, -- true / false, allows multiple choices to be selected

	Text = "Bosses",
	Tooltip = "", -- Information shown when you hover over the dropdown

	Callback = function(Value)
		Settings.Bossfarm.Boss = Value
	end,
})

LeftGroupBox:AddSlider("MySlider", {
	Text = "Position",
	Default = 10,
	Min = -15,
	Max = 15,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		Settings.Bossfarm.Position = Value
	end,
})


LeftGroupBox:AddToggle("Autofarm", {
	Text = "Ore Farm toggle",
	Default = false,
	Tooltip = "",
	Callback = function(Value)
		Settings.Autocollect.Toggle = Value
	end,
})

LeftGroupBox:AddToggle("Autofarm", {
	Text = "Flower Farm toggle",
	Default = false,
	Tooltip = "",
	Callback = function(Value)
		Settings.Autocollect.Flowers = Value
	end,
})

LeftGroupBox:AddDropdown("MyDropdown", {
	Values = flowersTable,
	Default = 1, -- number index of the value / string
	Multi = true, -- true / false, allows multiple choices to be selected

	Text = "Flowers",
	Tooltip = "", -- Information shown when you hover over the dropdown
	Callback = function(Value)
		Settings.Autocollect.Item = Value
	end,
})

LeftGroupBox:AddToggle("Autofarm", {
	Text = "Player Farm toggle",
	Default = false,
	Tooltip = "",
	Callback = function(Value)
		Settings.Players.Toggle = Value
	end,
})

LeftGroupBox:AddSlider("MySlider", {
	Text = "Position",
	Default = 10,
	Min = -15,
	Max = 15,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		Settings.Players.Position = Value
	end,
})

local LeftGroupBox = Tabs.Main:AddRightGroupbox("Misc")

LeftGroupBox:AddDropdown("MyDropdown", {
	Values = FillerNpcs,
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	Text = "Filler Npcs TP",
	Tooltip = "", -- Information shown when you hover over the dropdown

	Callback = function(Value)
		plr.Character:PivotTo(workspace.Entities.Interactions.FillerNpcs[Value]:GetPivot())
	end,
})

LeftGroupBox:AddDropdown("MyDropdown", {
	Values = Quests,
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	Text = "Quests TP",
	Tooltip = "", -- Information shown when you hover over the dropdown

	Callback = function(Value)
		plr.Character:PivotTo(workspace.Entities.Interactions.Quests[Value]:GetPivot())
	end,
})

LeftGroupBox:AddDropdown("MyDropdown", {
	Values = interactions,
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	Text = "Special interractions TP",
	Tooltip = "", -- Information shown when you hover over the dropdown

	Callback = function(Value)
		plr.Character:PivotTo(workspace.Entities.Interactions["Special Interactions"][Value]:GetPivot())
	end,
})

LeftGroupBox:AddDropdown("MyDropdown", {
	Values = events,
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	Text = "Special Events TP",
	Tooltip = "", -- Information shown when you hover over the dropdown

	Callback = function(Value)
		lr.Character:PivotTo(workspace.Entities.Interactions.SpecialEvents[Value]:GetPivot())
	end,
})

local MyButton = LeftGroupBox:AddButton({
	Text = "Godmode",
	Func = function()
		godmode()
	end,
	DoubleClick = false,
	Tooltip = "",
})

LeftGroupBox:AddToggle("Autofarm", {
	Text = "Boss notifier",
	Default = false,
	Tooltip = "",
	Callback = function(Value)
		Settings.Notifier = Value
	end,
})

local MenuGroup = Tabs["Configuration"]:AddLeftGroupbox("Menu");
(MenuGroup:AddLabel("Menu bind")):AddKeyPicker("MenuKeybind", {Default = "End",NoUI = true,Text = "Menu keybind"})
MenuGroup:AddButton("Unload", function() Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["Configuration"])
ThemeManager:SetFolder("Haeze(Hub)/CR")
SaveManager:SetFolder("Haeze(Hub)/CR")
ThemeManager:ApplyToTab(Tabs["Configuration"])
SaveManager:LoadAutoloadConfig()
game:GetService("RunService").Heartbeat:connect(function()
	task.spawn(function()
		autocollect()
		flowers()
		mobfarm()
		farmplayers()
		bossnotifier()
	end)
end)
