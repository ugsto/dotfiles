return {
	config = {
		formatting = {
			disabled = {
				"tsserver",
			},
		},
		clangd = {
			cmd = {
				"clangd",
				"--offset-encoding=utf-16",
			},
		},
		arduino_language_server = {
			cmd = {
				"arduino-language-server",
				"-cli-config",
				"~/.arduino15/arduino-cli.yaml",
				"-cli",
				"arduino-cli",
				"-clangd",
				"clangd",
				"-fqbn",
				"arduino:avr:uno",
			},
		},
		jdtls = function()
			local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
			local root_dir = require("jdtls.setup").find_root(root_markers)

			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
			local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
			os.execute("mkdir -p " .. workspace_dir)

			local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

			local os
			if vim.fn.has("macunix") then
				os = "mac"
			elseif vim.fn.has("win32") then
				os = "win"
			else
				os = "linux"
			end

			return {
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-javaagent:" .. install_path .. "/lombok.jar",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
					"-configuration",
					install_path .. "/config_" .. os,
					"-data",
					workspace_dir,
				},
				root_dir = root_dir,
			}
		end,
	},
	setup_handlers = {
		rust_analyzer = function(_, opts)
			opts.settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						command = "clippy",
					},
				},
			}
			require("rust-tools").setup({ server = opts })
		end,
		jdtls = function(_, opts)
			vim.api.nvim_create_autocmd("Filetype", {
				pattern = "java", -- autocmd to start jdtls
				callback = function()
					if opts.root_dir and opts.root_dir ~= "" then
						require("jdtls").start_or_attach(opts)
					end
				end,
			})
		end,
	},
	on_attach = function(client, _)
		client.server_capabilities.semanticTokensProvider = nil
	end,
}
