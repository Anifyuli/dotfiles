local function read_file(path)
  local f = io.open(vim.fn.expand(path), "r")
  if not f then return nil end
  local content = f:read("*a"):gsub("%s+", "")
  f:close()
  return content
end

local token = read_file("~/.config/nvim/.github_token")

local M = {
  token = token,
  has_token = token and true or false,
}

function M.url(spec)
  if token then
    return "https://x-access-token:" .. token .. "@github.com/" .. spec
  end
  return "https://github.com/" .. spec
end

return M
