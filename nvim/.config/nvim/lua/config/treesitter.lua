local tsc_ok, tsc = pcall(require, "nvim-treesitter.configs")

if not tsc_ok then
  return
end

tsc.setup({
	ensure_installed = {"comment", "lua", "markdown", "markdown_inline"},
	sync_install = false,
	auto_install = true,
})
