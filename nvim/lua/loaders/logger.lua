local loglevel = vim.g.loglevel or "INFO"

local function load_logger()
	local logger = vim.api.nvim_echo
	local error_logger = vim.api.nvim_err_writeln

	local M = {}

	local function debug(message)
		if loglevel == "DEBUG" then
			logger({ { "DEBUG: " .. message, "Comment" } }, true, {})
		end
	end

	local function info(message)
		if loglevel == "DEBUG" or loglevel == "INFO" then
			logger({ { "INFO: " .. message, "Normal" } }, true, {})
		end
	end

	local function warning(message)
		if loglevel == "DEBUG" or loglevel == "INFO" or loglevel == "WARNING" then
			logger({ { "WARNING: " .. message, "WarningMsg" } }, true, {})
		end
	end

	local function error(message)
		if loglevel == "DEBUG" or loglevel == "INFO" or loglevel == "WARNING" or loglevel == "ERROR" then
			error_logger("ERROR: " .. message)
		end
	end

	local function critical(message)
		if
			loglevel == "DEBUG"
			or loglevel == "INFO"
			or loglevel == "WARNING"
			or loglevel == "ERROR"
			or loglevel == "CRITICAL"
		then
			error_logger("CRITICAL:" .. message)
		end
	end

	M = {
		debug = debug,
		info = info,
		warning = warning,
		error = error,
		critical = critical,
	}

	return M
end

return load_logger()
