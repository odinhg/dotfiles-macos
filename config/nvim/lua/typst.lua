-- Typst: fold on headings and compile to PDF on save.

-- Fold on `=`, `==`, ... headings (followed by a space).
function _G.typst_foldexpr()
  local level = vim.fn.getline(vim.v.lnum):match("^(=+)%s")
  return level and (">" .. #level) or "="
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.typst_foldexpr()"
    vim.opt_local.foldlevel = 99
  end,
})

-- Compile the project's main.typ (or vim.g.typst_main) rather than the saved
-- chapter, since chapters usually can't compile on their own.
local function root_of(path)
  local found = vim.fs.find({ "typst.toml", ".git" }, { path = vim.fs.dirname(path), upward = true })[1]
  return found and vim.fs.dirname(found)
end

local function target_of(file)
  if vim.g.typst_main then
    return vim.g.typst_main, root_of(vim.g.typst_main)
  end
  local root = root_of(file)
  if root and vim.uv.fs_stat(root .. "/main.typ") then
    return root .. "/main.typ", root
  end
  return file, root
end

-- At most one compile at a time. A save during a compile queues one rerun.
local running, queued = false, false

local function compile(file)
  if vim.fn.executable("typst") == 0 then return end
  if running then
    queued = true
    return
  end

  local target, root = target_of(file)
  local cmd = { "typst", "compile" }
  if root then vim.list_extend(cmd, { "--root", root }) end
  table.insert(cmd, target)

  running = true
  vim.system(cmd, { text = true }, function(res)
    running = false
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify("typst compile failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
      end
      if queued then
        queued = false
        compile(file)
      end
    end)
  end)
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.typ",
  callback = function(ev) compile(ev.file) end,
})
