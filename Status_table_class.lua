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
	status_table:add_status("frostbitten", 60)
	status_table:add_status("airborne", 180)
	status_table:add_status("staggered", 180)
	status_table:add_status("stunned", 60)
	status_table:add_status("burned", 60)
	status_table:add_status("jaunted", 180)
	status_table:add_status("reloading", 30)

	print(status_table.parent.timer_max == player)
	--print(status_table:get_parent())
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

function Status_table:add_status(string, timer_max)
	-- (name, current_timer, timer_max, currently_running)
	local my_table = {}
	
	my_table["timer"] = timer_max
	my_table["timer_max"] = timer_max
	my_table["running"] = false
	my_table['callback'] = function() print('success') return end
	--print(my_table)
	--my_table:callback()
	
	--print("before: ", #self)
	self[string] = my_table
	--print("after: ", self[string])

end

function Status_table:update()
	
	for ind, value in pairs(self) do
		if value.running == true then
			-- if the status effect is active, do this stuff
			
			if value.timer <= 0 then
				-- if counter for this status is <= 0, times up. Reset the counter, set "counting down" to false, and tell the parent somehow.
				value.timer = value.timer_max
				value.running = false
				value.callback(self:get_parent())

				
			else
				-- otherwise, countdown.
				value.timer = value.timer - 1
			end
		end
	end
end

function Status_table:activate_status(...)
	local t = {n=select('#',...),...}

	setmetatable(t,{__index={timer_max = self[t[1]]['timer_max'], callback = function() print('kappa') return end}})

	local status, timer_max, callback =
		t[1] or t['frostbitten'], -- default check frostbitten
		t[2] or t['timer_max'],
		t[3] or t['callback']

	self[status]['running'] = true
	self[status]['timer_max'] = timer_max
	self[status]['callback'] = callback
end


function Status_table:get_parent()
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