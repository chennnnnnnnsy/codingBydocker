local status_ok, comment = pcall(require, "Comment")
if not status_ok then return end

comment.setup {
  pre_hook = function(ctx)
    local U = require "Comment.utils"

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location =
          require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return
        require("ts_context_commentstring.internal").calculate_commentstring {
          key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
          location = location
        }
  end
}
require("todo").setup {
  signs = {
    enable = true, -- show icons in the sign column
    priority = 8
  },
  keywords = {
    FIX = {
      icon = " ", -- used for the sign, and search results
      -- can be a hex color, or a named color
      -- named colors definitions follow below
      color = "error",
      -- a set of other keywords that all map to this FIX keywords
      alt = {"FIXME", "BUG", "FIXIT", "ISSUE"}
      -- signs = false -- configure signs for some keywords individually
    },
    TODO = {icon = " ", color = "info"},
    WARN = {icon = " ", color = "warning", alt = {"WARNING"}},
    NOTE = {icon = " ", color = "hint", alt = {"INFO"}}
  },
  merge_keywords = true, -- wheather to merge custom keywords with defaults
  highlight = {
    -- highlights before the keyword (typically comment characters)
    before = "", -- "fg", "bg", or empty
    -- highlights of the keyword
    -- wide is the same as bg, but also highlights the colon
    keyword = "wide", -- "fg", "bg", "wide", or empty
    -- highlights after the keyword (TODO text)
    after = "fg", -- "fg", "bg", or empty
    -- pattern can be a string, or a table of regexes that will be checked
    -- vim regex
    pattern = [[.*<(KEYWORDS)\s*:]],
    comments_only = true, -- highlight only inside comments using treesitter
    max_line_len = 400, -- ignore lines longer than this
    exclude = {} -- list of file types to exclude highlighting
  },
  -- list of named colors
  -- a list of hex colors or highlight groups
  -- will use the first valid one
  colors = {
    error = {"DiagnosticError", "ErrorMsg", "#DC2626"},
    warning = {"DiagnosticWarn", "WarningMsg", "#FBBF24"},
    info = {"DiagnosticInfo", "#2563EB"},
    hint = {"DiagnosticHint", "#10B981"},
    default = {"Identifier", "#7C3AED"}
  },
  search = {
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]] -- ripgrep regex
  }
}
