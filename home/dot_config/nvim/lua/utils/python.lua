-- Helper untuk resolve interpreter Python, UV-first
local M = {}

--- Cari path interpreter Python untuk project di `root_dir`
--- Prioritas: .venv (uv sync) -> VIRTUAL_ENV -> python3 di PATH
---@param root_dir string? root project (default: cwd)
---@return string
function M.get_python_path(root_dir)
  root_dir = root_dir or vim.uv.cwd()

  -- 1. Project venv dari UV (.venv biasanya dibuat `uv sync` / `uv venv`)
  local venv = vim.fs.find({ ".venv", "venv" }, {
    path = root_dir,
    upward = true,
    type = "directory",
  })[1]
  if venv then
    local py = venv .. "/bin/python"
    if vim.uv.fs_stat(py) then
      return py
    end
  end

  -- 2. Virtualenv yang sedang aktif di shell
  if vim.env.VIRTUAL_ENV then
    local py = vim.env.VIRTUAL_ENV .. "/bin/python"
    if vim.uv.fs_stat(py) then
      return py
    end
  end

  -- 3. Fallback: python3 di PATH (termasuk shim UV)
  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python3"
end

return M

-- vim: ts=2 sts=2 sw=2 et
