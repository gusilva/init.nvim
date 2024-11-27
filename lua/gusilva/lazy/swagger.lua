return {
	"rusagaib/oas-preview.nvim",
	config = function()
		require("oas-preview").setup({
			api_route = "http://127.0.0.1",
			port = "3333", -- up-to-you
			ui = "swagger", -- "swagger", "redoc", "stoplight"
		})
	end,
}

-- return {
-- 	"vinnymeller/swagger-preview.nvim",
-- 	build = "npm install -g swagger-ui-watcher",
-- 	config = function()
-- 		require("swagger-preview").setup({
-- 			-- The port to run the preview server on
-- 			port = 3332,
-- 			-- The host to run the preview server on
-- 			host = "localhost",
-- 		})
-- 	end,
-- }
