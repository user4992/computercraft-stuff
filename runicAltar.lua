--simple automation for botania runic altar
--requires a barrel/chest and a dropper/open crate/industrial dropper connected via wired modem
--
--you may also connect a factory hopper under the altar to auto-collect the output
--
--cyclic's mechanical user seems to be too dumb to operate the runic altar
--
--default recipes only
--does not care for oredictionary or tags
--assume default stone, oak saplings, the works



--locate our peripherals first
local barrel = peripheral.find("minecraft:barrel")
if barrel == nil then
	barrel = peripheral.find("minecraft:chest")
end
if barrel == nil then
	print("No suitable inventory found, quitting")
	return
end

local dropper = peripheral.find("engineersdecor:te_factory_dropper")
if dropper == nil then dropper = peripheral.find("botania:open_crate") end
if dropper == nil then dropper = peripheral.find("minecraft:dropper") end

if dropper == nil then
	print("No suitable dropper found, quitting")
	return
end

--local hopper = peripheral.find("engineersdecor:te_factory_hopper")

--[[
local user = peripheral.find("cyclic:user")
if user == nil then
	print("No mechanical user found, manual operation will be required")
end
]]

local recipes = {}

recipes["water"] = {
	{["name"] = "botania:manasteel_ingot", 			["count"] = 1},
	{["name"] = "botania:mana_powder", 				["count"] = 1},
	{["name"] = "minecraft:fishing_rod", 			["count"] = 1},
	{["name"] = "minecraft:sugar_cane", 			["count"] = 1},
	{["name"] = "minecraft:bone_meal", 				["count"] = 1},
}

