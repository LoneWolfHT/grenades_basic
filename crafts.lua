if not minetest.get_modpath("ctf_crafting") then
	-- Regular Grenade

	minetest.register_craft({
		type = "shaped",
		output = "grenades_basic:regular",
		recipe = {
			{"", "default:steel_ingot", ""},
			{"default:steel_ingot", "default:coal_lump", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
		},
	})

	-- Smoke Grenade

	minetest.register_craft({
		type = "shaped",
		output = "grenades_basic:smoke",
		recipe = {
			{"", "default:steel_ingot", ""},
			{"default:steel_ingot", "grenades_basic:gun_powder", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
		}
	})

	--Flashbang Grenade

	minetest.register_craft({
		type = "shaped",
		output = "grenades_basic:flashbang",
		recipe = {
			{"", "default:steel_ingot", ""},
			{"default:steel_ingot", "default:torch", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
		},
	})

	-- Other

	minetest.register_craftitem("grenades_basic:gun_powder", {
		description = "A dark powder used for crafting some grenades",
		inventory_image = "grenades_gun_powder.png"
	})

	minetest.register_craft({
		type = "shapeless",
		output = "grenades_basic:gun_powder",
		recipe = {"default:coal_lump", "default:coal_lump", "default:coal_lump", "default:coal_lump"},
	})
else
	crafting.register_recipe({
		type   = "inv",
		output = "ctf_grenades:grenade_regular 1",
		items  = { "default:steel_ingot 5", "default:iron_lump" },
		always_known = true,
		level  = 1,
	})

	crafting.register_recipe({
		type   = "inv",
		output = "ctf_grenades:grenade_smoke 1",
		items  = { "default:steel_ingot 5", "default:coal_lump 4" },
		always_known = true,
		level  = 1,
	})

	crafting.register_recipe({
		type   = "inv",
		output = "ctf_grenades:grenade_flashbang 1",
		items  = { "default:steel_ingot 5", "default:torch 5" },
		always_known = true,
		level  = 1,
	})
end

if minetest.get_modpath("ctf_treasure") then
	treasurer.register_treasure("ctf_grenades:grenade_regular", 0.4, 2, 1)
	treasurer.register_treasure("ctf_grenades:grenade_smoke", 0.4, 2, 1)
	treasurer.register_treasure("ctf_grenades:grenade_flashbang", 0.4, 2, 1)
end