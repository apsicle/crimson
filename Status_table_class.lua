Status_table = {}

--table.string_var converts to table["string_Var"]
--when assigning with string from variable, you need to do assignment table[string_Var] = value
--optional callback function that gets activated when timer runs out. default function does nothing
function Status_table.new(obj)
	--local arg = {n=select('#',...),...}
	status_table = {}
	setmetatable(status_table, {__index = Status_table})
	status_table:add_status("parent", obj)
	status_table:add_status("invincible", 60)
	status_table:add_status("frostbitten", 60, 
		function(obj, status)
			obj.color = global_palette[3]
			obj.speed = obj.speed / 2 end, 
		function(obj, status) end, 
		function(obj, status) 
			obj.speed = obj.speed * 2 end)
	status_table:add_status("airborne", 180)
	status_table:add_status("staggered", 180)
	status_table:add_status("stunned", 60)
	status_table:add_status("burned", 60)
	status_table:add_status("jaunted", 180)
	status_table:add_status("reloading", 30)
	status_table:add_status("hit", 180)
	status_table:add_status("stunned", 60)
	status_table:add_status("override_move", 60)
	status_table:add_status("knocked_back", 60, 
		function(obj, status) 
			obj.status:activate_status{'override_move', 60}
			print_table(status.data)
			status.data.dest_x = obj.x - (status.data.x - obj.x)
			status.data.dest_y = obj.y - (status.data.y - obj.y)
			end, 
		function(obj, status) 
			if move_constant_speed(obj, status.data.dest_x, status.data.dest_y, 5) == false then
				status.timer = 0
			end
			end, 
		function(obj, status) 
			obj.status:activate_status{'stunned', 60}
			end)
	status_table:add_status("ignore_collision_with", 60)
	--animation_running_up(status_table:get_parent())
	--print("arg1: ", arg[1], " arg2: ", arg[2])
	--[[for ind, value in pairs(arg) do
		print(arg[1], arg[2])
		if value ~= obj then
			status_table:add_status(value[1], value[2])
		end
	end
	--]]
	return status_table
end

function Status_table:add_status(status_name, timer_max, on_start, effect, callback)
	-- adds a table which keeps track of a particular status specified by status_name
	-- on_start function is called once with object effected as argument on start
	-- effect is called every update throughout status effect
	-- callback is called once when the status effect ends
	local on_start = on_start or function() return end
	local effect = effect or function() return end
	local callback = callback or function() return end
	-- (name, current_timer, timer_max, currently_running)
	local my_table = {}
	
	my_table["timer"] = timer_max
	my_table["timer_max"] = timer_max
	my_table["running"] = false
	my_table['on_start'] = on_start
	my_table['effect'] = effect
	my_table['callback'] = callback
	my_table['data'] = {}

	self[status_name] = my_table
	if status_name == "frostbitten" then
		--print_table(my_table)
	end

end

function Status_table:update()
	
	for ind, value in pairs(self) do
		if value.running == true then
			-- if the status effect is active, do this stuff
			if ind == 'frostbitten' then
				--print_table(value)
			end
			value.effect(self:get_parent(), value)
			
			if value.timer <= 0 then
				-- if counter for this status is <= 0, times up. Reset the counter, set "counting down" to false, and tell the parent somehow.
				value.timer = value.timer_max
				value.running = false
				value.callback(self:get_parent(), value)
			else
				-- otherwise, countdown.
				value.timer = value.timer - 1
			end
		end
	end
end

function Status_table:activate_status(t)
	

	setmetatable(t,{__index={timer_max = self[t[1]]['timer_max'], on_start = self[t[1]]['on_start'], effect = self[t[1]]['effect'], callback = self[t[1]]['callback'], data = {}}})

	local status, timer_max, on_start, effect, callback, data =
		t[1],
		t[2] or t['timer_max'],
		t[3] or t['on_start'],
		t[4] or t['effect'],
		t[5] or t['callback'],
		t[6] or t['data']

	-- add every piece of info to the current timer call
	self[status]['timer_max'] = timer_max
	self[status]['timer'] = timer_max
	self[status]['on_start'] = on_start
	self[status]['effect'] = effect
	self[status]['callback'] = callback
	self[status]['data'] = data

	-- if the current status is already activated, do not perform an on_start function call
	if self[status]['running'] ~= true then
		on_start(self:get_parent(), self[status])
	end

	-- start or restart the timer call.
	self[status]['running'] = true
	
end


function Status_table:get_parent()
	-- hack. this returns the parent object.
	return self.parent.timer_max
end

function Status_table:check_status(string)
	--[[print(string)
	print(self[string])
	print(self.airborne)
	print(self['airborne'])
	print(self.string)
	print(self['string'])--]]
	return self[string]['running']
end

function Status_table:get_status(string)
	return self[string]
end