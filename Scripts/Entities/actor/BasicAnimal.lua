BasicAnimal =
{
	collisionClass = gcc_npc_ignored_type,

	physicsParams =
	{
		additionalPhysicsMass = 1.0,

		Living =
		{
				min_slide_angle = 89.0,
				max_climb_angle = 89.0,
				min_fall_angle = 89.0,
				max_jump_angle = 89.0,
		}
	},

	Properties =
	{
		bCanHoldInformation = false
	}
}

-- =============================================================================
function BasicAnimal:GetActions(user, firstFast)
	if (user == nil) then
		return {}
	end

	if (self.actor:GetHealth() <= 0) then
		return self:AddAnimalLootAction(user, firstFast)
	end
	return {}
end

-- =============================================================================
function BasicAnimal:AddAnimalLootAction(user, firstFast)
	output = {}

	if (self.soul:HasScriptContext("animal_disableLootButcherActions")) then
		return {}
	end

	if (self.actor:CanBeButchered()) then
		if (not self.actor:IsPlayerInButcheringDistance()) then
			return {}
		end
		local enabled = user.soul:IsInTenseCircumstance() == false
		AddInteractorAction(output, firstFast, 
			Action():hint("@ui_hud_butcher"):action("use"):hintType(AHT_HOLD):func(BasicAnimal.OnUsed):interaction(inr_loot):enabled(enabled):reason("@ui_butcher_tensecircumstance"))
	else
		AddInteractorAction(output, firstFast, Action():hint("@ui_hud_loot"):action("use"):hintType(AHT_RELEASE):func(BasicAnimal.OnUsed):interaction(inr_loot))
	end

	return output
end

-- =============================================================================
function BasicAnimal:OnReset(bFromInit, bIsReload)
	BasicActor.Reset(self, bFromInit, bIsReload)
	self:SetColliderMode(4)
end

-- =============================================================================
function BasicAnimal:OnUsed(user)
	if (self.actor:GetHealth() <= 0) then
		self.actor:RequestItemExchange(user.id)
	end
end

-- =============================================================================
function BasicAnimal:IsUsable(user)
	if (not user) then
		return 0; -- canot be used by AI
	end

	if (self.actor:GetHealth() <= 0) then
		return 1
	end

	return 0
end

table.Merge(BasicAnimal, BasicActor)
