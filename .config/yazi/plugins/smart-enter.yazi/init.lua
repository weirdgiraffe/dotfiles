-- plugin to enter directory or open file on l
-- https://yazi-rs.github.io/docs/faq/#why-cant-open-and-enter-be-a-single-command
-- https://yazi-rs.github.io/docs/tips/#smart-enter-enter-for-directory-open-for-file
return {
  entry = function()
    local h = cx.active.current.hovered
    ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
  end,
}
