
-- *****************************************************************************
-- NewHomesEntity is the main representation of the New Homes DLC game core in the level - the entity creates and holds the NewHomes.GameCore object, and provides interface to access it from code

NewHomesEntity = {
	-- Editor data for the entity
	Editor = {
		Icon = "Seed.bmp",
		ShowBounds = 1,
		IconOnTop = 1,
	},
	
	-- New Homes game core object (its instance is created in the CreateGameCore method)
	gameCore = nil,
	
	-- Table with the saved data of New Homes game state which has been loaded during OnLoad method and will be used in LoadState method called by quest smart object
	loadedGameCoreState = nil,
}

-- *****************************************************************************

function NewHomesEntity:OnLoad(storage)
	self.loadedGameCoreState = storage
end

-- *****************************************************************************

function NewHomesEntity:OnSave(storage)
	if self.gameCore ~= nil then
		storage = table.ShallowCopy(self.gameCore:SaveState())
	end
end

-- *****************************************************************************

function NewHomesEntity:OnReset()
	self.gameCore = nil
	self.loadedGameCoreState = nil
end

-- *****************************************************************************
-- Creates instance of the GameCore object for controlling the New Homes gameplay

function NewHomesEntity:CreateGameCore()
	self.gameCore = NewHomes.GameCore:New()
	NewHomesLuaAPI.SetGameCore(self.gameCore)
end

-- *****************************************************************************
-- Loads the game core data (loaded during OnLoad method) into the model

function NewHomesEntity:LoadState()
	self.gameCore:LoadState(self.loadedGameCoreState)
end

-- *****************************************************************************

function NewHomesEntity:RequestStructureBuilding(param)
	local data = table.MakeFromType("homeDlc:locatorMove")
	data.add = true
	data.source = enum_homeDlcSourceType.ledgerBook
	data.constructionType = enum_homeDlcConstructionType.structure
	data.id = tonumber(param)
	
	XGenAIModule.SendMessageToEntityData(System.GetEntityByName("q_dlc_homes").this.id, "homeDlc:locatorMove", data)
end

-- *****************************************************************************

function NewHomesEntity:RequestAddonBuilding(param)
	local data = table.MakeFromType("homeDlc:locatorMove")
	data.add = true
	data.source = enum_homeDlcSourceType.ledgerBook
	data.constructionType = enum_homeDlcConstructionType.addon
	data.id = tonumber(param)
	
	XGenAIModule.SendMessageToEntityData(System.GetEntityByName("q_dlc_homes").this.id, "homeDlc:locatorMove", data)
end

-- *****************************************************************************
-- Provides all packed data for the Ledger book in json

function NewHomesEntity:PrepareBookData()
	local data = self.gameCore:PrepareBookData()
	return json.encode(data)
end

-- *****************************************************************************
-- Provides data for the Ledger book code controls

function NewHomesEntity:PrepareBookMetaData()
	local _, data = self.gameCore:PrepareBookData()
	return json.encode(data)
end

-- *****************************************************************************
