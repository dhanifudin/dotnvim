-- runner.lua
-- Task runner (Dispatch, Npm, Composer) backed by snacks.terminal
-- Interactive shell toggle also delegates to snacks.terminal

local M = {}

-- ─── Task Win Config ──────────────────────────────────────────────────────────

local task_win = {
  position = "bottom",
  height = 0.3,
}

-- ─── Core Task Runner ─────────────────────────────────────────────────────────

local function run(cmd, opts)
  opts = opts or {}

  local term = Snacks.terminal.open(cmd, {
    cwd = opts.cwd,
    start_insert = opts.focus or false,
    auto_insert = false,
    auto_close = false,
    win = task_win,
  })

  if term and term.buf then
    local label = type(cmd) == "table" and cmd[#cmd] or cmd
    vim.api.nvim_create_autocmd("TermClose", {
      buffer = term.buf,
      once = true,
      callback = function()
        local code = vim.v.event.status
        vim.schedule(function()
          if code == 0 then
            term:close()
            vim.notify("✓ '" .. label .. "' completed", vim.log.levels.INFO)
          else
            vim.notify("✗ '" .. label .. "' failed (exit " .. code .. ")", vim.log.levels.ERROR)
          end
        end)
      end,
    })
  end

  if not opts.focus then
    vim.cmd("wincmd p")
  end
end

-- ─── Project Root Detection ────────────────────────────────────────────────────

local function find_project_root(marker)
  local from = vim.fn.expand("%:p:h")
  local found = vim.fn.findfile(marker, from .. ";")
  if found == "" then
    found = vim.fn.findfile(marker, vim.fn.getcwd() .. ";")
  end
  if found ~= "" then
    return vim.fn.fnamemodify(found, ":p:h")
  end
end

local function run_in_root(cmd, marker, label)
  local root = find_project_root(marker)
  if not root then
    vim.notify(label .. ": " .. marker .. " not found", vim.log.levels.ERROR)
    return
  end
  run({ vim.o.shell, vim.o.shellcmdflag, cmd }, { cwd = root })
end

-- ─── Commands ─────────────────────────────────────────────────────────────────

vim.api.nvim_create_user_command("Dispatch", function(o)
  if o.args == "" then
    vim.notify("Dispatch: No command provided", vim.log.levels.ERROR)
    return
  end
  run({ vim.o.shell, vim.o.shellcmdflag, o.args })
end, { nargs = "+", complete = "shellcmd", desc = "Run command in terminal" })

vim.api.nvim_create_user_command("DispatchFocus", function(o)
  if o.args == "" then
    vim.notify("Dispatch: No command provided", vim.log.levels.ERROR)
    return
  end
  run({ vim.o.shell, vim.o.shellcmdflag, o.args }, { focus = true })
end, { nargs = "+", complete = "shellcmd", desc = "Run command in terminal (focused)" })

-- Npm
local npm_completions = {
  "install", "run", "test", "start", "build", "dev",
  "lint", "format", "update", "uninstall", "init", "publish",
}

vim.api.nvim_create_user_command("Npm", function(o)
  if o.args == "" then
    vim.notify("Npm: No arguments provided", vim.log.levels.ERROR)
    return
  end
  run_in_root("npm " .. o.args, "package.json", "Npm")
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line)
    if #vim.split(cmd_line, "%s+") <= 2 then
      return vim.tbl_filter(function(c) return c:find(arg_lead, 1, true) == 1 end, npm_completions)
    end
  end,
  desc = "Run npm command from project root",
})

-- Composer
local composer_completions = {
  "install", "require", "update", "remove", "dump-autoload",
  "init", "test", "run", "validate", "status", "create-project",
}

vim.api.nvim_create_user_command("Composer", function(o)
  if o.args == "" then
    vim.notify("Composer: No arguments provided", vim.log.levels.ERROR)
    return
  end
  run_in_root("composer " .. o.args, "composer.json", "Composer")
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line)
    if #vim.split(cmd_line, "%s+") <= 2 then
      return vim.tbl_filter(function(c) return c:find(arg_lead, 1, true) == 1 end, composer_completions)
    end
  end,
  desc = "Run composer command from project root",
})

-- Java (single-file source launch, Java 11+)
vim.api.nvim_create_user_command("JavaRun", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("JavaRun: no file in current buffer", vim.log.levels.ERROR)
    return
  end
  run({ vim.o.shell, vim.o.shellcmdflag, "java " .. vim.fn.shellescape(file) }, { focus = true })
end, { desc = "Run current Java file" })

-- Maven
local maven_completions = {
  "compile", "test", "package", "clean", "install",
  "exec:java", "dependency:tree", "archetype:generate",
  "test-compile", "verify",
}

