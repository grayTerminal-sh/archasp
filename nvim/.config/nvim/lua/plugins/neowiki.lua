return {
  "echaya/neowiki.nvim",
  opts = {
    wiki_dirs = {
        { name = "Pentest", path = "~/Wiki/pentest" },
        { name = "Python", path = "~/Wiki/python" },
        { name = "Osint", path = "~/Wiki/osint" },
    },
    index_file = "index.md",
    discover_nested_roots = true,
    keymaps = {
      action_link = "<CR>",
      action_link_vsplit = "<S-CR>",
      action_link_split = "<C-CR>",
      next_link = "<Tab>",
      prev_link = "<S-Tab>",
      navigate_back = "[[",
      navigate_forward = "]]",
      jump_to_index = "<Backspace>",
      rename_page = "<leader>wr",
      delete_page = "<leader>wd",
      insert_link = "<leader>wi",
      cleanup_links = "<leader>wc",
      toggle_task = "<leader>wt",
      close_float = "q",
    },
    gtd = {
      show_gtd_progress = true,
      gtd_progress_hl_group = "Comment",
    },
    floating_wiki = {
      open = {
        relative = "editor",
        width = 0.9,
        height = 0.9,
        border = "rounded",
      },
      style = {},
    },
  },
  config = function(_, opts)
    local neowiki = require("neowiki")
    neowiki.setup(opts)

    -- mappings globaux pour ouvrir le wiki
    vim.keymap.set("n", "<leader>ww", neowiki.open_wiki, { desc = "Open Wiki" })
    vim.keymap.set("n", "<leader>wW", neowiki.open_wiki_floating, { desc = "Open Wiki (float)" })
    vim.keymap.set("n", "<leader>wT", neowiki.open_wiki_new_tab, { desc = "Open Wiki (tab)" })
  end,
}

