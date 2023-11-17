return function(m)
  local ok, mod = pcall(require, m)
  if not ok then return nil end
  return mod
end