vim.api.nvim_create_user_command("Maven", function(o)
  if o.args == "" then
    vim.notify("Maven: No arguments provided", vim.log.levels.ERROR)
    return
  end
  run_in_root("mvn " .. o.args, "pom.xml", "Maven")
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line)
    if #vim.split(cmd_line, "%s+") <= 2 then
      return vim.tbl_filter(function(c) return c:find(arg_lead, 1, true) == 1 end, maven_completions)
    end
  end,
  desc = "Run Maven goal from project root",
})

-- Interactive new Maven project scaffold
vim.api.nvim_create_user_command("MavenNew", function()
  vim.ui.input({ prompt = "Group ID (default: com.example): " }, function(group_id)
    if group_id == nil then return end
    group_id = (group_id == "" and "com.example" or group_id)

    vim.ui.input({ prompt = "Artifact ID (project name): " }, function(artifact_id)
      if artifact_id == nil or artifact_id == "" then
        vim.notify("MavenNew: artifact ID is required", vim.log.levels.ERROR)
        return
      end

      vim.ui.input({ prompt = "Archetype (default: maven-archetype-quickstart): " }, function(archetype)
        if archetype == nil then return end
        archetype = (archetype == "" and "maven-archetype-quickstart" or archetype)

        local cmd = string.format(
          "mvn archetype:generate -DgroupId=%s -DartifactId=%s -DarchetypeArtifactId=%s -DinteractiveMode=false",
          vim.fn.shellescape(group_id),
          vim.fn.shellescape(artifact_id),
          vim.fn.shellescape(archetype)
        )
        run({ vim.o.shell, vim.o.shellcmdflag, cmd }, { focus = true })
      end)
    end)
  end)
end, { desc = "Scaffold a new Maven project interactively" })

-- ─── Keymaps ──────────────────────────────────────────────────────────────────

-- Dispatch
vim.keymap.set("n", "<leader>rd", function()
  vim.ui.input({ prompt = "Dispatch: " }, function(input)
    if input then run({ vim.o.shell, vim.o.shellcmdflag, input }) end
  end)
end, { desc = "Run dispatch command" })

vim.keymap.set("n", "<leader>rf", function()
  vim.ui.input({ prompt = "Dispatch (focus): " }, function(input)
    if input then run({ vim.o.shell, vim.o.shellcmdflag, input }, { focus = true }) end
  end)
end, { desc = "Run dispatch command (focus)" })

-- Npm
vim.keymap.set("n", "<leader>rn", function()
  vim.ui.input({ prompt = "Npm: " }, function(input)
    if input then vim.cmd("Npm " .. input) end
  end)
end, { desc = "Run npm command" })

vim.keymap.set("n", "<leader>rni", "<cmd>Npm install<cr>",      { desc = "Npm install" })
vim.keymap.set("n", "<leader>rns", "<cmd>Npm start<cr>",        { desc = "Npm start" })
vim.keymap.set("n", "<leader>rnt", "<cmd>Npm test<cr>",         { desc = "Npm test" })
vim.keymap.set("n", "<leader>rnb", "<cmd>Npm run build<cr>",    { desc = "Npm build" })
vim.keymap.set("n", "<leader>rnd", "<cmd>Npm run dev<cr>",      { desc = "Npm dev" })
vim.keymap.set("n", "<leader>rnl", "<cmd>Npm run lint<cr>",     { desc = "Npm lint" })

-- Composer
vim.keymap.set("n", "<leader>rc", function()
  vim.ui.input({ prompt = "Composer: " }, function(input)
    if input then vim.cmd("Composer " .. input) end
  end)
end, { desc = "Run composer command" })

vim.keymap.set("n", "<leader>rci", "<cmd>Composer install<cr>",       { desc = "Composer install" })
vim.keymap.set("n", "<leader>rcu", "<cmd>Composer update<cr>",        { desc = "Composer update" })
vim.keymap.set("n", "<leader>rct", "<cmd>Composer test<cr>",          { desc = "Composer test" })
vim.keymap.set("n", "<leader>rcd", "<cmd>Composer dump-autoload<cr>", { desc = "Composer dump-autoload" })

-- Java
vim.keymap.set("n", "<leader>rj", "<cmd>JavaRun<cr>", { desc = "Run current Java file" })

-- Maven
vim.keymap.set("n", "<leader>rm", function()
  vim.ui.input({ prompt = "Maven: " }, function(input)
    if input then vim.cmd("Maven " .. input) end
  end)
end, { desc = "Run Maven goal" })

vim.keymap.set("n", "<leader>rmn", "<cmd>MavenNew<cr>",        { desc = "Maven new project" })
vim.keymap.set("n", "<leader>rmc", "<cmd>Maven compile<cr>",   { desc = "Maven compile" })
vim.keymap.set("n", "<leader>rmt", "<cmd>Maven test<cr>",      { desc = "Maven test" })
vim.keymap.set("n", "<leader>rmp", "<cmd>Maven package<cr>",   { desc = "Maven package" })
vim.keymap.set("n", "<leader>rmi", "<cmd>Maven install<cr>",   { desc = "Maven install" })

return M
