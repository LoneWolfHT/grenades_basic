local function remove_flora(pos, radius)
	local pos1 = vector.subtract(pos, radius)
	local pos2 = vector.add(pos, radius)

	for _, p in ipairs(minetest.find_nodes_in_area(pos1, pos2, "group:flora")) do
		if vector.distance(pos, p) <= radius then
			minetest.remove_node(p)
		end
	end
end

grenades.register_grenade("grenades_basic:regular", {
	description = "Regular grenade (Kills anyone near blast)",
	image = "grenades_regular.png",
	on_explode = function(pos, name)
		if not name or not pos then
			return
		end

		local player = minetest.get_player_by_name(name)

		local radius = 6

		minetest.add_particlespawner({
			amount = 20,
			time = 0.5,
			minpos = vector.subtract(pos, radius),
			maxpos = vector.add(pos, radius),
			minvel = {x = 0, y = 5, z = 0},
			maxvel = {x = 0, y = 7, z = 0},
			minacc = {x = 0, y = 1, z = 0},
			maxacc = {x = 0, y = 1, z = 0},
			minexptime = 0.3,
			maxexptime = 0.6,
			minsize = 7,
			maxsize = 10,
			collisiondetection = true,
			collision_removal = false,
			vertical = false,
			texture = "grenades_smoke.png",
		})

		minetest.sound_play("boom", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 32,
		})

		remove_flora(pos, radius)

		for _, v in ipairs(minetest.get_objects_inside_radius(pos, radius)) do
			local hit = minetest.raycast(pos, v:get_pos(), true, true):next()

			if v:is_player() and v:get_hp() > 0 and hit.type == "object" and hit.ref:is_player() and
			hit.ref:get_player_name() == v:get_player_name() then
				v:punch(player, 2, {damage_groups = {fleshy = 26 - (vector.distance(pos, v:get_pos()) * 2)}}, nil)
			end
		end
	end,
})

-- Flashbang Grenade

grenades.register_grenade("grenades_basic:flashbang", {
	description = "Flashbang grenade (Blinds all who look at blast)",
	image = "grenades_flashbang.png",
	on_explode = function(pos)
		for _, v in ipairs(minetest.get_objects_inside_radius(pos, 20)) do
			local hit = minetest.raycast(pos, v:get_pos(), true, true):next()

			if v:is_player() and v:get_hp() > 0 and hit.type == "object" and hit.ref:is_player() and
			hit.ref:get_player_name() == v:get_player_name() then
				local playerdir = vector.round(v:get_look_dir())
				local grenadedir = vector.round(vector.direction(v:get_pos(), pos))
				local pname = v:get_player_name()

				minetest.sound_play("glasslike_break", {
					pos = pos,
					gain = 1.0,
					max_hear_distance = 32,
				})

				if math.acos(playerdir.x*grenadedir.x + playerdir.y*grenadedir.y + playerdir.z*grenadedir.z) <= math.pi/4 then
					for i = 0, 5, 1 do
						local key = v:hud_add({
							hud_elem_type = "image",
							position = {x = 0, y = 0},
							name = "flashbang hud "..pname,
							scale = {x = -200, y = -200},
							text = "grenades_white.png^[opacity:"..tostring(255 - (i * 20)),
							alignment = {x = 0, y = 0},
							offset = {x = 0, y = 0}
						})

						minetest.after(2 * i, function()
							if minetest.get_player_by_name(pname) then
								minetest.get_player_by_name(pname):hud_remove(key)
							end
						end)
					end
				end

			end
		end
	end,
})

-- Smoke Grenade

grenades.register_grenade("grenades_basic:smoke", {
	description = "Smoke grenade (Generates smoke around blast site)",
	image = "grenades_smoke_grenade.png",
	on_explode = function(pos)

		minetest.sound_play("glasslike_break", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 32,
		})

		minetest.sound_play("hiss", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 32,
		})

		for i = 0, 5, 1 do
			minetest.add_particlespawner({
				amount = 30,
				time = 11,
				minpos = vector.subtract(pos, 3),
				maxpos = vector.add(pos, 3),
				minvel = {x = 0, y = 2, z = 0},
				maxvel = {x = 0, y = 3, z = 0},
				minacc = {x = 1, y = 0.2, z = 1},
				maxacc = {x = 1, y = 0.2, z = 1},
				minexptime = 0.3,
				maxexptime = 0.5,
				minsize = 90,
				maxsize = 100,
				collisiondetection = false,
				collision_removal = false,
				vertical = false,
				texture = "grenades_smoke.png",
			})
		end
	end,
	particle = {
		image = "grenades_smoke.png",
		life = 1,
		size = 4,
		glow = 0,
		interval = 5,
	}
})

dofile(minetest.get_modpath("grenades_basic").."/crafts.lua")
