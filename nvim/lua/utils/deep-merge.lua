local function deep_merge(t1, t2)
	local merged = {}
	for k, v in pairs(t1) do
		merged[k] = v
		if type(v) == "table" and type(t2[k]) == "table" then
			merged[k] = deep_merge(v, t2[k])
		end
	end
	for k, v in pairs(t2) do
		if type(v) == "table" and type(t1[k]) == "table" then
			merged[k] = deep_merge(t1[k], v)
		else
			merged[k] = v
		end
	end
	return merged
end

return deep_merge
