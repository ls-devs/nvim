-- ── xmake ────────────────────────────────────────────────────────────────
-- Purpose : XMake build system integration for C/C++ and CMake projects
-- Trigger : ft = c / cpp / cmake
-- Note    : Only activated when xmake.lua or CMakeLists.txt exists in the project root
-- ─────────────────────────────────────────────────────────────────────────
return {
	"Mythos-404/xmake.nvim",
	ft = { "c", "cpp", "cmake" },
	-- Skip loading entirely if neither supported build file is present in the project root.
	cond = function()
		return vim.fn.filereadable("xmake.lua") == 1 or vim.fn.filereadable("CMakeLists.txt") == 1
	end,
	config = true,
}
