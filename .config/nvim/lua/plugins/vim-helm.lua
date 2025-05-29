local function is_helm_file(path)
  local check = vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })
  return not vim.tbl_isempty(check)
end

local function yaml_filetype(path, bufname)
  return is_helm_file(path) and "helm.yaml" or "yaml"
end

local function tmpl_filetype(path, bufname)
  return is_helm_file(path) and "helm.tmpl" or "template"
end

local function tpl_filetype(path, bufname)
  return is_helm_file(path) and "helm.tmpl" or "smarty"
end

return {
  'towolf/vim-helm',
  ft = 'helm',
  config = function()
    -- need to define filetypes for helm in order
    -- to disable yamlls LSP server for helm files
    vim.filetype.add({
      extension = {
        yaml = yaml_filetype,
        yml = yaml_filetype,
        tmpl = tmpl_filetype,
        tpl = tpl_filetype,
      },
      filename = {
        ["Chart.yaml"] = "yaml",
        ["Chart.lock"] = "yaml",
      }
    })
  end,
}
