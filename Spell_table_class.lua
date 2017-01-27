Spell_table = {}

--table.string_var converts to table["string_Var"]
--when assigning with string from variable, you need to do assignment table[string_Var] = value
--optional callback function that gets activated when timer runs out. default function does nothing
function Spell_table.new(obj)
	--local arg = {n=select('#',...),...}
	spell_table = {}
	setmetatable(spell_table, {__index = Spell_table})
	spell_table:add_spell("parent", obj)
	spell_table:add_spell(Shockwave, 180)
	spell_table:add_spell(Freezing_field, 180)

	--print(spell_table:get_parent())
	--print("arg1: ", arg[1], " arg2: ", arg[2])
	--[[for ind, value in pairs(arg) do
		print(arg[1], arg[2])
		if value ~= obj then
			spell_table:add_spell(value[1], value[2])
		end
	end
	--]]
	return spell_table
end

function Spell_table:add_spell(string, timer_max)
	-- (name, current_timer, timer_max, currently_on_cooldown)
	local my_table = {}
	
	my_table["timer"] = timer_max
	my_table["timer_max"] = timer_max
	my_table["on_cooldown"] = false
	my_table['callback'] = function() print('success') return end
	--print(my_table)
	--my_table:callback()
	
	--print("before: ", #self)
	self[string] = my_table
	--print("after: ", self[string])

end

function Spell_table:update()
	
	for ind, value in pairs(self) do
		if value.on_cooldown == true then
			-- if the spell effect is active, do this stuff
			
			if value.timer <= 0 then
				-- if counter for this spell is <= 0, times up. Reset the counter, set "counting down" to false, and tell the parent somehow.
				value.timer = value.timer_max
				value.on_cooldown = false
				value.callback(self:get_parent())

				
			else
				-- otherwise, countdown.
				value.timer = value.timer - 1
			end
		end
	end
end

function Spell_table:cast(...)
	local t = {n=select('#',...),...}

	setmetatable(t,{__index={timer_max = self[t[1]]['timer_max'], callback = function() print('kappa') return end}})


	local spell, timer_max, callback =
		t[1] or t['shockwave'], -- the spell to cast
		t[2] or t['timer_max'],
		t[3] or t['callback']

	-- check conditions before casting
	local spell_obj = t[1]() 
	local caster = self:get_parent()
	local cost = spell_obj.mp_cost

	if caster.mp[cost[2]] >= cost[1] then
		caster.mp[cost[2]] = caster.mp[cost[2]] - cost[1]
		--casts the spell.
		self[spell]['on_cooldown'] = true
		self[spell]['timer_max'] = timer_max
		self[spell]['callback'] = callback

		if caster == player then
			setup_mana()
		end
	else
		global_obj_array[spell_obj.global_index] = nil
	end

	

end


function Spell_table:get_parent()
	return self.parent.timer_max
end

function Spell_table:check_spell(string)
	--[[print(string)
	print(self[string])
	print(self.airborne)
	print(self['airborne'])
	print(self.string)
	print(self['string'])--]]
	return self[string]['on_cooldown']
end

function Spell_table:get_spell(string)
	return self[string]
end