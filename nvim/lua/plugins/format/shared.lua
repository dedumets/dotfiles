-- Formatter configuration shared across all of my devices.
--
-- For the most part, I only expect Lua to be required, as it's needed to
-- configure Neovim, but, if a pattern of using certain LSPs on all devices
-- emerges, this would be the place to abstract all of them into.
return {
	lua = { "stylua" },
}
