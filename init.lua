local function blast(pos, radius)
	local pos1 = vector.subtract(pos, radius)
	local pos2 = vector.add(pos, radius)

	for _, p in ipairs(minetest.find_nodes_in_area(pos1, pos2, {
		"group:flora", "group:mushroom", "default:snow",
		"group:grenade_breakable", "group:dig_immediate"
	})) do
		if vector.distance(pos, p) <= radius then
			local node = minetest.get_node(p).name

			if node ~= "air" then
				minetest.add_item(p, node)
			end

			minetest.remove_node(p)
		end
	end
end

local function check_hit(pos1, pos2, obj)
	local ray = minetest.raycast(pos1, pos2, true, false)
	local hit = ray:next()

	-- Skip over non-normal nodes like ladders, water, doors, glass, leaves, etc
	-- Also skip over all objects that aren't the target
	-- Any collisions within a 1 node distance from the target don't stop the grenade
	while hit and (
		(
		 hit.type == "node"
		 and
		 (
			hit.intersection_point:distance(pos2) <= 1
			or
			not minetest.registered_nodes[minetest.get_node(hit.under).name].walkable
		 )
		)
		or
		(
		 hit.type == "object" and hit.ref ~= obj
		)
	) do
		hit = ray:next()
	end

	if hit and hit.type == "object" and hit.ref == obj then
		return true
	end
end
grenades.register_grenade("grenades_basic:frag", {
	description = "Frag grenade (Kills anyone near blast)",
	image = "grenades_basic_frag.png",
	explode_radius = 6,
	explode_damage = 26,
	on_explode = function(def, obj, pos, name)
		if not name or not pos then
			return
		end

		local player = minetest.get_player_by_name(name)
		if not player then return end

		local radius = def.explode_radius

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
			texture = "grenades_basic_smoke.png",
		})

		minetest.add_particle({
			pos = pos,
			velocity = {x=0, y=0, z=0},
			acceleration = {x=0, y=0, z=0},
			expirationtime = 0.3,
			size = 15,
			collisiondetection = false,
			collision_removal = false,
			object_collision = false,
			vertical = false,
			texture = "grenades_basic_boom.png",
			glow = 10
		})

		minetest.sound_play("grenades_basic_explode", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 64,
		})

		blast(pos, radius/2)

		for _, v in pairs(minetest.get_objects_inside_radius(pos, radius)) do
			if v:get_hp() > 0 and (not v:get_luaentity() or not v:get_luaentity().name:find("builtin")) then
				local footpos = vector.offset(v:get_pos(), 0, 0.1, 0)
				local headpos = vector.offset(v:get_pos(), 0, v:get_properties().eye_height, 0)
				local footdist = vector.distance(pos, footpos)
				local headdist = vector.distance(pos, headpos)
				local target_head = false

				if footdist >= headdist then
					target_head = true
				end

				local hit_pos1 = check_hit(pos, target_head and headpos or footpos, v)

				-- Check the closest distance, but if that fails try targeting the farther one
				if hit_pos1 or check_hit(pos, target_head and footpos or headpos, v) then
					v:punch(player, 1, {
						punch_interval = 1,
						damage_groups = {
							grenade = 1,
							fleshy = def.explode_damage - ( (radius/3) * (target_head and headdist or footdist) )
						}
					}, vector.direction(pos, footpos))
				end
			end
		end
	end,
})

-- Smoke Grenade

grenades.register_grenade("grenades_basic:smoke", {
	description = "Smoke grenade (Generates smoke around blast site)",
	image = "grenades_basic_smoke_grenade.png",
	on_explode = function(def, obj, pos)
		minetest.sound_play("grenades_basic_glasslike_break", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 32,
		})

		local hiss = minetest.sound_play("grenades_basic_hiss", {
			pos = pos,
			gain = 1.0,
			loop = true,
			max_hear_distance = 32,
		})

		minetest.after(40, minetest.sound_stop, hiss)

		for i = 0, 5, 1 do
			minetest.add_particlespawner({
				amount = 40,
				time = 45,
				minpos = vector.subtract(pos, 2),
				maxpos = vector.add(pos, 2),
				minvel = {x = 0, y = 2, z = 0},
				maxvel = {x = 0, y = 3, z = 0},
				minacc = {x = 1, y = 0.2, z = 1},
				maxacc = {x = 1, y = 0.2, z = 1},
				minexptime = 1,
				maxexptime = 1,
				minsize = 125,
				maxsize = 140,
				collisiondetection = false,
				collision_removal = false,
				vertical = false,
				texture = "grenades_basic_smoke.png",
			})
		end
	end,
	particle = {
		image = "grenades_basic_smoke.png",
		life = 1,
		size = 4,
		glow = 0,
		interval = 5,
	}
})

dofile(minetest.get_modpath("grenades_basic").."/crafts.lua")