--recipes["botania:rune_fire"] = {
recipes["fire"] = {
	{["name"] = "botania:manasteel_ingot", 			["count"] = 1},
	{["name"] = "botania:mana_powder", 				["count"] = 1},
	{["name"] = "minecraft:nether_brick", 			["count"] = 1},
	{["name"] = "minecraft:gunpowder", 				["count"] = 1},
	{["name"] = "minecraft:nether_wart", 			["count"] = 1},
}

recipes["earth"] = {
	{["name"] = "botania:manasteel_ingot", 			["count"] = 1},
	{["name"] = "botania:mana_powder", 				["count"] = 1},
	{["name"] = "minecraft:coal_block", 			["count"] = 1},
	{["name"] = "minecraft:brown_mushroom", 		["count"] = 1},
	{["name"] = "minecraft:stone", 					["count"] = 1},
}

recipes["air"] = {
	{["name"] = "botania:manasteel_ingot", 			["count"] = 1},
	{["name"] = "botania:mana_powder", 				["count"] = 1},
	{["name"] = "minecraft:string", 				["count"] = 1},
	{["name"] = "minecraft:feather", 				["count"] = 1},
	{["name"] = "minecraft:white_carpet",			["count"] = 1},
}

recipes["spring"] = {
	{["name"] = "botania:rune_water", 				["count"] = 1},
	{["name"] = "botania:rune_fire", 				["count"] = 1},
	{["name"] = "minecraft:wheat", 					["count"] = 1},
	{["name"] = "minecraft:oak_sapling", 			["count"] = 3},
}

recipes["summer"] = {
	{["name"] = "botania:rune_earth", 				["count"] = 1},
	{["name"] = "botania:rune_air", 				["count"] = 1},
	{["name"] = "minecraft:sand", 					["count"] = 2},
	{["name"] = "minecraft:slime_ball", 			["count"] = 1},
	{["name"] = "minecraft:melon_slice",			["count"] = 1},
}

recipes["autumn"] = {
	{["name"] = "botania:rune_air", 				["count"] = 1},
	{["name"] = "botania:rune_fire", 				["count"] = 1},
	{["name"] = "minecraft:spider_eye",				["count"] = 1},
	{["name"] = "minecraft:oak_leaves", 			["count"] = 3},
}

recipes["winter"] = {
	{["name"] = "botania:rune_water", 				["count"] = 1},
	{["name"] = "botania:rune_earth", 				["count"] = 1},
	{["name"] = "minecraft:snow_block", 			["count"] = 2},
	{["name"] = "minecraft:white_wool", 			["count"] = 1},
	{["name"] = "minecraft:cake",					["count"] = 1},
}

recipes["mana"] = {
	{["name"] = "botania:mana_pearl", 				["count"] = 1},
	{["name"] = "botania:manasteel_ingot", 			["count"] = 5},
}

recipes["lust"] = {
	{["name"] = "botania:mana_diamond", 			["count"] = 2},
	{["name"] = "botania:rune_summer", 				["count"] = 1},
	{["name"] = "botania:rune_air", 				["count"] = 1},
}

recipes["gluttony"] = {
	{["name"] = "botania:mana_diamond", 			["count"] = 2},
	{["name"] = "botania:rune_fire", 				["count"] = 1},
	{["name"] = "botania:rune_winter", 				["count"] = 1},
}

recipes["greed"] = {
	{["name"] = "botania:mana_diamond", 			["count"] = 2},
	{["name"] = "botania:rune_spring", 				["count"] = 1},
	{["name"] = "botania:rune_water", 				["count"] = 1},
}

recipes["sloth"] = {
	{["name"] = "botania:mana_diamond", 			["count"] = 2},
	{["name"] = "botania:rune_autumn", 				["count"] = 1},
	{["name"] = "botania:rune_air", 				["count"] = 1},
}

recipes["wrath"] = {
	{["name"] = "botania:mana_diamond", 			["count"] = 2},
	{["name"] = "botania:rune_winter", 				["count"] = 1},
	{["name"] = "botania:rune_earth", 				["count"] = 1},
}

recipes["envy"] = {
	{["name"] = "botania:mana_diamond", 			["count"] = 2},
	{["name"] = "botania:rune_winter", 				["count"] = 1},
	{["name"] = "botania:rune_water", 				["count"] = 1},
}

recipes["pride"] = {
	{["name"] = "botania:mana_diamond", 			["count"] = 2},
	{["name"] = "botania:rune_summer", 				["count"] = 1},
	{["name"] = "botania:rune_fire", 				["count"] = 1},
}

local livingrock = {}

local function checkHasIngredients(recipe)

	local items = barrel.list()

	--check each of the recipe's items in a non-optimal way
	for kr,vr in pairs(recipe) do
		local foundItem = nil
		for ki,vi in pairs(items) do
			if vi.name == vr.name and vi.count >= vr.count then
				foundItem = vi
				vr["slot"] = ki
				print("found " .. vi.name .. " at " .. ki)
			end
		end
		if foundItem == nil then
			print("couldn't find enough " .. v)
			return false
		end
	end

	livingrock = nil
	for k,v in pairs(items) do
		if v.name == "botania:livingrock" then
			livingrock = v
			livingrock["slot"] = k
		end
	end
	if livingrock == nil then
		print("no livingrock left")
		return false
	end

	print("ingredients ok")
	return true
end

local function executeRecipe(recipe)

	for k,v in pairs(recipe) do
		print("#"..k.. " pulling x".. v["count"].." ".. v["name"] .." at slot ".. v["slot"])
		barrel.pushItems(peripheral.getName(dropper), v["slot"], v["count"])
		v["slot"] = nil --wipe the temporary slot data, prevent dropping wrong items later
	end

	print("items done, waiting")
	sleep(1)

	print("pulling x1 livingrock")
	barrel.pushItems(peripheral.getName(dropper), livingrock["slot"], 1)
	livingrock["slot"] = nil

	print("done")
	print("")

end

local allRecipes = ""
for k,v in pairs(recipes) do
	allRecipes = allRecipes .. k ..", "
end

print("runicAltar initialized")

while true do

	local chosenRecipe = nil
	print("which rune to craft?")
	chosenRecipe = read()
	if chosenRecipe ~= nil then
		if recipes[chosenRecipe] ~= nil then
			if checkHasIngredients(recipes[chosenRecipe]) then
				executeRecipe(recipes[chosenRecipe])
			end
		else
			print("invalid recipe")
			print("valid options are: " .. allRecipes)
		end
	end

    --event, param = os.pullEvent()
    --print(event, param)

end