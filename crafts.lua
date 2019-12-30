local gunpowder = "grenades_basic:gun_power"

if not minetest.get_modpath("tnt") then
	minetest.register_craftitem("grenades_basic:gun_powder", {
		description = "A dark powder used for crafting some grenades",
		inventory_image = "grenades_basic_gun_powder.png"
	})

	minetest.register_craft({
		type = "shapeless",
		output = "grenades_basic:gun_powder",
		recipe = {"default:coal_lump", "default:coal_lump", "default:coal_lump", "default:coal_lump"},
	})
else
	gunpowder = "tnt:gunpowder"
end

-- Frag Grenade

minetest.register_craft({
	type = "shaped",
	output = "grenades_basic:frag",
	recipe = {
		{"default:obsidian_shard", "default:steel_ingot", "default:obsidian_shard"},
		{"default:steel_ingot", gunpowder, "default:steel_ingot"},
		{"default:obsidian_shard", "default:steel_ingot", "default:obsidian_shard"}
	},
})

-- Smoke Grenade

minetest.register_craft({
	type = "shaped",
	output = "grenades_basic:smoke",
	recipe = {
		{"default:coal_lump", "default:steel_ingot", "default:coal_lump"},
		{"default:steel_ingot", gunpowder, "default:steel_ingot"},
		{"default:coal_lump", "default:steel_ingot", "default:coal_lump"}
	}
})

--Flashbang Grenade

minetest.register_craft({
	type = "shaped",
	output = "grenades_basic:flashbang",
	recipe = {
		{"default:steel_ingot", "default:mese_crystal", "default:steel_ingot"},
		{"default:steel_ingot", gunpowder, "default:steel_ingot"},
		{"", "default:steel_ingot", ""}
	},
})
