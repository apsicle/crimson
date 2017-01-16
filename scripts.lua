function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

function add_object(array, pointer, object)
	--inserts an object in an table and returns the index at which it was inserted
	table.insert(array, pointer, object)
	global_obj_pointer = global_obj_pointer + 1;
	return pointer
end

function collide(obj_a, obj_b)
	obj_a:resolve_collision(obj_b)
	obj_b:resolve_collision(obj_a)
	return
end