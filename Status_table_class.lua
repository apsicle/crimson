Status_table = {}

function Status_table.new(obj)
	status_table = {}
	setmetatable(table, {__index = Status_table, __newindex = {function(t,k,b) if k == "parent" then v.parent = t end rawset(t,k,v) end}})
	status_table.parent = obj
	status_table
end

function Status_table.add_status(string, timer_max)
	-- (name, current_timer, timer_max, currently_running)
	local my_table = {}
	
	my_table["timer"] = timer_max
	my_table["timer_max"] = timer_max
	my_table["running"] = false

	local status = {}

	self
end

function Status_table.update()
	for ind, value in pairs(status_table) do
		if value[4] == true then
			-- if the status effect is active, do this stuff
			if value[2] <= 0 then
				-- if counter for this status is <= 0, times up. Reset the counter, set "counting down" to false, and tell the parent somehow.
				value[2] = value[3]
				value[4] = false
				--status_table.parent
			else
				-- otherwise, countdown.
				value[2] = value[2] - 1
			end
		end
	end
end
				