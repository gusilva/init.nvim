return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "*",
  -- install jsregexp (optional!).
  build = "make install_jsregexp",

  dependencies = { "rafamadriz/friendly-snippets" },

  -- config = function()
  --     local ls = require("luasnip")
  --     ls.filetype_extend("javascript", { "jsdoc" })
  -- end,
}

